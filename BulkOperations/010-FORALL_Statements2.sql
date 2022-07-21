/*
 * Source: https://livesql.oracle.com/apex/f?p=590:1:4704207031745:CLEAR::1:TUTORIAL_ID,P1_SHOW_LEARN_SIDEBAR:182241645422959190146194127811898911783,Y
 * -----------------------------------------------------------------------------
 * Introduction to FORALL-2
 * -----------------------------------------------------------------------------
 * The real world is usually a little bit more interesting. For example, we 
 * will often have an array of values that we bind into the WHERE clause and 
 * also one or more arrays of values that we use in the SET clause of an update 
 * statement (or to provide values for columns of an INSERT statement in the
 * VALUES clause).
 * 
 * FORALL takes care of all that exactly as you'd expect - but it is up to you 
 * to make sure that the data is in synch across all your collections. In the 
 * block below, we update rows by employee NO with a new salary and name 
 * specific to each ID.
 */
DECLARE
   /* We use pre-defined collection types to reduce code volume. */
   l_ids        DBMS_SQL.number_table;
   l_names      DBMS_SQL.varchar2a;
   l_salaries   DBMS_SQL.number_table;
   --
BEGIN
   l_ids (1) := 7876;
   l_ids (2) := 7900;
   l_ids (3) := 7902;
   --
   l_names (1) := 'Sneezy';
   l_names (2) := 'Bashful';
   l_names (3) := 'Happy';
   --
   l_salaries (1) := 1300;
   l_salaries (2) := 1050;
   l_salaries (3) := 4000;
   --
   FORALL indx IN 1 .. l_ids.COUNT
   UPDATE SAIMK.emp
   SET ename = l_names (indx)
      ,sal = l_salaries (indx)
   WHERE empno = l_ids (indx)
   ;
   --
   DBMS_OUTPUT.PUT_LINE('Info-->'||SQL%ROWCOUNT||' rows updated by "FORALL", and will be ROLLBACKed.');
   --
   FOR emp_rec IN (  SELECT ename, sal
                       FROM SAIMK.emp
                      WHERE empno IN (7876, 7900, 7902)
                   ORDER BY empno)
   LOOP
      --
      DBMS_OUTPUT.put_line (emp_rec.ename || ' - ' || emp_rec.sal);
      --
   END LOOP;
   --
   ROLLBACK;
END;

/* 
 * If we do not keep the indexes in synch across all columns, I will get errors,
 * as you will see when you run this block:
 */

DECLARE
   --
   l_ids        DBMS_SQL.number_table;
   l_names      DBMS_SQL.varchar2a;
   l_salaries   DBMS_SQL.number_table;
   --
BEGIN
   --
   l_ids (1) := 7876;
   l_ids (2) := 7900;
   l_ids (3) := 7902;
   --
   l_names (1) := 'Sneezy';
   l_names (100) := 'Happy';
   --
   l_salaries (-1) := 1000;
   l_salaries (200) := 1500;
   l_salaries (3) := 2000;
   --
   FORALL indx IN 1 .. l_ids.COUNT
   UPDATE SAIMK.emp
   SET ename = l_names (indx), sal = l_salaries (indx)
   WHERE empno = l_ids (indx);
   --
   ROLLBACK;
   --
END;

/*
 * ORA-22160: element at index [N] does not exist
 * So: by all means, you can reference multiple bind arrays, but make sure they 
 * are consistent across index values (often this is not an issue, as the 
 * collections are loaded from the same BULK COLLECT query).
 * 
 * Here are some important things to remember about FORALL:
 * 
 * 1) Each FORALL statement may contain just a single DML statement. If your 
 * loop contains two updates and a delete, then you will need to write three 
 * FORALL statements.
 * 
 * 2) PL/SQL declares the FORALL iterator as an integer, just as it does with a 
 * FOR loop. You do not need to (and should not) declare a variable with this 
 * same name.
 * 
 * 3) In at least one place in the DML statement, you need to reference a 
 * collection and use the FORALL iterator as the index value in that collection.
 * 
 * 4) When using the IN low_value . . . high_value syntax in the FORALL header, 
 * the collections referenced inside the FORALL statement must be densely 
 * filled. That is, every index value between the low_value and high_value must 
 * be defined.
 * 
 * 5) If your collection is not densely filled, you should use the INDICES OF or 
 * VALUES OF syntax in your FORALL header.
 */