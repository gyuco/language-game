# EPIC 11 — Onboarding

**Priorità:** P0
**Epic:** Onboarding
**Storie:** US-25 (Tutorial prima apertura)

---

## US-25 — Tutorial prima apertura

**Priorità:** P0 | **Da nuovo utente**, voglio un breve tutorial alla prima apertura.

### Tasks Tecniche

1. **[Provider Onboarding]** — Provider per gestire stato onboarding
   - File: `lib/providers/onboarding/onboarding_provider.dart`
   - Dipende da: EPIC-01 US-01 Task 3 (AuthProvider)
   - Dettaglio: Provider che verifica se il tutorial è già stato mostrato (SharedPreferences/Isar chiave `onboarding_completed`). Se no, forza mostra tutorial. Dopo completamento, salva flag. Alla prima apertura dopo registrazione, non mostra.

2. **[Schermata Onboarding]** — Tutorial a 3-4 slide
   - File: `lib/features/onboarding/onboarding_screen.dart`
   - Dipende da: Task 1
   - Dettaglio: PageView con 3-4 slide. Sfondo: gradiente primario (Indaco → Teal). Testo bianco. Illustrazioni grandi (emoji-based 60% schermo). Dots indicator. Pulsante "Avanti" / "Salta" su ogni slide. Ultima slide: "Inizia" (bianco con testo indaco).

3. **[Slide Onboarding 1]** — "Benvenuto in Language Game"
   - File: `lib/features/onboarding/slides/welcome_slide.dart`
   - Dipende da: Task 2
   - Dettaglio: Icona globo/chat + titolo "Language Game" + "Impara e sfidati in tutte le lingue del mondo".

4. **[Slide Onboarding 2]** — "Come si gioca"
   - File: `lib/features/onboarding/slides/how_to_play_slide.dart`
   - Dipende da: Task 2
   - Dettaglio: Icona lightbulb + "Indovina la parola" + "Ti mostriamo una parola in una lingua straniera. Scrivi il significato nella tua lingua. Sbagli? Ti diamo un indizio in un'altra lingua!".

5. **[Slide Onboarding 3]** — "Modalità di gioco"
   - File: `lib/features/onboarding/slides/game_modes_slide.dart`
   - Dipende da: Task 2
   - Dettaglio: Icone lightning + trophy + "10 Sfida, Sfida Daily, Classifiche" + "Scegli la tua sfida e accumula punti. Più giochi, più sblocchi!".

6. **[Slide Onboarding 4]** — "Pronto?"
   - File: `lib/features/onboarding/slides/ready_slide.dart`
   - Dipende da: Task 2
   - Dettaglio: Icona rocket + "Sei pronto a imparare?" + Pulsante "Inizia!". Dopo tap, naviga alla home e salva onboarding completato.

7. **[Navigazione Condizionale Onboarding]** — Router che decide se mostrare onboarding o home
   - File: `lib/app/router.dart` (modifica)
   - Dipende da: Tasks 1-6
   - Dettaglio: Dopo auth (splash), se onboarding non completato → naviga a onboarding. Se completato → naviga a home. Aggiornare già esistente EPIC-01 US-01 Task 5.

### Casi di Test

- **Unitario:** `OnboardingProvider.isCompleted()` — prima apertura → false. Dopo completamento → true.
- **Widget Test:** `OnboardingScreen` — 4 slide, swipe funzionante, dots si aggiornano, ultima slide mostra "Inizia".
- **Integration Test:** Prima apertura → onboarding → swipe a destra 3 volte → "Inizia" → home. Riapri app → home direttamente (no onboarding).
- **Test Case 1:** Prima apertura → splash → onboarding → completa → home.
- **Test Case 2:** Seconda apertura → splash → home (salta onboarding).
- **Test Case 3:** Tap "Salta" su slide 2 → onboarding termina → home.

### Note Architetturali

- Il flag di completamento è salvato in SharedPreferences/Isar (locale) e opzionalmente su Appwrite (per sincronizzazione multi-dispositivo).
- La navigazione è gestita dal router: dopo l'auth check, se onboarding non completato → redirect a onboarding.
- Il design segue lo specifico DESIGN.md sezione 10: gradiente primario, testo bianco, dots indicator, illustrazioni grandi.
- Le slide sono widget separati per manutenibilità e futura personalizzazione per lingua.
