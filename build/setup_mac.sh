#!/bin/sh

SECRETS="$HOME/secrets"
KEYCHAIN="build.keychain"
KEYCHAIN_PASSWORD=`openssl rand -base64 32`

# Decrypt the file
echo "Decrypting Developer ID Certificate"
mkdir $SECRETS
openssl enc -aes-256-cbc -d -in certificate.p12.enc -out $SECRETS/certificate.p12 -k "$CERTIFICATE_DECRYPTION_PASSWORD"

# Create keychain
echo "Creating Keychain"
security create-keychain -p $KEYCHAIN_PASSWORD $KEYCHAIN
security list-keychains -s $KEYCHAIN
security default-keychain -s $KEYCHAIN
security unlock-keychain -p $KEYCHAIN_PASSWORD $KEYCHAIN
security set-key-partition-list -S apple-tool:,apple:,codesign: -s -k actions $KEYCHAIN
security set-keychain-settings $KEYCHAIN # Disable auto lock

# Add certificate to keychain
echo "Adding certificate to keychain"
security import $SECRETS/certificate.p12 -k $KEYCHAIN -P $CERTIFICATE_PASSWORD -A
echo "Completed"
