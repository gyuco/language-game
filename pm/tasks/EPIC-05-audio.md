# EPIC 05 — Modalità Audio

**Priorità:** P1
**Epic:** Modalità Audio
**Storie:** US-12 (Giocare in modalità audio), US-13 (Scelta scritta/audio)

---

## US-12 — Giocare in modalità audio

**Priorità:** P1 | **Da giocatore**, voglio giocare con la pronuncia invece del testo.

### Tasks Tecniche

1. **[Servizio Audio Player]** — Wrapper per audioplayers/just_audio
   - File: `lib/services/audio_player_service.dart`
   - Dipende da: —
   - Dettaglio: Service singleton o provider che avvolge `audioplayers` o `just_audio`. Metodi: `play(String urlOrFileId)`, `stop()`, `pause()`, `isPlaying`. Scarica file da Appwrite Storage dato un `fileId`. Gestisce errori di caricamento, file non trovato.

2. **[Gestione Toggle Audio in Provider Gioco]** — Condizionare la visualizzazione della parola in base al toggle
   - File: `lib/providers/quiz/audio_mode_provider.dart`
   - Dipende da: Task 1, EPIC-02 US-05 Task 5 (GuessTheWordProvider), EPIC-03 US-08 Task 1 (TenChallengeProvider)
   - Dettaglio: Provider boolean `isAudioMode`. Quando true, il quiz nasconde il testo della parola e riproduce l'audio. Quando false, mostra il testo. Integrato con GuessTheWordProvider e TenChallengeProvider come wrapper.

3. **[Pulsante Riascolto]** — UI per riascoltare la pronuncia
   - File: `lib/features/quiz/shared/replay_audio_button.dart`
   - Dipende da: Task 1, Task 2
   - Dettaglio: Icon button (speaker-high) visibile in modalità audio. Permette di riascoltare la parola. Disabilitato durante la riproduzione. Mostra feedback visivo quando preme.

4. **[Fallback Scritta]** — Se audio non disponibile, cadere in modalità scritta
   - File: `lib/services/audio_player_service.dart`
   - Dipende da: Task 1
   - Dettaglio: Se `word.audioFileId` è null o il caricamento fallisce, emettere evento di fallback. Il provider imposta `isAudioMode = false` e mostra avviso "Audio non disponibile per questa parola".

### Casi di Test

- **Test Unitario:** `AudioPlayerService.play()` — file esistente → riproduzione avviata. File inesistente → eccezione gestita.
- **Widget Test:** `ReplayAudioButton` — in modalità audio, pulsante visibile. Al tap, chiama service.play().
- **Integration Test:** Modalità audio → parola con audio → testo nascosto, audio riprodotto → utente risponde.
- **Test Case 1:** Parola con audioFileId valido → modalità audio → testo nascosto, audio parte automaticamente.
- **Test Case 2:** Parola senza audioFileId → fallback a scritta → avviso "Audio non disponibile" → gioco normale.
- **Test Case 3:** Pulsante riascolto premuto → audio riprodotto di nuovo.

### Note Architetturali

- I file audio sono su Appwrite Storage. Recuperarli via `Storage.getFileDownload(fileId)` per ottenere l'URL.
- `audioplayers` è più semplice, `just_audio` offre più controllo (caching, equalizzazione). Per v1, `audioplayers` è sufficiente.
- È importante precaricare l'audio all'inizio del turno per evitare lag.
- In modalità offline (US-26), l'audio potrebbe non essere disponibile → fallback automatico a scritta.

---

## US-13 — Scelta scritta/audio

**Priorità:** P1 | **Da giocatore**, voglio scegliere tra scritta e audio a inizio partita.

### Tasks Tecniche

1. **[Schermata Selezione Formato]** — UI per scegliere tra scritta e audio
   - File: `lib/features/quiz/shared/format_selector_screen.dart`
   - Dipende da: EPIC-05 US-12 Task 2 (AudioModeProvider)
   - Dettaglio: Schermata prima della partita con due grandi card: "📝 Scritta" e "🎧 Audio". Al tap, imposta `isAudioMode` e naviga alla schermata di gioco. Mostra la scelta corrente (dalle impostazioni) pre-selezionata.

2. **[Provider Preferenza Formato]** — Salvataggio e recupero preferenza formato
   - File: `lib/providers/quiz/format_preference_provider.dart`
   - Dipende da: Task 1
   - Dettaglio: Provider che persiste la preferenza su Appwrite (campo `audioMode` in `users`) e localmente (SharedPreferences/Isar). Default = false (scritta). Al cambio, aggiorna entrambi.

3. **[Integrazione con Impostazioni]** — Toggle audio in impostazioni (US-23)
   - File: `lib/features/settings/widgets/audio_toggle.dart`
   - Dipende da: Task 2
   - Dettaglio: Widget toggle nelle impostazioni per modificare la preferenza permanente. Descrizione: "Modalità audio predefinita".

### Casi di Test

- **Widget Test:** `FormatSelectorScreen` — due card visibili, tap su "Audio" → imposta audio mode.
- **Widget Test:** `FormatSelectorScreen` — se preferenza salvata = audio, card audio pre-selezionata.
- **Integration Test:** Imposta preferenza audio da impostazioni → apri nuova partita → formato selector preseleziona audio.
- **Test Case 1:** Preferenza = scritta → format selector pre-seleziona scritta → tap audio → partita in audio.
- **Test Case 2:** Preferenza = audio → nuova partita → parte automaticamente in audio (se salti format selector).

### Note Architetturali

- La scelta può essere saltata se l'utente ha impostato "Non chiedere più" nelle impostazioni.
- La preferenza è salvata sia localmente (per accesso rapido) sia su Appwrite (per sincronizzazione tra dispositivi).
- Il format selector è mostrato dopo la selezione della modalità di gioco, prima che inizi la partita.
