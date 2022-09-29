/* 
 * -----------------------------------------------------------------------------
 * Resource: 
 * -----------------------------------------------------------------------------
 * https://livesql.oracle.com/apex/livesql/file/tutorial_IEHP37S6LTWIIDQIR436SJ59L.html
 * -----------------------------------------------------------------------------
 * 16. Dynamic SQL and FORALL
 * ----------------------------------------------------------------------------- 
 * Have you got a dynamic update, insert or delete sitting inside a loop? 
 * 
 * Don't worry....FORALL will still come to the rescue! Yes, that's right, you 
 * can put an EXECUTE IMMEDIATE statement inside FORALL, as well as static SQL. 
 * 
 * Let's take a look.
 * -----------------------------------------------------------------------------
 * Notes:
 * -----------------------------------------------------------------------------
 * 1) Notice that we also used BULK COLLECT inside our FORALL statement, since we 
 * wanted to get back from FORALL the last names of employees who got a raise. 
 
 * 2) You need to include the RETURNING clause inside the dynamic DML statement 
 * and in the EXECUTE IMMEDIATE statement itself.
 *
 * The bottom line: if you can execute the DML statement statically, you can do 
 * it dynamically, too. Same FORALL syntax, just a different way of expressing 
 * the SQL statement inside it.
 * ----------------------------------------------------------------------------- 
 */
/* 
 * -----------------------------------------------------------------------------
 * EXAMPLE 1:
 * -----------------------------------------------------------------------------
 */
DECLARE 
   TYPE numlist_t IS TABLE OF NUMBER;
   TYPE namelist_t IS TABLE OF VARCHAR2(15);
   --
   PROCEDURE p_update_emps(p_col_in IN VARCHAR2, p_empnos_in IN numlist_t)
   IS
      l_enames namelist_t;
   BEGIN
      FORALL indx IN p_empnos_in.FIRST .. p_empnos_in.LAST
         EXECUTE IMMEDIATE
                'UPDATE saimk.employees t
                 SET '
                 || 't.' || p_col_in
                 || ' = '
                 || 't.' || p_col_in
                 || ' * 1.1 
                 WHERE t.employee_id = :1
                 RETURNING t.last_name 
                 INTO :2'
                 USING p_empnos_in(indx)
                 RETURNING 
                 BULK COLLECT 
                 INTO l_enames
      ;
      --
      FOR indx IN 1 .. l_enames.COUNT
      LOOP
         dbms_output.put_line ('10% raise to ' || l_enames(indx));
      END LOOP;
      /* 
       * to leave the table in its original state for next examples 
       */  
      ROLLBACK;
   END p_update_emps;
BEGIN
   DECLARE
      l_ids   numlist_t := numlist_t (138, 147);
   BEGIN
      p_update_emps ('salary', l_ids);
   END;
END;
/*----------------------------------------------------------------------------*/