#!/usr/bin/env bash
set -euo pipefail

# Pin matches the locally verified Flutter/Dart pair (3.47.2 / 3.13.2).
FLUTTER_VERSION="${FLUTTER_VERSION:-3.47.2}"
FLUTTER_ROOT="${FLUTTER_ROOT:-$HOME/flutter}"

if ! command -v flutter >/dev/null 2>&1; then
  if [[ ! -x "$FLUTTER_ROOT/bin/flutter" ]]; then
    git clone --depth 1 --branch "$FLUTTER_VERSION" https://github.com/flutter/flutter.git "$FLUTTER_ROOT"
  fi
  export PATH="$FLUTTER_ROOT/bin:$PATH"
fi

export PUB_CACHE="${PUB_CACHE:-$HOME/.pub-cache}"

flutter config --enable-web --no-analytics
flutter pub get
flutter gen-l10n
flutter build web --release --no-web-resources-cdn \
  --dart-define=SUPABASE_URL="${SUPABASE_URL:-}" \
  --dart-define=SUPABASE_ANON_KEY="${SUPABASE_ANON_KEY:-}"

test -f build/web/index.html
test -d build/web/assets
test -f build/web/assets/assets/brand/prana_logo.jpeg
test -f build/web/assets/assets/models/physio_context.json
test -f build/web/assets/assets/models/fall_window.json
test -f build/web/assets/assets/geo/kathmandu_demo.geojson
test -f build/web/assets/assets/demo/normal.csv
