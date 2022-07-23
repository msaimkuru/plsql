-- Takes 7.101 sec.
SELECT alpha_2_country_code, ANY_VALUE(country)
FROM saimk.TRASHBIGDATA
WHERE alpha_2_country_code LIKE 'A%'
GROUP BY alpha_2_country_code
;

--Takes 8.8 sec.
SELECT alpha_2_country_code, ANY_VALUE(country)
FROM saimk.TRASHBIGDATA
GROUP BY alpha_2_country_code
;

--Takes 7.288 sec.
SELECT alpha_2_country_code, country
FROM saimk.TRASHBIGDATA
WHERE alpha_2_country_code LIKE 'A%'
GROUP BY alpha_2_country_code, country
;

--Takes 8.81 sec.
SELECT alpha_2_country_code, country
FROM saimk.TRASHBIGDATA
GROUP BY alpha_2_country_code, country
;