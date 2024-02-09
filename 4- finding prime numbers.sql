SET SERVEROUTPUT ON 
DECLARE 
j NUMBER;
i NUMBER :=2;

BEGIN 
    LOOP
        j:=2;
        LOOP
            EXIT WHEN ((MOD(i,j)=0) OR  (j=i));
            j:=j+1;
        END LOOP;
        
        IF (j=i) THEN 
        DBMS_OUTPUT.PUT_LINE(i || ': is a prime number');
        END IF;
        
        i:=i+1;
        
        EXIT WHEN i=50;
    END LOOP;
END;
