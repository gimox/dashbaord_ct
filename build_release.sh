#!/usr/bin/env bash

# CyberProTrain Admin - Script di avvio build e release automatica
# Incrementa Major / Minor / Patch, aggiorna pubspec.yaml, esegue commit,
# crea e invia il tag su GitHub Actions compilando macOS, Windows (ZIP + Setup No-Admin) e Linux.

set -e

# Colori per il terminale
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$PROJECT_ROOT"

echo -e "${BLUE}${BOLD}====================================================${NC}"
echo -e "${CYAN}${BOLD}       CyberProTrain Admin - Release Automatica     ${NC}"
echo -e "${BLUE}${BOLD}====================================================${NC}"

# 1. Recupero versione attuale da pubspec.yaml
FULL_VERSION=$(grep "^version:" pubspec.yaml | head -n1 | cut -d ' ' -f2 | tr -d ' \r\n')
if [ -z "$FULL_VERSION" ]; then
  FULL_VERSION="1.0.0+1"
fi

VERSION_CORE=$(echo "$FULL_VERSION" | cut -d '+' -f1)
BUILD_NUM=$(echo "$FULL_VERSION" | cut -d '+' -f2 -s)
if [ -z "$BUILD_NUM" ]; then
  BUILD_NUM=1
fi

IFS='.' read -r MAJOR MINOR PATCH <<< "$VERSION_CORE"
MAJOR=${MAJOR:-1}
MINOR=${MINOR:-0}
PATCH=${PATCH:-0}

NEXT_PATCH="$MAJOR.$MINOR.$((PATCH + 1))"
NEXT_MINOR="$MAJOR.$((MINOR + 1)).0"
NEXT_MAJOR="$((MAJOR + 1)).0.0"

echo -e "\nVersione corrente: ${YELLOW}${BOLD}$VERSION_CORE${NC} (build $BUILD_NUM)"
echo -e "\n${BOLD}Quale incremento di versione vuoi rilasciare?${NC}"
echo -e "  ${GREEN}1)${NC} ${BOLD}Minor Version${NC} (v$VERSION_CORE ➔ ${GREEN}v$NEXT_MINOR${NC}) [Nuove funzionalità / feature]"
echo -e "  ${BLUE}2)${NC} ${BOLD}Major Version${NC} (v$VERSION_CORE ➔ ${BLUE}v$NEXT_MAJOR${NC}) [Breaking changes / release maggiore]"
echo -e "  ${CYAN}3)${NC} ${BOLD}Patch Version${NC} (v$VERSION_CORE ➔ ${CYAN}v$NEXT_PATCH${NC}) [Bugfix / correzioni minori]"
echo -e "  ${RED}4)${NC} Annulla ed esci\n"

read -p "Scelta [1-4]: " CHOICE

case "$CHOICE" in
  1)
    NEW_VERSION="$NEXT_MINOR"
    RELEASE_TYPE="Minor"
    ;;
  2)
    NEW_VERSION="$NEXT_MAJOR"
    RELEASE_TYPE="Major"
    ;;
  3)
    NEW_VERSION="$NEXT_PATCH"
    RELEASE_TYPE="Patch"
    ;;
  4)
    echo -e "${YELLOW}Operazione annullata.${NC}"
    exit 0
    ;;
  *)
    echo -e "${RED}Scelta non valida.${NC}"
    exit 1
    ;;
esac

NEW_BUILD=$((BUILD_NUM + 1))
NEW_TAG="v$NEW_VERSION"

echo -e "\n${YELLOW}=== AVVIO PROCEDURA AUTOMATICA: $RELEASE_TYPE Release $NEW_TAG (build $NEW_BUILD) ===${NC}"

# 2. Aggiornamento automatico di pubspec.yaml
echo -e "${CYAN}1/5. Aggiornamento pubspec.yaml...${NC}"
perl -i -pe "s/^version:.*/version: $NEW_VERSION+$NEW_BUILD/" pubspec.yaml
echo -e "${GREEN}✓ pubspec.yaml impostato a: $NEW_VERSION+$NEW_BUILD${NC}"

# 3. Stage e Commit di tutte le modifiche pendenti
echo -e "${CYAN}2/5. Creazione commit release...${NC}"
git add -A
git commit -m "Release $NEW_TAG ($RELEASE_TYPE bump)" || echo "Nessuna ulteriore modifica da committare."
echo -e "${GREEN}✓ Commit effettuato.${NC}"

# 4. Push del branch corrente su origin
echo -e "${CYAN}3/5. Push del branch su GitHub origin...${NC}"
CURRENT_BRANCH=$(git branch --show-current)
git push origin "$CURRENT_BRANCH"
echo -e "${GREEN}✓ Branch '$CURRENT_BRANCH' sincronizzato con origin.${NC}"

# 5. Creazione e push del tag di release
echo -e "${CYAN}4/5. Creazione del tag $NEW_TAG...${NC}"
if git rev-parse "$NEW_TAG" >/dev/null 2>&1; then
  echo -e "${YELLOW}Tag $NEW_TAG già esistente localmente, ricreazione in corso...${NC}"
  git tag -d "$NEW_TAG"
fi
git tag -a "$NEW_TAG" -m "Release $NEW_TAG ($RELEASE_TYPE bump)"
echo -e "${GREEN}✓ Tag $NEW_TAG creato.${NC}"

echo -e "${CYAN}5/5. Invio del tag a GitHub (trigger GitHub Actions)...${NC}"
git push origin "$NEW_TAG"
echo -e "${GREEN}✓ Tag inviato a GitHub!${NC}"

# 6. Riepilogo finale
echo -e "\n${GREEN}${BOLD}================================================================${NC}"
echo -e "${GREEN}${BOLD}   ✓ TUTTO COMPLETATO CON SUCCESSO! BUILD IN CORSO SU GITHUB    ${NC}"
echo -e "${GREEN}${BOLD}================================================================${NC}"
echo -e "La GitHub Action per ${BOLD}$NEW_TAG${NC} sta compilando:"
echo -e "  • ${BOLD}macOS:${NC} DMG montabile (App_macOS.dmg)"
echo -e "  • ${BOLD}Windows:${NC} ZIP portabile (App_Windows.zip) + Setup No-Admin (App_Windows_Setup.exe)"
echo -e "  • ${BOLD}Linux:${NC} Archivio tar.gz (App_Linux.tar.gz)"
echo -e "\nMonitora lo stato di avanzamento e scarica i file qui:"
echo -e "${BLUE}${BOLD}https://github.com/gimox/dashbaord_ct/actions${NC}\n"
