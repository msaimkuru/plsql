/*
 * -----------------------------------------------------------------------------
 * Resource:
 * -----------------------------------------------------------------------------
 * https://livesql.oracle.com/apex/livesql/file/tutorial_IEHP37S6LTWIIDQIR436SJ59L.html
 * -----------------------------------------------------------------------------
 * What You Should Know Before Beginning to This Tutorial
 * ------------------------------------------------------
 * 1) Before taking this tutorial, you should be proficient with the basics of 
 * SQL and PL/SQL programming. For example, you know how to create procedures 
 * and functions. You know how to write DML statements. 
 * 
 * In addition, it'd be helpful to have some experience with collections, which 
 * are a requirement for use with bulk processing. You might find this blog post 
 * helpful: 
 * -------> https://stevenfeuersteinonplsql.blogspot.com/2018/08/the-plsql-collection-resource-center.html
 * 
 * Be sure to run the Prerequisite SQL below before trying to execute code in 
 * the modules. It creates a local copy of the employees table for you to work 
 * with. All objects required by this tutorial will be dropped and re-created by 
 * the script below. 
 */
/*
 * -----------------------------------------------------------------------------
 * Prerequisite SQL
 * -----------------------------------------------------------------------------
 */
DROP TABLE saimk.employees;

DROP TABLE saimk.departments;

CREATE TABLE saimk.employees AS SELECT * FROM hr.employees;

CREATE TABLE saimk.departments AS SELECT * FROM hr.departments;

COMMENT ON TABLE saimk.employees IS 
'Created for Bulk Processing with PL/SQL Tutorial on https://livesql.oracle.com/apex/livesql/file/tutorial_IEHP37S6LTWIIDQIR436SJ59L.html'
;
/*----------------------------------------------------------------------------*/