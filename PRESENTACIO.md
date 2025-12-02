# Presentació del Projecte: Simple Voting Smart Contract

**Projecte Final - Curs de Blockchain**  
**Autor**: Igna Subirachs  
**Data**: Desembre 2025

---

## 📑 Índex

1. [Introducció](#introducció)
2. [Què és la Blockchain?](#què-és-la-blockchain)
3. [Què són els Smart Contracts?](#què-són-els-smart-contracts)
4. [El Projecte Simple Voting](#el-projecte-simple-voting)
5. [Implementació Tècnica](#implementació-tècnica)
6. [Casos d'Ús Pràctics](#casos-dús-pràctics)
7. [Demostració en Viu](#demostració-en-viu)
8. [Conclusions i Aprenentatges](#conclusions-i-aprenentatges)

---

## 1. Introducció

### Objectiu del Projecte
Desenvolupar un **Smart Contract de votació** a la blockchain de **MultiversX** que permeti:
- Crear votacions transparents i immutables
- Garantir que cada participant voti només una vegada
- Proporcionar resultats verificables en temps real
- Demostrar els avantatges de la tecnologia blockchain

### Per què aquest projecte?
La votació és un procés fonamental en qualsevol societat democràtica. Tradicionalment, els sistemes de votació tenen problemes de:
- **Confiança**: Cal confiar en qui compta els vots
- **Transparència**: No sempre es pot verificar el procés
- **Manipulació**: Possibilitat de frau o alteració de resultats
- **Costos**: Sistemes centralitzats cars i complexos

La blockchain resol aquests problemes de manera elegant i tecnològica.

---

## 2. Què és la Blockchain?

### Definició Simple
La **blockchain** (cadena de blocs) és com un **llibre de comptabilitat digital compartit i immutable**. Imagina una llibreta on:
- Tothom pot escriure
- Ningú pot esborrar ni modificar el que ja s'ha escrit
- Tothom té una còpia idèntica
- Tots poden verificar que tot és correcte

### Característiques Clau

#### 🔗 Descentralització
- No hi ha una autoritat central (com un banc o govern)
- La informació està replicada en milers d'ordinadors (nodes) arreu del món
- Si un node falla, la xarxa continua funcionant
- **Exemple**: Bitcoin no té cap president ni oficina central

#### 🔒 Seguretat Criptogràfica
- Cada bloc d'informació està enllaçat amb l'anterior mitjançant criptografia
- Modificar un bloc antic requereix modificar TOTS els blocs posteriors
- Això és matemàticament impossible amb la tecnologia actual
- **Analogia**: Com una cadena on cada anella està soldada a l'anterior

#### 👁️ Transparència
- Totes les transaccions són públiques i verificables
- Qualsevol persona pot consultar l'historial complet
- Les identitats són pseudònimes (adreces criptogràfiques)
- **Exemple**: Pots veure totes les transaccions de Bitcoin des de 2009

#### ⏱️ Immutabilitat
- Un cop una transacció està confirmada, no es pot canviar
- L'historial és permanent i inalterable
- Això crea un registre fiable i auditable
- **Exemple**: Com un tatuatge digital que no es pot esborrar

### Com Funciona?

```
1. TRANSACCIÓ
   Un usuari fa una acció (enviar diners, votar, etc.)
   ↓
2. VALIDACIÓ
   Els nodes de la xarxa verifiquen que l'acció sigui vàlida
   ↓
3. BLOC
   L'acció s'agrupa amb altres en un "bloc"
   ↓
4. CONSENS
   La xarxa acorda que el bloc és vàlid
   ↓
5. CADENA
   El bloc s'afegeix a la cadena per sempre
```

### MultiversX: La Blockchain que Utilitzem
- **Ràpida**: 15.000 transaccions per segon
- **Econòmica**: Comissions molt baixes
- **Escalable**: Tecnologia de "sharding" (fragmentació)
- **Sostenible**: Consum energètic mínim
- **Desenvolupador-friendly**: Llenguatge Rust per als smart contracts

---

## 3. Què són els Smart Contracts?

### Definició
Un **Smart Contract** (contracte intel·ligent) és un **programa informàtic que s'executa automàticament a la blockchain** quan es compleixen certes condicions predefinides.

### Analogia del Món Real: La Màquina Expenedora

Imagina una màquina de refrescs:
1. **Regles clares**: "Si poses 2€, obtens una Coca-Cola"
2. **Automàtica**: No cal un venedor
3. **Transparent**: Veus què obtens abans de pagar
4. **Immutable**: La màquina no pot canviar les regles a mitja transacció

Un smart contract funciona igual, però a la blockchain:
```
SI (usuari envia 0.01 EGLD) I (usuari no ha votat abans)
LLAVORS (registrar vot) I (sumar-lo al comptador)
ALTRAMENT (rebutjar transacció)
```

### Característiques dels Smart Contracts

#### 🤖 Autonomia
- S'executen sols, sense intermediaris
- No cal advocat, notari o àrbitre
- El codi és la llei
- **Exemple**: Un contracte de lloguer que transfereix automàticament el dipòsit quan acaba el contracte

#### 🔐 Immutabilitat
- Un cop desplegat, el codi no es pot canviar (normalment)
- Garanteix que les regles són les mateixes per a tothom
- Elimina la possibilitat de trampa
- **Important**: Per això cal revisar molt bé el codi abans de desplegar-lo!

#### 💰 Sense Confiança (Trustless)
- No cal confiar en l'altra part
- El codi garanteix l'execució
- La blockchain verifica tot automàticament
- **Exemple**: Pots fer negocis amb desconeguts sense por

#### 🌍 Transparent
- El codi és públic i auditable
- Tothom pot veure com funciona
- No hi ha "lletra petita" oculta
- **Avantatge**: Seguretat per transparència

### Llenguatge: Rust
El nostre smart contract està escrit en **Rust**, un llenguatge de programació:
- **Segur**: Evita errors comuns de memòria
- **Ràpid**: Rendiment similar a C/C++
- **Modern**: Eines i ecosistema excel·lents
- **Preferit per MultiversX**: Compilació a WebAssembly (WASM)

---

## 4. El Projecte Simple Voting

### Descripció General
Simple Voting és un smart contract que implementa un **sistema de votació descentralitzat** on:
- El propietari crea una votació amb opcions definides
- Els usuaris voten pagant una petita taxa (0.01 EGLD)
- Cada usuari només pot votar una vegada
- Els resultats són públics i verificables en temps real
- El propietari pot tancar la votació quan vulgui

### Funcionalitats Principals

#### 1️⃣ Inicialització (Deploy)
```rust
#[init]
fn init(&self, options: MultiValueEncoded<ManagedBuffer>, vote_price: BigUint)
```
- El propietari desplega el contracte
- Defineix les opcions de votació (ex: "Sí", "No")
- Estableix el preu per votar (ex: 0.01 EGLD)
- La votació comença oberta automàticament

#### 2️⃣ Votar
```rust
#[payable("EGLD")]
#[endpoint]
fn vote(&self, option_index: usize)
```
- L'usuari envia una transacció amb EGLD
- Especifica l'índex de l'opció (0 = primera opció, 1 = segona, etc.)
- El contracte verifica:
  - ✅ Que la votació estigui oberta
  - ✅ Que l'usuari no hagi votat abans
  - ✅ Que l'opció existeixi
  - ✅ Que hagi pagat la quantitat correcta
- Si tot és correcte, registra el vot

#### 3️⃣ Consultar Resultats
```rust
#[view(getVotes)]
fn get_votes(&self) -> MultiValueEncoded<BigUint>
```
- Qualsevol pot consultar els resultats
- Retorna el nombre de vots per cada opció
- Actualitzat en temps real
- No requereix pagar res (és una "view")

#### 4️⃣ Tancar Votació
```rust
#[only_owner]
#[endpoint(closeVoting)]
fn close_voting(&self)
```
- Només el propietari pot executar aquesta funció
- Marca la votació com a tancada
- A partir d'aquest moment, no s'accepten més vots
- Els resultats queden fixats permanentment

#### 5️⃣ Verificar Estat
```rust
#[view(isOpen)]
fn is_open(&self) -> bool
```
- Retorna si la votació està oberta o tancada
- Útil abans d'intentar votar

### Estructura de Dades

El contracte emmagatzema:
- **options**: Vector amb els noms de les opcions
- **votes**: Mapa que compta els vots per cada opció
- **voters**: Conjunt d'adreces que ja han votat
- **vote_price**: Preu per votar
- **is_open**: Estat de la votació (oberta/tancada)

---

## 5. Implementació Tècnica

### Arquitectura del Projecte

```
simple-voting/
├── src/
│   └── lib.rs              # Codi del smart contract en Rust
├── output/
│   └── simple-voting.wasm  # Contracte compilat
├── devnet.pem              # Clau privada per desplegar
├── deploy.ps1              # Script de desplegament
├── votacions.sh            # Script CLI per interactuar
├── LICENSE                 # Llicència MIT
└── README.md               # Documentació
```

### Flux de Desplegament

```bash
# 1. Compilar el contracte Rust a WASM
sc-meta all build

# 2. Desplegar a la xarxa de proves (Devnet)
./deploy.ps1

# 3. Obtenir l'adreça del contracte
# Exemple: erd1qqqqqqqqqqqqqpgq...
```

### Interacció amb el Contracte

Hem creat un **script CLI** (`votacions.sh`) que facilita totes les operacions:

```bash
# Votar Sí (opció 0)
./votacions.sh vote-yes

# Votar No (opció 1)
./votacions.sh vote-no

# Consultar resultats
./votacions.sh get-votes

# Tancar votació (només propietari)
./votacions.sh close-voting

# Verificar si està oberta
./votacions.sh is-open
```

### Comandes mxpy Subjacents

Darrere de l'script, s'executen comandes `mxpy`:

```bash
# Votar
mxpy contract call <ADREÇA> \
  --function "vote" \
  --arguments 0 \
  --value 10000000000000000 \
  --pem devnet.pem \
  --gas-limit 10000000 \
  --proxy https://devnet-gateway.multiversx.com \
  --chain D \
  --send

# Consultar
mxpy contract query <ADREÇA> \
  --function "getVotes" \
  --proxy https://devnet-gateway.multiversx.com
```

### Explorador de Blockchain

Podem veure totes les transaccions al [MultiversX Devnet Explorer](https://devnet-explorer.multiversx.com/):
- Historial complet de vots
- Adreces dels votants
- Quantitats transferides
- Gas consumit
- Estat del contracte

---

## 6. Casos d'Ús Pràctics

### Cas 1: Associació d'Estudiants 🎓

**Situació**: Decidir el destí del viatge de fi de curs

**Problema tradicional**:
- Algú ha de comptar els vots manualment
- Possibilitat de vots duplicats
- Dificultat per verificar els resultats
- Desconfiança en el procés

**Solució amb Simple Voting**:
1. El president desplega el contracte amb opcions: "Barcelona", "París", "Roma"
2. Cada estudiant vota des de la seva wallet
3. El contracte garanteix un vot per persona
4. Resultats visibles en temps real
5. Decisió transparent i verificable

**Avantatges**:
- ✅ Impossible votar dues vegades
- ✅ Recompte automàtic i instantani
- ✅ Transparència total
- ✅ Sense necessitat de confiar en ningú

### Cas 2: Comunitat de Veïns 🏢

**Situació**: Decidir si instal·lar plaques solars

**Problema tradicional**:
- Reunions presencials obligatòries
- Vots en paper fàcils de manipular
- Recompte manual propens a errors
- Desconfiança en l'administrador

**Solució amb Simple Voting**:
1. L'administrador crea la votació: "Sí a plaques solars" vs "No"
2. Cada veí vota des de casa amb la seva wallet
3. No cal reunió presencial
4. Resultats certificats per la blockchain
5. Registre permanent de la decisió

**Avantatges**:
- ✅ Participació remota
- ✅ Immutabilitat del resultat
- ✅ Auditoria permanent
- ✅ Reducció de costos

### Cas 3: Organització Empresarial 💼

**Situació**: Enquesta sobre horari flexible

**Problema tradicional**:
- Por a represàlies (falta d'anonimat)
- Possibilitat de manipulació de resultats
- Dificultat per verificar participació
- Costos de sistemes d'enquestes

**Solució amb Simple Voting**:
1. RRHH crea la votació: "A favor horari flexible" vs "En contra"
2. Empleats voten amb pseudonimitat (wallet)
3. Resultats verificables però identitats protegides
4. Decisió basada en dades objectives

**Avantatges**:
- ✅ Pseudonimitat (només es veu l'adreça)
- ✅ Impossible alterar resultats
- ✅ Baix cost
- ✅ Alta confiança en el procés

### Cas 4: DAO (Organització Autònoma Descentralitzada) 🌐

**Situació**: Decidir inversió en nou projecte

**Problema tradicional**:
- Necessitat de votacions presencials
- Costos de notaris i intermediaris
- Lentitud en el procés
- Dificultat per participants internacionals

**Solució amb Simple Voting**:
1. La DAO crea votació: "Invertir en Projecte X" vs "No invertir"
2. Membres de tot el món voten
3. La taxa de votació va a un fons comú
4. Decisió executada automàticament segons resultats

**Avantatges**:
- ✅ Participació global instantània
- ✅ Sense intermediaris
- ✅ Execució automàtica
- ✅ Governança descentralitzada

---

## 7. Demostració en Viu

### Preparació

1. **Verificar requisits**:
   ```bash
   # Comprovar que mxpy està instal·lat
   mxpy --version
   
   # Verificar que tenim EGLD a la wallet
   mxpy wallet pem-address devnet.pem
   ```

2. **Compilar i desplegar**:
   ```bash
   # Compilar
   sc-meta all build
   
   # Desplegar
   ./deploy.ps1
   ```

3. **Anotar l'adreça del contracte** que apareix després del desplegament

### Escenari de Demostració

**Pregunta**: "Estàs a favor d'implementar blockchain a l'empresa?"

**Opcions**: 
- Opció 0: "Sí, implementem blockchain"
- Opció 1: "No, esperem més temps"

### Pas a Pas

#### Pas 1: Votar "Sí"
```bash
./votacions.sh vote-yes
```
**Què passa**:
- S'envia una transacció a la blockchain
- Es paguen 0.01 EGLD
- El contracte registra el vot
- La nostra adreça queda marcada com "ja ha votat"

#### Pas 2: Consultar Resultats
```bash
./votacions.sh get-votes
```
**Resultat esperat**:
```
Opció 0 (Sí): 1 vot
Opció 1 (No): 0 vots
```

#### Pas 3: Intentar Votar Novament (Error Esperat)
```bash
./votacions.sh vote-yes
```
**Resultat esperat**:
```
Error: User has already voted
```
**Demostració**: El contracte impedeix vots duplicats!

#### Pas 4: Votar "No" des d'una Altra Wallet
```bash
# Canviar a una altra wallet
./votacions.sh vote-no
```

#### Pas 5: Consultar Resultats Actualitzats
```bash
./votacions.sh get-votes
```
**Resultat esperat**:
```
Opció 0 (Sí): 1 vot
Opció 1 (No): 1 vot
```

#### Pas 6: Tancar la Votació
```bash
./votacions.sh close-voting
```
**Només funciona** si som el propietari!

#### Pas 7: Verificar que està Tancada
```bash
./votacions.sh is-open
```
**Resultat esperat**:
```
false
```

#### Pas 8: Intentar Votar amb Votació Tancada
```bash
./votacions.sh vote-yes
```
**Resultat esperat**:
```
Error: Voting is closed
```

### Verificació a l'Explorador

1. Anar a [https://devnet-explorer.multiversx.com/](https://devnet-explorer.multiversx.com/)
2. Buscar l'adreça del contracte
3. Veure:
   - Totes les transaccions de vot
   - Adreces dels votants
   - Quantitats transferides
   - Estat actual del contracte

---

## 8. Conclusions i Aprenentatges

### Què He Après

#### 💡 Conceptes de Blockchain
- Com funciona una blockchain descentralitzada
- La importància de la immutabilitat i transparència
- El consens distribuït i la seguretat criptogràfica
- Les diferències entre blockchains (Bitcoin, Ethereum, MultiversX)

#### 🔧 Smart Contracts
- Com programar contractes intel·ligents en Rust
- La importància de la seguretat en el codi
- Gestió d'estat i emmagatzematge a la blockchain
- Interacció amb wallets i transaccions

#### 🛠️ Eines i Tecnologies
- **mxpy**: CLI de MultiversX per desplegar i interactuar
- **Rust**: Llenguatge de programació segur i eficient
- **WebAssembly (WASM)**: Format de compilació per smart contracts
- **Git/GitHub**: Control de versions i col·laboració

#### 🎯 Desenvolupament de Projectes
- Planificació i disseny d'un sistema descentralitzat
- Documentació clara i completa
- Testing i verificació de funcionalitats
- Creació d'eines per facilitar l'ús (scripts CLI)

### Avantatges de la Blockchain per a Votacions

| Aspecte | Sistema Tradicional | Blockchain |
|---------|-------------------|------------|
| **Confiança** | Cal confiar en l'organitzador | Verificable matemàticament |
| **Transparència** | Limitada | Total i auditable |
| **Immutabilitat** | Vots poden alterar-se | Impossible modificar |
| **Costos** | Alts (personal, infraestructura) | Baixos (només gas fees) |
| **Velocitat** | Recompte manual lent | Instantani i automàtic |
| **Accessibilitat** | Presencial o sistemes complexos | Des de qualsevol lloc amb internet |
| **Auditoria** | Difícil i costosa | Permanent i gratuïta |

### Limitacions i Millores Futures

#### Limitacions Actuals
- **Pseudonimitat vs Anonimat**: Les adreces són visibles (no és anonimat complet)
- **Cost de participació**: Cal tenir EGLD i pagar gas fees
- **Barrera tècnica**: Cal tenir wallet i coneixements bàsics
- **Immutabilitat del codi**: Errors en el contracte són difícils de corregir

#### Possibles Millores
1. **Sistema de delegació**: Permetre que altres votin en nom teu
2. **Votacions ponderades**: Vots amb diferents pesos segons criteris
3. **Votació secreta**: Implementar criptografia per ocultar vots fins al final
4. **Múltiples rondes**: Votacions amb segona volta
5. **Integració amb identitat digital**: Verificar identitat real mantenint privacitat
6. **Interfície web**: Crear una UI amigable sense necessitat de CLI

### Reflexió Personal

Aquest projecte m'ha permès entendre que **la blockchain no és només criptomonedes**. És una tecnologia fonamental que pot transformar:
- Sistemes de votació i governança
- Cadenes de subministrament
- Registres de propietat
- Sistemes financers
- Identitat digital
- I molt més...

El més important que he après és que **la descentralització no és només tecnologia, és una filosofia**: eliminar intermediaris, donar poder als usuaris, i crear sistemes més justos i transparents.

### Aplicacions Futures

Amb els coneixements adquirits, podria desenvolupar:
- **Sistema de governança per a una DAO**
- **Plataforma de crowdfunding descentralitzada**
- **Registre de títols acadèmics a la blockchain**
- **Sistema de trazabilitat per a productes**
- **Marketplace descentralitzat (NFTs)**

---

## 📚 Referències i Recursos

### Documentació Oficial
- [MultiversX Documentation](https://docs.multiversx.com/)
- [Rust Smart Contract Framework](https://docs.multiversx.com/developers/developer-reference/rust-smart-contract-build-reference/)
- [mxpy CLI Tool](https://docs.multiversx.com/sdk-and-tools/sdk-py/mxpy-cli/)

### Exploradors
- [Devnet Explorer](https://devnet-explorer.multiversx.com/)
- [Mainnet Explorer](https://explorer.multiversx.com/)

### Repositori del Projecte
- [GitHub: Simple-Voting](https://github.com/IgnaSubirachs/Simple-Voting)

### Aprenentatge Addicional
- [Blockchain Basics](https://www.blockchain.com/learning-portal/blockchain-basics)
- [Smart Contracts Explained](https://ethereum.org/en/smart-contracts/)
- [Rust Programming Language](https://www.rust-lang.org/learn)

---

## 🙏 Agraïments

Gràcies per l'atenció! Aquest projecte ha estat una experiència d'aprenentatge increïble que m'ha obert les portes al món de la blockchain i els smart contracts.

**Preguntes?** 🤔

---

**Llicència**: MIT License - Consulta [LICENSE](LICENSE) per a més detalls.
