# TECHNICAL.md — Language Game

> Documento tecnico: architettura, stack, strutture dati e decisioni implementative.

---

## 1. Stack Tecnologico

| Livello | Tecnologia |
|---|---|
| **Mobile** | Flutter (Dart) |
| **Backend** | Appwrite (BaaS) |
| **Database** | Appwrite Database (NoSQL) |
| **Auth** | Appwrite Auth |
| **Storage (audio)** | Appwrite Storage |
| **Push Notifications** | Appwrite Messaging |
| **Cloud Functions** | Appwrite Functions (Node.js / Dart) |
| **State Management** | Riverpod |
| **Local Storage (offline)** | Isar / Hive |
| **Audio Playback** | audioplayers / just_audio |

---

## 2. Architettura

```
┌──────────────────┐     ┌────────────────────┐
│   Flutter App    │◄───►│    Appwrite        │
│                  │     │                    │
│  ┌────────────┐  │     │  ┌──────────────┐  │
│  │ UI (Widget) │  │     │  │ Auth         │  │
│  ├────────────┤  │     │  ├──────────────┤  │
│  │ Providers   │  │     │  │ Database     │  │
│  │ (Riverpod)  │  │     │  │ (Parole,     │  │
│  ├────────────┤  │     │  │  Utenti,     │  │
│  │ Repository  │──┤     │  │  Partite)    │  │
│  │ Layer       │  │     │  ├──────────────┤  │
│  ├────────────┤  │     │  │ Storage      │  │
│  │ Local Cache │  │     │  │ (Audio)      │  │
│  │ (Isar)     │  │     │  ├──────────────┤  │
│  └────────────┘  │     │  │ Functions    │  │
│                  │     │  │ (Daily, etc) │  │
└──────────────────┘     │  ├──────────────┤  │
                         │  │ Messaging    │  │
                         │  │ (Push Notif) │  │
                         │  └──────────────┘  │
                         └────────────────────┘
```

### Flutter — Strati dell'app

```
lib/
├── app/              # Configurazione app, router, tema
├── auth/             # Login, registrazione, anonimo
├── features/
│   ├── home/         # Schermata principale
│   ├── quiz/         # Logica e UI del quiz
│   │   ├── guess_the_word/
│   │   └── ten_challenge/
│   ├── daily/        # Sfida Daily
│   ├── profile/      # Profilo utente, statistiche
│   ├── leaderboard/  # Classifiche
│   └── settings/     # Impostazioni (lingua, audio toggle, etc.)
├── models/           # Modelli dati (Word, User, GameSession, etc.)
├── repositories/     # Strati di accesso dati (remote + local)
├── providers/        # Riverpod providers
├── services/         # Appwrite SDK wrappers
├── utils/            # Helper, costanti, extensions
└── main.dart
```

---

## 3. Struttura Dati (Appwrite Database)

### Collezione `words` — Parole del gioco

| Campo | Tipo | Note |
|---|---|---|
| `id` | string | Appwrite auto-ID |
| `text` | string | La parola nella lingua originale |
| `translation` | string | Traduzione nella lingua target (es. italiano) |
| `language` | string | Codice lingua (es. `de`, `ja`, `ar`) |
| `languageName` | string | Nome leggibile (es. "Tedesco") |
| `category` | string? | Categoria opzionale (es. "cibo", "animali") |
| `difficulty` | int | 1 (facile) — 3 (difficile) |
| `audioFileId` | string? | Riferimento al file audio in Appwrite Storage |
| `createdAt` | datetime | |

**Indici:** `language`, `category`, `difficulty`, `language + difficulty`

---

### Collezione `users` (gestita da Appwrite Auth + profilo custom)

| Campo | Tipo | Note |
|---|---|---|
| `userId` | string | Matcha l'ID di Appwrite Auth |
| `displayName` | string | Nome visibile |
| `totalScore` | int | Punteggio totale accumulato |
| `dailyStreak` | int | Giorni consecutivi di gioco |
| `lastPlayedAt` | datetime | Ultima partita |
| `statsByLanguage` | map | `{ "de": { "correct": 10, "total": 15 }, ... }` |
| `preferredLanguage` | string | Lingua madre dell'utente per le traduzioni |
| `audioMode` | boolean | Preferenza audio (default: false) |
| `createdAt` | datetime | |

---

### Collezione `game_sessions` — Storico partite

| Campo | Tipo | Note |
|---|---|---|
| `id` | string | Auto-ID |
| `userId` | string | Riferimento all'utente |
| `mode` | string | `guess_the_word` / `ten_challenge` / `daily` |
| `audioMode` | boolean | Se era in modalità audio |
| `wordsPlayed` | array | Lista di ID parole giocate |
| `score` | int | Punteggio ottenuto |
| `maxStreak` | int | Streak massima raggiunta |
| `correctCount` | int | Parole indovinate |
| `totalCount` | int | Parole totali |
| `playedAt` | datetime | |

---

### Collezione `daily_challenges` — Sfida Daily

| Campo | Tipo | Note |
|---|---|---|
| `id` | string | Auto-ID |
| `date` | date | Data della sfida (YYYY-MM-DD) |
| `wordIds` | array | 5 ID parole per la sfida |
| `isActive` | boolean | Se la sfida è ancora giocabile |

---

## 4. Flusso di gioco — Dettaglio implementativo

### 4.1 Indovina la Parola

```
1. FE richiede una parola casuale → BE (o cache locale) restituisce parola + N lingue correlate
2. FE mostra la parola in lingua #1
3. Utente invia risposta
4. FE verifica: match esatto (case-insensitive, trimming)
5. Se sbagliato → mostra parola in lingua #2 (stesso significato)
6. Continua fino a indovinare o 7-8 tentativi
7. Calcolo punteggio in base ai tentativi
8. Salvataggio sessione su Appwrite
```

**Ottimizzazione offline:**
- Le parole vengono precaricate in cache locale (Isar)
- Le partite giocate offline vengono accodate e sincronizzate quando si torna online

### 4.2 10 Sfida

```
1. FE richiede 10 parole casuali (lingue random)
2. Timer di 10 secondi parte per ogni parola
3. Risposta corretta → streak +1, punti accumulati
4. Risposta errata / timeout → streak resetta, prossima parola
5. Dopo 10 parole → riepilogo + salvataggio
```

---

## 5. Audio

- I file audio sono ospitati su **Appwrite Storage**
- Ad ogni parola può essere associato un file audio (pronuncia)
- La riproduzione usa `audioplayers` o `just_audio`
- Il toggle "Modalità Audio" in impostazioni cambia il comportamento:
  - **On**: la parola viene pronunciata invece di essere mostrata (o in aggiunta)
  - **Off**: solo testo scritto
- All'aggiunta di una nuova parola, l'audio può essere:
  - Caricato manualmente
  - Generato via TTS (valutare integrazione futura con Google Cloud TTS / ElevenLabs)

---

## 6. Autenticazione

- **Accesso anonimo** (Appwrite `createAnonymousSession`) — si può giocare subito senza registrazione
- **Registrazione opzionale** (email + password) per:
  - Sincronizzare progressi tra dispositivi
  - Partecipare alle classifiche globali
  - Salvare lo storico
- **Social login** (Google, Apple) — valutare in v2

---

## 7. Sincronizzazione offline

1. Le parole vengono precaricate in cache locale (Isar) all'avvio
2. Le partite giocate offline vengono salvate in una coda locale
3. Al ritorno della connessione → sync automatico su Appwrite
4. Gestione conflitti: l'ultima scrittura vince (last-write-wins)

---

## 8. Push Notifications

- **Sfida Daily pronta!** — ogni giorno alle 9:00
- **Streak a rischio** — notifica serale se non si è giocato oggi
- **Nuove lingue disponibili** — quando il dataset si arricchisce

---

## 9. Appwrite Cloud Functions — Casi d'uso

| Funzione | Trigger | Cosa fa |
|---|---|---|
| `generateDailyChallenge` | Cron (ogni giorno a mezzanotte) | Seleziona 5 parole casuali, crea documento in `daily_challenges` |
| `updateLeaderboard` | Dopo salvataggio partita | Aggiorna classifica globale |
| `notifyDailyChallenge` | Cron (9:00) | Invia push per Sfida Daily |
| `notifyStreakReminder` | Cron (20:00) | Invia reminder a chi non ha giocato oggi |

---

## 10. Considerazioni su scalabilità e costi

**Appwrite Cloud** (o self-hosted per risparmiare):
- Database: le collezioni previste sono piccole (migliaia di parole, centinaia di utenti in v1)
- Storage: gli audio occupano spazio ( ~10-50 KB per file). 1000 parole = ~10-50 MB
- Funzioni: esecuzioni giornaliere, costo trascurabile
- Piano gratuito Appwrite Cloud è sufficiente per MVP

**Prossimi passi oltre il MVP:**
- Meilisearch / Typesense per ricerca full-text sul dataset
- CDN per distribuzione audio (se il traffico cresce)
- Backend custom se Appwrite diventa un collo di bottiglia

---

## 11. Ambienti

| Ambiente | Scopo |
|---|---|
| **Development** | Locale (emulatore Appwrite + Flutter) |
| **Staging** | Appwrite Cloud (progetto staging) |
| **Production** | Appwrite Cloud (progetto production) |

---

## 12. Roadmap tecnica (suggerita)

### v0.1 — MVP
- [ ] Setup Flutter + Appwrite
- [ ] Auth anonima
- [ ] Database parole (manuale, 50-100 parole iniziali)
- [ ] Modalità "Indovina la Parola" (scritta)
- [ ] Modalità "10 Sfida" (scritta)
- [ ] Cache offline (Isar)

### v0.2 — Audio
- [ ] Appwrite Storage per audio
- [ ] Modalità audio per entrambe le modalità
- [ ] Toggle impostazioni scritta/audio

### v0.3 — Daily & Social
- [ ] Sfida Daily (Cloud Function)
- [ ] Classifiche globali
- [ ] Profilo utente e statistiche

### v0.4 — Engagement
- [ ] Push notifications
- [ ] Streak giornaliero e badge
- [ ] Condivisione risultati
