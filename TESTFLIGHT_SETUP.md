# Konfiguracja TestFlight dla Arqma iOS Wallet

## Wprowadzone zmiany

### 1. Bundle Identifiers
Wszystkie Bundle Identifiers zostały zaktualizowane z Loki na Arqma:

- **Główna aplikacja**: `com.arqma.arqma-wallet` (poprzednio: `com.loki-project.loki-wallet`)
- **CakeWalletCore**: `com.arqma.arqma-wallet.CakeWalletCore`
- **CWMonero**: `network.arqma.wallet.CWMonero`
- **CakeWalletLib**: `com.arqma.arqma-wallet.CakeWalletLib`

### 2. Nazwy produktów
- **Product Name**: `ArqmaWallet` (poprzednio: `LokiWallet`)
- **Display Name**: `Arqma Wallet` (poprzednio: `Loki Wallet`)
- **Archive Name**: `ArqmaWallet`

### 3. Pliki zaktualizowane
- `CakeWallet.xcodeproj/project.pbxproj` - wszystkie Bundle Identifiers i Product Names
- `CakeWallet/Info.plist` - Display Name
- `CakeWallet.xcodeproj/xcshareddata/xcschemes/CakeWallet.xcscheme` - BuildableName i Archive Name

## Wymagane kroki przed publikacją w TestFlight

### 1. Development Team ID
Obecny Development Team ID: `SUQ8J2PCT7`

**WAŻNE**: Jeśli dane autoryzacyjne z repozytorium https://github.com/ArqTras/mdr/tree/main/ios-app zawierają inny Development Team ID, należy go zaktualizować w:
- Xcode → Project Settings → Signing & Capabilities → Team

### 2. Provisioning Profiles
Upewnij się, że masz prawidłowe Provisioning Profiles dla:
- `com.arqma.arqma-wallet` (App Store Distribution)
- `com.arqma.arqma-wallet.CakeWalletCore`
- `network.arqma.wallet.CWMonero`
- `com.arqma.arqma-wallet.CakeWalletLib`

### 3. Certyfikaty
Upewnij się, że masz:
- Certyfikat dystrybucyjny (Distribution Certificate) dla App Store
- Certyfikat powinien być powiązany z Twoim kontem Apple Developer

### 4. App Store Connect
1. Zaloguj się do [App Store Connect](https://appstoreconnect.apple.com/)
2. Utwórz nową aplikację (jeśli jeszcze nie istnieje) z Bundle ID: `com.arqma.arqma-wallet`
3. Wypełnij wymagane informacje o aplikacji

### 5. Archiwizacja i dystrybucja
1. W Xcode wybierz **Product → Archive**
2. Po zakończeniu archiwizacji kliknij **Distribute App**
3. Wybierz **App Store Connect**
4. Wybierz **TestFlight & App Store**
5. Postępuj zgodnie z instrukcjami, aby przesłać aplikację

### 6. TestFlight Configuration
Po przesłaniu aplikacji:
1. Przejdź do App Store Connect → TestFlight
2. Dodaj testerów wewnętrznych lub zewnętrznych
3. Wyślij zaproszenia do testerów

## Uwagi
- Upewnij się, że wszystkie certyfikaty i provisioning profiles są aktualne
- Sprawdź, czy wszystkie wymagane uprawnienia (capabilities) są poprawnie skonfigurowane
- Przetestuj aplikację przed wysłaniem do TestFlight

## Sprawdzenie konfiguracji
Aby sprawdzić, czy wszystko jest poprawnie skonfigurowane:
1. Otwórz projekt w Xcode
2. Wybierz target `CakeWallet`
3. Przejdź do **Signing & Capabilities**
4. Sprawdź, czy:
   - Team jest poprawnie ustawiony
   - Bundle Identifier to `com.arqma.arqma-wallet`
   - Provisioning Profile jest poprawnie przypisany (lub automatycznie zarządzany)

