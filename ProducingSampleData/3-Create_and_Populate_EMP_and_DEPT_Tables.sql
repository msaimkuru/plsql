/* 
 * Script Downloaded from: https://livesql.oracle.com/apex/f?p=590:41:9536950914740:::41:P41_ID:333667445241506780258350156571847879837
 */

REM   Script: EMP and DEPT
REM   Example EMP and DEPT tables.  Classic Oracle tables with 4 departments and 14 employees.  Includes a join query example.

-- Create DEPT table which will be the parent table of the EMP table. 
CREATE TABLE SAIMK.dept(  
  deptno     NUMBER(2,0),  
  dname      VARCHAR2(14),  
  loc        VARCHAR2(13),  
  CONSTRAINT pk_dept PRIMARY KEY (deptno)  
);

-- Create the EMP table which has a foreign key reference to the DEPT table.  The foreign key will require that the DEPTNO in the EMP table exist in the DEPTNO column in the DEPT table.
CREATE TABLE SAIMK.emp(  
  empno    NUMBER(4,0),  
  ename    VARCHAR2(10),  
  job      VARCHAR2(9),  
  mgr      NUMBER(4,0),  
  hiredate DATE,  
  sal      NUMBER(7,2),  
  comm     NUMBER(7,2),  
  deptno   NUMBER(2,0),  
  CONSTRAINT pk_emp PRIMARY KEY (empno),  
  CONSTRAINT fk_deptno FORE KEY (deptno) REFERENCES dept (deptno)  
);

-- Insert row into DEPT table using named columns.
INSERT INTO SAIMK.DEPT (DEPTNO, DNAME, LOC)
VALUES(10, 'ACCOUNTING', 'NEW YORK');

-- Insert a row into DEPT table by column position.
INSERT INTO SAIMK.dept  
VALUES(20, 'RESEARCH', 'DALLAS');

INSERT INTO SAIMK.dept  
VALUES(30, 'SALES', 'CHICAGO');

INSERT INTO SAIMK.dept  
VALUES(40, 'OPERATIONS', 'BOSTON');

-- Insert EMP row, using TO_DATE function to cast string literal into an oracle DATE format.
INSERT INTO SAIMK.emp  
VALUES(  
 7839, 'KING', 'PRESIDENT', null,  
 to_date('17-11-1981','dd-mm-yyyy'),  
 5000, null, 10  
);

INSERT INTO SAIMK.emp  
VALUES(  
 7698, 'BLAKE', 'MANAGER', 7839,  
 to_date('1-5-1981','dd-mm-yyyy'),  
 2850, null, 30  
);

INSERT INTO SAIMK.emp  
VALUES(  
 7782, 'CLARK', 'MANAGER', 7839,  
 to_date('9-6-1981','dd-mm-yyyy'),  
 2450, null, 10  
);

INSERT INTO SAIMK.emp  
VALUES(  
 7566, 'JONES', 'MANAGER', 7839,  
 to_date('2-4-1981','dd-mm-yyyy'),  
 2975, null, 20  
);

INSERT INTO SAIMK.emp  
VALUES(  
 7788, 'SCOTT', 'ANALYST', 7566,  
 to_date('13-JUL-87','dd-mm-rr') - 85,  
 3000, null, 20  
);

INSERT INTO SAIMK.emp  
VALUES(  
 7902, 'FORD', 'ANALYST', 7566,  
 to_date('3-12-1981','dd-mm-yyyy'),  
 3000, null, 20  
);

INSERT INTO SAIMK.emp  
VALUES(  
 7369, 'SMITH', 'CLERK', 7902,  
 to_date('17-12-1980','dd-mm-yyyy'),  
 800, null, 20  
);

INSERT INTO SAIMK.emp  
VALUES(  
 7499, 'ALLEN', 'SALESMAN', 7698,  
 to_date('20-2-1981','dd-mm-yyyy'),  
 1600, 300, 30  
);

INSERT INTO SAIMK.emp  
VALUES(  
 7521, 'WARD', 'SALESMAN', 7698,  
 to_date('22-2-1981','dd-mm-yyyy'),  
 1250, 500, 30  
);

INSERT INTO SAIMK.emp  
VALUES(  
 7654, 'MARTIN', 'SALESMAN', 7698,  
 to_date('28-9-1981','dd-mm-yyyy'),  
 1250, 1400, 30  
);

INSERT INTO SAIMK.emp  
VALUES(  
 7844, 'TURNER', 'SALESMAN', 7698,  
 to_date('8-9-1981','dd-mm-yyyy'),  
 1500, 0, 30  
);

INSERT INTO SAIMK.emp  
VALUES(  
 7876, 'ADAMS', 'CLERK', 7788,  
 to_date('13-JUL-87', 'dd-mm-rr') - 51,  
 1100, null, 20  
);

INSERT INTO SAIMK.emp  
VALUES(  
 7900, 'JAMES', 'CLERK', 7698,  
 to_date('3-12-1981','dd-mm-yyyy'),  
 950, null, 30  
);

INSERT INTO SAIMK.emp  
VALUES(  
 7934, 'MILLER', 'CLERK', 7782,  
 to_date('23-1-1982','dd-mm-yyyy'),  
 1300, null, 10  
);

COMMIT;

/*
 * ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 * SAMPLE QUERIES:
 * ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Simple natural join between DEPT and EMP tables based on the primary key of the DEPT table DEPTNO, and the DEPTNO foreign key in the EMP table.
select ename, dname, job, empno, hiredate, loc  
from emp, dept  
where emp.deptno = dept.deptno  
order by ename;

-- The GROUP BY clause in the SQL statement allows aggregate functions of non grouped columns.  The join is an inner join thus departments with no employees are not displayed.
select dname, count(*) count_of_employees
from dept, emp
where dept.deptno = emp.deptno
group by DNAME
order by 2 desc
 * ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 */