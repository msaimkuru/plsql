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