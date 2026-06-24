#!/usr/bin/env bash
# Maps12 baslatma: 9 dakika tünel keşfi, otomatik snapshot ve RTAB-Map export.
set -euo pipefail

MAPS12_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
source "${MAPS12_ROOT}/scripts/env.sh"

SESSION="maps12_run"
WORLD="${MAPS12_ROOT}/worlds/general_slam_benchmark.world"
LOG_DIR="${MAPS12_ROOT}/logs"
DB_STORE="${MAPS12_ROOT}/outputs"
OUT_ROOT="${MAPS12_ROOT}/yenicikti"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
DURATION=540
RUN_DIR="${OUT_ROOT}/${TIMESTAMP}_maps12_general_benchmark_9dk"
LIVE_DIR="${RUN_DIR}/live_snapshot"
EXPORT_DIR="${RUN_DIR}/rtabmap_export"
DB_PATH="${DB_STORE}/rtabmap.db"

mkdir -p "${LOG_DIR}" "${DB_STORE}" "${LIVE_DIR}" "${EXPORT_DIR}"
rm -f "${DB_PATH}"
tmux kill-session -t "${SESSION}" 2>/dev/null || true

eval "$("${MAPS12_ROOT}/scripts/world_profile.py" "${WORLD}")"
ENV_EXPORTS="export MAPS10_SPAWN_X='${MAPS10_SPAWN_X:-0}'; export MAPS10_SPAWN_Y='${MAPS10_SPAWN_Y:-0}'; export MAPS10_SPAWN_YAW='${MAPS10_SPAWN_YAW:-0}'; export MAPS10_BOUNDS='${MAPS10_BOUNDS:-}'; export MAPS10_HAS_BOUNDS='${MAPS10_HAS_BOUNDS:-0}'"

tmux new-session -d -s "${SESSION}" -n gazebo bash
tmux send-keys -t "${SESSION}:gazebo" "${ENV_EXPORTS}; source '${MAPS12_ROOT}/scripts/env.sh'; ros2 launch sjtu_drone_bringup sjtu_drone_bringup.launch.py world:='${WORLD}' 2>&1 | tee '${LOG_DIR}/${TIMESTAMP}_bringup.log'" C-m

sleep 8

tmux new-window -t "${SESSION}" -n rtabmap bash
tmux send-keys -t "${SESSION}:rtabmap" "${ENV_EXPORTS}; source '${MAPS12_ROOT}/scripts/env.sh'; ros2 launch sjtu_drone_bringup rtabmap_lidar_depth.launch.py rtabmapviz:=false 2>&1 | tee '${LOG_DIR}/${TIMESTAMP}_rtabmap.log'" C-m

sleep 8

tmux new-window -t "${SESSION}" -n explorer bash
tmux send-keys -t "${SESSION}:explorer" "${ENV_EXPORTS}; source '${MAPS12_ROOT}/scripts/env.sh'; python3 '${MAPS12_ROOT}/scripts/autonomous_explorer.py' --altitude 1.45 --duration ${DURATION} 2>&1 | tee '${LOG_DIR}/${TIMESTAMP}_explorer.log'" C-m

tmux new-window -t "${SESSION}" -n autosave bash
tmux send-keys -t "${SESSION}:autosave" "${ENV_EXPORTS}; source '${MAPS12_ROOT}/scripts/env.sh'; sleep $((DURATION + 10)); python3 '${MAPS12_ROOT}/scripts/save_live_bundle.py' --output-dir '${LIVE_DIR}' --max-points 900000 2>&1 | tee '${LOG_DIR}/${TIMESTAMP}_live_snapshot.log' || true; pkill -f 'rtabmap_slam/rtabmap' || true; pkill -f 'rtabmap_sync/rgbd_sync' || true; pkill -f 'rtabmap_viz' || true; sleep 3; DB='${DB_PATH}'; [ -f \"\$DB\" ] || DB=~/.ros/rtabmap.db; if [ -f \"\$DB\" ]; then /opt/ros/humble/bin/rtabmap-export --cloud --poses --poses_camera --output_dir '${EXPORT_DIR}' --output rtabmap_cloud --voxel 0.025 \"\$DB\" 2>&1 | tee '${LOG_DIR}/${TIMESTAMP}_export.log' || true; cp \"\$DB\" '${EXPORT_DIR}/rtabmap.db' 2>/dev/null || true; [ -f '${EXPORT_DIR}/rtabmap_cloud_cloud.ply' ] && cp '${EXPORT_DIR}/rtabmap_cloud_cloud.ply' '${EXPORT_DIR}/rtabmap_cloud.ply'; timeout 120 python3 '${MAPS12_ROOT}/scripts/render_output.py' '${EXPORT_DIR}' 2>&1 | tee -a '${LOG_DIR}/${TIMESTAMP}_export.log' || true; fi; pkill -f 'gzserver' || true; pkill -f 'gzclient' || true; echo 'Maps12 tamamlandi: ${RUN_DIR}'" C-m

echo "Maps12 baslatildi."
echo "Sure: ${DURATION} sn"
echo "Spawn: ${MAPS10_SPAWN_X:-0}, ${MAPS10_SPAWN_Y:-0}"
echo "Bounds: ${MAPS10_BOUNDS:-none}"
echo "Cikti: ${RUN_DIR}"
echo "Izlemek icin: tmux attach -t ${SESSION}"
