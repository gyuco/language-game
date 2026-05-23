# EPIC 09 — Statistiche e Progresso

**Priorità:** P1 (US-19, US-21) / P2 (US-20)
**Epic:** Statistiche e Progresso
**Storie:** US-19 (Statistiche personali), US-20 (Badge e risultati), US-21 (Streak giornaliero)

---

## US-19 — Statistiche personali

**Priorità:** P1 | **Da giocatore**, voglio vedere le mie statistiche di gioco.

### Tasks Tecniche

1. **[Provider Statistiche]** — Provider per le statistiche utente
   - File: `lib/providers/stats/stats_provider.dart`
   - Dipende da: EPIC-02 US-05 Task 4 (GameRepository), EPIC-01 US-03 Task 3 (ProfileRepository)
   - Dettaglio: Aggrega dati da `game_sessions` e `users` per produrre statistiche: partite totali, parole indovinate, punteggio totale, streak massima, partite per modalità, andamento punteggio nel tempo.

2. **[Grafico Per Lingua]** — Statistiche per lingua (parole conosciute in每 lingua)
   - File: `lib/features/stats/charts/language_chart.dart`
   - Dipende da: Task 1
   - Dettaglio: Widget con bar chart orizzontale. Ogni barra = lingua, lunghezza proporzionale al numero di parole indovinate in quella lingua. Colori: gradiente primario. Usare `fl_chart` o `syncfusion_flutter_charts`.

3. **[Grafico Andamento Punteggio]** — Andamento punteggio nel tempo
   - File: `lib/features/stats/charts/score_timeline_chart.dart`
   - Dipende da: Task 1
   - Dettaglio: Line chart semplice. Asse X: giorni (ultimi 30). Asse Y: punteggio. Mostra trend. Colore linea: indaco. Area sotto: gradiente leggero.

4. **[Schermata Statistiche]** — UI completa delle statistiche
   - File: `lib/features/stats/stats_screen.dart`
   - Dipende da: Tasks 1-3
   - Dettaglio: ScrollView con sezioni: "Riepilogo" (card con numeri grandi), "Per modalità" (tabella), "Per lingua" (grafico), "Andamento" (grafico). Accessibile da profilo e home.

### Casi di Test

- **Test Unitario:** `StatsProvider.calculateStats()` — 10 partite mock => statistiche aggregate corrette.
- **Widget Test:** `StatsScreen` — mockare statistiche, verificare tutti i numeri e grafici renderizzati.
- **Integration Test:** Gioca 3 partite in modalità diverse → statistiche mostrano 3 partite totali, punteggi corretti, distribuzione per modalità.
- **Test Case 1:** Statistiche vuote (nessuna partita) → empty state "Nessuna partita ancora. Inizia a giocare!".
- **Test Case 2:** 5 partite in Indovina Parola + 3 in 10 Sfida → modalità card mostra 5 e 3.

### Note Architetturali

- I grafici in Flutter possono usare `fl_chart` (open source) — buona qualità e personalizzabile.
- Le statistiche sono calcolate lato client aggregando i dati delle `game_sessions` (non c'è un endpoint server-side dedicato in v1).
- Per utenti con molte partite, paginare il caricamento delle sessioni (ultime 100 e poi summary).
- Il campo `statsByLanguage` nella collezione `users` è aggiornato incrementalmente dopo ogni partita per evitare ricalcoli pesanti.

---

## US-20 — Badge e risultati

**Priorità:** P2 | **Da giocatore**, voglio sbloccare badge completando obiettivi.

### Tasks Tecniche

1. **[Modello Badge]** — Data model per badge/achievement
   - File: `lib/models/badge.dart`
   - Dipende da: —
   - Dettaglio: `Badge` con: `id`, `name`, `description`, `iconName`, `conditionType` (enum: totalGames, totalWords, streak, languages, etc.), `conditionValue` (int), `isUnlocked` (locale), `unlockedAt`.

2. **[Service Badge Checker]** — Logica per verificare e sbloccare badge
   - File: `lib/services/badge_service.dart`
   - Dipende da: Task 1, EPIC-09 US-19 Task 1 (StatsProvider)
   - Dettaglio: Dopo ogni partita, verifica tutte le condizioni dei badge. Se una condizione è soddisfatta e il badge non è ancora sbloccato, lo sblocca. Badge predefiniti: "Prima partita", "Poliglotta" (10 lingue), "Centurione" (100 parole), "Fedele" (streak 7gg), "Veloce" (10 risposte in 10 secondi).

3. **[Provider Badge]** — State management per badge
   - File: `lib/providers/stats/badge_provider.dart`
   - Dipende da: Tasks 1-2
   - Dettaglio: Carica badge sbloccati dal profilo utente (campo `badges` in `users`). Espone lista badge con stato. Dopo ogni partita, esegue badge check e notifica nuovi badge.

4. **[Schermata Badge]** — UI lista badge
   - File: `lib/features/profile/badges_screen.dart`
   - Dipende da: Task 3
   - Dettaglio: Griglia di badge. Ogni badge: icona (colorata se sbloccato, grigia se bloccato), nome, descrizione. Badge sbloccati hanno glow/bordo speciale. Sezione "Nuovo!" per badge appena sbloccati.

5. **[Animazione Sblocco Badge]** — Celebrazione quando si sblocca un badge
   - File: `lib/features/profile/widgets/badge_unlock_overlay.dart`
   - Dipende da: Task 3
   - Dettaglio: Overlay/Modal che appare a fine partita quando si sblocca un badge. Icona ruota su asse Y (flip) + glow + titolo "Nuovo badge!". Pulsante "Vedi tutti i badge". Animazione confetti.

### Casi di Test

- **Test Unitario:** `BadgeService.checkBadges(stats)` — stats con 100 parole → badge "Centurione" sbloccato.
- **Test Unitario:** `BadgeService.checkBadges(stats)` — stats con 5 lingue → badge "Poliglotta" non ancora (serve 10).
- **Widget Test:** `BadgesScreen` — mockare 3 badge sbloccati, 5 bloccati → griglia corretta con stati.
- **Integration Test:** Gioca fino a 10 lingue diverse → badge "Poliglotta" sbloccato → animazione celebrazione → badge visibile nella schermata badge.
- **Test Case 1:** Prima partita completata → badge "Prima partita" sbloccato → overlay celebrazione.
- **Test Case 2:** Tutti i badge già sbloccati → nessuna condizione nuova → nessuna notifica.

### Note Architetturali

- La lista dei badge è hardcoded nell'app, non dal server (per semplicità v1). Le condizioni sono check locali.
- I badge sbloccati sono persistiti nel campo `badges` (array di string/badgeIds) nella collezione `users` di Appwrite.
- L'animazione di sblocco usa `confetti_widget` o implementazione personalizzata con `CustomPainter`.
- I badge sono controllati alla fine di ogni partita, non in tempo reale.

---

## US-21 — Streak giornaliero

**Priorità:** P1 | **Da giocatore**, voglio essere incentivato a giocare tutti i giorni.

### Tasks Tecniche

1. **[Provider Streak]** — Provider per streak giornaliero
   - File: `lib/providers/stats/streak_provider.dart`
   - Dipende da: EPIC-01 US-03 Task 3 (ProfileRepository)
   - Dettaglio: Legge `dailyStreak` e `lastPlayedAt` dal profilo utente. All'avvio, verifica se lo streak va resettato (se lastPlayedAt < ieri). Espone streak corrente, giorni rimanenti per badge milestone (7, 30, 365).

2. **[Aggiornamento Streak]** — Logica di incremento streak
   - File: `lib/services/streak_service.dart`
   - Dipende da: Task 1
   - Dettaglio: Dopo ogni partita, chiamato per aggiornare lo streak. Se `lastPlayedAt` è `ieri` → streak++. Se è oggi → niente. Se è più vecchio → streak=1. Salva su Appwrite.

3. **[UI Streak in Home]** — Visualizzazione streak nella schermata home
   - File: `lib/features/home/widgets/streak_display.dart`
   - Dipende da: Task 1
   - Dettaglio: Card o badge con icona 🔥 + numero streak. Testo "Giorni consecutivi!" o "Gioca oggi per mantenere lo streak!". Colore ambra con glow. Animazione count-up quando streak aumenta.

4. **[Notifica Streak a Rischio]** — Reminder serale (integrazione con EPIC-13)
   - File: (vedi EPIC-13 US-29)
   - Dipende da: Task 1, EPIC-13
   - Dettaglio: Verifica se oggi l'utente ha giocato. Se no, invia push notification alle 20:00.

### Casi di Test

- **Test Unitario:** `StreakService.calculateStreak(lastPlayedDate: yesterday)` → streak incrementato.
- **Test Unitario:** `StreakService.calculateStreak(lastPlayedDate: 3daysAgo)` → streak resettato a 1.
- **Widget Test:** `StreakDisplay` — streak=7 → mostra "🔥 7", "7 giorni consecutivi!" con ambra.
- **Integration Test:** Gioca giorno 1 → streak=1 → gioca giorno 2 → streak=2 → salta 2 giorni → gioca giorno 5 → streak=1.
- **Test Case 1:** Utente gioca oggi (prima volta) → streak=1. Gioca domani → streak=2.
- **Test Case 2:** Utente non gioca per 3 giorni → prossima partita → streak=1 (resettato).

### Note Architetturali

- Lo streak usa la timezone dell'utente (o UTC forzato per semplicità). Valutare `DateTime.now().toUtc()` per consistenza.
- `lastPlayedAt` è aggiornato su Appwrite a ogni partita, non solo per la daily.
- La logica di reset confronta le date, non le ore: se oggi è 23:59 e giochi, lo streak si aggiorna. Mezz'ora dopo (domani 00:01) se giochi di nuovo, si incrementa.
- Integrare con la notifica US-29 per reminder serale.
