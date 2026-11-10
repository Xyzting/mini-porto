import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pertemuan_3/main.dart';

void main() {
  testWidgets('halaman memakai semua widget yang diwajibkan tugas', (
    tester,
  ) async {
    await tester.pumpWidget(const PortfolioApp());

    Finder diHalaman(Type jenis) => find.descendant(
      of: find.byType(HalamanProfil),
      matching: find.byType(jenis),
    );

    // Widget dasar
    expect(diHalaman(Text), findsWidgets);
    expect(diHalaman(Image), findsWidgets);
    expect(diHalaman(Icon), findsWidgets);
    // Widget layout
    expect(diHalaman(Row), findsWidgets);
    expect(diHalaman(Column), findsWidgets);
    // Styling
    expect(diHalaman(Container), findsWidgets);
    // Informasi: ListTile di dalam Card
    expect(
      find.descendant(of: diHalaman(Card), matching: find.byType(ListTile)),
      findsWidgets,
    );
  });

  testWidgets('font kustom di tema terdaftar di pubspec.yaml', (tester) async {
    await tester.pumpWidget(const PortfolioApp());
    final tema = Theme.of(tester.element(find.byType(HalamanProfil)));

    final manifest =
        jsonDecode(await rootBundle.loadString('FontManifest.json')) as List;
    final fontTerdaftar = manifest.map((font) => (font as Map)['family']);

    expect(fontTerdaftar, contains(tema.textTheme.bodyLarge?.fontFamily));
  });

  testWidgets('foto profil di kartu adalah aset yang ikut ter-bundle', (
    tester,
  ) async {
    await tester.pumpWidget(const PortfolioApp());
    final foto = tester.widget<Image>(
      find.descendant(
        of: find.byType(KartuMahasiswa),
        matching: find.byType(Image),
      ),
    );

    final data = await rootBundle.load((foto.image as AssetImage).assetName);

    expect(data.lengthInBytes, greaterThan(0));
  });

  testWidgets('nama panjang tetap utuh tanpa overflow di HP kecil, teks 200%', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    const namaPanjang = 'Muhammad Rizky Ananda Pratama Putra Wijayakusuma';
    await tester.pumpWidget(
      MaterialApp(
        theme: buatTema(),
        home: const HalamanProfil(
          profil: Profil(
            nama: namaPanjang,
            nim: '10120001234567',
            prodi: 'Teknik Informatika dan Sistem Cerdas',
            kampus: 'Universitas Teknologi Bandung',
            foto: 'assets/images/foto.png',
            bio: 'Bio singkat untuk menguji tata letak.',
            keahlian: [
              Keahlian('Flutter', Icons.flutter_dash),
              Keahlian('Dart', Icons.code_rounded),
              Keahlian('Git', Icons.commit_rounded),
            ],
            info: [
              InfoItem(
                ikon: Icons.location_on_outlined,
                isi: 'Kabupaten Bandung Barat, Jawa Barat, Indonesia',
                label: 'Domisili',
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Overflow (mis. "A RenderFlex overflowed") tertangkap di sini.
    expect(tester.takeException(), isNull);
    final nama = tester.renderObject<RenderParagraph>(find.text(namaPanjang));
    expect(nama.didExceedMaxLines, isFalse);
  });

  testWidgets('foto di kartu tampil utuh, tidak terpotong', (tester) async {
    final aset = AssetImage(profilSaya.foto);
    final foto = find.descendant(
      of: find.byType(KartuMahasiswa),
      matching: find.byWidgetPredicate((w) => w is Image && w.image == aset),
    );

    // Muat gambar sungguhan supaya ukuran aslinya diketahui.
    await tester.runAsync(() async {
      await tester.pumpWidget(const PortfolioApp());
      await precacheImage(aset, tester.element(foto));
    });
    await tester.pump();

    final render = tester.renderObject<RenderImage>(
      find.descendant(of: foto, matching: find.byType(RawImage)),
    );
    final ukuranAsli = Size(
      render.image!.width / render.scale,
      render.image!.height / render.scale,
    );
    final hasil = applyBoxFit(
      render.fit ?? BoxFit.scaleDown,
      ukuranAsli,
      render.size,
    );

    // Bagian yang digambar harus seluruh gambar, bukan potongannya.
    expect(hasil.source.width, closeTo(ukuranAsli.width, 0.01));
    expect(hasil.source.height, closeTo(ukuranAsli.height, 0.01));
  });

  testWidgets('kartu berayun saat halaman muncul lalu berhenti tegak', (
    tester,
  ) async {
    await tester.pumpWidget(const PortfolioApp());
    expect(rotasiKartu(tester).isIdentity(), isFalse);

    await tester.pumpAndSettle();
    expect(rotasiKartu(tester).isIdentity(), isTrue);
  });

  testWidgets('kartu tidak berayun kalau animasi dimatikan di pengaturan HP', (
    tester,
  ) async {
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);

    await tester.pumpWidget(const PortfolioApp());

    expect(rotasiKartu(tester).isIdentity(), isTrue);
  });
}

/// Transformasi (rotasi) terluar yang membungkus kartu mahasiswa.
Matrix4 rotasiKartu(WidgetTester tester) {
  final transform = tester.widget<Transform>(
    find
        .descendant(
          of: find.byType(KartuMahasiswa),
          matching: find.byType(Transform),
        )
        .first,
  );
  return transform.transform;
}
