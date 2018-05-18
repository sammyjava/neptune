SELECT pages.* FROM pages 
WHERE lower(label) LIKE '%core%' OR lower(metakeywords) LIKE '%core%' OR lower(metadescription) LIKE '%core%' OR lower(headtitle) LIKE '%core%' OR lower(title) LIKE '%core%'
UNION
SELECT pages.* FROM pages,pagetags
WHERE pages.pid=pagetags.pid AND tag LIKE '%core%'
ORDER BY label,pid;
