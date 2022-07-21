/*
 * Exercise 5 on https://livesql.oracle.com/apex/f?p=590:1:4704207031745:CLEAR::1:TUTORIAL_ID,P1_SHOW_LEARN_SIDEBAR:182241645422959190146194127811898911783,Y
 * 
 * Uses BULK COLLECT to fetch all the enames from employees identified by that
 * WHERE clause and returns the collection.
 */

DECLARE
    l_filter_salary NUMBER := &pfilter_salary;
    l_filter_deptno NUMBER := &pfilter_deptno;
    --
    l_enames   DBMS_SQL.varchar2_table;
    --
    PROCEDURE get_names (
       where_in    IN  VARCHAR2,
       names_out   OUT DBMS_SQL.varchar2_table)
    IS
    BEGIN
        EXECUTE IMMEDIATE 
        'SELECT ename
        FROM SAIMK.emp 
        WHERE ' || where_in
        BULK COLLECT INTO names_out
        ;
    END get_names;
    --
BEGIN
   get_names ('deptno = '||l_filter_deptno, l_enames);
   --
   DBMS_OUTPUT.put_line ('---------------------------------------------------');
   DBMS_OUTPUT.put_line ('ENAME list For deptno = '||l_filter_deptno);
   DBMS_OUTPUT.put_line ('---------------------------------------------------');
   --
   FOR indx IN 1 .. l_enames.COUNT
   LOOP
      DBMS_OUTPUT.put_line (l_enames (indx));
   END LOOP;
   --
   DBMS_OUTPUT.put_line ('---------------------------------------------------');
   --
   get_names ('sal > '||l_filter_salary, l_enames);
   --
   DBMS_OUTPUT.put_line ('---------------------------------------------------');   
   DBMS_OUTPUT.put_line ('ENAME list For salary > '||l_filter_salary);
   DBMS_OUTPUT.put_line ('---------------------------------------------------');
   --
   FOR indx IN 1 .. l_enames.COUNT
   LOOP
      DBMS_OUTPUT.put_line (l_enames (indx));
   END LOOP;
   --
   DBMS_OUTPUT.put_line ('---------------------------------------------------');
   --
END;
