# EPIC 13 — Notifiche Push

**Priorità:** P2
**Epic:** Notifiche Push
**Storie:** US-28 (Notifica sfida daily), US-29 (Reminder streak)

---

## US-28 — Notifica sfida daily

**Priorità:** P2 | **Da giocatore abituale**, voglio una notifica quando la daily è pronta.

### Tasks Tecniche

1. **[Setup Appwrite Messaging]** — Configurare push notifications su Appwrite
   - File: `lib/services/notification_service.dart`
   - Dipende da: Appwrite config, setup progetto Appwrite
   - Dettaglio: Inizializzare Appwrite Messaging. Richiedere permessi notifica su iOS/Android. Registrare il device token FCM/APNS su Appwrite. Salvare `pushToken` nel profilo utente.

2. **[Cloud Function — notifyDailyChallenge]** — Funzione che invia notifica daily
   - File: `appwrite/functions/notify_daily_challenge/index.js`
   - Dipende da: Task 1, EPIC-06 US-14
   - Dettaglio: Trigger cron alle 9:00. Query utenti che non hanno ancora giocato la daily oggi. Invia push notification a ciascuno: titolo "Sfida Daily pronta!", corpo "5 nuove parole ti aspettano!". Link diretto alla daily (deep link).

3. **[Deep Link Daily]** — Aprire la schermata daily dalla notifica
   - File: `lib/app/router.dart` (modifica)
   - Dipende da: Task 2, EPIC-06
   - Dettaglio: Configurare deep link per `daily` path. Alla ricezione della notifica, navigare a `daily_screen`. Flutter handle del click sulla notifica con `firebase_messaging` o Appwrite Messaging handler.

4. **[Provider Notifiche]** — Gestione stato notifiche e permessi
   - File: `lib/providers/notifications/notification_provider.dart`
   - Dipende da: Task 1
   - Dettaglio: Provider che gestisce lo stato dei permessi notifica, il token registrato. Metodo per richiedere permessi (solo dopo login). Espone se le notifiche sono abilitate.

### Casi di Test

- **Unitario:** `NotificationService.requestPermission()` — permesso concesso → token registrato. Negato → stato denied.
- **Unitario:** Cloud Function — utenti senza daily completata ricevono notifica, chi ha già giocato no.
- **Integration Test:** Abilita notifiche → ricevi notifica daily → tap → app si apre sulla daily.
- **Test Case 1:** 9:00, utente non ha giocato la daily → riceve notifica "Sfida Daily pronta!".
- **Test Case 2:** 9:00, utente ha già giocato la daily → nessuna notifica.
- **Test Case 3:** Permessi notifica negati → nessun errore, app funziona normalmente.

### Note Architetturali

- Appwrite Messaging supporta invio a singoli utenti via `userId` — non serve gestire topic complessi.
- Il device token è registrato su Appwrite durante l'installazione, collegato all'userId.
- Le notifiche richiedono configurazione aggiuntiva su Firebase Cloud Messaging (FCM) per Android e APNS per iOS.
- Deep linking usa `go_router` con schemi URI custom.

---

## US-29 — Reminder streak

**Priorità:** P2 | **Da giocatore**, voglio un reminder se non ho ancora giocato oggi.

### Tasks Tecniche

1. **[Cloud Function — notifyStreakReminder]** — Funzione reminder serale
   - File: `appwrite/functions/notify_streak_reminder/index.js`
   - Dipende da: EPIC-13 US-28 Task 1, EPIC-09 US-21 (StreakProvider)
   - Dettaglio: Trigger cron alle 20:00. Query utenti che non hanno partite oggi (`lastPlayedAt != today`). Per ognuno, se `dailyStreak > 0`, invia notifica: "Non hai ancora giocato oggi! Il tuo streak di N giorni è a rischio." Se streak = 0, invia versione più gentile: "Non hai ancora giocato oggi! Una partita veloce?"

2. **[Toggle Notifiche in Impostazioni]** — Opzione per disattivare notifiche
   - File: `lib/features/settings/notification_settings_screen.dart`
   - Dipende da: EPIC-13 US-28 Task 4
   - Dettaglio: Sezione notifiche nelle impostazioni. Toggle "Notifica daily", "Reminder streak". Salva preferenza su Appwrite. Se disattivato, non inviare notifiche a quell'utente (aggiornare Cloud Functions per rispettare la preferenza).

### Casi di Test

- **Unitario:** Cloud Function — utente con streak=5 e nessuna partita oggi → riceve notifica con "streak di 5 giorni".
- **Unitario:** Cloud Function — utente con streak=0 e nessuna partita → riceve notifica "Una partita veloce?".
- **Integration Test:** Disattiva notifiche da impostazioni → mezzanotte (mock) → nessuna notifica. Riativa → notifiche funzionano.
- **Test Case 1:** Streak=7, non gioca oggi → 20:00 → notifica "Il tuo streak di 7 giorni è a rischio!".
- **Test Case 2:** Gioca alle 19:00 → 20:00 → nessuna notifica (ha già giocato).

### Note Architetturali

- Le Cloud Function rispettano il flag `notificationsEnabled` nel profilo utente.
- Le notifiche sono inviate solo a utenti registrati (non anonimi) — gli anonimi non hanno push token.
- La preferenza notifiche è salvata su Appwrite (`user.notifications.daily` e `user.notifications.reminder`).
- Cron job: usare la schedulazione di Appwrite Functions (o equivalente).
