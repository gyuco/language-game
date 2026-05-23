# EPIC 04 — Infinity

**Priorità:** P2
**Epic:** Modalità Infinity
**Storie:** US-11 (Modalità Infinity)

---

## US-11 — Modalità Infinity

**Priorità:** P2 | **Da giocatore esperto**, voglio una modalità senza limite di parole.

### Tasks Tecniche

1. **[Provider Quiz — Infinity]** — State management per Infinity mode
   - File: `lib/providers/quiz/infinity_provider.dart`
   - Dipende da: EPIC-03 US-08 Task 1 (TenChallengeProvider base), EPIC-02 US-07 Task 1 (ScoreCalculator)
   - Dettaglio: Estendere `TenChallengeNotifier` o creare provider separato. Differenze: nessun limite di parole (non si ferma a 10), punteggio = streak (1pt per parola), gioco termina solo su errore o uscita esplicita. Metodi: `startGame()`, `submitAnswer(String)`, `quitGame()`.

2. **[Schermata Gioco — Infinity]** — UI condivisa con 10 Sfida ma adattata
   - File: `lib/features/quiz/infinity/game_screen.dart`
   - Dipende da: Task 1, EPIC-03 US-08 Task 4 (ProgressBar) ma adattata
   - Dettaglio: Stessa UI di 10 Sfida ma senza progress bar fissa (o mostra conteggio parole correnti invece di "3/10"). Timer circolare identico. Streak badge. Pulsante "Esci" per terminare la partita volontariamente.

3. **[Schermata Riepilogo Infinity]** — Riepilogo adattato per Infinity
   - File: `lib/features/quiz/infinity/summary_screen.dart`
   - Dipende da: Task 2
   - Dettaglio: Mostra streak totale (punteggio), parole corrette, lingue incontrate, confronto con record personale. "New record!" se superato. Pulsanti: "Rigioca", "Home", "Condividi".

4. **[Record Personale Infinity]** — Tracking del miglior risultato
   - File: `lib/providers/quiz/infinity_provider.dart`
   - Dipende da: Task 1
   - Dettaglio: Caricare/salvare il record personale (best streak) dal profilo utente. Mostrare "Record: N" durante la partita. Se superato, salvarlo a fine partita.

### Casi di Test

- **Test Unitario:** `InfinityNotifier.submitAnswer()` — risposta corretta incrementa streak, sbagliata termina gioco.
- **Test Unitario:** `InfinityNotifier.quitGame()` — termina partita volontariamente, punteggio = streak corrente.
- **Widget Test:** `GameScreen` (Infinity) — verificare assenza progress bar 10-pallini, presenza contatore parole.
- **Integration Test:** Gioca Infinity → 5 corrette → esci → riepilogo mostra streak=5 → record personale < 5 → "New record!".
- **Test Case 1:** Giocatore fa 15 risposte corrette consecutive → streak=15, partita ancora in corso.
- **Test Case 2:** Streak=12 → sbaglia → gioco termina → punteggio=12.

### Note Architetturali

- Condividere quanto più codice possibile con 10 Sfida: stesso timer, stesso input, stesso sistema di punteggio. Differenza solo nel criterio di terminazione.
- Il record personale è salvato nel campo `infinityBestStreak` della collezione `users`.
- Valutare l'uso di un parametro `maxWords` nel provider di 10 Sfida per generalizzare (null = infinity).
