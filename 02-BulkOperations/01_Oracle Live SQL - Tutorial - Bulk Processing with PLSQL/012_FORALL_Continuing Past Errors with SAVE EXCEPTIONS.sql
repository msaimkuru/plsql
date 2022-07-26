/* 
 * -----------------------------------------------------------------------------
 * Resource: 
 * -----------------------------------------------------------------------------
 * https://livesql.oracle.com/apex/livesql/file/tutorial_IEHP37S6LTWIIDQIR436SJ59L.html
 * -----------------------------------------------------------------------------
 * 12. FORALL-Continuing Past Errors with SAVE EXCEPTIONS
 * ----------------------------------------------------------------------------- 
 * Add the SAVE EXCEPTIONS clause to your FORALL statement when you want the 
 * PL/SQL runtime engine to execute all DML statements generated by the FORALL, 
 * even if one or more than fail with an error.
 * -----------------------------------------------------------------------------
 * Note: 
 * -----------------------------------------------------------------------------
 * With FORALL-SAVE EXCEPTIONS all DML stataements are executed even if 
 * any  one of the DML statements generated causes an error. But at the end of
 * the FORALL statement still an exception (ORA-24381: error(s) in array DML)
 * occurs.
 * -----------------------------------------------------------------------------
 */
/* 
 * -----------------------------------------------------------------------------
 * EXAMPLE 1:
 * ----------------------------------------------------------------------------- 
 * In the code below (which is, kind of silly, since it updates all the employee 
 * rows each time), we are going to get errors. We can't update a first_name to 
 * a string of 1000 or 3000 bytes. Without SAVE EXCEPTIONS we never get past 
 * the third element in the bind array. The employees table has 107 rows. 
 * ----------------------------------------------------------------------------- 
 * - How many were updated? (Answer: 107 * 2 = 214 Rows)
 * - Exception Got: 
 *   ORA-12899: value too large for column "SAIMK"."EMPLOYEES"."FIRST_NAME" (actual: 1000, maximum: 20)
 * -----------------------------------------------------------------------------  
 */
DECLARE  
   TYPE namelist_t IS TABLE OF VARCHAR2 (5000);  
   --
   enames_with_errors namelist_t := namelist_t ('ABC',  
                                                'DEF',  
                                                RPAD ('BIGBIGGERBIGGEST', 1000, 'ABC'),
                                                'LITTLE',  
                                                RPAD ('BIGBIGGERBIGGEST', 3000, 'ABC'),
                                                'SMITHIE'
                                               );  
BEGIN  
   FORALL indx IN 1 .. enames_with_errors.COUNT  
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
         FOR indx IN 1.. enames_with_errors.COUNT LOOP
            dbms_output.put_line ('#Rows Updated at index ' || indx || ': ' || SQL%BULK_ROWCOUNT(indx));
         END LOOP;
         --         
         dbms_output.put_line ('---------------------------------------------');
         dbms_output.put_line ('                            SQLERRM -> ' || SQLERRM);
         dbms_output.put_line ('---------------------------------------------');
         dbms_output.put_line ('    DBMS_UTILITY.FORMAT_ERROR_STACK -> ' || dbms_utility.format_error_stack);         
         dbms_output.put_line ('---------------------------------------------');
         dbms_output.put_line ('DBMS_UTILITY.FORMAT_ERROR_BACKTRACE -> ' || dbms_utility.format_error_backtrace);
         dbms_output.put_line ('---------------------------------------------'); 
         /* 
          * to leave the table in its original state for next examples 
          */      
         ROLLBACK;  
END;
/*----------------------------------------------------------------------------*/
/* 
 * -----------------------------------------------------------------------------
 * EXAMPLE 2:
 * ----------------------------------------------------------------------------- 
 * Let's try that again with SAVE EXCEPTIONS. Below, we ask that PL/SQL execute 
 * every generated statement no matter how of them fail, please! 
 * 
 * Now how many rows were updated? (Notice that with SAVE EXCEPTIONS in place,
 * Answer: 107 * 4 = 428 Rows)
 * -----------------------------------------------------------------------------  
 */
DECLARE  
   TYPE namelist_t IS TABLE OF VARCHAR2 (5000);  
   --
   enames_with_errors namelist_t := namelist_t ('ABC',  
                                                'DEF',  
                                                RPAD ('BIGBIGGERBIGGEST', 1000, 'ABC'),  
                                                'LITTLE',  
                                                RPAD ('BIGBIGGERBIGGEST', 3000, 'ABC'),  
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
         FOR indx IN 1.. enames_with_errors.COUNT LOOP
            dbms_output.put_line ('#Rows Updated at index ' || indx || ': ' || SQL%BULK_ROWCOUNT(indx));
         END LOOP;
         --
         dbms_output.put_line ('---------------------------------------------');
         dbms_output.put_line ('                            SQLERRM -> ' || SQLERRM);
         dbms_output.put_line ('---------------------------------------------');
         dbms_output.put_line ('    DBMS_UTILITY.FORMAT_ERROR_STACK -> ' || dbms_utility.format_error_stack);         
         dbms_output.put_line ('---------------------------------------------');
         dbms_output.put_line ('DBMS_UTILITY.FORMAT_ERROR_BACKTRACE -> ' || dbms_utility.format_error_backtrace);
         dbms_output.put_line ('---------------------------------------------');
         /* 
          * to leave the table in its original state for next examples 
          */         
         ROLLBACK;  
END;
/*----------------------------------------------------------------------------*/
/*
 * -----------------------------------------------------------------------------
 * Exercise 10
 * -----------------------------------------------------------------------------
 * Change the code you wrote in Exercise 9 so that the SQL engine executes the 
 * DML statement as many times as there are elements in the binding array. 
 * 
 * Notice how the error information changes.
 * ----------------------------------------------------------------------------- 
 */
/* 
 * ----------------------------------------------------------------------------- 
 * Solution For Exercise 10
 * ----------------------------------------------------------------------------- 
 */
DECLARE
   /* 
    * Second value is too big but since we added SAVE EXCEPTIONS,
    * we still see two rows updated - and a generic error message
    * for the "generic" ORA-24381. 
    */
   TYPE numbers_nt IS TABLE OF NUMBER;
   --
   l_ids        numbers_nt := numbers_nt(101, 111, 131);
   l_salaries   numbers_nt := numbers_nt(10000, 1100000, 12000);
BEGIN
   FORALL indx IN 1 .. l_ids.COUNT SAVE EXCEPTIONS
      UPDATE saimk.employees t
      SET t.salary = l_salaries(indx)
      WHERE t.employee_id = l_ids(indx)
   ;
   --
   dbms_output.put_line ('#Rows Updated: ' || SQL%ROWCOUNT);
   --
   /* 
    * to leave the table in its original state for next examples 
    */   
   ROLLBACK;
   --
   EXCEPTION
      WHEN OTHERS THEN
         dbms_output.put_line ('#Rows Updated: ' || SQL%ROWCOUNT);
         --
         FOR indx IN 1.. l_ids.COUNT LOOP
            dbms_output.put_line ('#Rows Updated at index ' || indx || ': ' || SQL%BULK_ROWCOUNT(indx));
         END LOOP;
         --
         dbms_output.put_line ('---------------------------------------------');
         dbms_output.put_line ('                            SQLERRM -> ' || SQLERRM);
         dbms_output.put_line ('---------------------------------------------');
         dbms_output.put_line ('    DBMS_UTILITY.FORMAT_ERROR_STACK -> ' || dbms_utility.format_error_stack);         
         dbms_output.put_line ('---------------------------------------------');
         dbms_output.put_line ('DBMS_UTILITY.FORMAT_ERROR_BACKTRACE -> ' || dbms_utility.format_error_backtrace);
         dbms_output.put_line ('---------------------------------------------');
         /* 
          * to leave the table in its original state for next examples 
          */         
         ROLLBACK;
END;
/*----------------------------------------------------------------------------*/