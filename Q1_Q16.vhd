-- Mealy Machine (mealy.vhd)
-- Asynchronous reset, active low
------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY recog2 IS
PORT(
  x: in BIT;
  clk: in BIT;
  reset: in BIT;
  y: out BIT);
end;


ARCHITECTURE myArch OF recog2 IS
  -- State declaration
  TYPE state_type IS (INIT, COUNT_0, COUNT_1);  -- List your states here 	
  SIGNAL curState: state_type;
  SIGNAL nextState: state_type;
  --------------------------------------------------------------------------
    --SIGNALS 
  SIGNAL c_value : integer RANGE 0 to 31; -- ONLY NEED 0 TO 255 (8 BITS)
  SIGNAL m: std_logic_vector(1 downto 0);
  SIGNAL x_reg : BIT;
  --------------------------------------------------------------------------
BEGIN
  -----------------------------------------------------
  combi_nextState: PROCESS(curState, x_reg)
  BEGIN
    CASE curState IS
      WHEN INIT =>
        IF x_reg='0' THEN
          m<="11";			--ADD
          nextState <= COUNT_0;
        ELSE
          m<="00";			-- RESET
          nextState <= INIT;
        END IF;
      WHEN COUNT_0 =>
        IF (c_value=15) AND (x_reg='1') THEN
            m<="01";  -- SET TO 1
        	nextState <= COUNT_1;     
        ELSIF x_reg='0' THEN
          m<="11";			--ADD
          nextState <= COUNT_0;
          -----------------------------------------
        ELSIF c_value>15 AND x_reg='1' THEN
          m<="01";
          nextState <= COUNT_1;
          ------------------------------------------
        ELSE
          m<="00";			--RESET
          nextState <= INIT;
        END IF;
      WHEN COUNT_1 =>
        IF (c_value=16) THEN
          m<="00";			--RESET
          nextState <= INIT;
        ELSIF x_reg='1' THEN
          nextState <= COUNT_1;
          m<="11";			--ADD
        ELSE
          m<="01";   -- SET TO 1
          nextState <= COUNT_0;
        END IF; 
      WHEN OTHERS =>
          nextState <= INIT;
          m<="00";			--RESET


    END CASE;
  END PROCESS; -- combi_nextState
  -----------------------------------------------------
  combi_out: PROCESS(curState,c_value)
  BEGIN
    y <= '0'; -- assign default value
    IF (curState = COUNT_1) AND c_value=16 THEN y <= '1';
    END IF;
  END PROCESS; -- combi_output
  -----------------------------------------------------
  seq_state: PROCESS (clk, reset)
  BEGIN
    IF reset = '0' THEN
      curState <= INIT;
      -----------------------
      --c_value<=0; -- RESET
      -----------------------
    ELSIF clk'EVENT AND clk='1' THEN
      curState <= nextState;
      x_reg <= x;
      -----------------------
      --IF (m='1') THEN c_value<=c_value+1;-- INCREMENT
      --ELSE c_value<=0; -- RESET
      -------------------------
      	  
      --END IF;
    END IF;
  END PROCESS; -- seq
-------------------------------------------------------
  seq1_state: PROCESS (clk, m)
  BEGIN
    IF (reset = '0') OR (m="00") OR (m="10") THEN
      -----------------------
      c_value<=0; -- RESET
      -----------------------
    ELSIF clk'EVENT AND clk='1' THEN
      -----------------------
      IF m="11" THEN c_value<=c_value+1;-- INCREMENT
      ELSIF m="01" THEN c_value<=1;
      ELSE c_value<=0;
      -------------------------
	  END IF;
    END IF;
  END PROCESS; -- seq1
  -----------------------------------------------------
  

  
END; -- arch_mealy

