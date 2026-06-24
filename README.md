# Kâşif Drone SLAM

ROS 2, Gazebo ve RTAB-Map kullanarak kapalı alanlarda drone tabanlı 3B haritalama ve otonom keşif denemeleri için hazırlanmış proje deposudur. Çalışma Maps1-Maps12 arasında adım adım geliştirilmiştir: ilk sürümlerde temel SLAM hattı kurulmuş, orta sürümlerde sensör ve rota kalitesi iyileştirilmiş, son sürümlerde genel otonom keşif algoritması farklı harita tiplerinde denenmiştir.

Bu repo kod ve dokümantasyon odaklıdır. Büyük SLAM çıktıları, RTAB-Map veritabanları, nokta bulutları, mesh dosyaları, build klasörleri ve ham veri setleri içermemektedir.



## İçerik

- `experiment-archive/01-baseline/`: ilk baseline çalışma notları ve eski çıktı referansı.
- `experiment-archive/02-rtabmap-improvement/` - `experiment-archive/06-side-depth-cameras/`: RTAB-Map hattı, sensör yerleşimi, rota ve çıktı kalitesi denemeleri.
- `experiment-archive/07-autonomous-coverage/` - `experiment-archive/08-waypoint-free-coverage/`: visited-grid, coverage ve recovery tabanlı otonom keşif denemeleri.
- `experiment-archive/09-controlled-tunnel/`: temiz tünel çıktısı için kontrollü waypoint denemesi.
- `experiment-archive/10-general-autonomous/` - `final-benchmark-experiment/`: aynı genel otonom algoritmanın farklı ortam türlerinde test edildiği final grup.
- `WebDemo/`: statik web sunumu. Tez ve sunumda kullanılan ana arayüz.
- `WebDemo2/`: .NET backend + frontend denemesi. Opsiyonel, tam sistem servisi için ayrılmıştır.
- `docs/assets/`: GitHub'a uygun küçük çıktı ve web arayüzü görselleri.
- `docs/presentation/`: 15 sayfalık sunum taslağı.
- `reports/`: deney özetleri ve GitHub'a konmayan çıktıların açıklaması.
- `tests/`: ROS/Gazebo açmadan çalışabilen hafif pytest testleri.

## Önerilen Sistem

Geliştirme ve simülasyon için önerilen ortam:

- İşletim sistemi: Ubuntu 22.04 LTS
- CPU: 6 çekirdek ve üzeri
- RAM: en az 16 GB, önerilen 32 GB
- Disk: kod için 5-10 GB, deney çıktıları için ek 50 GB ve üzeri
- GPU: Gazebo/RViz için OpenGL destekli GPU önerilir

Minimum demo/dokümantasyon inceleme için:

- Ubuntu 22.04 veya modern Linux dağıtımı
- Python 3.10+
- Node.js 20+ sadece frontend sözdizimi kontrolü için

## Gerekli Teknolojiler

Simülasyon ve SLAM çalıştırmak için:

- ROS 2 Humble
- Gazebo Classic / Gazebo 11 uyumlu kurulum
- RTAB-Map ve ROS 2 RTAB-Map paketleri
- colcon
- tmux
- Python 3.10
- NumPy, OpenCV ve Pillow

Web demo için:

- Python 3 HTTP server yeterlidir
- Three.js dosyaları `WebDemo/node_modules` içinde yerel geliştirmede bulunabilir; GitHub'da `node_modules` tutulmaz

Opsiyonel WebDemo2 backend için:

- .NET 8 SDK
- MSSQL Server veya uyumlu SQL Server bağlantısı
- EF Core araçları

## Kurulum

1. Depoyu klonlayın.

```bash
git clone <repo-url>
cd Project-Final
```

2. Python demo bağımlılıklarını kurun.

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements-demo.txt
```

3. ROS 2 ortamını kurun.

Ubuntu 22.04 üzerinde ROS 2 Humble kurulmalıdır. Kurulum resmi ROS dokümantasyonuna göre yapılmalıdır.

4. RTAB-Map ve Gazebo bağımlılıklarını kurun.

Sistemde `ros2`, `gazebo`, `rtabmap`, `rtabmap-databaseViewer` ve `colcon` komutlarının çalıştığını doğrulayın.

```bash
ros2 --help
gazebo --version
rtabmap --version
colcon --help
```

5. Çalıştırılacak map klasöründe workspace build edin.

Örnek:

```bash
cd final-benchmark-experiment
./scripts/build.sh
```

## Çalıştırma

Her map kendi `scripts/` klasörüyle çalıştırılır. Genel akış:

```bash
cd final-benchmark-experiment
./scripts/start.sh
```

Canlı gözlem ve kayıt almadan deneme için:

```bash
cd final-benchmark-experiment
./scripts/start_live.sh
```

Durdurma:

```bash
./scripts/stop.sh
```

Çıktı kaydetme:

```bash
./scripts/save.sh
```

Not: `start.sh` bazı haritalarda otomatik kayıt/export akışı başlatabilir. Sadece görsel kontrol yapılacaksa `start_live.sh` veya manuel Gazebo + explorer oturumu kullanılmalıdır.

## Web Demo

Statik web sunumu Project-Final kökünden servis edilmelidir; böylece harita dosya yolları doğru çözülür.

```bash
python3 -m http.server 8088 --bind 0.0.0.0 --directory .
```

Tarayıcı:

```text
http://localhost:8088/WebDemo/
```

WebDemo harita kartlarını, final çıktı önizlemelerini, nokta bulutu/mesh bağlantılarını ve kamera/depth görsellerini sunmak için kullanılır. Büyük `.ply`, `.db`, `.glb` dosyaları GitHub'a konmaz; bu dosyalar deney çalıştırıldığında tekrar üretilir veya harici depoda saklanır.

## Dokümantasyon Görselleri

README, rapor ve sunum için seçilen küçük görseller `docs/assets/` altında tutulur:

- `docs/assets/gazebo/`: Gazebo ve RViz ekranları.
- `docs/assets/web-ui/`: web arayüzü ekranları.
- `docs/assets/outputs/`: final çıktı önizlemeleri ve RTAB-Map Database Viewer ekranı.

Bu klasörde sadece küçük PNG/JPEG dokümantasyon görselleri yer alır. Tam çözünürlüklü deney çıktıları, nokta bulutları ve mesh dosyaları repoya eklenmez.

## Map Serisi Özeti

| Map | Amaç | Uçuş mantığı |
| --- | --- | --- |
| Maps1 | İlk çalışan baseline | Eski temel çalışma |
| Maps2 | RTAB-Map hattını iyileştirme | Kontrollü oda denemesi |
| Maps3 | Tünel/koridor denemesi | Kontrollü rota |
| Maps4 | Geniş galeri ve loop closure | Gidiş-dönüş rota |
| Maps5 | Daha temiz nokta bulutu | Yavaş kontrollü rota |
| Maps6 | Sağ/sol depth kamera | Kontrollü rota + ek sensör |
| Maps7 | Otonom coverage başlangıcı | visited-grid + recovery |
| Maps8 | Waypoint'siz otonom deneme | coverage skorlaması |
| Maps9 | Temiz tünel çıktısı | kontrollü waypoint |
| Maps10 | Genel otonom explorer | haritaya özel waypoint yok |
| Maps11 | Zorlu dönüşlü tünel | Maps10 ile aynı algoritma |
| Maps12 | Benchmark benzeri ortam | experiment-archive/10-general-autonomous/11 ile aynı algoritma |

## Final Deney Özeti

| Ortam türü | Pose | Link | Ham nokta | Voxel sonrası nokta | RTAB-Map DB |
| --- | ---: | ---: | ---: | ---: | ---: |
| Genel oda/koridor | 166 | 391 | 1.281.401 | 1.032.035 | 577 MB |
| Dönüşlü tünel | 152 | 443 | 1.133.121 | 599.763 | 450 MB |
| Loop oda/koridor benchmark | 151 | 373 | 1.498.090 | 845.870 | 584 MB |

Bu sonuçlar, aynı genel otonom keşif algoritmasının farklı geometrilerde RTAB-Map çıktısı üretebildiğini gösterir. Sistem global frontier planner değildir; bu nedenle tüm haritanın gezilmesi garanti edilmez.

## Çıktıların Anlamı

- `rtabmap.db`: RTAB-Map ana veritabanı.
- `rtabmap_cloud.ply`: final 3B nokta bulutu.
- `rtabmap_cloud_poses.txt`: poz/trajectory kaydı.
- `rtabmap_cloud_camera_poses.txt`: kamera pozları.
- `render_bev.png`: üstten 2B harita görünümü.
- `mesh.obj`, `mesh_unlit.glb`: mesh/web gösterimi için çıktı.
- `live_snapshot/camera`: RGB ve depth kamera görüntüleri.
- `live_snapshot/lidar`: LiDAR nokta bulutu önizlemesi.
- `live_snapshot/fused_slam`: canlı birleşik SLAM snapshot.

## GitHub'a Konmayan Dosyalar

Aşağıdaki dosyalar bilinçli olarak repoya konmaz:

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
- `*.db`, `*.ply`, `*.glb`, `*.obj`, `*.bag`
- `rgb/`, `depth/`, `datasets/`, `models/`, `weights/`
- `node_modules/`
- Eski zip arşivleri ve geçici aktarım paketleri

Bu dosyalar büyük, makineye özel veya yeniden üretilebilir çıktılardır. Deney sonuçları rapor olarak `reports/` altında özetlenir.

## Testler

Hafif testler ROS/Gazebo açmaz ve büyük model yüklemez.

```bash
pip install -r requirements-test.txt
pytest -q
```

Frontend sözdizimi kontrolü:

```bash
node --check WebDemo/app.js
node --check WebDemo2/Frontend/app.js
```

## CI

`.github/workflows/ci.yml` GitHub Actions üzerinde şunları çalıştırır:

- Python testleri
- WebDemo JavaScript syntax check
- WebDemo2 frontend JavaScript syntax check

CI gerçek Gazebo, RTAB-Map, ROS 2 simülasyonu veya büyük model/çıktı yüklemez.

## environment.yml Durumu

Bu projede `environment.yml` önerilmez. Ana bağımlılıklar ROS 2, Gazebo, RTAB-Map ve sistem paketleri olduğu için Conda ortamı eksik ve yanıltıcı kalır. Python tarafı için `requirements-demo.txt` ve `requirements-test.txt` ayrılmıştır.

## Lisans ve Üçüncü Parti Bileşenler

Üçüncü parti bileşenler ve dikkat edilmesi gereken lisans notları için `THIRD_PARTY_NOTICES.md` dosyasına bakın.

## Ek Dokümanlar

- `docs/REPO_STRUCTURE.md`: önerilen repo adı ve nihai klasör yapısı.
- `docs/GITHUB_PREP_GUIDE.md`: GitHub'a yükleme öncesi paketleme rehberi.
- `docs/presentation/slam_sunum_15_sayfa.md`: 15 sayfalık sunum akışı.
- `reports/experiment_summary.md`: final deney sonuçlarının kısa özeti.
