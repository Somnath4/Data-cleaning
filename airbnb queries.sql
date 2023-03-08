/* Let's see the data */
SELECT *
FROM airbnb
LIMIT 10;

/* Check duplicate values */
SELECT *
FROM(SELECT id,
            ROW_NUMBER() 
            OVER(
                  PARTITION BY `id` 
                  ORDER BY `id`
                  ) row_num 
		FROM airbnb) t
WHERE row_num = 2;

/* Delete duplicates from the TABLE */
DELETE FROM airbnb
WHERE id IN(SELECT id
						FROM(SELECT id,
										ROW_NUMBER() 
										OVER(
                                        PARTITION BY `id` 
										ORDER BY `id`
										) row_num 
								FROM airbnb) t
						WHERE row_num > 1);


/* Remove the '$'sign from price and service_fee column */
SELECT price
FROM (SELECT SUBSTRING_INDEX(price, '$', -1) price
      FROM airbnb) t;

SELECT service_fee
FROM (SELECT SUBSTRING_INDEX(service_fee, '$', -1) service_fee
      FROM airbnb) t;

/* Update the price and the service_fee columns */
UPDATE airbnb
SET price = SUBSTRING_INDEX(price, '$', -1);

UPDATE airbnb
SET service_fee = SUBSTRING_INDEX(service_fee, '$', -1);

      
/* Remove comma from price column before converting it to Decimal data type */
UPDATE airbnb 
SET price = REPLACE(price, ',', '');

/* Convert price and service_fee columns data type to Decimal from Varchar */
ALTER TABLE airbnb 
MODIFY price DECIMAL(10,2),
MODIFY service_fee DECIMAL(10,2);

/* Check total neighbourhood_group. We found that there are some spelling mistakes. */
SELECT neighbourhood_group, COUNT(neighbourhood_group)
FROM airbnb
GROUP BY neighbourhood_group;

/* Correct the spelling mistakes */
UPDATE airbnb
SET neighbourhood_group = REPLACE(neighbourhood_group,'brookln', 'Brooklyn')
WHERE neighbourhood_group = 'brookln';

UPDATE airbnb
SET neighbourhood_group = REPLACE(neighbourhood_group,'manhatan', 'Manhattan')
WHERE neighbourhood_group = 'manhatan';

/* Fill null values with NA values */
SELECT * 
FROM airbnb 
WHERE  neighbourhood_group IS NULL;

/* Check total neighbourhood_group */
SELECT neighbourhood_group, COUNT(neighbourhood_group)
FROM airbnb
GROUP BY neighbourhood_group;

/* Check total neighbourhood */
SELECT neighbourhood, COUNT(neighbourhood) 
FROM airbnb
GROUP BY neighbourhood;

/* We can fill null values in neighbourhood column */
SELECT neighbourhood_group, neighbourhood
FROM airbnb
WHERE neighbourhood IN ("Washington Heights",
                        'Clinton Hill',
                        'East Village',
                        'Upper East Side',
                        'Woodside',
                        'Williamsburg',
                        'Bushwick',
                        'Prospect Heights',
                        'Chelsea',
                        'East Harlem',
                        'Eastchester',
                        'Harlem',
                        'Chinatown',
                        'Queens Village',
                        'Bedford-Stuyvesant',
                        'Upper West Side');

/* Check null values in neighbourhood_group column */
SELECT neighbourhood_group, neighbourhood
FROM airbnb
WHERE neighbourhood_group IS NULL
GROUP BY neighbourhood;


/* Update/fill the null values in the neighhorhood_group column  */
UPDATE airbnb
SET neighbourhood_group = IFNULL(neighbourhood_group, 'Bronx')
WHERE neighbourhood = 'Eastchester';

UPDATE airbnb
SET neighbourhood_group = IFNULL(neighbourhood_group, 'Queens')
WHERE neighbourhood IN ('Queens Village', 
                        'Woodside');

UPDATE airbnb
SET neighbourhood_group = IFNULL(neighbourhood_group, 'Brooklyn')
WHERE neighbourhood IN ('Clinton Hill', 
                        'Williamsburg',
                        'Bedford-Stuyvesant', 
                        'Prospect Heights',
                        'Bushwick');

UPDATE airbnb
SET neighbourhood_group = IFNULL(neighbourhood_group, 'Manhattan')
WHERE neighbourhood IN ('Washington Heights',
                        'East Village',
                        'Upper East Side', 
                        'Chelsea',
                        'East Harlem', 
                        'Harlem',
                        'Chinatown', 
                        'Upper West Side');

/* Fill country and country code columns */
UPDATE airbnb
SET country = IFNULL(country, 'United States'),
    country_code = IFNULL(country_code, 'US');

/* Check for null values in other columns */
select 
      sum(case when NAME is null then 1 else 0 end) as NAME,
      sum(case when host_identity_verified is null then 1 else 0 end) as host_identity_verified,
      sum(case when host_name is null then 1 else 0 end) as host_name, 
      sum(case when neighbourhood is null then 1 else 0 end) as neighbourhood,
      sum(case when instant_bookable is null then 1 else 0 end) as instant_bookable, 
      sum(case when cancellation_policy is null then 1 else 0 end) as cancellation_policy,
      sum(case when room_type is null then 1 else 0 end) as roomtype,
      sum(case when price is null then 1 else 0 end) as price,
      sum(case when service_fee is null then 1 else 0 end) as service_fee,
      sum(case when number_of_reviews is null then 1 else 0 end) as number_of_reviews,
      sum(case when last_review is null then 1 else 0 end) as last_review,
      sum(case when reviews_per_month is null then 1 else 0 end) as reviews_per_month,
      sum(case when review_rate_number is null then 1 else 0 end) as review_rate_number,
      sum(case when calculated_host_listings_count is null then 1 else 0 end) as calculated_host_listings_count,
      sum(case when availability_365 is null then 1 else 0 end) as availability_365,
      sum(case when house_rules is null then 1 else 0 end) as house_rules
from airbnb;

/* Update null values with NA and 0 VALUES */
UPDATE airbnb
SET NAME = IFNULL(NAME, 'NA'),
    host_identity_verified = IFNULL(host_identity_verified, 'NA'),
    host_name = IFNULL(host_name, 'NA'),
    neighbourhood = IFNULL(neighbourhood, 'NA'),
    instant_bookable = IFNULL(instant_bookable, 'NA'),
    cancellation_policy = IFNULL(cancellation_policy, 'NA'),
    price = IFNULL(price, '0'),
    service_fee = IFNULL(service_fee, '0'),
    number_of_reviews = IFNULL(number_of_reviews, '0'),
    reviews_per_month = IFNULL(reviews_per_month, '0'),
    review_rate_number = IFNULL(review_rate_number, '0'),
    calculated_host_listings_count= IFNULL(calculated_host_listings_count, '0'),
    availability_365 = IFNULL(availability_365, '0'),
    house_rules = IFNULL(house_rules, 'NA');


/* Delete uuuse columns */
ALTER TABLE airbnb
DROP COLUMN country_code,
DROP COLUMN last_review,
DROP COLUMN license;

/* Check typographical errors */
SELECT *
FROM airbnb
WHERE house_rules LIKE "%ÔÇÖ%";

SELECT *
FROM airbnb
WHERE house_rules LIKE"%ÔÇØ%";

SELECT *
FROM airbnb
ORDER BY minimum_nights DESC;

/* Fix some typographical error in house rules columns*/
UPDATE airbnb
SET house_rules = REPLACE(house_rules, 'ÔÇó', '•')
WHERE house_rules LIKE '%ÔÇó%';
UPDATE airbnb
SET house_rules = REPLACE(house_rules, 'ÔÇô', '-')
WHERE house_rules LIKE '%ÔÇô%';

UPDATE airbnb
SET house_rules = REPLACE(house_rules, 'ÔÇ£', '“')
WHERE house_rules LIKE '%ÔÇ£%';

UPDATE airbnb
SET house_rules = REPLACE(house_rules, 'ÔÇØ', '”')
WHERE house_rules LIKE '%ÔÇØ%';