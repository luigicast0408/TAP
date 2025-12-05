# Spark RDD e Oltre

## Resilient Distributed Dataset (RDD)

Un **RDD (Resilient Distributed Dataset)** rappresenta la struttura dati fondamentale di Apache Spark.  
È una collezione **distribuita**, **immutabile** e **tollerante ai guasti** di oggetti, suddivisa in più partizioni che possono essere elaborate in parallelo su nodi differenti del cluster.

Gli RDD possono contenere qualunque tipo di oggetto Python, Java o Scala, incluse classi definite dall’utente. La loro progettazione consente a Spark di ottenere elevata scalabilità e parallelismo senza richiedere complessi meccanismi di sincronizzazione.

---

## Tipi di RDD

- **ParallelCollectionRDD** — creato parallelizzando una collezione locale (`sc.parallelize`).
- **CoGroupedRDD** — risultato di operazioni di *cogroup* su RDD multipli.
- **HadoopRDD** — usato per leggere dati da HDFS tramite l'API MapReduce.
- **MapPartitionsRDD** — prodotto da trasformazioni come `map`, `flatMap`, `filter`.
- **CoalescedRDD** — ottenuto tramite `coalesce()` o `repartition()`.
- **ShuffledRDD** — generato dopo operazioni che richiedono shuffle.
- **PipedRDD** — consente di inviare dati a processi esterni.
- **SequenceFileRDD** — permette di salvare dati come SequenceFile.

---

# Esempi pratici in PySpark

## Creazione del contesto Spark

```python
import findspark
import pyspark

findspark.find()

conf = pyspark.SparkConf().setAppName('Tap').setMaster('local')
sc = pyspark.SparkContext(conf=conf)
sc
```

---

## Creare un RDD con `parallelize`

```python
digits = sc.parallelize([0,1,2,3,4,5,6,7,8,9])
digits.collect()
```

Restituisce tutti gli elementi dell’RDD:

```
[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
```

---

# Operazioni sugli RDD

Gli RDD supportano due categorie principali:

- **Transformations** → producono un nuovo RDD.  
- **Actions** → restituiscono un valore al driver.

Le trasformazioni sono **lazy**: Spark esegue i calcoli solo quando viene invocata un’azione.

---

# Transformations

## `map(func)`
Applica la funzione a ciascun elemento.

```python
squares = digits.map(lambda x: x*x)
squares.collect()
```

---

## `filter(func)`
Restituisce un nuovo dataset contenente gli elementi per i quali la funzione **`func()`** restituisce **`True`**.
```python
evens = digits.filter(lambda x: x % 2 == 0)
evens.collect()
```

---

## `flatMap(func)`
Simile a **`map`**, ma permette di produrre **zero, uno o più elementi** per ogni input.  
La funzione deve restituire una sequenza.

```python
def factors(nr):
    i = 2
    facts = []
    while i <= nr:
        if nr % i == 0:
            facts.append(i)
            nr = nr / i
        else:
            i += 1
    return facts

primes = digits.flatMap(factors)
primes.collect()
```

---

## `distinct()`
Restituisce un nuovo RDD contenente solo gli elementi unici.

```python
primes.distinct().collect()
```

---

## `sample(withReplacement, fraction)`
Esegue un campionamento casuale degli elementi.
```python
digits.sample(False, 0.2).collect()
```

---

## `union()`
Unisce due RDD restituendo un dataset che contiene tutti gli elementi di entrambi.
```python
odds = digits.filter(lambda x: x % 2 == 1)
yy = evens.union(odds)
yy.collect()
```

---

## `intersection()`
Restituisce gli elementi presenti in entrambi gli RDD.
```python
intersects = evens.intersection(squares)
intersects.collect()
```

---

## `cartesian()`
Restituisce il prodotto cartesiano tra due RDD.

```python
cart = evens.cartesian(odds)
cart.collect()
```

---

## `groupByKey()`
Operazione applicabile solo a RDD di coppie `(key, value)`.  
Restituisce per ogni chiave una lista dei valori associati iterabili.
```python
cartgroup = cart.groupByKey()
cartgroup.collect()
```

```python
cartgroup.map(lambda x : (x[0], list(x[1]))).collect()
```

## `join()`
Unisce due RDD basati su chiave, producendo `(K, (V, W))`.
```python
cart2 = squares.cartesian(odds)
cart.join(cart2).collect()
```

---

## `cogroup()`
Restituisce per ogni chiave tutte le liste di valori provenienti dagli RDD in input.
```python
cart.cogroup(cart2).map(lambda x: (x[0], list(x[1][0]) + list(x[1][1]))).collect()
```

---

## `pipe(command)`
Invia gli elementi dell'RDD a un comando esterno e ritorna l’output come nuovo RDD.

```python
digits.pipe("whoami").collect()
```

---

# Actions

## `reduce(func)`
Aggrega gli elementi utilizzando una funzione associativa e commutativa.
```python
digits.reduce(lambda a,b: a + b)
```

---

## `count()`
Restituisce il numero di elementi dell’RDD.
```python
digits.count()
```

---

## `collect()`
Ritorna tutti gli elementi al driver (da usare solo se il dataset è piccolo).
```python
cart.collect()
```

---

## `take(n)`
Restituisce i primi `n` elementi.
```python
digits.take(2)
```

---

## `takeSample()`

```python
digits.takeSample(False, 5)
```

---

## `takeOrdered(n)`
Restituisce i primi `n` elementi in ordine naturale o tramite comparatore personalizzato.
```python
digits.takeOrdered(5)
```

---

## `first()`
Restituisce il primo elemento

```python
digits.first()
```

---

## `countByKey()`
Conta le occorrenze di ciascuna chiave in un RDD di coppie.
```python
cart2.countByKey()
```

---

## `histogram()`

```python
rdd = sc.parallelize(range(51))
rdd.histogram([0, 5, 25, 50])
```

---

## `stats()`
Restituisce statistiche descrittive: count, media, varianza, min, max.
```python
digits.stats()
```

---

## `foreach(func)`
Esegue una funzione su ciascun elemento dell’RDD (side effects).
```python
countdown = sc.parallelize(range(11))
countdown.foreach(lambda x: print("[%-10s] %d%%" % ('='*x, 10*x)))
```

---

# Terminare il contesto Spark

```python
sc.stop()
```

## Operazioni Lazy e Non-Lazy nei Modelli di Calcolo Distribuito

Nel paradigma di elaborazione dei dati adottato da Apache Spark e da modelli funzionali come la Stream API di Java, le operazioni vengono distinte in intermedie (lazy) e terminali (non-lazy). Le operazioni intermedie non causano l’esecuzione immediata del calcolo: ogni trasformazione applicata a un dataset descrive soltanto una parte della pipeline, contribuendo alla costruzione del Directed Acyclic Graph (DAG) che rappresenta il flusso computazionale. Tale approccio consente al motore di ottimizzare la pipeline nel suo complesso prima di eseguirla, eliminando passaggi ridondanti, combinando trasformazioni e riducendo il numero di scansioni sui dati.

Le operazioni terminali producono invece l’avvio effettivo dell'esecuzione. Quando viene invocata un’azione, Spark analizza l’intera catena di trasformazioni lazy accumulate fino a quel momento, applica strategie di ottimizzazione e avvia la computazione distribuita sui nodi del cluster. Solo in questa fase il programma genera un risultato concreto, come la restituzione di valori al driver o la persistenza su un file system distribuito.

Questa separazione fra descrizione logica del calcolo ed esecuzione fisica rappresenta un elemento fondamentale dei sistemi moderni di data processing. In Spark, l’invocazione di trasformazioni quali map, filter, distinct o flatMap non comporta alcuna esecuzione immediata; al contrario, un’azione come collect, count, reduce o saveAsTextFile forza l’esecuzione del DAG generato. La Stream API di Java segue lo stesso modello concettuale: una sequenza di operazioni intermedie rimane inattiva fino a quando non viene invocata un’operazione terminale.

| Categoria                   | Esempi di Operazioni                                                                             | Lazy? | Attiva il DAG? | Output                     |
| --------------------------- | ------------------------------------------------------------------------------------------------ | ----- | -------------- | -------------------------- |
| Trasformazioni (Intermedie) | **`map`, `filter`, `flatMap`, `distinct`, `union`, `intersection`, `groupByKey`, `reduceByKey`** | Sì    | No             | Nuovo RDD                  |
| Azioni (Terminali)          | **`collect`, `count`, `first`, `take`, `reduce`, `saveAsTextFile`, `countByKey`**                | No    | Sì             | Valori o scrittura esterna |
### Esempi
**Esempio di trasformazioni lazy**
```python
rdd = sc.parallelize([1, 2, 3, 4, 5])

# Nessuna computazione viene eseguita in queste righe
rdd2 = rdd.map(lambda x: x * 2)
rdd3 = rdd2.filter(lambda x: x > 5)
rdd4 = rdd3.distinct()
```
In questa fase non viene prodotto alcun valore e non avviene alcun calcolo.  
Spark sta solo **costruendo il DAG**
```python
result = rdd4.collect()
```
In questo momento Spark:
1. **analizza tutte le trasformazioni accumulate,**
2. **ottimizza la pipeline,**
3. **distribuisce le operazioni sui nodi,**
4. **restituisce il risultato finale:**