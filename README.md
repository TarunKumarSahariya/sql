# Introduction
This is my first SQL project, where I  have tried to get the idea of the job market! I have majorly focused on Data Analyst roles. This project explores top-paying jobs, top-paying skills, top-demanded skills, top-paying skills & lastly the optimal skills(Ones which have high demand & also provide high pay) in Data Analytics.

Check-out the SQL queries here: [project_sql folder](/project_sql/)

# Background
I wanted to make this project to apply whatever I have learned so far in SQL. This project aims to find out the kind of jobs to look out for if you are into Data Analytics, the kind of skills to learn, what skills are in demand and how much they pay on an average.

The datasets used are from [SQL Course by 
Luke Barousse](https://www.lukebarousse.com/sql)

### The questions which I wanted to answer:-
1. What are the top paying data-analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data-analytics?
4. Which skills are associated with higher salaries?
5. What are the most optimum skills to learn?
# Tools used
- **SQL**: All of my queries are in SQL, it allowed me to get sharp insights.
- **PostgreSQL**: This was my database management system.
- **Visual Studio Code**: It doesn't need to be explined, it's the go-to text-editor.
- **Git & Github**: Essential for version control & sharing my SQL scripts & analysis, ensuring collboration & project tracking.

# The Analysis
Each query provides insights at specific aspects of the data-analyst job market.

### 1. Top paying Data Analysis jobs
I identified the high paying jobs in India for data analysis by filtering the data by the job title, job location & salary year average columns.

```sql
SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM
    job_postings_fact
LEFT JOIN
    company_dim
ON
    job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location LIKE '%India' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10
```

Here's the breakdown of the top data analyst jobs in 2023:-

- **Wide Salary Range**: Top 10 paying data analyst roles span from $184,000 to $650,000, indicating significant salary potential in the field.

- **Diverse Employers**: Companies like SmartAsset, Meta, and AT&T are among those offering high salaries, showing a broad interest across different industries.

- **Job Title Variety**: There's a high diversity in job titles, from Data Analyst to Director of Analytics, reflecting varied roles and specializations within data analytics.

![top_paying_jobs](assets\top_paying_jobs.png)
*Bar graph visualizing the top 10 paying job roles for data analysts according to the yearly salary; ChatGPT generated this graph from my SQL query results*

### 2. Skills for Top Paying Jobs
To understand what skills are required for the top-paying jobs, I joined the job postings with the skills data, providing insights into what employers value for high-compensation roles.
```sql
WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        salary_year_avg,
        name AS company_name
    FROM
        job_postings_fact
    LEFT JOIN
        company_dim
    ON
        job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Analyst' AND
        job_location LIKE '%India' AND
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)

SELECT 
    top_paying_jobs.*,
    skills_dim.skills
FROM
    top_paying_jobs
INNER JOIN
    skills_job_dim
ON
    top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN
    skills_dim
ON
    skills_job_dim.skill_id = skills_dim.skill_id
```
Here's the breakdown of the most demanded skills for the top 10 highest paying data analyst jobs in 2023:-
- **SQL** and **Python** appear in almost every high-paying job, signaling core demand.

- Cloud platforms like **Azure** and **AWS**, as well as modern data tools like **MongoDB**, **Databricks**, and **Snowflake**, are highly valued.

![top_paying_roles_skills](assets\top_paying_roles_skills.png)
*Bar graph visualizing the count of skills for the top 10 paying jobs for data analysts; ChatGPT generated this graph from my SQL query results*

### 3. In-Demand Skills for Data Analysts

This query helped identify the skills most frequently requested in job postings, directing focus to areas with high demand.

```sql
SELECT 
    skills_dim.skills,
    count(*) as jobs_available
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location LIKE '%India'
GROUP BY
    skills_dim.skills
ORDER BY
    jobs_available DESC
LIMIT 5
```
Here's the breakdown of the most demanded skills for data analysts in 2023 in India.
- **SQL** and **Python** remain fundamental, emphasizing the need for strong foundational skills in data processing and spreadsheet manipulation.

| Skills   | Demand Count |
|----------|--------------|
| SQL      | 2561         |
| Python   | 1802         |
| Excel    | 1718         |
| Tableau  | 1346         |
| Power BI | 1043         |

*Table of the demand for the top 5 skills in data analyst job postings in India*

### 4. Skills Based on Salary
Exploring the average salaries associated with different skills, revealed which skills are the highest paying.
```sql
SELECT 
    skills_dim.skills,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary_per_annum
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL AND
    job_location LIKE '%India'
GROUP BY
    skills_dim.skills
ORDER BY
    avg_salary_per_annum DESC
LIMIT 5
```
Here's a breakdown of the results for top paying skills for Data Analysts:
**PostgreSQL**, **MySQL** are the amongst the top when it comes to relational database management systems which are usually run on operating systems like **Linux** which is also among the top skills.
**gitlab** is highly valued skill for version control, CI/CD (Continuous Integration/Continuous Deployment), and collaboration on code repositories.
**Pyspark** A Python API for Apache Spark used for big data processing and machine learning.

### 5. Most Optimal Skills to Learn

Combining insights from demand and salary data, this query aimed to pinpoint skills that are both in high demand and have high salaries, offering a strategic focus for skill development.

```sql
SELECT
    skills_job_dim.skill_id,
    skills_dim.skills,
    COUNT(*) as jobs_available,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary_per_annum
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL
GROUP BY
    skills_job_dim.skill_id,
    skills_dim.skills
HAVING 
    COUNT(*) > 10
ORDER BY
    avg_salary_per_annum DESC,
    jobs_available DESC
LIMIT 25
```

| skill_id | skills | jobs_available | avg_salary_per_annum |
|----------|--------|----------------|----------------------|
| 98 | kafka | 40 | 129,999 |
| 101 | pytorch | 20 | 125,226 |
| 31 | perl | 20 | 124,686 |
| 99 | tensorflow | 24 | 120,647 |
| 63 | cassandra | 11 | 118,407 |
| 219 | atlassian | 15 | 117,966 |
| 96 | airflow | 71 | 116,387 |
| 3 | scala | 59 | 115,480 |
| 169 | linux | 58 | 114,883 |
| 234 | confluence | 62 | 114,153 |
| 95 | pyspark | 49 | 114,058 |
| 18 | mongodb | 26 | 113,608 |
| 62 | mongodb | 26 | 113,608 |
| 81 | gcp | 78 | 113,065 |
| 92 | spark | 187 | 113,002 |
| 193 | splunk | 15 | 112,928 |
| 75 | databricks | 102 | 112,881 |
| 210 | git | 74 | 112,250 |
| 80 | snowflake | 241 | 111,578 |
| 6 | shell | 44 | 111,496 |
| 168 | unix | 37 | 111,123 |
| 97 | hadoop | 140 | 110,888 |
| 93 | pandas | 90 | 110,767 |
| 137 | phoenix | 23 | 109,259 |
| 25 | php | 29 | 109,052 |

*Table of the most optimal skills for data analyst sorted by salary*


# What I Learned

Throughout this adventure, I've turbocharged my SQL toolkit with some serious firepower:

- **🧩 Complex Query Crafting:** Mastered the art of advanced SQL, merging tables like a pro and wielding WITH clauses for ninja-level temp table maneuvers.
- **📊 Data Aggregation:** Got cozy with GROUP BY and turned aggregate functions like COUNT() and AVG() into my data-summarizing sidekicks.
- **💡 Analytical Wizardry:** Leveled up my real-world puzzle-solving skills, turning questions into actionable, insightful SQL queries.

# Conclusions

### Insights
From the analysis, several general insights emerged:

1. **Top-Paying Data Analyst Jobs**: The highest-paying jobs for data analysts that allow remote work offer a wide range of salaries, the highest at $650,000!
2. **Skills for Top-Paying Jobs**: High-paying data analyst jobs require advanced proficiency in SQL, suggesting it’s a critical skill for earning a top salary.
3. **Most In-Demand Skills**: SQL is also the most demanded skill in the data analyst job market, thus making it essential for job seekers.
4. **Skills with Higher Salaries**: Specialized skills, such as SVN and Solidity, are associated with the highest average salaries, indicating a premium on niche expertise.
5. **Optimal Skills for Job Market Value**: SQL leads in demand and offers for a high average salary, positioning it as one of the most optimal skills for data analysts to learn to maximize their market value.

### Closing Thoughts

This project enhanced my SQL skills and provided valuable insights into the data analyst job market. The findings from the analysis serve as a guide to prioritizing skill development and job search efforts. Aspiring data analysts can better position themselves in a competitive job market by focusing on high-demand, high-salary skills. This exploration highlights the importance of continuous learning and adaptation to emerging trends in the field of data analytics.

