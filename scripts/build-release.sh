#!/usr/bin/env bash
# Build a distributable Ice.app zip for this Chinese fork.
#
# Default: ad-hoc (sign-to-run-locally) signing so the .app is runnable for
# personal use. Gatekeeper may still require:
#   right-click → Open
#   or: xattr -cr /Applications/Ice.app
#
# Optional Developer ID signing (no workflow redesign needed later):
#   MACOS_CERTIFICATE_P12          base64-encoded .p12
#   MACOS_CERTIFICATE_PASSWORD     p12 password
#   MACOS_CERTIFICATE_IDENTITY     codesign identity name
#   APPLE_TEAM_ID                  10-character team id
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

DERIVED="${ROOT}/build/DerivedData"
DIST="${ROOT}/dist"
APP_NAME="Ice.app"
KEYCHAIN_PATH="${RUNNER_TEMP:-/tmp}/ice-signing.keychain-db"
KEYCHAIN_PASSWORD="ice-ci-signing"

mkdir -p "$DIST"

cleanup() {
  if [[ -n "${MACOS_CERTIFICATE_P12:-}" && -f "$KEYCHAIN_PATH" ]]; then
    security delete-keychain "$KEYCHAIN_PATH" >/dev/null 2>&1 || true
  fi
}
trap cleanup EXIT

SIGNING_MODE="adhoc"
if [[ -n "${MACOS_CERTIFICATE_P12:-}" && -n "${MACOS_CERTIFICATE_PASSWORD:-}" && -n "${MACOS_CERTIFICATE_IDENTITY:-}" ]]; then
  SIGNING_MODE="developer_id"
fi

echo "==> Signing mode: ${SIGNING_MODE}"

if [[ "$SIGNING_MODE" == "developer_id" ]]; then
  CERT_PATH="${RUNNER_TEMP:-/tmp}/certificate.p12"
  echo "${MACOS_CERTIFICATE_P12}" | base64 --decode > "$CERT_PATH"
  security create-keychain -p "$KEYCHAIN_PASSWORD" "$KEYCHAIN_PATH"
  security set-keychain-settings -lut 21600 "$KEYCHAIN_PATH"
  security unlock-keychain -p "$KEYCHAIN_PASSWORD" "$KEYCHAIN_PATH"
  security import "$CERT_PATH" -P "$MACOS_CERTIFICATE_PASSWORD" -A -t cert -f pkcs12 -k "$KEYCHAIN_PATH"
  security list-keychain -d user -s "$KEYCHAIN_PATH" ~/Library/Keychains/login.keychain-db
  security set-key-partition-list -S apple-tool:,apple: -s -k "$KEYCHAIN_PASSWORD" "$KEYCHAIN_PATH"
  rm -f "$CERT_PATH"

  TEAM_ARGS=()
  if [[ -n "${APPLE_TEAM_ID:-}" ]]; then
    TEAM_ARGS+=(DEVELOPMENT_TEAM="${APPLE_TEAM_ID}")
  fi

  xcodebuild \
    -project Ice.xcodeproj \
    -scheme Ice \
    -configuration Release \
    -derivedDataPath "$DERIVED" \
    -destination "generic/platform=macOS" \
    -allowProvisioningUpdates \
    CODE_SIGN_STYLE=Manual \
    CODE_SIGN_IDENTITY="${MACOS_CERTIFICATE_IDENTITY}" \
    "${TEAM_ARGS[@]}" \
    ENABLE_HARDENED_RUNTIME=YES \
    build
else
  echo "==> No Apple Developer cert secrets; using ad-hoc signing."
  xcodebuild \
    -project Ice.xcodeproj \
    -scheme Ice \
    -configuration Release \
    -derivedDataPath "$DERIVED" \
    -destination "generic/platform=macOS" \
    CODE_SIGN_STYLE=Manual \
    CODE_SIGN_IDENTITY=- \
    CODE_SIGNING_REQUIRED=YES \
    CODE_SIGNING_ALLOWED=YES \
    DEVELOPMENT_TEAM= \
    ENABLE_HARDENED_RUNTIME=NO \
    build
fi

APP_PATH="$(find "$DERIVED/Build/Products/Release" -maxdepth 1 -name "$APP_NAME" -print -quit)"
if [[ -z "$APP_PATH" || ! -d "$APP_PATH" ]]; then
  echo "error: ${APP_NAME} was not produced" >&2
  exit 1
fi

if [[ "$SIGNING_MODE" == "adhoc" ]]; then
  echo "==> Re-signing ${APP_NAME} ad-hoc"
  codesign --force --deep --sign - "$APP_PATH"
fi

echo "==> codesign verify"
codesign --verify --verbose=2 "$APP_PATH" || true
codesign -dv --verbose=4 "$APP_PATH" || true

echo "==> Creating Ice.zip"
ditto -c -k --keepParent "$APP_PATH" "${DIST}/Ice.zip"

echo "==> Done: ${DIST}/Ice.zip"
ls -lh "${DIST}/Ice.zip"
