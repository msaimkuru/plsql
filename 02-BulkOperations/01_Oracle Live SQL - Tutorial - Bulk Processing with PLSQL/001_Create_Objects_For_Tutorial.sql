/*
 * Resource:
 * ---------
 * https://livesql.oracle.com/apex/livesql/file/tutorial_IEHP37S6LTWIIDQIR436SJ59L.html
 * 
 * All objects will be dropped and the objects required by this tutorial will be 
 * created. 
 */

DROP TABLE  saimk.employees;
/ 

CREATE TABLE saimk.employees AS SELECT * FROM hr.employees;
/

COMMENT ON TABLE saimk.employees IS 
'Created for Bulk Processing with PL/SQL Tutorial on https://livesql.oracle.com/apex/livesql/file/tutorial_IEHP37S6LTWIIDQIR436SJ59L.html'
;