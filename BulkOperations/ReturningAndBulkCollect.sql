DECLARE
   TYPE ids_t IS TABLE OF SAIMK.EMP.empno%TYPE;
   l_ids ids_t;
BEGIN
   UPDATE SAIMK.emp t
      SET t.ename = UPPER (t.ename)
    WHERE t.deptno = 10
      RETURNING t.empno BULK COLLECT INTO l_ids;

   FOR indx IN 1 .. l_ids.COUNT 
   LOOP
      DBMS_OUTPUT.PUT_LINE (l_ids (indx));
   END LOOP;

   ROLLBACK;
END;
/