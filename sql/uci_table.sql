drop table if exists uci_table;
create table uci_table(
id int,
name varchar(255),
data_types varchar(255),
default_task varchar(255),
attribute_types varchar(255),
number_of_instances float,
number_of_attributes float,
year float,
sample_size varchar(255)
);
select * from uci_table


--Distribution Analysis:

SELECT default_task,
COUNT(*) AS total_datasets,
ROUND(AVG(number_of_attributes::numeric), 1) AS avg_attributes,
ROUND(AVG(number_of_instances::numeric), 0) AS avg_instances
FROM uci_table
WHERE default_task <> 'Unknown'
GROUP BY default_task
ORDER BY total_datasets DESC
LIMIT 5;

--Temporal Analysis(Trends Over Time):

select year,
count(*) as datasets_published,
round(avg(number_of_attributes::numeric),1) as avg_attributes_per_year
from uci_table
where year is not null
group by year 
order by year asc;


-- Relational Analysis (Joining Structured Metrics with Text);

select 
    t.name,
    t.default_task,
    t.number_of_attributes,
    t.year,
    d.abstract
FROM uci_table t
JOIN uci_database d ON t.name = d.dataset
ORDER BY t.year DESC
LIMIT 10;



--  Ranking Datasets Within Each Task
select default_Task,
name,
number_of_attributes,
year,
ROW_NUMBER() over(partition by default_task order by number_of_attributes desc) as rank_in_task
from uci_table
where default_task <> 'Unknown' and number_of_attributes is not null;


--  Identifying Decade-Over-Decade Growth Trends:

select (Floor(year / 10) * 10)::int AS decade,
count(*) AS total_datasets_published,
round(avg(number_of_attributes::numeric), 1) as avg_attributes,
round(avg(number_of_instances::numeric), 0) as avg_instances
from uci_table
where year is not null
group by decade
order by decade ASC;

-- Text-Based Filtering via SQL
select 
    t.name,
    t.default_task,
    t.year,
    d.abstract
from uci_table t
join uci_database d on t.name= d.dataset
where d.abstract ILIKE '%health%' 
   or d.abstract ILIKE '%medical%'
order by t.year DESC;