# EPIC 01 — Autenticazione e Profilo

**Priorità:** P0 (US-01, US-02, US-04) / P1 (US-03)
**Epic:** Autenticazione e Profilo
**Storie:** US-01 (Accesso anonimo), US-02 (Registrazione account), US-03 (Profilo utente), US-04 (Persistenza sessione)

---

## US-01 — Accesso anonimo

**Priorità:** P0 | **Da giocatore occasionale**, voglio poter iniziare a giocare immediatamente senza registrazione.

### Tasks Tecniche

1. **[Setup Appwrite SDK e Config]** — Inizializzare Appwrite SDK nel progetto Flutter
   - File: `lib/app/appwrite_config.dart`
   - Dipende da: —
   - Dettaglio: Creare un file di config con endpoint Appwrite, project ID. Inizializzare `Client`, `Account`, `Databases`, `Storage`, `Functions` singleton. Usare un `Provider` Riverpod per esporre i servizi.

2. **[Repository Auth]** — Creare repository per l'autenticazione che astrae Appwrite Auth
   - File: `lib/repositories/auth_repository.dart`
   - Dipende da: Task 1
   - Dettaglio: Implementare metodi `createAnonymousSession()`, `getCurrentUser()`, `deleteSession()`. Gestire errori Appwrite (network, session expired, etc.). Esporre uno stream dello stato di autenticazione.

3. **[Provider Auth State]** — Provider Riverpod per lo stato di autenticazione globale
   - File: `lib/providers/auth_provider.dart`
   - Dipende da: Task 2
   - Dettaglio: Creare un `StateNotifierProvider<AuthNotifier, AuthState>` che gestisca: `unauthenticated`, `authenticated(User)`, `loading`, `error`. All'avvio dell'app, tentare `getCurrentUser()` per ripristinare la sessione. Se fallisce, creare automaticamente sessione anonima.

4. **[Schermata Splash/Loading]** — Mostrare una schermata di caricamento mentre Appwrite inizializza
   - File: `lib/features/splash/splash_screen.dart`
   - Dipende da: Task 3
   - Dettaglio: Widget che ascolta lo stato di auth. Se `unauthenticated` → crea sessione anonima. Se `authenticated` → naviga alla home. Se `error` → mostra messaggio con retry. Usare gradiente primario come sfondo, logo al centro. Timer massimo 3s.

5. **[Navigazione condizionale basata su auth]** — Router principale che decide la schermata iniziale
   - File: `lib/app/router.dart`
   - Dipende da: Tasks 3-4
   - Dettaglio: Usare `go_router` (o `MaterialApp.router`) con un `redirect` che in base all'auth state mostra splash, login, o home.

6. **[Upgrade anonimo → registrato]** — Unire i dati anonimi all'account registrato
   - File: `lib/repositories/auth_repository.dart`
   - Dipende da: Tasks 2, US-02
   - Dettaglio: Dopo la registrazione, se l'utente era in sessione anonima, trasferire `game_sessions` e `profile` dall'ID anonimo al nuovo userId. Implementare logica di merge lato Appwrite.

### Casi di Test

- **Test Unitario:** `AuthRepository` — mockare Appwrite SDK, testare `createAnonymousSession()` restituisce userId, testare errore di rete lancia `AuthException`.
- **Widget Test:** `SplashScreen` — mockare auth state, verificare che con `authenticated` navighi alla home, con `unauthenticated` chiami `createAnonymousSession()`.
- **Integration Test:** Flusso completo apertura app → splash → sessione anonima creata → navigazione a home.
- **Test Case 1:** Prima apertura app → sessione anonima creata su Appwrite → utente può giocare.
- **Test Case 2:** Appwrite non raggiungibile → retry automatico + mostra errore con pulsante riprova.
- **Test Case 3:** Utente anonimo cancella dati app → nuova sessione anonima (ID diverso, nessun dato precedente).

### Note Architetturali

- Usare `Appwrite Auth` con `createAnonymousSession()` — la sessione è persistente nel device storage di Appwrite SDK.
- Il merge anonimo→registrato è critico: prevedere una Appwrite Cloud Function per unire i dati se il volume cresce.
- Il `AuthNotifier` deve essere inizializzato prima del `runApp()` per evitare flash di schermate non autenticate.
- Stato `AuthState` definito come sealed class con pattern `freezed` o `equatable`.

---

## US-02 — Registrazione account

**Priorità:** P0 | **Da giocatore abituale**, voglio registrarmi con email e password.

### Tasks Tecniche

1. **[Schermata di Login]** — UI per login con email + password
   - File: `lib/auth/login_screen.dart`
   - Dipende da: EPIC-01 US-01 Task 2 (AuthRepository)
   - Dettaglio: Form con campi email/password, pulsante login, link a registrazione e recupero password. Validazione client-side (email valida, password ≥ 8 caratteri). Mostra errori Appwrite tradotti (es. "Credenziali errate", "Utente non trovato"). Design: card centrata, sfondo gradiente.

2. **[Schermata di Registrazione]** — UI per registrazione con email + password
   - File: `lib/auth/register_screen.dart`
   - Dipende da: Task 1
   - Dettaglio: Form con email, password, conferma password, display name. Validazione: password match, password strength (min 8 char, almeno 1 numero), email formato. Dopo registrazione, crea profilo in collezione `users` con `displayName`.

3. **[Schermata Recupero Password]** — UI per reset password via email
   - File: `lib/auth/forgot_password_screen.dart`
   - Dipende da: Task 2
   - Dettaglio: Campo email, pulsante "Invia link di reset". Appwrite `account.createRecovery()`. Messaggio di conferma "Controlla la tua email".

4. **[Metodi AuthRepository per registrazione/login]** — Implementare metodi mancanti
   - File: `lib/repositories/auth_repository.dart`
   - Dipende da: EPIC-01 US-01 Task 2
   - Dettaglio: Aggiungere `registerWithEmail(email, password, displayName)`, `loginWithEmail(email, password)`, `logout()`, `resetPassword(email)`.

5. **[Provider Auth — Unione account anonimo]** — Logica di merge al momento della registrazione
   - File: `lib/providers/auth_provider.dart`
   - Dipende da: Task 4, US-01 Task 6
   - Dettaglio: Se `AuthState` è anonimo e l'utente si registra, chiamare merge dei dati dopo la registrazione.

### Casi di Test

- **Test Unitario:** `AuthRepository.registerWithEmail()` — testare registrazione con dati validi, email già usata, password debole, errore di rete.
- **Widget Test:** `LoginScreen` — testare validazione form: email vuota mostra errore, password < 8 caratteri mostra errore, submit con dati validi chiama repository.
- **Integration Test:** Registrazione → login → verifica profilo creato su Appwrite → logout → login → verifica sessione persistente.
- **Test Case 1:** Email nuova + password valida → registrazione OK → reindirizzamento a home.
- **Test Case 2:** Email già registrata → mostra errore "Email già in uso".
- **Test Case 3:** Password di 6 caratteri → errore validazione client-side "Minimo 8 caratteri".
- **Test Case 4:** Utente anonimo si registra → merge dati anonimi → nuovo account con storico.

### Note Architetturali

- La validazione lato client è essenziale per UX reattiva, ma la validazione finale è server-side (Appwrite).
- Le password non vengono mai gestite lato client — Appwrite usa hash server-side.
- Il merge anonimo→registrato richiede un migration service separato (`services/profile_migration_service.dart`) per trasferire game_sessions e stats dall'userId anonimo a quello nuovo.
- Usare `FlutterToast` o `SnackBar` per feedback non intrusivi.

---

## US-03 — Profilo utente

**Priorità:** P1 | **Da giocatore registrato**, voglio vedere e modificare il mio profilo.

### Tasks Tecniche

1. **[Schermata Profilo]** — UI del profilo utente
   - File: `lib/features/profile/profile_screen.dart`
   - Dipende da: EPIC-01 US-01 Task 3 (AuthProvider), EPIC-09 US-19 (Statistiche)
   - Dettaglio: Mostra avatar (placeholder circolare con iniziali), display name, email, punteggio totale, streak giornaliero 🔥, data iscrizione, statistiche rapide. Pulsanti: "Modifica profilo", "Statistiche", "Badge", "Impostazioni", "Elimina account".

2. **[Modifica Profilo]** — Schermata di modifica profilo
   - File: `lib/features/profile/edit_profile_screen.dart`
   - Dipende da: Task 1
   - Dettaglio: Form per modificare display name e lingua madre preferita. Salva su Appwrite collezione `users`. Validazione: display name non vuoto, lingua tra quelle supportate.

3. **[Repository Profilo]** — Accesso ai dati profilo su Appwrite
   - File: `lib/repositories/profile_repository.dart`
   - Dipende da: EPIC-01 US-01 Task 1 (Appwrite config)
   - Dettaglio: Metodi `getProfile(userId)`, `updateProfile(userId, data)`, `deleteAccount(userId)`. Lettura/scrittura su collezione `users` in Appwrite Database.

4. **[Provider Profilo]** — State management per il profilo
   - File: `lib/providers/profile_provider.dart`
   - Dipende da: Task 3, US-01 Task 3
   - Dettaglio: `FutureProvider` o `StateNotifierProvider` per caricare il profilo. Ricarica dopo modifiche. Gestisce stati loading/error/data.

5. **[Eliminazione Account]** — Flusso di eliminazione account con conferma
   - File: `lib/features/profile/delete_account_dialog.dart`
   - Dipende da: Task 3
   - Dettaglio: Bottom sheet di conferma con testo esplicativo. Password richiesta per conferma. Chiama `Appwrite Account.delete()` + pulizia collezioni. Logout automatico dopo cancellazione.

### Casi di Test

- **Test Unitario:** `ProfileRepository.updateProfile()` — testare aggiornamento display name, lingua preferita, gestione errore 404 (utente non trovato).
- **Widget Test:** `ProfileScreen` — mockare profilo dati, verificare visualizzazione corretta di nome, email, punteggio, streak.
- **Integration Test:** Modifica display name → verifica persistenza su Appwrite → refresh profilo → nuovo nome visibile.
- **Test Case 1:** Utente registrato apre profilo → vede nome, email, punteggio, streak corretti.
- **Test Case 2:** Modifica display name in stringa vuota → errore validazione "Il nome non può essere vuoto".
- **Test Case 3:** Eliminazione account → conferma con password → account cancellato → logout automatico → reindirizzamento a splash.

### Note Architetturali

- Il profilo è nella collezione `users` di Appwrite Database, non in Auth (che ha dati minimi).
- Per l'avatar: iniziali su sfondo circolare con colore generato dall'hash dello username (evita upload immagini in v1).
- La lingua madre preferita (`preferredLanguage`) è usata per le traduzioni nel gioco e per la modalità inversa (US-32).
- Proteggere eliminazione account con conferma a 2 step (dialog + password).

---

## US-04 — Persistenza sessione

**Priorità:** P0 | **Da giocatore**, voglio che la mia sessione rimanga attiva tra un avvio e l'altro.

### Tasks Tecniche

1. **[Gestione Token Sessione]** — Sfruttare persistenza automatica di Appwrite SDK
   - File: `lib/services/session_service.dart`
   - Dipende da: EPIC-01 US-01 Task 1
   - Dettaglio: Appwrite SDK mantiene automaticamente il token di sessione. Creare un service che ascolti lo stato della sessione. Se `getCurrentUser()` fallisce con `401`, tenta refresh. Se anche refresh fallisce, stato `unauthenticated`.

2. **[Provider Sessione Persistente]** — Provider che mantiene auth state tra riavvii
   - File: `lib/providers/session_provider.dart`
   - Dipende da: Task 1
   - Dettaglio: All'init, leggere token salvato da Appwrite SDK. Se presente, chiamare `getCurrentUser()`. Se valido → authenticated. Se scaduto → refresh silenzioso. Se refresh fallisce → mostra login.

3. **[Schermata Login Forzato]** — Mostrata solo quando refresh fallisce
   - File: `lib/auth/forced_login_screen.dart`
   - Dipende da: Task 2
   - Dettaglio: Stessa UI di LoginScreen ma con messaggio "Sessione scaduta. Effettua di nuovo il login."

### Casi di Test

- **Test Unitario:** `SessionService` — mockare Appwrite, testare flusso token valido → utente restituito, token scaduto → refresh chiamato.
- **Widget Test:** App riaperta → mockare sessione persistente → utente vede home senza login.
- **Integration Test:** Login → chiudi app → riapri → utente ancora autenticato → logout → chiudi → riapri → vede login.
- **Test Case 1:** Token valido → splash → home.
- **Test Case 2:** Token scaduto → refresh OK → home.
- **Test Case 3:** Token scaduto → refresh fallisce → schermata login forzato.

### Note Architetturali

- Appwrite SDK gestisce la persistenza del token in automatico (storage nativo del dispositivo). Non serve fare manualmente save/load.
- Il refresh token è gestito da Appwrite internamente — noi chiamiamo solo `Account.get()` e gestiamo l'eccezione `AppwriteException` con codice `401`.
- Non implementare OAuth manuale — Appwrite SDK lo fa già.
