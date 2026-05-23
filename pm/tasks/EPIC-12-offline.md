# EPIC 12 — Supporto Offline

**Priorità:** P1
**Epic:** Supporto Offline
**Storie:** US-26 (Giocare offline), US-27 (Sincronizzazione)

---

## US-26 — Giocare offline

**Priorità:** P1 | **Da giocatore**, voglio giocare anche senza connessione.

### Tasks Tecniche

1. **[Setup Isar Database]** — Inizializzare Isar per cache locale
   - File: `lib/app/isar_config.dart`
   - Dipende da: —
   - Dettaglio: Configurare Isar database. Definire schemi Isar per: `Word`, `GameSession`, `UserProfile`. Aprire database all'avvio dell'app. Chiudere correttamente su dispose. Directory: `getApplicationDocumentsDirectory()`.

2. **[Cache Locale Parole]** — Servizio di caching per il dataset parole
   - File: `lib/services/word_cache_service.dart`
   - Dipende da: Task 1, EPIC-02 US-05 Task 3 (WordRepository)
   - Dettaglio: All'avvio (quando connesso), scarica parole da Appwrite e le salva in Isar. Mantiene data ultimo sync. Alla richiesta di parole (random, by language), prima cerca in Isar. Se cache vuota e offline, usa solo cache.

3. **[Provider Connettività]** — Monitoraggio stato connessione
   - File: `lib/providers/connectivity/connectivity_provider.dart`
   - Dipende da: —
   - Dettaglio: Usa `connectivity_plus` per monitorare lo stato della rete. Espone `isOnline` (boolean). Ascolta cambiamenti di connettività. Notifica altri provider quando la connettività cambia.

4. **[Cache Locale GameSession]** — Salvataggio locale delle partite
   - File: `lib/services/game_cache_service.dart`
   - Dipende da: Task 1, EPIC-02 US-05 Task 4 (GameRepository)
   - Dettaglio: Salva ogni partita completata in Isar. Quando online, la salva anche su Appwrite. Se offline, solo locale. Mantiene stato sync (synced/pending).

5. **[Indicatore Offline in Home]** — UI che mostra stato offline
   - File: `lib/features/home/widgets/offline_indicator.dart`
   - Dipende da: Task 3
   - Dettaglio: Banner in alto o badge che mostra "Modalità offline" con icona wifi-off. Colore warning/ambra. Quando si torna online, mostra "Connessione ripristinata" brevemente.

6. **[Fallback Audio Offline]** — Gestione audio non disponibile offline
   - File: `lib/services/audio_player_service.dart`
   - Dipende da: Task 3, EPIC-05 US-12 Task 1
   - Dettaglio: Se offline, i file audio non sono disponibili. Forzare modalità scritta con avviso "Audio non disponibile offline". Non tentare download.

### Casi di Test

- **Test Unitario:** `WordCacheService.getRandomWord()` — cache popolata → restituisce parola. Cache vuota → null/eccezione.
- **Test Unitario:** `ConnectivityProvider` — online → true, offline → false.
- **Widget Test:** `OfflineIndicator` — offline → banner visibile. Online → nascosto.
- **Integration Test:** Attiva modalità aereo → apri app → partita funziona con cache → completata → salvata localmente → disattiva aereo → sync automatico.
- **Test Case 1:** Online → avvio app → cache popolata → gioca → partita salvata su Appwrite + locale.
- **Test Case 2:** Offline → avvio app → cache già popolata → gioca → partita salvata locale → indicatore offline visibile.
- **Test Case 3:** Offline → avvio app → cache vuota → messaggio "Nessuna connessione. Connettiti per scaricare le parole."

### Note Architetturali

- Isar è scelto per la cache locale per la sua velocità e supporto a schemi complessi (embedded objects, indici).
- Le parole sono precaricate in cache all'avvio: query Appwrite `words` → salva in Isar. Tempo stimato: < 1s per 500 parole.
- La cache ha un timestamp `lastSyncedAt`. Se più vecchio di 24h, refresh in background.
- `connectivity_plus` non distingue tra WiFi e dati mobili — solo online/offline.

---

## US-27 — Sincronizzazione

**Priorità:** P1 | **Da giocatore**, quando torno online voglio la sincronizzazione automatica.

### Tasks Tecniche

1. **[Sync Service]** — Servizio di sincronizzazione dati offline
   - File: `lib/services/sync_service.dart`
   - Dipende da: EPIC-12 US-26 Tasks 1-4
   - Dettaglio: Quando la connettività passa da offline a online, avvia sync. Legge da Isar tutte le `GameSession` con status `pending`. Le invia ad Appwrite in ordine cronologico. Aggiorna status in `synced`. Se fallisce, riprova con backoff esponenziale (1s, 2s, 4s, 8s, max 60s).

2. **[Provider Sincronizzazione]** — State management per stato sync
   - File: `lib/providers/connectivity/sync_provider.dart`
   - Dipende da: Task 1
   - Dettaglio: Espone stato sync: `idle`, `syncing`, `completed`, `error`. Mostra progresso (N/M partite sync). Dopo sync, ricarica statistiche e profilo.

3. **[UI Indicatore Sync]** — Indicatore di sincronizzazione nella UI
   - File: `lib/features/home/widgets/sync_indicator.dart`
   - Dipende da: Task 2
   - Dettaglio: Spinner/icona quando sync in corso. Testo "Sincronizzazione in corso...". Quando completato, mostra "✅ Dati sincronizzati" per 3 secondi. In caso di errore, mostra "Errore sincronizzazione" con pulsante riprova.

4. **[Sincronizzazione Manuale]** — Pulsante per forzare sync
   - File: `lib/features/settings/sync_settings_screen.dart`
   - Dipende da: Task 2
   - Dettaglio: Nelle impostazioni, sezione "Sincronizzazione". Mostra: data ultimo sync, pulsante "Sincronizza ora". Stato: partite in attesa di sync.

5. **[Conflict Resolution]** — Gestione conflitti (last-write-wins)
   - File: `lib/services/sync_service.dart`
   - Dipende da: Task 1
   - Dettaglio: Se una partita offline è in conflitto con dati server (es. parola cancellata), logica last-write-wins: la versione locale sovrascrive quella server. Per i dati utente (profilo), la versione server è preferita (più recente). Documentare il comportamento.

### Casi di Test

- **Test Unitario:** `SyncService.syncPendingGames()` — 5 partite pending → tutte inviate → status synced.
- **Test Unitario:** `SyncService.syncPendingGames()` — errore di rete → retry con backoff → dopo 3 tentativi successo.
- **Widget Test:** `SyncIndicator` — sync in corso → spinner. Completato → checkmark. Errore → icona errore + riprova.
- **Integration Test:** Gioca 3 partite offline → torna online → sync parte automaticamente → partite visibili in cronologia → punteggio totale aggiornato.
- **Test Case 1:** 5 partite offline → torna online → sync: 1/5, 2/5, ... 5/5 → completato.
- **Test Case 2:** 0 partite offline → sync non necessario → nessuna indicazione.
- **Test Case 3:** Sync fallisce per timeout → retry dopo 1s → fallisce → retry dopo 2s → successo.

### Note Architetturali

- La coda di sync è gestita da Isar (oggetti `PendingSync` con: `type` (game_session), `data` (JSON), `createdAt`, `retryCount`).
- Backoff esponenziale: evitare sovraccarico del server dopo un periodo offline prolungato.
- La sincronizzazione è unidirezionale (locale → server). I dati letti (parole, classifiche) vengono semplicemente richiesti al server quando online.
- Il sync avviene anche all'avvio dell'app se ci sono dati pending.
- Dopo il sync, aggiornare `totalScore` e `statsByLanguage` nel profilo utente per riflettere le partite offline.
