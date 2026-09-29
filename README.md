# YeniYuva

Türkiye'de yaşayan göçmenler, sığınmacılar ve sahada çalışan gönüllüler için geliştirilmiş; temel kamu ve sivil toplum hizmetlerini harita üzerinde listeleyen, çok dilli bir mobil rehber ve destek platformudur.

Kullanıcıların sağlık, eğitim, barınma, hukuki danışmanlık ve sosyal yardım kaynaklarına dil bariyerine takılmadan, konum bazlı olarak erişebilmesini amaçlar.

---

## Temel Modüller

- **Hizmet Haritası (Service Locator):** Kullanıcının bulunduğu konuma en yakın hastane, sağlık ocağı, baro, STK merkezi ve dil kurslarını harita üzerinde gösterir, kategoriye göre filtreler ve yol tarifi sunar.
- **Bilgi Merkezi:** İkamet izni, çalışma hakları, sağlık randevu sistemi (MHRS) ve okul kayıt süreçleri gibi bürokratik konularda doğrulanmış kılavuzlar içerir. Çevrimdışı (offline) erişilebilir.
- **Çoklu Dil ve RTL Desteği:** Türkçe, Arapça, Farsça, İngilizce, Ukraynaca ve Rusça dillerini destekler. Arapça ve Farsça için sağdan sola (RTL) arayüz uyumluluğu bulunur.
- **Topluluk Forumu:** Supabase Realtime altyapısı ile kullanıcıların soru sorabileceği, deneyim paylaşabileceği ve yardımlaşabileceği tartışma alanı.
- **Acil Durum Paneli:** 112 Acil Çağrı, YİMER 157 (Yabancılar İletişim Merkezi) ve en yakın acil yardım merkezlerine tek dokunuşla erişim sağlar.

---

## Teknik Altyapı

- **İstemci (Mobile & Web):** Flutter (Dart) — Tek kod tabanı, Clean Architecture mimarisi, GoRouter, Provider, intl yerelleştirme.
- **Veritabanı ve Arka Uç:** Supabase (PostgreSQL, PostGIS coğrafi sorguları, Row Level Security, Realtime WebSocket, JWT Auth).
- **Harita Servisi:** Mapbox / Google Maps API.
- **Veri Senkronizasyonu:** n8n (Kurum ve STK duyurularının periyodik içeri aktarımı).

---

## Dizin Yapısı

```
yeniyuva-destek/
├── android/               # Android platform yapılandırması
├── ios/                   # iOS platform yapılandırması
├── web/                   # Web platform yapılandırması
├── lib/
│   ├── core/              # Tema, sabitler, network yönetimi ve ortak bileşenler
│   ├── features/          # Modüler özellik paketleri
│   │   ├── admin/         # Yönetici paneli ekranları
│   │   ├── auth/          # Kimlik doğrulama (Giriş/Kayıt)
│   │   ├── emergency/     # Acil durum modülü
│   │   ├── forum/         # Topluluk forumu ve mesajlaşma
│   │   ├── home/          # Ana sayfa ve özet akışı
│   │   ├── info_center/   # Çok dilli rehber içerikleri
│   │   ├── onboarding/    # İlk karşılama ve dil seçimi
│   │   ├── profile/       # Kullanıcı profili ayarları
│   │   └── service_map/   # Harita, konum hesaplama ve hizmet filtreleme
│   ├── l10n/              # 6 dilde ARB ve çeviri kaynakları
│   ├── router/            # GoRouter rota tanımları
│   └── main.dart          # Uygulama başlangıç noktası
├── supabase/              # Veritabanı şeması ve SQL tanımları
├── n8n/                   # Veri otomasyonu için Docker Compose dosyası
└── docs/                  # Proje analizi ve detaylı gereksinim dokümanları
```

---

## Kurulum ve Çalıştırma

### Gereksinimler

- Flutter SDK (3.19 veya üzeri)
- Dart SDK
- Supabase hesabı veya yerel Supabase kurulumu

### Adımlar

1. Depoyu klonlayın ve bağımlılıkları yükleyin:
   ```bash
   git clone https://github.com/yusufci/yeniyuva-destek.git
   cd yeniyuva-destek
   flutter pub get
   ```

2. `.env.example` dosyasını referans alarak `.env` dosyasını oluşturun ve anahtarları girin:
   ```env
   SUPABASE_URL=https://your-project.supabase.co
   SUPABASE_ANON_KEY=your-anon-key-here
   MAPBOX_ACCESS_TOKEN=your-mapbox-access-token-here
   ```

3. Veritabanı tablolarını oluşturmak için `supabase/schema.sql` dosyasındaki SQL sorgularını Supabase SQL editöründe çalıştırın.

4. Uygulamayı başlatın:
   ```bash
   # Mobil cihaz veya emülatörde:
   flutter run

   # Web ortamında:
   flutter run -d chrome
   ```

---

## Ek Dokümanlar

- [Detaylı Proje Analizi ve Fonksiyonel Gereksinimler](docs/PROJE_DOKUMANTASYONU.md)
- [Aşama Aşama Geliştirme Planı](docs/GELISTIRME_PLANI.md)

---

## Proje Durumu

> **Not:** Bu çalışma zamanında bir fikir ve prototip olarak geliştirilmiş olup şu anda aktif olarak sürdürülmemektedir. İleri seviye ya da tamamlanmış bir kurumsal yazılım iddiası taşımamaktadır; zamanında yapılıp arşive kaldırılmış, ilgilenenler için referans niteliğinde bir açık kaynak tabandır.

---

## Lisans

Bu proje MIT Lisansı altında sunulmaktadır. Ayrıntılar için `LICENSE` dosyasına bakabilirsiniz.
