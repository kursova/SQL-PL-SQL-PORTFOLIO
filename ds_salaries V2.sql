SELECT *
FROM DS_SALARIES;--MY ALL DATA: 3755  Rows

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

SELECT JOB_TITLE,COUNT(*)
FROM DS_SALARIES
GROUP BY JOB_TITLE
ORDER BY COUNT(*) DESC;--Data Engineer, Data Scientist are the top 2 as usual, followed by Data Analyst and Machine Learning Engineer.

---EMPLOYMENT TYPE 

SELECT 
FROM DS_SALARIES
WHERE EMPLOYMENT_TYPE
