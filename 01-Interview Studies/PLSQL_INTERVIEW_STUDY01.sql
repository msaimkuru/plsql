/*
 * source url:
 * https://mindmajix.com/oracle-pl-sql-interview-questions
 *
 * Study Date: 18.07.2022
 */

/*
 * Question 7) What are SQL functions? Describe in brief different types of 
 * SQL functions?
 -------------------------------------------------------------------------------
 * Answer:
 -------------------------------------------------------------------------------
 * 1) Single-Row functions: These functions operate on a single row to give one 
 * result per row. 
 * 2) Multiple-Row functions: These functions operate on groups of rows to give 
 * one result per group of rows.
 */
 --Example for Multiple-Row functions
 SELECT STDDEV(SAL), VARIANCE(SAL), AVG(SAL), MAX(SAL), MIN(SAL), SUM(SAL)
 FROM saimk.emp
 ;
 
/*
 * Question 8) Explain the character, number, and date function in detail?
 */
    SELECT TO_CHAR(SYSDATE, 'DY') A,  TO_CHAR(SYSDATE, 'dy')B FROM DUAL;
    
    SELECT NEXT_DAY(TRUNC(SYSDATE), 'MONDAY') FROM DUAL;
    
    SELECT LAST_DAY(SYSDATE) from DUAL;
    
    SELECT * FROM DUAL;
    
/*
 * Question 11) Describe different types of General Function used in SQL?
 -------------------------------------------------------------------------------
 * Answer:
 -------------------------------------------------------------------------------
 * NVL: Converts a null value to an actual value. NVL (exp1, exp2).
 * If exp1 is null then the NVL function returns the value of exp2.
 *
 * NVL2: If exp1 is not null, nvl2 returns exp2, if exp1 is null, nvl2 returns 
 * exp3.The argument exp1 can have any data type. NVL2 (exp1, exp2, exp3) 
 *
 * NULLIF: Compares two expressions and returns null if they are equal or 
 * the first expression if they are not equal. NULLIF (exp1, exp2)
 *
 * COALESCE: Returns the first non-null expression in the expression list. 
 * COALESCE (exp1, exp2… expn). The advantage of the COALESCE function over the 
 * NVL function is that the COALESCE function can take multiple alternative 
 * values.
 */
 
 SELECT A,
        NVL(A, TO_DATE('31.12.9999','DD.MM.YYYY')) B,
        NVL2(A, 1, 0) C
 FROM
 (SELECT CAST(NULL AS DATE) A FROM DUAL UNION
  SELECT SYSDATE A FROM DUAL
 )t1
 ;
 
 SELECT NULLIF(5, 5) A, NULLIF(6, 5) B FROM DUAL;
  
 SELECT COALESCE(NULL, NULL, '1st Non-Null Value','2nd Non-Null Value') A,
        COALESCE(NULL, '0', '1','2') B,
        COALESCE(NULL, NULL) C
 FROM DUAL
 ;
 
/*
 * Question  12) What is the difference between COUNT (*), COUNT (expression), 
 * COUNT (distinct expression)? (Where expression is any column name of Table)? 
 */
 
 SELECT COUNT(*) A, COUNT(A) B, COUNT(DISTINCT A) C
 FROM
 (SELECT CAST(NULL AS DATE) A FROM DUAL UNION ALL
  SELECT SYSDATE A FROM DUAL UNION ALL
  SELECT SYSDATE A FROM DUAL UNION ALL
  SELECT SYSDATE + 1 A FROM DUAL
 )t1
 ;
 
/*
 * Question 13) What is a Sub Query? Describe its Types? 
 -------------------------------------------------------------------------------
 * Answer:
 -------------------------------------------------------------------------------
 * A subquery is a SELECT statement that is embedded in a clause of another 
 * SELECT statement. A subquery can be placed in WHERE HAVING and FROM clause.
 *
 * Types of subqueries:
 * --------------------
 * 1) Single-Row Subquery: Queries that return only one row from the inner select 
 * statement. 
 * Single-row comparison operators are: =, >, >=, <, <=, <>
 * 2) Multiple-Row Subquery: Queries that return more than one row from the inner 
 * Select statement. There are also multiple-column subqueries that return more
 * than one column from the inner select statement. 
 * Operators include: IN, ANY, ALL.
 *
 * > ANY means more than the minimum.
 * < ANY means less than the maximum
 * = ANY is equivalent to IN operator.
 *
 * > ALL means more than the maximum
 * < ALL means less than the minimum
 * <> ALL is equivalent to NOT IN condition. 
 */

/*
 * Question 17) What is the use of Double Ampersand (&&) in SQL Queries?
 -------------------------------------------------------------------------------
 * Answer:
 ------------------------------------------------------------------------------- 
 * Use “&&” if you want to reuse the variable value without prompting the 
 * user each time.
 */
  SELECT empno, ename, &&columnname FROM emp ORDER BY &columnname;
  
/* Question 33) What is the difference between Truncate and Delete?
 -------------------------------------------------------------------------------
 * Answer:
 -------------------------------------------------------------------------------
    The main difference between Truncate and Delete is as below:
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------
    SQL Truncate	                                                                SQL Delete
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------
    TRUNCATE	                                                                    DELETE
    Removes all rows from a table and releases storage space used by that table.	Removes all rows from a table but does not release storage space used by that table.
    TRUNCATE Command is faster. 	                                                DELETE command is slower.
    Is a DDL statement and cannot be Rollback.	                                    Is a DML statement and can be Rollback.
    Database Triggers do not fire on TRUNCATE.	                                    Database Triggers fire on DELETE.
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------
*/

/* Question 34) What is the main difference between CHAR and VARCHAR2?
 -------------------------------------------------------------------------------
 * Answer:
 -------------------------------------------------------------------------------
 * CHAR pads blank spaces to a maximum length, whereas VARCHAR2 does not 
 * pad blank spaces.
 */
 SELECT LENGTH(A), LENGTH(B), REPLACE(A,' ', '-')
 FROM 
 (SELECT CAST('ABC' AS CHAR(10)) A, CAST('ABC' AS VARCHAR2(10)) B
  FROM DUAL
 )t1
 ;
 
/* Question  38) What is the difference between ON DELETE CASCADE and 
 * ON DELETE SET NULL?
 -------------------------------------------------------------------------------
 * Answer:
 -------------------------------------------------------------------------------
 * ON DELETE CASCADE Indicates that when the row in the parent table is deleted, 
 * the dependent rows in the child table will also be deleted. 
 * 
 * ON DELETE SET NULL Covert foreign key values to null when the parent value is 
 * removed. Without the ON DELETE CASCADE or the ON DELETE SET NULL options, the
 * row in the parent table cannot be deleted if it is referenced in the child ,
 * table.
 */

/* Question  39) What is a Candidate Key?
 -------------------------------------------------------------------------------
 * Answer:
 -------------------------------------------------------------------------------
 * The columns in a table that can act as a Primary Key are called Candidate 
 * Key.
 */
 
/* 
 * Question  45) Write a PL/SQL Program that raises a user-defined exception on 
 * Monday?
 */
    DECLARE
        a EXCEPTION;
    BEGIN
    --
    IF TO_CHAR(sysdate, 'DY')='MON' THEN
        RAISE a;
    END IF;
    --
    EXCEPTION
        WHEN a THEN
            DBMS_OUTPUT.PUT_LINE('my exception is raised on monday!');
    END
    ; 
    
/*
 * Question 53: What are The Types of Ref Cursors?
 -------------------------------------------------------------------------------
 * Answer:
 -------------------------------------------------------------------------------
 * In all databases having 2 ref cursors.
 *      1.Strong ref cursor
 *      2.Weak ref cursor
 * A strong ref cursor is a ref cursor that has a return type, whereas a weak 
 * ref cursor has no return type.
 */
 DECLARE
    TYPE t_w_ref_cursor IS REF CURSOR; /* example of a weak ref cursor */
    lw_ref_cur t_w_ref_cursor;
    --
    rec_emp EMP%ROWTYPE;
    --
    TYPE t_s_ref_cursor IS REF CURSOR RETURN DEPT%ROWTYPE; /* example of a strong ref cursor */
    ls_ref_cur t_s_ref_cursor;
    --    
    rec_dept DEPT%ROWTYPE;
    --    
 BEGIN
    /* 
     * Example of a strong ref cursor 
     */
    OPEN lw_ref_cur FOR SELECT * FROM EMP;
    --
    LOOP
        FETCH lw_ref_cur into rec_emp;
        --
        EXIT WHEN lw_ref_cur%NOTFOUND;
        --
        DBMS_OUTPUT.PUT_LINE(rec_emp.empno||CHR(9)||rec_emp.ename||CHR(9)||rec_emp.SAL);
        --
    END LOOP;
    --
    /* 
     * Example of a strong ref cursor 
     */
    OPEN ls_ref_cur FOR SELECT * FROM DEPT;
    --
    LOOP
        FETCH ls_ref_cur into rec_dept;
        --
        EXIT WHEN ls_ref_cur%NOTFOUND;
        --
        DBMS_OUTPUT.PUT_LINE(rec_dept.deptno||CHR(9)||rec_dept.dname||CHR(9)||rec_dept.loc);
        --
    END LOOP;   
 END;
 
/*
 * Question54) What is the Difference Between the trim, delete collection 
 * methods? 
 */
DECLARE
    type t1 is table of number(10);           
    v_t t1 := t1(10,20,30,40,50,60);              
BEGIN           
    v_t.trim(2);           
    DBMS_OUTPUT.PUT_LINE('after deleting last two elements');            
    
    FOR i in v_t.FIRST.. v_t.LAST           
    LOOP           
        DBMS_OUTPUT.PUT_LINE(v_t(i));            
    END LOOP;            
    
    v_t.delete(2);           
    
    DBMS_OUTPUT.PUT_LINE('after deleting second element');            
    
    FOR i in v_t.FIRST..v_t.LAST            
    LOOP  
        DBMS_OUTPUT.PUT('Element '||i||'-->');
        IF v_t.exists(i) THEN            
            DBMS_OUTPUT.PUT_LINE(v_t(i));  
        ELSE  
            DBMS_OUTPUT.PUT_LINE('Not Existing');
        END IF;            
    END LOOP;         
END; 

/*
 * Question 55) What are Overloading Procedures?
 -------------------------------------------------------------------------------
 * Answer:
 ------------------------------------------------------------------------------- 
 * Overload refers to the same name that can be used for a different purpose, 
 * in oracle we can also implement an overloading procedure through the package.
 * Overloading procedure having the same name with different types or different 
 * numbers of parameters.
 */

/*
 * Question 56) What are the Global Variables?
 -------------------------------------------------------------------------------
 * Answer:
 ------------------------------------------------------------------------------- 
 * In oracle, we are declaring global variables in Package Specification only.
 */
 
/*
 * Question 58) What is Invalid_number, Value_Error?
 */

/* Example for ORA-01722: invalid number*/
BEGIN
    INSERT INTO emp(empno, ename, sal) 
    VALUES(1,'gokul', 'abc')
    ;
    --
    EXCEPTION WHEN invalid_number THEN 
        DBMS_OUTPUT.PUT_LINE('insert proper data only');
        DBMS_OUTPUT.PUT_LINE( DBMS_UTILITY.FORMAT_ERROR_STACK() );
        DBMS_OUTPUT.PUT_LINE( DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );
END;


/* Example for ORA-06502: PL/SQL: numeric or value error*/
BEGIN
    DECLARE 
        z NUMBER(10);
    BEGIN
        z:= '&x' + '&y';
        dbms_output.put_line('z-->'||z);
        --
        EXCEPTION 
            WHEN value_error THEN 
                DBMS_OUTPUT.PUT_LINE('enter only numeric data value for x and y');
                DBMS_OUTPUT.PUT_LINE( DBMS_UTILITY.FORMAT_ERROR_STACK() );
                DBMS_OUTPUT.PUT_LINE( DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );
    END;            
END;

/*
 * Question 62) Explain different methods to trace the PL/SQL code?
 -------------------------------------------------------------------------------
 * Answer:
 -------------------------------------------------------------------------------
 * Tracing code is a necessary technique to test the performance of the code
 * during runtime.  We have different methods in PL/SQL to trace the code, 
 * which are,
 * DBMS_ TRACE
 * DBMS_ APPLICATION_INFO
 * Tkproof utilities and trcsess  
 * DBMS_SESSION and DBMS_MONITOR
 */
 
/*
 * Question  67) Name the two exceptions in PL/SQL?
 -------------------------------------------------------------------------------
 * Answer:
 -------------------------------------------------------------------------------
 * Error handling part of PL/SQL is called an exception.  We have two types of
 * exceptions, and they are User-defined and predefined.
 ---------------------------------
 * SOME PREDEFINED EXCEPTIONS:
 ---------------------------------
 * DUP_VAL_ON_INDEX
 * ZERO_DIVIDE
 * NO_DATA_FOUND
 * TOO_MANY_ROWS
 * CURSOR_ALREADY_OPEN
 * INVALID_NUMBER
 * INVALID_CURSOR
 * PROGRAM_ERROR
 * TIMEOUT_ON_RESOURCE
 * STORAGE_ERROR
 * LOGON_DENIED
 * VALUE_ERROR
 */
 
 