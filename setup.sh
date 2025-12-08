#!/bin/bash
# setup.sh - Instalador Interactivo Modular para TheHive 4 y Cortex

# Detener si hay errores críticos
set -e

# Colores para la interfaz
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# --- FUNCIONES DE INSTALACIÓN ---

preparar_sistema() {
    echo -e "${CYAN}🔧 Preparando el sistema (Git + LFS)...${NC}"
    sudo apt-get update
    sudo apt-get install -y git git-lfs
    git lfs install
    echo -e "${GREEN}✅ Sistema listo.${NC}"
}

instalar_thehive() {
    echo -e "${YELLOW}⬇️ Descargando TheHive 4 Legacy...${NC}"
    # Limpieza preventiva
    if [ -d "thehive4" ]; then sudo rm -rf thehive4; fi
    
    # Clonar repo específico
    git clone https://github.com/IvanBustaman/thehive4.git
    
    echo -e "${YELLOW}🐝 Instalando TheHive...${NC}"
    cd thehive4
    chmod +x install.sh
    sudo ./install.sh
    cd ..
}

instalar_cortex() {
    echo -e "${YELLOW}⬇️ Descargando Cortex 3 Legacy...${NC}"
    # Limpieza preventiva
    if [ -d "cortex" ]; then sudo rm -rf cortex; fi
    
    # Clonar repo específico
    git clone https://github.com/IvanBustaman/cortex.git
    
    echo -e "${YELLOW}🧠 Instalando Cortex...${NC}"
    cd cortex
    chmod +x install.sh
    sudo ./install.sh
    cd ..
}

# --- MENÚ PRINCIPAL ---

clear
echo -e "${CYAN}=============================================${NC}"
echo -e "${CYAN}        INSTALADOR DE THE HIVE Y CORTEX      ${NC}"
echo -e "${CYAN}=============================================${NC}"
echo ""
echo "Seleccione qué desea instalar en este servidor:"
echo ""
echo "  1) Instalar SOLO TheHive 4"
echo "  2) Instalar SOLO Cortex 3"
echo "  3) Instalar AMBOS (Stack Completo)"
echo "  4) Salir"
echo ""
read -p "Ingrese una opción [1-4]: " opcion

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
        instalar_thehive
        echo -e "${CYAN}-----------------------------------${NC}"
        echo -e "${CYAN}⏳ Esperando 5 segundos antes de continuar con Cortex...${NC}"
        sleep 5
        instalar_cortex
        ;;
    4)
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
if [ "$opcion" == "1" ] || [ "$opcion" == "3" ]; then
    echo -e "🐝 Acceso TheHive: http://$(hostname -I | awk '{print $1}'):9000"
fi
if [ "$opcion" == "2" ] || [ "$opcion" == "3" ]; then
    echo -e "🧠 Acceso Cortex:  http://$(hostname -I | awk '{print $1}'):9001"
fi
echo "------------------------------------------------"
