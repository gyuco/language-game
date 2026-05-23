# User Stories — Language Game

> Storie utente organizzate per epic, con criteri di accettazione.
> Priorità: **P0** = MVP (v0.1), **P1** = v0.2, **P2** = v0.3, **P3** = future

---

## Epic 1: Autenticazione e Profilo

### US-01 — Accesso anonimo
| Campo | Valore |
|-------|--------|
| **Priorità** | P0 |
| **Story** | **Da giocatore occasionale**, voglio poter iniziare a giocare immediatamente senza registrazione, così da provare l'app senza barriere. |
| **Note** | L'account anonimo è persistente sul dispositivo. Opzione di upgrade a account registrato in un secondo momento. |

**Criteri di accettazione:**
- [ ] Alla prima apertura, l'app crea automaticamente una sessione anonima via Appwrite
- [ ] L'utente può giocare a tutte le modalità disponibili senza registrazione
- [ ] I progressi vengono salvati localmente (e sul backend se connesso)
- [ ] Se l'utente cancella i dati dell'app, perde l'accesso all'account anonimo

---

### US-02 — Registrazione account
| Campo | Valore |
|-------|--------|
| **Priorità** | P0 |
| **Story** | **Da giocatore abituale**, voglio registrarmi con email e password, così da sincronizzare i miei progressi tra più dispositivi. |

**Criteri di accettazione:**
- [ ] L'utente può registrarsi con email + password
- [ ] L'utente può fare login con email + password
- [ ] L'utente può fare logout
- [ ] Se l'utente era in sessione anonima e si registra, i dati anonimi vengono uniti al nuovo account
- [ ] C'è un'opzione "Recupera password" via email
- [ ] Il form di registrazione mostra errori chiari (email già usata, password debole, ecc.)

---

### US-03 — Profilo utente
| Campo | Valore |
|-------|--------|
| **Priorità** | P1 |
| **Story** | **Da giocatore registrato**, voglio vedere e modificare il mio profilo, così da personalizzare la mia esperienza. |

**Criteri di accettazione:**
- [ ] Schermata profilo accessibile dal tab o dal menu
- [ ] Mostra: nome visualizzato, email, punteggio totale, streak, data di iscrizione
- [ ] L'utente può modificare il nome visualizzato
- [ ] L'utente può cambiare la lingua madre preferita
- [ ] Opzione per eliminare l'account con conferma esplicita

---

### US-04 — Persistenza sessione
| Campo | Valore |
|-------|--------|
| **Priorità** | P0 |
| **Story** | **Da giocatore**, voglio che la mia sessione rimanga attiva tra un'avvio e l'altro dell'app, così da non dover rifare login ogni volta. |

**Criteri di accettazione:**
- [ ] Appwrite gestisce il token di sessione in automatico
- [ ] Alla riapertura dell'app, l'utente è già autenticato
- [ ] Se il token scade, l'app tenta un refresh silenzioso
- [ ] Se il refresh fallisce, mostra schermata di login

---

## Epic 2: Indovina la Parola

### US-05 — Giocare a "Indovina la Parola"
| Campo | Valore |
|-------|--------|
| **Priorità** | P0 |
| **Story** | **Da giocatore**, voglio giocare a "Indovina la Parola", così da mettere alla prova la mia conoscenza delle lingue. |

**Criteri di accettazione:**
- [ ] L'app mostra una parola in una lingua straniera (scritta o pronunciata)
- [ ] L'utente scrive la traduzione nella sua lingua madre
- [ ] L'app valida la risposta (case-insensitive, trimming)
- [ ] L'utente può passare alla parola successiva in qualsiasi momento
- [ ] A fine partita mostra riepilogo con: parola corretta, lingue viste, punteggio
- [ ] La partita viene salvata nella cronologia

---

### US-06 — Indizi progressivi in altre lingue
| Campo | Valore |
|-------|--------|
| **Priorità** | P0 |
| **Story** | **Da giocatore**, quando sbaglio una risposta voglio vedere la stessa parola in un'altra lingua, così da avere un indizio per indovinare. |

**Criteri di accettazione:**
- [ ] Ogni risposta sbagliata mostra la parola in una lingua diversa (stesso significato)
- [ ] Le lingue vengono rivelate in ordine casuale predefinito
- [ ] Massimo 7-8 tentativi per parola
- [ ] Dopo l'ultimo tentativo, la parola viene svelata con traduzione e lingue
- [ ] La bandiera della lingua corrente è sempre visibile accanto alla parola

---

### US-07 — Punteggio decrescente
| Campo | Valore |
|-------|--------|
| **Priorità** | P0 |
| **Story** | **Da giocatore**, voglio che il punteggio sia inversamente proporzionale al numero di indizi usati, così da essere premiato per le risposte rapide. |

**Criteri di accettazione:**
- [ ] Punteggio per tentativo: 1° = 5pt, 2° = 4pt, 3° = 3pt, 4-5° = 2pt, 6+ = 1pt
- [ ] Parola svelata = 0pt
- [ ] Il punteggio viene mostrato durante e dopo la partita
- [ ] Il punteggio della partita viene sommato al totale utente

---

## Epic 3: 10 Sfida

### US-08 — Giocare a "10 Sfida"
| Campo | Valore |
|-------|--------|
| **Priorità** | P0 |
| **Story** | **Da giocatore**, voglio giocare alla modalità "10 Sfida", così da mettermi alla prova con 10 parole consecutive in lingue diverse. |

**Criteri di accettazione:**
- [ ] L'app mostra 10 parole una dopo l'altra, ciascuna in lingua casuale
- [ ] Ogni parola ha un timer di 10 secondi visibile
- [ ] L'utente scrive la risposta e la conferma
- [ ] Risposta corretta → si passa alla parola successiva
- [ ] Risposta sbagliata o timeout → si passa alla parola successiva (nessuna penalità oltre al reset streak)
- [ ] A fine partita mostra riepilogo: punteggio, streak massima, corrette/totali

---

### US-09 — Timer visivo
| Campo | Valore |
|-------|--------|
| **Priorità** | P0 |
| **Story** | **Da giocatore**, voglio vedere chiaramente il countdown di 10 secondi, così da sapere quanto tempo mi resta. |

**Criteri di accettazione:**
- [ ] Timer mostrato come cerchio con bordo animato (stroke circolare)
- [ ] Colore del bordo: normale → warning a 3s → critical a 1s
- [ ] Secondi mostrati al centro del cerchio
- [ ] A 3s: leggero pulse del cerchio
- [ ] A 0s: timer scade automaticamente, passa alla parola successiva

---

### US-10 — Moltiplicatore streak
| Campo | Valore |
|-------|--------|
| **Priorità** | P0 |
| **Story** | **Da giocatore**, voglio che le risposte consecutive corrette aumentino il mio punteggio, così da essere incentivato a fare meglio. |

**Criteri di accettazione:**
- [ ] Prima corretta = 1pt, seconda = 2pt, ... decima = 10pt
- [ ] Risposta sbagliata o timeout resetta il moltiplicatore a 1
- [ ] Lo streak corrente è sempre visibile durante la partita
- [ ] Animazione quando lo streak aumenta (numero che scorre)
- [ ] Massimo punteggio teorico: 55pt (1+2+...+10)

---

## Epic 4: Infinity

### US-11 — Modalità Infinity
| Campo | Valore |
|-------|--------|
| **Priorità** | P2 |
| **Story** | **Da giocatore esperto**, voglio una modalità senza limite di parole che continua finché non sbaglio, così da sfidare me stesso a raggiungere streak sempre più lunghi. |

**Criteri di accettazione:**
- [ ] Stessa meccanica di "10 Sfida" ma senza limite di 10 parole
- [ ] Il gioco termina solo quando l'utente sbaglia o esce
- [ ] Il punteggio è la lunghezza della streak (1pt per parola)
- [ ] Alla fine mostra: streak totale, parole corrette, lingue incontrate
- [ ] Salva il record personale per modalità Infinity

---

## Epic 5: Modalità Audio

### US-12 — Giocare in modalità audio
| Campo | Valore |
|-------|--------|
| **Priorità** | P1 |
| **Story** | **Da giocatore**, voglio giocare sentendo la pronuncia della parola invece di leggerla, così da allenare il riconoscimento all'ascolto. |

**Criteri di accettazione:**
- [ ] In modalità audio, la parola viene pronunciata (non mostrata come testo)
- [ ] C'è un pulsante per riascoltare la pronuncia
- [ ] La parola viene pronunciata all'inizio del turno automaticamente
- [ ] Supporto per lingue con alfabeti non latini (arabo, cinese, giapponese, ecc.)
- [ ] Se il file audio non è disponibile, cade in modalità scritta con avviso

---

### US-13 — Scelta scritta/audio
| Campo | Valore |
|-------|--------|
| **Priorità** | P1 |
| **Story** | **Da giocatore**, voglio poter scegliere tra modalità scritta e audio all'inizio di ogni partita, così da alternare in base alla mia voglia. |

**Criteri di accettazione:**
- [ ] Schermata di selezione formato prima di ogni partita
- [ ] Due opzioni: 📝 Scritta e 🎧 Audio
- [ ] La scelta può essere resa permanente dalle impostazioni
- [ ] La scelta è ricordata per la sessione corrente

---

## Epic 6: Sfida Daily

### US-14 — Giocare la sfida daily
| Campo | Valore |
|-------|--------|
| **Priorità** | P2 |
| **Story** | **Da giocatore abituale**, voglio una sfida daily con 5 parole uguali per tutti, così da competere con gli altri sulla stessa base. |

**Criteri di accettazione:**
- [ ] Ogni giorno 5 parole uguali per tutti gli utenti
- [ ] La sfida è giocabile una sola volta al giorno
- [ ] Le parole vengono selezionate automaticamente da una Cloud Function a mezzanotte
- [ ] La schermata home mostra se la daily è già stata completata oggi
- [ ] Il punteggio della daily contribuisce al totale e alla classifica daily separata

---

### US-15 — Classifica daily
| Campo | Valore |
|-------|--------|
| **Priorità** | P2 |
| **Story** | **Da giocatore**, voglio vedere la classifica della sfida daily, così da confrontare il mio risultato con gli altri. |

**Criteri di accettazione:**
- [ ] Classifica separata per la sfida daily di oggi
- [ ] Mostra posizione, nome, punteggio
- [ ] La classifica si aggiorna in tempo reale (o quasi)
- [ ] La classifica dei giorni passati è consultabile (storico)
- [ ] Se l'utente non ha giocato la daily, non compare in classifica

---

## Epic 7: Vero o Falso?

### US-16 — Giocare a "Vero o Falso?"
| Campo | Valore |
|-------|--------|
| **Priorità** | P3 |
| **Story** | **Da giocatore**, voglio una modalità rapida "Vero o Falso?" dove devo solo toccare per rispondere, così da giocare sessioni velocissime. |

**Criteri di accettazione:**
- [ ] Viene mostrata una parola con una traduzione proposta
- [ ] L'utente tocca "Vero" o "Falso"
- [ ] Feedback immediato (corretto/sbagliato)
- [ ] Nessun input testuale richiesto
- [ ] Punteggio basato su velocità e correttezza
- [ ] Partita: 10 domande o modalità infinity

---

## Epic 8: Classifiche

### US-17 — Classifica globale
| Campo | Valore |
|-------|--------|
| **Priorità** | P2 |
| **Story** | **Da giocatore**, voglio vedere la classifica globale, così da sapere dove mi posiziono tra tutti gli utenti. |

**Criteri di accettazione:**
- [ ] Classifica ordinata per punteggio totale decrescente
- [ ] Mostra: posizione, nome, punteggio, livello/badge
- [ ] L'utente corrente è evidenziato (es. con badge "tu" o colore diverso)
- [ ] Scrollabile
- [ ] Mostra il rank dell'utente anche se non tra i primi (es. "Sei al #42")

---

### US-18 — Classifica tra amici (futuro)
| Campo | Valore |
|-------|--------|
| **Priorità** | P3 |
| **Story** | **Da giocatore**, voglio poter aggiungere amici e vedere la classifica tra di noi, così da sfidare persone che conosco. |

**Criteri di accettazione:**
- [ ] Possibilità di cercare utenti per nome
- [ ] Inviare/ricevere richieste di amicizia
- [ ] Classifica filtrata per amici
- [ ] Notifica quando un amico supera il tuo punteggio

---

## Epic 9: Statistiche e Progresso

### US-19 — Statistiche personali
| Campo | Valore |
|-------|--------|
| **Priorità** | P1 |
| **Story** | **Da giocatore**, voglio vedere le mie statistiche di gioco, così da monitorare i miei progressi nel tempo. |

**Criteri di accettazione:**
- [ ] Schermata statistiche accessibile dal profilo
- [ ] Mostra: partite totali, parole indovinate, punteggio totale, streak massima
- [ ] Grafico a barre per lingua (quante parole conosci in每 lingua)
- [ ] Andamento punteggio nel tempo (grafico semplice)
- [ ] Statistiche per modalità di gioco

---

### US-20 — Badge e risultati
| Campo | Valore |
|-------|--------|
| **Priorità** | P2 |
| **Story** | **Da giocatore**, voglio sbloccare badge e risultati completando obiettivi, così da avere un senso di progressione e collezionismo. |

**Criteri di accettazione:**
- [ ] Lista badge con stato (bloccato/sbloccato)
- [ ] Badge sbloccati: animazione di celebrazione
- [ ] Esempi badge: "Poliglotta" (10 lingue), "Centurione" (100 parole), "Fedele" (streak 7gg)
- [ ] Nuovi badge vengono controllati al termine di ogni partita
- [ ] Schermata badge accessibile dal profilo

---

### US-21 — Streak giornaliero
| Campo | Valore |
|-------|--------|
| **Priorità** | P1 |
| **Story** | **Da giocatore**, voglio essere incentivato a giocare tutti i giorni con uno streak giornaliero, così da mantenere l'abitudine. |

**Criteri di accettazione:**
- [ ] Lo streak aumenta di 1 per ogni giorno con almeno una partita completata
- [ ] Lo streak si resetta se si salta un giorno
- [ ] Lo streak è mostrato nella home e nel profilo
- [ ] Icona 🔥 accanto al numero
- [ ] Notifica serale se non si è ancora giocato oggi (P2)

---

## Epic 10: Impostazioni

### US-22 — Lingua dell'interfaccia
| Campo | Valore |
|-------|--------|
| **Priorità** | P1 |
| **Story** | **Da utente**, voglio poter cambiare la lingua dell'interfaccia dell'app, così da usarla nella mia lingua madre. |

**Criteri di accettazione:**
- [ ] Impostazione "Lingua app" nelle impostazioni
- [ ] Opzioni: Italiano, Inglese (almeno), + altre in futuro
- [ ] Il cambio lingua avviene senza riavviare l'app
- [ ] Di default segue la lingua di sistema
- [ ] La lingua dell'interfaccia è distinta dalla lingua di gioco

---

### US-23 — Toggle audio
| Campo | Valore |
|-------|--------|
| **Priorità** | P1 |
| **Story** | **Da giocatore**, voglio poter impostare la modalità audio come preferenza permanente, così da non dover scegliere ogni volta. |

**Criteri di accettazione:**
- [ ] Toggle "Modalità audio" nelle impostazioni
- [ ] On: le partite partono in modalità audio di default
- [ ] Off: le partite partono in modalità scritta di default
- [ ] La scelta è comunque modificabile all'inizio di ogni partita

---

### US-24 — Tema chiaro/scuro
| Campo | Valore |
|-------|--------|
| **Priorità** | P2 |
| **Story** | **Da utente**, voglio poter scegliere tra tema chiaro e scuro, così da giocare comodamente in qualsiasi ambiente. |

**Criteri di accettazione:**
- [ ] Opzione: Chiaro, Scuro, Segui sistema
- [ ] "Segui sistema" è il default
- [ ] Il tema si applica immediatamente senza riavvio
- [ ] La scelta è persistente tra sessioni

---

## Epic 11: Onboarding

### US-25 — Tutorial prima apertura
| Campo | Valore |
|-------|--------|
| **Priorità** | P0 |
| **Story** | **Da nuovo utente**, voglio un breve tutorial alla prima apertura, così da capire subito come funziona il gioco. |

**Criteri di accettazione:**
- [ ] 3-4 slide con swipe orizzontale
- [ ] Spiega: concetto del gioco, come si risponde, come funzionano gli indizi
- [ ] L'ultima slide ha un pulsante "Inizia"
- [ ] Il tutorial è mostrato una sola volta (persistente)
- [ ] Opzione "Salta tutorial" su ogni slide

---

## Epic 12: Supporto Offline

### US-26 — Giocare offline
| Campo | Valore |
|-------|--------|
| **Priorità** | P1 |
| **Story** | **Da giocatore in mobilità**, voglio poter giocare anche senza connessione internet, così da non perdere l'abitudine quando sono in metro/aereo. |

**Criteri di accettazione:**
- [ ] Le parole vengono precaricate in cache locale all'avvio (quando connesso)
- [ ] Se non c'è connessione, il gioco funziona con i dati in cache
- [ ] Indicatore visivo in home: "Modalità offline"
- [ ] Tutte le modalità di gioco sono disponibili offline
- [ ] I dati audio potrebbero non essere disponibili offline (fallback a scritta con avviso)

---

### US-27 — Sincronizzazione
| Campo | Valore |
|-------|--------|
| **Priorità** | P1 |
| **Story** | **Da giocatore**, quando torno online voglio che i miei progressi vengano sincronizzati automaticamente, così da non perdere dati. |

**Criteri di accettazione:**
- [ ] Le partite giocate offline vengono accodate localmente
- [ ] Al ritorno della connessione, sync automatico in background
- [ ] Indicatore di sincronizzazione (es. icona spinner nella barra)
- [ ] Se la sincronizzazione fallisce, riprova con backoff esponenziale
- [ ] L'utente può forzare una sincronizzazione manuale

---

## Epic 13: Notifiche Push

### US-28 — Notifica sfida daily
| Campo | Valore |
|-------|--------|
| **Priorità** | P2 |
| **Story** | **Da giocatore abituale**, voglio ricevere una notifica quando la sfida daily è pronta, così da non dimenticare di giocarla. |

**Criteri di accettazione:**
- [ ] Notifica push ogni giorno alle 9:00
- [ ] Testo: "La sfida daily è pronta! 5 parole ti aspettano."
- [ ] Toccando la notifica si apre direttamente la daily
- [ ] La notifica non viene inviata se la daily è già stata completata

---

### US-29 — Reminder streak
| Campo | Valore |
|-------|--------|
| **Priorità** | P2 |
| **Story** | **Da giocatore**, voglio ricevere un reminder se non ho ancora giocato oggi, così da non perdere il mio streak. |

**Criteri di accettazione:**
- [ ] Notifica push alle 20:00 se non si è giocata nessuna partita oggi
- [ ] Testo: "Non hai ancora giocato oggi! Il tuo streak di N giorni è a rischio."
- [ ] Toccando la notifica si apre la home
- [ ] Non inviata se si è già giocato oggi

---

## Epic 14: Condivisione

### US-30 — Condividi risultato
| Campo | Valore |
|-------|--------|
| **Priorità** | P2 |
| **Story** | **Da giocatore**, voglio poter condividere il risultato di una partita sui social, così da sfidare i miei amici. |

**Criteri di accettazione:**
- [ ] Pulsante "Condividi" nella schermata di riepilogo partita
- [ ] Genera un testo formattato con: modalità, punteggio, streak, lingue
- [ ] Usa lo share sheet nativo del sistema operativo
- [ ] Esempio testo: "🧠 Language Game | 10 Sfida: 42pt 🔥 | Streak: 8 | Ho indovinato 9/10 parole in 6 lingue! Mi battezzi? 🌍"

---

## Epic 15: Amministrazione Dataset

### US-31 — Aggiungere parole (admin)
| Campo | Valore |
|-------|--------|
| **Priorità** | P1 |
| **Story** | **Da amministratore**, voglio poter aggiungere nuove parole al dataset, così da espandere il vocabolario del gioco. |

**Criteri di accettazione:**
- [ ] Interfaccia admin (o operazione via backend) per aggiungere parole
- [ ] Campi: testo, traduzione, lingua, categoria opzionale, difficoltà
- [ ] Possibilità di caricare file audio associato
- [ ] Validazione: no duplicati, lingua supportata
- [ ] Le nuove parole sono subito disponibili nel gioco

---

## Epic 16: Variante Inversa (Indovina la Parola)

### US-32 — Modalità inversa
| Campo | Valore |
|-------|--------|
| **Priorità** | P2 |
| **Story** | **Da giocatore esperto**, voglio la variante "inversa" dove vedo la parola nella mia lingua e devo scriverla in una lingua straniera, così da allenare la produzione attiva. |

**Criteri di accettazione:**
- [ ] Opzione "Modalità inversa" nella schermata di selezione
- [ ] La parola è mostrata nella lingua madre dell'utente
- [ ] L'utente deve scrivere la traduzione in una lingua straniera casuale
- [ ] Stesso sistema di punteggio decrescente
- [ ] Feedback con la grafia corretta nella lingua target

---

## Riepilogo priorità

| Priorità | Conteggio | Cosa include |
|----------|-----------|-------------|
| **P0** | 7 | Autenticazione base, Indovina la Parola, 10 Sfida, punteggio, timer, onboarding, persistenza |
| **P1** | 9 | Profilo, audio, statistiche, streak, offline/sync, toggle audio, lingua UI, dataset admin, modalità inversa |
| **P2** | 10 | Daily, classifiche globali, badge, Infinity, tema, notifiche, condivisione, modalità inversa |
| **P3** | 2 | Vero/Falso, amici |

---

*Documento curato da: Language Game Product Team*
*Versione: 1.0*
*Basato su: PRD.md v1.0*
