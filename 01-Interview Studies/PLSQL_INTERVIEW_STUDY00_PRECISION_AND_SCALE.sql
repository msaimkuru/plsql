/*
 * For numeric columns, you can specify the column as:
 * column_name NUMBER 
 * 
 * Optionally, you can also specify a precision (total number of digits) and 
 * scale (number of digits to the right of the decimal point):
 *
 * column_name NUMBER (precision, scale) 
 * 
 * If a precision is not specified, the column stores values as given. 
 * If no scale is specified, the scale is zero.
 *
 * Oracle guarantees portability of numbers with a precision equal to or less 
 * than 38 digits. You can specify a scale and no precision:
 * 
 * column_name NUMBER (*, scale) 
 * In this case, the precision is 38, and the specified scale is maintained.
 *
 * If you specify a negative scale, Oracle Database rounds the actual data to 
 * the specified number of places to the left of the decimal point. For example, 
 * specifying (7,-2) means Oracle Database rounds to the nearest hundredths
 */

DECLARE
    NUMERIC_VALUE_ERROR EXCEPTION;
    PRAGMA EXCEPTION_INIT(NUMERIC_VALUE_ERROR, -6502);
    
    l_nv1 NUMBER(4,2);  /* Maximum of 4 digits, max 2 digits for after decimal points, max 2 digits for before decimal digits */
    l_nv2 NUMBER(4,-2); /* Maximum of 6 digits, max 0 digits for after decimal points, max 6 digits for before decimal digits, rounded with respect to laast 2 digit */
BEGIN
    l_nv1:= 3.184;
    DBMS_OUTPUT.PUT_LINE('l_nv1-->'||l_nv1);
    l_nv1 := 43.5;
    DBMS_OUTPUT.PUT_LINE('l_nv1-->'||l_nv1);
    l_nv1 := 43.21;
    DBMS_OUTPUT.PUT_LINE('l_nv1-->'||l_nv1);
    l_nv1 := 43.216;
    l_nv2 := 147889.21;
    DBMS_OUTPUT.PUT_LINE('l_nv1-->'||l_nv1);
    DBMS_OUTPUT.PUT_LINE('l_nv2-->'||l_nv2);
    DBMS_OUTPUT.PUT_LINE('l_nv3-->'||l_nv3);
    l_nv1 := 143.2;
    DBMS_OUTPUT.PUT_LINE('l_nv1-->'||l_nv1);  
    
    EXCEPTION
        WHEN NUMERIC_VALUE_ERROR THEN
            DBMS_OUTPUT.PUT_LINE(SQLERRM);
            RAISE;
END
;    