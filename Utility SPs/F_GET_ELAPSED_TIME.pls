CREATE OR REPLACE FUNCTION f_get_elapsed_time(pstart TIMESTAMP, pend TIMESTAMP, p_msg VARCHAR2, ptimeunit VARCHAR2 DEFAULT 'SECONDS') RETURN VARCHAR2 
IS
BEGIN  
  IF UPPER(ptimeunit) = 'SECONDS' THEN
    RETURN p_msg||TO_CHAR(pend-pstart, 'SSSS.FF'); 
  END IF;  
END f_get_elapsed_time;