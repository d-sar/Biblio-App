# Guide de résolution des problèmes - App Biblio

## ✅ Correction de l'erreur "databaseFactory not initialized"

L'erreur `Bad state: databaseFactory not initialized` a été corrigée dans cette version. Voici ce qui a été fait :

### 🔧 Modifications apportées

1. **DatabaseService amélioré** : Le service détecte automatiquement la plateforme et initialise la bonne base de données
2. **Support multi-plateforme** : 
   - Windows/Linux/macOS : Utilise `sqflite_common_ffi`
   - Android/iOS : Utilise `sqflite` standard
   - Web : Affiche un message d'erreur informatif (SQLite non supporté)

### 🚀 Comment tester la correction

#### Test 1 : Lancement de l'application
```bash
cd "c:\Users\hp\OneDrive\Documents\app_biblio"
flutter run -d windows
```

#### Test 2 : Test des favoris
1. Lancez l'application
2. Recherchez un livre (ex: "flutter")
3. Cliquez sur l'icône cœur pour ajouter aux favoris
4. Cliquez sur le bouton flottant pour voir les favoris
5. Si aucune erreur n'apparaît, la correction fonctionne !

### 🐛 Problèmes courants et solutions

#### Problème : Erreur de compilation Windows
```
Error: Build process failed
```

**Solutions :**
1. **Nettoyer le projet** (peut nécessiter des permissions admin) :
   ```bash
   flutter clean
   flutter pub get
   ```

2. **Utiliser le web à la place** :
   ```bash
   flutter run -d chrome
   ```
   Note : Les favoris ne fonctionneront pas sur web (SQLite non supporté)

3. **Vérifier Visual Studio** :
   ```bash
   flutter doctor
   ```
   Assurez-vous que Visual Studio Build Tools est installé

#### Problème : Permissions Windows
```
Flutter failed to delete a directory at "build"
```

**Solutions :**
1. **Fermer tous les processus Flutter** :
   - Fermez VS Code, Android Studio
   - Tuez les processus `flutter.exe` dans le gestionnaire de tâches

2. **Lancer en tant qu'administrateur** :
   - Clic droit sur PowerShell → "Exécuter en tant qu'administrateur"

3. **Supprimer manuellement le dossier build** :
   ```bash
   rmdir /s build
   flutter pub get
   ```

#### Problème : Erreur de base de données persiste
Si vous voyez encore l'erreur `databaseFactory not initialized` :

1. **Vérifiez la plateforme** :
   ```bash
   flutter devices
   ```

2. **Réinstallez les dépendances** :
   ```bash
   flutter pub deps --style=compact
   flutter pub get
   ```

3. **Testez sur une autre plateforme** :
   ```bash
   # Android (si connecté)
   flutter run -d android
   
   # Web (favoris non fonctionnels mais app fonctionne)
   flutter run -d chrome
   ```

### 📱 Plateformes supportées

| Plateforme | Base de données | Status |
|------------|----------------|---------|
| Windows    | sqflite_common_ffi | ✅ Supporté |
| macOS      | sqflite_common_ffi | ✅ Supporté |
| Linux      | sqflite_common_ffi | ✅ Supporté |
| Android    | sqflite | ✅ Supporté |
| iOS        | sqflite | ✅ Supporté |
| Web        | Non supporté | ❌ Favoris désactivés |

### 🔍 Vérification du bon fonctionnement

L'application fonctionne correctement si :
- ✅ Elle se lance sans erreur
- ✅ Vous pouvez rechercher des livres
- ✅ Vous pouvez ajouter des favoris (icône cœur)
- ✅ Vous pouvez voir la liste des favoris
- ✅ Vous pouvez supprimer des favoris (glisser vers la gauche)

### 📞 Support

Si les problèmes persistent :
1. Vérifiez que Flutter est à jour : `flutter upgrade`
2. Vérifiez la configuration : `flutter doctor`
3. Essayez sur une autre plateforme
4. Consultez les logs détaillés : `flutter run -v`

### 🎯 Commandes rapides de dépannage

```bash
# Diagnostic complet
flutter doctor -v

# Nettoyage complet
flutter clean
flutter pub get

# Test sur différentes plateformes
flutter run -d windows    # Desktop Windows
flutter run -d chrome     # Web (favoris non fonctionnels)
flutter run -d android    # Mobile Android (si connecté)

# Voir les appareils disponibles
flutter devices
```
