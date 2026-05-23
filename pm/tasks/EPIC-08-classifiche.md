# EPIC 08 — Classifiche

**Priorità:** P2 (US-17) / P3 (US-18)
**Epic:** Classifiche
**Storie:** US-17 (Classifica globale), US-18 (Classifica tra amici)

---

## US-17 — Classifica globale

**Priorità:** P2 | **Da giocatore**, voglio vedere la classifica globale.

### Tasks Tecniche

1. **[Provider Leaderboard]** — Provider per classifica globale
   - File: `lib/providers/leaderboard/global_leaderboard_provider.dart`
   - Dipende da: EPIC-01 US-01 Task 1 (Appwrite config)
   - Dettaglio: Carica top N utenti ordinati per `totalScore` decrescente dalla collezione `users`. Query Appwrite Database con `orderDesc('totalScore')`, limite 100. Cache per 5 minuti. Include utente corrente anche se fuori top 100 (calcola rank separato).

2. **[Schermata Classifica Globale]** — UI classifica globale
   - File: `lib/features/leaderboard/global_leaderboard_screen.dart`
   - Dipende da: Task 1
   - Dettaglio: ListView con item per ogni utente. Posizione, avatar (iniziali), display name, punteggio. Top 3 con podio (oro/argento/bronzo). Utente corrente evidenziato con badge "Tu" e colore primario. Pulsante "Il mio rank" scrolla alla posizione dell'utente.

3. **[Widget Elemento Classifica]** — Singolo elemento della lista
   - File: `lib/features/leaderboard/widgets/leaderboard_tile.dart`
   - Dipende da: Task 1
   - Dettaglio: Card compatta con: posizione (#1, #2, ...), avatar circolare, display name, punteggio, badge se presente. Colori: oro/argento/bronzo per top 3. Highlight per utente corrente.

4. **[Posizione Utente Fuori Top]** — Mostrare rank anche se non tra i primi
   - File: `lib/features/leaderboard/widgets/my_rank_card.dart`
   - Dipende da: Task 1
   - Dettaglio: Card in fondo o in alto che mostra "La tua posizione: #42" con pulsante "Mostra in classifica". Visibile solo quando l'utente non è nella top visualizzata.

### Casi di Test

- **Test Unitario:** `GlobalLeaderboardProvider.loadLeaderboard()` — restituisce lista ordinata, rank utente calcolato.
- **Widget Test:** `GlobalLeaderboardScreen` — mockare top 5, verificare posizioni corrette, colori podio, evidenziazione utente.
- **Integration Test:** Gioca partite → punteggio totale aggiornato → classifica riflette cambiamento.
- **Test Case 1:** Lista classifica → top 3 mostra oro/argento/bronzo, utente è #5 → evidenziato.
- **Test Case 2:** Utente è #150 → card "La tua posizione: #150" visibile, non compare nella lista.

### Note Architetturali

- La classifica globale usa un campo `totalScore` sulla collezione `users` di Appwrite, aggiornato dopo ogni partita (tramite Cloud Function o direttamente).
- Per volumi elevati (1000+ utenti), valutare una collezione `leaderboard` separata aggiornata periodicamente.
- Il refresh manuale (pull-to-refresh) è implementato. Auto-refresh all'apertura della schermata.

---

## US-18 — Classifica tra amici (futuro)

**Priorità:** P3 | **Da giocatore**, voglio aggiungere amici e vedere la classifica tra noi.

### Tasks Tecniche

1. **[Collezione Appwrite — friends]** — Schema per relazioni di amicizia
   - File: `appwrite/schema/friends.json`
   - Dipende da: —
   - Dettaglio: Collezione con campi: `userId` (richiedente), `friendId` (destinatario), `status` (pending/accepted), `createdAt`. Indice composito su `userId + status`.

2. **[Service Amici]** — Repository per gestione amicizie
   - File: `lib/repositories/friends_repository.dart`
   - Dipende da: Task 1
   - Dettaglio: Metodi: `sendRequest(userId, friendId)`, `acceptRequest(requestId)`, `rejectRequest(requestId)`, `getFriends(userId)`, `getPendingRequests(userId)`, `searchUsers(query)`.

3. **[Provider Friends Leaderboard]** — Classifica filtrata per amici
   - File: `lib/providers/leaderboard/friends_leaderboard_provider.dart`
   - Dipende da: Task 2
   - Dettaglio: Carica profili degli amici + utente corrente. Ordina per `totalScore`. Stessa UI di classifica globale ma filtrata.

4. **[UI Ricerca e Gestione Amici]** — Schermate per cercare, inviare, gestire amicizie
   - File: `lib/features/social/friends_screen.dart`
   - Dipende da: Task 2
   - Dettaglio: Tab con: lista amici, richieste in sospeso, cerca utenti. Ricerca con debounce. Pulsanti "Aggiungi", "Accetta", "Rifiuta".

5. **[Notifica Amici]** — Notifica quando un amico supera il punteggio
   - File: `appwrite/functions/notify_friend_score/index.js`
   - Dipende da: Task 2, EPIC-13 (Notifiche)
   - Dettaglio: Cloud Function che confronta punteggi dopo ogni partita. Se un amico supera, invia push notification.

### Casi di Test

- **Test Unitario:** `FriendsRepository.sendRequest()` — richiesta creata con status pending.
- **Test Unitario:** `FriendsRepository.searchUsers("gio")` — restituisce utenti matching.
- **Widget Test:** `FriendsScreen` — lista amici vuota → empty state, ricerca funzionante.
- **Integration Test:** Utente A invia richiesta a B → B accetta → A e B compaiono nella classifica amici di entrambi.
- **Test Case 1:** Cerca "marco" → mostra utenti con "marco" nel nome → tap "Aggiungi" → richiesta inviata.
- **Test Case 2:** Richiesta ricevuta → tab richieste mostra notifica → tap "Accetta" → amico aggiunto.

### Note Architetturali

- Priorità P3: implementare solo dopo tutte le funzionalità P0/P1/P2.
- Le relazioni di amicizia sono bidirezionali: se A è amico di B, anche B è amico di A.
- Usare il pattern di Appwrite: query per documenti dove `userId = X` o `friendId = X` per ottenere tutti gli amici.
- La ricerca utenti usa `listDocuments` con `search` o, per volumi maggiori, un servizio di ricerca esterno.
