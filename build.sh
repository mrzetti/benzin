#!/usr/bin/env bash
set -euo pipefail
ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
WORK=$(mktemp -d /tmp/opencode/benzin-build.XXXXXX)
trap 'rm -rf "$WORK"' EXIT
java -jar "$ROOT/tools/ffdec/ffdec.jar" -importScript \
  "$ROOT/assets/original.swf" \
  "$WORK/community.swf" \
  "$ROOT/scripts"
java -jar "$ROOT/tools/ffdec/ffdec.jar" -export text "$WORK/texts" "$WORK/community.swf"
python3 "$ROOT/scripts/translate-text.py" "$WORK/texts"
java -cp "$ROOT/tools/ffdec/ffdec.jar" "$ROOT/scripts/ImportEnglish.java" "$WORK/community.swf" "$ROOT/web/benzin-community-en-v2.swf" "$WORK"
