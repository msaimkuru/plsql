/* 
 * Resource: 
 * ---------
 * https://livesql.oracle.com/apex/livesql/file/tutorial_IEHP37S6LTWIIDQIR436SJ59L.html
 * -----------------------------------------------------------------------------
 * 6. Dynamic SQL and FORALL
 * ----------------------------------------------------------------------------- 
 * Have you got a dynamic update, insert or delete sitting inside a loop? Don't 
 * worry....FORALL will still come to the rescue! Yes, that's right, you can put 
 * an EXECUTE IMMEDIATE statement inside FORALL, as well as static SQL. 
 * 
 * Let's take a look.
 */
DECLARE 
    TYPE numlist IS TABLE OF NUMBER;
    TYPE namelist IS TABLE OF VARCHAR2(15);
    --
    PROCEDURE p_update_emps(col_in IN VARCHAR2, empnos_in IN numlist)
    IS
       enames   namelist;
    BEGIN
       FORALL indx IN empnos_in.FIRST .. empnos_in.LAST
          EXECUTE IMMEDIATE
                'UPDATE saimk.employees t
                 SET '
                 || col_in
                 || ' = '
                 || col_in
                 || ' * 1.1 
                 WHERE t.employee_id = :1
                 RETURNING t.last_name 
                 INTO :2'
                 USING empnos_in (indx)
                 RETURNING 
                 BULK COLLECT 
                 INTO enames
                 ;
       --
       FOR indx IN 1 .. enames.COUNT
       LOOP
          dbms_output.put_line ('10% raise to ' || enames (indx));
       END LOOP;
       /* 
        * to leave the table in its original state for next examples 
        */  
       ROLLBACK;
    END p_update_emps;
BEGIN
    DECLARE
       l_ids   numlist := numlist (138, 147);
    BEGIN
       p_update_emps ('salary', l_ids);
    END;
END
;

/*
 * Note:
 * -----
 * Notice that I also used BULK COLLECT inside my FORALL statement, since I 
 * wanted get back from FORALL the last names of employees who got a raise. 
 * You need to include the RETURNING clause inside the dynamic DML statement 
 * and in the EXECUTE IMMEDIATE statement itself.
 *
 * The bottom line: if you can execute the DML statement statically, you can do 
 * it dynamically, too. Same FORALL syntax, just a different way of expressing 
 * the SQL statement inside it.
 */