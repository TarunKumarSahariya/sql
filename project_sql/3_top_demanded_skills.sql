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