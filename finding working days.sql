

SELECT *
FROM DEV_HOLIDAY;

DECLARE 
v_baslangic_tarihi DATE := TO_DATE('19/04/2024', 'DD/MM/YYYY');
v_bitis_tarihi DATE := TO_DATE('20/05/2024', 'DD/MM/YYYY');
v_control BOOLEAN := TRUE;
v_holiday_control SMALLINT;
BEGIN
    WHILE v_control =TRUE LOOP
        v_baslangic_tarihi:=v_baslangic_tarihi+1;
        IF TO_CHAR(v_baslangic_tarihi, 'D') NOT IN (6,7) THEN 
            SELECT COUNT(*) INTO v_holiday_control 
            FROM DEV_HOLIDAY 
            WHERE HOLIDAY_DAY=TO_CHAR(v_baslangic_tarihi, 'DD')
            AND HOLIDAY_MONTH=TO_CHAR(v_baslangic_tarihi, 'MM');
            IF v_holiday_control =0 THEN 
                DBMS_OUTPUT.PUT_LINE ('Weekday: ' || v_baslangic_tarihi);
            ELSE 
                DBMS_OUTPUT.PUT_LINE ('Official Holiday: ' || v_baslangic_tarihi);
            END IF;
        
        ELSE 
            DBMS_OUTPUT.PUT_LINE ('Weekend: ' || v_baslangic_tarihi);
        END IF;
        
        IF v_baslangic_tarihi=v_bitis_tarihi THEN 
            v_control:=FALSE;
        END IF;
    END LOOP;
            
END;