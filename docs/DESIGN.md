# DESIGN.md — Language Game

> Sistema di design: look & feel, palette, tipografia, componenti e animazioni.
> Target: app mobile moderna, professionale, colorata — che trasmette energia e voglia di imparare.

---

## 1. Filosofia di design

Language Game è un gioco, non un corso di lingue. Il design deve riflettere:

- **Giocosità controllata** — colori vivaci ma non infantili, animazioni fluide ma non stucchevoli
- **Chiarezza** — ogni schermata comunica un'azione singola. Zero confusione
- **Internazionalità** — il design deve funzionare con testi in alfabeti latini, arabi, CJK, cirillici
- **Reward** — ogni interazione positiva ha un feedback visivo (colori, micro-animazioni)

> **Motto di design:** *"Sembra un gioco premium, si usa con un dito solo."*

---

## 2. Palette colori

### 2.1 Colori primari

| Ruolo | Nome | HEX | Esempio |
|-------|------|-----|---------|
| **Primario** | Indaco | `#4F46E5` | Intestazioni, pulsanti primari, link |
| **Primario chiaro** | Indaco chiaro | `#818CF8` | Stati hover, sfondi leggeri |
| **Primario scuro** | Indaco scuro | `#3730A3` | Testo su sfondo chiaro, stati attivi |
| **Secondario** | Teal | `#0D9488` | Badge, chip, accenti secondari |
| **Secondario chiaro** | Teal chiaro | `#5EEAD4` | Glow, highlight, sfondi secondari |

### 2.2 Colori accent (energia, ricompense, streak)

| Ruolo | Nome | HEX | Uso |
|-------|------|-----|-----|
| **Accento** | Ambra | `#F59E0B` | Streak, badge speciali, stelle |
| **Accento glow** | Ambra chiaro | `#FDE68A` | Sfondo streak, glow effetti |
| **Energia** | Corallo | `#FB7185` | Moltiplicatori, alert morbidi |
| **Energia chiaro** | Rosa | `#FCE7F3` | Sfondo per sezioni "calde" |

### 2.3 Colori funzionali (feedback di gioco)

| Ruolo | HEX | Uso |
|-------|-----|-----|
| **Successo** | `#10B981` (Smeraldo) | Risposta corretta, badge completato |
| **Errore** | `#F43F5E` (Rose) | Risposta sbagliata, timer scaduto |
| **Info** | `#0EA5E9` (Sky) | Indizi, suggerimenti, onboarding |
| **Warning** | `#F59E0B` (Ambra) | Streak a rischio, avvisi soft |

### 2.4 Neutri (sfondi, superfici, testo)

| Ruolo | Light HEX | Dark HEX |
|-------|-----------|----------|
| **Sfondo** | `#F8FAFC` (Slate 50) | `#0F172A` (Slate 900) |
| **Superficie** | `#FFFFFF` | `#1E293B` (Slate 800) |
| **Superficie elevata** | `#F1F5F9` (Slate 100) | `#334155` (Slate 700) |
| **Bordi/divider** | `#E2E8F0` (Slate 200) | `#475569` (Slate 600) |
| **Testo primario** | `#0F172A` (Slate 900) | `#F8FAFC` (Slate 50) |
| **Testo secondario** | `#64748B` (Slate 500) | `#94A3B8` (Slate 400) |
| **Testo terziario** | `#94A3B8` (Slate 400) | `#64748B` (Slate 500) |

### 2.5 Gradienti

| Nome | Da → A | Uso |
|------|--------|-----|
| **Primary Gradient** | `#4F46E5` → `#0D9488` | Hero, header schermate principali |
| **Streak Gradient** | `#F59E0B` → `#FB7185` | Badge streak, schermate ricompensa |
| **Correct Gradient** | `#10B981` → `#0D9488` | Schermata risposta corretta |
| **Dark Gradient** | `#0F172A` → `#1E293B` | Sfondi dark mode (sottile) |

> **Nota:** I gradienti si applicano sempre con angolo di 135° (dal basso a sinistra all'alto a destra) per coerenza.

---

## 3. Tipografia

### 3.1 Font family

| Ruolo | Font | Peso | Fallback |
|-------|------|------|----------|
| **Headings (H1-H3)** | `Outfit` | Bold (700) | `SF Pro Display` / `Roboto` |
| **Headings (H4-H6)** | `Outfit` | Semibold (600) | `SF Pro Display` / `Roboto` |
| **Body** | `Inter` | Regular (400) | `SF Pro Text` / `Roboto` |
| **Body emphasized** | `Inter` | Medium (500) | `SF Pro Text` / `Roboto` |
| **Label / Button** | `Inter` | Semibold (600) | `SF Pro Text` / `Roboto` |
| **Caption / Small** | `Inter` | Medium (500) | `SF Pro Text` / `Roboto` |

**Perché Outfit + Inter?**
- **Outfit**: geometrico, pulito, leggibile anche su schermi piccoli. Dà carattere senza essere invadente
- **Inter**: ottimizzato per schermi, eccellente leggibilità, perfetto per testi lunghi e UI
- Entrambi supportano bene il latino. Per alfabeti non latini si usano i fallback Noto

### 3.2 Font stack per lingue non latine

Per supportare tutte le lingue del gioco, il font stack deve includere fallback specifici:

```
Latin:         Outfit / Inter → system fallback
Arabo:         Outfit / Inter → Noto Naskh Arabic → system
CJK (ja/zh):  Outfit / Inter → Noto Sans JP / Noto Sans SC → system
Coreano:       Outfit / Inter → Noto Sans KR → system
Cirillico:     Outfit / Inter → Noto Sans → system
Greco:         Outfit / Inter → Noto Sans → system
Hindi/Devanagari: Outfit / Inter → Noto Sans Devanagari → system
```

**Approccio Flutter:** caricare solo Outfit e Inter via Google Fonts, poi configurare `fontFamilyFallback` nel `ThemeData` con i Noto font necessari.

### 3.3 Type scale

| Livello | Dimensione | Altezza riga | Tracking | Peso | Uso |
|---------|-----------|-------------|---------|------|-----|
| **H1** | 32pt | 40px | -1% | Bold | Schermata titolo, punteggio |
| **H2** | 28pt | 36px | -0.5% | Bold | Sezioni principali |
| **H3** | 24pt | 32px | 0% | Bold | Card title, modal title |
| **H4** | 20pt | 28px | 0% | Semibold | Sottotitoli |
| **H5** | 18pt | 26px | 0% | Semibold | Categorie, gruppi |
| **H6** | 16pt | 24px | 0% | Semibold | Label sezione |
| **Body L** | 17pt | 26px | 0% | Regular | Parola del quiz (testo grande) |
| **Body** | 15pt | 22px | 0% | Regular / Medium | Testo generale |
| **Body S** | 13pt | 20px | 0% | Regular | Dettagli, metadati |
| **Caption** | 12pt | 16px | 0.5% | Medium | Badge, timbri, etichette |
| **Label** | 14pt | 20px | 0.5% | Semibold | Pulsanti, tab bar |
| **Overline** | 11pt | 14px | 1.5% | Semibold | Overline decorativo |

> **Nota:** La parola del quiz in modalità scrittura usa **Body L** (o più grande su schermi grandi) per essere ben leggibile. In casi di lingue con alfabeti densi (CJK, arabo), si può scalare automaticamente.

### 3.4 Gerarchia sui colori

- Headings: **Testo primario** (Slate 900 / Slate 50)
- Body: **Testo primario** con peso Regular
- Body secondario: **Testo secondario** per dettagli meno importanti
- Caption / Overline: **Testo secondario** o **colore primary** se decorativo
- Link: **Primary** (#4F46E5)
- Errore: **Rose** (#F43F5E) in peso Medium

---

## 4. Spaziatura e layout

### 4.1 Spazio base

Il sistema usa una griglia di 4px come unità atomica.

| Token | Pixel | Uso comune |
|-------|-------|------------|
| `space-1` | 4px | Gap icona-testo, padding interno chip |
| `space-2` | 8px | Gap tra elementi piccoli, padding badge |
| `space-3` | 12px | Padding orizzontale card piccole |
| `space-4` | 16px | Padding standard card, gap sezioni |
| `space-5` | 20px | Padding tab-bar, margine tra paragrafi |
| `space-6` | 24px | Gap tra sezioni, padding schermata |
| `space-8` | 32px | Margine tra blocchi principali |
| `space-10` | 40px | Sezioni hero, gap schermate |
| `space-12` | 48px | Padding top schermata, gap grandi |
| `space-16` | 64px | Sezioni distinte, margine massimo |

### 4.2 Layout schermata

- **Margine laterale standard:** 20px (space-5)
- **Larghezza massima contenuto:** 480px (comfort su iPhone SE → Pro Max)
- **Padding top:** 12px (space-3) dall'ultima safe area
- **Card border-radius:** 16px (arrotondato ma non troppo "morbido")
- **Bottom sheet border-radius:** 20px solo angoli superiori
- **Barra inferiore (tab):** altezza 60px

### 4.3 Responsività

L'app è mobile-first. Su tablet si applicano questi aggiustamenti:

- Margine laterale: 20px → 48px
- Griglia a 2 colonne per schede e statistiche
- Card più grandi (padding space-8 invece di space-4)

---

## 5. Componenti UI

### 5.1 Card

```
┌──────────────────────────────┐
│                              │
│   [Icona] Titolo             │
│   Testo descrizione          │
│                              │
│   [Pulsante]                 │
│                              │
└──────────────────────────────┘
```

- **Border-radius:** 16px
- **Padding:** 16px (space-4) interno
- **Ombra:** `y=2, blur=8, spread=0, colore=black@6%` (light) / `black@25%` (dark)
- **Sfondo:** Superficie (bianco / slate 800)
- **Stati:** elevate su tap (ombra più marcata)

**Varianti:**
- **Card colorata:** overlay primario/secondario con testo bianco
- **Card streak:** bordo ambra + glow leggero
- **Card compatta:** padding 12px, per elenchi

### 5.2 Pulsanti

| Tipo | Altezza | Padding H | Border-radius | Font |
|------|---------|-----------|---------------|------|
| **Primario (filled)** | 52px | 24px | 14px | Inter Semibold 16pt |
| **Secondario (outlined)** | 52px | 24px | 14px | Inter Semibold 16pt |
| **Terziario (text)** | 44px | 16px | 10px | Inter Medium 15pt |
| **Icon button** | 44px×44px | — | 12px | — |
| **Small** | 36px | 16px | 10px | Inter Semibold 13pt |
| **FAB** | 56px | — | 16px | — |

**Stati primario (filled):**
- **Default:** `#4F46E5` sfondo, testo bianco
- **Premuto:** `#3730A3` sfondo
- **Disabilitato:** `#94A3B8` sfondo, testo bianco 60%
- **Loading:** mostra spinner bianco, nasconde testo

**Stati secondario (outlined):**
- **Default:** bordo `#4F46E5`, testo `#4F46E5`, sfondo trasparente
- **Premuto:** sfondo `#4F46E5@8%` (sottile)
- **Disabilitato:** bordo `#CBD5E1`, testo `#94A3B8`

### 5.3 Input (risposta quiz)

```
┌──────────────────────────────┐
│  Scriyi la risposta...    [→] │
└──────────────────────────────┘
```

- **Altezza:** 56px
- **Border-radius:** 14px (coerente coi pulsanti)
- **Bordo:** `#E2E8F0` (light) / `#475569` (dark) — 1.5px
- **Focus:** bordo `#4F46E5` + glow subtle (`#4F46E5@15%`)
- **Errore:** bordo `#F43F5E` + shake animation
- **Successo:** bordo `#10B981` + brief glow verde
- **Padding:** 16px orizzontale, 14px verticale
- **Font:** Inter Regular 17pt (Body L)

### 5.4 Badge e chip

| Tipo | Padding | Border-radius | Font | Colori |
|------|---------|---------------|------|--------|
| **Badge lingua** | 8px 12px | 8px | Caption (11pt) | Sfondo `#EEF2FF`, testo `#4F46E5` |
| **Chip categoria** | 8px 14px | 20px (pill) | Label (14pt) | Sfondo superficie + bordo |
| **Badge punteggio** | 6px 10px | 6px | Caption (11pt) | Dinamico per colore |
| **Badge streak** | 8px 12px | 8px | Caption (11pt) | Ambra (`#F59E0B`) + icon🔥 |

### 5.5 Barra di navigazione (bottom tab)

- **Altezza:** 60px
- **Stile:** Trasparente con blur dietro (o superficie con border-top sottile)
- **Icone:** outlined quando inattive, filled quando attive
- **Colore attivo:** `#4F46E5`
- **Colore inattivo:** `#94A3B8`
- **Label:** 11pt, Semibold, mostra solo sotto l'icona
- **Tab:** massimo 5 icone

### 5.6 Schermata quiz — elementi speciali

**Carta parola (centrale):**
```
┌──────────────────────────────┐
│                              │
│          [Bandiera]          │
│         Tedesco              │
│                              │
│       ┌────────────┐        │
│       │            │        │
│       │   Apfel    │        │
│       │            │        │
│       └────────────┘        │
│                              │
│     Indizio: 2/8 lingue     │
│                              │
└──────────────────────────────┘
```

- La parola è al centro, font **Outfit Bold 32pt** (H1)
- La lingua è sopra, **Caption 11pt** uppercase + tracking
- Bandierina (emoji) accanto al nome lingua
- La card ha padding 32px e sfondo superficie
- Leggero effetto "floating" colore primario sul bordo laterale

**Barra progresso (10 Sfida):**
- 10 pallini orizzontali
- Completato: `#10B981` (pieno)
- Corrente: `#4F46E5` (pieno + glow)
- Futuro: `#E2E8F0` (vuoto)
- Errore: `#F43F5E` (vuoto con bordo rosso)
- **Diametro pallini:** 10px, gap 6px

**Timer (10 Sfida):**
- Cerchio con bordo animato (stroke circolare progressivo)
- **Start:** bordo `#4F46E5`
- **Warning (< 3s):** bordo `#F59E0B` + leggero pulse
- **Critical (< 1s):** bordo `#F43F5E` + pulse più rapido
- **Diametro:** 48px
- **Testo al centro:** secondi rimanenti, Inter Semibold

---

## 6. Iconografia

### 6.1 Set icone

- **Set:** Phosphor Icons (o Lucide Icons) — tratto coerente, stile outline
- **Dimensione default:** 24px
- **Dimensione piccola:** 20px (dentro chip, badge)
- **Dimensione grande:** 32-40px (schermate vuote, onboarding)
- **Peso tratto:** 2px (consistente su tutte)
- **Colore:** ereditato dal contesto (text-primary di solito)

### 6.2 Icone principali

| Schermo | Icona |
|---------|-------|
| Home | `house` |
| Gioca | `play-circle` |
| Classifiche | `trophy` |
| Profilo | `user` |
| Impostazioni | `gear` |
| Indovina Parola | `lightbulb` |
| 10 Sfida | `lightning` |
| Audio | `speaker-high` |
| Scritta | `text-aa` |
| Corretto | `check-circle` |
| Sbagliato | `x-circle` |
| Streak | `fire` |
| Badge | `medal` |
| Daily | `calendar-star` |
| Condividi | `share-fill` |
| Audio play | `play` |

### 6.3 Bandiere

Le lingue sono rappresentate da **emoji bandiera** (`🇩🇪`, `🇯🇵`, `🇫🇷`, ecc.) — nessuna immagine personalizzata. Vantaggi:

- Zero asset da mantenere
- Funzionano subito per tutte le lingue
- Scalano perfettamente
- Aggiornate automaticamente dal sistema operativo

---

## 7. Animazioni e transizioni

### 7.1 Timing

| Tipo | Durata | Curva easing |
|------|--------|-------------|
| Tap feedback | 100ms | `easeOut` |
| Hover / stato | 150ms | `easeOut` |
| Transizione schermata | 300ms | `easeInOut` (curve `easeInOutCubicEmphasized` su Flutter) |
| Card appear | 400ms | `easeOutBack` (leggero overshoot) |
| Parola nuova | 350ms | `easeOut` |
| Risposta corretta | 500ms | `easeOut` |
| Risposta sbagliata | 300ms | `easeInOut` |
| Ricompensa (confetti) | 1200ms | `easeOut` |
| Streak badge | 600ms | `easeOutBack` |
| Timer urgente | 300ms | `linear` (pulse) |

### 7.2 Micro-interazioni

| Elemento | Comportamento |
|----------|--------------|
| **Pulsante tap** | Scale da 1.0 a 0.97 in 100ms, poi ritorno |
| **Card tap** | Elevazione aumenta (ombra più marcata + leggero lift y=-2) |
| **Input focus** | Bordo cambia colore + glow appare, label fluttua su |
| **Risposta corretta** | Card diventa verde dal bordo verso l'interno (riempimento), checkmark animata |
| **Risposta sbagliata** | Card vibra orizzontalmente (shake) + bordo rosso + X appena |
| **Nuova parola** | Slide up + fade in (da y=20, opacità 0 → y=0, opacità 1) |
| **Timer che scende** | Il tratto circolare si accorcia. A <3s il badge pulse (scale 1.0↔1.05) |
| **Streak count-up** | Numero scorre verso l'alto (digit counter animation) |
| **Badge sbloccato** | Icona ruota su asse Y (flip) + glow |
| **Bottom tab switch** | Icona rotola leggermente + colore cambia con crossfade |

### 7.3 Schermate di transizione

- **Push (nuova schermata):** slide da destra (default Flutter)
- **Modal / Bottom sheet:** slide up + sfondo si oscura (opacità 0→40%)
- **Fine partita → riepilogo:** la card del punteggio scala da 0.8 a 1.0 con fade, poi gli elementi appaiono in sequenza con stagger (ritardo 80ms l'uno dall'altro)

---

## 8. Dark mode

### 8.1 Filosofia

Dark mode non è "light mode con sfondo nero". La palette dark è studiata per:

- Ridurre l'affaticamento visivo durante sessioni lunghe
- Far risaltare i colori primari (l'indaco brilla sullo slate scuro)
- Mantenere la gerarchia visiva chiara

### 8.2 Regole

- **Sfondo:** Slate 900 (`#0F172A`) — non nero puro, più morbido
- **Superficie:** Slate 800 (`#1E293B`)
- **Elevazione:** più chiara è la superficie, più è "sopra" (slate 700 per card elevate, slate 600 per dialog)
- **Ombre:** black `@25%` invece di `@6%`
- **Colori primari:** invariati (l'indaco funziona bene su entrambi)
- **Testo primario:** Slate 50 (`#F8FAFC`)
- **Testo secondario:** Slate 400 (`#94A3B8`)
- **Bordi:** Slate 600 (`#475569`)
- **Overlay modale:** black `@60%`

### 8.3 Toggle

- L'app segue **le impostazioni di sistema** di default
- L'utente può forzare light/dark dalle impostazioni app
- Persistenza in Appwrite (campo `preferredTheme` su profile)

---

## 9. Spazi vuoti (empty state)

Le schermate vuote seguono una struttura fissa:

```
         ┌────┐
         │icon│    (64×64px, colore secondario)
         └────┘
           
        Titolo    (H3, testo primario)
     Descrizione  (Body, testo secondario)
           
      [Pulsante]  (primario o outlined)
```

**Esempi:**
- **Nessuna partita:** icona `game-controller` + "Nessuna partita ancora" + "Inizia la tua prima sfida!" + [Gioca ora]
- **Nessuna classifica:** icona `trophy` + "Classifica vuota" + "Le classifiche si popolano quando giochi"
- **Nessun badge:** icona `medal` + "Ancora nessun badge" + "Completa obiettivi per sbloccare badge"

---

## 10. Schermo onboarding / tutorial

- **3-4 slide**, swipe orizzontale
- Sfondo: gradient primario (Indaco → Teal)
- Testo bianco, corpo Inter Regular 17pt
- Illustrazioni: grandi (60% schermo), emoji-based o icona grande
- Dots indicator: pallini bianchi con opacità (attivo: 100%, inattivo: 40%)
- Pulsante "Avanti" / "Inizia" bianco con testo indaco

---

## 11. Risorse e asset

### 11.1 Icona app

- **Forma:** non è necessario un logo complesso. Un **globo stilizzato** con uno **stroke a forma di "L"** (Language) o un **dialog bubble multicolore**
- **Sfondo:** gradient Indaco → Teal
- **Colore icona:** bianco
- **Formato:** mascherabile (iOS) / adaptive (Android)

### 11.2 Splash screen

- Sfondo: gradient primario
- Al centro: icona app bianca + nome "Language Game" in Outfit Bold 28pt
- Durata: 1.5-2s massimo

---

## 12. Accessibilità

- **Touch target minimo:** 44×44px (Apple HIG) — tutti i pulsanti e icone tappabili lo rispettano
- **Contrasto testo:** minimo 4.5:1 per testo normale, 3:1 per testo grande (WCAG AA)
- **Testo scalabile:** supporto `MediaQuery.textScaleFactor` per utenti che ingrandiscono i font
- **Stato focus visibile:** bordi e glow su elementi focalizzati (per navigazione a tastiera / switch control)
- **Non affidarsi solo ai colori:** lo stato corretto/sbagliato è comunicato da icona + colore + testo

---

## 13. Design tokens (riepilogo per implementazione)

Questi token sono da mappare direttamente in `ThemeData` Flutter.

### Colori

```dart
// lib/app/theme/colors.dart

class AppColors {
  // Primary
  static const primary = Color(0xFF4F46E5);
  static const primaryLight = Color(0xFF818CF8);
  static const primaryDark = Color(0xFF3730A3);
  static const primaryContainer = Color(0xFFEEF2FF);

  // Secondary
  static const secondary = Color(0xFF0D9488);
  static const secondaryLight = Color(0xFF5EEAD4);
  static const secondaryContainer = Color(0xFFF0FDFA);

  // Accent / Energy
  static const accent = Color(0xFFF59E0B);
  static const accentLight = Color(0xFFFDE68A);
  static const energy = Color(0xFFFB7185);
  static const energyLight = Color(0xFFFCE7F3);

  // Functional
  static const success = Color(0xFF10B981);
  static const error = Color(0xFFF43F5E);
  static const info = Color(0xFF0EA5E9);
  static const warning = Color(0xFFF59E0B);

  // Neutrals Light
  static const backgroundLight = Color(0xFFF8FAFC);
  static const surfaceLight = Color(0xFFFFFFFF);
  static const surfaceElevatedLight = Color(0xFFF1F5F9);
  static const borderLight = Color(0xFFE2E8F0);
  static const textPrimaryLight = Color(0xFF0F172A);
  static const textSecondaryLight = Color(0xFF64748B);
  static const textTertiaryLight = Color(0xFF94A3B8);

  // Neutrals Dark
  static const backgroundDark = Color(0xFF0F172A);
  static const surfaceDark = Color(0xFF1E293B);
  static const surfaceElevatedDark = Color(0xFF334155);
  static const borderDark = Color(0xFF475569);
  static const textPrimaryDark = Color(0xFFF8FAFC);
  static const textSecondaryDark = Color(0xFF94A3B8);
  static const textTertiaryDark = Color(0xFF64748B);
}
```

### Tipografia

```dart
// lib/app/theme/typography.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  static const _fallback = ['Noto Sans', 'Roboto', 'system-ui'];

  // Heading
  static final h1 = GoogleFonts.outfit(
    fontSize: 32,
    height: 40 / 32,
    letterSpacing: -0.01,
    fontWeight: FontWeight.w700,
  );
  static final h2 = GoogleFonts.outfit(
    fontSize: 28,
    height: 36 / 28,
    letterSpacing: -0.005,
    fontWeight: FontWeight.w700,
  );
  static final h3 = GoogleFonts.outfit(
    fontSize: 24,
    height: 32 / 24,
    letterSpacing: 0,
    fontWeight: FontWeight.w700,
  );
  static final h4 = GoogleFonts.outfit(
    fontSize: 20,
    height: 28 / 20,
    letterSpacing: 0,
    fontWeight: FontWeight.w600,
  );
  static final h5 = GoogleFonts.outfit(
    fontSize: 18,
    height: 26 / 18,
    letterSpacing: 0,
    fontWeight: FontWeight.w600,
  );
  static final h6 = GoogleFonts.outfit(
    fontSize: 16,
    height: 24 / 16,
    letterSpacing: 0,
    fontWeight: FontWeight.w600,
  );

  // Body
  static final bodyLarge = GoogleFonts.inter(
    fontSize: 17,
    height: 26 / 17,
    letterSpacing: 0,
    fontWeight: FontWeight.w400,
  );
  static final body = GoogleFonts.inter(
    fontSize: 15,
    height: 22 / 15,
    letterSpacing: 0,
    fontWeight: FontWeight.w400,
  );
  static final bodySmall = GoogleFonts.inter(
    fontSize: 13,
    height: 20 / 13,
    letterSpacing: 0,
    fontWeight: FontWeight.w400,
  );

  // Label / Button
  static final label = GoogleFonts.inter(
    fontSize: 14,
    height: 20 / 14,
    letterSpacing: 0.005,
    fontWeight: FontWeight.w600,
  );
  static final button = GoogleFonts.inter(
    fontSize: 16,
    height: 24 / 16,
    letterSpacing: 0,
    fontWeight: FontWeight.w600,
  );

  // Caption
  static final caption = GoogleFonts.inter(
    fontSize: 12,
    height: 16 / 12,
    letterSpacing: 0.005,
    fontWeight: FontWeight.w500,
  );
  static final overline = GoogleFonts.inter(
    fontSize: 11,
    height: 14 / 11,
    letterSpacing: 0.015,
    fontWeight: FontWeight.w600,
  );
}
```

### Spaziatura

```dart
// lib/app/theme/spacing.dart

class AppSpacing {
  static const double space1 = 4;
  static const double space2 = 8;
  static const double space3 = 12;
  static const double space4 = 16;
  static const double space5 = 20;
  static const double space6 = 24;
  static const double space8 = 32;
  static const double space10 = 40;
  static const double space12 = 48;
  static const double space16 = 64;
}
```

### Bordi (radius)

```dart
// lib/app/theme/borders.dart

class AppRadius {
  static const double sm = 6;
  static const double md = 10;
  static const double lg = 14;
  static const double xl = 16;
  static const double pill = 20;
  static const double full = 999;
}
```

---

## 14. Moodboard visiva (descrittiva)

Se dovessi descrivere Language Game in 3 riferimenti stilistici:

1. **Duolingo** — per la giocosità, i colori vivaci, le ricompense visive
2. **NYT Crossword / Wordle** — per la pulizia, la chiarezza, l'esperienza premium
3. **Headspace** — per le animazioni fluide, le transizioni morbide, la cura nei dettagli

> **In una frase:** Language Game è il Wordle delle lingue, colorato come Duolingo, fluido come Headspace.

---

*Documento curato da: Language Game Design Team*
*Versione: 1.0 — Base per implementazione tema Flutter*
