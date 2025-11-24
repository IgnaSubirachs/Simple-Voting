# Contracte Intel·ligent de Votació Simple (MultiversX)

Aquest és un projecte de contracte intel·ligent de **Votació Simple** per a la blockchain de MultiversX. Permet als usuaris votar per opcions predefinides (per exemple, "Sí", "No") pagant una petita tarifa (preu de l'aposta).

## Visió General del Projecte

- **Xarxa**: MultiversX Devnet
- **Llenguatge**: Rust (framework multiversx-sc)
- **Propòsit**: Demostració del projecte final per al curs de Blockchain.

## Requisits Previs

- **mxpy**: MultiversX Python CLI instal·lat.
- **Cartera (Wallet)**: Un fitxer `devnet.pem` amb alguns xEGLD (tokens de Devnet).

## Com Construir

Per compilar el contracte a WASM:

```bash
sc-meta all build
```

Això generarà `output/simple-voting.wasm`.

## Com Desplegar

Es proporciona un script de PowerShell `deploy.ps1` per simplificar el desplegament a la Devnet.

1. Assegura't de tenir `devnet.pem` a l'arrel del projecte.
2. Executa l'script:

```powershell
./deploy.ps1
```

Això desplegarà el contracte amb:
- **Preu de l'Aposta**: 0.01 EGLD (10000000000000000 wei)
- **Opcions**: "Yes", "No"

## Com Interactuar

### Veure el Contracte a l'Explorador
Ves al [Devnet Explorer](https://devnet-explorer.multiversx.com/) i cerca l'adreça del teu contracte.

### Comprovar el Propietari (CLI)
```bash
mxpy contract query <ADREÇA_DEL_CONTRACTE> --function "getOwner" --proxy https://devnet-gateway.multiversx.com
```

### Votar (CLI)
Per votar "Sí" (índex 0):
```bash
mxpy contract call <ADREÇA_DEL_CONTRACTE> --function "vote" --arguments 0 --value 10000000000000000 --pem devnet.pem --gas-limit 10000000 --proxy https://devnet-gateway.multiversx.com --chain D --send
```
