#!/bin/bash

# Kompleksowy skrypt do przygotowania aplikacji Arqma Wallet do TestFlight
# Wykonuje wszystkie wymagane kroki: instalacja zależności, budowanie, archiwizacja

set -e

echo "=========================================="
echo "Arqma Wallet - Build for TestFlight"
echo "=========================================="

PROJECT_DIR=$(pwd)

# Krok 1: Sprawdź zależności
echo ""
echo "🔍 Krok 1: Sprawdzanie zależności..."

if ! command -v pod &> /dev/null; then
    echo "❌ CocoaPods nie jest zainstalowany"
    echo "   Zainstaluj: sudo gem install cocoapods"
    exit 1
fi

if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Xcode nie jest zainstalowany"
    echo "   Zainstaluj Xcode z App Store"
    exit 1
fi

echo "✅ Wszystkie zależności są dostępne"

# Krok 2: Instalacja CocoaPods (jeśli potrzeba)
echo ""
echo "📦 Krok 2: Instalacja zależności CocoaPods..."

if [ ! -d "Pods" ] || [ ! -f "CakeWallet.xcworkspace" ]; then
    echo "   Instalowanie podów..."
    pod install
else
    echo "   Pods już zainstalowane, aktualizowanie..."
    pod update
fi

echo "✅ Zależności CocoaPods gotowe"

# Krok 3: Sprawdź biblioteki natywne (jeśli potrzeba)
echo ""
echo "🔨 Krok 3: Sprawdzanie bibliotek natywnych..."

if [ ! -d "Libraries/loki/lib-ios" ]; then
    echo "⚠️  Biblioteki natywne nie są zbudowane"
    echo "   Jeśli potrzebujesz, uruchom: ./build.sh"
    echo "   (To może zająć dużo czasu)"
    read -p "   Kontynuować bez budowania bibliotek? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "   Budowanie bibliotek..."
        ./build.sh
    fi
else
    echo "✅ Biblioteki natywne są dostępne"
fi

# Krok 4: Weryfikacja konfiguracji
echo ""
echo "🔍 Krok 4: Weryfikacja konfiguracji projektu..."

BUNDLE_ID=$(xcodebuild -showBuildSettings -workspace CakeWallet.xcworkspace -scheme CakeWallet -configuration Release 2>/dev/null | grep "PRODUCT_BUNDLE_IDENTIFIER" | head -1 | awk '{print $3}')

if [ -z "$BUNDLE_ID" ]; then
    echo "⚠️  Nie można odczytać Bundle Identifier"
else
    echo "   Bundle Identifier: $BUNDLE_ID"
    if [[ "$BUNDLE_ID" == *"arqma"* ]]; then
        echo "✅ Bundle Identifier jest poprawny dla Arqma"
    else
        echo "⚠️  Bundle Identifier może wymagać aktualizacji"
    fi
fi

# Krok 5: Archiwizacja
echo ""
echo "📦 Krok 5: Archiwizacja aplikacji..."
echo ""

# Uruchom skrypt archiwizacji
if [ -f "scripts/archive_and_upload.sh" ]; then
    chmod +x scripts/archive_and_upload.sh
    ./scripts/archive_and_upload.sh
else
    echo "❌ Nie znaleziono skryptu archive_and_upload.sh"
    exit 1
fi

echo ""
echo "=========================================="
echo "✅ Wszystkie kroki zakończone!"
echo "=========================================="

