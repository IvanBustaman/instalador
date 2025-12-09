#!/bin/bash
# setup.sh - Instalador Interactivo Modular (TheHive, Cortex, MISP)

# Detener si hay errores críticos
set -e

# Colores para la interfaz
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# --- FUNCIONES DE INSTALACIÓN ---

preparar_sistema() {
    echo -e "${CYAN}🔧 Preparando sistema (Git + LFS)...${NC}"
    sudo apt-get update
    sudo apt-get install -y git git-lfs
    git lfs install
    echo -e "${GREEN}✅ Sistema listo.${NC}"
}

instalar_thehive() {
    echo -e "${YELLOW}⬇️ Descargando TheHive 4 Legacy...${NC}"
    if [ -d "thehive4" ]; then sudo rm -rf thehive4; fi
    
    # URL del repositorio de TheHive
    git clone https://github.com/IvanBustaman/thehive4.git
    
    echo -e "${YELLOW}🐝 Instalando TheHive...${NC}"
    cd thehive4
    chmod +x install.sh
    sudo ./install.sh
    cd ..
}

instalar_cortex() {
    echo -e "${YELLOW}⬇️ Descargando Cortex 3 Legacy...${NC}"
    if [ -d "cortex" ]; then sudo rm -rf cortex; fi
    
    # URL del repositorio de Cortex
    git clone https://github.com/IvanBustaman/cortex.git
    
    echo -e "${YELLOW}🧠 Instalando Cortex...${NC}"
    cd cortex
    chmod +x install.sh
    sudo ./install.sh
    cd ..
}

instalar_misp() {
    echo -e "${YELLOW}⬇️ Descargando instalador de MISP...${NC}"
    if [ -d "misp" ]; then sudo rm -rf misp; fi
    
    # URL del repositorio de MISP (Aquí es donde va el link nuevo)
    git clone https://github.com/IvanBustaman/misp.git
    
    echo -e "${RED}⚠️  NOTA: Se recomienda instalar MISP en una VM dedicada o con +8GB RAM.${NC}"
    echo -e "Presiona ENTER para continuar o Ctrl+C para cancelar."
    read
    
    echo -e "${YELLOW}🦠 Iniciando instalación de MISP...${NC}"
    cd misp
    chmod +x install.sh
    sudo ./install.sh
    cd ..
}

# --- MENÚ PRINCIPAL ---

clear
echo -e "${CYAN}=============================================${NC}"
echo -e "${CYAN}         MENÚI DE INSTALACIÓN DE MDR         ${NC}"
echo -e "${CYAN}=============================================${NC}"
echo "Seleccione qué desea instalar en este servidor:"
echo ""
echo "  1) Instalar SOLO TheHive 4"
echo "  2) Instalar SOLO Cortex 3"
echo "  3) Instalar SOLO MISP"
echo "  4) Instalar TheHive + Cortex (Stack Básico)"
echo "  5) Salir"
echo ""
read -p "Ingrese una opción [1-5]: " opcion

# Ejecutar preparación básica siempre
preparar_sistema

case $opcion in
    1)
        instalar_thehive
        ;;
    2)
        instalar_cortex
        ;;
    3)
        instalar_misp
        ;;
    4)
        instalar_thehive
        echo -e "${CYAN}-----------------------------------${NC}"
        echo -e "${CYAN}⏳ Esperando 5 segundos antes de continuar con Cortex...${NC}"
        sleep 5
        instalar_cortex
        ;;
    5)
        echo "Saliendo..."
        exit 0
        ;;
    *)
        echo "❌ Opción no válida."
        exit 1
        ;;
esac

echo ""
echo -e "${GREEN}✨ ¡Proceso finalizado!${NC}"
echo "------------------------------------------------"
if [ "$opcion" == "1" ] || [ "$opcion" == "4" ]; then
    echo -e "🐝 Acceso TheHive: http://$(hostname -I | awk '{print $1}'):9000"
fi
if [ "$opcion" == "2" ] || [ "$opcion" == "4" ]; then
    echo -e "🧠 Acceso Cortex:  http://$(hostname -I | awk '{print $1}'):9001"
fi
if [ "$opcion" == "3" ]; then
    echo -e "🦠 Acceso MISP:    https://$(hostname -I | awk '{print $1}')"
fi

echo "------------------------------------------------"
