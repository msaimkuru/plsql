CREATE OR REPLACE PACKAGE BODY saimk.pkg_maths 
IS
   --
   PROCEDURE p_print(p_msg VARCHAR2, p_print_msg BOOLEAN DEFAULT FALSE)
   IS
   BEGIN
      IF p_print_msg THEN
         dbms_output.put_line(p_msg);
      END IF;   
   END p_print;
   --
   FUNCTION f_get_gcd(p_a INTEGER, p_b INTEGER, p_print_msg BOOLEAN DEFAULT FALSE) RETURN INTEGER
   IS
      l_result INTEGER := 0;
      l_remainder INTEGER;
      --
      l_a INTEGER := p_a;
      l_b INTEGER := p_b;
      --
      l_step NUMBER := 1;
      --
   BEGIN
      /*
       * -----------------------------------------------------------------------
       * For a detailled explanation and proo please visit:
       * https://www.khanacademy.org/computing/computer-science/cryptography/modarithmetic/a/the-euclidean-algorithm#:~:text=The%20Euclidean%20Algorithm%20for%20finding,%3D%20B%E2%8B%85Q%20%2B%20R)
       * -----------------------------------------------------------------------
       * The idea of this algorithm depends on the Euclid Algorithm. To find the 
       * GCD of 2 integers we can evaluate the GCD of the absolutely smaller 
       * number(as 1st parameter to GCD function) and the result of the mod 
       * operation of the absolutely bigger number and the absolutely smaller 
       * number (as 2nd parameter to GCD function) with an iteration. 
       *
       * That is, 
       * to find GCD(15, 6) we can estimate GCD(6, 15 mod 6) = GCD(6, 3). 
       * And now,to Find GCD(6, 3) we can estimate GCD(3, 6 mod 3) = GCD(3, 0). 
       * After the 1st step in the iteration the second parameter holds the 
       * inter-remainder value, and the first parameter holds the previous value 
       * of the second parameter. 
       *
       * When the second parameter to the GCD function gets 0, it is the
       * stopping point.
       *
       * 1. If ABS(l_a) < ABS(l_b), l_remainder :=  MOD(l_a, l_b) will be l_a, 
       * otherwise it will be the remainder of the l_a / l_b division.
       * 
       * 2. l_a := l_b and then l_b := l_remainder operations will assure the
       * first parameter to the next MOD(l_a, l_b) call will always be 
       * (absolutely) greater or equal to the second parameter, and the second 
       * parameter will always be holding the remainder of internal mod 
       * operations.
       *
       */
      /* -----------------------------------------------------------------------
       * SAMPLE OUTPUT
       * -----------------------------------------------------------------------
         ---------------------- GCD ----------------------
         l_a		l_b		l_remainder
         15		6		
         -------------------------------------------------
         Starting GCD LOOP..
         l_a		l_b		l_remainder		Step#
         -------------------------------------------------
         15		6		3				1
         6		3		0				2
         3		0		0				3
         -------------------------------------------------
         GCD(15, 6) = 3
       * -----------------------------------------------------------------------
       */
      --
      p_print('---------------------- GCD ----------------------', p_print_msg);
      p_print('l_a'||chr(9)||chr(9)||'l_b'||chr(9)||chr(9)||'l_remainder', p_print_msg);
      p_print(l_a||chr(9)||chr(9)||l_b||chr(9)||chr(9)||l_remainder, p_print_msg);
      --
      p_print('-------------------------------------------------', p_print_msg);
      p_print('Starting GCD LOOP..', p_print_msg);
      p_print('l_a'||chr(9)||chr(9)||'l_b'||chr(9)||chr(9)||'l_remainder'||chr(9)||chr(9)||'Step#', p_print_msg);      
      p_print('-------------------------------------------------', p_print_msg);
      --
      WHILE l_b != 0 LOOP
         l_remainder := MOD(l_a, l_b);
         --
         p_print(l_a||chr(9)||chr(9)||l_b||chr(9)||chr(9)||l_remainder||chr(9)||chr(9)||chr(9)||chr(9)||l_step, p_print_msg);      
         --
         l_a := l_b;
         l_b := l_remainder;
         --
         l_step := l_step + 1;
      END LOOP;
      --
      p_print(l_a||chr(9)||chr(9)||l_b||chr(9)||chr(9)||l_remainder||chr(9)||chr(9)||chr(9)||chr(9)||l_step, p_print_msg);
      p_print('-------------------------------------------------', p_print_msg);
      --
      RETURN ABS(l_a);
      --
   END f_get_gcd;
   --
END pkg_maths;