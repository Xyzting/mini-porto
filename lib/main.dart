import 'dart:math' as math;

import 'package:flutter/material.dart';

void main() {
  runApp(const PortfolioApp());
}

const profilSaya = Profil(
  nama: 'Reyhan',
  nim: '24552011032',
  prodi: 'Teknik Informatika',
  kampus: 'Universitas Teknologi Bandung',
  foto: 'assets/images/foto.png',
  bio:
      'Saya adalah manusia biasa yang sedang mencari uang. '
      'Halaman ini adalah tugas Pertemuan 5, yang akan membuat saya mendapatkan nilai dan menjadi sarjana. ',
  keahlian: [
    Keahlian('Flutter', Icons.flutter_dash),
    Keahlian('Dart', Icons.code_rounded),
    Keahlian('Git', Icons.commit_rounded),
  ],
  info: [
    InfoItem(
      ikon: Icons.menu_book_outlined,
      isi: 'Pemrograman Mobile II',
      label: 'Mata kuliah',
    ),
    InfoItem(
      ikon: Icons.link_rounded,
      isi: 'github.com/Xyzting',
      label: 'GitHub',
    ),
    InfoItem(
      ikon: Icons.location_on_outlined,
      isi: 'Bandung, Jawa Barat',
      label: 'Domisili',
    ),
  ],
);

class Profil {
  const Profil({
    required this.nama,
    required this.nim,
    required this.prodi,
    required this.kampus,
    required this.foto,
    required this.bio,
    required this.keahlian,
    required this.info,
  });

  final String nama;
  final String nim;
  final String prodi;
  final String kampus;
  final String foto;
  final String bio;
  final List<Keahlian> keahlian;
  final List<InfoItem> info;
}

class Keahlian {
  const Keahlian(this.label, this.ikon);

  final String label;
  final IconData ikon;
}

class InfoItem {
  const InfoItem({required this.ikon, required this.isi, required this.label});

  final IconData ikon;
  final String isi;
  final String label;
}

class Warna {
  static const pinus = Color(0xFF16302A); // warna utama, teks
  static const tosca = Color(0xFF2A7466); // ikon di latar terang
  static const kawah = Color(0xFF8FD3C3); // aksen di latar gelap
  static const kawahMuda = Color(0xFFD3ECE4); // latar kotak keahlian
  static const belerang = Color(0xFFE6CF5C); // aksen kuning
  static const kabut = Color(0xFFEFF4F1); // latar halaman
  static const batu = Color(0xFF5A6A64); // teks pendukung
  static const garis = Color(0x1A16302A); // garis tipis (pinus 10%)
}

const fontUtama = 'PlusJakartaSans';

ThemeData buatTema() {
  final teks =
      const TextTheme(
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          height: 1.15,
          letterSpacing: -0.4,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          height: 1.3,
          letterSpacing: 0,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          height: 1.35,
          letterSpacing: 0,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 1.6,
          letterSpacing: 0,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.5,
          letterSpacing: 0,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          height: 1.3,
          letterSpacing: 0.2,
        ),
      ).apply(
        fontFamily: fontUtama,
        bodyColor: Warna.pinus,
        displayColor: Warna.pinus,
      );

  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Warna.pinus,
      primary: Warna.pinus,
      onPrimary: Warna.kabut,
      secondary: Warna.tosca,
      tertiary: Warna.belerang,
      surface: Warna.kabut,
      onSurface: Warna.pinus,
      onSurfaceVariant: Warna.batu,
    ),
    scaffoldBackgroundColor: Warna.kabut,
    fontFamily: fontUtama,
    textTheme: teks,
    iconTheme: const IconThemeData(color: Warna.tosca),
    appBarTheme: AppBarThemeData(
      backgroundColor: Warna.kabut,
      foregroundColor: Warna.pinus,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: teks.titleLarge,
    ),
    cardTheme: const CardThemeData(
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        side: BorderSide(color: Warna.garis),
      ),
    ),
    listTileTheme: ListTileThemeData(
      iconColor: Warna.tosca,
      titleTextStyle: teks.titleMedium,
      subtitleTextStyle: teks.bodyMedium?.copyWith(color: Warna.batu),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
    ),
  );
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pertemuan 5',
      debugShowCheckedModeBanner: false,
      theme: buatTema(),
      home: const HalamanProfil(profil: profilSaya),
    );
  }
}

class HalamanProfil extends StatelessWidget {
  const HalamanProfil({super.key, required this.profil});

  final Profil profil;

  @override
  Widget build(BuildContext context) {
    final teks = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  KartuMahasiswa(profil: profil),

                  const JudulBagian('Tentang saya'),
                  Text(profil.bio, style: teks.bodyLarge),

                  const JudulBagian('Sedang dipelajari'),
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: 12,
                      children: [
                        for (final keahlian in profil.keahlian)
                          Expanded(child: KotakKeahlian(keahlian: keahlian)),
                      ],
                    ),
                  ),

                  const JudulBagian('Info'),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        children: [
                          for (final item in profil.info)
                            ListTile(
                              leading: Icon(item.ikon),
                              title: Text(item.isi),
                              subtitle: Text(item.label),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class KartuMahasiswa extends StatelessWidget {
  const KartuMahasiswa({super.key, required this.profil});

  final Profil profil;

  @override
  Widget build(BuildContext context) {
    final teks = Theme.of(context).textTheme;

    final kartu = Card(
      color: Warna.pinus,
      elevation: 8,
      shadowColor: Warna.pinus,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(24)),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Lubang tali kartu.
              Center(
                child: Container(
                  width: 44,
                  height: 7,
                  margin: const EdgeInsets.only(top: 14),
                  decoration: BoxDecoration(
                    color: Warna.kabut,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        profil.foto,
                        fit: BoxFit.fitWidth,
                        semanticLabel: 'Foto ${profil.nama}',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      spacing: 16,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                profil.nama,
                                style: teks.headlineSmall?.copyWith(
                                  color: Warna.kabut,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                profil.prodi,
                                style: teks.bodyMedium?.copyWith(
                                  color: Warna.kawah,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'NIM',
                                style: teks.labelMedium?.copyWith(
                                  color: Warna.kabut.withValues(alpha: 0.6),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                profil.nim,
                                textAlign: TextAlign.end,
                                style: teks.titleMedium?.copyWith(
                                  color: Warna.kabut,
                                  fontFeatures: const [
                                    FontFeature.tabularFigures(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Container(
                color: Warna.belerang,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.school_outlined,
                      size: 20,
                      color: Warna.pinus,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        profil.kampus,
                        style: teks.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );

    final bolehBerayun = !MediaQuery.disableAnimationsOf(context);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: bolehBerayun ? 0.05 : 0, end: 0),
      duration: const Duration(milliseconds: 2000),
      curve: const _KurvaAyunan(),
      builder: (context, sudut, child) => Transform.rotate(
        angle: sudut,
        alignment: Alignment.topCenter,
        child: child,
      ),
      child: kartu,
    );
  }
}

class _KurvaAyunan extends Curve {
  const _KurvaAyunan();

  @override
  double transformInternal(double t) =>
      1 - math.exp(-5 * t) * math.cos(3 * 2 * math.pi * t);
}

class JudulBagian extends StatelessWidget {
  const JudulBagian(this.judul, {super.key});

  final String judul;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 32, bottom: 12),
      child: Semantics(
        header: true,
        child: Text(judul, style: Theme.of(context).textTheme.titleLarge),
      ),
    );
  }
}

class KotakKeahlian extends StatelessWidget {
  const KotakKeahlian({super.key, required this.keahlian});

  final Keahlian keahlian;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Warna.kawahMuda,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(keahlian.ikon),
          const SizedBox(height: 12),
          Text(keahlian.label, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}
