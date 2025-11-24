# Contracte Intel·ligent de Votació Simple (MultiversX)

Aquest projecte és una demostració pràctica d'un **Contracte Intel·ligent (Smart Contract)** desplegat a la blockchain de **MultiversX**. Ha estat desenvolupat com a projecte final per al curs de Blockchain.

## 📚 Què hem après? Conceptes Clau

### 1. Què és la Blockchain?
La Blockchain (cadena de blocs) és com un llibre de comptabilitat digital compartit i immutable. Imagina una llibreta on tothom pot escriure, però ningú pot esborrar ni modificar el que ja s'ha escrit.
- **Descentralització**: No hi ha una autoritat central (com un banc). La informació està copiada en milers d'ordinadors (nodes) arreu del món.
- **Seguretat**: Cada bloc d'informació està enllaçat amb l'anterior mitjançant criptografia, fent impossible modificar les dades sense que tothom se n'adoni.
- **Transparència**: Totes les transaccions són públiques i verificables per qualsevol persona.

### 2. Com funciona?
Quan algú fa una acció (com enviar diners o votar), aquesta acció s'agrupa amb altres en un "bloc". Els ordinadors de la xarxa verifiquen que l'acció sigui vàlida. Un cop validat, el bloc s'afegeix a la cadena per sempre.

### 3. Què són els Smart Contracts?
Són programes informàtics que s'executen automàticament a la blockchain quan es compleixen certes condicions.
- Són **autònoms**: No necessiten intermediaris (advocats, notaris) per funcionar.
- Són **immutables**: Un cop desplegat, el codi no es pot canviar (normalment), garantint que les regles del joc són les mateixes per a tothom.
- En aquest projecte, el Smart Contract actua com a **àrbitre imparcial** de la votació: compta els vots i assegura que ningú voti dues vegades.

---

## 🗳️ Sobre aquest Projecte: Simple Voting

Aquest contracte permet crear una votació amb opcions definides (per exemple, "Sí" i "No") i permet als usuaris participar-hi pagant una petita quantitat de criptomoneda (EGLD) com a "aposta" o taxa de votació.

### Funcionalitats i Accions
Amb aquest contracte podem realitzar les següents accions a la blockchain:

1.  **Inicialitzar (Deploy)**: El propietari crea la votació, defineix les opcions i el preu per votar.
2.  **Votar (`vote`)**: Qualsevol usuari amb una cartera (wallet) pot enviar una transacció per votar per una opció.
    *   El contracte verifica automàticament si l'usuari ja ha votat.
    *   Si tot és correcte, suma el vot i registra l'usuari.
3.  **Consultar Resultats (`getVotes`)**: Tothom pot veure en temps real quants vots té cada opció.
4.  **Tancar Votació (`closeVoting`)**: Només el propietari pot tancar la votació, impedint nous vots.

---

## 🛠️ Instruccions Tècniques

### Requisits Previs
- **mxpy**: Eina de línia de comandes de MultiversX.
- **Cartera (Wallet)**: Un fitxer `devnet.pem` amb xEGLD (moneda de prova).

### Com Construir (Build)
Per traduir el codi Rust a un format que la màquina virtual de MultiversX entengui (WASM):

```bash
sc-meta all build
```

### Com Desplegar (Deploy)
Hem creat un script automàtic per facilitar aquesta tasca a la xarxa de proves (Devnet):

```powershell
./deploy.ps1
```

### Com Interactuar

**Veure el Contracte a l'Explorador:**
Pots veure totes les transaccions i l'estat del contracte al [Devnet Explorer](https://devnet-explorer.multiversx.com/).

**Votar (Exemple per consola):**
Per votar per la primera opció ("Sí"):
```bash
mxpy contract call <ADREÇA_DEL_CONTRACTE> --function "vote" --arguments 0 --value 10000000000000000 --pem devnet.pem --gas-limit 10000000 --proxy https://devnet-gateway.multiversx.com --chain D --send
```
