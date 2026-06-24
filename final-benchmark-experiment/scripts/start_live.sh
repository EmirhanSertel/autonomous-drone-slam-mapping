#!/usr/bin/env bash
# Maps12 live test: Gazebo + RTAB-Map + general autonomous explorer. No snapshot/export.
set -euo pipefail

MAPS10_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
WORLD="${1:-${MAPS10_ROOT}/worlds/general_slam_benchmark.world}"
SESSION="${MAPS10_SESSION:-maps12_live}"
LOG_DIR="${MAPS10_ROOT}/logs/live_$(date +%Y%m%d_%H%M%S)"

mkdir -p "${LOG_DIR}"
tmux kill-session -t "${SESSION}" 2>/dev/null || true

eval "$("${MAPS10_ROOT}/scripts/world_profile.py" "${WORLD}")"

ENV_EXPORTS="export MAPS10_SPAWN_X='${MAPS10_SPAWN_X:-0}'; export MAPS10_SPAWN_Y='${MAPS10_SPAWN_Y:-0}'; export MAPS10_SPAWN_YAW='${MAPS10_SPAWN_YAW:-0}'; export MAPS10_BOUNDS='${MAPS10_BOUNDS:-}'; export MAPS10_HAS_BOUNDS='${MAPS10_HAS_BOUNDS:-0}'"

tmux new-session -d -s "${SESSION}" -n gazebo bash
tmux send-keys -t "${SESSION}:gazebo" "${ENV_EXPORTS}; source '${MAPS10_ROOT}/scripts/env.sh'; ros2 launch sjtu_drone_bringup sjtu_drone_bringup.launch.py world:='${WORLD}' 2>&1 | tee '${LOG_DIR}/bringup.log'" C-m

sleep 10

tmux new-window -t "${SESSION}" -n rtabmap bash
tmux send-keys -t "${SESSION}:rtabmap" "${ENV_EXPORTS}; source '${MAPS10_ROOT}/scripts/env.sh'; ros2 launch sjtu_drone_bringup rtabmap_lidar_depth.launch.py rtabmapviz:=true 2>&1 | tee '${LOG_DIR}/rtabmap.log'" C-m

sleep 8

tmux new-window -t "${SESSION}" -n explorer bash
tmux send-keys -t "${SESSION}:explorer" "${ENV_EXPORTS}; source '${MAPS10_ROOT}/scripts/env.sh'; python3 '${MAPS10_ROOT}/scripts/autonomous_explorer.py' --altitude 1.45 --duration 540 2>&1 | tee '${LOG_DIR}/explorer.log'" C-m

echo "Maps12 live started."
echo "World: ${WORLD}"
echo "Spawn: ${MAPS10_SPAWN_X:-0}, ${MAPS10_SPAWN_Y:-0}"
echo "Bounds: ${MAPS10_BOUNDS:-none}"
echo "Logs: ${LOG_DIR}"
echo "Watch: tmux attach -t ${SESSION}"
