/* 
 * Resource: 
 * ---------
 * https://oracle-base.com/articles/misc/performance-of-numeric-data-types-in-plsql
 * -----------------------------------------------------------------------------
 * Performance of Numeric Data Types in PL/SQL
 * -----------------------------------------------------------------------------
 * Oracle provide a variety of numeric data types that have differing 
 * performance characteristics. This article demonstrates the performance 
 * differences between the basic integer and real number datatypes.
 * 
 * - NUMBER Data Type
 * - Integer Data Types
 * - Real Number Data Types
 * 
 * -----------------------------------------------------------------------------
 * NUMBER Data Type
 * ----------------------------------------------------------------------------- 
 * The NUMBER data type is the supertype of all numeric datatypes. It is an 
 * internal type, meaning the Oracle program performs the mathematical 
 * operations, making it slower, but extremely portable. All the tests in this 
 * article will compare the performance of other types with the NUMBER data 
 * type.
 * -----------------------------------------------------------------------------
 * Integer Data Types
 * -----------------------------------------------------------------------------
 * The following code compares the performance of some integer data types with 
 * that of the NUMBER data type.
 */

SET SERVEROUTPUT ON
DECLARE
  l_number1          NUMBER := 1;
  l_number2          NUMBER := 1;
  l_integer1         INTEGER := 1;
  l_integer2         INTEGER := 1;
  l_pls_integer1     PLS_INTEGER := 1;
  l_pls_integer2     PLS_INTEGER := 1;
  l_binary_integer1  BINARY_INTEGER := 1;
  l_binary_integer2  BINARY_INTEGER := 1;
  l_simple_integer1  SIMPLE_INTEGER := 1;
  l_simple_integer2  SIMPLE_INTEGER := 1;
  l_loops            NUMBER := 10000000;
  l_start            NUMBER;
BEGIN
  -- Time NUMBER.
  l_start := DBMS_UTILITY.get_time;
  
  FOR i IN 1 .. l_loops LOOP
    l_number1 := l_number1 + l_number2;
  END LOOP;
  
  DBMS_OUTPUT.put_line('NUMBER         : '||(DBMS_UTILITY.get_time - l_start) || ' hsecs');

  -- Time INTEGER.
  l_start := DBMS_UTILITY.get_time;
  
  FOR i IN 1 .. l_loops LOOP
    l_integer1 := l_integer1 + l_integer2;
  END LOOP;
  
  DBMS_OUTPUT.put_line('INTEGER        : '||(DBMS_UTILITY.get_time - l_start) || ' hsecs');

  -- Time PLS_INTEGER.
  l_start := DBMS_UTILITY.get_time;
  
  FOR i IN 1 .. l_loops LOOP
    l_pls_integer1 := l_pls_integer1 + l_pls_integer2;
  END LOOP;
  
  DBMS_OUTPUT.put_line('PLS_INTEGER    : '||(DBMS_UTILITY.get_time - l_start) || ' hsecs');

  -- Time BINARY_INTEGER.
  l_start := DBMS_UTILITY.get_time;
  
  FOR i IN 1 .. l_loops LOOP
    l_binary_integer1 := l_binary_integer1 + l_binary_integer2;
  END LOOP;
  
  DBMS_OUTPUT.put_line('BINARY_INTEGER : '||(DBMS_UTILITY.get_time - l_start) || ' hsecs');

  -- Time SIMPLE_INTEGER.
  l_start := DBMS_UTILITY.get_time;
  
  FOR i IN 1 .. l_loops LOOP
    l_simple_integer1 := l_simple_integer1 + l_simple_integer2;
  END LOOP;
  
  DBMS_OUTPUT.put_line('SIMPLE_INTEGER : '||(DBMS_UTILITY.get_time - l_start) || ' hsecs');
END;

/*
 * -----------------------------------------------------------------------------
 * Analyzing Outputs
 * -----------------------------------------------------------------------------
 * NUMBER         : 16 hsecs
 * INTEGER        : 30 hsecs
 * PLS_INTEGER    : 4 hsecs
 * BINARY_INTEGER : 5 hsecs
 * SIMPLE_INTEGER : 5 hsecs
 * 
 * From this we can make a number of conclusions:
 * 
 * NUMBER: As mentioned previously, since NUMBER is an internal datatype, it is 
 *         not the fastest of the numeric types.
 *
 * INTEGER: Like NUMBER, the INTEGER type is an internal type, but the extra 
 *          constraints on this datatype make it substantially slower than
 *          NUMBER.If possible, you should avoid constrained internal datatypes.
 *
 * PLS_INTEGER: This type uses machine arithmetic, making it much faster than 
 *              the internal datatypes. If in doubt, you should use PLS_INTEGER 
 *              for integer variables.
 *
 * BINARY_INTEGER: Prior to Oracle 10g, BINARY_INTEGER was an internal type with 
 *                 performance characteristics worse than the INTEGER datatype.
 *                 From Oracle 10g upward BINARY_INTEGER is identical to 
 *                 PLS_INTEGER.
 *                
 * SIMPLE_INTEGER: This subtype of PLS_INTEGER was introduced in Oracle 11g. In 
 *                 interpreted mode it has similar performance to BINARY_INTEGER 
 *                 and PLS_INTEGER, but in natively compiled code it is 
 *                 typically about twice as fast as those types. You can read 
 *                 more about the SIMPLE_INTEGER data type here.
 *
 * There are additional predefined subtypes of PLS_INTEGER, listed here.
 *
 * If you are dealing with an integer value, using PLS_INTEGER is a safe option. 
 * It has good performance, whilst still having all the boundary checking. Only
 * use other data types if you have a specific need they meet.
 */

/*
 * -----------------------------------------------------------------------------
 * Real Number Data Types
 * -----------------------------------------------------------------------------
 * Oracle 10g introduced the BINARY_FLOAT and BINARY_DOUBLE data types to handle 
 * real numbers. Both new types use machine arithmetic, making them faster than 
 * the NUMBER data type, as shown in the following example.
 */
SET SERVEROUTPUT ON
DECLARE
  l_number1         NUMBER := 1.1;
  l_number2         NUMBER := 1.1;
  l_binary_float1   BINARY_FLOAT := 1.1;
  l_binary_float2   BINARY_FLOAT := 1.1;
  l_simple_float1   SIMPLE_FLOAT := 1.1;
  l_simple_float2   SIMPLE_FLOAT := 1.1;
  l_binary_double1  BINARY_DOUBLE := 1.1;
  l_binary_double2  BINARY_DOUBLE := 1.1;
  l_simple_double1  SIMPLE_DOUBLE := 1.1;
  l_simple_double2  SIMPLE_DOUBLE := 1.1;
  l_loops           NUMBER := 10000000;
  l_start           NUMBER;
BEGIN
  -- Time NUMBER.
  l_start := DBMS_UTILITY.get_time;
  
  FOR i IN 1 .. l_loops LOOP
    l_number1 := l_number1 + l_number2;
  END LOOP;
  
  DBMS_OUTPUT.put_line('NUMBER         : '||(DBMS_UTILITY.get_time - l_start) || ' hsecs');

  -- Time BINARY_FLOAT.
  l_start := DBMS_UTILITY.get_time;
  
  FOR i IN 1 .. l_loops LOOP
    l_binary_float1 := l_binary_float1 + l_binary_float2;
  END LOOP;
  
  DBMS_OUTPUT.put_line('BINARY_FLOAT   : '||(DBMS_UTILITY.get_time - l_start) || ' hsecs');

  -- Time SIMPLE_FLOAT.
  l_start := DBMS_UTILITY.get_time;
  
  FOR i IN 1 .. l_loops LOOP
    l_simple_float1 := l_simple_float1 + l_simple_float2;
  END LOOP;
  
  DBMS_OUTPUT.put_line('SIMPLE_FLOAT   : '||(DBMS_UTILITY.get_time - l_start) || ' hsecs');

  -- Time BINARY_DOUBLE.
  l_start := DBMS_UTILITY.get_time;
  
  FOR i IN 1 .. l_loops LOOP
    l_binary_double1 := l_binary_double1 + l_binary_double2;
  END LOOP;
  
  DBMS_OUTPUT.put_line('BINARY_DOUBLE  : '||(DBMS_UTILITY.get_time - l_start) || ' hsecs');

  -- Time SIMPLE_DOUBLE.
  l_start := DBMS_UTILITY.get_time;
  
  FOR i IN 1 .. l_loops LOOP
    l_simple_double1 := l_simple_double1 + l_simple_double2;
  END LOOP;
  
  DBMS_OUTPUT.put_line('SIMPLE_DOUBLE  : '||(DBMS_UTILITY.get_time - l_start) || ' hsecs');
END;

/*
 * -----------------------------------------------------------------------------
 * Analyzing Outputs
 * -----------------------------------------------------------------------------
 * NUMBER         : 15 hsecs
 * BINARY_FLOAT   : 8 hsecs
 * SIMPLE_FLOAT   : 8 hsecs
 * BINARY_DOUBLE  : 6 hsecs
 * SIMPLE_DOUBLE  : 8 hsecs
 * 
 * Both BINARY_FLOAT and BINARY_DOUBLE out-perform the NUMBER data type, but the 
 * fact they use machine arithmetic can potentially make them less portable. The 
 * same mathematical operations performed on two different underlying 
 * architectures may result in minor rounding errors. If portability is your 
 * primary concern, then you should use the NUMBER type, otherwise you can take
 * advantage of these types for increased performance.
 * 
 * Similar to SIMPLE_INTEGER, SIMPLE_FLOAT and SIMPLE_DOUBLE provide improved 
 * performance in natively compiled code because of the removal of the code path 
 * associated with NULL processing, since they can't be assigned a NULL value.
 * 
 * If you are dealing with anything to do with finance, I would stick to using 
 * NUMBER. For anything else the BINARY_* data types probably make more sense.
 * If in doubt use NUMBER.
 */