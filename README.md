# Gelesiye (Delphi Edition) — Modern Veresiye & Cari Takip Sistemi

**Gelesiye**, esnaf, işletme ve serbest meslek sahipleri için tasarlanmış; modern, güvenilir, sade ve hızlı bir veresiye/cari takip yazılımıdır.

Embarcadero Delphi 12 (Athens) ile **Win64** hedefinde; **MVVM (Model-View-ViewModel)** tasarım deseni, **saf nesne yönelimli (OOP) kalıtım**, **veritabanından bağımsız Repository mimarisi** ve **%100 Standart VCL bileşenleri** kullanılarak geliştirilmiştir.

---

## 🚀 Hemen İndir ve Kur

- 📦 **Kararlı Kurulum Paketi (Release x64):** [Gelesiye_Setup_x64.exe](releases/Gelesiye_Setup_x64.exe) — *Önerilen üretim sürümü (~5.6 MB)*
- 🛠️ **Geliştirici / Test Kurulum Paketi (Debug x64):** [Gelesiye_Setup_Debug_x64.exe](releases/Gelesiye_Setup_Debug_x64.exe) — *Hata ayıklama sembolleri ve geliştirici araçları içeren sürüm (~9.2 MB)*

> **Varsayılan Giriş Şifresi:** `gel`

---

## 📸 Ekran Görüntüleri

### 1. Ana Ekran (Cari Listesi & Özet Kartlar)
![Ana Ekran (Cari Listesi)](docs/screenshots/main.png)

<br>

### 2. Hareketler & Borç / Alacak Fişi Girişi
![Hareketler ve Fiş Girişi](docs/screenshots/hareket.png)

---

## 🌟 Öne Çıkan Özellikler ve Portfolyo Yetkinlikleri

### 1. Mimari & Yazılım Tasarımı
- **Saf MVVM Deseni:** Görsel VCL arayüzü (`src/Forms/`), iş ve sunum mantığı (`src/ViewModels/`) ile saf domain nesneleri (`src/Domain/`) birbirinden tamamen izole edilmiştir.
- **Repository Pattern & DB-Agnostic Altyapı:**
  - Tek dosya, sıfır kurulumlu gömülü **SQLite** motoru (`src/Data/uDbSQLite.pas`).
  - Çok kullanıcılı ağ ve ofis ortamları için **Firebird** veritabanı soyutlaması (`src/Data/uDbFirebird.pas`).
- **%100 Standart Delphi VCL:** Harici veya ticari görsel bileşen kütüphanesine (DevExpress vb.) bağımlılık olmadan, tamamen Delphi'nin yerel kontrolleri ve custom-draw teknikleriyle modern Slate-100 arayüzü oluşturulmuştur.

### 2. İşlevsel Fonksiyonlar
- **Hızlı Fiş Girişi & Klavye Kısayolları:**
  - `F5`: Hesaba Borç Ekle (Borç Fişi)
  - `F6`: Tahsilat Yap (Alacak sütunu)
  - `F7`: Hesaba Alacak Ekle (Alacak Fişi)
  - `F8`: Ödeme Yap (Borç sütunu)
  - `F4 / Çift Tık`: Seçili fişi veya cariyi düzenle
- **Sağ Tık Bağlam (Context) Menüleri:** Hem cari listesinde hem hareket tablosunda tüm işlemlere (ekleme, düzenleme, silme, yazdırma, yenileme) sağ tıklayarak hızlı erişim.
- **Profesyonel FastReport Entegrasyonu:**
  - Tahsilat, ödeme, borç ve alacak fişleri için işlem öncesi bakiye, işlem tutarı, son bakiye ve yazıyla tutar içeren profesyonel makbuz çıktıları.
  - Cari hesap ekstresi ve özet/detaylı cari listesi raporları.
- **Canlı TCMB Döviz Kurları:** Türkiye Cumhuriyet Merkez Bankası (TCMB) günlük kurlarını arkaplanda asenkron olarak sorgulayan servis (`uDovizKuruService.pas`).
- **Modern Tema Altyapısı:** Aydınlık ve Karanlık mod desteği sunan merkezi tema yöneticisi (`uGelesiyeTheme.pas`).
- **Çoklu Dil (Lokalizasyon):** Türkçe ve İngilizce arayüz desteği (`uGelesiyeLang.pas`).
- **81 İl & 973 İlçe Veritabanı:** Türkiye il ve ilçe verilerinin otomatik yüklenmesi.

---

## 📂 Dizin Yapısı

```
Gelesiye-Delphi/
├── assets/          # Uygulama ikonları, yüksek çözünürlüklü görseller
├── docs/            # Ekran görüntüleri ve HTML kullanıcı kılavuzu
├── installer/       # Inno Setup 6 x64 kurulum yapılandırma scripti (.iss)
├── releases/        # Dağıtıma hazır 64-bit kurulum paketleri (.exe)
├── scripts/         # Derleme ve kurulum otomasyon betikleri (.bat)
│   ├── build.bat        # Win64 Debug derleme betiği
│   └── build_setup.bat  # Inno Setup kurulum paketi üretme betiği
├── src/             # Delphi kaynak kodları
│   ├── Common/          # Sabitler, temalar, dil ve versiyon tanımları
│   ├── Data/            # SQLite & Firebird repository implementasyonları
│   ├── Domain/          # Varlıklar (Entities) ve servis arayüzleri
│   ├── Forms/           # VCL formları ve özel çizim pencereleri
│   ├── Services/        # Döviz kuru, yazdırma ve yedekleme servisleri
│   └── ViewModels/      # MVVM sunum mantığı sınıfları
└── tests/           # Otomatik birim ve entegrasyon test takımı
```

---

## 🛠️ Derleme ve Kurulum

### Gereksinimler
- **IDE:** Embarcadero Delphi 12 (Community veya Enterprise)
- **Hedef Mimari:** Windows 64-bit (Win64)
- **Kurulum Aracı (Opsiyonel):** Inno Setup 6

### 1. Uygulamayı Derleme (Debug Win64)
Komut satırından doğrudan:
```cmd
scripts\build.bat
```
Çalıştırılabilir çıktı `bin\Debug\Gelesiye.exe` konumunda oluşturulur.

### 2. Kurulum Paketi Üretme (Inno Setup x64)
```cmd
scripts\build_setup.bat
```
Çıktı kurulum paketi `releases\Gelesiye_Setup_x64.exe` olarak hazır hale getirilir.

---

## 📄 Lisans

Bu proje kişisel, eğitim ve şirket içi kullanım için ücretsizdir. Ticari amaçla satışı veya ücretli dağıtımı yapılamaz. Detaylar için [LICENSE](LICENSE) dosyasına bakabilirsiniz.
