-- YeniYuva - Supabase Database Schema
-- PostGIS eklentisini aktifleştir
CREATE EXTENSION IF NOT EXISTS postgis;

-- ============================================
-- PROFILES (Kullanıcı Profilleri)
-- ============================================
CREATE TABLE profiles (
    id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
    username TEXT UNIQUE,
    avatar_url TEXT,
    preferred_language TEXT DEFAULT 'tr',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Yeni kullanıcı kaydında otomatik profil oluştur
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.profiles (id, username, preferred_language)
    VALUES (
        NEW.id,
        COALESCE(NEW.raw_user_meta_data->>'username', 'user_' || LEFT(NEW.id::text, 8)),
        COALESCE(NEW.raw_user_meta_data->>'preferred_language', 'tr')
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION handle_new_user();

-- ============================================
-- SERVICES (Hizmet Noktaları)
-- ============================================
CREATE TABLE services (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name JSONB NOT NULL,              -- {"tr": "...", "ar": "...", "en": "..."}
    description JSONB,
    category TEXT NOT NULL,            -- health, education, legal, housing, social_aid, employment, community
    address JSONB NOT NULL,            -- {"tr": "...", "ar": "...", "en": "..."}
    location GEOMETRY(Point, 4326) NOT NULL,
    phone TEXT,
    working_hours JSONB,              -- {"monday": {"open": "08:00", "close": "17:00"}, ...}
    spoken_languages TEXT[] DEFAULT '{"tr"}',
    website TEXT,
    email TEXT,
    is_active BOOLEAN DEFAULT true,
    is_verified BOOLEAN DEFAULT false,
    created_by UUID REFERENCES profiles(id),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Konum bazlı arama için spatial index
CREATE INDEX idx_services_location ON services USING GIST(location);
CREATE INDEX idx_services_category ON services(category);
CREATE INDEX idx_services_is_active ON services(is_active);

-- ============================================
-- ARTICLES (Rehber Makaleleri)
-- ============================================
CREATE TABLE articles (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    title JSONB NOT NULL,              -- {"tr": "...", "ar": "...", "en": "..."}
    content JSONB NOT NULL,            -- {"tr": "...", "ar": "...", "en": "..."}
    summary JSONB,                     -- {"tr": "...", "ar": "...", "en": "..."}
    category TEXT NOT NULL,            -- life_in_turkey, education_system, health_system, work_life, legal_rights
    slug TEXT UNIQUE NOT NULL,
    cover_image_url TEXT,
    is_published BOOLEAN DEFAULT false,
    author_id UUID REFERENCES profiles(id),
    view_count INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_articles_category ON articles(category);
CREATE INDEX idx_articles_slug ON articles(slug);
CREATE INDEX idx_articles_is_published ON articles(is_published);

-- ============================================
-- FORUM THREADS (Forum Başlıkları)
-- ============================================
CREATE TABLE forum_threads (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    category TEXT,
    author_id UUID REFERENCES profiles(id) NOT NULL,
    vote_count INTEGER DEFAULT 0,
    reply_count INTEGER DEFAULT 0,
    is_locked BOOLEAN DEFAULT false,
    is_pinned BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_forum_threads_category ON forum_threads(category);
CREATE INDEX idx_forum_threads_author ON forum_threads(author_id);
CREATE INDEX idx_forum_threads_created ON forum_threads(created_at DESC);

-- ============================================
-- FORUM POSTS (Forum Yanıtları)
-- ============================================
CREATE TABLE forum_posts (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    body TEXT NOT NULL,
    thread_id UUID REFERENCES forum_threads(id) ON DELETE CASCADE NOT NULL,
    author_id UUID REFERENCES profiles(id) NOT NULL,
    vote_count INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_forum_posts_thread ON forum_posts(thread_id);
CREATE INDEX idx_forum_posts_author ON forum_posts(author_id);

-- ============================================
-- FAVORITES (Favori Hizmetler)
-- ============================================
CREATE TABLE favorites (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
    service_id UUID REFERENCES services(id) ON DELETE CASCADE NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(user_id, service_id)
);

CREATE INDEX idx_favorites_user ON favorites(user_id);

-- ============================================
-- REPORTS (İçerik Bildirimi)
-- ============================================
CREATE TABLE reports (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    reporter_id UUID REFERENCES profiles(id) NOT NULL,
    target_type TEXT NOT NULL,          -- thread, post, service
    target_id UUID NOT NULL,
    reason TEXT NOT NULL,
    description TEXT,
    status TEXT DEFAULT 'pending',      -- pending, reviewed, resolved, dismissed
    reviewed_by UUID REFERENCES profiles(id),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_reports_status ON reports(status);

-- ============================================
-- VOTES (Oylama)
-- ============================================
CREATE TABLE votes (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
    target_type TEXT NOT NULL,          -- thread, post
    target_id UUID NOT NULL,
    value INTEGER NOT NULL CHECK (value IN (-1, 1)),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(user_id, target_type, target_id)
);

-- ============================================
-- RPC FUNCTIONS
-- ============================================

-- Yakın hizmetleri bulan fonksiyon
CREATE OR REPLACE FUNCTION nearby_services(
    lat DOUBLE PRECISION,
    lng DOUBLE PRECISION,
    radius_km INTEGER DEFAULT 10,
    category_filter TEXT DEFAULT NULL,
    lang_filter TEXT DEFAULT NULL
)
RETURNS TABLE (
    id UUID,
    name JSONB,
    description JSONB,
    category TEXT,
    address JSONB,
    phone TEXT,
    working_hours JSONB,
    spoken_languages TEXT[],
    website TEXT,
    distance_km DOUBLE PRECISION,
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        s.id,
        s.name,
        s.description,
        s.category,
        s.address,
        s.phone,
        s.working_hours,
        s.spoken_languages,
        s.website,
        ROUND((ST_Distance(
            s.location::geography,
            ST_SetSRID(ST_MakePoint(lng, lat), 4326)::geography
        ) / 1000.0)::numeric, 2)::double precision AS distance_km,
        ST_Y(s.location::geometry) AS latitude,
        ST_X(s.location::geometry) AS longitude
    FROM services s
    WHERE s.is_active = true
      AND ST_DWithin(
          s.location::geography,
          ST_SetSRID(ST_MakePoint(lng, lat), 4326)::geography,
          radius_km * 1000
      )
      AND (category_filter IS NULL OR s.category = category_filter)
      AND (lang_filter IS NULL OR lang_filter = ANY(s.spoken_languages))
    ORDER BY distance_km;
END;
$$ LANGUAGE plpgsql;

-- Updated_at otomatik güncelleme trigger
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_profiles_updated_at BEFORE UPDATE ON profiles FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER update_services_updated_at BEFORE UPDATE ON services FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER update_articles_updated_at BEFORE UPDATE ON articles FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER update_forum_threads_updated_at BEFORE UPDATE ON forum_threads FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER update_forum_posts_updated_at BEFORE UPDATE ON forum_posts FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- ============================================
-- ROW LEVEL SECURITY (RLS)
-- ============================================
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE services ENABLE ROW LEVEL SECURITY;
ALTER TABLE articles ENABLE ROW LEVEL SECURITY;
ALTER TABLE forum_threads ENABLE ROW LEVEL SECURITY;
ALTER TABLE forum_posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE favorites ENABLE ROW LEVEL SECURITY;
ALTER TABLE reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE votes ENABLE ROW LEVEL SECURITY;

-- Profiles
CREATE POLICY "Profiles are viewable by everyone" ON profiles FOR SELECT USING (true);
CREATE POLICY "Users can insert their own profile" ON profiles FOR INSERT WITH CHECK (auth.uid() = id);
CREATE POLICY "Users can update own profile" ON profiles FOR UPDATE USING (auth.uid() = id);

-- Services
CREATE POLICY "Active services are viewable by everyone" ON services FOR SELECT USING (is_active = true);
CREATE POLICY "Authenticated users can insert services" ON services FOR INSERT WITH CHECK (auth.role() = 'authenticated');

-- Articles
CREATE POLICY "Published articles are viewable by everyone" ON articles FOR SELECT USING (is_published = true);

-- Forum Threads
CREATE POLICY "Threads are viewable by everyone" ON forum_threads FOR SELECT USING (true);
CREATE POLICY "Authenticated users can create threads" ON forum_threads FOR INSERT WITH CHECK (auth.uid() = author_id);
CREATE POLICY "Authors can update their threads" ON forum_threads FOR UPDATE USING (auth.uid() = author_id);
CREATE POLICY "Authors can delete their threads" ON forum_threads FOR DELETE USING (auth.uid() = author_id);

-- Forum Posts
CREATE POLICY "Posts are viewable by everyone" ON forum_posts FOR SELECT USING (true);
CREATE POLICY "Authenticated users can create posts" ON forum_posts FOR INSERT WITH CHECK (auth.uid() = author_id);
CREATE POLICY "Authors can update their posts" ON forum_posts FOR UPDATE USING (auth.uid() = author_id);
CREATE POLICY "Authors can delete their posts" ON forum_posts FOR DELETE USING (auth.uid() = author_id);

-- Favorites
CREATE POLICY "Users can view own favorites" ON favorites FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can manage own favorites" ON favorites FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can delete own favorites" ON favorites FOR DELETE USING (auth.uid() = user_id);

-- Reports
CREATE POLICY "Authenticated users can create reports" ON reports FOR INSERT WITH CHECK (auth.uid() = reporter_id);

-- Votes
CREATE POLICY "Users can view votes" ON votes FOR SELECT USING (true);
CREATE POLICY "Users can manage own votes" ON votes FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update own votes" ON votes FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can delete own votes" ON votes FOR DELETE USING (auth.uid() = user_id);

-- ============================================
-- SEED DATA (Örnek Veriler)
-- ============================================
INSERT INTO services (name, description, category, address, location, phone, working_hours, spoken_languages) VALUES
(
    '{"tr": "İstanbul Göçmen Sağlık Merkezi", "ar": "مركز صحة المهاجرين في إسطنبول", "en": "Istanbul Migrant Health Center"}'::jsonb,
    '{"tr": "Göçmenlere ücretsiz sağlık hizmetleri", "ar": "خدمات صحية مجانية للمهاجرين", "en": "Free health services for migrants"}'::jsonb,
    'health',
    '{"tr": "Fatih, İstanbul", "ar": "فاتح، إسطنبول", "en": "Fatih, Istanbul"}'::jsonb,
    ST_SetSRID(ST_MakePoint(28.9467, 41.0138), 4326),
    '+90 212 555 0001',
    '{"monday": {"open": "08:00", "close": "17:00"}, "tuesday": {"open": "08:00", "close": "17:00"}, "wednesday": {"open": "08:00", "close": "17:00"}, "thursday": {"open": "08:00", "close": "17:00"}, "friday": {"open": "08:00", "close": "17:00"}}'::jsonb,
    ARRAY['tr', 'ar', 'en']
),
(
    '{"tr": "Ankara Göçmen Eğitim Merkezi", "ar": "مركز تعليم المهاجرين في أنقرة", "en": "Ankara Migrant Education Center"}'::jsonb,
    '{"tr": "Dil kursları ve eğitim desteği", "ar": "دورات لغة ودعم تعليمي", "en": "Language courses and education support"}'::jsonb,
    'education',
    '{"tr": "Çankaya, Ankara", "ar": "تشانكايا، أنقرة", "en": "Çankaya, Ankara"}'::jsonb,
    ST_SetSRID(ST_MakePoint(32.8597, 39.9208), 4326),
    '+90 312 555 0002',
    '{"monday": {"open": "09:00", "close": "18:00"}, "tuesday": {"open": "09:00", "close": "18:00"}, "wednesday": {"open": "09:00", "close": "18:00"}, "thursday": {"open": "09:00", "close": "18:00"}, "friday": {"open": "09:00", "close": "18:00"}}'::jsonb,
    ARRAY['tr', 'ar', 'en', 'fa']
),
(
    '{"tr": "İzmir Hukuki Danışmanlık Merkezi", "ar": "مركز الاستشارات القانونية في إزمير", "en": "Izmir Legal Counseling Center"}'::jsonb,
    '{"tr": "Ücretsiz hukuki danışmanlık hizmetleri", "ar": "خدمات استشارات قانونية مجانية", "en": "Free legal counseling services"}'::jsonb,
    'legal',
    '{"tr": "Konak, İzmir", "ar": "كوناك، إزمير", "en": "Konak, Izmir"}'::jsonb,
    ST_SetSRID(ST_MakePoint(27.1428, 38.4192), 4326),
    '+90 232 555 0003',
    '{"monday": {"open": "09:00", "close": "17:00"}, "tuesday": {"open": "09:00", "close": "17:00"}, "wednesday": {"open": "09:00", "close": "17:00"}, "thursday": {"open": "09:00", "close": "17:00"}, "friday": {"open": "09:00", "close": "17:00"}}'::jsonb,
    ARRAY['tr', 'ar', 'en']
);

-- Örnek Makaleler
INSERT INTO articles (title, content, summary, category, slug, is_published) VALUES
(
    '{"tr": "Türkiye''de Oturma İzni Nasıl Alınır?", "ar": "كيفية الحصول على تصريح إقامة في تركيا؟", "en": "How to Get a Residence Permit in Turkey?"}'::jsonb,
    '{"tr": "Oturma izni başvurusu için gerekli belgeler ve adım adım rehber...", "ar": "المستندات المطلوبة والدليل خطوة بخطوة لطلب تصريح الإقامة...", "en": "Required documents and step-by-step guide for residence permit application..."}'::jsonb,
    '{"tr": "Oturma izni başvuru rehberi", "ar": "دليل طلب تصريح الإقامة", "en": "Residence permit application guide"}'::jsonb,
    'life_in_turkey',
    'oturma-izni-nasil-alinir',
    true
),
(
    '{"tr": "Okul Kaydı Nasıl Yapılır?", "ar": "كيفية التسجيل في المدرسة؟", "en": "How to Register for School?"}'::jsonb,
    '{"tr": "Çocuğunuzun okul kaydı için gerekli belgeler ve süreç...", "ar": "المستندات المطلوبة والعملية لتسجيل طفلك في المدرسة...", "en": "Required documents and process for enrolling your child in school..."}'::jsonb,
    '{"tr": "Okul kaydı rehberi", "ar": "دليل التسجيل المدرسي", "en": "School registration guide"}'::jsonb,
    'education_system',
    'okul-kaydi-nasil-yapilir',
    true
),
(
    '{"tr": "Sağlık Randevusu Alma Rehberi", "ar": "دليل حجز موعد صحي", "en": "Health Appointment Booking Guide"}'::jsonb,
    '{"tr": "MHRS ve ALO 182 üzerinden sağlık randevusu alma adımları...", "ar": "خطوات حجز موعد صحي عبر MHRS و ALO 182...", "en": "Steps to book a health appointment via MHRS and ALO 182..."}'::jsonb,
    '{"tr": "Sağlık randevusu rehberi", "ar": "دليل الموعد الصحي", "en": "Health appointment guide"}'::jsonb,
    'health_system',
    'saglik-randevusu-alma-rehberi',
    true
);