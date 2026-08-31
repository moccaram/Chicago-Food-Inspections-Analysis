-- 01_fail_rate_by_month.sql
select 
	to_char(fi.inspection_date, 'YYYY-MM') as inspection_month,
	dit.inspection_type,
	count(fi.inspection_id) as total_inspections,
	sum(case when fi.results = 'Fail' then 1 else 0 end) as failures,
	round(sum(case when fi.results = 'Fail' then 1 else 0 end) * 100.0 / count(fi.inspection_id), 2) as fail_rate_pct
from fact_inspections fi 
join dim_inspection_types dit on fi.inspection_type_id = dit.inspection_type_id
where fi.inspection_date is not null
group by 
	to_char(fi.inspection_date, 'YYYY-MM'),
	dit.inspection_type
order by
	inspection_month desc,
	total_inspections desc;
	