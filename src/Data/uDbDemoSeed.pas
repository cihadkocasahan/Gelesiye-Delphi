unit uDbDemoSeed;

interface

uses
  FireDAC.Comp.Client,
  FireDAC.Stan.Param,
  System.SysUtils,
  System.Classes;

procedure SeedDemoData(AConn: TFDConnection; AForce: Boolean = False);

implementation

procedure SeedDemoData(AConn: TFDConnection; AForce: Boolean = False);
var
  FirmaId: Integer;
  NowStr: string;

  procedure AddCariWithMovements(
    const ACariKodu, AUnvan, AYetkili, ATelefon, AGsm,
          ASehir, AIlce, AVergiD, AVergiNo, AEposta: string;
    ALimit: Double; AVariation: Integer);
  var
    CariId: Integer;
    Qry: TFDQuery;
  begin
    Qry := TFDQuery.Create(nil);
    try
      Qry.Connection := AConn;
      Qry.SQL.Text :=
        'INSERT INTO CARILER (' +
        '  FIRMA_ID, CARI_KODU, UNVAN, YETKILI, TELEFON, GSM, FAKS, ' +
        '  ADRES, IL, ILCE, VERGI_DAIRESI, VERGI_NO, EPOSTA, WEB, ' +
        '  CARI_LIMIT, HESAP_DURUMU, NOTLAR, KAYIT_TARIHI, IS_DELETED' +
        ') VALUES (' +
        '  :FID, :KOD, :UNVAN, :YETKILI, :TEL, :GSM, '''', ' +
        '  :ADRES, :IL, :ILCE, :VD, :VN, :MAIL, :WEB, ' +
        '  :LIMIT, 1, ''Demo tohumlama cari kartı'', :KAYIT, 0' +
        ');';
      Qry.ParamByName('FID').AsInteger := FirmaId;
      Qry.ParamByName('KOD').AsString := ACariKodu;
      Qry.ParamByName('UNVAN').AsString := AUnvan;
      Qry.ParamByName('YETKILI').AsString := AYetkili;
      Qry.ParamByName('TEL').AsString := ATelefon;
      Qry.ParamByName('GSM').AsString := AGsm;
      Qry.ParamByName('ADRES').AsString := AIlce + ' Mah. Atatürk Cad. No: ' + IntToStr(AVariation * 3);
      Qry.ParamByName('IL').AsString := ASehir;
      Qry.ParamByName('ILCE').AsString := AIlce;
      Qry.ParamByName('VD').AsString := AVergiD;
      Qry.ParamByName('VN').AsString := AVergiNo;
      Qry.ParamByName('MAIL').AsString := AEposta;
      Qry.ParamByName('WEB').AsString := 'www.' + Copy(AEposta, Pos('@', AEposta) + 1, MaxInt);
      Qry.ParamByName('LIMIT').AsCurrency := ALimit;
      Qry.ParamByName('KAYIT').AsString := NowStr;
      Qry.ExecSQL;
      CariId := AConn.GetLastAutoGenValue('');

      // 6 ila 8 hareket ekle
      // 1: Devir
      Qry.SQL.Text :=
        'INSERT INTO HAREKETLER (FIRMA_ID, CARI_ID, TARIH, ISLEM_TURU, ACIKLAMA, BORC, ALACAK, IS_DELETED) ' +
        'VALUES (:FID, :CID, ''2026-01-02 09:30:00'', 4, ''2025 Yılı Devir Bakiyesi'', :B, 0, 0);';
      Qry.ParamByName('FID').AsInteger := FirmaId;
      Qry.ParamByName('CID').AsInteger := CariId;
      Qry.ParamByName('B').AsCurrency := 3000.0 + (AVariation * 250.0);
      Qry.ExecSQL;

      // 2: Mal Alımı / Borç Dekontu
      Qry.SQL.Text :=
        'INSERT INTO HAREKETLER (FIRMA_ID, CARI_ID, TARIH, ISLEM_TURU, ACIKLAMA, BORC, ALACAK, IS_DELETED) ' +
        'VALUES (:FID, :CID, ''2026-01-15 14:20:00'', 0, ''Hizmet Bedeli / Mal Alımı'', :B, 0, 0);';
      Qry.ParamByName('FID').AsInteger := FirmaId;
      Qry.ParamByName('CID').AsInteger := CariId;
      Qry.ParamByName('B').AsCurrency := 5000.0 + (AVariation * 380.0);
      Qry.ExecSQL;

      // 3: Banka Havalesi ile Tahsilat
      Qry.SQL.Text :=
        'INSERT INTO HAREKETLER (FIRMA_ID, CARI_ID, TARIH, ISLEM_TURU, ACIKLAMA, BORC, ALACAK, IS_DELETED) ' +
        'VALUES (:FID, :CID, ''2026-01-28 11:15:00'', 1, ''Banka Havalesi ile Tahsilat'', 0, :A, 0);';
      Qry.ParamByName('FID').AsInteger := FirmaId;
      Qry.ParamByName('CID').AsInteger := CariId;
      Qry.ParamByName('A').AsCurrency := 4000.0 + (AVariation * 200.0);
      Qry.ExecSQL;

      // 4: Fatura Bedeli / Satış
      Qry.SQL.Text :=
        'INSERT INTO HAREKETLER (FIRMA_ID, CARI_ID, TARIH, ISLEM_TURU, ACIKLAMA, BORC, ALACAK, IS_DELETED) ' +
        'VALUES (:FID, :CID, ''2026-02-10 16:45:00'', 0, ''Fatura Bedeli (#A-10492)'', :B, 0, 0);';
      Qry.ParamByName('FID').AsInteger := FirmaId;
      Qry.ParamByName('CID').AsInteger := CariId;
      Qry.ParamByName('B').AsCurrency := 4500.0 + (AVariation * 310.0);
      Qry.ExecSQL;

      // 5: Kredi Kartı ile Tahsilat
      Qry.SQL.Text :=
        'INSERT INTO HAREKETLER (FIRMA_ID, CARI_ID, TARIH, ISLEM_TURU, ACIKLAMA, BORC, ALACAK, IS_DELETED) ' +
        'VALUES (:FID, :CID, ''2026-02-22 10:00:00'', 1, ''Kredi Kartı ile Tahsilat'', 0, :A, 0);';
      Qry.ParamByName('FID').AsInteger := FirmaId;
      Qry.ParamByName('CID').AsInteger := CariId;
      Qry.ParamByName('A').AsCurrency := 3500.0 + (AVariation * 290.0);
      Qry.ExecSQL;

      // 6: Veresiye Satış Faturası
      Qry.SQL.Text :=
        'INSERT INTO HAREKETLER (FIRMA_ID, CARI_ID, TARIH, ISLEM_TURU, ACIKLAMA, BORC, ALACAK, IS_DELETED) ' +
        'VALUES (:FID, :CID, ''2026-03-05 13:30:00'', 0, ''Veresiye Satış Faturası'', :B, 0, 0);';
      Qry.ParamByName('FID').AsInteger := FirmaId;
      Qry.ParamByName('CID').AsInteger := CariId;
      Qry.ParamByName('B').AsCurrency := 2800.0 + (AVariation * 170.0);
      Qry.ExecSQL;

      // 7: Nakit Tahsilat
      if (AVariation mod 2 = 0) then
      begin
        Qry.SQL.Text :=
          'INSERT INTO HAREKETLER (FIRMA_ID, CARI_ID, TARIH, ISLEM_TURU, ACIKLAMA, BORC, ALACAK, IS_DELETED) ' +
          'VALUES (:FID, :CID, ''2026-03-12 15:00:00'', 1, ''Nakit Tahsilat'', 0, :A, 0);';
        Qry.ParamByName('FID').AsInteger := FirmaId;
        Qry.ParamByName('CID').AsInteger := CariId;
        Qry.ParamByName('A').AsCurrency := 2000.0 + (AVariation * 150.0);
        Qry.ExecSQL;
      end;

      // 8: İskonto / Mal İadesi
      if (AVariation mod 3 = 0) then
      begin
        Qry.SQL.Text :=
          'INSERT INTO HAREKETLER (FIRMA_ID, CARI_ID, TARIH, ISLEM_TURU, ACIKLAMA, BORC, ALACAK, IS_DELETED) ' +
          'VALUES (:FID, :CID, ''2026-03-18 17:10:00'', 2, ''Mal İadesi / İskonto Bedeli'', 0, :A, 0);';
        Qry.ParamByName('FID').AsInteger := FirmaId;
        Qry.ParamByName('CID').AsInteger := CariId;
        Qry.ParamByName('A').AsCurrency := 750.0 + (AVariation * 50.0);
        Qry.ExecSQL;
      end;

    finally
      Qry.Free;
    end;
  end;

begin
  if not AForce then
  begin
    if AConn.ExecSQLScalar('SELECT COUNT(*) FROM CARILER WHERE IS_DELETED = 0') >= 10 then
      Exit;
  end;

  FirmaId := AConn.ExecSQLScalar('SELECT COALESCE(MIN(ID), 1) FROM FIRMALAR');
  NowStr := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now);

  AConn.StartTransaction;
  try
    AddCariWithMovements('00001', 'Ahmet Yılmaz - Yılmaz Ticaret', 'Ahmet Yılmaz', '0212 555 1001', '0532 555 1001', 'İstanbul', 'Kadıköy', 'Kadıköy', '1234567890', 'ahmet@yilmazticaret.com', 25000.0, 1);
    AddCariWithMovements('00002', 'Demir İnşaat & Hırdavat Ltd. Şti.', 'Mehmet Demir', '0216 444 2002', '0533 444 2002', 'İstanbul', 'Ümraniye', 'Sarıgazi', '2345678901', 'info@demirinsaat.com.tr', 50000.0, 2);
    AddCariWithMovements('00003', 'Kaya Gıda Toptan ve Perakende', 'Ayşe Kaya', '0232 333 3003', '0535 333 3003', 'İzmir', 'Konak', 'Konak', '3456789012', 'siparis@kayagida.com', 35000.0, 3);
    AddCariWithMovements('00004', 'Yıldız Kırtasiye ve Büro Malz.', 'Canan Yıldız', '0312 222 4004', '0542 222 4004', 'Ankara', 'Çankaya', 'Çankaya', '4567890123', 'yildiz@kirtasiye.com', 15000.0, 4);
    AddCariWithMovements('00005', 'Şahin Otomotiv Yedek Parça', 'Mustafa Şahin', '0224 555 5005', '0544 555 5005', 'Bursa', 'Nilüfer', 'Nilüfer', '5678901234', 'mustafa@sahinoto.com', 40000.0, 5);
    AddCariWithMovements('00006', 'Anadolu Lojistik & Taşımacılık A.Ş.', 'Emre Koç', '0262 641 6006', '0530 641 6006', 'Kocaeli', 'Gebze', 'İlyasbey', '6789012345', 'info@anadolulojistik.com', 60000.0, 6);
    AddCariWithMovements('00007', 'Örnek Tekstil ve Konfeksiyon San.', 'Zeynep Arslan', '0258 261 7007', '0536 261 7007', 'Denizli', 'Pamukkale', 'Gökpınar', '7890123456', 'zeynep@ornektekstil.com', 30000.0, 7);
    AddCariWithMovements('00008', 'Marmara Kimya ve Boya Sanayi', 'Murat Çelik', '0212 674 8008', '0537 674 8008', 'İstanbul', 'İkitelli', 'İkitelli', '8901234567', 'murat@marmarakimya.com', 45000.0, 8);
    AddCariWithMovements('00009', 'Boğaziçi Elektrik ve Elektronik', 'Burak Doğan', '0212 288 9009', '0538 288 9009', 'İstanbul', 'Şişli', 'Mecidiyeköy', '9012345678', 'burak@bogazicielectric.com', 35000.0, 9);
    AddCariWithMovements('00010', 'Çukurova Tarım Ürünleri Ltd.', 'Ali Öztürk', '0322 453 1010', '0539 453 1010', 'Adana', 'Seyhan', 'Seyhan', '0123456789', 'ali@cukurovatarim.com', 75000.0, 10);
    AddCariWithMovements('00011', 'Güneş Ambalaj ve Plastik Sanayi', 'Kemal Aydın', '0342 338 1111', '0541 338 1111', 'Gaziantep', 'Şehitkamil', 'Şehitkamil', '1122334455', 'kemal@gunesambalaj.com', 40000.0, 11);
    AddCariWithMovements('00012', 'Akdeniz Mobilya ve Ahşap Sanayi', 'Seda Kurt', '0242 345 1212', '0543 345 1212', 'Antalya', 'Muratpaşa', 'Muratpaşa', '2233445566', 'seda@akdenizmobilya.com', 50000.0, 12);
    AddCariWithMovements('00013', 'Karadeniz Balıkçılık & Su Ürünleri', 'Hasan Çakır', '0462 321 1313', '0545 321 1313', 'Trabzon', 'Ortahisar', 'Karadeniz', '3344556677', 'hasan@karadenizbalik.com', 25000.0, 13);
    AddCariWithMovements('00014', 'Ege Çiftliği Süt ve Besicilik', 'Fatma Güler', '0236 231 1414', '0546 231 1414', 'Manisa', 'Yunusemre', 'Mesir', '4455667788', 'fatma@egeciftligi.com', 35000.0, 14);
    AddCariWithMovements('00015', 'TeknoPark Bilişim Hizmetleri Ltd.', 'Oğuzhan Polat', '0312 210 1515', '0547 210 1515', 'Ankara', 'Yenimahalle', 'Yenimahalle', '5566778899', 'oguzhan@teknoparkbilisim.com', 60000.0, 15);
    AddCariWithMovements('00016', 'Başak Ekmek ve Unlu Mamulleri', 'İsmail Keskin', '0332 350 1616', '0548 350 1616', 'Konya', 'Selçuklu', 'Mevlana', '6677889900', 'ismail@basakmamul.com', 20000.0, 16);
    AddCariWithMovements('00017', 'Umut Temizlik ve Hijyen Malz.', 'Hatice Korkmaz', '0222 230 1717', '0549 230 1717', 'Eskişehir', 'Tepebaşı', 'Battalgazi', '7788990011', 'hatice@umuttemizlik.com', 15000.0, 17);
    AddCariWithMovements('00018', 'Barış Matbaacılık ve Yayıncılık', 'Barış Yalçın', '0212 567 1818', '0551 567 1818', 'İstanbul', 'Zeytinburnu', 'Zeytinburnu', '8899001122', 'baris@barismatbaa.com', 30000.0, 18);
    AddCariWithMovements('00019', 'Zirve Endüstriyel Mutfak Ekip.', 'Serhat Erdem', '0216 390 1919', '0552 390 1919', 'İstanbul', 'Tuzla', 'Tuzla', '9900112233', 'serhat@zirvemutfak.com', 80000.0, 19);
    AddCariWithMovements('00020', 'Atlas Medikal ve Sağlık Gereçleri', 'Elif Yavuz', '0312 430 2020', '0553 430 2020', 'Ankara', 'Altındağ', 'Ulus', '1029384756', 'elif@atlasmedikal.com', 45000.0, 20);
    AddCariWithMovements('00021', 'Serin Soğutma & İklimlendirme', 'Tolga Acar', '0232 464 2121', '0554 464 2121', 'İzmir', 'Bornova', 'Bornova', '2130495867', 'tolga@serinsogutma.com', 35000.0, 21);
    AddCariWithMovements('00022', 'Elit Yapı Malzemeleri ve Boya', 'Berna Aslan', '0242 228 2222', '0555 228 2222', 'Antalya', 'Kepez', 'Düden', '3241506978', 'berna@elityapi.com', 40000.0, 22);
    AddCariWithMovements('00023', 'Mega Metal ve Alüminyum Doğrama', 'Kadir Şen', '0224 441 2323', '0556 441 2323', 'Bursa', 'Osmangazi', 'Osmangazi', '4352617089', 'kadir@megametal.com', 55000.0, 23);
    AddCariWithMovements('00024', 'Doğu Tarım & Hayvancılık Paz.', 'Hakan Güneş', '0442 233 2424', '0557 233 2424', 'Erzurum', 'Yakutiye', 'Aziziye', '5463728190', 'hakan@dogutarim.com', 65000.0, 24);
    AddCariWithMovements('00025', 'Güven Sigorta ve Aracılık Hiz.', 'Selin Çetin', '0212 212 2525', '0558 212 2525', 'İstanbul', 'Beşiktaş', 'Beşiktaş', '6574839201', 'selin@guvensigorta.com', 20000.0, 25);
    AConn.Commit;
  except
    AConn.Rollback;
    raise;
  end;
end;

end.
