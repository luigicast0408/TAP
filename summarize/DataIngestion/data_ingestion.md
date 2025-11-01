# Data Ingestion

## Il processo di acquisizione dei dati

Il processo di **data ingestion** può essere suddiviso in più fasi, che vanno dall’identificazione delle fonti alla raccolta, trasformazione e infine caricamento dei dati nel sistema di destinazione.

1. **Identificazione delle fonti di dati**Il primo passo nell’acquisizione dei dati consiste nell’individuare e comprendere le **fonti di dati** rilevanti per le esigenze aziendali.Queste possono variare notevolmente a seconda del tipo di dato — **strutturato**, **semi-strutturato** o **non strutturato** — e del **dominio applicativo**.

   > 💡 **Nota Bene:** I dati devono essere **accessibili**, sia dal punto di vista dei **permessi di utilizzo**, sia per quanto riguarda la **raggiungibilità tecnica** della fonte.
   >
2. **Raccolta dei dati**
   La **raccolta dei dati** è il processo di acquisizione di informazioni da varie fonti per utilizzarle in successive **analisi, elaborazioni o archiviazioni**.
   Nel contesto della *data ingestion*, questa fase rappresenta l’**acquisizione iniziale dei dati grezzi**, che saranno poi trasformati, convalidati e caricati in un sistema di gestione dei dati, come un **data lake** o un **data warehouse**.

   Per raccogliere i dati vengono utilizzate diverse strategie, in base alla natura della fonte e ai requisiti aziendali.
3. **Trasformazione e convalida dei dati**Dopo la raccolta, i dati grezzi devono essere **trasformati e convalidati** per garantirne l’affidabilità e la coerenza.In questa fase si applicano operazioni come:

   - **Pulizia dei dati** (rimozione di duplicati e gestione dei valori mancanti);
   - **Normalizzazione** e **formattazione**;
   - **Verifica della qualità** e **conformità ai modelli di business**.
4. **Caricamento nel sistema di destinazione**
   I dati così trasformati vengono infine **caricati** nel sistema di destinazione — ad esempio un **data warehouse**, un **data lake** o una piattaforma di **analytics** — dove potranno essere analizzati, combinati e utilizzati per generare valore informativo.
5. **Monitoraggio e aggiornamento continuo**
   Una volta implementato il flusso di acquisizione, è essenziale **monitorare** le prestazioni e la qualità dei dati nel tempo.
   Il monitoraggio consente di individuare **errori, ritardi o anomalie** nel processo di ingestion e di adattare il sistema a **nuove sorgenti** o a **variazioni nei volumi dei dati**.

## Che cos'è il Data Ingestion?

L’**acquisizione dei dati** (*data ingestion*) è il processo mediante il quale i dati vengono **raccolti e importati** da una o più sorgenti per essere **utilizzati immediatamente** o **archiviati** all’interno di un sistema di destinazione, come un database o un data lake.

Il termine *ingestion* deriva dal verbo inglese *to ingest*, che significa “assorbire” o “introdurre”: in questo contesto indica l’**atto di trasferire e integrare i dati** all’interno di un sistema, affinché possano essere analizzati o elaborati successivamente.

## Una storia di fusioni e acquisizioni

### La nascita di una nuova azienda nel campo dei dati

C’era una volta un’azienda chiamata **Talend**, fondata con l’obiettivo di aiutare le organizzazioni a **raccogliere, trasformare e gestire i dati** provenienti da diversi ecosistemi.

Talend si è distinta per il suo approccio **open source**, grazie al lancio di **Talend Open Studio**, una piattaforma che ha permesso agli utenti di **creare e distribuire flussi di integrazione dei dati** in modo semplice e flessibile.
Nel tempo, l’azienda ha ampliato la propria offerta con soluzioni dedicate alla **qualità dei dati**, all’**integrazione cloud** e alla **data governance**, consolidando così la propria posizione nel settore.

### Crescita e acquisizioni per conquistare il mercato delle PMI

> Il mese scorso **Stitch** è entrata a far parte di **Talend**.
> Talend è un’azienda globale di software open source specializzata nell’integrazione di **Big Data** e **cloud**, la cui missione è *“rendere i vostri dati migliori, più affidabili e più accessibili per generare valore aziendale”*.
> Una visione perfettamente in linea con quella di Stitch: *“ispirare e dare potere alle persone basate sui dati”*.

Grazie a questa fusione, Talend offre oggi una **piattaforma ETL SaaS** completa e senza attriti, integrando le potenzialità di Stitch.
È possibile **estrarre dati da oltre 140 fonti popolari** e trasferirli nel proprio **data warehouse** o **database** in pochi minuti, senza bisogno di scrivere una sola riga di codice.

### L’acquisizione da parte di una società di Business Intelligence

Successivamente, **Talend** è stata acquisita da **Qlik**, una delle principali aziende nel settore della **Business Intelligence (BI)** e dell’**analisi dei dati**.

L’unione tra le due realtà ha dato origine a un’entità con una **posizione di leadership consolidata** in numerose categorie di mercato.
Per **sette anni consecutivi**, **Gartner** ha riconosciuto **Talend** come *leader* nel proprio **Magic Quadrant for Data Integration Tools** e per **cinque anni consecutivi** nel **Magic Quadrant for Data Quality Solutions**.

Parallelamente, **Qlik** è stata classificata come *leader* nel **Magic Quadrant for Analytics and Business Intelligence Platforms** per **tredici anni di seguito**, confermando la propria eccellenza nel campo dell’analisi e della visualizzazione dei dati.
Inoltre, **IDC MarketScape** ha nominato Qlik come *leader* nel report **“US Business Intelligence and Analytics Platforms 2022 Vendor Assessment”*, rafforzando ulteriormente la reputazione dell’azienda nel panorama globale della BI.

## Data Ingestion vs Data Integration

L’**acquisizione dei dati** (*data ingestion*) è un concetto simile, ma distinto, da quello di **integrazione dei dati** (*data integration*).
Mentre la *data integration* ha l’obiettivo di **combinare più sorgenti di dati** in un sistema unificato e coerente — spesso **all’interno dello stesso ambiente aziendale** — la *data ingestion* si concentra principalmente sul **trasferimento dei dati** da fonti esterne verso un sistema di destinazione.

In altre parole, l’integrazione dei dati punta alla **fusione logica e strutturale** delle informazioni, mentre l’acquisizione dei dati riguarda il **processo iniziale di raccolta e importazione**, che può coinvolgere **siti web, applicazioni SaaS** o **database esterni**.

## Metodi di raccolta dei dati

- **Batch ingestion** → comporta la raccolta e l’elaborazione dei dati a intervalli regolari (ad esempio ogni ora o ogni giorno).
  I dati vengono aggregati in grandi set e caricati in blocco, consentendo un’elaborazione efficiente ma non in tempo reale.
- **Streaming ingestion** → consiste nell’acquisizione continua di dati in **tempo reale**, dove le informazioni vengono raccolte non appena generate.
  I dati fluiscono costantemente dalla sorgente alla destinazione, permettendo **analisi immediate** e **aggiornamenti dinamici**.
- **Micro-batch ingestion** → rappresenta un approccio intermedio, in cui i dati vengono raccolti in piccoli blocchi a intervalli molto brevi, combinando l’efficienza del batch con la reattività dello streaming.

## Validazione dei dati

- **Pulizia dei dati:** identificare e correggere le inesattezze nei dati. Ciò può comportare la gestione dei valori mancanti, la rimozione dei duplicati o la risoluzione delle incongruenze.
- **Convalida dello schema:** assicurarsi che i dati in arrivo siano conformi allo schema predefinito in termini di struttura, tipi e vincoli.
- **Controllo di qualità:** verificare l’integrità, la qualità e la completezza dei dati.

> 💡 **Nota:** la convalida può essere costosa e non sempre applicabile, soprattutto in sistemi di ingestione in tempo reale.

## Trasformazione dei dati

- **Arricchimento dei dati:** combinare dati provenienti da più sorgenti o aggiungere informazioni contestuali per aumentarne il valore informativo.
- **Normalizzazione e aggregazione:** uniformare i formati e aggregare i dati per semplificarne l’analisi e il caricamento nei sistemi di destinazione.
- **Derivazione e calcolo:** creare nuovi attributi o metriche a partire da dati esistenti (es. calcolo di indici o rapporti).
- **Filtraggio:** eliminare i dati indesiderati o irrilevanti.

> 💡 **Nota:** la trasformazione è un passaggio facoltativo. L’idea originale dello schema in lettura implica dati grezzi non filtrati; tuttavia, ciò richiede spazio aggiuntivo e non sempre porta valore.

## Caricamento dei dati (destinazione - sink)

Una volta **definito il metodo di acquisizione** — che sia in *batch* o in *tempo reale* — si procede con l’**avvio del processo di trasferimento dei dati**.
In questa fase, le informazioni vengono inviate verso le **destinazioni previste**, che possono comprendere **database**, **data warehouse** o **data lake**, a seconda dell’architettura del sistema.
Il **caricamento** può avvenire in modalità **incrementale**, aggiornando solo i nuovi dati, oppure in modalità **completa**, sostituendo l’intero insieme di informazioni.
È in questo momento che i dati vengono **effettivamente ingeriti nel sistema**, diventando disponibili per l’elaborazione e l’analisi.

## Monitoraggio e registrazione

Durante il processo di acquisizione è fondamentale **implementare meccanismi di gestione degli errori**, in modo da poter **intercettare e gestire eventuali anomalie** o **ripetere automaticamente i tentativi di inserimento** in caso di fallimento.
Allo stesso tempo, è importante predisporre un sistema di **registrazione (logging)** che consenta di **tracciare ogni fase del processo**, includendo eventuali **problemi di connessione alle fonti dati**, **errori di parsing** o **violazioni dello schema**.
Queste pratiche garantiscono **maggiore affidabilità, tracciabilità e trasparenza** nell’intero flusso di data ingestion.

## Automazione e programmazione

- **Automazione delle pipeline:** utilizzare strumenti e piattaforme per automatizzare l'inserimento dei dati.
- **Pianificazione:** programmare attività di acquisizione periodiche per i processi batch.

Spesso questi strumenti agiscono come un **agente** connesso alla generazione dei dati.

## Sicurezza e conformità

Un aspetto essenziale del processo di acquisizione riguarda la **sicurezza dei dati**.
I **dati sensibili** devono essere **crittografati** sia **durante la trasmissione** sia **a riposo**, per proteggerli da accessi non autorizzati o intercettazioni.
È inoltre necessario **implementare rigorosi controlli di accesso**, assicurando che solo gli **utenti autorizzati** possano acquisire, modificare o visualizzare le informazioni.
Infine, l’intero processo deve essere conforme alle principali **normative sulla protezione dei dati**, come il **GDPR**, l’**HIPAA** o altre **regolamentazioni specifiche del settore**, garantendo così la piena tutela della privacy e la sicurezza delle informazioni gestite.
