#!/bin/bash

# =============================================================================
# Script d'Interacció amb el Contracte de Votació Simple (MultiversX)
# =============================================================================
# Aquest script conté totes les comandes necessàries per interactuar amb
# el contracte intel·ligent de votació desplegat a MultiversX Devnet.
#
# IMPORTANT: Substitueix <ADREÇA_DEL_CONTRACTE> per l'adreça real del teu contracte
# =============================================================================

# Colors per a la sortida
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# =============================================================================
# CONFIGURACIÓ
# =============================================================================

# Substitueix aquesta adreça per la del teu contracte desplegat
CONTRACT_ADDRESS="<ADREÇA_DEL_CONTRACTE>"

# Configuració de la xarxa
PROXY="https://devnet-gateway.multiversx.com"
CHAIN_ID="D"
PEM_FILE="devnet.pem"

# Paràmetres de votació
BET_PRICE="10000000000000000"  # 0.01 EGLD en denominació més petita
GAS_LIMIT="10000000"

# =============================================================================
# FUNCIONS D'AJUDA
# =============================================================================

print_header() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}"
}

print_info() {
    echo -e "${GREEN}ℹ ${NC}$1"
}

print_warning() {
    echo -e "${YELLOW}⚠ ${NC}$1"
}

print_error() {
    echo -e "${RED}✗ ${NC}$1"
}

check_contract_address() {
    if [ "$CONTRACT_ADDRESS" == "<ADREÇA_DEL_CONTRACTE>" ]; then
        print_error "Si us plau, actualitza CONTRACT_ADDRESS amb l'adreça real del contracte!"
        exit 1
    fi
}

# =============================================================================
# 1. CONSTRUCCIÓ I DESPLEGAMENT
# =============================================================================

build() {
    print_header "Construint el contracte..."
    sc-meta all build
    print_info "Contracte construït correctament!"
}

deploy() {
    print_header "Desplegant el contracte..."
    print_warning "Assegura't que tens xEGLD suficient al teu wallet!"
    
    # Opcions de votació: "Sí" i "No"
    # Preu per vot: 0.01 EGLD
    mxpy contract deploy \
        --bytecode="output/simple-voting.wasm" \
        --pem="$PEM_FILE" \
        --gas-limit=60000000 \
        --proxy="$PROXY" \
        --chain="$CHAIN_ID" \
        --arguments 10000000000000000 str:Sí str:No \
        --send \
        --recall-nonce
    
    print_info "Contracte desplegat! Copia l'adreça i actualitza CONTRACT_ADDRESS en aquest script."
}

# =============================================================================
# 2. VOTACIÓ
# =============================================================================

vote_yes() {
    check_contract_address
    print_header "Votant SÍ (opció 0)..."
    
    mxpy contract call "$CONTRACT_ADDRESS" \
        --function "vote" \
        --arguments 0 \
        --value "$BET_PRICE" \
        --pem "$PEM_FILE" \
        --gas-limit "$GAS_LIMIT" \
        --proxy "$PROXY" \
        --chain "$CHAIN_ID" \
        --send \
        --recall-nonce
    
    print_info "Vot SÍ enviat correctament!"
}

vote_no() {
    check_contract_address
    print_header "Votant NO (opció 1)..."
    
    mxpy contract call "$CONTRACT_ADDRESS" \
        --function "vote" \
        --arguments 1 \
        --value "$BET_PRICE" \
        --pem "$PEM_FILE" \
        --gas-limit "$GAS_LIMIT" \
        --proxy "$PROXY" \
        --chain "$CHAIN_ID" \
        --send \
        --recall-nonce
    
    print_info "Vot NO enviat correctament!"
}

# =============================================================================
# 3. CONSULTES (VIEWS)
# =============================================================================

get_votes() {
    check_contract_address
    print_header "Consultant resultats de la votació..."
    
    mxpy contract query "$CONTRACT_ADDRESS" \
        --function "getVotes" \
        --proxy "$PROXY"
    
    print_info "Resultats obtinguts!"
}

get_options() {
    check_contract_address
    print_header "Consultant opcions de votació..."
    
    mxpy contract query "$CONTRACT_ADDRESS" \
        --function "getOptions" \
        --proxy "$PROXY"
}

is_open() {
    check_contract_address
    print_header "Verificant si la votació està oberta..."
    
    mxpy contract query "$CONTRACT_ADDRESS" \
        --function "isOpen" \
        --proxy "$PROXY"
}

get_owner() {
    check_contract_address
    print_header "Consultant propietari del contracte..."
    
    mxpy contract query "$CONTRACT_ADDRESS" \
        --function "getOwner" \
        --proxy "$PROXY"
}

get_bet_price() {
    check_contract_address
    print_header "Consultant preu per vot..."
    
    mxpy contract query "$CONTRACT_ADDRESS" \
        --function "getBetPrice" \
        --proxy "$PROXY"
}

# =============================================================================
# 4. GESTIÓ (NOMÉS PROPIETARI)
# =============================================================================

close_voting() {
    check_contract_address
    print_header "Tancant la votació..."
    print_warning "Només el propietari pot executar aquesta acció!"
    
    mxpy contract call "$CONTRACT_ADDRESS" \
        --function "closeVoting" \
        --pem "$PEM_FILE" \
        --gas-limit "$GAS_LIMIT" \
        --proxy "$PROXY" \
        --chain "$CHAIN_ID" \
        --send \
        --recall-nonce
    
    print_info "Votació tancada correctament!"
}

# =============================================================================
# 5. UTILITATS
# =============================================================================

view_in_explorer() {
    check_contract_address
    print_header "Obrint l'explorador..."
    
    EXPLORER_URL="https://devnet-explorer.multiversx.com/accounts/$CONTRACT_ADDRESS"
    print_info "URL: $EXPLORER_URL"
    
    # Intenta obrir l'URL al navegador (funciona a Linux/Mac)
    if command -v xdg-open &> /dev/null; then
        xdg-open "$EXPLORER_URL"
    elif command -v open &> /dev/null; then
        open "$EXPLORER_URL"
    else
        print_warning "Copia l'URL anterior al teu navegador"
    fi
}

show_help() {
    print_header "Script d'Interacció - Contracte de Votació Simple"
    echo ""
    echo "Ús: ./votacions.sh [comanda]"
    echo ""
    echo "Comandes disponibles:"
    echo ""
    echo "  ${GREEN}Construcció i Desplegament:${NC}"
    echo "    build              - Construeix el contracte"
    echo "    deploy             - Desplega el contracte a Devnet"
    echo ""
    echo "  ${GREEN}Votació:${NC}"
    echo "    vote-yes           - Vota SÍ (opció 0)"
    echo "    vote-no            - Vota NO (opció 1)"
    echo ""
    echo "  ${GREEN}Consultes:${NC}"
    echo "    get-votes          - Mostra els resultats de la votació"
    echo "    get-options        - Mostra les opcions disponibles"
    echo "    is-open            - Verifica si la votació està oberta"
    echo "    get-owner          - Mostra el propietari del contracte"
    echo "    get-bet-price      - Mostra el preu per vot"
    echo ""
    echo "  ${GREEN}Gestió (només propietari):${NC}"
    echo "    close-voting       - Tanca la votació"
    echo ""
    echo "  ${GREEN}Utilitats:${NC}"
    echo "    explorer           - Obre el contracte a l'explorador"
    echo "    help               - Mostra aquesta ajuda"
    echo ""
    echo "Exemples:"
    echo "  ./votacions.sh build"
    echo "  ./votacions.sh vote-yes"
    echo "  ./votacions.sh get-votes"
    echo ""
}

# =============================================================================
# MENÚ PRINCIPAL
# =============================================================================

case "$1" in
    # Construcció i desplegament
    build)
        build
        ;;
    deploy)
        deploy
        ;;
    
    # Votació
    vote-yes)
        vote_yes
        ;;
    vote-no)
        vote_no
        ;;
    
    # Consultes
    get-votes)
        get_votes
        ;;
    get-options)
        get_options
        ;;
    is-open)
        is_open
        ;;
    get-owner)
        get_owner
        ;;
    get-bet-price)
        get_bet_price
        ;;
    
    # Gestió
    close-voting)
        close_voting
        ;;
    
    # Utilitats
    explorer)
        view_in_explorer
        ;;
    help|--help|-h)
        show_help
        ;;
    
    # Per defecte
    *)
        print_error "Comanda desconeguda: $1"
        echo ""
        show_help
        exit 1
        ;;
esac
