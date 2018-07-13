
------------------------------
   元の分類
------------------------------

    path
-------------
 /           
 /detail   
 /list/cd    
 /list/dvd  
 /list/newly

------------------------------
   結果
------------------------------

   path_name   | ss | uu | pv
---------------+----+----+----
 /             |  5 |  4 |  5
 /detail       |  5 |  3 |  5
 category_list |  6 |  4 |  6
 newly_list    |  3 |  2 |  3
(4 行)

------------------------------
   クエリ式
------------------------------

WITH
access_log_with_path as (
    SELECT
    *
    , substring(url from '//[^/]+([^?#]+)') AS path
    FROM access_log
)
, access_log_with_split_path AS (
    SELECT
    *
    , split_part(path, '/', 2) AS path1
    , split_part(path, '/', 3) AS path2
    FROM access_log_with_path
)
, access_log_with_path_name AS (
    SELECT
    *
    , CASE
    WHEN path1 = 'list' THEN
        CASE
            WHEN path2 = 'newly' THEN 'newly_list'
            ELSE 'category_list'
        END
        -- 上記以外は元のpathを採用
        ELSE path
    END AS path_name
    FROM access_log_with_split_path
)

SELECT
    path_name
    , COUNT(DISTINCT short_session) AS SS
    , COUNT(DISTINCT long_session) AS UU
    , COUNT(*) AS PV
FROM access_log_with_path_name
GROUP BY path_name
ORDER BY path_name
;
