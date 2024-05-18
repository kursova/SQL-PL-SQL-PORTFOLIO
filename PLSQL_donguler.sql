
---SEQUENCE OLUÞTURMA
CREATE SEQUENCE ea_seq_V2
START WITH 5
INCREMENT BY 1;

CREATE TABLE EA_70000_V2 AS
SELECT MUSTERI_ID, PAKET_ID, KURUM_ID, 0 AS ID FROM EA_70000_ABONE_BAZLI;

SELECT * FROM EA_70000_V2;

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