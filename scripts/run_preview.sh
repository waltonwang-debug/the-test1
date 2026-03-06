#!/usr/bin/env bash
set -euo pipefail

PORT="${1:-4173}"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "Starting preview server..."
echo "URL: http://127.0.0.1:${PORT}/preview.html"
echo "Press Ctrl+C to stop."

cd "$ROOT_DIR"
python3 -m http.server "$PORT" --directory "$ROOT_DIR"
