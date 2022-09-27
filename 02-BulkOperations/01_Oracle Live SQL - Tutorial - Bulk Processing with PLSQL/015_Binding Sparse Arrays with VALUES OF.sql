/* 
 * -----------------------------------------------------------------------------
 * Resource: 
 * -----------------------------------------------------------------------------
 * https://livesql.oracle.com/apex/livesql/file/tutorial_IEHP37S6LTWIIDQIR436SJ59L.html
 * -----------------------------------------------------------------------------
 * 15. Binding Sparse Arrays with VALUES OF
 * ----------------------------------------------------------------------------- 
 * The VALUES OF clause, like its "sister" INDICES OF, makes it easier to use 
 * FORALL with bind arrays that are sparse - or with bind arrays from which you 
 * need to select out specific elements for binding. 
 *
 * With VALUES OF, you specify a collection whose element values (not the index 
 * values) specify the index values in the bind arrays that will be used to 
 * generate DML statements in the FORALL. Sound complicated? It is, sort of. 
 * It is another level of "indirectness" from INDICES OF, and not as commonly 
 * used.
 *
 * -----------------------------------------------------------------------------
 * Note:
 * -----------------------------------------------------------------------------
 * The datatype of elements in a collection used in the VALUES OF clause must be 
 * PLS_INTEGER. It also must be indexed by PLS_INTEGER.
 *
 * You are much less likely to use VALUES OF than INDICES OF, but it's good to 
 * know that it's there.
 * -----------------------------------------------------------------------------
 */ 
/* 
 * -----------------------------------------------------------------------------
 * EXAMPLE 1:
 * ----------------------------------------------------------------------------- 
 * Notice in the block below that the three element values are -77, 13067 and 
 * 1070. These in turn are index values in the l_employees array. And those 
 * elements in turn have the values 134, 123 and 129. You should therefore see 
 * in the output of the last step in the script that the employees with these 3 
 * IDs now earn a $10000 salary.
 * -----------------------------------------------------------------------------  
 */
DECLARE
   TYPE employee_aat 
      IS TABLE OF employees.employee_id%TYPE INDEX BY PLS_INTEGER;
   --
   l_employees employee_aat;
   --
   TYPE values_aat IS TABLE OF PLS_INTEGER INDEX BY PLS_INTEGER;
   --
   l_employee_idx_values values_aat;
   --
BEGIN
   l_employees (-77) := 134;
   l_employees (13067) := 123;
   l_employees (99999999) := 147;
   l_employees (1070) := 129;
   --
   l_employee_idx_values (100) := -77;
   l_employee_idx_values (200) := 13067;
   l_employee_idx_values (300) := 1070;
   --
   FORALL l_index IN VALUES OF l_employee_idx_values
      UPDATE saimk.employees t
      SET t.salary = 10000
      WHERE t.employee_id = l_employees(l_index)
      ;
   --
   DBMS_OUTPUT.put_line('#Rows updated: ' || SQL%ROWCOUNT);
   --
   /* 
    * to leave the table in its original state for next examples 
    */   
   ROLLBACK;
END
;
/*----------------------------------------------------------------------------*/