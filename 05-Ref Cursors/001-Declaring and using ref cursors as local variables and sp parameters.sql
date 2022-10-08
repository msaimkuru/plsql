/*
 * -----------------------------------------------------------------------------
 * EXAMPLE 1:
 * ----------------------------------------------------------------------------- 
 * Declaring and using ref cursor as a local variable, sp parameter
 * -----------------------------------------------------------------------------  
 */
/*
 * @author	Saim Kuru
 * @version 1.0
 */ 
DECLARE
   /*
    * An sp with a ref cursor parameter
    */
   PROCEDURE p_show_data_char_number(p_cv_in IN SYS_REFCURSOR)
   IS
      TYPE data_rt IS RECORD
      (
         string_value VARCHAR2 (32767),
         number_value NUMBER
      );
      --
      TYPE data_t IS TABLE OF data_rt;
      --
      l_data data_t;
   BEGIN
      FETCH p_cv_in
      BULK COLLECT 
      INTO l_data
      ;
      --
      FOR idx IN 1 .. l_data.COUNT
      LOOP
         DBMS_OUTPUT.put_line( l_data(idx).string_value
                              || '-'
                              || l_data(idx).number_value);
      END LOOP;
   END p_show_data_char_number;
BEGIN 
   DECLARE
      l_ref_cursor_variable SYS_REFCURSOR;
   BEGIN
      OPEN l_ref_cursor_variable FOR
         SELECT *
         FROM (SELECT 'Feuerstein' nam, 1000 num
               FROM sys.DUAL
               UNION
               SELECT 'Ng', 100
               FROM sys.DUAL
               )
         ORDER BY nam;
      /*
       * Call sp with a ref cursor
       */
      p_show_data_char_number(l_ref_cursor_variable);
      --
      CLOSE l_ref_cursor_variable;
   END;
END;
/*----------------------------------------------------------------------------*/