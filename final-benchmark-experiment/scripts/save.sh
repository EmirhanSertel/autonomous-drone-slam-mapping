#!/usr/bin/env bash
# Maps12 SLAM ciktisini kaydeder. Maps1 outputs etkilenmez.
set -euo pipefail

MAPS12_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
source "${MAPS12_ROOT}/scripts/env.sh"

LABEL="${LABEL:-maps12_$(date +%Y-%m-%d_%H-%M-%S)}"
OUT_DIR="${MAPS12_ROOT}/outputs/${LABEL}"
mkdir -p "${OUT_DIR}"

echo "=== Maps12 cikti kaydediliyor ==="
echo "Hedef: ${OUT_DIR}"

python3 "${MAPS12_ROOT}/scripts/save_slam_snapshot.py" \
  --output-dir "${OUT_DIR}" \
  --label "${LABEL}"

echo "Kaydedildi: ${OUT_DIR}"
