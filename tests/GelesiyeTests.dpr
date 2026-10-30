program GelesiyeTests;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Classes,
  System.IOUtils,
  System.Generics.Collections,
  Vcl.Graphics,
  uGelesiyeConsts in '..\src\Common\uGelesiyeConsts.pas',
  uGelesiyeTypes in '..\src\Common\uGelesiyeTypes.pas',
  uGelesiyeVersion in '..\src\Common\uGelesiyeVersion.pas',
  uGelesiyeTheme in '..\src\Common\uGelesiyeTheme.pas',
  uGelesiyeLang in '..\src\Common\uGelesiyeLang.pas',
  uGelesiyeInterfaces in '..\src\Domain\uGelesiyeInterfaces.pas',
  uGelesiyeEntities in '..\src\Domain\uGelesiyeEntities.pas',
  uDbSQLite in '..\src\Data\uDbSQLite.pas',
  uDbIlIlceSeed in '..\src\Data\uDbIlIlceSeed.pas',
  uDbFactory in '..\src\Data\uDbFactory.pas',
  uBaseViewModel in '..\src\ViewModels\uBaseViewModel.pas',
  uCariListViewModel in '..\src\ViewModels\uCariListViewModel.pas',
  uCariDetailViewModel in '..\src\ViewModels\uCariDetailViewModel.pas',
  uHareketViewModel in '..\src\ViewModels\uHareketViewModel.pas',
  uFirmaViewModel in '..\src\ViewModels\uFirmaViewModel.pas',
  uAyarlarViewModel in '..\src\ViewModels\uAyarlarViewModel.pas',
  uBackupService in '..\src\Services\uBackupService.pas',
  uDovizKuruService in '..\src\Services\uDovizKuruService.pas';

var
  GPassCount: Integer = 0;

procedure AssertEqual(const AExpected, AActual: Currency; const ATestName: string);
begin
  if Abs(AExpected - AActual) > 0.001 then
  begin
    Writeln(Format('[FAIL] %s: Beklenen=%.2f, Gerceklesen=%.2f', [ATestName, AExpected, AActual]));
    Halt(1);
  end
  else
  begin
    Inc(GPassCount);
    Writeln(Format('[PASS] %s: %.2f == %.2f', [ATestName, AExpected, AActual]));
  end;
end;

procedure AssertEqualInt(const AExpected, AActual: Integer; const ATestName: string);
begin
  if AExpected <> AActual then
  begin
    Writeln(Format('[FAIL] %s: Beklenen=%d, Gerceklesen=%d', [ATestName, AExpected, AActual]));
    Halt(1);
  end
  else
  begin
    Inc(GPassCount);
    Writeln(Format('[PASS] %s: %d == %d', [ATestName, AExpected, AActual]));
  end;
end;

procedure AssertEqualStr(const AExpected, AActual: string; const ATestName: string);
begin
  if AExpected <> AActual then
  begin
    Writeln(Format('[FAIL] %s: Beklenen="%s", Gerceklesen="%s"', [ATestName, AExpected, AActual]));
    Halt(1);
  end
  else
  begin
    Inc(GPassCount);
    Writeln(Format('[PASS] %s: "%s" == "%s"', [ATestName, AExpected, AActual]));
  end;
end;

procedure AssertTrue(const ACondition: Boolean; const ATestName: string);
begin
  if not ACondition then
  begin
    Writeln('[FAIL] ' + ATestName);
    Halt(1);
  end
  else
  begin
    Inc(GPassCount);
    Writeln('[PASS] ' + ATestName);
  end;
end;

procedure RunAllTests;
var
  DbPath, AppDir: string;
  FirmaRepo: IFirmaRepository;
  CariRepo: ICariRepository;
  HareketRepo: IHareketRepository;
  AyarlarRepo: IAyarlarRepository;
  F, FCheck: IFirma;
  C, CRef, CUpdated, CSearch1, CSearch2, CSearch3, CSearch4: ICari;
  CAlacakli, CLimit, CPasif, CDeleteTest, CDeleted, TransferredCari, CariItem: ICari;
  LastHrk: IHareket;
  HVM: THareketViewModel;
  CListVM: TCariListViewModel;
  FVM: TFirmaViewModel;
  DetailVM: TCariDetailViewModel;
  AyarVM: TAyarlarViewModel;
  Ozet: TBakiyeOzet;
  NewFirma: IFirma;
  BackupPath, BackupErr, Err, AppTitle, SbVer, DataDir, MainDbCopy, NextKod, KurStr: string;
  SearchResultList, ListBorclular, ListAlacaklilar, ListSifir, ListLimit, ListPasif: TList<ICari>;
  AciklamaList: TList<string>;
  IlRepo: IIlIlceRepository;
  Iller, IlcelerAdana, IlcelerAnkara: TList<string>;
  Filtre: TCariFiltre;
  KurRes: TDovizKurlari;
  I, TurIdx, DelId, DelTestId: Integer;
begin
  Writeln('============================================================');
  Writeln('GELESIYE COMPREHENSIVE INTEGRATION & DOMAIN TEST SUITE');
  Writeln('============================================================');

  AppDir := ExtractFilePath(ParamStr(0));
  DbPath := AppDir + 'test_gelesiye_full.db';
  if FileExists(DbPath) then
    DeleteFile(DbPath);

  TDbFactory.Initialize(dpSQLite, DbPath);
  FirmaRepo := TDbFactory.GetFirmaRepository;
  CariRepo := TDbFactory.GetCariRepository;
  HareketRepo := TDbFactory.GetHareketRepository;
  AyarlarRepo := TDbFactory.GetAyarlarRepository;

  // --------------------------------------------------------------------------
  // BÖLÜM 1: Firma Yönetimi & Varsayılan Değerler
  // --------------------------------------------------------------------------
  Writeln(sLineBreak + '--- 1. Firma Testleri ---');
  F := FirmaRepo.GetDefault;
  AssertTrue(F <> nil, 'Varsayilan firma otomatik olusturuldu mu?');
  AssertTrue(Pos('TEST', F.Unvan) > 0, 'Varsayilan firma unvani dogru mu?');
  AssertEqualInt(2026, F.Donem, 'Varsayilan firma donemi 2026 mi?');
  AssertEqualStr('TL', F.ParaBirimi, 'Varsayilan firma para birimi TL mi?');

  // Firma güncelleme
  F.Telefon := '0212 555 11 22';
  F.VergiDairesi := 'Mecidiyeköy';
  FirmaRepo.Update(F);
  FCheck := FirmaRepo.GetById(F.Id);
  AssertEqualStr('0212 555 11 22', FCheck.Telefon, 'Firma telefon guncellemesi basarili mi?');
  AssertEqualStr('Mecidiyeköy', FCheck.VergiDairesi, 'Firma vergi dairesi guncellemesi basarili mi?');

  // --------------------------------------------------------------------------
  // BÖLÜM 2: Cari Kart CRUD & Kod Üretimi
  // --------------------------------------------------------------------------
  Writeln(sLineBreak + '--- 2. Cari CRUD Testleri ---');
  NextKod := CariRepo.GetNextCariKodu(F.Id);
  AssertEqualStr('00001', NextKod, 'Ilk cari kodu 00001 olarak uretildi mi?');

  C := TCari.Create;
  C.FirmaId := F.Id;
  C.CariKodu := NextKod;
  C.Unvan := 'Örnek Müşteri Ltd.';
  C.Yetkili := 'Ahmet Yılmaz';
  C.Telefon := '0216 444 00 11';
  C.Gsm := '0532 111 22 33';
  C.Il := 'İstanbul';
  C.Ilce := 'Kadıköy';
  C.CariLimit := 15000.0;
  C.HesapDurumu := hdAktif;
  C.Notlar := 'Önemli kurumsal müşteri';
  C.KayitTarihi := Date;
  C.Id := CariRepo.Insert(C);
  AssertTrue(C.Id > 0, 'Cari kart basariyla eklendi mi?');

  // GetById doğrulama
  CRef := CariRepo.GetById(C.Id);
  AssertTrue(CRef <> nil, 'Eklenen cari GetById ile okundu mu?');
  AssertEqualStr('Örnek Müşteri Ltd.', CRef.Unvan, 'Cari unvani eslesiyor mu?');
  AssertEqualStr('Ahmet Yılmaz', CRef.Yetkili, 'Cari yetkilisi eslesiyor mu?');
  AssertEqual(15000.00, CRef.CariLimit, 'Cari limit degeri dogru mu?');

  // Cari Güncelleme
  CRef.Unvan := 'Örnek Müşteri A.Ş.';
  CRef.CariLimit := 20000.0;
  CariRepo.Update(CRef);
  CUpdated := CariRepo.GetById(C.Id);
  AssertEqualStr('Örnek Müşteri A.Ş.', CUpdated.Unvan, 'Cari unvan guncellemesi basarili mi?');
  AssertEqual(20000.00, CUpdated.CariLimit, 'Cari limit guncellemesi basarili mi?');

  // Detail ViewModel testi
  DetailVM := TCariDetailViewModel.Create(CariRepo);
  try
    DetailVM.MevcutCariYukle(C.Id);
    AssertEqualStr('Örnek Müşteri A.Ş.', DetailVM.Cari.Unvan, 'DetailVM carisi unvani dogru mu?');
    AssertEqual(20000.00, DetailVM.Cari.CariLimit, 'DetailVM cari limiti dogru mu?');
  finally
    DetailVM.Free;
  end;

  // --------------------------------------------------------------------------
  // BÖLÜM 3: Fiş / Hareket Türleri & Yürüyen Bakiye & Hareket Silme
  // --------------------------------------------------------------------------
  Writeln(sLineBreak + '--- 3. Hareket & Bakiye Testleri ---');
  HVM := THareketViewModel.Create(HareketRepo, CariRepo);
  try
    HVM.CariYukle(C.Id);

    // 1. Borç Dekontu: 1000 TL (Bakiye: 1000 TL)
    HVM.BorcEkle(1000.0, 'Fatura No: 101', Now);
    // 2. Tahsilat: 100 TL (Bakiye: 900 TL)
    HVM.TahsilatYap(100.0, 'Kasa Tahsilat', Now);
    // 3. Alacak Dekontu: 10 TL (Bakiye: 890 TL)
    HVM.AlacakEkle(10.0, 'İade Fişi', Now);
    // 4. Ödeme: 20 TL (Bakiye: 910 TL)
    HVM.OdemeYap(20.0, 'Fazla Ödeme İadesi', Now);

    AssertEqual(1020.00, HVM.ToplamBorc, 'Toplam Borc Dogrulamasi (1000 + 20)');
    AssertEqual(110.00, HVM.ToplamAlacak, 'Toplam Alacak Dogrulamasi (100 + 10)');
    AssertEqual(910.00, HVM.NetBakiye, 'Net Bakiye Dogrulamasi (910 TL)');
    AssertEqualInt(4, HVM.KayitSayisi, 'Hareket kayit sayisi 4 mu?');

    // Hareket silme testi: Son hareketi sil
    LastHrk := HVM.Hareketler[HVM.Hareketler.Count - 1];
    DelId := LastHrk.Id;
    HVM.HareketSil(DelId);
    AssertEqualInt(3, HVM.KayitSayisi, 'Hareket silindikten sonra kayit sayisi 3 oldu mu?');
    AssertEqual(1000.00, HVM.ToplamBorc, 'Hareket silinince Toplam Borc 1000 TL oldu mu?');
    AssertEqual(890.00, HVM.NetBakiye, 'Hareket silinince Net Bakiye 890 TL oldu mu?');

    // Silinen hareketi geri yerine ekle (910 TL bakiye dengesi için)
    HVM.OdemeYap(20.0, 'Fazla Ödeme İadesi', Now);
    AssertEqual(910.00, HVM.NetBakiye, 'Odeme tekrar eklenince Net Bakiye 910 TL oldu mu?');
  finally
    HVM.Free;
  end;

  // --------------------------------------------------------------------------
  // BÖLÜM 4: Akıllı Arama & Öncelikli Sıralama (Exact > StartsWith > Contains)
  // --------------------------------------------------------------------------
  Writeln(sLineBreak + '--- 4. Arama & Öncelik Sıralaması Testi ---');
  // 4 özel cari ekle:
  // 1. "KAYA" (Tam eşleşme)
  // 2. "KAYA TİCARET" (Başlayan)
  // 3. "AKIN KAYA" (İçeren)
  // 4. "KAYALAR GIDA" (Başlayan)
  CSearch1 := TCari.Create;
  CSearch1.FirmaId := F.Id; CSearch1.CariKodu := '00010'; CSearch1.Unvan := 'KAYA';
  CSearch1.HesapDurumu := hdAktif; CSearch1.KayitTarihi := Date;
  CariRepo.Insert(CSearch1);

  CSearch2 := TCari.Create;
  CSearch2.FirmaId := F.Id; CSearch2.CariKodu := '00011'; CSearch2.Unvan := 'KAYA TİCARET';
  CSearch2.HesapDurumu := hdAktif; CSearch2.KayitTarihi := Date;
  CariRepo.Insert(CSearch2);

  CSearch3 := TCari.Create;
  CSearch3.FirmaId := F.Id; CSearch3.CariKodu := '00012'; CSearch3.Unvan := 'AKIN KAYA';
  CSearch3.HesapDurumu := hdAktif; CSearch3.KayitTarihi := Date;
  CariRepo.Insert(CSearch3);

  CSearch4 := TCari.Create;
  CSearch4.FirmaId := F.Id; CSearch4.CariKodu := '00013'; CSearch4.Unvan := 'KAYALAR GIDA';
  CSearch4.HesapDurumu := hdAktif; CSearch4.KayitTarihi := Date;
  CariRepo.Insert(CSearch4);

  // Arama testi: "KAYA" sorgusu
  Filtre.FirmaId := F.Id;
  Filtre.AramaMetni := 'KAYA';
  Filtre.SorguTuru := stUnvan;
  Filtre.AramaModu := amIceren;
  Filtre.HesapDurumu := hdAktif;
  Filtre.BakiyeFiltresi := bfTumu;

  SearchResultList := CariRepo.GetAll(Filtre);
  try
    AssertTrue(SearchResultList.Count >= 4, 'KAYA sorgusunda en az 4 sonuc bulundu mu?');
    // 1. Sırada TAM EŞLEŞME: "KAYA" olmalı
    AssertEqualStr('KAYA', SearchResultList[0].Unvan, 'Arama 1. sira TAM ESLESME ("KAYA") mi?');
    // 2. ve 3. Sırada BAŞLAYANLAR: "KAYA TİCARET" ve "KAYALAR GIDA"
    AssertTrue(Pos('KAYA', SearchResultList[1].Unvan) = 1, 'Arama 2. sira KAYA ile basliyor mu?');
    AssertTrue(Pos('KAYA', SearchResultList[2].Unvan) = 1, 'Arama 3. sira KAYA ile basliyor mu?');
    // Son sırada İÇERENLER: "AKIN KAYA"
    AssertEqualStr('AKIN KAYA', SearchResultList[SearchResultList.Count - 1].Unvan,
      'Arama son sira ICEREN ("AKIN KAYA") mi?');
  finally
    SearchResultList.Free;
  end;

  // --------------------------------------------------------------------------
  // BÖLÜM 5: Filtre Testleri (Borçlular, Alacaklılar, Sıfır, Limit Aşan)
  // --------------------------------------------------------------------------
  Writeln(sLineBreak + '--- 5. Bakiye & Durum Filtre Testleri ---');
  // Alacaklı cari oluştur (Bize borcu yok, biz ona borçluyuz: Alacak Dekontu ekle)
  CAlacakli := TCari.Create;
  CAlacakli.FirmaId := F.Id; CAlacakli.CariKodu := '00020'; CAlacakli.Unvan := 'Alacaklı Tedarikçi';
  CAlacakli.HesapDurumu := hdAktif; CAlacakli.KayitTarihi := Date; CAlacakli.CariLimit := 5000;
  CAlacakli.Id := CariRepo.Insert(CAlacakli);

  HVM := THareketViewModel.Create(HareketRepo, CariRepo);
  try
    HVM.CariYukle(CAlacakli.Id);
    HVM.AlacakEkle(500.0, 'Mal Alımı Faturası', Now);
    AssertEqual(-500.00, HVM.NetBakiye, 'Alacakli cari bakiyesi -500 TL mi?');
  finally
    HVM.Free;
  end;

  // Limit aşan cari oluştur (Limit: 500 TL, Borç: 1500 TL)
  CLimit := TCari.Create;
  CLimit.FirmaId := F.Id; CLimit.CariKodu := '00030'; CLimit.Unvan := 'Riskli Müşteri';
  CLimit.HesapDurumu := hdAktif; CLimit.KayitTarihi := Date; CLimit.CariLimit := 500.0;
  CLimit.Id := CariRepo.Insert(CLimit);

  HVM := THareketViewModel.Create(HareketRepo, CariRepo);
  try
    HVM.CariYukle(CLimit.Id);
    HVM.BorcEkle(1500.0, 'Yüksek Tutar Fatura', Now);
  finally
    HVM.Free;
  end;

  // Test: Borçlular Filtresi
  Filtre.AramaMetni := '';
  Filtre.BakiyeFiltresi := bfBorclular;
  ListBorclular := CariRepo.GetAll(Filtre);
  try
    AssertTrue(ListBorclular.Count >= 2, 'Borclular filtresi en az 2 kayit getirdi mi?');
    for I := 0 to ListBorclular.Count - 1 do
    begin
      CariItem := ListBorclular[I];
      AssertTrue(CariItem.Bakiye > 0.001, 'Borclular listesindeki cari bakiyesi pozitif mi?');
    end;
  finally
    ListBorclular.Free;
  end;

  // Test: Alacaklılar Filtresi
  Filtre.BakiyeFiltresi := bfAlacaklilar;
  ListAlacaklilar := CariRepo.GetAll(Filtre);
  try
    AssertTrue(ListAlacaklilar.Count >= 1, 'Alacaklilar filtresi en az 1 kayit getirdi mi?');
    for I := 0 to ListAlacaklilar.Count - 1 do
    begin
      CariItem := ListAlacaklilar[I];
      AssertTrue(CariItem.Bakiye < -0.001, 'Alacaklilar listesindeki cari bakiyesi negatif mi?');
    end;
  finally
    ListAlacaklilar.Free;
  end;

  // Test: Sıfır Bakiye Filtresi
  Filtre.BakiyeFiltresi := bfSifirBakiye;
  ListSifir := CariRepo.GetAll(Filtre);
  try
    AssertTrue(ListSifir.Count >= 1, 'Sifir bakiye filtresi kayit getirdi mi?');
    for I := 0 to ListSifir.Count - 1 do
    begin
      CariItem := ListSifir[I];
      AssertTrue(Abs(CariItem.Bakiye) <= 0.001, 'Sifir bakiyeli cari bakiyesi gercekten 0 mi?');
    end;
  finally
    ListSifir.Free;
  end;

  // Test: Limit Aşanlar Filtresi
  Filtre.BakiyeFiltresi := bfLimitAsanlar;
  ListLimit := CariRepo.GetAll(Filtre);
  try
    AssertTrue(ListLimit.Count >= 1, 'Limit asanlar filtresi riskli cariyi buldu mu?');
    AssertEqualStr('Riskli Müşteri', ListLimit[0].Unvan, 'Limit asan cari dogru mu?');
  finally
    ListLimit.Free;
  end;

  // Pasif cari testi
  CPasif := TCari.Create;
  CPasif.FirmaId := F.Id; CPasif.CariKodu := '00040'; CPasif.Unvan := 'Eski Pasif Cari';
  CPasif.HesapDurumu := hdPasif; CPasif.KayitTarihi := Date; CPasif.CariLimit := 1000;
  CPasif.Id := CariRepo.Insert(CPasif);

  Filtre.BakiyeFiltresi := bfTumu;
  Filtre.HesapDurumu := hdPasif;
  ListPasif := CariRepo.GetAll(Filtre);
  try
    AssertTrue(ListPasif.Count >= 1, 'Pasif cariler filtresi basarili mi?');
    AssertEqualStr('Eski Pasif Cari', ListPasif[0].Unvan, 'Pasif cari unvani dogru mu?');
  finally
    ListPasif.Free;
  end;

  // Bakiye Özet Testi
  Ozet := CariRepo.GetBakiyeOzet(F.Id);
  AssertTrue(Ozet.BorcluCariSayisi >= 1, 'Bakiye ozetinde borclu cari sayisi dogru mu?');
  AssertTrue(Ozet.GenelBorcluToplam > 0.001, 'Bakiye ozetinde genel borclu toplami pozitif mi?');
  AssertTrue(Ozet.AlacakliCariSayisi >= 1, 'Bakiye ozetinde alacakli cari sayisi dogru mu?');

  // --------------------------------------------------------------------------
  // BÖLÜM 6: Cari Silme (Soft Delete) Testi
  // --------------------------------------------------------------------------
  Writeln(sLineBreak + '--- 6. Soft Delete Testi ---');
  CDeleteTest := TCari.Create;
  CDeleteTest.FirmaId := F.Id; CDeleteTest.CariKodu := '00099'; CDeleteTest.Unvan := 'Silinecek Cari';
  CDeleteTest.HesapDurumu := hdAktif; CDeleteTest.KayitTarihi := Date;
  DelTestId := CariRepo.Insert(CDeleteTest);
  AssertTrue(DelTestId > 0, 'Silinecek cari basariyla olusturuldu mu?');

  CariRepo.Delete(DelTestId);
  CDeleted := CariRepo.GetById(DelTestId);
  AssertTrue(CDeleted = nil, 'Silinen cari GetById ile bulunamadi mi (soft delete)?');

  // --------------------------------------------------------------------------
  // BÖLÜM 7: Yıl Sonu Devir İşlemi (2026 -> 2027)
  // --------------------------------------------------------------------------
  Writeln(sLineBreak + '--- 7. Yıl Sonu Devir Testleri ---');
  FVM := TFirmaViewModel.Create(FirmaRepo);
  try
    NewFirma := TFirma.Create;
    NewFirma.Kod := 'Frm2027';
    NewFirma.Unvan := '2027 - TEST DÖNEMİ';
    NewFirma.Donem := 2027;
    NewFirma.ParaBirimi := 'TL';
    FVM.FirmaKaydet(NewFirma, True);

    AssertTrue(FVM.DevirYap(F.Id, NewFirma.Id, True), 'Yil sonu devir basarili mi?');

    // Yeni firmada devir bakiyelerini kontrol et
    CListVM := TCariListViewModel.Create(CariRepo);
    HVM := THareketViewModel.Create(HareketRepo, CariRepo);
    try
      CListVM.Yenile(NewFirma.Id);
      AssertTrue(CListVM.KayitSayisi >= 1, 'Yeni doneme cariler aktarildi mi?');

      // İlk carinin (Örnek Müşteri A.Ş. - 910 TL) devir hareketini doğrula
      TransferredCari := nil;
      for I := 0 to CListVM.Cariler.Count - 1 do
      begin
        CariItem := CListVM.Cariler[I];
        if CariItem.Unvan = 'Örnek Müşteri A.Ş.' then
          TransferredCari := CariItem;
      end;

      AssertTrue(TransferredCari <> nil, 'Ornek Musteri yeni doneme aktarildi mi?');
      if TransferredCari <> nil then
      begin
        HVM.CariYukle(TransferredCari.Id);
        AssertEqual(910.00, HVM.NetBakiye, 'Yeni donem devir bakiyesi 910 TL mi?');
        AssertEqualInt(1, HVM.KayitSayisi, 'Devir fisi 1 adet mi?');
        AssertTrue(HVM.Hareketler[0].IslemTuru = itDevir, 'Hareket turu itDevir mi?');
      end;
    finally
      HVM.Free;
      CListVM.Free;
    end;
  finally
    FVM.Free;
  end;

  // --------------------------------------------------------------------------
  // BÖLÜM 8: Ayarlar ve Açıklama Şablonları Testi
  // --------------------------------------------------------------------------
  Writeln(sLineBreak + '--- 8. Ayarlar & Açıklama Şablonları Testi ---');
  AssertTrue(AyarlarRepo <> nil, 'Ayarlar repository mevcut mu?');
  AssertTrue(AyarlarRepo.GetAyar('ParaBirimi', 'TL') = 'TL', 'Varsayilan ParaBirimi dogru mu?');

  AyarlarRepo.SetAyar('TestParam', 'Gelesiye2026');
  AssertEqualStr('Gelesiye2026', AyarlarRepo.GetAyar('TestParam'), 'Ayar yazma ve okuma basarili mi?');

  // Fiş türü 1 (Borç), 2 (Tahsilat), 3 (Alacak), 4 (Ödeme) şablonları
  for TurIdx := 1 to 4 do
  begin
    AciklamaList := AyarlarRepo.GetAciklamalar(TurIdx);
    try
      AssertTrue(AciklamaList.Count >= 1, Format('Tur %d icin varsayilan aciklamalar mevcut mu?', [TurIdx]));
    finally
      AciklamaList.Free;
    end;
  end;

  // Yeni açıklama ekleme ve silme
  AyarlarRepo.AddAciklama(1, 'Ozel Test Aciklamasi');
  AciklamaList := AyarlarRepo.GetAciklamalar(1);
  try
    AssertTrue(AciklamaList.IndexOf('Ozel Test Aciklamasi') >= 0, 'Yeni aciklama eklendi mi?');
  finally
    AciklamaList.Free;
  end;

  AyarlarRepo.DeleteAciklama(1, 'Ozel Test Aciklamasi');
  AciklamaList := AyarlarRepo.GetAciklamalar(1);
  try
    AssertTrue(AciklamaList.IndexOf('Ozel Test Aciklamasi') = -1, 'Aciklama basariyla silindi mi?');
  finally
    AciklamaList.Free;
  end;

  // --------------------------------------------------------------------------
  // BÖLÜM 9: Şifre ve Güvenlik ViewModel Testi
  // --------------------------------------------------------------------------
  Writeln(sLineBreak + '--- 9. Şifre & Güvenlik Testleri ---');
  AyarVM := TAyarlarViewModel.Create(AyarlarRepo);
  try
    AyarVM.SifreKorumasi := True;
    AssertTrue(AyarVM.VerifyPassword('gel'), 'Varsayilan sifre gel dogrulandi mi?');
    AssertTrue(not AyarVM.VerifyPassword('yanlis'), 'Varsayilan sifrede hatali sifre reddedildi mi?');
    AssertTrue(AyarVM.ChangePassword('', '123456', '123456', Err), 'Ilk sifre tanimlama basarili mi?');
    AssertTrue(AyarVM.VerifyPassword('123456'), 'Dogru sifre dogrulandi mi?');
    AssertTrue(not AyarVM.VerifyPassword('yanlis'), 'Hatali sifre reddedildi mi?');
    AssertTrue(not AyarVM.VerifyPassword('gel'), 'Eski sifre artik gecersiz mi?');
    AyarVM.KapatmaEylemi := 1;
    AssertTrue(AyarVM.KapatmaEylemi = 1, 'Kapatma eylemi kucult olarak saklandi mi?');
    AyarVM.MaksYedekSayisi := 20;
    AssertTrue(AyarVM.MaksYedekSayisi = 20, 'Maksimum yedek sayisi 20 olarak saklandi mi?');
  finally
    AyarVM.Free;
  end;

  // --------------------------------------------------------------------------
  // BÖLÜM 10: Yedekleme Servisi Testi
  // --------------------------------------------------------------------------
  Writeln(sLineBreak + '--- 10. Yedekleme Servis Testleri ---');
  AssertTrue(TBackupService.GetDatabasePath <> '', 'Veritabani yolu tanimli mi?');
  AssertTrue(TBackupService.GetBackupFolder <> '', 'Yedekleme klasoru tanimli mi?');
  AssertTrue(TBackupService.GetDefaultBackupFolder <> '', 'Varsayilan yedek klasoru dolu mu?');
  AssertTrue(TBackupService.FormatFileSize(500) = '500 B', 'FormatFileSize Byte testi dogru mu?');
  AssertTrue(Pos('KB', TBackupService.FormatFileSize(2048)) > 0, 'FormatFileSize KB testi dogru mu?');
  AssertTrue(Pos('MB', TBackupService.FormatFileSize(2 * 1024 * 1024)) > 0, 'FormatFileSize MB testi dogru mu?');

  // Test DB'sini data klasörüne taklit edip yedekleme almayı test et
  DataDir := AppDir + 'data\';
  ForceDirectories(DataDir);
  MainDbCopy := DataDir + DEF_DB_NAME;
  TFile.Copy(DbPath, MainDbCopy, True);
  try
    AssertTrue(TBackupService.BackupDatabase(BackupPath, BackupErr), 'Veritabani basariyla yedeklendi mi?');
    AssertTrue(FileExists(BackupPath), 'Yedek dosyasi gercekten olusturuldu mu?');
    AssertTrue(TFile.GetSize(BackupPath) > 0, 'Yedek dosyasi boyutu gecerli mi?');
    AssertTrue(TBackupService.GetLastBackupDate > 0, 'Son yedekleme tarihi kaydedildi mi?');

    var LBackupList := TBackupService.GetBackupList;
    try
      AssertTrue(LBackupList.Count >= 1, 'GetBackupList en az 1 yedek buldu mu?');
    finally
      LBackupList.Free;
    end;
  finally
    if FileExists(MainDbCopy) then DeleteFile(MainDbCopy);
    if FileExists(BackupPath) then DeleteFile(BackupPath);
  end;

  // --------------------------------------------------------------------------
  // BÖLÜM 11: Tema Yöneticisi Testi (uGelesiyeTheme)
  // --------------------------------------------------------------------------
  Writeln(sLineBreak + '--- 11. Tema Testleri ---');
  TAppThemeManager.SetTheme(thLight);
  AssertTrue(Theme.HeaderMain = 13795088, 'Aydinlik tema HeaderMain rengi dogru mu?');
  AssertTrue(Theme.HeaderModal = 13795088, 'Aydinlik tema HeaderModal rengi dogru mu?');
  AssertTrue(Theme.PanelBottom = clWhite, 'Aydinlik tema PanelBottom rengi dogru mu?');
  AssertTrue(Theme.ZebraEven = clWhite, 'Aydinlik tema ZebraEven beyaz mi?');

  TAppThemeManager.SetTheme(thDark);
  AssertTrue(Theme.HeaderMain = $003B291E, 'Karanlik tema HeaderMain rengi dogru mu?');
  AssertTrue(TAppThemeManager.CurrentTheme = thDark, 'Karanlik tema aktif mi?');
  AssertTrue(Theme.ZebraEven = $00242424, 'Karanlik tema ZebraEven dogru mu?');
  TAppThemeManager.SetTheme(thLight); // Geri al

  // --------------------------------------------------------------------------
  // BÖLÜM 12: Dil & Lokalizasyon Testi (uGelesiyeLang)
  // --------------------------------------------------------------------------
  Writeln(sLineBreak + '--- 12. Lokalizasyon Testleri ---');
  TLangManager.SetLanguage(langTR);
  AssertEqualStr('Borç Dekontu', _T(lkTurBorcDekontu), 'TR Borc Dekontu metni dogru mu?');
  AssertEqualStr('Tahsilat', _T(lkTurTahsilat), 'TR Tahsilat metni dogru mu?');
  AssertEqualStr('Alacak Dekontu', _T(lkTurAlacakDekontu), 'TR Alacak Dekontu metni dogru mu?');
  AssertEqualStr('Ödeme', _T(lkTurOdeme), 'TR Odeme metni dogru mu?');
  AssertEqualStr('Kaydet', _T(lkBtnKaydet), 'TR Kaydet butonu metni dogru mu?');
  AssertEqualStr('Vazgeç', _T(lkBtnVazgec), 'TR Vazgec butonu metni dogru mu?');

  TLangManager.SetLanguage(langEN);
  AssertEqualStr('Debit Voucher', _T(lkTurBorcDekontu), 'EN Borc Dekontu metni dogru mu?');
  AssertEqualStr('Collection', _T(lkTurTahsilat), 'EN Tahsilat metni dogru mu?');
  AssertEqualStr('Credit Voucher', _T(lkTurAlacakDekontu), 'EN Alacak Dekontu metni dogru mu?');
  AssertEqualStr('Payment', _T(lkTurOdeme), 'EN Odeme metni dogru mu?');
  AssertEqualStr('Save', _T(lkBtnKaydet), 'EN Save butonu metni dogru mu?');
  AssertEqualStr('Cancel', _T(lkBtnVazgec), 'EN Cancel butonu metni dogru mu?');
  TLangManager.SetLanguage(langTR); // Geri al

  // --------------------------------------------------------------------------
  // BÖLÜM 13: Versiyon Yardımcıları Testi (uGelesiyeVersion)
  // --------------------------------------------------------------------------
  Writeln(sLineBreak + '--- 13. Versiyon Bilgisi Testleri ---');
  AppTitle := GetGelesiyeTitleWithVersion('Test Firma');
  AssertTrue(Pos('Test Firma', AppTitle) > 0, 'Baslik firma adini iceriyor mu?');
  AssertTrue(Pos('Gelesiye', AppTitle) > 0, 'Baslik program adini iceriyor mu?');
  SbVer := GetGelesiyeStatusBarVersion;
  AssertTrue(Pos('v1.0.0', SbVer) > 0, 'Durum cubugu versiyon bilgisi v1.0.0 iceriyor mu?');

  // --------------------------------------------------------------------------
  // BÖLÜM 14: Döviz Kuru Servis Testleri (uDovizKuruService)
  // --------------------------------------------------------------------------
  Writeln(sLineBreak + '--- 14. Doviz Kuru Servis Testleri ---');
  // 14.1 Başarısız/Boş kur formatlama testi (Kullanıcı talebi: alınamazsa boş göstersin)
  KurRes.USD := 0;
  KurRes.EUR := 0;
  KurRes.Basarili := False;
  KurStr := TDovizKuruService.FormatKurMetni(KurRes);
  AssertEqualStr('', KurStr, 'Basarisiz kur metni bos string olmali');

  // 14.2 Başarılı kur formatlama testi
  KurRes.USD := 48.51;
  KurRes.EUR := 56.36;
  KurRes.Basarili := True;
  KurStr := TDovizKuruService.FormatKurMetni(KurRes);
  AssertTrue(Pos('$', KurStr) > 0, 'Dolar sembolu formatta mevcut mu?');
  AssertTrue(Pos('€', KurStr) > 0, 'Euro sembolu formatta mevcut mu?');

  // 14.3 KurlariAl metodu hata fırlatmadan calisiyor mu?
  TDovizKuruService.KurlariAl(KurRes);
  AssertTrue(True, 'KurlariAl sessizce (hata firlatmadan) calisti');
  if KurRes.Basarili then
  begin
    AssertTrue(KurRes.USD > 0, 'TCMB Dolar kuru pozitif mi?');
    AssertTrue(KurRes.EUR > 0, 'TCMB Euro kuru pozitif mi?');
  end;

  // --------------------------------------------------------------------------
  // BÖLÜM 15: İl & İlçe Otomatik Tohumlama Testleri
  // --------------------------------------------------------------------------
  Writeln(sLineBreak + '--- 15. Il & Ilce Otomatik Tohumlama Testleri ---');
  IlRepo := TDbFactory.GetIlIlceRepository;
  AssertTrue(IlRepo <> nil, 'Il & Ilce repository olusturuldu mu?');

  Iller := IlRepo.GetIller;
  try
    AssertEqualInt(81, Iller.Count, 'Toplam 81 il otomatik yuklendi mi?');
    AssertTrue(Iller.IndexOf('Adana') >= 0, 'Adana ili mevcut mu?');
    AssertTrue(Iller.IndexOf('Ankara') >= 0, 'Ankara ili mevcut mu?');
    AssertTrue(Iller.IndexOf('İstanbul') >= 0, 'İstanbul ili mevcut mu?');
    AssertTrue(Iller.IndexOf('İzmir') >= 0, 'İzmir ili mevcut mu?');
  finally
    Iller.Free;
  end;

  IlcelerAdana := IlRepo.GetIlceler('Adana');
  try
    AssertEqualInt(15, IlcelerAdana.Count, 'Adana ilceler sayisi 15 mi?');
    AssertTrue(IlcelerAdana.IndexOf('Seyhan') >= 0, 'Seyhan ilcesi Adana altinda mevcut mu?');
    AssertTrue(IlcelerAdana.IndexOf('Çukurova') >= 0, 'Çukurova ilcesi Adana altinda mevcut mu?');
  finally
    IlcelerAdana.Free;
  end;

  IlcelerAnkara := IlRepo.GetIlceler('Ankara');
  try
    AssertTrue(IlcelerAnkara.Count >= 25, 'Ankara ilceler sayisi 25 mi?');
    AssertTrue(IlcelerAnkara.IndexOf('Çankaya') >= 0, 'Çankaya ilcesi Ankara altinda mevcut mu?');
    AssertTrue(IlcelerAnkara.IndexOf('Keçiören') >= 0, 'Keçiören ilcesi Ankara altinda mevcut mu?');
  finally
    IlcelerAnkara.Free;
  end;

  TDbFactory.Finalize;
  if FileExists(DbPath) then
    DeleteFile(DbPath);

  Writeln(sLineBreak + '============================================================');
  Writeln(Format('[BASARILI] TUM %d TEST EKSIKSIZ GECTI!', [GPassCount]));
  Writeln('============================================================');
end;

begin
  try
    RunAllTests;
  except
    on E: Exception do
    begin
      Writeln('[HATA] ' + E.ClassName + ': ' + E.Message);
      Halt(1);
    end;
  end;
end.
