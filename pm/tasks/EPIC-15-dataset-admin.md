# EPIC 15 — Amministrazione Dataset

**Priorità:** P1
**Epic:** Amministrazione Dataset
**Storie:** US-31 (Aggiungere parole)

---

## US-31 — Aggiungere parole (admin)

**Priorità:** P1 | **Da amministratore**, voglio aggiungere nuove parole al dataset.

### Tasks Tecniche

1. **[Admin Role / Auth Guard]** — Proteggere interfaccia admin per soli admin
   - File: `lib/services/admin_guard_service.dart`
   - Dipende da: EPIC-01 (Auth), Appwrite team/roles
   - Dettaglio: Verificare se l'utente corrente ha ruolo admin (campo `role` in `users` = "admin"). Se non admin, nascondere accesso alla sezione admin. Usare Appwrite Team o custom claim.

2. **[Schermata Admin Dashboard]** — Dashboard per la gestione parole
   - File: `lib/features/admin/admin_dashboard_screen.dart`
   - Dipende da: Task 1
   - Dettaglio: Schermata protetta da admin guard. Accesso da profilo (solo admin). Statistiche: totale parole, per lingua, per difficoltà. Pulsanti: "Aggiungi parola", "Importa CSV", "Gestisci lingue".

3. **[Form Aggiunta Parola]** — Form per inserire nuova parola
   - File: `lib/features/admin/add_word_screen.dart`
   - Dipende da: Task 1
   - Dettaglio: Form con campi: testo, traduzione, lingua (dropdown), categoria (dropdown), difficoltà (1-3). Validazione: testo e traduzione obbligatori, lingua tra quelle supportate, no duplicati (check su Appwrite). Pulsante "Salva" che crea documento in `words`.

4. **[Upload Audio Admin]** — Caricamento file audio per parola
   - File: `lib/features/admin/audio_upload_widget.dart`
   - Dipende da: Task 3, Appwrite Storage
   - Dettaglio: Widget per caricare file audio (formati: mp3, ogg, wav). Upload su Appwrite Storage. Collega `audioFileId` al documento parola. Preview audio con player.

5. **[Importazione CSV]** — Import massivo parole da file CSV
   - File: `lib/features/admin/import_csv_screen.dart`
   - Dipende da: Task 3
   - Dettaglio: Seleziona file CSV dal dispositivo. Parsing di righe con formato: `text,translation,language,category,difficulty`. Validazione batch. Report finale: N parole importate, M errori.

6. **[Validazione Anti-Duplicati]** — Controllo duplicati prima del salvataggio
   - File: `lib/services/word_validation_service.dart`
   - Dipende da: EPIC-02 US-05 Task 3 (WordRepository)
   - Dettaglio: Prima di salvare, query Appwrite per controllare se esiste già parola con stesso `text` e `language`. Se duplicato, mostra warning e opzioni: "Salva comunque" o "Annulla".

### Casi di Test

- **Unitario:** `AdminGuardService.isAdmin(user)` — ruolo=admin → true, ruolo=user → false.
- **Unitario:** `WordValidationService.isDuplicate(text, language)` — parola esistente → true, nuova → false.
- **Widget Test:** `AddWordScreen` — form vuoto → pulsante salva disabilitato. Compila campi → abilitato. Lingua non selezionata → errore.
- **Integration Test:** Admin aggiunge parola → verifica su Appwrite → parola disponibile nel gioco.
- **Test Case 1:** Nuova parola "Ciao" in IT → salva → documento creato in `words` → giocabile.
- **Test Case 2:** Parola duplicata → mostra warning "Parola già esistente" → conferma → salvata comunque.
- **Test Case 3:** Utente non-admin tenta accesso admin → redirect/nascosto.

### Note Architetturali

- L'interfaccia admin è un'area protetta: solo utenti con `role: admin` possono accedere.
- Il ruolo admin può essere impostato manualmente su Appwrite Console o tramite API.
- Per import CSV, usare `file_picker` package per selezione file.
- Il caricamento audio usa Appwrite Storage. Dimensione massima: 5MB per file audio.
- In v1, l'interfaccia admin è parte dell'app Flutter. In futuro, valutare una web app admin separata.
- Il dataset cresce con nuove parole, tutte verificate manualmente (niente auto-translation).
