/************************************
 * CHECKSUM as an Aggregate Function
 ************************************
 */

/* 
 * The CHECKSUM function returns a deterministic 8-byte signed long checksum, 
 * converted to an Oracle number. This can be useful to check the contents of 
 * a table to see if it has changed. The checksum is based on the passed in 
 * expression of a group of rows, which is not affected by the row order. 
 * 
 * The expression can be a column, constant, bind variable, or an expression 
 * combining them. It supports most data types except ADT and JSON. We have the 
 * choice of performing the action for all rows, or distinct rows.
 * 
 * As an aggregate function it reduces the number of rows, hence the term 
 * "aggregate". If the data isn't grouped we turn the 14 rows in the EMP table 
 * to a single row with the aggregated values.
 */
select checksum(sal) as checksum_total_sal, sum(sal)
from   emp;

/* The DISTINCT, UNIQUE and ALL keywords are also available for the analytic 
 * function.
 *
 * We can get more granularity of information by including a GROUP BY clause. 
 * In the following example we see the checksum of the salaries per department.
 */
 
select checksum(distinct sal) as checksum_distinct_sal
from   emp;

select deptno,
       checksum(sal) as checksum_sal_by_dept
from   emp
group by deptno
order by deptno;

--insert into emp (empno, ename, sal, deptno) values (9999, 'HALL', 1000, 10);

/*
 * Using DISTINCT or UNIQUE keywords mean only unique values in the expression 
 * are used for the calculation. The ALL keyword is the same as the default 
 * action.
 */

select checksum(sal) as checksum_total_sal,
       checksum(all sal) as checksum_total_sal_all,
       checksum(distinct sal) as checksum_total_sal_distinct,
       checksum(unique sal) as checksum_total_sal_unique       
from   emp;

/************************************
 * CHECKSUM as an Analytic Function
 ************************************
 */
/* 
 * Omitting a partitioning clause from the OVER clause means the whole result 
 * set is treated as a single partition. In the following example we display 
 * the salary checksum, as well as all the original data.
 */
select empno,
       ename,
       deptno,
       sal,
       checksum(sal) over () as checksum_total
from   emp;

/*
 * Adding the partitioning clause allows us to return the checksum within a 
 * partition.
 */

select empno,
       ename,
       deptno,
       sal,
       checksum(sal) over (partition by deptno) as checksum_by_dept
from   emp; 