#!/bin/bash

cd $HOME

# Desinstalar
echo '    >>>    Removendo a instalação anterior'
rm -rf .android .android-studio .flutter .pub-cache .java .cache/Google/ .config/flutter/ .config/Google/ Android .emulator_console_auth_token
echo ''

# Instalar Flutter
echo '    >>>    Instalando o Flutter'
git clone https://github.com/flutter/flutter.git .flutter
echo ''

# Instalar Android Studio
echo '    >>>    Instalando o Android Studio'
linkAndroidStudio=$(curl -s https://developer.android.com/studio | grep https://redirector.gvt1.com/edgedl/android/studio/ide-zips/ | grep linux | head -n 1 | cut -d'"' -f2)
curl -L "${linkAndroidStudio}" | tar -xz
mv android-studio .android-studio
#source ~/.bashrc
echo ''

# Configurar o Android Studio
echo '    >>>    Configurando o Android Studio'
$HOME/.android-studio/bin/studio.sh
echo ''

# Instalar Comand Line Tools
echo '    >>>    Instalando o Comand Line Tools'
linkCommandLineTools=$(curl -s https://developer.android.com/studio | grep https://dl.google.com/android/repository/ | grep linux | head -n 1 | cut -d'"' -f2)
mkdir -p $HOME/Android/Sdk/cmdline-tools/
cd $HOME/Android/Sdk/cmdline-tools/
curl -L "${linkCommandLineTools}" >> latest.zip
unzip latest.zip
mv cmdline-tools latest
rm latest.zip
cd $HOME
echo ''

#Aceitar Licensas
echo '    >>>    Aceitando Licensas Android'
yes y | $HOME/.flutter/bin/flutter doctor --android-licenses
echo ''


#Instalar AVDImage
echo '    >>>    Instalando o Emulador de Android'
$HOME/Android/Sdk/cmdline-tools/latest/bin/sdkmanager --install "system-images;android-29;default;x86"
echo "no" | $HOME/Android/Sdk/cmdline-tools/latest/bin/avdmanager create avd -n Android --device "pixel_xl" -k "system-images;android-29;default;x86"
#emulator @Android
echo ''

#Exportar caminhos
echo '    >>>    Finalizando a Instalação'
case ":$PATH:" in
  *:$HOME/.flutter/bin:*) echo "Já está no caminho";;
  *) echo 'export PATH="$PATH:${HOME}/.flutter/bin"' >> .bashrc
     echo 'export PATH="$PATH:${HOME}/.android-studio/bin"' >> .bashrc
     echo 'export ANDROID_SDK=$HOME/Android/Sdk/' >> .bashrc
     echo 'export PATH=$ANDROID_SDK/emulator:$ANDROID_SDK/tools:$ANDROID_SDK/cmdline-tools/latest/bin/:$PATH' >> .bashrc ;;
esac


#Flutter Doctor
$HOME/.flutter/bin/flutter upgrade
$HOME/.flutter/bin/flutter doctor
echo '    >>>    Instalação Finalizada  <<  '
echo ''


