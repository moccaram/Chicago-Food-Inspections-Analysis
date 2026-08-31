-- 05_repeat_offenders_window.sql
with inspection_history as (
    select 
        df.license,
        df.dba_name,
        fi.inspection_date,
        fi.results,
        dit.inspection_type,
        lag(fi.results) over(partition by df.license order by fi.inspection_date) as prev_result,
        lag(fi.inspection_date) over(partition by df.license order by fi.inspection_date) as prev_date
    from fact_inspections fi
    join dim_facilities df on fi.facility_id = df.facility_id
    join dim_inspection_types dit on fi.inspection_type_id = dit.inspection_type_id
    where fi.inspection_date is not null
)
select 
    license,
    dba_name,
    prev_date as first_fail_date,
    inspection_date as consecutive_fail_date,
    (inspection_date - prev_date) as days_between_fails,
    inspection_type
from inspection_history
where results = 'Fail' and prev_result = 'Fail' and (inspection_date - prev_date) > 0
order by days_between_fails asc, consecutive_fail_date desc;