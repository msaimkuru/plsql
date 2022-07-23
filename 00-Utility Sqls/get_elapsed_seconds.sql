DECLARE 
  t1 TIMESTAMP; 
  t2 TIMESTAMP; 
  l_name varchar2(30); 
begin 
  t1 := systimestamp; 
  --
  FOR c1 IN (SELECT * FROM saimk.trashbigdata WHERE ROWNUM < 1000000) LOOP 
    l_name := NULL;
  END LOOP;
  --
  t2 := systimestamp;
  --
  DBMS_OUTPUT.PUT_LINE('Start: '||t1); 
  DBMS_OUTPUT.PUT_LINE('  End: '||t2); 
  DBMS_OUTPUT.PUT_LINE(SAIMK.f_get_elapsed_time(t1, t2, 'Elapsed Time --> ')); 
END; 
