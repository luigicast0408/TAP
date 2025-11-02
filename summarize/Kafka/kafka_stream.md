# Apache Kafka – Streams

**Kafka Streams** è una libreria client sviluppata per la creazione di applicazioni e microservizi **real-time**, in cui i dati di input e/o output sono memorizzati in cluster **Apache Kafka**.  
Essa combina la semplicità di sviluppo e distribuzione delle applicazioni **Java** e **Scala** con la potenza e l’affidabilità della tecnologia di clustering di Kafka, permettendo di realizzare applicazioni **scalabili, elastiche, fault-tolerant e distribuite**.

---

## Concetti fondamentali

### 1. Libreria client integrabile

Kafka Streams è progettata come una **libreria client semplice e leggera**, facilmente integrabile in qualsiasi applicazione Java.  
Può essere aggiunta al progetto come una normale dipendenza Maven:

```xml
<dependency>
    <groupId>org.apache.kafka</groupId>
    <artifactId>kafka-streams</artifactId>
    <version>4.1.0</version>
</dependency>
```

Grazie a questa architettura, non richiede server o componenti separati: il codice viene eseguito direttamente come parte dell’applicazione.

---

### 2. Architettura standalone (autonoma)

Kafka Streams **non dipende da sistemi esterni** oltre a Kafka stesso, che funge da livello di messaggistica interna.  
Utilizza il modello di **partizionamento** di Kafka per scalare orizzontalmente l’elaborazione, mantenendo al contempo forti garanzie di **ordinamento** dei dati.

![11.png](image/11.png)

Questa autonomia rende la libreria altamente portabile e adatta a contesti di produzione distribuiti.

---

### 3. Fault Tolerance (Tolleranza ai guasti)

Kafka Streams supporta lo **stato locale fault-tolerant**, che permette di eseguire operazioni **stateful** (come join, aggregazioni e windowing) in modo rapido ed efficiente.  
Lo stato è mantenuto su ogni singola macchina tramite **RocksDB**, mentre i **Kafka topics** vengono utilizzati per il **backup** e la **replicazione** dello stato.

![12.pmg](image/12.png)

In caso di guasto di un’istanza, il sistema è in grado di ripristinare rapidamente lo stato, garantendo la **continuità dell’elaborazione** e la **consistenza dei dati**.

---

### 4. Exactly Once Processing (Elaborazione esattamente una volta)

Kafka Streams supporta la semantica di elaborazione **“exactly-once”**, garantendo che ogni record venga elaborato **una sola volta**, anche in caso di errori durante l’elaborazione da parte dei client o dei broker Kafka.

![13.png](image/13.png)

Questo meccanismo riduce drasticamente il rischio di duplicazione o perdita dei messaggi, assicurando un comportamento coerente e affidabile anche in ambienti distribuiti.

---

### 5. Elaborazione record-by-record

Kafka Streams utilizza un modello di **elaborazione record-per-record**, che consente una **latenza di elaborazione di pochi millisecondi**.  
Supporta inoltre operazioni di **windowing basate sul tempo dell’evento**, anche in presenza di record che arrivano **fuori ordine**.

![14.png](image/14.png)

Questa caratteristica è cruciale per scenari real-time in cui la tempestività e la precisione dei dati sono fondamentali.

---

### 6. Primitivi e API

Kafka Streams offre un set di **primitive di elaborazione dei flussi**, che include sia un **DSL (Domain Specific Language)** di alto livello, sia una **API di basso livello** per un controllo più fine sull’elaborazione.  
Queste API permettono di definire facilmente flussi complessi di trasformazioni, aggregazioni e join.

---

## Use Cases

Il **New York Times** utilizza Apache Kafka e Kafka Streams per archiviare e distribuire, in tempo reale, i contenuti pubblicati alle varie applicazioni e ai sistemi che li rendono disponibili ai lettori.

![15.png](image/15.png)

### Esempi

```bash
# Build Kafka Stream (see README.md )
cd kafka-stream
./build.sh

# Start Kafka Server
docker run --rm -p 9092:9092 --network tap --name kafkaServer\
 -e KAFKA_NODE_ID=1 \
  -e KAFKA_PROCESS_ROLES=broker,controller \
  -e KAFKA_LISTENERS=PLAINTEXT://:9092,CONTROLLER://:9093 \
  -e KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://kafkaServer:9092 \
  -e KAFKA_CONTROLLER_LISTENER_NAMES=CONTROLLER \
  -e KAFKA_LISTENER_SECURITY_PROTOCOL_MAP=CONTROLLER:PLAINTEXT,PLAINTEXT:PLAINTEXT \
  -e KAFKA_CONTROLLER_QUORUM_VOTERS=1@localhost:9093 \
  -e KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR=1 \
  -e KAFKA_TRANSACTION_STATE_LOG_REPLICATION_FACTOR=1 \
  -e KAFKA_TRANSACTION_STATE_LOG_MIN_ISR=1 \
  -e KAFKA_GROUP_INITIAL_REBALANCE_DELAY_MS=0 \
apache/kafka:4.1.0

# Create the topic (required)
docker exec -it --workdir /opt/kafka/bin/ kafkaServer ./kafka-topics.sh --create --bootstrap-server kafkaServer:9092  --topic streams-plaintext-input
docker exec -it --workdir /opt/kafka/bin/ kafkaServer ./kafka-topics.sh --create --bootstrap-server kafkaServer:9092  --topic streams-wordcount-output

# kafkaWordCountStream
docker run -it --rm --network tap  tap:kafkastream java -cp /app/app.jar tap.WordCount

# Start a producer 
docker exec --workdir /opt/kafka/bin/ -it kafkaServer ./kafka-console-producer.sh --topic streams-plaintext-input --bootstrap-server localhost:9092

# In another tab open a consumer
docker exec --workdir /opt/kafka/bin/ -it kafkaServer ./kafka-console-consumer.sh --topic streams-wordcount-output --from-beginning --bootstrap-server localhost:9092 --property print.key=true --property print.value=true --property
key.deserializer=org.apache.kafka.common.serialization.StringDeserializer --property value.deserializer=org.apache.kafka.com
mon.serialization.LongDeserializer

# Use "All streams lead to Kafka" followed by "Hello kafka streams"
```
![16.png](image/16.png)

## Concetti fondamentali

### 1. Topologia di elaborazione dei flussi

Uno **stream** è l’astrazione principale fornita da Kafka Streams: rappresenta un set di dati **illimitato e continuamente aggiornato**.  
Uno stream è una **sequenza ordinata, riproducibile e fault-tolerant** di record di dati immutabili, dove ogni record è definito come una **coppia chiave-valore** (`key-value`).

Un’**applicazione di elaborazione di flussi** è qualsiasi programma che utilizza la libreria **Kafka Streams**.  
Essa definisce la propria logica computazionale tramite una o più **topologie di processori**, dove una topologia è un **grafo diretto di nodi (processori di flusso)** collegati da **archi (flussi di dati)**.

Un **processore di flusso** è un nodo nella topologia:  
- riceve un record di input dai processori upstream;  
- applica un’operazione (trasformazione, filtro, join, ecc.);  
- genera uno o più record di output inviandoli ai processori downstream.  

In altre parole, ogni processore rappresenta una fase di trasformazione del flusso, e l’intera topologia descrive la pipeline completa di elaborazione dei dati.

![Stream Processing Topology](image/17.png)

---

### 2. Dualità tra flussi e tabelle

Nella pratica, la maggior parte dei casi d’uso dell’elaborazione di flussi richiede **sia flussi che tabelle**.  
Ad esempio, in un’applicazione di e-commerce, un flusso di **transazioni clienti** può essere **arricchito** con le informazioni aggiornate provenienti da una **tabella di clienti**.

Kafka Streams introduce una potente astrazione che mostra come **flussi e tabelle siano due rappresentazioni dello stesso concetto di dati nel tempo**.

#### • Stream come tabella

Uno stream può essere interpretato come il **changelog di una tabella**, dove ogni record rappresenta una modifica di stato (update, insert, delete).  
Riproducendo lo stream dall’inizio, è possibile **ricostruire la tabella completa**.

Esempio pratico:  
Aggregare un flusso di eventi di visualizzazione di pagina per ottenere il numero totale di visualizzazioni per utente.  
Il risultato di questa aggregazione è una **tabella**, che mantiene il conteggio aggiornato per ciascun utente.

---

#### • Tabella come flusso

Allo stesso modo, una **tabella** può essere vista come un’**istantanea** in un momento specifico dello stato più recente di ciascuna chiave.  
Iterando su ogni voce della tabella (`key-value`), si può ricostruire il flusso degli aggiornamenti:  
una tabella è quindi un **flusso mascherato**, e viceversa uno stream è una **tabella mascherata**.

---