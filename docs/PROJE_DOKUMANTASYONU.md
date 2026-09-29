# PROJE ADI: YeniYuva - Göçmen Destek ve Bilgilendirme Platformu

## 1. PROJE ÖZETİ VE VİZYONU

**Ana Fikir:** Türkiye'de yaşayan göçmenler, mülteciler ve sığınmacılar için tasarlanmış, çok dilli, merkezi bir mobil ve web uygulaması geliştir. Bu platform, ABD'deki "USAHello/FindHello" modelinden ilham alarak, kullanıcıların temel hizmetlere (sağlık, eğitim, barınma, hukuki destek vb.) kolayca erişmesini sağlayacak bir "dijital yaşam rehberi" olacaktır.

**Çözülecek Temel Sorun:** Dil ve bilgi bariyerleri nedeniyle göçmenlerin kamu ve sivil toplum hizmetlerine erişimde yaşadığı zorlukları ortadan kaldırmak.

**Hedef:** Kullanıcıların, bulundukları konuma en yakın kritik kaynakları harita üzerinde görmelerini, hizmetler hakkında güncel bilgi almalarını ve toplulukla etkileşim kurmalarını sağlamak.

---

## 2. HEDEF KULLANICI PROFİLLERİ

1.  **Göçmen/Mülteci Aileler ve Bireyler:** Ana kullanıcı kitlesi. Uygulamayı günlük hayattaki ihtiyaçları için kullanacaklar (örn: "En yakın Arapça konuşan doktor nerede?", "Çocuğum için okul kaydını nasıl yaparım?").
2.  **STK Çalışanları ve Gönüllüler:** Sahada göçmenlere destek olan kişiler. Danışmanlık verdikleri kişileri doğru kaynaklara yönlendirmek için uygulamayı bir araç olarak kullanacaklar.
3.  **Kamu Kurumu Personeli:** Göçmenlerle çalışan memurlar (örn: Göç İdaresi, belediyeler). Hizmetlerin bilinirliğini artırmak için platformu kullanabilirler.

---

## 3. TEKNİK YAPI (TECHNOLOGY STACK)

*   **Ön Yüz (Frontend):** **Flutter**. Tek bir kod tabanı ile iOS, Android ve Web platformlarında çalışacak. Bu, geliştirme ve bakım maliyetlerini düşürecektir.
*   **Arka Uç (Backend):** **Supabase (PostgreSQL)**. Açık kaynak, PostgreSQL tabanlı, real-time özellikleri ve coğrafi sorgu desteği ile bu proje için idealdir.
*   **Veritabanı:** **PostgreSQL** (PostGIS eklentisi ile). Coğrafi (konum bazlı) sorgulamalar için yüksek performanslı ve güvenilir bir çözümdür.
*   **Harita Servisi:** **Google Maps API**. Konum tabanlı hizmetlerin gösterimi, rota çizimi ve yer arama işlevleri için kullanılacak.
*   **Çoklu Dil Desteği (i18n):** Flutter'ın `intl` paketi ve ARB dosyaları kullanılacak. Tüm metinler (arayüz, içerik, hata mesajları) merkezi bir yerden yönetilecek.
*   **Veri Otomasyonu:** **n8n**. Açık kaynak workflow otomasyon aracı ile STK ve kamu kurumlarının RSS feed'lerinden otomatik veri çekilecek.

---

## 4. TEMEL ÖZELLİKLER (FONKSİYONEL GEREKSİNİMLER)

### 4.1. Hizmet Haritası (Service Locator)

*   **İnteraktif Harita:** Google Maps entegrasyonu ile hizmet noktalarının (sağlık ocağı, okul, STK merkezi vb.) gösterimi.
*   **Kategori Bazlı Filtreleme:**
    *   Sağlık (Hastane, Sağlık Ocağı, Eczane)
    *   Eğitim (Okul, Dil Kursu, Üniversite)
    *   Hukuki Destek (Baro, Hukuk Büroları, Danışmanlık)
    *   Barınma (Geçici Konaklama, Kiralık Ev, Yurt)
    *   Sosyal Yardım (Gıda Bankası, Giysi Yardımı)
    *   İş ve Kariyer (İş Bulma Kurumları, Meslek Kursları)
    *   Topluluk Merkezleri
*   **Arama Fonksiyonu:** Anahtar kelime ve adres ile arama.
*   **Konum Bazlı Arama:** Kullanıcının mevcut konumuna göre en yakın hizmetleri listeleme (örn: 5km, 10km, 25km yarıçapında).
*   **Detaylı Hizmet Bilgisi:** Seçilen hizmet noktası için detaylı bilgi kartı (adres, telefon, çalışma saatleri, sunulan hizmetler, konuşulan diller).
*   **Rota Oluşturma:** Seçilen hizmet noktasına yol tarifi.

### 4.2. Bilgi Merkezi (Rehber)

*   **Kategorize Edilmiş Makaleler:**
    *   **Türkiye'de Yaşam:** Oturma izni, vatandaşlık, ulaşım, bankacılık vb.
    *   **Eğitim Sistemi:** Okul kayıtları, denklik, burslar.
    *   **Sağlık Sistemi:** Randevu alma, acil servisler, sigorta.
    *   **Çalışma Hayatı:** Çalışma izni, iş arama, haklar.
    *   **Hukuki Haklar:** Mülteci statüsü, hak ve yükümlülükler.
*   **Çoklu Dil Desteği:** Tüm makaleler hedef dillerde (Türkçe, Arapça, Farsça, İngilizce, Ukraynaca, Rusça) sunulmalı.
*   **Arama Fonksiyonu:** Makaleler içinde anahtar kelime ile arama.

### 4.3. Topluluk Forumu

*   **Gerçek Zamanlı Mesajlaşma:** Supabase Realtime (WebSocket) ile anlık sohbet.
*   **Konu Başlıkları (Threads):** Kullanıcıların belirli konularda (örn: 
İş arıyorum", "Ev arıyorum") tartışma başlatmalarına olanak tanıma.
*   **Yanıtlar ve Yorumlar:** Kullanıcıların birbirlerinin başlıklarına yanıt vermesi.
*   **Oylama ve Beğeni:** Faydalı yanıtları ve başlıkları öne çıkarmak için oylama sistemi.
*   **Kullanıcı Profilleri:** Basit kullanıcı profilleri (kullanıcı adı, profil resmi, katılım tarihi).
*   **Moderasyon:** Uygunsuz içeriği bildirme (raporlama) ve moderatörler tarafından yönetilme.

### 4.4. Kullanıcı Yönetimi ve Kimlik Doğrulama

*   **Kayıt ve Giriş:**
    *   E-posta ve şifre ile kayıt.
    *   Sosyal medya ile giriş (Google, Apple).
    *   SMS ile telefon numarası doğrulama (opsiyonel, güvenlik için).
*   **Profil Yönetimi:** Kullanıcıların kendi profil bilgilerini (kullanıcı adı, şifre) güncelleyebilmesi.
*   **Güvenlik:** Supabase Auth ile güvenli JWT (JSON Web Token) tabanlı oturum yönetimi.

---

## 5. TEKNİK OLMAYAN GEREKSİNİMLER

### 5.1. Kullanıcı Arayüzü ve Deneyimi (UI/UX)

*   **Basit ve Anlaşılır Tasarım:** Düşük teknoloji okuryazarlığına sahip kullanıcılar için bile kolayca gezilebilir olmalı.
*   **Görsel Hiyerarşi:** Önemli bilgiler (acil durum numaraları, en yakın hastane) kolayca fark edilebilir olmalı.
*   **Çoklu Dil Desteği:** Arayüz, sağdan sola (RTL) yazılan dilleri (Arapça, Farsça) tam olarak desteklemeli.
*   **Erişilebilirlik (Accessibility):** Ekran okuyucular ve yüksek kontrast modu gibi özellikler desteklenmeli.
*   **Performans:** Uygulama yavaş internet bağlantılarında bile hızlı çalışmalı.

### 5.2. Güvenlik ve Veri Gizliliği

*   **KVKK ve GDPR Uyumu:** Türkiye ve AB veri koruma yasalarına tam uyum.
*   **Veri Şifreleme:** Tüm kullanıcı verileri hem aktarım sırasında (HTTPS/TLS) hem de depolanırken (at-rest encryption) şifrelenmeli.
*   **Anonimlik:** Kullanıcılar forumda anonim veya takma ad ile paylaşım yapabilmeli.
*   **Veri Minimizasyonu:** Sadece uygulamanın çalışması için kesinlikle gerekli olan minimum kullanıcı verisi toplanmalı.
*   **Şeffaf Gizlilik Politikası:** Verilerin nasıl toplandığı, kullanıldığı ve korunduğu açık ve anlaşılır bir dille anlatılmalı.

### 5.3. Çevrimdışı İşlevsellik (Offline-First)

*   **Önbellekleme (Caching):** Kritik veriler (hizmet noktaları, rehber makaleleri) cihazda yerel olarak saklanmalı.
*   **Senkronizasyon:** İnternet bağlantısı geri geldiğinde, çevrimdışı yapılan işlemler (forum gönderisi, favoriye ekleme) otomatik olarak sunucu ile senkronize edilmeli.
*   **Kullanıcı Bildirimi:** Uygulamanın çevrimdışı olduğu ve verilerin senkronize edileceği kullanıcıya net bir şekilde belirtilmeli.

---

## 6. MİMARİ VE GELİŞTİRME DETAYLARI

### 6.1. Frontend Mimarisi (Flutter)

*   **Mimari Desen:** **MVVM (Model-View-ViewModel) + Clean Architecture** kombinasyonu kullanılacak.
    *   **Presentation Layer (View & ViewModel):** Flutter widget'ları ve state management (Riverpod).
    *   **Domain Layer (Use Cases):** İş mantığı, entity'ler.
    *   **Data Layer (Repositories):** Supabase API ve yerel veritabanı (SQLite) ile iletişim.
*   **State Management:** **Riverpod** kullanılacak. Compile-time safety, basit dependency injection ve ölçeklenebilir yapısı nedeniyle tercih edilmiştir.
*   **Navigasyon:** `go_router` paketi ile tip-güvenli (type-safe) ve deep-linking destekli yönlendirme.
*   **Yerel Veritabanı:** `drift` (eski adıyla Moor) paketi kullanılacak. Type-safe SQLite implementasyonu sağlar ve reaktif veri akışları sunar.

### 6.2. Backend Mimarisi (Supabase)

*   **Veritabanı Şeması:**
    *   `services`: Hizmet noktalarını (isim, adres, kategori, koordinatlar vb.) içerir. PostGIS `geometry` tipi kullanılacak.
    *   `articles`: Rehber makalelerini (başlık, içerik, dil, kategori) içerir.
    *   `forum_threads`: Forum başlıklarını içerir.
    *   `forum_posts`: Forum yanıtlarını içerir.
    *   `users`: Supabase Auth ile entegre kullanıcı profilleri.
*   **API:** Supabase'in otomatik oluşturduğu REST ve GraphQL API'leri kullanılacak.
*   **Erişim Kontrolü:** **Row-Level Security (RLS)** ile kullanıcıların sadece kendi verilerine veya izinli oldukları verilere erişmesi sağlanacak. Örneğin, bir kullanıcı sadece kendi profilini güncelleyebilir.
*   **Real-time:** Forum ve bildirimler için Supabase Realtime Subscriptions kullanılacak.
*   **Database Functions (pg_cron):** Zamanlanmış görevler (örn: haftalık rapor oluşturma) için PostgreSQL fonksiyonları.

### 6.3. Veri Otomasyon Mimarisi (n8n)

*   **Workflow Tetikleyicileri:** Belirli aralıklarla (örn: her 6 saatte bir) çalışan Cron job'lar.
*   **Node'lar:**
    1.  **RSS Reader Node:** Hedef STK ve kurumların RSS feed'lerini okur.
    2.  **Filter Node:** Yeni ve ilgili duyuruları filtreler.
    3.  **Set Node:** Veriyi standart bir formata dönüştürür.
    4.  **PostgreSQL Node:** Veriyi Supabase veritabanındaki `services` veya `articles` tablosuna ekler.
    5.  **Discord/Slack Node:** Yeni bir veri eklendiğinde moderatörlere bildirim gönderir.
*   **Hosting:** n8n, ayrı bir Docker container'ında self-hosted olarak çalıştırılabilir.

---

## 7. GELİŞTİRME YOL HARİTASI (ROADMAP)

### Faz 1: MVP (Minimum Viable Product) - (Tahmini Süre: 3-4 Ay)

*   **Hedef:** Temel işlevselliğe sahip, kullanılabilir bir ürün ortaya çıkarmak.
*   **Özellikler:**
    *   Kullanıcı kaydı ve girişi (E-posta/şifre, Google).
    *   Hizmet haritası (filtreleme ve arama).
    *   Rota oluşturma.
    *   Bilgi merkezi (sınırlı sayıda makale ile).
    *   Çoklu dil desteği (Türkçe, Arapça, İngilizce).
    *   Manuel veri girişi için basit bir admin paneli.

### Faz 2: Topluluk ve Çevrimdışı Yetenekler - (Tahmini Süre: 2-3 Ay)

*   **Hedef:** Kullanıcı etkileşimini ve uygulamanın erişilebilirliğini artırmak.
*   **Özellikler:**
    *   Topluluk forumu (başlık açma, yanıtlama).
    *   Kullanıcı profilleri.
    *   Çevrimdışı mod (harita ve rehber makaleleri için).
    *   Favori hizmetleri kaydetme.
    *   Push bildirimleri (yeni forum yanıtları için).

### Faz 3: Otomasyon ve Ölçeklendirme - (Tahmini Süre: 2-3 Ay)

*   **Hedef:** Veri güncelliğini sağlamak ve platformu genişletmek.
*   **Özellikler:**
    *   n8n ile RSS feed otomasyonu.
    *   Daha fazla dil desteği (Farsça, Ukraynaca, Rusça).
    *   Gelişmiş forum moderasyon araçları.
    *   Kullanıcı geri bildirim ve anket sistemi.
    *   Performans optimizasyonu ve analitik entegrasyonu (Sentry, Firebase Analytics).

---

## 8. BAŞARI METRİKLERİ (KPIs)

*   **Kullanıcı Etkileşimi:**
    *   Aylık Aktif Kullanıcı (MAU).
    *   Kullanıcı Tutma Oranı (Retention Rate).
    *   Ortalama Oturum Süresi.
*   **Hizmet Erişimi:**
    *   Günlük yapılan hizmet araması sayısı.
    *   Rota oluşturma sayısı.
*   **Topluluk Sağlığı:**
    *   Günlük açılan forum başlığı ve yanıt sayısı.
    *   Çözülen sorun oranı (kullanıcıların birbirine yardım etmesi).
*   **Teknik Performans:**
    *   Uygulama çökme oranı (Crash-free users).
    *   API yanıt süresi (<200ms).

Bu doküman, YeniYuva projesinin tüm teknik ve fonksiyonel gereksinimlerini detaylandırarak, bir kod üretim yapay zekası için net ve kapsamlı bir başlangıç noktası sunmayı amaçlamaktadır.
