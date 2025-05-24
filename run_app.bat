@echo off
echo ========================================
echo     App Biblio - Lanceur d'application
echo ========================================
echo.

echo Verification de Flutter...
flutter doctor --version
if %errorlevel% neq 0 (
    echo ERREUR: Flutter n'est pas installe ou n'est pas dans le PATH
    echo Veuillez installer Flutter: https://docs.flutter.dev/get-started/install
    pause
    exit /b 1
)

echo.
echo Installation des dependances...
flutter pub get
if %errorlevel% neq 0 (
    echo ERREUR: Echec de l'installation des dependances
    pause
    exit /b 1
)

echo.
echo Appareils disponibles:
flutter devices

echo.
echo Choisissez une plateforme:
echo 1. Windows (Desktop)
echo 2. Chrome (Web)
echo 3. Android (si connecte)
echo 4. Detecter automatiquement
echo.
set /p choice="Votre choix (1-4): "

if "%choice%"=="1" (
    echo Lancement sur Windows...
    flutter run -d windows
) else if "%choice%"=="2" (
    echo Lancement sur Chrome...
    flutter run -d chrome
) else if "%choice%"=="3" (
    echo Lancement sur Android...
    flutter run -d android
) else (
    echo Lancement automatique...
    flutter run
)

echo.
echo Application fermee.
pause
