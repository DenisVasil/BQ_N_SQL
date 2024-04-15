#Active mandates by industry

SELECT COUNT(DISTINCT(p.mandate_id)) AS Active, o.parent_vertical
FROM `gc_paysvc_live.payments` p
JOIN `gc_paysvc_live.mandates` m
ON p.mandate_id=m.id
JOIN `gc_paysvc_live.organisations` o
ON m.organisation_id=o.id
GROUP BY o.parent_vertical
ORDER BY COUNT(p.mandate_id);


# Total Mandates by industry

SELECT COUNT(m.id) AS Total, o.parent_vertical
FROM `gc_paysvc_live.mandates` m
JOIN `gc_paysvc_live.organisations` o
ON m.organisation_id=o.id
GROUP BY o.parent_vertical
ORDER BY COUNT(m.id);


#Number of organizations by industry

SELECT parent_vertical, COUNT(*)
FROM `gc_paysvc_live.organisations`
GROUP BY parent_vertical;

#Dates
SELECT id, created_at
FROM `gc_paysvc_live.mandates`
ORDER BY created_at;

SELECT id, created_at
FROM `gc_paysvc_live.organisations`
ORDER BY created_at;

SELECT id, created_at
FROM `gc_paysvc_live.payments`
ORDER BY created_at;

#Number of payments by each mandate after december

SELECT COUNT(*), mandate_id
FROM `gc_paysvc_live.payments`
WHERE created_at > '2018-12-01'
GROUP BY mandate_id

#Number of pyments by the same customers after december campaign

SELECT COUNT(*) AS muber_of_mandates, mandate_id
FROM `gc_paysvc_live.payments`
WHERE created_at > '2018-12-01'AND mandate_id IN (SELECT mandate_id FROM
`gc_paysvc_live.payments` WHERE created_at < '2018-12-01')
GROUP BY mandate_id;

#variant 2
SELECT COUNT(*) AS muber_of_mandates, mandate_id
FROM `gc_paysvc_live.payments`
WHERE created_at > '2018-12-01'
GROUP BY mandate_id
HAVING mandate_id IN (SELECT mandate_id FROM
`gc_paysvc_live.payments` WHERE created_at < '2018-12-01')

#average

WITH average_m AS(
SELECT COUNT(*) AS muber_of_mandates, mandate_id
FROM `gc_paysvc_live.payments`
WHERE created_at > '2018-12-01'
GROUP BY mandate_id
HAVING mandate_id IN (SELECT mandate_id FROM
`gc_paysvc_live.payments` WHERE created_at < '2018-12-01')
)

SELECT AVG(muber_of_mandates)
FROM average_m

#Sum customers by industry after ad

WITH average_m AS(
SELECT COUNT(*) AS muber_of_mandates, mandate_id
FROM `gc_paysvc_live.payments`
WHERE created_at > '2018-12-01'
GROUP BY mandate_id
HAVING mandate_id IN (SELECT mandate_id FROM
`gc_paysvc_live.payments` WHERE created_at < '2018-12-01')
)

SELECT SUM(muber_of_mandates) AS cust_by_ind, o.parent_vertical
FROM average_m a
JOIN `gc_paysvc_live.mandates` m
ON a.mandate_id=m.id
JOIN `gc_paysvc_live.organisations` o
ON m.organisation_id=o.id
GROUP BY o.parent_vertical
ORDER BY COUNT(a.mandate_id)

#sum customers by industry befoe ad

WITH average_m AS(
SELECT COUNT(*) AS muber_of_mandates, mandate_id
FROM `gc_paysvc_live.payments`
WHERE created_at < '2018-12-01'
GROUP BY mandate_id
HAVING mandate_id IN (SELECT mandate_id FROM
`gc_paysvc_live.payments` WHERE created_at > '2018-12-01')
)

SELECT SUM(muber_of_mandates) AS cust_by_ind, o.parent_vertical
FROM average_m a
JOIN `gc_paysvc_live.mandates` m
ON a.mandate_id=m.id
JOIN `gc_paysvc_live.organisations` o
ON m.organisation_id=o.id
GROUP BY o.parent_vertical
ORDER BY COUNT(a.mandate_id)

#Sales amount before

WITH average_m AS(
SELECT COUNT(*) AS muber_of_mandates, mandate_id, SUM(amount) AS total_a
FROM `gc_paysvc_live.payments`
WHERE created_at < '2018-12-01'
GROUP BY mandate_id
HAVING mandate_id IN (SELECT mandate_id FROM
`gc_paysvc_live.payments` WHERE created_at > '2018-12-01')
)

SELECT SUM(muber_of_mandates) AS cust_by_ind, o.parent_vertical, SUM(a.total_a) AS Amount
FROM average_m a
JOIN `gc_paysvc_live.mandates` m
ON a.mandate_id=m.id
JOIN `gc_paysvc_live.organisations` o
ON m.organisation_id=o.id
GROUP BY o.parent_vertical
ORDER BY COUNT(a.mandate_id)

#Sales amount after

WITH average_m AS(
SELECT COUNT(*) AS muber_of_mandates, mandate_id, SUM(amount) AS total_a
FROM `gc_paysvc_live.payments`
WHERE created_at > '2018-12-01'
GROUP BY mandate_id
HAVING mandate_id IN (SELECT mandate_id FROM
`gc_paysvc_live.payments` WHERE created_at < '2018-12-01')
)

SELECT SUM(muber_of_mandates) AS cust_by_ind, o.parent_vertical, SUM(a.total_a) AS Amount
FROM average_m a
JOIN `gc_paysvc_live.mandates` m
ON a.mandate_id=m.id
JOIN `gc_paysvc_live.organisations` o
ON m.organisation_id=o.id
GROUP BY o.parent_vertical
ORDER BY COUNT(a.mandate_id)

#overall
SELECT COUNT(*) as number, SUM(amount) as total
FROM `gc_paysvc_live.payments`
WHERE created_at < '2018-12-01';

SELECT COUNT(*) as number, SUM(amount) as total
FROM `gc_paysvc_live.payments`
WHERE created_at > '2018-12-01';

#total vs active mandates by source

SELECT COUNT(DISTINCT(p.mandate_id)) AS Active, p.source
FROM `gc_paysvc_live.payments` p
JOIN `gc_paysvc_live.mandates` m
ON p.mandate_id=m.id
GROUP BY p.source
ORDER BY COUNT(p.mandate_id);

SELECT COUNT(m.id) AS Total, p.source
FROM `gc_paysvc_live.mandates` m
JOIN `gc_paysvc_live.payments` p
ON p.mandate_id=m.id
GROUP BY p.source
ORDER BY COUNT(m.id);

#the table

SELECT  m.id AS mandate_ID, m.scheme, p.source, o.id AS Organization_ID, o.created_at AS Org_Signup, o.parent_vertical
FROM `gc_paysvc_live.payments` p
JOIN `gc_paysvc_live.mandates` m
ON p.mandate_id=m.id
JOIN `gc_paysvc_live.organisations` o
ON m.organisation_id=o.id
ORDER BY o.created_at