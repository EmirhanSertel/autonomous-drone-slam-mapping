# Repository Structure

Recommended GitHub repository name:

```text
kasif-drone-slam
```

Alternative names:

- `drone-slam-rtabmap`
- `kasif-uav-mapping`
- `autonomous-drone-slam-gazebo`

Chosen recommendation: `kasif-drone-slam`

Reason: It is short, project-specific, and clearly communicates the core topic: Kâşif drone + SLAM.

## Final Folder Layout

```text
kasif-drone-slam/
  README.md
  .gitignore
  requirements-demo.txt
  requirements-test.txt
  pytest.ini
  THIRD_PARTY_NOTICES.md
  .github/
    workflows/
      ci.yml
  docs/
    GITHUB_PREP_GUIDE.md
    REPO_STRUCTURE.md
    presentation/
      slam_sunum_15_sayfa.md
    assets/
      README.md
      gazebo/
      outputs/
      web-ui/
  reports/
    experiment_summary.md
  tests/
    test_world_profile.py
  experiment-archive/01-baseline/
  experiment-archive/02-rtabmap-improvement/
  ...
  final-benchmark-experiment/
  WebDemo/
  WebDemo2/
```

## Source Code Folders

The active final scenario is `final-benchmark-experiment/`. Earlier iterations are kept under `experiment-archive/` with numbered, descriptive folder names so they stay available without cluttering the project root.

Each experiment folder keeps:

- `README.md`
- `scripts/`
- `slam_ws/src/`
- `worlds/` when present

Generated folders are ignored:

- `outputs/`
- `yenicikti/`
- `logs/`
- `slam_ws/build/`
- `slam_ws/install/`
- `slam_ws/log/`

## Web Folders

- `WebDemo/`: main static website used for thesis/sunum.
- `WebDemo2/`: optional backend/frontend implementation.

Both stay in the same repo because the project output depends on both SLAM code and web visualization.

## Documentation Assets

Small PNG/JPEG previews were copied into `docs/assets/` so the repository has visual documentation without committing large experiment artifacts.

Full outputs remain outside Git:

- RTAB-Map `.db`
- PLY/PCD point clouds
- OBJ/GLB meshes
- raw RGB/depth frame folders
- zips and handoff archives
