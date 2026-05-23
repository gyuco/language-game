# EPIC 03 — 10 Sfida

**Priorità:** P0
**Epic:** Modalità "10 Sfida"
**Storie:** US-08 (Giocare a "10 Sfida"), US-09 (Timer visivo), US-10 (Moltiplicatore streak)

---

## US-08 — Giocare a "10 Sfida"

**Priorità:** P0 | **Da giocatore**, voglio giocare alla modalità "10 Sfida".

### Tasks Tecniche

1. **[Provider Quiz — TenChallenge]** — State management per la 10 Sfida
   - File: `lib/providers/quiz/ten_challenge_provider.dart`
   - Dipende da: EPIC-02 US-05 Tasks 1-4 (Word/GameSession models, repositories)
   - Dettaglio: `StateNotifierProvider<TenChallengeNotifier, TenChallengeState>`. Stato: lista parole (10), indice corrente, streak corrente, punteggio totale, timer, stato (playing/gameOver). Metodi: `startGame()`, `submitAnswer(String)`, `timeOut()`, `endGame()`. Alla fine calcola riepilogo.

2. **[Schermata Gioco — 10 Sfida]** — UI della 10 Sfida
   - File: `lib/features/quiz/ten_challenge/game_screen.dart`
   - Dipende da: Task 1, EPIC-02 US-05 Task 6 (componenti condivisi)
   - Dettaglio: Layout con barra progresso (10 pallini), timer circolare, parola centrale, input risposta, streak badge. Stati: attesa risposta, feedback corretto/sbagliato, timeout. Animazioni: parola slide-up, feedback con colore.

3. **[Selezione Parole Random]** — Logica per selezionare 10 parole in lingue diverse
   - File: `lib/services/word_selector.dart`
   - Dipende da: EPIC-02 US-05 Task 3 (WordRepository)
   - Dettaglio: Seleziona 10 parole da Appwrite/Isar. Ciascuna parola è in una lingua diversa e casuale. Evita ripetizioni di parola e di lingua nella stessa sessione. Gestisce il caso in cui non ci siano abbastanza lingue nel dataset.

4. **[Barra Progresso]** — Widget per mostrare il progresso delle 10 parole
   - File: `lib/features/quiz/shared/progress_bar.dart`
   - Dipende da: —
   - Dettaglio: 10 pallini orizzontali. Stati: completato (verde), corrente (indaco + glow), futuro (grigio), errore (rosso). Diametro 10px, gap 6px. Animazione quando si passa alla parola successiva.

### Casi di Test

- **Test Unitario:** `TenChallengeNotifier.startGame()` — 10 parole caricate, indice 0, streak 0, punteggio 0.
- **Test Unitario:** `TenChallengeNotifier.submitAnswer()` — risposta corretta: streak +1, punteggio aggiornato. Risposta sbagliata: streak reset.
- **Test Unitario:** `WordSelector.selectRandomWords(10)` — restituisce 10 parole di lingue diverse, nessun duplicato.
- **Widget Test:** `GameScreen` (10 Sfida) — mockare provider, verificare progress bar, timer, parola, input visibili.
- **Integration Test:** Flusso completo: avvia 10 Sfida → rispondi correttamente 5 volte → sbaglia 1 → rispondi 4 → riepilogo con punteggio e streak massima.
- **Test Case 1:** 10 risposte corrette consecutive → punteggio 55pt (massimo teorico).
- **Test Case 2:** 5 corrette → sbaglia → 5 corrette → streak massima = 5, punteggio = (1+2+3+4+5)+0+(1+2+3+4+5) = 30pt.

### Note Architetturali

- La selezione delle parole deve garantire varietà di lingua. Se il dataset ha poche lingue, si possono ripetere lingue ma non parole.
- Il timer è gestito dal provider (non dal widget) per correttezza anche se lo schermo viene ricostruito.
- `TenChallengeState` include `remainingTime` (int secondi), aggiornato da un Timer.periodic nel notifier.

---

## US-09 — Timer visivo

**Priorità:** P0 | **Da giocatore**, voglio vedere il countdown di 10 secondi.

### Tasks Tecniche

1. **[Widget Timer Circolare]** — Timer circolare animato
   - File: `lib/features/quiz/shared/circular_timer.dart`
   - Dipende da: —
   - Dettaglio: Widget CustomPainter per cerchio con bordo animato (stroke circolare progressivo). Diametro 48px. Parametri: `duration` (10s), `remainingSeconds`, `isRunning`. Colore cambia: indaco (normale), ambra (< 3s, pulse), rosso (< 1s, pulse rapido). Testo centrale con secondi rimanenti (Inter Semibold).

2. **[Logica Timer in Provider]** — Gestione timer nel TenChallengeProvider
   - File: `lib/providers/quiz/ten_challenge_provider.dart`
   - Dipende da: US-08 Task 1
   - Dettaglio: All'inizio del turno, avvia Timer.periodic (1s). Decrementa `remainingTime`. A 0 secondi, chiama `timeOut()`. Pulisce timer su dispose. Gestisce pausa app in background.

3. **[Animazioni Timer]** — Pulse animation quando il tempo sta finendo
   - File: `lib/features/quiz/shared/timer_pulse_animation.dart`
   - Dipende da: Task 1
   - Dettaglio: Widget wrapper che applica scale animation (1.0↔1.05) quando remaining < 3s. Durata 300ms, curva linear. Colore bordo cambia con transition.

### Casi di Test

- **Widget Test:** `CircularTimer` — mockare remaining=7 → stroke a 30%, colore indaco. remaining=2 → stroke a 80%, colore ambra.
- **Widget Test:** `CircularTimer` — remaining=0 → stroke completo, colore rosso, pulse attivo.
- **Test Unitario:** Provider timer — tick decrementa remaining, a 0 chiama timeOut(), passa alla prossima parola.
- **Test Case 1:** Utente risponde prima dello scadere → timer si ferma → feedback risposta.
- **Test Case 2:** Timer arriva a 0 → timeout → parola successiva, streak resetta.

### Note Architetturali

- Usare `CustomPainter` per l'animazione circolare del timer — più performante di stack di container.
- Il timer deve sopravvivere a ricostruzioni del widget (gestito dal provider).
- In background, il timer può andare in pausa (AppLifecycleListener). Alla ripresa, ricalcolare remaining time basato sul timestamp reale.

---

## US-10 — Moltiplicatore streak

**Priorità:** P0 | **Da giocatore**, voglio che le risposte consecutive aumentino il punteggio.

### Tasks Tecniche

1. **[Logica Streak in Provider]** — Calcolo e tracciamento streak
   - File: `lib/providers/quiz/ten_challenge_provider.dart` (integrazione)
   - Dipende da: US-08 Task 1, EPIC-02 US-07 Task 1 (ScoreCalculator)
   - Dettaglio: Streak inizia a 0. Ogni risposta corretta: streak++. Punteggio = `ScoreCalculator.calculateStreakScore(streak)` (1pt per 1°, 2pt per 2°, ecc.). Ogni errore/timeout: streak = 0. `maxStreak` track separato.

2. **[UI Streak Badge]** — Visualizzazione streak corrente
   - File: `lib/features/quiz/shared/streak_badge.dart`
   - Dipende da: Task 1
   - Dettaglio: Badge con icona 🔥 e numero streak. Visualizzato in alto durante la partita. Colore: ambra quando streak > 0, grigio quando 0. Animazione count-up (digit counter) quando streak aumenta. Animazione shake/reset quando streak si resetta.

3. **[Animazione Streak Count-up]** — Animazione del numero che scorre
   - File: `lib/features/quiz/shared/streak_animation.dart`
   - Dipende da: Task 2
   - Dettaglio: Usare `TweenAnimationBuilder` per animare il numero da vecchio valore a nuovo valore. Durata 600ms, curva `easeOutBack` (leggero overshoot). Effetto rimbalzo quando streak aumenta.

### Casi di Test

- **Test Unitario:** ScoreCalculator.calculateStreakScore(1) → 1, (3) → 3, (10) → 10.
- **Widget Test:** `StreakBadge` — streak=3 → mostra "🔥 3", colore ambra. streak=0 → mostra "🔥 0", colore grigio.
- **Integration Test:** 3 risposte corrette consecutive → streak=3 → punteggio totale 1+2+3=6pt.
- **Test Case 1:** Streak 5 → risposta corretta → streak 6, punteggio +6.
- **Test Case 2:** Streak 8 → risposta sbagliata → streak 0, animazione reset, streak massima = 8 salvata.

### Note Architetturali

- Lo streak è reset su errore o timeout, non su skip esplicito (se implementato).
- `maxStreak` è salvato in `GameSession` e sul profilo utente (record personale).
- Per la modalità Infinity (US-11), lo stesso meccanismo si applica ma senza limite di 10.
