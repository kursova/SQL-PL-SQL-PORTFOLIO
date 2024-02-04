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
*/

--- code of interviews

SELECT gf.*, dl.*
FROM get_fit_now_member gf
INNER JOIN person p on gf.person_id=p.id
INNER JOIN drivers_license dl ON dl.id=p.license_id
INNER JOIN get_fit_now_check_in gfn ON gfn.membership_id=gf.id
WHERE membership_status='gold'-- Morty Schapiro
AND gf.id LIKE '48Z%'-- Morty Schapiro
AND plate_number LIKE '%H42W%'-- Morty Schapiro
AND check_in_date=20180109;--Annabel Miller
/*


id	    person_id	name	        membership_start_date	membership_status	id      age	height	eye_color	hair_color	gender	plate_number	car_make	car_model
48Z55	67318	    Jeremy Bowers	20160101	            gold	            423327	30	70	    brown	    brown	    male	0H42W2	        Chevrolet	Spark L
*/

--interview of Jeremy Bowers

SELECT *
FROM interview
WHERE person_id=67318;

/*
person_id	transcript
67318	    I was hired by a woman with a lot of money. I don't know her name but I know she's around 5'5" (65") or 5'7" (67"). 
            She has red hair and she drives a Tesla Model S. I know that she attended the SQL Symphony Concert 3 times in December 2017.
*/

---Jeremy Bowers is the murderer. But who is behind him? Now, let's find the woman 

SELECT *
FROM drivers_license dr
INNER JOIN person p ON p.license_id=dr.id
INNER JOIN facebook_event_checkin fb ON fb.person_id=p.id 
--INNER JOIN interview i ON i.person_id=p.id
WHERE hair_color='red'
AND gender='female' 
AND car_make='Tesla'
AND car_model='Model S';--Miranda Priestly who we are looking for

INSERT INTO solution VALUES (1, 'Miranda Priestly');
        
        SELECT value FROM solution;
        
        /*
        value
Congrats, you found the brains behind the murder! Everyone in SQL City hails you as the greatest SQL detective of all time. Time to break out the champagne!
*/







