SELECT *
FROM DS_SALARIES;--MY ALL DATA: 3755  Rows
--- test
---DESCRIBE DS_SALARIES TABLE 
DESCRIBE DS_SALARIES;
/*
Name               Null? Type          
------------------ ----- ------------- 
WORK_YEAR                NUMBER(38)    
EXPERIENCE_LEVEL         VARCHAR2(26)  
EMPLOYMENT_TYPE          VARCHAR2(26)  
JOB_TITLE                VARCHAR2(128) 
SALARY                   NUMBER(38)    
SALARY_CURRENCY          VARCHAR2(26)  
SALARY_IN_USD            NUMBER(38)    
EMPLOYEE_RESIDENCE       VARCHAR2(26)  
REMOTE_RATIO             NUMBER(38)    
COMPANY_LOCATION         VARCHAR2(26)  
COMPANY_SIZE             VARCHAR2(26)  
*/



--NULL VALUES CONTROL
SELECT  t.column_name
FROM    user_tab_columns t
WHERE   t.nullable = 'Y'
        AND t.table_name = 'DS_SALARIES'
        AND t.num_distinct = 0;---THERE IS NO NULL VALUE
        
---EXPERIENCE_LEVEL CONTROL
SELECT  EXPERIENCE_LEVEL,
        COUNT(*),
        ROUND(COUNT(*)*100/SUM(COUNT(*)) OVER (),2) AS PERCENTAGE --YOU CAN FIND PERCENTAGE VALUES USING OVER FUNCTION
FROM DS_SALARIES
GROUP BY EXPERIENCE_LEVEL;
/*
EX(DIRECTOR)	    %3,04
SE(EXPERT)  	    %67
MI(INTERMEDIATE)	%21,44
EN(JUNIOR)      	%8,52
we observe that Senior-level/Expert accounts for the highest.
*/

--HOW MANY JOB TITLE EXIST?
SELECT DISTINCT JOB_TITLE
FROM DS_SALARIES;--93  Rows

SELECT  JOB_TITLE,
        COUNT(*)
FROM DS_SALARIES
GROUP BY JOB_TITLE
ORDER BY COUNT(*) DESC;--Data Engineer, Data Scientist are the top 2 as usual, followed by Data Analyst and Machine Learning Engineer.

---EMPLOYMENT TYPE 

SELECT  EMPLOYMENT_TYPE, 
        COUNT(*), 
        ROUND(COUNT(*) * 100/(SELECT COUNT(*) FROM DS_SALARIES),2)--YOU CAN ALSO FIND PERCENTAGE USING SUBQUERY
FROM DS_SALARIES  
GROUP BY EMPLOYMENT_TYPE; --Almost the entirety of employee type is full-time.(%99)

----RELATION BETWEEN EMPLOYEE_RESIDENCE AND COMPANY_LOCATION 

SELECT COMPANY_LOCATION, EMPLOYEE_RESIDENCE, COUNT(*)
FROM DS_SALARIES
GROUP BY COMPANY_LOCATION, EMPLOYEE_RESIDENCE 
ORDER BY COUNT(*) DESC;--MOST OF THE EMPLOYEES LIVE USA FOLLOWED BY GB.

---SALARY IN USD
---I WANT TO FIND EVERY YEAR'S HIGHEST SALARY IN USD 
SELECT *
FROM    (SELECT DS.*,
        ROW_NUMBER() OVER (PARTITION BY WORK_YEAR, JOB_TITLE ORDER BY SALARY_IN_USD DESC) AS SEQ
        FROM DS_SALARIES DS) DS
WHERE SEQ=1
ORDER BY WORK_YEAR, SALARY_IN_USD DESC;
/*IN 2020 THE JOB TITLE OF HIGHEST SALARY IN USD IS RESEARCH SCIENTIST WHICH IS 450000 USD
IN 2021 Applied Machine Learning Scientist SALARY IN USD:423000
IN 2022 Data Analyst SALARY IN USD:430967
IN 2023 AI Scientist SALARY IN USD:423834 */

