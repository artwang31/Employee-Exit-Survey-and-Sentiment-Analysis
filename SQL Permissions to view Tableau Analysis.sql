SELECT DISTINCT A.EmployeeKey,
		A.JobTitle,
		B.WinNT_ID AS ADUserName,
		C.Division,
		B.Department
    FROM [HRISStaged].[dbo].[EmployeeJobTitle] A
    LEFT JOIN [MasterData].[dbo].[ADAccounts] B ON A.EmployeeKey = B.EmployeeID --Using LEFT JOIN because we know we have missing data fields
    CROSS JOIN [HRISStaged].[dbo].[EmployeeCorpGroup_Pivoted] C
    LEFT JOIN [HRISStaged].[dbo].[EmployeeStatus] D ON A.EmployeeKey = D.EmployeeKey
    WHERE D.StatusName = 'Active' AND
          (A.JobTitle = 'Associate Regional Superintendent' OR
	  A.JobTitle = 'Executive' OR
          A.JobTitle = 'Regional Superintendent' OR
          A.JobTitle = 'Regional Director' OR
	  A.EmployeeKey = '105893' OR
	  A.EmployeeKey = 'EBMFH2N9Q'  OR
	  A.EmployeeKey = '105895'  OR
	  A.EmployeeKey = '102628'  OR
	  A.EmployeeKey = 'PRUW3DISZ')
UNION
SELECT A.EmployeeKey,
       A.JobTitle,
       B.WinNT_ID AS ADUserName,
       C.Division,
       B.Department
    FROM [HRISStaged].[dbo].[EmployeeJobTitle] A
    LEFT JOIN [MasterData].[dbo].[ADAccounts] B ON A.EmployeeKey = B.EmployeeID --Using LEFT JOIN because we know we have missing data fields
    LEFT JOIN [HRISStaged].[dbo].[EmployeeCorpGroup_Pivoted] C ON A.EmployeeKey = C.EmployeeKey
    LEFT JOIN [HRISStaged].[dbo].[EmployeeStatus] D ON A.EmployeeKey = D.EmployeeKey
    WHERE D.StatusName = 'Active' AND
          (A.JobTitle LIKE '%Principal%' OR
          A.JobTitle LIKE '%Dean%' OR
          A.JobTitle = 'Director of School Operations')
UNION
SELECT DISTINCT A.EmployeeKey,
		A.JobTitle,
		B.WinNT_ID as ADUserName,
		--- Use Employee ID to add an exceptions school ---
		--- User below as template - paste in new line below green line below ---
		--- WHEN b.EmployeeID = '101747' THEN 'AF Amistad HS' ---
		CASE
                    WHEN B.EmployeeID = 'VV5KV1Q1E' THEN 'Company A'
                    --- Paste new exceptions here ---
                    WHEN B.EmployeeID = '101705' THEN 'Company B'
                    ELSE C.Division
                END AS Division,
		C.Division as Department
	FROM [HRISStaged].[dbo].[EmployeeJobTitle] A
	LEFT JOIN [MasterData].[dbo].[ADAccounts] as B ON A.EmployeeKey = B.EmployeeID
	LEFT JOIN [HRISStaged].[dbo].[EmployeeCorpGroup_Pivoted] as C ON A.EmployeeKey = C.EmployeeKey
	LEFT JOIN [HRISStaged].[dbo].[EmployeeStatus] D ON A.EmployeeKey = D.EmployeeKey
	WHERE A.EmployeeKey IS NOT NULL AND
              D.StatusName = 'Active'
