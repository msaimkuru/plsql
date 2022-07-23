/*
 * source url:
 * https://www.guru99.com/pl-sql-interview-questions-answers.html
 *
 * Study Date: 18.07.2022
 */

/*
 * Question 6: Name the two exceptions in PL/SQL?
 * Question 7: Show some predefined exceptions. 
 -------------------------------------------------------------------------------
 * Answers:
 -------------------------------------------------------------------------------
 * Error handling part of PL/SQL is called an exception.  We have two types of
 * exceptions, and they are User-defined and predefined.
 ---------------------------------
 * SOME PREDEFINED EXCEPTIONS:
 ---------------------------------
 * DUP_VAL_ON_INDEX
 * ZERO_DIVIDE
 * NO_DATA_FOUND
 * TOO_MANY_ROWS
 * CURSOR_ALREADY_OPEN
 * INVALID_NUMBER
 * INVALID_CURSOR
 * PROGRAM_ERROR
 * TIMEOUT_ON_RESOURCE
 * STORAGE_ERROR
 * LOGON_DENIED
 * VALUE_ERROR
 */
 
 /* ----------------------------------------------------------------------------
  * Associating a PL/SQL Exception with a Number: Pragma EXCEPTION_INIT
  * ----------------------------------------------------------------------------
  * The exception_init PRAGMA instructs Oracle to assign a name to a standard 
  * Oracle error message that does not have an associated named exception. 
  *
  * To handle error conditions (typically ORA- messages) that have no predefined 
  * name, you must use the OTHERS handler or the pragma EXCEPTION_INIT. A pragma 
  * is a compiler directive that is processed at compile time, not at run time.
  *
  * In PL/SQL, the pragma EXCEPTION_INIT tells the compiler to associate an 
  * exception name with an Oracle error number. That lets you refer to any 
  * internal exception by name and to write a specific handler for it. 
  * You code the pragma EXCEPTION_INIT in the declarative part of a PL/SQL block
  * , subprogram, or package using the syntax
  *     PRAGMA EXCEPTION_INIT(exception_name, -Oracle_error_number);
  * where exception_name is the name of a previously user declared exception and 
  * the number is a negative value corresponding to an ORA- error number. 
  * The pragma must appear somewhere after the exception declaration in the same 
  * declarative section.
  *
  * Exception_init will associate the Oracle predefined error code to a user 
  * defined name so that this name can be used in the WHEN clause of the 
  * exception section explicitly.
  */
DECLARE
   xTableDoesNotExist    EXCEPTION;
   PRAGMA exception_init (xTableDoesNotExist, -942);
   --
   Type t_rc IS REF CURSOR;
   lv_rc t_rc;
   lv_cnt NUMBER;
   --
   dynsql VARCHAR2(100) := 'SELECT COUNT(*) FROM EMPXYZ';
   --
BEGIN   
    OPEN lv_rc FOR dynsql;
    FETCH lv_rc INTO lv_cnt;
    CLOSE lv_rc;
    --
    DBMS_OUTPUT.PUT_LINE('lv_cnt-->'||lv_cnt);
    --
    EXCEPTION
        WHEN xTableDoesNotExist THEN
            IF lv_rc%ISOPEN THEN
                DBMS_OUTPUT.PUT_LINE('Closing cursor lv_rc');
                CLOSE lv_rc;
            END IF;    
            RAISE_APPLICATION_ERROR(-20001, 'TABLE or VIEW DOES NOT EXIST (EMPXYZ)');

END;


/* ----------------------------------------------------------------------------- 
 * Defining Your Own Error Messages: Procedure RAISE_APPLICATION_ERROR
 * ----------------------------------------------------------------------------
 * The procedure RAISE_APPLICATION_ERROR lets you issue user-defined ORA- error 
 * messages from stored subprograms. That way, you can report errors to your 
 * application and avoid returning unhandled exceptions.
 *
 * To call RAISE_APPLICATION_ERROR, use the syntax
 * 
 * raise_application_error(error_number, message[, {TRUE | FALSE}]);
 * where error_number is a negative integer in the range -20000 .. -20999 and 
 * message is a character string up to 2048 bytes long. If the optional third 
 * parameter is TRUE, the error is placed on the stack of previous errors. If 
 * the parameter is FALSE (the default), the error replaces all previous errors. 
 * RAISE_APPLICATION_ERROR is part of package DBMS_STANDARD, and as with 
 * package STANDARD, you do not need to qualify references to it.
 */
 
DECLARE
    LOCAL_EXCEPTION_DIV_BY_ZERO EXCEPTION;
    PRAGMA EXCEPTION_INIT(LOCAL_EXCEPTION_DIV_BY_ZERO, -1476);
    --
    lv0 NUMBER := 0;
    lv1 NUMBER := 4;
    lv_result NUMBER;
    --
BEGIN   
    BEGIN
        lv_result := lv1 / lv0;
        EXCEPTION 
            WHEN LOCAL_EXCEPTION_DIV_BY_ZERO THEN
                DBMS_STANDARD.RAISE_APPLICATION_ERROR(-20001, 'My Exception Definition for Division By Zero Error!', TRUE);
    END;
    --
    EXCEPTION 
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_STACK);
            DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
END;