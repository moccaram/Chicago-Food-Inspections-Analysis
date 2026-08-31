-- 1. Populate Inspection Types Dimension
Insert into dim_inspection_types (inspection_type)
select distinct inspection_type
from staging_inspections
where inspection_type is not null;

-- 2. Popuate Violation Catalog Dimension
insert into dim_violation_catalog (violation_code, era, violation_description)
select distinct violation_code, era, max(violation_description)
from staging_violations
where violation_code is not null
group by violation_code, era;


-- 3. Populate Facilities Dimension
insert into dim_facilities (license, dba_name, facility_type, address, city, state, zip, latitude, longitude, location, has_location)
select distinct on (license)
	license,
	dba_name,
	facility_type,
	address,
	city, 
	state,
	zip,
	latitude,
	longitude,
	location,
	has_location
from staging_inspections
where license is not null
order by license, inspection_date desc;



-- 4. Populate Inspections Fact Table
insert into fact_inspections (inspection_id, facility_id, inspection_type_id, inspection_date, risk, results)
select 
	s.inspection_id,
	f.facility_id,
	t.inspection_type_id,
	s.inspection_date,
	s.risk,
	s.results
from staging_inspections s
left join dim_facilities f on s.license = f.license
left join dim_inspection_types t on s.inspection_type = t.inspection_type;


-- 5. Populate Inspection Violations Fact Table 
insert into fact_inspection_violations (inspection_id, violation_code, era, comments)
select
	v.inspection_id,
	v.violation_code,
	v.era,
	v.comments
from staging_violations v
join fact_inspections f on v.inspection_id  = f.inspection_id
join dim_violation_catalog c on v.violation_code = c.violation_code and v.era = c.era
on conflict (inspection_id, violation_code) do nothing;



-- Verification
select 'dim_inspection_types' as table_name, count(*) as row_count from dim_inspection_types
union all
select 'dim_violation_catalog', count(*) from dim_violation_catalog
union all
select 'dim_facilities', count(*) from dim_facilities
union all
select 'fact_inspections', count(*) from fact_inspections
union all
select 'fact_inspection_violations', count(*) from fact_inspection_violations
order by row_count desc;