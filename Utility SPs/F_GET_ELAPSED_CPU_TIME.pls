CREATE OR REPLACE FUNCTION f_get_elapsed_cpu_time(p_last_timing PLS_INTEGER, p_msg VARCHAR2, ptimeunit VARCHAR2 DEFAULT 'SECONDS') RETURN VARCHAR2 
IS
BEGIN  
  IF UPPER(ptimeunit) = 'SECONDS' THEN
    RETURN p_msg||ROUND ( (DBMS_UTILITY.get_cpu_time - p_last_timing) / 100, 2);
  END IF;  
END f_get_elapsed_cpu_time;