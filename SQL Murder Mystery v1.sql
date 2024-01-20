/*
A crime has taken place and the detective needs your help. 
The detective gave you the crime scene report, but you somehow lost it. 
You vaguely remember that the crime was a ?murder? that occurred sometime on ?Jan.15, 2018? and that it took place in ?SQL City?. 
Start by retrieving the corresponding crime scene report from the police department’s database.
*/

---firstly, Run this query to find the names of the tables in this database.

SELECT name 
FROM sqlite_master
WHERE type = 'table';

---now, we know the tables name's and we also know the crime was a murder that occurred sometime on ?Jan.15, 2018? and that it took place in ?SQL City. Let's check out crime_scene_report table 
-- and put these informations on our query.

SELECT *
FROM crime_scene_report
WHERE type='murder'
AND city='SQL City'
AND date=20180115; /*Security footage shows that there were 2 witnesses. The first witness lives at the last house on "Northwestern Dr". 
The second witness, named Annabel, lives somewhere on "Franklin Ave".*/


SELECT *
FROM (
		SELECT *
		FROM person 
		WHERE address_street_name='Northwestern Dr'
		ORDER BY address_number DESC
		LIMIT 1 ---this table gives us the first witness's informations
	  ) A
UNION 
SELECT *
FROM person 
WHERE address_street_name='Franklin Ave'
AND name LIKE '%Annabel%';--and this table gives as the second witness's informations

/* our suspects
id	    name	        license_id	address_number	address_street_name	ssn
14887	Morty Schapiro	118009	    4919	        Northwestern Dr	    111564949
16371	Annabel Miller	490173	    103	            Franklin Ave	    318771143
*/

SELECT  i.person_id, 
        p.name, 
        p.license_id, 
        i.transcript
FROM interview i
INNER JOIN person p on p.id=i.person_id
WHERE person_id in (14887, 16371);

/*
person_id	name	        license_id	transcript
14887	    Morty Schapiro	118009	    I heard a gunshot and then saw a man run out. He had a "Get Fit Now Gym" bag. The membership number on the bag started with "48Z". 
                                        Only gold members have those bags. The man got into a car with a plate that included "H42W".
16371	    Annabel Miller	490173	    I saw the murder happen, and I recognized the killer from my gym when I was working out last week on January the 9th.











