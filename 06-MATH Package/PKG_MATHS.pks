CREATE OR REPLACE PACKAGE saimk.pkg_maths 
IS
   FUNCTION f_get_gcd(p_a INTEGER, p_b INTEGER, p_print_msg BOOLEAN DEFAULT FALSE) RETURN INTEGER;
END pkg_maths;