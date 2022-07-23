/* Source: https://oracle-base.com/articles/21c/any_value-21c
 * ANY_VALUE Aggregate Function in Oracle Database 21c
 * The ANY_VALUE function allows us to safely drop columns out of a GROUP BY 
 * clause to reduce any performance overhead.
 */
 
 /*
  * The Problem
  * We want to return a list of departments with a count of the number of 
  * employees in the department, so we use the COUNT aggregate function and a 
  * GROUP BY clause.
  */
SELECT d.deptno,
       d.dname,
       COUNT(e.empno) AS employee_count
FROM   SAIMK.dept d
       LEFT OUTER JOIN SAIMK.emp e 
       ON d.deptno = e.deptno
GROUP BY d.deptno, d.dname
ORDER BY 1;
/*
 * We are forced to include all non-aggregate columns from the select list into 
 * the GROUP BY or we will get an error. In this case we don't really care about
 * including the DNAME column in the GROUP BY, but we are forced to do so. 
 * Adding extra columns in the GROUP BY represents an overhead. To get around 
 * this, people will sometimes use the MIN or MAX functions.
 */
SELECT d.deptno,
       MIN(d.dname) AS dname,
       COUNT(e.empno) AS employee_count
FROM   SAIMK.dept d
       LEFT OUTER JOIN SAIMK.emp e 
       ON d.deptno = e.deptno
GROUP BY d.deptno
ORDER BY 1
;
/*
 * This allows us to remove the DNAME column from the GROUP BY, but now we have 
 * additional work associated with the MIN and MAX functions, which is a 
 * new overhead.
 *
 * ANY_VALUE : The Solution
 * Oracle 21c introduced the ANY_VALUE aggregate function to solve this problem. 
 * We use it in the same way we would use MIN or MAX, but it is optimized to 
 * reduce the overhead of the aggregate function. Rather than doing any type of 
 * comparison, ANY_VALUE just presents the first non-NULL value it finds.
 */
SELECT d.deptno,
       ANY_VALUE(d.dname) AS dname,
       COUNT(e.empno) AS employee_count
FROM   SAIMK.dept d
       LEFT OUTER JOIN  SAIMK.emp e ON d.deptno = e.deptno
GROUP BY d.deptno
ORDER BY 1
; 

