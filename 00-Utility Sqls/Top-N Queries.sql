/* 
 * Top-N Queries Prior to Oracle 12c 
 */
    --returns the first 5 employees with the highest salaries.
    SELECT ROWNUM, v1.*
    FROM(
        SELECT ROWNUM as inner_select_rownum, t.*
        FROM SAIMK.emp t
        ORDER BY sal DESC
    ) v1
    WHERE ROWNUM <= 5
    ;
--------------------------------------------------------------------------------
/* 
 * New Possible Top-N Queries With Oracle 12c 
 */
    --returns the first 5 employees with the highest salaries.
    SELECT ROWNUM, t.*
    FROM SAIMK.emp t
    ORDER BY sal DESC
    FETCH FIRST 5 ROWS ONLY
    ;   
    
    -- Skips first 2 employees with the highest salaries and returns the next 5 employees.
    SELECT ROWNUM, t.*
    FROM SAIMK.emp t
    ORDER BY sal DESC
    OFFSET 2 ROWS
    FETCH FIRST 5 ROWS ONLY
    ;    
    
    --Returns top 15% employees with the highest salary
    SELECT ROWNUM, t.*
    FROM SAIMK.emp t
    ORDER BY sal DESC
    FETCH FIRST 15 PERCENT ROWS ONLY
    ;
--------------------------------------------------------------------------------    