#!/bin/bash

# Actualizar la lista de paquetes
echo "Actualizando la lista de paquetes..."
sudo apt update -y

# Actualizar los paquetes instalados
echo "Actualizando los paquetes instalados..."
sudo apt upgrade -y

# Instalar programas comunes
echo "Instalando programas comunes..."
sudo apt install -y \
    git \
    curl \
    wget \
    build-essential \
    htop \
    neofetch \
    gitg 

# Instalando Vivaldi
echo "Importar la clave pública (para permitir la verificación del repositorio APT): "
wget -qO- https://repo.vivaldi.com/archive/linux_signing_key.pub | gpg --dearmor | sudo dd of=/usr/share/keyrings/vivaldi-browser.gpg
echo "Agregar el repositorio:"
echo "deb [signed-by=/usr/share/keyrings/vivaldi-browser.gpg arch=$(dpkg --print-architecture)] https://repo.vivaldi.com/archive/deb/ stable main" | sudo dd of=/etc/apt/sources.list.d/vivaldi-archive.list
echo "Instalando Vivaldi"
sudo apt update && sudo apt install vivaldi-stable -y

# Instalando Brave Browser
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo apt install -y \
    brave-browser


read -p "¿Deseas Configurar Git ahora? (s/n): " git_response
if [[ "$git_response" == "s" || "$git_response" == "S" ]]; then
    # Configurar Git
    echo "Configurando Git..."
    read -p "Introduce tu nombre de usuario de Git: " git_username
    git config --global user.name "$git_username"
    read -p "Introduce tu correo electrónico de Git: " git_email
    git config --global user.email "$git_email"
    git config --global user.ui true
    git config --global init.defaultBranch main
    git config --global core.autocrlf
    git config --global core.autocrlf input
fi


#Instalando Utilidades 
sudo apt install -y \
    p7zip-full \
    p7zip-rar \
    rar \
    unrar \ 
    ffmpeg \
    libavcodec-extra \
    gstreamer1.0-libav \
    gstreamer1.0-plugins-ugly \
    gstreamer1.0-plugins-bad  \
    gstreamer1.0-pulseaudio  \
    vorbis-tools
# Desinstalar Programas 
echo "Desintalando Gnome Games"
sudo apt purge -y \
    gnome-games \
    libgnome-games-support-1-3 \
    libgnome-games-support-common \
    cheese \
    zutty
#Desinstalando Firefox-ESR
echo "Desinstalando Firefox-ESR"
echo "Eliminar la versión de Firefox ESR de nuestro Sistema"
sudo apt purge -y \
    firefox-esr
echo "Agregar e Importar la llave (key) del repositorio oficial de Mozilla"
wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | sudo tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null
gpg -n -q --import --import-options import-show /etc/apt/keyrings/packages.mozilla.org.asc | awk '/pub/{getline; gsub(/^ +| +$/,""); print "\n"$0"\n"}'
echo "Agregamos el nuevo repositorio"
echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" | sudo tee -a /etc/apt/sources.list.d/mozilla.list > /dev/null
echo "Tenemos que darle prioridad a este nuevo repositorio"
echo '
Package: *
Pin: origin packages.mozilla.org
Pin-Priority: 1000
' | sudo tee /etc/apt/preferences.d/mozilla
echo "Actualizamos para que el sistema «tome» los nuevos repositorios"
sudo apt update
echo "Instalando Firefox"
sudo apt install firefox

# Desinstalar Programas 
echo "Desintalando Gnome Games"
sudo apt purge -y \
    gnome-games \
    libgnome-games-support-1-3 \
    libgnome-games-support-common \
    cheese \
    zutty

# Limpiar el sistema
echo "Limpiando el sistema..."
sudo apt autoremove -y
sudo apt clean

# Configuración de finalización
echo "Instalación y configuración completada."

#Reiniciar el sistema (opcional)
read -p "¿Deseas reiniciar el sistema ahora? (s/n): " reboot_response
if [[ "$reboot_response" == "s" || "$reboot_response" == "S" ]]; then
    sudo reboot
fi
