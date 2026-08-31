-- 02_fail_rate_by_facility.sql
select 
	df.facility_type,
	count(fi.inspection_id) as total_inspections,
	sum(case when fi.results = 'Fail' then 1 else 0 end) as failures,
	round(sum(case when fi.results = 'Fail' then 1 else 0 end) * 100.0 / count(fi.inspection_id), 2) as fail_rate_pct
from fact_inspections fi
join dim_facilities df on fi.facility_id = df.facility_id
where df.facility_type is not null
group by df.facility_type
having count(fi.inspection_id) >= 100
order by fail_rate_pct desc;