-- 03.fail_rate_by_zip.sql
select 
	df.zip,
	count(fi.inspection_id) as total_inspections,
	sum(case when fi.results = 'Fail' then 1 else 0 end) as failures,
	round(sum(case when fi.results = 'Fail' then 1 else 0 end) * 100.0 / count(fi.inspection_id), 2) as fail_rate_pct
from fact_inspections fi
join dim_facilities df on fi.facility_id = df.facility_id
where df.zip is not null
group by df.zip
having count(fi.inspection_id) >= 100
order by fail_rate_pct desc;