# EPIC 10 — Impostazioni

**Priorità:** P1 (US-22, US-23) / P2 (US-24)
**Epic:** Impostazioni
**Storie:** US-22 (Lingua dell'interfaccia), US-23 (Toggle audio), US-24 (Tema chiaro/scuro)

---

## US-22 — Lingua dell'interfaccia

**Priorità:** P1 | **Da utente**, voglio cambiare la lingua dell'interfaccia.

### Tasks Tecniche

1. **[Setup Localization (Flutter Intl)]** — Configurare localizzazione nell'app
   - File: `lib/app/localization/app_localizations.dart`
   - File: `lib/app/localization/l10n/` (directory per file ARB)
   - Dipende da: —
   - Dettaglio: Integrare `flutter_localizations` e `intl`. Creare file ARB per italiano e inglese. Configurare `MaterialApp` con `localizationsDelegates` e `supportedLocales`. Struttura: `app.arb` per chiavi UI.

2. **[Provider Lingua Interfaccia]** — State management per la lingua UI
   - File: `lib/providers/settings/locale_provider.dart`
   - Dipende da: Task 1
   - Dettaglio: Provider che gestisce il locale corrente. Default: `Locale.system`. Persiste la scelta su Appwrite (campo `preferredLocale` in `users`) e localmente. Al cambio, ricostruisce l'app con il nuovo locale.

3. **[Schermata Impostazioni — Lingua]** — UI per selezionare lingua
   - File: `lib/features/settings/locale_settings_screen.dart`
   - Dipende da: Task 2
   - Dettaglio: Lista di opzioni: "Segui sistema", "Italiano", "English". Ogni opzione mostra bandiera + nome lingua. Checkmark sulla selezione corrente. Applicazione immediata senza riavvio.

4. **[Traduzioni Chiave]** — Traduzioni per tutte le stringhe UI in italiano e inglese
   - File: `lib/app/localization/l10n/app_it.arb`
   - File: `lib/app/localization/l10n/app_en.arb`
   - Dipende da: Task 1
   - Dettaglio: Tradurre tutte le stringhe dell'interfaccia: titoli, pulsanti, messaggi, etichette. Organizzare per sezione (home, quiz, profile, settings, etc.).

### Casi di Test

- **Widget Test:** `LocaleSettingsScreen` — "Segui sistema" pre-selezionato di default, tap "Italiano" → locale cambia.
- **Integration Test:** Cambia lingua in Inglese → tutte le label diventano in inglese → ricarica app → persistenza.
- **Test Case 1:** Dispositivo in italiano → app avvia in italiano → utente cambia in inglese → UI in inglese.
- **Test Case 2:** Utente seleziona "Segui sistema" → app segue la lingua del dispositivo anche se cambiata dopo.

### Note Architetturali

- Usare `flutter_localizations` + `intl` con generazione automatica (convenzione standard Flutter).
- Per cambiare lingua senza riavvio, usare il `locale` parameter di `MaterialApp` avvolto in un `Consumer` che reagisce al LocaleProvider.
- Le traduzioni includono anche i nomi delle lingue stesse (es. "Italiano" in inglese diventa "Italian").
- Aggiungere altre lingue in futuro è semplice: basta un nuovo file ARB.

---

## US-23 — Toggle audio

**Priorità:** P1 | **Da giocatore**, voglio impostare la modalità audio come preferenza permanente.

### Tasks Tecniche

1. **[Toggle Audio in Impostazioni]** — Widget toggle per preferenza audio
   - File: `lib/features/settings/widgets/audio_toggle.dart`
   - Dipende da: EPIC-05 US-13 Task 2 (FormatPreferenceProvider)
   - Dettaglio: SwitchListTile: "Modalità audio predefinita", descrizione: "Le partite partono in modalità audio". On/Off. Quando attivo, `isAudioMode = true` nelle nuove partite.

2. **[Persistenza Preferenza]** — Salvare preferenza su Appwrite e locale
   - File: `lib/providers/quiz/format_preference_provider.dart`
   - Dipende da: Task 1
   - Dettaglio: Già implementato in US-13. Verificare che il toggle in impostazioni aggiorni correttamente il provider.

### Casi di Test

- **Widget Test:** `AudioToggle` — switch off → `isAudioMode = false`, switch on → `isAudioMode = true`.
- **Integration Test:** Attiva toggle audio in impostazioni → chiudi app → riapri → nuova partita parte in audio.
- **Test Case 1:** Toggle ON → nuova partita → parte in audio → format selector mostra audio pre-selezionato.
- **Test Case 2:** Toggle OFF → nuova partita → parte in scritta.

### Note Architetturali

- La preferenza audio è la stessa usata da US-13 (format selector): se attiva, il format selector pre-seleziona audio.
- Salvare la preferenza in Appwrite (`users.audioMode`) per sincronizzare tra dispositivi.

---

## US-24 — Tema chiaro/scuro

**Priorità:** P2 | **Da utente**, voglio scegliere tra tema chiaro e scuro.

### Tasks Tecniche

1. **[Tema Chiaro e Scuro]** — Definire ThemeData light e dark completi
   - File: `lib/app/theme/theme_data.dart`
   - Dipende da: DESIGN.md (colori, font, componenti)
   - Dettaglio: Creare due `ThemeData`: light (basato su palette slate chiaro) e dark (basato su palette slate scuro). Includere: colorScheme, textTheme (con Outfit e Inter), cardTheme, inputDecorationTheme, elevatedButtonTheme, bottomNavigationBarTheme, dialogTheme. Applicare tutti i design tokens da DESIGN.md (radius, spacing).

2. **[Provider Tema]** — State management per il tema
   - File: `lib/providers/settings/theme_provider.dart`
   - Dipende da: Task 1
   - Dettaglio: Provider con tre stati: "system", "light", "dark". Default: system. Persiste su Appwrite (campo `preferredTheme` in `users`) e su SharedPreferences. Espone `ThemeMode` per MaterialApp.

3. **[Schermata Impostazioni — Tema]** — UI per selezionare tema
   - File: `lib/features/settings/theme_settings_screen.dart`
   - Dipende da: Task 2
   - Dettaglio: Tre opzioni: "🌗 Segui sistema", "☀️ Chiaro", "🌙 Scuro". Radio button o segmented control. Anteprima del tema. Applicazione immediata.

4. **[Integrazione con MaterialApp]** — Applicare tema scelto
   - File: `lib/app/app.dart`
   - Dipende da: Task 2
   - Dettaglio: `MaterialApp(themeMode: ref.watch(themeProvider))`. Il tema viene applicato in tempo reale al cambio di impostazione.

### Casi di Test

- **Widget Test:** `ThemeSettingsScreen` — "Segui sistema" pre-selezionato, tap "Scuro" → tema cambia.
- **Integration Test:** Seleziona tema scuro → chiudi app → riapri → tema scuro ancora attivo. Cambia in chiaro → tema cambia immediatamente.
- **Test Case 1:** Tema = system → dispositivo in dark mode → app dark. Dispositivo in light → app light.
- **Test Case 2:** Tema = light forzato → app sempre light, ignora impostazioni di sistema.

### Note Architetturali

- Il `ThemeData` deve incorporare tutto il design system da DESIGN.md: colori, font (Outfit per headings, Inter per body), radius, spaziature, ombre.
- L'approccio standard Flutter con `ThemeData` è sufficiente per v1. Per temi più complessi, valutare `theme_extension`.
- Dark mode non è "light mode con colori invertiti" ma ha la sua palette dedicata.
- La persistenza usa sia SharedPreferences (per velocità) sia Appwrite (per sincronizzazione cross-device).
