DECLARE
   TYPE employees_t IS TABLE OF saimk.employees%ROWTYPE INDEX BY PLS_INTEGER;
   --
   l_employees   employees_t;
BEGIN
   IF l_employees IS NULL THEN
      dbms_output.put_line('Point 1: l_employees is null..');
   ELSE    
      dbms_output.put_line('Point 1: l_employees.COUNT: '||l_employees.COUNT);   
   END IF; 
   --
   SELECT *
   BULK COLLECT 
   INTO l_employees
   FROM saimk.employees
   WHERE 1=2;
   --
   IF l_employees IS NULL THEN
      dbms_output.put_line('Point 2: l_employees is null..');
   ELSE    
      dbms_output.put_line('Point 2: l_employees.COUNT: '||l_employees.COUNT);   
   END IF;   
END;