# EPIC 07 — Vero o Falso?

**Priorità:** P3
**Epic:** Modalità "Vero o Falso?"
**Storie:** US-16 (Giocare a "Vero o Falso?")

---

## US-16 — Giocare a "Vero o Falso?"

**Priorità:** P3 | **Da giocatore**, voglio una modalità rapida solo tap.

### Tasks Tecniche

1. **[Provider Quiz — TrueFalse]** — State management per Vero/Falso
   - File: `lib/providers/quiz/true_false_provider.dart`
   - Dipende da: EPIC-02 US-05 Tasks 1, 3 (Word model, WordRepository)
   - Dettaglio: Stato con parola corrente, traduzione proposta (corretta al 50% o sbagliata al 50%), timer (se previsto), punteggio, streak, contatore domande (10 o infinity). Metodi: `startGame()`, `submitAnswer(bool)`, `generateNextQuestion()`.

2. **[Generatore Domande Vero/Falso]** — Logica per generare coppie parola-traduzione con distrattori
   - File: `lib/services/true_false_generator.dart`
   - Dipende da: EPIC-02 US-05 Task 3 (WordRepository)
   - Dettaglio: Prende una parola casuale. Con probabilità 50%, la traduzione è corretta (Vero). Con 50%, prende una traduzione sbagliata da un'altra parola (Falso). Garantisce che il distrattore sia plausibile.

3. **[Schermata Gioco Vero/Falso]** — UI con due pulsanti grandi
   - File: `lib/features/quiz/true_false/game_screen.dart`
   - Dipende da: Task 1
   - Dettaglio: Schermata minimale: parola in alto, traduzione proposta sotto, due pulsanti grandi "✅ Vero" e "❌ Falso" (o "V" e "F"). Feedback immediato: verde + check per corretto, rosso + X per sbagliato. Prossima domanda dopo 1.5s.

4. **[Punteggio Veloce]** — Sistema di punteggio basato su velocità e correttezza
   - File: `lib/services/true_false_score_service.dart`
   - Dipende da: Task 1
   - Dettaglio: Punteggio base = 1pt per corretto, 0 per sbagliato. Bonus velocità: risposta entro 2s = +1pt, entro 5s = +0.5pt. Streak multiplier: x2 dopo 5 corrette consecutive, x3 dopo 10.

5. **[Schermata Riepilogo Vero/Falso]** — Fine partita
   - File: `lib/features/quiz/true_false/summary_screen.dart`
   - Dipende da: Task 1
   - Dettaglio: Statistiche: risposte corrette/totali, tempo medio di risposta, punteggio, streak massima. Pulsanti rigioca/home.

### Casi di Test

- **Test Unitario:** `TrueFalseGenerator.generateQuestion()` — 50% vero, 50% falso, distrattori plausibili.
- **Test Unitario:** `TrueFalseProvider.submitAnswer(true)` — se vero, punteggio +1; se falso, 0 e prossima domanda.
- **Widget Test:** `GameScreen` (Vero/Falso) — due pulsanti visibili, parola e traduzione mostrate, tap su "Vero" emette evento.
- **Integration Test:** Flusso: avvia Vero/Falso → 10 domande → riepilogo con statistiche.
- **Test Case 1:** Parola "apple" con traduzione "mela" → Vero → corretto → +1pt.
- **Test Case 2:** Parola "apple" con traduzione "cane" → Falso → corretto → +1pt.
- **Test Case 3:** Parola "apple" con traduzione "mela" → Falso → sbagliato → 0pt, mostra traduzione corretta.

### Note Architetturali

- Priorità P3: implementare dopo tutte le funzionalità P0/P1/P2.
- I distrattori devono essere plausibili: stessa categoria o difficoltà simile.
- Per la versione infinity, riutilizzare la logica di EPIC-04 (Infinity).
- Il sistema di punteggio veloce è separato dal ScoreCalculator standard perché usa metriche di velocità.
