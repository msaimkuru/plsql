/*
 * Exercise 4 on https://livesql.oracle.com/apex/f?p=590:1:4704207031745:CLEAR::1:TUTORIAL_ID,P1_SHOW_LEARN_SIDEBAR:182241645422959190146194127811898911783,Y
 * 
 * An anonymous block that deletes all the rows in the employees table for 
 * department 10 and returns all the employee NOs and the employee names of 
 * deleted rows. 
 * 
 * Then displays those values using DBMS_OUTPUT.PUT_LINE. 
 * Finally, rollbacks.
 */

DECLARE
   TYPE t_rec IS RECORD(empno SAIMK.emp.empno%TYPE,
                        ename SAIMK.emp.ename%TYPE
                       );    
   TYPE emps_t IS TABLE OF t_rec;
   l_emps emps_t;
   --
   --
   TYPE empno_t IS TABLE OF SAIMK.emp.empno%TYPE;
   l_empnos     empno_t;

   TYPE enames_t IS TABLE OF SAIMK.emp.ename%TYPE;
   l_enames   enames_t;   
BEGIN
   /* 
    * Returning 2 columns into 1 plsql table
    */
   DELETE FROM SAIMK.EMP t
   WHERE t.deptno = 10
   RETURNING t.empno, t.ename 
   BULK COLLECT INTO l_emps
   ;
   --
   DBMS_OUTPUT.put_line('----------------------------------------------------');
   --
   FOR indx IN 1 .. l_emps.COUNT
   LOOP
      DBMS_OUTPUT.put_line (l_emps (indx).empno || ' - ' || l_emps (indx).ename);
   END LOOP;
   --
   ROLLBACK;
   --
   --
   /* 
    * Returning 2 columns into 2 plsql tables
    */   
   -- 
   DELETE FROM SAIMK.EMP t
   WHERE t.deptno = 10
   RETURNING t.empno, t.ename 
   BULK COLLECT INTO l_empnos, l_enames
   ;
   --
   DBMS_OUTPUT.put_line('----------------------------------------------------');
   --
   FOR indx IN 1 .. l_empnos.COUNT
   LOOP
      DBMS_OUTPUT.put_line (l_empnos (indx) || ' - ' || l_enames (indx));
   END LOOP;
   --
   ROLLBACK;
END;
/
