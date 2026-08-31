-- 07_materialized_views.sql
create materialized view vw_monthly_seasonality as
select 
    to_char(fi.inspection_date, 'yyyy-mm') as inspection_month,
    dit.inspection_type,
    count(fi.inspection_id) as total_inspections,
    sum(case when lower(fi.results) = 'fail' then 1 else 0 end) as failures,
    round(sum(case when lower(fi.results) = 'fail' then 1 else 0 end) * 100.0 / count(fi.inspection_id), 2) as fail_rate_pct
from fact_inspections fi
join dim_inspection_types dit on fi.inspection_type_id = dit.inspection_type_id
where fi.inspection_date is not null
group by 
    to_char(fi.inspection_date, 'yyyy-mm'),
    dit.inspection_type;