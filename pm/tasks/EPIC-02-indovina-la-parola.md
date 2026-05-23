# EPIC 02 — Indovina la Parola

**Priorità:** P0
**Epic:** Modalità "Indovina la Parola"
**Storie:** US-05 (Giocare a "Indovina la Parola"), US-06 (Indizi progressivi), US-07 (Punteggio decrescente)

---

## US-05 — Giocare a "Indovina la Parola"

**Priorità:** P0 | **Da giocatore**, voglio giocare a "Indovina la Parola".

### Tasks Tecniche

1. **[Modello Word]** — Data model per le parole del gioco
   - File: `lib/models/word.dart`
   - Dipende da: —
   - Dettaglio: Classe `Word` con campi: `id`, `text`, `translation`, `language`, `languageName`, `category`, `difficulty`, `audioFileId`, `createdAt`. Includere metodi `fromJson`/`toJson` per Appwrite, `fromIsar`/`toIsar` per cache locale. Usare `freezed` o `equatable` per immutabilità.

2. **[Modello GameSession]** — Data model per sessione di gioco
   - File: `lib/models/game_session.dart`
   - Dipende da: Task 1
   - Dettaglio: Classe `GameSession` con: `id`, `userId`, `mode`, `audioMode`, `wordsPlayed` (List<WordResult>), `score`, `maxStreak`, `correctCount`, `totalCount`, `playedAt`. `WordResult` annidata: `wordId`, `originalLanguage`, `attempts`, `hintsUsed`, `correct`.

3. **[Repository Parole]** — Accesso al dataset parole (remote + cache)
   - File: `lib/repositories/word_repository.dart`
   - Dipende da: Task 1, Appwrite config
   - Dettaglio: Metodi: `getRandomWord()` (parola casuale con traduzioni multilingua), `getWordsByIds(List<String> ids)`, `getTranslations(String wordId)` (recupera traduzioni in altre lingue). Strategia: prima cache Isar, poi Appwrite.

4. **[Repository Partite]** — Salvataggio/caricamento partite
   - File: `lib/repositories/game_repository.dart`
   - Dipende da: Task 2
   - Dettaglio: Metodi: `saveGameSession(GameSession)`, `getGameHistory(userId, {limit, offset})`. Salva su Appwrite collezione `game_sessions` e su Isar per offline.

5. **[Provider Quiz — GuessTheWord]** — State management per la partita
   - File: `lib/providers/quiz/guess_the_word_provider.dart`
   - Dipende da: Tasks 1-4
   - Dettaglio: `StateNotifierProvider<GuessTheWordNotifier, GuessTheWordState>`. Stato contiene: parola corrente, lingue rivelate, tentativi, punteggio, stato partita (playing/completed). Metodi: `startGame()`, `submitAnswer(String)`, `skipWord()`, `nextWord()`, `endGame()`.

6. **[Schermata Gioco — Indovina la Parola]** — UI della modalità di gioco
   - File: `lib/features/quiz/guess_the_word/game_screen.dart`
   - Dipende da: Task 5
   - Dettaglio: Schermata con parola centrale (Outfit Bold 32pt), bandiera + nome lingua sopra, input di risposta con validazione in tempo reale, pulsante invio, pulsante salta. Stati: parola mostrata, feedback corretto (bordo verde + animazione), feedback sbagliato (shake + bordo rosso), prossima parola.

7. **[Schermata Riepilogo]** — Riepilogo fine partita
   - File: `lib/features/quiz/shared/quiz_summary_screen.dart`
   - Dipende da: Task 6, US-05 Tasks
   - Dettaglio: Mostra punteggio totale, parole corrette/totali, lingue incontrate, streak massima, pulsanti: "Rigioca", "Torna alla home", "Condividi" (se US-30 implementata), "Vedi classifica" (se US-17 implementata).

### Casi di Test

- **Test Unitario:** `GuessTheWordNotifier.startGame()` — caricare parola, stato iniziale corretto.
- **Test Unitario:** `GuessTheWordNotifier.submitAnswer()` — risposta giusta incrementa punteggio, risposta sbagliata rivela lingua successiva.
- **Widget Test:** `GameScreen` — mockare provider, verificare parola mostrata, input funzionante, feedback visivo corretto/sbagliato.
- **Integration Test:** Flusso completo: giocatore apre modalità → vede parola → scrive risposta giusta → feedback corretto → vedi riepilogo.
- **Test Case 1:** Parola "Apfel" (tedesco) con traduzione "Mela" → utente scrive "mela" → risposta corretta, punteggio 5pt.
- **Test Case 2:** Parola "Apfel" → utente scrive "pera" → risposta sbagliata → animazione shake → nuova lingua rivelata.
- **Test Case 3:** Utente preme "Salta" → punteggio 0pt per quella parola → passa alla successiva.

### Note Architetturali

- La validazione è case-insensitive con trimming. Normalizzare la risposta: `answer.trim().toLowerCase()`.
- Punteggio calcolato in base ai tentativi: 1°=5pt, 2°=4pt, 3°=3pt, 4°-5°=2pt, 6°+=1pt, svelata=0pt.
- Le parole multiple (con traduzioni multilingua) sono la chiave del gioco. Il dataset in Appwrite deve relazionare una parola con le sue traduzioni. Opzione: una collezione `word_groups` con groupId.
- La cache Isar velocizza l'avvio delle partite in assenza di connessione.

---

## US-06 — Indizi progressivi in altre lingue

**Priorità:** P0 | **Da giocatore**, quando sbaglio voglio vedere la parola in altre lingue.

### Tasks Tecniche

1. **[Logica Indizi Multi-lingua]** — Gestione della progressione degli indizi
   - File: `lib/services/hint_service.dart`
   - Dipende da: EPIC-02 US-05 Task 1 (Word model)
   - Dettaglio: Servizio che, data una parola, recupera le sue traduzioni in altre lingue. Ordine casuale predefinito (shuffle all'inizio). Traccia quante lingue sono state rivelate. Massimo 7-8 tentativi.

2. **[Provider Gestione Indizi]** — Integrazione con GuessTheWordProvider
   - File: `lib/providers/quiz/hint_provider.dart`
   - Dipende da: Task 1, EPIC-02 US-05 Task 5
   - Dettaglio: Espone la lista delle lingue rivelate. Ogni errore aggiunge una lingua alla lista. Quando la lista è piena (7-8), la parola viene svelata. Mostra bandiera + lingua + parola per ogni indizio rivelato.

3. **[UI Indizi Progressivi]** — Visualizzazione delle lingue rivelate
   - File: `lib/features/quiz/guess_the_word/hints_display.dart`
   - Dipende da: Task 2
   - Dettaglio: Widget che mostra le lingue rivelate finora in chip orizzontali scorrevoli. Ogni chip: bandiera + nome lingua + parola tradotta. In alto: "Indizio: N/8 lingue".

### Casi di Test

- **Test Unitario:** `HintService.getNextHint()` — prima chiamata restituisce prima lingua casuale, 8 chiamate esauriscono gli indizi.
- **Test Unitario:** `HintProvider` — 3 risposte sbagliate → 3 lingue rivelate, all'8ª la parola è svelata.
- **Widget Test:** `HintsDisplay` — mockare 3 lingue rivelate, verificare 3 chip visibili con bandiere e traduzioni.
- **Test Case 1:** Parola con 5 traduzioni → 2 risposte sbagliate → 2 lingue rivelate → 3ª risposta giusta → fine turno.
- **Test Case 2:** Parola con 8 traduzioni → 8 risposte sbagliate → ultimo indizio rivelato → parola svelata → 0pt.

### Note Architetturali

- Le traduzioni sono recuperate da Appwrite: la parola originale ha un `groupId` che collega tutte le traduzioni. In alternativa, una sub-collezione `translations` sotto ogni parola.
- L'ordine degli indizi è randomizzato all'inizio della partita per evitare pattern prevedibili.
- Il conteggio massimo degli indizi dipende da quante traduzioni ci sono nel dataset (minimo 2, massimo 8).

---

## US-07 — Punteggio decrescente

**Priorità:** P0 | **Da giocatore**, voglio punteggio inversamente proporzionale agli indizi usati.

### Tasks Tecniche

1. **[Calcolatore Punteggio]** — Logica di calcolo punteggio basata sui tentativi
   - File: `lib/services/score_calculator.dart`
   - Dipende da: —
   - Dettaglio: Funzione `calculateGuessScore(int attemptsUsed) → int`: Tentativo 1=5pt, 2=4pt, 3=3pt, 4-5=2pt, 6+=1pt, svelata=0pt. Includere anche calcolatore per 10 Sfida (`calculateStreakScore(int streakLength) → int`).

2. **[Provider Punteggio]** — Integrazione con provider di gioco
   - File: `lib/providers/quiz/score_provider.dart`
   - Dipende da: Task 1, EPIC-02 US-05 Task 5
   - Dettaglio: Provider che tiene traccia del punteggio corrente durante la partita. Mostrato in header. Si aggiorna ad ogni risposta. Notifica con animazione quando cambia.

3. **[UI Punteggio in Partita]** — Visualizzazione punteggio durante la partita
   - File: `lib/features/quiz/shared/score_display.dart`
   - Dipende da: Task 2
   - Dettaglio: Badge/number in alto a destra con il punteggio corrente. Animazione di conteggio quando il punteggio cambia (digit counter animation). Colore ambra per punteggio alto, primario per medio, secondario per basso.

### Casi di Test

- **Test Unitario:** `ScoreCalculator.calculateGuessScore()` — input 1 → output 5, input 3 → output 3, input 6 → output 1, input 8 → output 0.
- **Widget Test:** `ScoreDisplay` — mockare punteggio = 42, verificare mostra "42" con stile corretto.
- **Integration Test:** Partita completa → risposte a vari tentativi → punteggio finale calcolato correttamente → salvato in game_session.
- **Test Case 1:** 3 parole indovinate al 1° tentativo → punteggio 5+5+5 = 15pt.
- **Test Case 2:** 3 parole: 1° tentativo (5pt), 3° tentativo (3pt), svelata (0pt) → totale 8pt.

### Note Architetturali

- Il calcolatore è un plain Dart service (nessuna dipendenza Flutter) — facilmente testabile.
- Condividere `ScoreCalculator` tra GuessTheWord e TenChallenge tramite dependency injection.
- Il punteggio di fine partita viene sommato al `totalScore` dell'utente nella collezione `users` dopo il salvataggio.
