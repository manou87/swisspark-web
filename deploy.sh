#!/bin/bash

# 🚀 Script de déploiement SwissPark
# Ce script automatise le déploiement de votre site web

echo "🚀 Déploiement SwissPark en cours..."

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
DOMAIN="suissepark.ch"
BUILD_DIR="dist"
SOURCE_DIR="."

# Vérification des prérequis
check_prerequisites() {
    echo -e "${BLUE}📋 Vérification des prérequis...${NC}"
    
    # Vérifier si Node.js est installé
    if ! command -v node &> /dev/null; then
        echo -e "${RED}❌ Node.js n'est pas installé${NC}"
        echo "Installez Node.js depuis https://nodejs.org/"
        exit 1
    fi
    
    # Vérifier si npm est installé
    if ! command -v npm &> /dev/null; then
        echo -e "${RED}❌ npm n'est pas installé${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}✅ Prérequis vérifiés${NC}"
}

# Nettoyage et préparation
prepare_build() {
    echo -e "${BLUE}🧹 Préparation du build...${NC}"
    
    # Nettoyer le dossier de build
    if [ -d "$BUILD_DIR" ]; then
        rm -rf "$BUILD_DIR"
    fi
    
    # Créer le dossier de build
    mkdir -p "$BUILD_DIR"
    
    echo -e "${GREEN}✅ Build préparé${NC}"
}

# Construction du projet
build_project() {
    echo -e "${BLUE}🔨 Construction du projet...${NC}"
    
    # Copier les fichiers source
    cp -r "$SOURCE_DIR"/* "$BUILD_DIR/"
    
    # Supprimer les fichiers de développement
    cd "$BUILD_DIR"
    rm -f deploy.sh README.md vercel.json
    
    # Minifier CSS (si cssnano est installé)
    if command -v cssnano &> /dev/null; then
        echo "Minification CSS..."
        cssnano styles.css styles.min.css
        mv styles.min.css styles.css
    fi
    
    # Minifier JavaScript (si terser est installé)
    if command -v terser &> /dev/null; then
        echo "Minification JavaScript..."
        terser script.js -o script.min.js
        mv script.min.js script.js
    fi
    
    cd ..
    
    echo -e "${GREEN}✅ Projet construit${NC}"
}

# Vérification de la qualité
quality_check() {
    echo -e "${BLUE}🔍 Vérification de la qualité...${NC}"
    
    cd "$BUILD_DIR"
    
    # Vérifier que tous les fichiers sont présents
    required_files=("index.html" "styles.css" "script.js")
    for file in "${required_files[@]}"; do
        if [ ! -f "$file" ]; then
            echo -e "${RED}❌ Fichier manquant: $file${NC}"
            exit 1
        fi
    done
    
    # Vérifier la taille des fichiers
    echo "📊 Taille des fichiers:"
    ls -lh *.html *.css *.js
    
    cd ..
    
    echo -e "${GREEN}✅ Qualité vérifiée${NC}"
}

# Déploiement Vercel
deploy_vercel() {
    echo -e "${BLUE}🌐 Déploiement sur Vercel...${NC}"
    
    if ! command -v vercel &> /dev/null; then
        echo -e "${YELLOW}⚠️  Vercel CLI non installé${NC}"
        echo "Installez-le avec: npm i -g vercel"
        echo "Puis connectez-vous avec: vercel login"
        return 1
    fi
    
    cd "$BUILD_DIR"
    
    # Déployer sur Vercel
    vercel --prod --yes
    
    cd ..
    
    echo -e "${GREEN}✅ Déployé sur Vercel${NC}"
}

# Déploiement Netlify
deploy_netlify() {
    echo -e "${BLUE}🌐 Déploiement sur Netlify...${NC}"
    
    if ! command -v netlify &> /dev/null; then
        echo -e "${YELLOW}⚠️  Netlify CLI non installé${NC}"
        echo "Installez-le avec: npm i -g netlify-cli"
        echo "Puis connectez-vous avec: netlify login"
        return 1
    fi
    
    cd "$BUILD_DIR"
    
    # Déployer sur Netlify
    netlify deploy --prod --dir=.
    
    cd ..
    
    echo -e "${GREEN}✅ Déployé sur Netlify${NC}"
}

# Déploiement FTP
deploy_ftp() {
    echo -e "${BLUE}🌐 Déploiement FTP...${NC}"
    
    if [ -z "$FTP_HOST" ] || [ -z "$FTP_USER" ] || [ -z "$FTP_PASS" ]; then
        echo -e "${YELLOW}⚠️  Variables FTP non configurées${NC}"
        echo "Configurez FTP_HOST, FTP_USER, FTP_PASS"
        return 1
    fi
    
    # Utiliser lftp pour le déploiement FTP
    if command -v lftp &> /dev/null; then
        lftp -c "open -u $FTP_USER,$FTP_PASS $FTP_HOST; mirror -R $BUILD_DIR/ /"
        echo -e "${GREEN}✅ Déployé via FTP${NC}"
    else
        echo -e "${RED}❌ lftp non installé${NC}"
        echo "Installez lftp pour le déploiement FTP"
    fi
}

# Test du déploiement
test_deployment() {
    echo -e "${BLUE}🧪 Test du déploiement...${NC}"
    
    if [ -n "$DEPLOY_URL" ]; then
        echo "Test de l'URL: $DEPLOY_URL"
        
        # Vérifier que le site répond
        if curl -s -o /dev/null -w "%{http_code}" "$DEPLOY_URL" | grep -q "200"; then
            echo -e "${GREEN}✅ Site accessible${NC}"
        else
            echo -e "${RED}❌ Site inaccessible${NC}"
        fi
    else
        echo -e "${YELLOW}⚠️  URL de déploiement non spécifiée${NC}"
    fi
}

# Menu principal
show_menu() {
    echo -e "${BLUE}🎯 Choisissez votre méthode de déploiement:${NC}"
    echo "1) Vercel (Recommandé)"
    echo "2) Netlify"
    echo "3) FTP"
    echo "4) Build uniquement"
    echo "5) Quitter"
    echo ""
    read -p "Votre choix (1-5): " choice
}

# Exécution principale
main() {
    echo -e "${GREEN}🎉 Bienvenue dans le déploiement SwissPark!${NC}"
    echo "Domaine cible: $DOMAIN"
    echo ""
    
    check_prerequisites
    prepare_build
    build_project
    quality_check
    
    show_menu
    
    case $choice in
        1)
            deploy_vercel
            ;;
        2)
            deploy_netlify
            ;;
        3)
            deploy_ftp
            ;;
        4)
            echo -e "${GREEN}✅ Build terminé dans le dossier $BUILD_DIR${NC}"
            echo "Uploadez manuellement les fichiers sur votre hébergement"
            ;;
        5)
            echo -e "${YELLOW}👋 Au revoir!${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}❌ Choix invalide${NC}"
            exit 1
            ;;
    esac
    
    if [ $? -eq 0 ]; then
        echo ""
        echo -e "${GREEN}🎉 Déploiement terminé avec succès!${NC}"
        echo "Votre site est maintenant accessible sur $DOMAIN"
        echo ""
        echo "📱 Prochaines étapes:"
        echo "1. Configurez votre DNS pour pointer vers $DOMAIN"
        echo "2. Testez votre site sur différents appareils"
        echo "3. Configurez Google Analytics"
        echo "4. Testez les performances avec Lighthouse"
    else
        echo -e "${RED}❌ Déploiement échoué${NC}"
        exit 1
    fi
}

# Exécuter le script principal
main "$@"
