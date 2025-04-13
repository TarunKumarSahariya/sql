WITH skills_demand AS (
    SELECT 
        skills_job_dim.skill_id,
        skills_dim.skills,
        count(*) as jobs_available
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst' AND
        salary_year_avg IS NOT NULL
    GROUP BY
        skills_job_dim.skill_id,
        skills_dim.skills
), avg_salary AS (
    SELECT 
        skills_job_dim.skill_id,
        skills_dim.skills,
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
)

SELECT
    skills_demand.skill_id,
    skills_demand.skills,
    skills_demand.jobs_available,
    avg_salary.avg_salary_per_annum
FROM
    skills_demand
INNER JOIN
    avg_salary
ON skills_demand.skill_id = avg_salary.skill_id
ORDER BY
    skills_demand.jobs_available DESC,
    avg_salary.avg_salary_per_annum DESC
LIMIT 25

--rewriting the above but more concisely.

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