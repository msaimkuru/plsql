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
   /**
    * @author	Saim Kuru
    * @version 1.0
    * --------------------------------------------------------------------------
    * Calculates Greatest Common Divisor of p_a and p_b
    * --------------------------------------------------------------------------
    * For a detailled explanation and proof please visit:
    * https://www.khanacademy.org/computing/computer-science/cryptography/modarithmetic/a/the-euclidean-algorithm#:~:text=The%20Euclidean%20Algorithm%20for%20finding,%3D%20B%E2%8B%85Q%20%2B%20R)
    * -----------------------------------------------------------------------
    * The idea of this algorithm depends on the Euclid Algorithm. To find  
    * GCD(A, B), we can evaluate GCD(B, A mod B) with an iteration. 
    *
    * That is, 
    * to find GCD(15, 6) we can evaluate GCD(6, 15 mod 6) = GCD(6, 3). And 
    * now,to find GCD(6, 3) we can evaluate GCD(3, 6 mod 3) = GCD(3, 0). 
    * After each step of the iteration the second parameter holds the 
    * inter-remainder value, and the first parameter holds the previous value 
    * of the second parameter. 
    *
    * When the 2nd parameter to the GCD function gets 0, it is the
    * stopping point for the iteration, and the result is the 1st parameter.
    * -----------------------------------------------------------------------
    * Notes:
    * -----------------------------------------------------------------------
    * 1. If ABS(l_a) < ABS(l_b), l_remainder :=  MOD(l_a, l_b) will be l_a, 
    * otherwise it will be the remainder of the l_a / l_b division.
    * 
    * 2. l_a := l_b and then l_b := l_remainder operations will assure the
    * first parameter to the next MOD(l_a, l_b) call will always be 
    * (absolutely) greater or equal to the second parameter, and the second 
    * parameter will always be holding the remainder of internal mod 
    * operations.
    *
    * -----------------------------------------------------------------------
    * Proof that the Euclidean Algorithm Works
    * -----------------------------------------------------------------------       
      Recall this definition: 
      -----------------------
      When a and b are integers and a != 0 we say a divides b, and write a|b, 
      if b/a is an integer.
      -----------------------
      1. Use the definition to prove that if a, b, c, x and y are integers 
      and a|b and a|c, then a|(bx + cy).
      -------
      Answer:
      -------
      We are given that the two quotients b/a and c/a are integers.
      Therefore the integer linear combination 
      (b/a) × x + (c/a) × y = (bx + cy)/a is an integer, which means that 
      a|(bx + cy).
      -------
      2. Use (1) to prove that if a is a positive integer and b, q and r are
      integers with b = aq + r, then gcd(b, a) = gcd(a, r).
      -------
      Answer:
      -------
      Write m = gcd(b, a) and n = gcd(a, r). Since m divides both b 
      and a, it must also divide r = b−aq by (1). This shows that m is a 
      common divisor of a and r, so it must be ≤ n, their greatest common 
      divisor. Likewise, since n divides both a and r, it must divide 
      b = aq +r by (1), so n ≤ m.
      
      Since m ≤ n and n ≤ m, we have m = n.
      -------------------
      Alternative answer: 
      -------------------
      Let c be a common divisor of b and a. Then by (1), c must divide 
      r = b − aq. Thus, the set D of common divisors of b and a is a subset 
      of the set E of common divisors of a and r. 
      
      Now let d be a common divisor of a and r. Then by (1), d must divide 
      b = aq + r. Thus, the set E of common divisors of a and r is a subset 
      of the set D of common divisors of b and a. 
      
      Hence D = E and the largest integer in this set is both gcd(b, a) and
      gcd(a, r). Therefore gcd(b, a) = gcd(a, r).       
    * -----------------------------------------------------------------------
    */
   /* -----------------------------------------------------------------------
    * SAMPLE OUTPUT
    * -----------------------------------------------------------------------
         ---------------------- GCD ----------------------
         l_a		l_b		l_remainder
         15			6		
         -------------------------------------------------
         Starting GCD LOOP..
         l_a		l_b		l_remainder		Step#
         -------------------------------------------------
         15			6		3				1
         6			3		0				2
         3			0		0				3
         -------------------------------------------------
         GCD(15, 6) = 3
    * -----------------------------------------------------------------------
    */ 
   FUNCTION f_get_gcd(p_a INTEGER, p_b INTEGER, p_print_msg BOOLEAN DEFAULT FALSE) RETURN INTEGER
   IS
      l_remainder INTEGER;
      --
      l_a INTEGER := p_a;
      l_b INTEGER := p_b;
      --
      l_step NUMBER := 1;
      --
   BEGIN
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