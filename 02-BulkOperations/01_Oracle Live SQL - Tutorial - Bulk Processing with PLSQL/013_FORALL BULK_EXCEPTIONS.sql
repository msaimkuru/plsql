/* 
 * -----------------------------------------------------------------------------
 * Resource: 
 * -----------------------------------------------------------------------------
 * https://livesql.oracle.com/apex/livesql/file/tutorial_IEHP37S6LTWIIDQIR436SJ59L.html
 * -----------------------------------------------------------------------------
 * 13. SQL%BULK_EXCEPTIONS Pseudo-Collection Usage With FORALL-SAVE EXCEPTIONS
 * ----------------------------------------------------------------------------- 
 * - If you want the PL/SQL engine to execute as many of the DML statements as 
 * possible, even if errors are raised along the way, add the SAVE EXCEPTIONS 
 * clause to the FORALL header.
 
 * - Then, if the SQL engine raises an error, the PL/SQL engine will save that 
 * information in a pseudo-collection** named SQL%BULK_EXCEPTIONS, and continue
 * executing statements. When all statements have been attempted, PL/SQL then 
 * raises the ORA-24381 error.
 *
 * - You can—and should—trap that error in the exception section and then 
 * iterate through the contents of SQL%BULK_EXCEPTIONS to find out which errors 
 * have occurred. You can then write error information to a log table and/or 
 * attempt recovery of the DML statement.
 *
 * - SQL%BULK_EXCEPTIONS is a collection of records, each of which has 2 fields: 
 * ERROR_INDEX and ERROR_CODE.
 *
 * - The ERROR_INDEX field contains a sequentially generated integer, 
 * incremented with each either successful or erroneous statement execution in 
 * the SQL engine. 
 *
 * - For sequentially filled collections, this integer matches the index value 
 * of the variable in the bind array. 
 *
 * - For sparsely-filled collections (see the modules on INDICES OF and 
 * VALUES OF for more details), you will have to write special-purpose code to 
 * "link back" the nth executed statement to its index value in the bind array.
 *
 * - ERROR_CODE is the value returned by SQLCODE at the time the error occurred. 
 * Note that this collection does not include the error message.
 */
/* 
 * -----------------------------------------------------------------------------
 * EXAMPLE 1:
 * ----------------------------------------------------------------------------- 
 * Let's go back to the same block used to show the effects of SAVE EXCEPTIONS, 
 * but now also take advantage of SQL%BULK_EXCEPTIONS.
 * -----------------------------------------------------------------------------  
 */ 
DECLARE  
   TYPE namelist_t IS TABLE OF VARCHAR2 (5000);  
   --
   enames_with_errors namelist_t := namelist_t ('ABC',  
                                                'DEF',  
                                                RPAD ('BIGBIGGERBIGGEST', 50, 'ABC'),  
                                                'LITTLE',  
                                                RPAD ('BIGBIGGERBIGGEST', 50, 'ABC'),  
                                                'SMITHIE'
                                               );                       
BEGIN
   FORALL indx IN 1 .. enames_with_errors.COUNT SAVE EXCEPTIONS  
      UPDATE saimk.employees t
      SET t.first_name = enames_with_errors(indx)
      ;
   /* 
    * to leave the table in its original state for next examples 
    */
   ROLLBACK;
   --
   EXCEPTION
      WHEN OTHERS THEN
         dbms_output.put_line ('#Rows Updated: ' || SQL%ROWCOUNT || ' rows.');  
         --         
         dbms_output.put_line ('---------------------------------------------');
         dbms_output.put_line ('                            SQLERRM -> '||SQLERRM);
         dbms_output.put_line ('---------------------------------------------');
         dbms_output.put_line ('    DBMS_UTILITY.FORMAT_ERROR_STACK -> '||dbms_utility.format_error_stack);         
         dbms_output.put_line ('---------------------------------------------');
         dbms_output.put_line ('DBMS_UTILITY.FORMAT_ERROR_BACKTRACE -> '||dbms_utility.format_error_backtrace);
         dbms_output.put_line ('---------------------------------------------');          
         --
         FOR indx IN 1 .. SQL%BULK_EXCEPTIONS.COUNT LOOP
            dbms_output.put_line (
               'Error '
            || indx
            || ': occurred on SQL%BULK_EXCEPTIONS'' sequential index '
            || SQL%BULK_EXCEPTIONS(indx).ERROR_INDEX
            || ' attempting to update name to "'
            || enames_with_errors(SQL%BULK_EXCEPTIONS (indx).ERROR_INDEX)
            || '"')
            ;
            --
            dbms_output.put_line ('Oracle error is '
            || SQLERRM(-1 * SQL%BULK_EXCEPTIONS (indx).ERROR_CODE));
            --
            dbms_output.put_line('----------------------------------------');
        END LOOP;
        /* 
         * to leave the table in its original state for next examples 
         */
        ROLLBACK;  
END
;
/*----------------------------------------------------------------------------*/
/*
 * ------
 * Notes:
 * ------
 * 1) Notice that we multiply the error code in SQL%BULK_EXCEPTIONS by -1 before 
 * passing it to SQLERRM. Here's why we do that:
 *
 * SQLERRM not only returns the current error message. If you pass it an error 
 * code, it returns the error message for that code.
 *
 * But it expects a negative value for all but two error codes 
 * - 0 (no error) and 100 (the ANSI-standard NO_DATA_FOUND error code).
 * For reasons that may never be known, the value for the error code stored in 
 * the pseudo-collection is not negative.
 *
 * 2) ** What's a "pseudo-collection"? 
 * It's a data structure created implicitly by PL/SQL for us. The "pseudo" 
 * indicates that it doesn't have all the features of a "normal" collection.
 
 * In the case of SQL%BULK_EXCEPTIONS, it has just one method defined on it: 
 * COUNT. It is always filled sequentially from index value 1. 
 * 
 * 3) The number of elements in this pseudo-collection matches the number of 
 * times the SQL engine encountered an error.
 * ----------------------------------------------------------------------------- 
 */
/*
 * -----------------------------------------------------------------------------
 * Exercise 11:
 * -----------------------------------------------------------------------------
 * Change the code you wrote in Exercise 10 as follows:
 * 1) Expand the number of employee IDs to update to 5.
 * 2) Change the array of salary values so that at least 2 of the updates will 
 * fail.
 * 3) Change the exception handler to show which of the attempts to update 
 * failed, the error code, and the error message associated with that code.
 */
/* 
 * ----------------------------------------------------------------------------- 
 * Solution For Exercise 11:
 * ----------------------------------------------------------------------------- 
 */
DECLARE
   /* 
    * 2nd and 4th values are too big but since we added SAVE EXCEPTIONS,
    * we still see 3 rows updated - and a generic error message. 
    */
   TYPE numbers_nt IS TABLE OF NUMBER;
   --
   l_ids        numbers_nt := numbers_nt (101, 111, 117, 131, 143);
   l_salaries   numbers_nt := numbers_nt (10000, 1100000, 12000, 6669999, 5000);
BEGIN
   --
   dbms_output.put_line('----- Salaries before update -----');
   FOR JJ IN(SELECT t.* FROM saimk.employees t WHERE t.employee_id in (101, 111, 117, 131, 143) ORDER BY t.employee_id)
   LOOP
     dbms_output.put_line(jj.employee_id||','||jj.salary);
   END LOOP;
   dbms_output.put_line('----------------------------------');
   --
   FORALL indx IN 1 .. l_ids.COUNT SAVE EXCEPTIONS
      UPDATE saimk.employees t
      SET t.salary = l_salaries (indx)
      WHERE t.employee_id = l_ids (indx)
      ;
   --
   dbms_output.put_line('----- Salaries after update -----');
   FOR JJ IN(SELECT t.* FROM saimk.employees t WHERE t.employee_id in (101, 111, 117, 131, 143) ORDER BY t.employee_id)
   LOOP
     dbms_output.put_line(jj.employee_id||','||jj.salary);
   END LOOP;
   dbms_output.put_line('----------------------------------');
   --   
   dbms_output.put_line ('#Rows Updated: ' || SQL%ROWCOUNT);
   /* 
    * to leave the table in its original state for next examples 
    */   
   ROLLBACK;
   --
   EXCEPTION
      WHEN OTHERS THEN
         dbms_output.put_line ('#Rows Updated: ' || SQL%ROWCOUNT || ' rows.');  
         --         
         dbms_output.put_line ('---------------------------------------------');
         dbms_output.put_line ('                            SQLERRM -> '||SQLERRM);
         dbms_output.put_line ('---------------------------------------------');
         dbms_output.put_line ('    DBMS_UTILITY.FORMAT_ERROR_STACK -> '||dbms_utility.format_error_stack);         
         dbms_output.put_line ('---------------------------------------------');
         dbms_output.put_line ('DBMS_UTILITY.FORMAT_ERROR_BACKTRACE -> '||dbms_utility.format_error_backtrace);
         dbms_output.put_line ('---------------------------------------------');              
         --
         dbms_output.put_line('----- Salaries after update -----');
         FOR JJ IN(SELECT t.* FROM saimk.employees t WHERE t.employee_id in (101, 111, 117, 131, 143) ORDER BY t.employee_id)
         LOOP
            dbms_output.put_line(jj.employee_id||','||jj.salary);
         END LOOP;
         dbms_output.put_line('----------------------------------');         
         --
         FOR indx IN 1 .. SQL%BULK_EXCEPTIONS.COUNT LOOP
            dbms_output.put_line (
               'Error '
            || indx
            || ' - bind array index: '
            || SQL%BULK_EXCEPTIONS (indx).ERROR_INDEX
            || ' attempting to update salary to '
            || l_salaries(SQL%BULK_EXCEPTIONS (indx).ERROR_INDEX))
            ;
            --
            dbms_output.put_line (
               'Oracle error is '
            || SQLERRM(-1 * SQL%BULK_EXCEPTIONS (indx).ERROR_CODE))
            ;
            --
            dbms_output.put_line('----------------------------------------');
         END LOOP;
         /* 
          * to leave the table in its original state for next examples 
          */ 
         ROLLBACK; 
END
;
/*----------------------------------------------------------------------------*/