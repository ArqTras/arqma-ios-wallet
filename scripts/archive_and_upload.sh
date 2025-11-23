#!/bin/bash

# Skrypt do archiwizacji i wysłania aplikacji Arqma Wallet do TestFlight
# Wymagania:
# - macOS z zainstalowanym Xcode
# - Zalogowany w Xcode z kontem Apple Developer
# - Zainstalowane zależności CocoaPods (pod install)
# - Skonfigurowane certyfikaty i provisioning profiles

set -e  # Zatrzymaj przy pierwszym błędzie

echo "=========================================="
echo "Arqma Wallet - Archive & Upload to TestFlight"
echo "=========================================="

# Ścieżki
PROJECT_DIR=$(pwd)
SCHEME="CakeWallet"
WORKSPACE="CakeWallet.xcworkspace"
CONFIGURATION="Release"
ARCHIVE_PATH="$PROJECT_DIR/build/ArqmaWallet.xcarchive"
EXPORT_PATH="$PROJECT_DIR/build/export"
EXPORT_OPTIONS_PLIST="$PROJECT_DIR/ExportOptions.plist"

# Sprawdź, czy workspace istnieje
if [ ! -d "$WORKSPACE" ]; then
    echo "❌ Błąd: Nie znaleziono workspace $WORKSPACE"
    echo "   Uruchom najpierw: pod install"
    exit 1
fi

# Sprawdź, czy Xcode jest zainstalowany
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Błąd: xcodebuild nie jest dostępny"
    echo "   Zainstaluj Xcode z App Store"
    exit 1
fi

# Utwórz katalogi
mkdir -p "$PROJECT_DIR/build"
mkdir -p "$EXPORT_PATH"

echo ""
echo "📦 Krok 1: Czyszczenie poprzednich buildów..."
xcodebuild clean \
    -workspace "$WORKSPACE" \
    -scheme "$SCHEME" \
    -configuration "$CONFIGURATION" \
    -quiet

echo ""
echo "🔨 Krok 2: Budowanie i archiwizacja..."
xcodebuild archive \
    -workspace "$WORKSPACE" \
    -scheme "$SCHEME" \
    -configuration "$CONFIGURATION" \
    -archivePath "$ARCHIVE_PATH" \
    -allowProvisioningUpdates \
    CODE_SIGN_IDENTITY="iPhone Distribution" \
    CODE_SIGN_STYLE="Automatic" \
    DEVELOPMENT_TEAM="SUQ8J2PCT7" \
    PROVISIONING_PROFILE_SPECIFIER="" \
    | xcpretty

if [ ! -d "$ARCHIVE_PATH" ]; then
    echo "❌ Błąd: Archiwizacja nie powiodła się"
    exit 1
fi

echo ""
echo "✅ Archiwizacja zakończona pomyślnie!"
echo "   Lokalizacja: $ARCHIVE_PATH"

# Sprawdź, czy plik ExportOptions.plist istnieje
if [ ! -f "$EXPORT_OPTIONS_PLIST" ]; then
    echo ""
    echo "⚠️  Nie znaleziono ExportOptions.plist, tworzę domyślny..."
    cat > "$EXPORT_OPTIONS_PLIST" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>app-store</string>
    <key>teamID</key>
    <string>SUQ8J2PCT7</string>
    <key>uploadBitcode</key>
    <false/>
    <key>uploadSymbols</key>
    <true/>
    <key>compileBitcode</key>
    <false/>
    <key>destination</key>
    <string>upload</string>
    <key>signingStyle</key>
    <string>automatic</string>
    <key>stripSwiftSymbols</key>
    <true/>
</dict>
</plist>
EOF
    echo "   Utworzono: $EXPORT_OPTIONS_PLIST"
    echo "   ⚠️  Sprawdź i zaktualizuj teamID jeśli potrzeba!"
fi

echo ""
echo "📤 Krok 3: Eksportowanie IPA..."
xcodebuild -exportArchive \
    -archivePath "$ARCHIVE_PATH" \
    -exportPath "$EXPORT_PATH" \
    -exportOptionsPlist "$EXPORT_OPTIONS_PLIST" \
    -allowProvisioningUpdates \
    | xcpretty

IPA_PATH="$EXPORT_PATH/ArqmaWallet.ipa"

if [ ! -f "$IPA_PATH" ]; then
    echo "❌ Błąd: Eksport IPA nie powiódł się"
    exit 1
fi

echo ""
echo "✅ IPA wyeksportowane pomyślnie!"
echo "   Lokalizacja: $IPA_PATH"

echo ""
echo "📱 Krok 4: Wysyłanie do TestFlight..."
echo ""
echo "Opcja A: Użyj Xcode Organizer (zalecane):"
echo "   1. Otwórz Xcode"
echo "   2. Window → Organizer"
echo "   3. Wybierz archiwum ArqmaWallet"
echo "   4. Kliknij 'Distribute App'"
echo "   5. Wybierz 'App Store Connect' → 'TestFlight & App Store'"
echo "   6. Postępuj zgodnie z instrukcjami"
echo ""
echo "Opcja B: Użyj altool (wymaga App-Specific Password):"
echo "   xcrun altool --upload-app --type ios --file \"$IPA_PATH\" \\"
echo "     --username \"TWÓJ_APPLE_ID\" --password \"APP_SPECIFIC_PASSWORD\""
echo ""
echo "Opcja C: Użyj Transporter (zalecane dla CI/CD):"
echo "   1. Pobierz Transporter z App Store"
echo "   2. Otwórz Transporter"
echo "   3. Przeciągnij plik: $IPA_PATH"
echo "   4. Kliknij 'Deliver'"
echo ""

echo "=========================================="
echo "✅ Proces zakończony!"
echo "=========================================="
echo ""
echo "Następne kroki:"
echo "1. Przejdź do App Store Connect (https://appstoreconnect.apple.com)"
echo "2. Sprawdź status przesyłki w TestFlight"
echo "3. Po przetworzeniu, dodaj testerów i wyślij zaproszenia"
echo ""

