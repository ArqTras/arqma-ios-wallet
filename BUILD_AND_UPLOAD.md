# Instrukcja kompilacji i wysłania Arqma Wallet do TestFlight

## ⚠️ Wymagania

1. **macOS** - Kompilacja iOS wymaga macOS z Xcode
2. **Xcode** - Najnowsza wersja z App Store
3. **Apple Developer Account** - Aktywne członkostwo ($99/rok)
4. **Certyfikaty i Provisioning Profiles** - Skonfigurowane w Xcode

## 📋 Krok po kroku

### 1. Przygotowanie środowiska

```bash
# Zainstaluj CocoaPods (jeśli nie masz)
sudo gem install cocoapods

# Zainstaluj xcpretty dla czytelniejszych logów (opcjonalnie)
sudo gem install xcpretty
```

### 2. Instalacja zależności

```bash
# Przejdź do katalogu projektu
cd arqma-ios-wallet

# Zainstaluj zależności CocoaPods
pod install
```

### 3. Konfiguracja w Xcode

1. Otwórz projekt w Xcode:
   ```bash
   open CakeWallet.xcworkspace
   ```
   ⚠️ **WAŻNE**: Otwórz `.xcworkspace`, nie `.xcodeproj`!

2. W Xcode:
   - Wybierz target **CakeWallet**
   - Przejdź do **Signing & Capabilities**
   - Upewnij się, że:
     - **Team** jest poprawnie ustawiony (SUQ8J2PCT7 lub Twój Team ID)
     - **Bundle Identifier** to `com.arqma.arqma-wallet`
     - **Automatically manage signing** jest włączone (lub masz ręcznie skonfigurowane provisioning profiles)

### 4. Budowanie bibliotek natywnych (jeśli potrzeba)

Jeśli biblioteki natywne nie są zbudowane:

```bash
# Zainstaluj zależności systemowe (Homebrew)
brew install pkgconfig cmake zeromq

# Zbuduj biblioteki
./build.sh
```

⚠️ To może zająć 30-60 minut!

### 5. Archiwizacja i wysłanie do TestFlight

#### Opcja A: Użyj przygotowanego skryptu (zalecane)

```bash
# Nadaj uprawnienia wykonywania
chmod +x scripts/build_for_testflight.sh
chmod +x scripts/archive_and_upload.sh

# Uruchom pełny proces
./scripts/build_for_testflight.sh
```

#### Opcja B: Ręcznie przez Xcode

1. W Xcode wybierz **Product → Archive**
2. Poczekaj na zakończenie archiwizacji
3. W oknie Organizer kliknij **Distribute App**
4. Wybierz **App Store Connect**
5. Wybierz **TestFlight & App Store**
6. Postępuj zgodnie z instrukcjami

#### Opcja C: Przez wiersz poleceń

```bash
# Archiwizacja
xcodebuild archive \
    -workspace CakeWallet.xcworkspace \
    -scheme CakeWallet \
    -configuration Release \
    -archivePath build/ArqmaWallet.xcarchive \
    -allowProvisioningUpdates

# Eksport IPA
xcodebuild -exportArchive \
    -archivePath build/ArqmaWallet.xcarchive \
    -exportPath build/export \
    -exportOptionsPlist ExportOptions.plist \
    -allowProvisioningUpdates

# Wysyłanie do TestFlight (wymaga App-Specific Password)
xcrun altool --upload-app \
    --type ios \
    --file build/export/ArqmaWallet.ipa \
    --username "TWÓJ_APPLE_ID" \
    --password "APP_SPECIFIC_PASSWORD"
```

### 6. Konfiguracja w App Store Connect

1. Zaloguj się do [App Store Connect](https://appstoreconnect.apple.com/)
2. Przejdź do **My Apps**
3. Utwórz nową aplikację (jeśli jeszcze nie istnieje):
   - **Bundle ID**: `com.arqma.arqma-wallet`
   - **Name**: Arqma Wallet
   - **Primary Language**: English (lub inny)
4. Przejdź do **TestFlight**
5. Poczekaj na przetworzenie builda (może zająć 10-30 minut)
6. Po przetworzeniu:
   - Dodaj testerów wewnętrznych (Internal Testing)
   - Lub dodaj testerów zewnętrznych (External Testing) - wymaga przeglądu Apple

## 🔧 Rozwiązywanie problemów

### Błąd: "No signing certificate found"

**Rozwiązanie:**
1. Otwórz Xcode → Preferences → Accounts
2. Dodaj swoje konto Apple Developer
3. Kliknij "Download Manual Profiles"
4. W projekcie włącz "Automatically manage signing"

### Błąd: "Provisioning profile doesn't match"

**Rozwiązanie:**
1. W Xcode: Signing & Capabilities
2. Wyczyść i ponownie wybierz Team
3. Upewnij się, że Bundle Identifier jest poprawny

### Błąd: "Missing required icon file"

**Rozwiązanie:**
1. Sprawdź, czy wszystkie wymagane rozmiary ikon są w `Assets.xcassets/AppIcon.appiconset`
2. Upewnij się, że ikony są w formacie PNG

### Błąd: "Invalid Bundle"

**Rozwiązanie:**
1. Sprawdź Bundle Identifier w Info.plist
2. Upewnij się, że wszystkie Bundle Identifiers są unikalne
3. Sprawdź, czy nie ma konfliktów z innymi aplikacjami

### Build kończy się błędem kompilacji

**Rozwiązanie:**
1. Wyczyść build folder: `Product → Clean Build Folder` (Shift+Cmd+K)
2. Usuń Derived Data: `Xcode → Preferences → Locations → Derived Data → Delete`
3. Uruchom ponownie: `pod install`
4. Spróbuj zbudować ponownie

## 📝 Sprawdzenie przed wysłaniem

- [ ] Bundle Identifier: `com.arqma.arqma-wallet`
- [ ] Display Name: `Arqma Wallet`
- [ ] Version i Build Number są poprawne
- [ ] Wszystkie ikony są dodane
- [ ] Certyfikaty są aktualne
- [ ] Provisioning Profiles są aktualne
- [ ] Aplikacja kompiluje się bez błędów
- [ ] Aplikacja działa na urządzeniu testowym

## 🚀 Po wysłaniu do TestFlight

1. **Poczekaj na przetworzenie** (10-30 minut)
2. **Sprawdź status** w App Store Connect → TestFlight
3. **Dodaj testerów**:
   - Internal Testing: Do 100 testerów (natychmiast)
   - External Testing: Nieograniczona liczba (wymaga przeglądu Apple)
4. **Wyślij zaproszenia** do testerów
5. **Monitoruj feedback** od testerów

## 📞 Wsparcie

Jeśli napotkasz problemy:
1. Sprawdź logi w Xcode Organizer
2. Sprawdź status w App Store Connect
3. Zobacz dokumentację Apple: https://developer.apple.com/testflight/

