/* 
 * Resource:
 * ---------
 * https://livesql.oracle.com/apex/livesql/file/tutorial_IEHP37S6LTWIIDQIR436SJ59L.html
 * -----------------------------------------------------------------------------
 * 3. Possible Solutions For The Row by Row Problem
 * ----------------------------------------------------------------------------- 
 * Generally, the way to improve performance over row-by-row context switching 
 * is to not perform row-by-row DML operations. This can be accomplished in one 
 * of two ways:
 * 
 * 1. Implement the functionality in "pure" SQL - no PL/SQL loop.
 * 2. Use the bulk processing features of PL/SQL.
 * 
 * If you can change your implementation to avoid a loop and instead simply 
 * execute a single DML statement, that should be done. 
 * For example, we can do this with the increase_salary procedure:

        CREATE OR REPLACE PROCEDURE increase_salary (
           department_id_in   IN employees.department_id%TYPE,
           increase_pct_in    IN NUMBER)
        IS
        BEGIN
           UPDATE employees emp
              SET emp.salary =
                       emp.salary
                     + emp.salary * increase_salary.increase_pct_in
            WHERE emp.department_id = 
                     increase_salary.department_id_in;
        END increase_salary;
 * 
 * Of course, it is not always this easy. You might be doing some very complex 
 * processing of each row before doing the insert, update or delete that would 
 * be hard to do in SQL. You may need to do more nuanced error management than 
 * "all or nothing" SQL will allow. Or you might simply not have sufficient 
 * knowledge of SQL to do what's needed.
 * 
 * In an ideal world, you would stop programming and take an advanced SQL class 
 * (the Oracle Dev Gym offers a free one on SQL analytic functions). In the real
 * world, you need to get the program up and running ASAP.
 * 
 * Whatever your situation, the bulk processing features of PL/SQL offer a 
 * straightforward solution - though there will be a lot to consider as you 
 * implement your conversion to BULK COLLECT and FORALL.
 *
 * Let's first take a look at BULK COLLECT, which improves the performance of 
 * multi-row querying and is relatively simple. Then we'll move on to FORALL, 
 * which is used to execute the same non-query DML statement repeatedly, with 
 * different bind variables. That feature has a lot more moving parts and issues 
 * you need to take into account (which should come as no surprise, as you are 
 * changing data, not simply querying it.
 */