-- 06_top_facility_risk_by_zip.sql
with risk_counts as (
    select 
        df.zip,
        df.facility_type,
        count(fi.inspection_id) as critical_failures
    from fact_inspections fi
    join dim_facilities df on fi.facility_id = df.facility_id
    where fi.results = 'Fail'
      and df.zip is not null
      and df.facility_type is not null
    group by 
        df.zip,
        df.facility_type
),
ranked_risks as (
    select 
        zip,
        facility_type,
        critical_failures,
        dense_rank() over(partition by zip order by critical_failures desc) as risk_rank
    from risk_counts
    where critical_failures > 0 
)
select 
        zip,
        facility_type,
        critical_failures,
        risk_rank
from ranked_risks
where risk_rank <= 3
order by 
    zip asc, 
    risk_rank asc;