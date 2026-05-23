# EPIC 14 — Condivisione

**Priorità:** P2
**Epic:** Condivisione
**Storie:** US-30 (Condividi risultato)

---

## US-30 — Condividi risultato

**Priorità:** P2 | **Da giocatore**, voglio condividere il risultato sui social.

### Tasks Tecniche

1. **[Service Condivisione]** — Servizio per generare testo condivisibile
   - File: `lib/services/share_service.dart`
   - Dipende da: EPIC-02 US-05 Task 2 (GameSession model)
   - Dettaglio: Metodo `generateShareText(GameSession) → String`. Formatta il risultato in testo leggibile. Esempio: "🧠 Language Game | 10 Sfida: 42pt 🔥 | Streak: 8 | Ho indovinato 9/10 parole in 6 lingue! Mi battezzi? 🌍". Template diverso per ogni modalità.

2. **[Provider Condivisione]** — Provider per azione di sharing
   - File: `lib/providers/share/share_provider.dart`
   - Dipende da: Task 1
   - Dettaglio: Provider che chiama `Share.share(text)` dalla libreria `share_plus`. Gestisce lo share sheet nativo. Eventuale generazione di immagine (opzionale per v1).

3. **[Pulsante Condividi in Riepilogo]** — UI pulsante nella schermata di riepilogo
   - File: `lib/features/quiz/shared/share_button.dart`
   - Dipende da: Task 2
   - Dettaglio: Pulsante "Condividi" nella schermata di riepilogo partita. Icona share. Testo variabile per modalità. Posizionato in fondo accanto a "Rigioca" e "Home".

4. **[Template Testo per Modalità]** — Testi di condivisione per ogni modalità di gioco
   - File: `lib/services/share_templates.dart`
   - Dipende da: Task 1
   - Dettaglio: Template per: GuessTheWord, TenChallenge, Infinity, Daily, TrueFalse. Includere emoji, punteggio, streak, lingue. Localizzati in italiano e inglese (seguendo EPIC-10 US-22).

### Casi di Test

- **Test Unitario:** `ShareService.generateShareText()` — gameSession 10 Sfida, punteggio=42, streak=8, corrette=9/10, lingue=6 → output contiene "42pt", "8", "9/10", "6 lingue".
- **Widget Test:** `ShareButton` — pulsante visibile nel riepilogo → tap → chiama share service.
- **Integration Test:** Gioca partita → riepilogo → tap "Condividi" → share sheet nativo si apre con testo corretto.
- **Test Case 1:** Indovina Parola: "🧠 Language Game | Indovina la Parola: 15pt 🔥 | Ho indovinato 3/4 parole! 🌍".
- **Test Case 2:** Daily: "🧠 Language Game | Sfida Daily: 25pt 🔥 | 5/5 parole! Oggi sono in forma! 📅".

### Note Architetturali

- Usare `share_plus` package per lo share sheet nativo (cross-platform).
- I testi di condivisione sono localizzati (EPIC-10 US-22).
- Per v1, solo testo. In futuro valutare generazione di immagini (condivisione social con screenshot stiloso).
- Le emoji sono parte integrante del testo di condivisione per renderlo accattivante.
