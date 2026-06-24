# GitHub Hazırlık Rehberi

## 1. Önerilen Repo Klasör Yapısı

Önerilen repo adı:

```text
kasif-drone-slam
```

```text
Project-Final/
  README.md
  .gitignore
  requirements-demo.txt
  requirements-test.txt
  THIRD_PARTY_NOTICES.md
  .github/workflows/ci.yml
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
  experiment-archive/02-rtabmap-improvement/ ... final-benchmark-experiment/
    README.md
    scripts/
    slam_ws/src/
    worlds/                # varsa
  WebDemo/
  WebDemo2/
```

## 2. Eksik / Gereksiz Dosya Analizi

GitHub'a konmaması gereken büyük veya geçici dosyalar:

- `final-benchmark-experiment/outputs/`
- `final-benchmark-experiment/yenicikti/`
- `final-benchmark-experiment/logs/`
- `final-benchmark-experiment/slam_ws/build/`
- `final-benchmark-experiment/slam_ws/install/`
- `final-benchmark-experiment/slam_ws/log/`
- `experiment-archive/*/outputs/`
- `experiment-archive/*/yenicikti/`
- `experiment-archive/*/logs/`
- `experiment-archive/*/slam_ws/build/`
- `experiment-archive/*/slam_ws/install/`
- `experiment-archive/*/slam_ws/log/`
- `WebDemo/node_modules/`
- `WebDemo2/**/obj/`
- `WebDemo2/**/bin/`
- `rgb/`
- `depth/`
- `bugrayaat.zip`, `bugrayaatv2.zip`
- `*.db`, `*.ply`, `*.glb`, `*.obj`, `*.bag`, model ağırlıkları ve veri setleri

Bu dosyalar ya yeniden üretilebilir çıktıdır ya da makineye özel build/cache dosyasıdır.

## 3. Yazılan veya Güncellenen Dosyalar

- `README.md`
- `.gitignore`
- `requirements-demo.txt`
- `requirements-test.txt`
- `pytest.ini`
- `.github/workflows/ci.yml`
- `tests/test_world_profile.py`
- `reports/experiment_summary.md`
- `THIRD_PARTY_NOTICES.md`
- `docs/REPO_STRUCTURE.md`
- `docs/assets/README.md`
- `docs/assets/gazebo/*`
- `docs/assets/outputs/*`
- `docs/assets/web-ui/*`
- `docs/presentation/slam_sunum_15_sayfa.md`
- `final-benchmark-experiment/scripts/world_profile.py`
- `WebDemo/package.json`
- `WebDemo2/Frontend/package.json`

## 4. README.md İçeriği

Ana README kök dizinde yer alır. Projenin amacı, sistem gereksinimleri, kurulum, çalıştırma, web demo, map serisi, çıktı politikası, testler ve CI bölümlerini içerir.

## 5. .gitignore İçeriği

Kök `.gitignore` dosyası ROS build klasörlerini, SLAM çıktılarını, nokta bulutlarını, meshleri, veri setlerini, model ağırlıklarını, node_modules ve .NET obj/bin klasörlerini dışarıda bırakır.

## 6. requirements Dosyaları

- `requirements-demo.txt`: demo/render ve yerel yardımcı script bağımlılıkları.
- `requirements-test.txt`: CI ve pytest bağımlılıkları.

## 7. environment.yml Durumu

`environment.yml` oluşturulmadı. Bu proje ROS 2, Gazebo ve RTAB-Map gibi apt/sistem bağımlılıklarına dayandığı için Conda ortamı gerçek kurulumu temsil etmez. Python bağımlılıkları ayrı requirements dosyalarıyla yönetilir.

## 8. THIRD_PARTY_NOTICES.md Durumu

Gerekli görüldü ve eklendi. Projede ROS 2, Gazebo, RTAB-Map, sjtu_drone, Three.js, obj2gltf, ASP.NET Core, EF Core ve OpenCV/Pillow/NumPy gibi üçüncü parti bileşenler kullanıldığı için kısa lisans ve kaynak notu tutulmalıdır.

## 9. Test Dosyası Önerisi

`tests/test_world_profile.py` eklendi. Bu test:

- gerçek ROS/Gazebo açmaz,
- büyük model veya veri yüklemez,
- world dosyası profil çıkarma mantığını küçük XML örneğiyle test eder.

İleride eklenebilecek testler:

- WebDemo `maps` verisinde zorunlu alanlar var mı?
- `render_output.py` küçük fake PLY ile BEV dosyası üretebiliyor mu?
- `ProjectFinalImportService` seed map metadatası beklenen map sayısını içeriyor mu?

## 10. GitHub'a Yüklemeden Önce Kontrol Listesi

```bash
git status --short
find . -type f -size +50M
pytest -q
node --check WebDemo/app.js
node --check WebDemo2/Frontend/app.js
git check-ignore -v final-benchmark-experiment/yenicikti/20260621_202718_maps12_general_benchmark_9dk/rtabmap_export/rtabmap.db
git check-ignore -v WebDemo/node_modules/three/build/three.module.js
```

Kontrol:

- Büyük `.db`, `.ply`, `.glb`, `.obj` dosyaları staged olmamalı.
- `slam_ws/build`, `install`, `log` staged olmamalı.
- `node_modules` staged olmamalı.
- README ve reports güncel olmalı.
- Testler geçmeli.

## 11. Önerilen Commit Mesajı

```text
docs: prepare Project-Final for GitHub handoff
```

Alternatif:

```text
chore: add repo docs, gitignore, lightweight tests and CI
```
