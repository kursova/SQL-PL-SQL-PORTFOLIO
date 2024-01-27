
DECLARE
    a INTEGER :=0;

BEGIN 
    WHILE a<100 LOOP
        a:=a+1;
        IF MOD(a,5)!=0 THEN
            CONTINUE;
        END IF;
    DBMS_OUTPUT.PUT_LINE('a: ' || a);
    END LOOP;
END;


