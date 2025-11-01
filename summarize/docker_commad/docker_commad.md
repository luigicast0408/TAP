## Comando `docker build`

Il comando `docker build` consente di **creare un’immagine Docker** a partire da un **Dockerfile** e dal **contesto di build** (la directory corrente o specificata).

### Utilizzo base

Se eseguito **senza argomenti**, Docker cerca automaticamente un file denominato `Dockerfile` **nella directory corrente**:

```bash
docker build
```

### Specificare un percorso personalizzato per il Dockerfile

È possibile indicare un percorso diverso per il file Dockerfile tramite l’opzione `-f`:

```bash
docker build -f /path/to/Dockerfile 
```

### Assegnare un nome o tag all’immagine

Per assegnare un **nome** o un **tag** all’immagine durante la creazione, si utilizza l’opzione `-t` (o `--tag`):

```bash
docker build -t nome_immagine:tag 
```

**Esempio**

```bash
docker build -f ./docker/Dockerfile -t myapp:latest .
```

In questo esempio:

- `f` specifica il percorso del Dockerfile.
- `t` assegna all’immagine il nome `myapp` e il tag `latest`.
- `.` indica che il **contesto di build** è la directory corrente.

## Dockerfile — Sintassi e Struttura

Docker può **costruire automaticamente immagini** leggendo le istruzioni contenute in un **Dockerfile**.

Un **Dockerfile** è un **file di testo** che include tutti i comandi che un utente potrebbe eseguire manualmente da riga di comando per **assemblare un’immagine** Docker.

### Struttura generale

Ogni riga del Dockerfile segue la sintassi:

```bash
# Comment
INSTRUCTION argument
```

Per convenzione, le **istruzioni** sono scritte in **maiuscolo** (`UPPERCASE`).

### `FROM`

```docker
FROM [--platform=<platform>] <image>[:<tag>] [AS <name>]
```

- `FROM` è **la prima istruzione** di ogni **Dockerfile**, subito dopo eventuali **commenti**, **direttive del parser** o **argomenti globali (`ARG`)**.
- Specifica **l’immagine di base** da cui verrà costruita la nuova immagine Docker.
- L’immagine di origine viene recuperata da un **registro pubblico o privato** (ad esempio Docker Hub).

### `ARG`

```docker
ARG <name>[=<default value>]
```

Definisce la variabile d’ambiente utilizzata nel builder

L'argomento può essere utilizzato in DockerFile `FROM`, `RUN,`anche passato durante **`BUILD`**

```bash
docker build --build-arg user=what_user 
```

- `ARG` è referenziato usando `${VARIABLE}` lo scope inizia dalla linea dov’è definita (notazione standard)
- `ENV` vince su `ARG` in esecuzione
- **Esiste un set di `ARG` predefiniti (come `HTTP_PROXY`)**

### `ENV`

```docker
ENV <key> <value>
ENV <key>=<value> ...
```

Definisce le variabili d’ambiente che persistono nel conteiner.

**La variabile d'ambiente può essere passata anche durante l'avvio nel seguente modo:**

```bash
docker run -e "deep=purple"
```

### `RUN` (shell mode)

L’istruzione `RUN` viene utilizzata per **eseguire comandi nel livello sopra l’immagine corrente** durante la **fase di build** dell’immagine Docker.

Ogni istruzione `RUN` crea un **nuovo livello (layer)** nell’immagine risultante.

La shell predefinita per il formato shell può essere modificata utilizzando il comando `SHELL`.

Nella shell è possibile utilizzare un backslash per continuare una singola istruzione come in questo esempio:

```docker
RUN /bin/bash -c 'source $HOME/.bashrc; \
echo $HOME'
```

### `RUN` (exec mode)

```docker
RUN ["executable", "param1", "param2"] (exec form)
```

A differenza della shell, la forma exec non richiama una shell di comando. Ciò significa che non avviene la normale elaborazione della shell.

Se si volesse utilizzare una shell diversa da `/bin/sh` si utilizza la forma exec passando la forma desiderata

```docker
RUN ["/bin/bash", "-c", "echo hello"]
```

***Esempio***

```docker
RUN [ "sh", "-c", "echo $HOME" ]. 
```

non verrà eseguita la sostituzione di variabili su $HOME. Se si desidera l'elaborazione tramite shell, utilizzare il formato shell o eseguire direttamente una shell, ad esempio:

```docker
RUN [ "sh", "-c", "echo $HOME" ]. 
```

Il formato exec viene analizzato come un array JSON, il che significa che è necessario utilizzare le parole tra virgolette doppie (“) e non tra virgolette singole (').

### **`CMD` (modulo esecutivo)**

Lo scopo principale di un `CMD` è fornire impostazioni predefinite per un contenitore in esecuzione. Queste impostazioni predefinite possono includere un eseguibile oppure ometterlo, nel qual caso è necessario specificare anche un'istruzione `ENTRYPOINT`.

Modulo esecutivo, questo è il modulo preferito

```docker
CMD ["executable","param1","param2"]
```

Come il modulo `RUN` exec non richiama una shell, quindi per forzare la sostituzione delle variabili effettuata dalla shell usa

```docker
CMD [ "sh", "-c", "echo $HOME" ]
```

### `CMD` (forma sheel)

Lo scopo principale di un `CMD` è fornire impostazioni predefinite per un contenitore in esecuzione. Queste impostazioni predefinite possono includere un eseguibile oppure ometterlo, nel qual caso è necessario specificare anche un'istruzione **`ENTRYPOINT`**.

```docker
CMD command param1 param2
```

Se si desidera eseguire un comando **senza utilizzare una shell**, è necessario esprimerlo come un **array JSON** e specificare il **percorso completo dell’eseguibile**.

Questa **forma a array** rappresenta il **formato consigliato** per l’istruzione `CMD`.

Eventuali parametri aggiuntivi devono essere indicati singolarmente come stringhe all’interno dell’array.

```docker
FROM ubuntu
CMD echo "This is a test." | wc -l
```

Riassumendo:

> `RUN` esegue effettivamente un comando e conferma il risultato
**`CMD` non esegue nulla in fase di compilazione, ma specifica il comando previsto per l'immagine.**
>

### `ENTRYPOINT`

L’istruzione **`ENTRYPOINT`** definisce il **comando principale** che verrà **eseguito automaticamente all’avvio del container**.

Forma sheel

```docker
ENTRYPOINT comando param1 param2
```

In questo caso, il comando viene eseguito all’interno della shell predefinita (`/bin/sh -c` su Linux).

**Esempi**

Esecuzione di un container dall’immagine ufficiale di Nginx

```bash
docker run -i -t --rm -p 80:80 nginx
```

Verifica del corretto funzionamento del container

```bash
docker run -i -t --rm -p 80:80 nginx
```

Visualizzare lo script di entrypoint

```bash
docker run -i -t --rm -p 80:80 nginx cat docker-entrypoint.sh
```

### `CMD` – `ENTRYPOINT` Interaction

Sia le istruzioni **`CMD`** che **`ENTRYPOINT`** definiscono **il comando da eseguire all’avvio di un container**.

Tuttavia, esse possono **interagire tra loro** in modi differenti a seconda della loro configurazione nel Dockerfile.

### Regole di cooperazione

1. **`ENTRYPOINT`** definisce **il comando principale** (il processo eseguibile) del container.
2. **`CMD`** fornisce **i parametri predefiniti** per l’`ENTRYPOINT`.
3. Se il container viene eseguito con **argomenti da riga di comando**, questi **sovrascrivono il valore di `CMD`**, ma **non quello di `ENTRYPOINT`**.
4. Se viene specificato **solo `CMD`**, Docker esegue il comando definito in `CMD`.
5. Se vengono specificati **entrambi**, `CMD` viene passato come **argomento di default** all’`ENTRYPOINT`.

> Ogni Dockerfile dovrebbe specificare almeno una delle due istruzioni:
>
>
> `CMD`, oppure`ENTRYPOINT`.
>
> In assenza di entrambe, l’esecuzione del container non avrà un comando predefinito e terminerà immediatamente.
>

### `EXPOSE`

`EXPOSE` specifica le **porte interne** (all’interno del container) che dovrebbero essere rese disponibili per la comunicazione con altri container o con l’host.

```docker
EXPOSE <port> [<port>/<protocol>...]
```

**Esempio**

```docker
EXPOSE 80/tcp
EXPOSE 443/tcp
```

Questo indica che l’applicazione nel container è predisposta per utilizzare le porte **80 (HTTP)** e **443 (HTTPS)**, ma non le rende automaticamente accessibili all’esterno.

Per pubblicare effettivamente la porta durante l'esecuzione del contenitore, utilizzare il flag `-p` su `docker run` per pubblicare e mappare una o più porte, oppure il flag `-P` per pubblicare tutte le porte esposte e mapparle alle porte di ordine superiore.

**Esempio**

```bash
bash docker run -p 80:80/tcp -p 80:80/udp
```

### `ADD`

L’istruzione **`ADD`** consente di **copiare nuovi file, directory o URL remoti** e di **aggiungerli al file system dell’immagine** in un percorso specificato.

```bash
ADD [--chown=<user>:<group>] <src>... <dest>
ADD [--chown=<user>:<group>] ["<src>",... "<dest>"] (this form is required for paths containing whitespace)
```

La destinazione è un percorso assoluto o un percorso relativo a `WORKDIR`, in cui la sorgente verrà copiata all'interno del contenitore di destinazione

**Esempio**

```bash
ADD test relativeDir/          # adds "test" to `WORKDIR`/relativeDir/
ADD test /absoluteDir/         # adds "test" to /absoluteDir/
```

### `COPY`

**L'istruzione `COPY` copia nuovi file o directory da**e li aggiunge al file system del contenitore nel percorso.

```bash
COPY [--chown=<user>:<group>] <src>... <dest>
COPY [--chown=<user>:<group>] ["<src>",... "<dest>"] (this form is required for paths containing whitespace)
```

### `VOLUME`

**L'istruzione `VOLUME` crea un punto di montaggio con il nome specificato e lo contrassegna come contenente volumi montati esternamente dall'host nativo o da altri contenitori.**

```bash
VOLUME ["/data"]
```

**Il comando** `docker run` **inizializza il volume appena creato con tutti i dati presenti nella posizione specificata all'interno dell'immagine di base.**

**Esempio**

```docker
FROM ubuntu
RUN mkdir /myvol
RUN echo "hello world" > /myvol/greeting
VOLUME /myvol
```

Questo `Dockerfile` genera un'immagine che fa sì che `docker run` crei un nuovo punto di montaggio in `/myvol` e copi il file di benvenuto nel volume appena creato.

### `WORKDIR`

L'istruzione `WORKDIR` imposta la directory di lavoro per tutte le istruzioni `RUN` `CMD`, `ENTRYPOINT`, `COPY` e `ADD` che la seguono nel Dockerfile.

Se `WORKDIR` non esiste, verrà creato anche se non verrà utilizzato in alcuna istruzione Dockerfile successiva. Può essere utilizzato piu volte

```docker
WORKDIR /a
WORKDIR b
WORKDIR c
RUN pwd
```

L'output del comando pwd finale in questo Dockerfile sarà /a/b/c.