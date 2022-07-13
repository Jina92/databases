
Query 1:   	List all employers that have more than 2 positions available for software developers
-- more than: greater than ( '>' not '>=' )
SELECT e.EmployerId, e.Name, Count(JobId) as CNT
FROM employer e INNER JOIN job j 
ON e.EmployerId = j.EmployerId
WHERE j.Title LIKE '%Software Developer%'
GROUP BY EmployerId 
HAVING CNT > 2; 

Query 2: 	List all candidates that have more than 5 years’ experience in software testing
SELECT s.SeekerId, Name, k.Type, YearOfExperience, Email 
FROM seeker s INNER JOIN ownedSkill o INNER JOIN Skill k
ON s.SeekerId = o.SeekerId AND o.SkillId = k.SkillId
WHERE s.YearOfExperience >= 5 and k.Type LIKE '%Software Testing%'


Query 3: 	List all the positions available for software developers including the qualifications and years of experience required.    
SELECT j.JobId, j.title,  j.ReqYearOfExperience, q.Area, d.Type, j.salaryMin, j.salaryMax
FROM  job j INNER JOIN RequiredQualification rq INNER JOIN Qualification q INNER JOIN QualificationDegree d
ON j.JobId = rq.JobId AND rq.QualId = q.QualId AND rq.DegreeId = d.DegreeId
WHERE j.Title like '%Software Developer%'


Query 4:  	Display the ‘best fit’ list of candidates for a specific database analyst position

SELECT s.SeekerId, s.Name, s.JobId, s.Title,  o.SeekerId, o.Name, o.JobId, o.Title
FROM
( -- Compare Skill, Skill Area, Skill level between  job and seeker 
    SELECT s.SeekerId, s.Name, j.JobId, j.Title, SeekerSkillCNT
    FROM 
    (
        SELECT s.SeekerId, s.Name, COUNT(s.SeekerId) SeekerSkillCNT
        FROM
        (
            SELECT s.SeekerId, s.Name, a.SkillAreaId, k.SkillId, l.SkillLevelId
            FROM Seeker s INNER JOIN OwnedSkill os INNER JOIN Skill k INNER JOIN SkillArea a INNER JOIN SkillLevel l 
            ON s.SeekerId = os.SeekerId AND os.SkillId = k.SkillId AND k.SkillAreaId = a.SkillAreaId AND os.SkillLevelId = l.SkillLevelId
        ) s 
        RIGHT JOIN 
        ( 
            SELECT j.jobid, j.title, a.SkillAreaId, k.SkillId, l.SkillLevelId
            FROM
            ( SELECT * 
                FROM job  
                WHERE Title like '%Database Analyst%'  
                LIMIT 1  -- This can be changed into another WhERE clause, like " AND JobId = :jobid"
            ) j
            INNER JOIN RequiredSkill r INNER JOIN Skill k INNER JOIN SkillArea a INNER JOIN SkillLevel l 
                ON j.JobId = r.JobId AND r.SkillId = k.SkillId AND k.SkillAreaId = a.SkillAreaId AND r.SkillLevelId = l.SkillLevelId         
        ) j
        ON s.SkillAreaId = j.SkillAreaId AND s.SkillId = j.SkillId AND s.SkillLevelId >= j.SkillLevelId
        GROUP BY s.SeekerID
    ) s
    INNER JOIN 
    (
        SELECT COUNT(j.jobid) JobSkillCNT, j.jobid, j.title
        FROM
        ( SELECT * 
            FROM job  
            WHERE Title like '%Database Analyst%'  
            LIMIT 1  -- This can be changed into another WhERE clause, like " AND JobId = :jobid"
        ) j
        INNER JOIN RequiredSkill r INNER JOIN Skill k INNER JOIN SkillArea a INNER JOIN SkillLevel l 
            ON j.JobId = r.JobId AND r.SkillId = k.SkillId AND k.SkillAreaId = a.SkillAreaId AND r.SkillLevelId = l.SkillLevelId     
    ) j
    ON s.SeekerSkillCNT = j.JobSkillCNT
) s
INNER JOIN
( -- Compare Qualification, YearOfExperience, VisaId job and seeker
    SELECT s.SeekerId, s.Name, s.YearOfExperience, s.QualId, s.DegreeId,  s.VisaInfoId, 
    j.ReqYearOfExperience, j.ReqVisaId, j.JobId, j.Title
    FROM
    (
        SELECT s.SeekerId, s.Name, s.YearOfExperience, q.QualId, d.DegreeId,  ov.VisaInfoId
        FROM Seeker s INNER JOIN ownedqualification oq INNER JOIN qualification q INNER JOIN qualificationdegree d 
        ON s.SeekerId = oq.SeekerId AND oq.QualId = q.QualId AND oq.DegreeId = d.DegreeId 
        INNER JOIN ownedVisa ov
        ON s.SeekerId = ov.SeekerId 
    ) s 
    INNER JOIN 
    ( 
        SELECT j.jobid, j.title, j.ReqYearOfExperience, j.ReqVisaId, q.QualId, d.DegreeId
        FROM
        ( SELECT * 
            FROM job  
            WHERE Title like '%Database Analyst%'  
            LIMIT 1  -- This can be changed into another WhERE clause, like " AND JobId = :jobid"
        ) j
        INNER JOIN requiredqualification rq INNER JOIN qualification q INNER JOIN qualificationdegree d 
        ON j.JobId = rq.JobId AND rq.QualId = q.QualId AND rq.DegreeId = d.DegreeId      
    ) j
    ON s.QualId = j.QualId AND s.DegreeId >= j.DegreeId 
    WHERE s.YearOfExperience >= j.ReqYearOfExperience AND s.VisaInfoId >= j.ReqVisaId
) o 
ON s.SeekerId = o.SeekerId 





Query 5: 	Display the visa status for all web designers. Include the candidate name, surname and phone number. 

SELECT s.SeekerId, s.Name, s.JobId, s.Title, v.VisaInfoId, v.Type VisaType, s.PhoneNo -- o.SeekerId, o.Name, o.JobId, o.Title
FROM
( -- Compare Skill, Skill Area, Skill level
    SELECT s.SeekerId, s.Name, j.JobId, j.Title, SeekerSkillCNT, s.PhoneNo
    FROM 
    (
        SELECT s.SeekerId, s.Name, COUNT(s.SeekerId) SeekerSkillCNT, j.jobId, j.title, s.PhoneNo
        FROM
        (
            SELECT s.SeekerId, s.Name, a.SkillAreaId, k.SkillId, l.SkillLevelId, s.PhoneNo
            FROM Seeker s INNER JOIN OwnedSkill os INNER JOIN Skill k INNER JOIN SkillArea a INNER JOIN SkillLevel l 
            ON s.SeekerId = os.SeekerId AND os.SkillId = k.SkillId AND k.SkillAreaId = a.SkillAreaId AND os.SkillLevelId = l.SkillLevelId
        ) s 
        RIGHT JOIN 
        ( 
            SELECT j.jobid, j.title, a.SkillAreaId, k.SkillId, l.SkillLevelId
            FROM
            ( SELECT * 
                FROM job  
                WHERE Title like '%Web Design%'  
            ) j
            INNER JOIN RequiredSkill r INNER JOIN Skill k INNER JOIN SkillArea a INNER JOIN SkillLevel l 
                ON j.JobId = r.JobId AND r.SkillId = k.SkillId AND k.SkillAreaId = a.SkillAreaId AND r.SkillLevelId = l.SkillLevelId         
        ) j
        ON s.SkillAreaId = j.SkillAreaId AND s.SkillId = j.SkillId AND s.SkillLevelId >= j.SkillLevelId
        GROUP BY s.SeekerID, j.jobid
    ) s
    INNER JOIN 
    (
        SELECT COUNT(j.jobid) JobSkillCNT, j.jobid, j.title
        FROM
        ( SELECT * 
            FROM job  
            WHERE Title like '%Web Design%'  
        ) j
        INNER JOIN RequiredSkill r INNER JOIN Skill k INNER JOIN SkillArea a INNER JOIN SkillLevel l 
            ON j.JobId = r.JobId AND r.SkillId = k.SkillId AND k.SkillAreaId = a.SkillAreaId AND r.SkillLevelId = l.SkillLevelId 
        GROUP BY j.jobId  
    ) j
    ON s.SeekerSkillCNT = j.JobSkillCNT AND s.jobId = j.jobId
) s
INNER JOIN
( -- Compare Qualification, YearOfExperience, VisaId
    SELECT s.SeekerId, s.Name, s.YearOfExperience, s.QualId, s.DegreeId,  s.VisaInfoId, 
    j.ReqYearOfExperience, j.ReqVisaId, j.JobId, j.Title
    FROM
    (
        SELECT s.SeekerId, s.Name, s.YearOfExperience, q.QualId, d.DegreeId,  ov.VisaInfoId
        FROM Seeker s INNER JOIN ownedqualification oq INNER JOIN qualification q INNER JOIN qualificationdegree d 
        ON s.SeekerId = oq.SeekerId AND oq.QualId = q.QualId AND oq.DegreeId = d.DegreeId 
        INNER JOIN ownedVisa ov
        ON s.SeekerId = ov.SeekerId 
    ) s 
    INNER JOIN 
    ( 
        SELECT j.jobid, j.title, j.ReqYearOfExperience, j.ReqVisaId, q.QualId, d.DegreeId
        FROM
        ( SELECT * 
            FROM job  
            WHERE Title like '%Web Design%'  
        ) j
        INNER JOIN requiredqualification rq INNER JOIN qualification q INNER JOIN qualificationdegree d 
        ON j.JobId = rq.JobId AND rq.QualId = q.QualId AND rq.DegreeId = d.DegreeId      
    ) j
    ON s.QualId = j.QualId AND s.DegreeId >= j.DegreeId 
    WHERE s.YearOfExperience >= j.ReqYearOfExperience AND s.VisaInfoId >= j.ReqVisaId
) o 
ON s.SeekerId = o.SeekerId AND s.jobId = o.JobId
INNER JOIN OwnedVisa ov INNER JOIN VisaInfo v
ON s.SeekerId = ov.SeekerId AND ov.VisaInfoId = v.VisaInfoId






Query 6: 	List the position title, description, responsibilities, skills requirements, and years of experience, salary range, l.location, and contract type for all positions where the salary is over $150 000. Group the results by position type (contract type: Full-time, Casual, etc).

SELECT  e.Name EmployerName, o.Name OrganName, jobId, title, ContractType, Skills, p.suburb, g.State, g.Country, j.Description, j.Responsibilities
FROM (
    SELECT  jobId, title, group_concat(Type, '(', Skill, ')' SEPARATOR ', ') Skills, EmployerId, PostLocalId, ContractType, Description, Responsibilities
    FROM (
        SELECT j.JobId, j.title, j.ReqYearOfExperience, 
        j.salaryMin, j.salaryMax, j.ContractType, j.PostLocalId, j.EmployerId, j.Description, j.Responsibilities, 
        a.Type, group_concat(k.Type, ':', l.Type SEPARATOR ', ') Skill
        FROM job j INNER JOIN RequiredSkill r INNER JOIN Skill k INNER JOIN SkillArea a INNER JOIN SkillLevel l 
        ON j.JobId = r.JobId AND r.SkillId = k.SkillId AND k.SkillAreaId = a.SkillAreaId AND r.SkillLevelId = l.SkillLevelId
        WHERE SalaryMin > 150000 or SalaryMax > 15000 
        GROUP BY j.JobId, a.SkillAreaId
    ) j
	GROUP BY JobId
) j
INNER JOIN PostLocal p INNER JOIN PostGlobal g
ON j.PostLocalId = p.PostLocalId AND p.PostGlobalId = g.PostGlobalId 
INNER JOIN Employer e INNER JOIN Organisation o
ON e.EmployerId = j.EmployerId AND e.OrganId = o.OrganId
ORDER BY ContractType

SELECT  e.name EmployerName, ContractType, count(*) CNT
FROM (
    SELECT  jobId, title, group_concat(Type, '(', Skill, ')' SEPARATOR ', ') Skills, EmployerId, PostLocalId, ContractType, Description, Responsibilities
    FROM (
        SELECT j.JobId, j.title, j.ReqYearOfExperience, 
        j.salaryMin, j.salaryMax, j.ContractType, j.PostLocalId, j.EmployerId, j.Description, j.Responsibilities, 
        a.Type, group_concat(k.Type, ':', l.Type SEPARATOR ', ') Skill
        FROM job j INNER JOIN RequiredSkill r INNER JOIN Skill k INNER JOIN SkillArea a INNER JOIN SkillLevel l 
        ON j.JobId = r.JobId AND r.SkillId = k.SkillId AND k.SkillAreaId = a.SkillAreaId AND r.SkillLevelId = l.SkillLevelId
        WHERE SalaryMin > 150000 or SalaryMax > 15000 
        GROUP BY j.JobId, a.SkillAreaId
    ) j
	GROUP BY JobId
) j
INNER JOIN PostLocal p INNER JOIN PostGlobal g
ON j.PostLocalId = p.PostLocalId AND p.PostGlobalId = g.PostGlobalId 
INNER JOIN Employer e INNER JOIN Organisation o
ON e.EmployerId = j.EmployerId AND e.OrganId = o.OrganId
GROUP BY e.EmployerId, ContractType 

