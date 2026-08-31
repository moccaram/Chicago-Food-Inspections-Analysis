-- 04_top_violations_by_month.sql
select 
    to_char(fi.inspection_date, 'YYYY-MM') as inspection_month,
    dvc.violation_code,
    dvc.violation_description,
    count(fiv.violation_code) as violation_count
from fact_inspections fi
join fact_inspection_violations fiv on fi.inspection_id = fiv.inspection_id
join dim_violation_catalog dvc on fiv.violation_code = dvc.violation_code and fiv.era = dvc.era
where fi.inspection_date is not null
group by 
    to_char(fi.inspection_date, 'YYYY-MM'),
    dvc.violation_code,
    dvc.violation_description
order by 
    inspection_month desc,
    violation_count desc; 