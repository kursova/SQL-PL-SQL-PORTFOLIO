
---SEQUENCE OLUÞTURMA
DROP SEQUENCE ea_seq_V3;
CREATE SEQUENCE ea_seq_V5
START WITH 1
INCREMENT BY 1;
CACHE_SIZE 1;

DROP TABLE EA_70000_V2;
CREATE TABLE EA_70000_V2 AS
SELECT MUSTERI_ID, PAKET_ID, KURUM_ID, 0 AS ID FROM EA_70000_ABONE_BAZLI;

SELECT * FROM EA_70000_V2;

DECLARE
    v_count number;
BEGIN
    SELECT COUNT(*) INTO v_count FROM EA_70000_V2;

            UPDATE EA_70000_V2
                SET ID=ea_seq_V4.nextval;
    
END;

----WHILE ÝLE FAKTÖRÝYEL HESAPLAMA
SET SERVEROUT ON;
DECLARE
v_sayi number:=&deger;
v_carpim EA_70000_V2.ID%TYPE :=1;
k number;
BEGIN 
k:=v_sayi;
    WHILE v_sayi>0 LOOP
        v_carpim:=v_sayi*v_carpim;
        v_sayi:=v_sayi-1;
    end loop;          
dbms_output.put_line (k || '! =' || v_carpim );
END;

----LOOP ÝLE FIBONACCI SERISI HESAPLAMA
SET SERVEROUT ON;
DECLARE
    v_ilk_sayi number:=0;
    v_ikinci_sayi number:=1;
    v_toplam number;
    v_adet number:=10;
BEGIN 

    FOR i IN 2..v_adet loop
        v_toplam:=v_ilk_sayi+v_ikinci_sayi;
        v_ilk_sayi:=v_ikinci_sayi;
        v_ikinci_sayi:=v_toplam;
        dbms_output.put_line (v_toplam);
    END LOOP;   
END;

---1 ocaktan itibaren 2 haftada bir salý gününe denk gelen toplantý ayarlama. (23 nisa hariç)
SET SERVEROUT ON;
DECLARE
    v_tarih date ;
    v_adet number:=0;
BEGIN 
    
        SELECT next_day(to_date('01/01/2024', 'dd/mm/yyyy'), 'salý') INTO v_tarih FROM dual;
    LOOP 
        if v_tarih!=to_date('23/04/2024', 'dd/mm/yyyy') 
            then 
                dbms_output.put_line ('toplantý tarihi: '|| v_tarih);
                v_adet:=v_adet+1;
        end if;
        
        v_tarih:=v_tarih+14;
        EXIT WHEN v_adet=10;
     END LOOP;
END;

---EKRANA ÇÝFT SAYILARI YAZDIRMA 
SET SERVEROUT ON;
BEGIN
    for i in 1..20 LOOP
        continue when mod(i,2)=1;
        dbms_output.put_line (i);
    END LOOP;
END;

---ROWTYPE KULLANIMI
SET SERVEROUT ON;
DECLARE
    v_personel EA_70000_V2%rowtype;
    
BEGIN 
    select * into v_personel from EA_70000_V2 where id=3854730;
    dbms_output.put_line(v_personel.PAKET_ID);
END;

----ROWTYPE ILE INSERT KULLANIMI
CREATE TABLE ayrilan_personel as 
SELECT * FROM EA_70000_V2 where 1=0;

DECLARE
    v_ayrilan ayrilan_personel%rowtype;
BEGIN
    SELECT * INTO v_ayrilan FROM EA_70000_V2 WHERE ID=3854733;
    insert into ayrilan_personel values v_ayrilan;
END;
SELECT * FROM EA_70000_V2;

--ROWTYPE ILE UPDATE KULLANIMI
DECLARE 
    v_ayrilan ayrilan_personel%ROWTYPE;
BEGIN 
    SELECT * INTO v_ayrilan FROM ayrilan_personel WHERE ID=3854733;
    v_ayrilan.PAKET_ID:=10;
    UPDATE ayrilan_personel
        SET ROW =v_ayrilan
    WHERE ID=3854733;
END;


SET SERVEROUT ON;
DECLARE
    type type_personel is table of EA_70000_V2%rowtype
        index by VARCHAR2(250);
    
    v_personel type_personel;
BEGIN 
    SELECT * INTO  v_personel(1) FROM EA_70000_V2 WHERE ID=3854730;
    DBMS_OUTPUT.PUT_LINE (v_personel(1).musteri_id);
END;

----LOOP 
SET SERVEROUT ON;
DECLARE
    TYPE type_personel IS TABLE OF EA_70000_V2%ROWTYPE
        INDEX BY VARCHAR2(250);
    v_personel type_personel;
BEGIN 
    FOR i IN 1..10 LOOP
        SELECT * INTO v_personel(i) FROM EA_70000_V2
        WHERE ID=3854729+i;
    END LOOP;
    
    FOR i IN 1..10 LOOP
        DBMS_OUTPUT.PUT_LINE (v_personel(i).musteri_id);
    END LOOP;
END;

---COLLECTION ÝÇERÝSÝNDE DÖNGÜ
SET SERVEROUT ON;
DECLARE
    TYPE sirket_type IS TABLE OF VARCHAR2(250)
        INDEX BY VARCHAR2(250);
        
    v_sirket sirket_type;
    v_count number;
    v_key varchar(250);
    v_name varchar(250);
    v_hizmet_no varchar(250);
    v_milenicom_count number:=0;
    
BEGIN
    SELECT COUNT(*) INTO v_count 
    FROM GZM_700;
    
    FOR i IN 1..v_count LOOP
    
        SELECT KURUM_ADI,HIZMET_NO
        INTO v_name, v_hizmet_no
        FROM GZM_700
        WHERE ID=i;
        
        v_sirket(v_name):=v_hizmet_no;
        
    END LOOP;
    
    v_key:=v_sirket.first;
    
    WHILE v_key IS NOT NULL LOOP
        IF (v_sirket(v_key) like '%MÝLLENÝCOM%') THEN 
            dbms_output.put_line(v_key || ' : ' || v_sirket(v_key));
            v_milenicom_count :=v_milenicom_count+1;
        END IF;
        
        v_key:=v_sirket.next(v_key);
        
    END LOOP;
    dbms_output.put_line ('tum musteriler: ' ||v_count );
    dbms_output.put_line ('millenicom: ' ||v_milenicom_count );
END;


----NESTED TABLES 
 DECLARE
    TYPE isim_type IS TABLE OF VARCHAR(20); ---burada index yok
    v_isimler isim_type;
 BEGIN 
    v_isimler := isim_type('gizem', 'didem', 'esra');
    v_isimler.extend;
    v_isimler(v_isimler.count):='yasemin';
     for i in v_isimler.first..v_isimler.last loop
        dbms_output.put_line(v_isimler(i));
     end loop;
 END;
 
 ----CURSOR KULLANIMI
SET SERVEROUTPUT ON;
--SELECT * FROM EA_70000_V2;

DECLARE
    CURSOR c_personel IS 
        SELECT musteri_id, id FROM EA_70000_V2;
        
    v_musteri_id EA_70000_V2.musteri_id%type;
    id EA_70000_V2.id%type;
BEGIN
    OPEN c_personel;
        FOR i IN 1..10 LOOP
            FETCH c_personel INTO v_musteri_id, id;
            dbms_output.put_line(v_musteri_id || ' : ' || id);
        END LOOP;
    CLOSE c_personel;
END;

----LOOP ÝÇERÝSÝNDE CURSOR VE RECORD KULLANIMI
SET SERVEROUTPUT ON;
DECLARE
    CURSOR c_personel IS 
        SELECT musteri_id, id FROM EA_70000_V2;
        
    --v_personel_record c_personel%rowtype;
    c_new_line char(1):=CHR(10);
BEGIN
   -- OPEN c_personel;
        FOR v_personel_record IN c_personel LOOP
            --FETCH c_personel INTO v_personel_record;
           dbms_output.put_line(v_personel_record.musteri_id  || c_new_line ||  v_personel_record.id  );
        END LOOP;
    --CLOSE c_personel;
END;

----CURSORDA PARAMETRE KULLANIMI 
SET SERVEROUTPUT ON;
DECLARE
    CURSOR c_personel (c_paket_id number) IS 
        SELECT * FROM EA_70000_V2
        WHERE paket_id=c_paket_id;
        
    v_personel_record c_personel%rowtype;
    c_new_line char(1):=CHR(10);
BEGIN
        FOR v_personel_record IN c_personel (129500) LOOP
           dbms_output.put_line(v_personel_record.musteri_id  || ' : ' ||  v_personel_record.paket_id  );
        END LOOP;
    
END;

----EXCEPTION BLOÐU KULLANIMI 
SET SERVEROUTPUT ON;
DECLARE
    v_personel varchar2(250);
BEGIN
    SELECT paket_id INTO v_personel FROM EA_70000_V2 WHERE paket_id=129500;
    EXCEPTION 
        WHEN too_many_rows THEN 
            dbms_output.put_line('birden fazla deðer var.');
END;



----ÝSÝMSÝZ BLOKTA KARESÝNÝ ALMA VS PROSEDÜRLE KARESÝNÝ ALMA 
SET SERVEROUTPUT ON;
DECLARE
    v_sonuc number;
BEGIN
    for i in 1..10 LOOP
        v_sonuc:=i**2;
         dbms_output.put_line(i || ' karesi: ' || v_sonuc );
    END LOOP;
END;

---PROSEDUR
SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE karesini_al IS
    v_sonuc number;
BEGIN
    for i in 1..10 LOOP
        v_sonuc:=i**2;
         dbms_output.put_line(i || ' karesi: ' || v_sonuc );
    END LOOP;
END;

SELECT * FROM USER_OBJECTS WHERE OBJECT_TYPE='PROCEDURE';

---PROSEDÜR ÇAÐIRMA 
1-  EXECUTE PROSEDUR_ADI
2-  EXEC PROSEDUR_ADI
3-  BEGIN 
    karesini_al;
END;

-----PARAMETRELÝ PROSEDÜR OLUÞTURMA //BU ÇALIÞMADI NEDEN??
SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE personel_yazdr (p_paket_id NUMBER) IS 
  
    CURSOR c_personel IS
        SELECT * FROM EA_70000_V2
        paket_id=p_paket_id;
BEGIN 
    FOR i IN c_personel LOOP
        dbms_output.put_line(ID || ' :' || i );
    END LOOP;
END;

 EXEC personel_yazdr(129364);
SELECT * FROM EA_70000_V2;


---------------PARAMETRELI PROSEDÜR OLUÞTURMA -2 (BU KISMI KULLANARAK DAHA SONRA YAPMAK ÝSTEDÝÐÝMÝZ INSERT PROSEDÜRÜNÜ KULLANABÝLÝRÝZ 
CREATE OR REPLACE PROCEDURE konum_ekle 
    (
        p_konum_id konum.konum_id%type,
        p_konum_adi varchar,
        p_il_kodu number 
    )
IS 
BEGIN 
    INSERT INTO konum
    values (p_konum_id, p_konum_adi, p_il_kodu);
    commit;
END;

EXEC konum_ekle (222,'deneme', 45);

---------
CREATE OR REPLACE PROCEDURE test_datasi_dondurme (p_abone_id number) IS 
    v_abone SMARTTBILL.ABONE_HAREKET%ROW_TYPE;
BEGIN
    SELECT * INTO v_abone
    FROM SMARTTBILL.ABONE_HAREKET 
    WHERE ABONE_ID=p_abone_id;
    DBMS_OUTPUT.put_line('insert into SMARTTBILL.ABONE_HAREKET ' || );
END;






---------------

CREATE OR REPLACE PROCEDURE test_datasi_dondurme (p_abone_id number) IS 

    v_abone SMARTTBILL.ABONE_HAREKET%ROWTYPE;
BEGIN
    SELECT * INTO v_abone
    FROM SMARTTBILL.ABONE_HAREKET 
    WHERE ABONE_ID=p_abone_id;

    FUNCTION check_null (val IN VARCHAR2) 
    RETURN VARCHAR2 IS 
        BEGIN 
            IF val IS NULL THEN 
                RETURN 'NULL';
            ELSE 
                RETURN '''' || REPLACE(val,'''','''''') || '''';
            END IF;   
        END check_null;
        
        FUNCTION check_null_number (val IN NUMBER) 
    RETURN VARCHAR2 IS 
        BEGIN 
            IF val IS NULL THEN 
                RETURN 'NULL';
            ELSE 
                RETURN TO_CHAR(val);
            END IF;   
        END check_null;
        
    DBMS_OUTPUT.PUT_LINE (
    'Insert into SMARTTBILL.ABONE_HAREKET (
    ID,ABONE_ID,HESAP_ID,HIZMET_NO,HIZMET_TURU,ALT_HIZMET_TURU,PAKET_TURU,HIZ,SA_GRUP_KODU,SERVIS_SEVIYE_ID,ABONE_TIPI,VPOP_SAYISI,ABONE_TURU,DEVRE_CESIDI,INDIRIMLI_SOZLESME_ID,PROJE_TAKIP_KODU,TESIS_TARIHI,IPTAL_TARIHI,SERVISE_VERILIS_TARIHI,IL_KODU,CAGRI_NO,HAREKET_IS_TURU,BASLANGIC_TARIHI,UZAK_MESAFE,TAMAMLANMA_ZAMANI,HEADER_ID,UPLOAD_HIZI_ORAN,MUDURLUK_KODU,SONLANMA_TARIHI,HAT_SAYISI,ISEMRI_GELIS_TARIHI,DOMAIN_ADI,KULLANICI_KIMLIK,DURUM,STATIK_IP,ANA_DEVRE_NO,HAREKET_ALT_IS_TURU,TESIS_BB_KODU,ACIKLAMA,KULLANICI_SAYISI,BELEDIYE_KODU,NUSHA_SAYISI,ESKI_ID,ENGELLI_INDIRIMI,XDSL_TIP_KODU,OM_TARIFE_ID,TOPLAMA_MERKEZI,KADEME,DONEM_ID,LOKASYON_ID,FIBER_MESAFE,REFERANS_HESAP_NO,DEVRE_OZELLIK,ILISKILI_HIZMET_NO,UST_HEADER_ID,DEVRE_KULLANIM_TIPI,URUN_SIPARIS_NO,XDSL_LAC_ID,TLAC_SERVICE_NUMBER,ALTYAPI_TIPI)
    values 
    (' 
    ||
    check_null(v_abone.ID)|| ','||
    check_null(v_abone.ABONE_ID)|| ','||
    check_null(v_abone.HESAP_ID)|| ','||
    check_null(v_abone.HIZMET_NO)|| ','||
    check_null(v_abone.HIZMET_TURU)|| ','||
    check_null(v_abone.ALT_HIZMET_TURU)|| ','||
    check_null(v_abone.PAKET_TURU)|| ','||
    check_null(v_abone.HIZ)|| ','||
    check_null(v_abone.SA_GRUP_KODU)|| ','||
    check_null(v_abone.SERVIS_SEVIYE_ID)|| ','||
    check_null(v_abone.ABONE_TIPI)|| ','||
    check_null(v_abone.VPOP_SAYISI)|| ','||
    check_null(v_abone.ABONE_TURU)|| ','||
    check_null(v_abone.DEVRE_CESIDI)|| ','||
    check_null(v_abone.INDIRIMLI_SOZLESME_ID)|| ','||
    check_null(v_abone.PROJE_TAKIP_KODU)|| ','||
    check_null(v_abone.TESIS_TARIHI)|| ','||
    check_null(v_abone.IPTAL_TARIHI)|| ','||
    check_null(v_abone.SERVISE_VERILIS_TARIHI)|| ','||
    check_null(v_abone.IL_KODU)|| ','||
    check_null(v_abone.CAGRI_NO)|| ','||
    check_null(v_abone.HAREKET_IS_TURU)|| ','||
    check_null(v_abone.BASLANGIC_TARIHI)|| ','||
    check_null(v_abone.UZAK_MESAFE)|| ','||
    check_null(v_abone.TAMAMLANMA_ZAMANI)|| ','||
    check_null(v_abone.HEADER_ID)|| ','||
    check_null(v_abone.UPLOAD_HIZI_ORAN)|| ','||
    check_null(v_abone.MUDURLUK_KODU)|| ','||
    check_null(v_abone.SONLANMA_TARIHI)|| ','||
    check_null(v_abone.HAT_SAYISI)|| ','||
    check_null(v_abone.ISEMRI_GELIS_TARIHI)|| ','||
    check_null(v_abone.DOMAIN_ADI)|| ','||
    check_null(v_abone.KULLANICI_KIMLIK)|| ','||
    check_null(v_abone.DURUM)|| ','||
    check_null(v_abone.STATIK_IP)|| ','||
    check_null(v_abone.ANA_DEVRE_NO)|| ','||
    check_null(v_abone.HAREKET_ALT_IS_TURU)|| ','||
    check_null(v_abone.TESIS_BB_KODU)|| ','||
    check_null(v_abone.ACIKLAMA)|| ','||
    check_null(v_abone.KULLANICI_SAYISI)|| ','||
    check_null(v_abone.BELEDIYE_KODU)|| ','||
    check_null(v_abone.NUSHA_SAYISI)|| ','||
    check_null(v_abone.ESKI_ID)|| ','||
    check_null(v_abone.ENGELLI_INDIRIMI)|| ','||
    check_null(v_abone.XDSL_TIP_KODU)|| ','||
    check_null(v_abone.OM_TARIFE_ID)|| ','||
    check_null(v_abone.TOPLAMA_MERKEZI)|| ','||
    check_null(v_abone.KADEME)|| ','||
    check_null(v_abone.DONEM_ID)|| ','||
    check_null(v_abone.LOKASYON_ID)|| ','||
    check_null(v_abone.FIBER_MESAFE)|| ','||
    check_null(v_abone.REFERANS_HESAP_NO)|| ','||
    check_null(v_abone.DEVRE_OZELLIK)|| ','||
    check_null(v_abone.ILISKILI_HIZMET_NO)|| ','||
    check_null(v_abone.UST_HEADER_ID)|| ','||
    check_null(v_abone.DEVRE_KULLANIM_TIPI)|| ','||
    check_null(v_abone.URUN_SIPARIS_NO)|| ','||
    check_null(v_abone.XDSL_LAC_ID)|| ','||
    check_null(v_abone.TLAC_SERVICE_NUMBER)|| ','||
    check_null(v_abone.ALTYAPI_TIPI)|| ','||

    ')'
    );
END ;

SET SERVEROUTPUT ON;
EXEC test_datasi_dondurme(54263848127);

SELECT * FROM SMARTTBILL.ABONE_HAREKET WHERE ABONE_ID=54263848127;





