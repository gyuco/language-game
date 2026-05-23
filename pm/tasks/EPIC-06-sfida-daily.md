# EPIC 06 — Sfida Daily

**Priorità:** P2
**Epic:** Sfida Daily
**Storie:** US-14 (Giocare la sfida daily), US-15 (Classifica daily)

---

## US-14 — Giocare la sfida daily

**Priorità:** P2 | **Da giocatore abituale**, voglio una sfida daily con 5 parole uguali per tutti.

### Tasks Tecniche

1. **[Cloud Function — generateDailyChallenge]** — Funzione Appwrite che seleziona le parole daily
   - File: `appwrite/functions/generate_daily_challenge/index.js` (o .dart)
   - Dipende da: Appwrite setup, collezione `daily_challenges`
   - Dettaglio: Trigger cron a mezzanotte. Seleziona 5 parole casuali dal dataset. Crea documento in `daily_challenges` con data, wordIds, isActive=true. Assicura che le parole siano diverse da quelle dei giorni precedenti (evita ripetizioni vicine).

2. **[Provider Daily Challenge]** — State management per la daily
   - File: `lib/providers/daily/daily_challenge_provider.dart`
   - Dipende da: EPIC-02 US-05 Tasks (WordRepository), EPIC-03 US-08 Task 1 (TenChallengeProvider)
   - Dettaglio: Provider che carica la daily del giorno. Verifica se l'utente ha già giocato (controlla game_sessions per oggi). Se non giocata, carica le 5 parole. Usa la stessa meccanica di 10 Sfida ma con 5 parole. Salva risultato a fine partita.

3. **[Schermata Daily]** — UI della sfida daily
   - File: `lib/features/daily/daily_screen.dart`
   - Dipende da: Task 2
   - Dettaglio: Schermata con timer countdown (24h se già giocata, o tempo rimanente), progress bar 5 parole, pulsante "Gioca" se non giocata, altrimenti mostra riepilogo del risultato di oggi.

4. **[Stato Daily in Home]** — Indicatore daily nella schermata home
   - File: `lib/features/home/widgets/daily_card.dart`
   - Dipende da: Task 2
   - Dettaglio: Card nella home che mostra: "Sfida Daily" + stato (non giocata/ completata / tempo rimasto). Icona calendar-star. Tap naviga alla daily.

5. **[Cloud Function — Daily Streak Update]** — Aggiornamento streak giornaliero dopo aver giocato
   - File: `appwrite/functions/update_daily_streak/index.js`
   - Dipende da: Task 2
   - Dettaglio: Dopo che una partita daily (o qualsiasi partita) è salvata, aggiorna `dailyStreak` e `lastPlayedAt` nell'utente. Se `lastPlayedAt` è `ieri`, incrementa. Se è `oggi`, non fa nulla. Se è più vecchio, resetta a 1.

### Casi di Test

- **Test Unitario:** `DailyChallengeProvider.loadTodayChallenge()` — restituisce 5 wordIds. Se già giocata, stato completed.
- **Test Unitario:** Cloud Function `generateDailyChallenge` — output è 5 ID validi, mai uguali ai 2 giorni precedenti.
- **Widget Test:** `DailyCard` — non giocata → mostra "Non giocata" + pulsante. Completata → mostra punteggio.
- **Integration Test:** Aspetta mezzanotte (mock) → daily generata → gioca daily → verifica salvata → non giocabile di nuovo → streak aggiornato.
- **Test Case 1:** Daily non giocata → pulsante "Gioca" → partita 5 parole → fine → punteggio salvato → card mostra risultato.
- **Test Case 2:** Daily già giocata → pulsante disabilitato → "Completata! Torna domani."

### Note Architetturali

- La Cloud Function `generateDailyChallenge` gira su Appivate Functions con trigger cron a mezzanotte.
- La verifica "già giocata oggi" si fa controllando se esiste una `game_session` con `mode=daily` e `playedAt` di oggi.
- Lo streak giornaliero è aggiornato non solo per la daily ma per qualsiasi partita (US-21).
- Le parole della daily sono le stesse per tutti gli utenti, permettendo una classifica equa.

---

## US-15 — Classifica daily

**Priorità:** P2 | **Da giocatore**, voglio vedere la classifica della sfida daily.

### Tasks Tecniche

1. **[Cloud Function — Daily Leaderboard]** — Calcola la classifica daily
   - File: `appwrite/functions/daily_leaderboard/index.js`
   - Dipende da: US-14 Task 1
   - Dettaglio: Query `game_sessions` per oggi con `mode=daily`, ordinate per score decrescente. Restituisce top N (es. 100) con userId + displayName + score. Cache per 5 minuti per ridurre query.

2. **[Provider Daily Leaderboard]** — Provider per classifica daily
   - File: `lib/providers/daily/daily_leaderboard_provider.dart`
   - Dipende da: Task 1
   - Dettaglio: Carica la classifica daily. Mostra posizione utente corrente anche se non in top. Refresh periodico (es. ogni 30s). Cache locale per evitare refresh continui.

3. **[Schermata Classifica Daily]** — UI della classifica daily
   - File: `lib/features/daily/daily_leaderboard_screen.dart`
   - Dipende da: Task 2
   - Dettaglio: Lista ordinata. Ogni riga: posizione, nome, punteggio. Utente corrente evidenziato (colore primario + badge "Tu"). Scrollable. Se non giocata, messaggio "Gioca la daily per comparire in classifica".

4. **[Storico Classifiche Daily]** — Consultazione classifiche giorni precedenti
   - File: `lib/features/daily/daily_leaderboard_history.dart`
   - Dipende da: Task 2
   - Dettaglio: Picker data per selezionare giorno. Carica classifica di quel giorno. Mostra messaggio se nessuna partita quel giorno.

### Casi di Test

- **Test Unitario:** `DailyLeaderboardProvider.loadLeaderboard(date)` — restituisce lista ordinata, posizione utente calcolata.
- **Widget Test:** `DailyLeaderboardScreen` — mockare classifica, verificare top 3, evidenziazione utente corrente.
- **Integration Test:** Gioca daily → classifica si aggiorna → posizione utente visibile.
- **Test Case 1:** Utente non ha giocato la daily → classifica mostra "Non sei in classifica. Gioca ora!".
- **Test Case 2:** Utente è 5° in classifica → evidenziato con "Tu" e colore diverso.

### Note Architetturali

- La classifica daily è separata dalla classifica globale (US-17).
- Usare Appwrite Database con query ordinata per `score` su `game_sessions` con filtro `playedAt` = oggi e `mode` = daily.
- Per volumi elevati, considerare una collezione di ranking separata aggiornata dalla Cloud Function.
