
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