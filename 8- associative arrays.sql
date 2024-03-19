SELECT *
FROM (
SELECT V2.*, ROW_NUMBER() OVER(ORDER BY HESAP_ID, ABONE_ID, TAH_DONEM) AS ID 
FROM EA_710470_IADE_IPEK_V2 V2)
WHERE ID<=100;


  CREATE TABLE "AGILES"."GIZEM_DENEME"
   (	"HESAP_TURU" NUMBER, 
	"MUSTERI_ID" NUMBER, 
	"KURUM_ADI" VARCHAR2(250 BYTE), 
	"FATURA_ID" VARCHAR2(18 BYTE), 
	"FATURA_NO" VARCHAR2(13 BYTE), 
	"HESAP_ID" NUMBER, 
	"HIZMET_NO" VARCHAR2(20 BYTE), 
	"TAH_DONEM" NUMBER, 
	"ABONE_ID" NUMBER, 
	"TAAHHUT_BASLANGIC_TARIHI" DATE, 
	"TAAHHUT_BITIS_TARIHI" DATE, 
	"KAYNAK_UCRET_TURU_ID" NUMBER, 
	"FIBER_KAMPANYA_ID" NUMBER, 
	"OLMASI_GEREKEN_INDIRIM" NUMBER, 
	"UYGULANAN_INDIRIM" NUMBER, 
	"NOTLAR" VARCHAR2(97 BYTE), 
	"INDIRIM_BITIS_TARIHI" DATE,
    "ID" NUMBER
   ) ;
   
SELECT * FROM GIZEM_DENEME;

--collections
--associative arrays 
SET SERVEROUTPUT ON
DECLARE 
    type dep_type is table of GIZEM_DENEME%rowtype
    index by VARCHAR2(5);
    v_dept dep_type;
BEGIN
    SELECT * INTO v_dept(1) 
    FROM GIZEM_DENEME
    WHERE ID=1;
    dbms_output.put_line('FATURA_NO: ' || v_dept(1).fatura_no);
    dbms_output.put_line('ABONE_ID: '  || v_dept(1).abone_id);
    dbms_output.put_line('UYGULANAN_INDIRIM: ' || v_dept(1).uygulanan_indirim);
END;

---we can turn more than one rows in this example. normally, into turns one value. But we can use for loop to return more than one rows.
SET SERVEROUTPUT ON
DECLARE 
    type dep_type is table of GIZEM_DENEME%rowtype
    index by VARCHAR2(5);
    v_dept dep_type;
BEGIN
    for i in 0..10 loop
        SELECT * INTO v_dept(i+1) 
        FROM GIZEM_DENEME
        WHERE ID=i+1;
    end loop;
    
    for i in 0..10 loop 
        dbms_output.put_line('ID ' || v_dept(i+1).id);
        
    end loop;
END;
   
--associative arrays record
SET SERVEROUTPUT ON
DECLARE type per_info_type is record
    (
        id  pls_integer, --pls_integer is a data type just like number or date or varchar2. but it's more efficient than the number data type because it consumes a bit less space and is faster 
        name varchar2(30),
        salary number 
    );
    type personel_type is table of per_info_type
    index by pls_integer;
    
    v_pers personel_type;
    
    BEGIN
        v_pers(1).id:=10;
        v_pers(1).name:='Gizem';
        v_pers(1).salary:=5000;
        
        v_pers(2).id:=11;
        v_pers(2).name:='Gozde';
        v_pers(2).salary:=2000;
        
        dbms_output.put_line(v_pers(1).id || ' ' || v_pers(1).name || ' ' ||  v_pers(1).salary); 
        dbms_output.put_line(v_pers(2).id|| ' ' || v_pers(2).name  || ' '  || v_pers(2).salary);
        
    END;
    
    ---collection methods
    
  SET SERVEROUTPUT ON
DECLARE 
    TYPE country IS TABLE OF VARCHAR2(30)
    INDEX BY VARCHAR2(2);
    t_country country;
BEGIN
    t_country('TR'):='TURKIYE';
    t_country('US'):='AMERICA';
    t_country('DE'):='GERMANY';
    t_country('AU'):='AUSTRALIA';
    dbms_output.put_line(t_country.FIRST);
    dbms_output.put_line(t_country.LAST);
    dbms_output.put_line(t_country.PRIOR('TR'));
    dbms_output.put_line(t_country.COUNT);
    dbms_output.put_line(t_country.NEXT('UK'));
    t_country.DELETE('FR');
     dbms_output.put_line(t_country.COUNT);
     IF NOT t_country.EXISTS('FR') THEN 
           dbms_output.put_line('FR WAS DELETED');
    END IF;
END;
     
----collections with loop
SET SERVEROUTPUT ON
DECLARE 
    TYPE country IS TABLE OF VARCHAR2(30)
    INDEX BY VARCHAR2(2);
    t_country country;
    v_index varchar2(2) ;
    
BEGIN
    t_country('TR'):='TURKIYE';
    t_country('US'):='AMERICA';
    t_country('DE'):='GERMANY';
    t_country('AU'):='AUSTRALIA';
    
    v_index:=t_country.FIRST;
    
    WHILE v_index IS NOT NULL LOOP
    
    dbms_output.put_line(v_index || ': ' || t_country(v_index));
    v_index:=t_country.next(v_index);
     END LOOP;
END;
   
   
----


   