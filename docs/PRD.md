# PRD — Language Game

> **Visione**: Un'app mobile dove le persone imparano e si sfidano a indovinare parole in tutte le lingue del mondo, in modo divertente e progressivo.

---

## 1. Panoramica

Language Game è un quiz multilingua con due modalità principali (scritta e audio). Il dataset di parole viene costruito progressivamente. L'app è mobile con backend.

---

## 2. Modalità di gioco

### 2.1 Indovina la Parola

Una singola parola da indovinare, con indizi progressivi in lingue diverse.

**Meccanica:**
- Viene mostrata una parola in una lingua straniera (scritta o pronunciata)
- L'utente deve indovinare il significato nella propria lingua
- Ogni risposta sbagliata svela la stessa parola in un'altra lingua come indizio
- Le lingue vengono rivelate una alla volta fino a un massimo di 7-8

**Punteggio (decrescente):**
| Lingue viste | Punti |
|---|---|
| 1 (indovinato subito) | 5 |
| 2 | 4 |
| 3 | 3 |
| 4-5 | 2 |
| 6+ | 1 |
| Nessuna (svelata) | 0 |

**Variante "Inversa":** la parola viene mostrata nella lingua dell'utente, che deve scriverla in una lingua straniera casuale.

---

### 2.2 10 Sfida

10 parole in sequenza, più ne indovini consecutivamente più punti fai.

**Meccanica:**
- 10 parole una dopo l'altra, ciascuna in una lingua diversa e casuale
- 10 secondi per rispondere
- Se sbagli o scade il tempo → si passa alla parola successiva
- **Nessuna penalità** per gli errori, ma il moltiplicatore si resetta

**Punteggio a scaletta (moltiplicatore streak):**
| Corrette consecutive | Punti |
|---|---|
| 1ª | 1 |
| 2ª | 2 |
| 3ª | 3 |
| ... | ... |
| 10ª | 10 |

- Una risposta sbagliata resetta il moltiplicatore a 1, ma il gioco continua
- **Punteggio massimo teorico**: 1+2+...+10 = 55 punti
- A fine partita: riepilogo, statistiche e classifica

**Variante "Infinity":** stesso meccanismo, ma senza limite di parole. Si va avanti finché non si sbaglia. Il punteggio è la lunghezza della streak.

---

## 3. Modalità audio

Ogni modalità di gioco supporta due formati:

- **📝 Scritta** — la parola è mostrata visivamente (testo)
- **🎧 Audio** — la parola è pronunciata (senza mostrare il testo)

L'utente può scegliere la modalità all'inizio di ogni partita o nelle impostazioni.

La modalità audio è particolarmente utile per:
- Lingue con alfabeti non latini (arabo, cinese, giapponese, russo, coreano, ecc.)
- Allenare il riconoscimento all'ascolto
- Aumentare la difficoltà per utenti esperti

---

## 4. Modalità secondarie (future / extra)

### 4.1 Sfida Daily
- 5 parole uguali per tutti gli utenti ogni giorno
- Classifica globale giornaliera
- Promuove il ritorno quotidiano sull'app

### 4.2 Vero o Falso?
- Veloce, stile trivia
- Viene mostrata una parola con una traduzione proposta
- L'utente deve dire se è giusta o sbagliata
- Nessun input testuale, solo tap: massima velocità

---

## 5. Profilo utente e progressione

- **Punteggio totale** accumulato in tutte le modalità
- **Statistiche per lingua** — quante parole conosci in每 lingua
- **Streak giornaliero** — quanti giorni consecutivi hai giocato
- **Badge e risultati** per obiettivi (es. "10 lingue diverse", "100 parole indovinate", "Streak di 7 giorni")
- **Cronologia partite** — riepilogo delle sessioni passate

---

## 6. Dataset (costruzione progressiva)

- Le parole vengono aggiunte **manualmente o da fonti curate** inizialmente
- Il dataset cresce nel tempo con nuove lingue e nuovi vocaboli
- Ogni parola ha: **traduzione**, **lingua**, **categoria** (facoltativa), **audio** (facoltativo, aggiungibile dopo)
- Possibilità futura: contributi dalla community con moderazione

---

## 7. Requisiti funzionali generali

- **Autenticazione** (anonima o via account — email/Social)
- **Backend** per sincronizzare dati tra dispositivi
- **Classifiche** globali e tra amici
- **Notifiche** per la Sfida Daily e reminder per lo streak giornaliero
- **Lingua dell'interfaccia configurabile** (traduzione dell'app)
- **Supporto offline** per le partite (sync quando si torna online)
- **Onboarding** tutorial rapido alla prima apertura

---

## 8. User flow tipico

1. Apertura app → schermata home
2. Scelta: Nuova partita / Sfida Daily / Classifiche / Statistiche
3. Selezione modalità (Indovina la Parola o 10 Sfida)
4. Selezione formato (Scritta o Audio)
5. Partita
6. Fine partita → riepilogo punteggio + statistiche
7. Opzioni: rigioca, condividi, vedi classifica

---

## 9. Non obiettivi (fuori scope v1)

- Supporto multiplayer in tempo reale (valutare in futuro)
- Creazione di parole da parte degli utenti (v1 solo dataset curato)
- Web app / desktop (solo mobile)
- Traduzioni automatiche (parole verificate manualmente)
