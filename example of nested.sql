set serveroutput on
DECLARE 
    TYPE employee_type is record 
    (
        adi employees.first_name%type,
        soyadi employees.last_name%type,
        siparis_adedi number,
        toplam_siparis_miktari number
    );
    
    v_employee employee_type;

BEGIN

    SELECT first_name, last_name, count(*) as siparis_adedi,
    sum(FREIGHT) as toplam_siparis_miktari
    into v_employee
    FROM EMPLOYEES E
    INNER JOIN ORDERS O ON E.EMPLOYEE_ID=O.EMPLOYEE_ID
    WHERE E.EMPLOYEE_ID=3
    GROUP BY first_name, last_name;
    
    DBMS_OUTPUT.PUT_LINE('first_name: ' || v_employee.adi);
    DBMS_OUTPUT.PUT_LINE('Last_name: ' || v_employee.soyadi);
    DBMS_OUTPUT.PUT_LINE('Count: ' || v_employee.siparis_adedi);
    DBMS_OUTPUT.PUT_LINE('Sum: ' || v_employee.toplam_siparis_miktari);

END;