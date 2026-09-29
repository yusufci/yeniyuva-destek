import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // .env dosyasını yükle
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    debugPrint('⚠️ .env dosyası yüklenemedi: $e');
  }

  // Mapbox Access Token ayarla
  final mapboxToken = dotenv.env['MAPBOX_ACCESS_TOKEN'] ?? '';
  if (mapboxToken.isNotEmpty && mapboxToken != 'your-mapbox-access-token-here') {
    MapboxOptions.setAccessToken(mapboxToken);
    debugPrint('✅ Mapbox token ayarlandı');
  } else {
    debugPrint('⚠️ Mapbox token yapılandırılmamış. .env dosyasını kontrol edin.');
  }

  // Supabase başlat
  final supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
  final supabaseKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  if (supabaseUrl.isNotEmpty &&
      supabaseKey.isNotEmpty &&
      supabaseUrl.startsWith('https://')) {
    try {
      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseKey,
      );
      debugPrint('✅ Supabase bağlantısı başarılı');
    } catch (e) {
      debugPrint('⚠️ Supabase başlatılamadı: $e');
    }
  } else {
    debugPrint('⚠️ Supabase yapılandırılmamış. .env dosyasını kontrol edin.');
  }

  runApp(
    const ProviderScope(
      child: YeniYuvaApp(),
    ),
  );
}
