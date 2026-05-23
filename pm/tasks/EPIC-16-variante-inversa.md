# EPIC 16 — Variante Inversa

**Priorità:** P2
**Epic:** Variante Inversa (Indovina la Parola)
**Storie:** US-32 (Modalità inversa)

---

## US-32 — Modalità inversa

**Priorità:** P2 | **Da giocatore esperto**, voglio la variante "inversa" per allenare la produzione attiva.

### Tasks Tecniche

1. **[Provider Modalità Inversa]** — State management per modalità inversa
   - File: `lib/providers/quiz/inverse_provider.dart`
   - Dipende da: EPIC-02 US-05 Task 5 (GuessTheWordProvider), EPIC-02 US-05 Task 3 (WordRepository)
   - Dettaglio: Estensione di GuessTheWordProvider o provider separato. Logica inversa: la parola viene mostrata nella lingua madre dell'utente. L'utente deve scrivere la traduzione in una lingua straniera casuale. Stesso sistema di punteggio decrescente. Metodo: `startInverseGame()`.

2. **[Selezione Lingua Target Casual]** — Scegliere lingua straniera per la risposta
   - File: `lib/services/inverse_game_service.dart`
   - Dipende da: EPIC-02 US-05 Task 3 (WordRepository), EPIC-01 US-03 (preferredLanguage)
   - Dettaglio: Data una parola nella lingua madre, seleziona una lingua target casuale (diversa dalla lingua madre). Verifica che esista una traduzione della parola in quella lingua. Altrimenti, sceglie un'altra lingua.

3. **[Schermata Gioco Inversa]** — UI della modalità inversa
   - File: `lib/features/quiz/inverse/inverse_game_screen.dart`
   - Dipende da: Task 1
   - Dettaglio: Stessa struttura di GuessTheWord ma: parola nella lingua madre dell'utente, label "Scrivi in [Lingua Target]", bandiera della lingua target. Feedback: mostra grafia corretta nella lingua target dopo la risposta.

4. **[Feedback Grafia Corretta]** — Mostrare la scrittura corretta nella lingua target
   - File: `lib/features/quiz/inverse/widgets/correct_spelling_display.dart`
   - Dipende da: Task 1
   - Dettaglio: Dopo la risposta (giusta o sbagliata), mostrare la parola scritta correttamente nella lingua target. Evidenziare le differenze con la risposta dell'utente (se sbagliata). Animazione di rivelazione.

### Casi di Test

- **Test Unitario:** `InverseGameService.selectTargetLanguage(preferredLanguage: 'it')` → restituisce lingua != 'it'.
- **Test Unitario:** `InverseProvider.submitAnswer("apple")` — parola madre "Mela", target "en" → "apple" corretta → +5pt.
- **Widget Test:** `InverseGameScreen` — mostra "Scrivi in Tedesco" con bandiera DE, campo input.
- **Integration Test:** Avvia modalità inversa → parola in italiano → scrivi traduzione in tedesco → feedback con grafia corretta.
- **Test Case 1:** Parola "Mela" (IT) → target "Tedesco" → utente scrive "Apfel" → corretto → 5pt → mostra "✓ Apfel".
- **Test Case 2:** Parola "Mela" (IT) → target "Francese" → utente scrive "Pomme" → corretto → mostra "✓ Pomme".
- **Test Case 3:** Parola "Mela" (IT) → target "Tedesco" → utente scrive "Birne" (pera) → sbagliato → mostra "✗ Apfel" con differenze evidenziate.

### Note Architetturali

- La lingua madre dell'utente è il campo `preferredLanguage` dal profilo (US-03).
- La modalità inversa è una variante di "Indovina la Parola" (US-05..07): stesso sistema di punteggio, stessi indizi ma al contrario.
- Il feedback con la grafia corretta è fondamentale per l'apprendimento: l'utente vede la parola target come dovrebbe essere scritta.
- Il selettore di lingua target deve garantire che la traduzione esista nel dataset.
- Per evitare frustrazione, mostrare sempre la grafia corretta dopo la risposta, indipendentemente dall'esito.
