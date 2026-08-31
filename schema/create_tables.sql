-- Dimension Tables
-- 1. Facility Dimension
Create table dim_facilities (
	facility_id serial primary key,
	license varchar(50),
	dba_name varchar(255),
	facility_type varchar(100),
	address varchar(255),
	city varchar(100),
	state varchar(10),
	zip varchar(10),
	latitude decimal(10, 6),
	longitude decimal(10, 6),
	location varchar(100),
	has_location boolean
);


-- 2. Inspection Type Dimension
create table dim_inspection_types (
	inspection_type_id serial primary key,
	inspection_type varchar(100) unique
);


-- 3. Violation Catalog Dimension
create table dim_violation_catalog (
	violation_code varchar(20),
	era varchar(20),
	violation_description varchar(500),
	primary key (violation_code, era)
);






-- Fact Tables 
-- 4. Inspections Fact Table
create table fact_inspections (
	inspection_id integer primary key,
	facility_id integer references dim_facilities(facility_id),
	inspection_type_id integer references dim_inspection_types(inspection_type_id),
	inspection_date date,
	risk varchar(50),
	results varchar(50)
);


-- 5. Inspection Violations Fact Detail
create table fact_inspection_violations (
	inspection_id integer references fact_inspections(inspection_id),
	violation_code varchar(20),
	era varchar(20),
	comments text,
	primary key (inspection_id, violation_code),
	foreign key (violation_code, era) references dim_violation_catalog(violation_code, era)
);

