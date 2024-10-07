#!/bin/bash

cd ~

termux-setup-storage

pkg install wget unzip openjdk-17 which proot-distro -y

wget https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -O commandlinetools.zip
unzip commandlinetools.zip -d $HOME/android-sdk

mkdir -p $HOME/android-sdk/cmdline-tools/latest
mv $HOME/android-sdk/cmdline-tools/bin $HOME/android-sdk/cmdline-tools/latest/
mv $HOME/android-sdk/cmdline-tools/lib $HOME/android-sdk/cmdline-tools/latest/

echo 'export JAVA_HOME=/data/data/com.termux/files/usr/lib/jvm/java-17-openjdk' >> ~/.profile
echo 'export PATH=$PATH:$JAVA_HOME/bin' >> ~/.profile
echo 'export ANDROID_HOME=$HOME/android-sdk' >> ~/.profile
echo 'export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin' >> ~/.profile

source ~/.profile

chmod +x $HOME/android-sdk/cmdline-tools/latest/bin/sdkmanager
https://github.com/godotengine/godot-builds/releases/download/4.3-stable/Godot_v4.3-stable_linux.arm64.zip
sdkmanager --update
sdkmanager "platforms;android-33" "platform-tools" "build-tools;34.0.0"

rm ~/commandlinetools.zip

chmod +x ~/android-sdk/platform-tools/adb

cd ~/android-sdk
keytool -genkey -v -keystore debug.keystore -keyalg RSA -keysize 2048 -validity 10000 -alias androiddebugkey -dname "CN=Android Debug,O=Android,C=US" -storepass android -keypass android

cd ~

proot-distro install ubuntu

proot-distro login ubuntu <<-EOF
  apt update
  apt upgrade -y

  apt install wget unzip libfontconfig1 libx11-6 libxcursor1 libxinerama1 libxrandr2 libxrender1 git -y
  
  mkdir -p ~/godot
  cd ~/godot
  
  wget https://github.com/godotengine/godot-builds/releases/download/4.3-stable/Godot_v4.3-stable_linux.arm64.zip

  unzip Godot_v4.3-stable_linux.arm64.zip
  chmod +x Godot_v4.3-stable_linux.arm64.zip
  rm -rf Godot_v4.3-stable_linux.arm64.zip
  
  ./Godot_v4.3-stable_linux.arm64 --export-release "Android" ./name.apk --headless

  git clone https://github.com/ilyaijn85/build-game.git
  
  cd build-game
  chmod +x build-game.sh

  mv editor_settings-4.tres ~/.config/godot
  exit
EOF

cd ~
clear

echo "Run Successful." 
echo "Now you can Build Your Game." 
echo "You don't need to run this again."

echo " "
echo "run proot-distro login ubuntu to use ubunu environment."
echo "then once you login run ~/build-game/build-game.sh"
echo "Then provide your project path and game name."

echo ""
echo "Recommend to restart the Termux then continue"
echo " "

