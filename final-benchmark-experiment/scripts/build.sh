#!/usr/bin/env bash
set -euo pipefail

MAPS8_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
source "${MAPS8_ROOT}/scripts/env.sh"

echo "=== Maps8 workspace build ==="
echo "Workspace: ${MAPS8_WS}"
echo "Maps1 (~/slam_ws) etkilenmez."
echo

cd "${MAPS8_WS}"
colcon build --symlink-install \
  --packages-select sjtu_drone_description sjtu_drone_bringup sjtu_drone_control drone_autonomy \
  --cmake-args -DCMAKE_BUILD_TYPE=Release

echo
echo "Build tamamlandi. Maps8 hazir."
