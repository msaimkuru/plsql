CREATE OR REPLACE PROCEDURE SAIMK.test_ex_cr_impl_cr_for_cr_prf2 (approach IN VARCHAR2, p_bulk_fetch_limit NUMBER, p_country VARCHAR2)
IS
   L_T1 TIMESTAMP;
   L_T2 TIMESTAMP;
   --
   CURSOR cur IS
      SELECT * FROM saimk.trashbigdata t 
      WHERE (p_country IS NULL OR t.country = p_country)
      ;
   --   
   one_row cur%ROWTYPE;
   --
   TYPE t IS TABLE OF cur%ROWTYPE INDEX BY PLS_INTEGER;
   --
   many_rows     t;
   last_timing   NUMBER;
   cntr number := 0;
   --
   PROCEDURE start_timer
   IS
   BEGIN
      last_timing := DBMS_UTILITY.get_cpu_time;
   END;
   --
   PROCEDURE show_elapsed_time (message_in IN VARCHAR2 := NULL)
   IS
   BEGIN
      DBMS_OUTPUT.put_line (
            '"'
         || message_in
         || '" completed in: '
         || TO_CHAR (
               SAIMK.f_get_elapsed_cpu_time(last_timing, NULL))
         ||' seconds..');
   END;
   --
BEGIN
   --
   start_timer;
   l_t1 := systimestamp;
   --
   CASE approach
      WHEN 'implicit cursor for loop'
      THEN
         FOR j IN cur
         LOOP
            cntr := cntr + 1;
         END LOOP;

         DBMS_OUTPUT.put_line ('Number of Rows Fetched-->'||cntr);

      WHEN 'explicit open, fetch, close'
      THEN
         OPEN cur;

         LOOP
            FETCH cur INTO one_row;
            EXIT WHEN cur%NOTFOUND;
            cntr := cntr + 1;
         END LOOP;

         DBMS_OUTPUT.put_line ('Number of Rows Fetched-->'||cntr);

         CLOSE cur;
      WHEN 'bulk fetch'
      THEN
         OPEN cur;

         LOOP
            FETCH cur BULK COLLECT INTO many_rows LIMIT p_bulk_fetch_limit;
            EXIT WHEN many_rows.COUNT () = 0;

            FOR indx IN 1 .. many_rows.COUNT
            loop
               cntr := cntr + 1;
            end loop;
         END LOOP;

         DBMS_OUTPUT.put_line ('Number of Rows Fetched-->'||cntr);

         CLOSE cur;
   END CASE;
   --
   l_t2 := systimestamp;
   --
   show_elapsed_time (approach);
   dbms_output.put_line(saimk.f_get_elapsed_time(l_t1, l_t2, 'Elapsed time:'));
END test_ex_cr_impl_cr_for_cr_prf2;
/