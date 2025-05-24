#!/bin/bash

echo "========================================"
echo "    App Biblio - Lanceur d'application"
echo "========================================"
echo

echo "Vérification de Flutter..."
if ! command -v flutter &> /dev/null; then
    echo "ERREUR: Flutter n'est pas installé ou n'est pas dans le PATH"
    echo "Veuillez installer Flutter: https://docs.flutter.dev/get-started/install"
    exit 1
fi

flutter doctor --version

echo
echo "Installation des dépendances..."
flutter pub get
if [ $? -ne 0 ]; then
    echo "ERREUR: Échec de l'installation des dépendances"
    exit 1
fi

echo
echo "Appareils disponibles:"
flutter devices

echo
echo "Choisissez une plateforme:"
echo "1. macOS (Desktop) - macOS uniquement"
echo "2. Linux (Desktop) - Linux uniquement"
echo "3. Chrome (Web)"
echo "4. Android (si connecté)"
echo "5. iOS (si connecté et sur macOS)"
echo "6. Détecter automatiquement"
echo

read -p "Votre choix (1-6): " choice

case $choice in
    1)
        echo "Lancement sur macOS..."
        flutter run -d macos
        ;;
    2)
        echo "Lancement sur Linux..."
        flutter run -d linux
        ;;
    3)
        echo "Lancement sur Chrome..."
        flutter run -d chrome
        ;;
    4)
        echo "Lancement sur Android..."
        flutter run -d android
        ;;
    5)
        echo "Lancement sur iOS..."
        flutter run -d ios
        ;;
    *)
        echo "Lancement automatique..."
        flutter run
        ;;
esac

echo
echo "Application fermée."
