-- Mealy Machine (mealy.vhd)
-- Asynchronous reset, active low
------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY recog1 IS
PORT(
  x: in STD_ULOGIC;
  clk: in STD_ULOGIC;
  reset: in STD_ULOGIC;
  y: out STD_ULOGIC);
end;


ARCHITECTURE arch_mealy OF recog1 IS
  -- State declaration
  TYPE state_type IS (BIT_0, BIT_1, BIT_2);  -- List your states here 	
  SIGNAL curState, nextState: state_type;
  SIGNAL count_num: STD_ULOGIC;
  SIGNAL en: bit;
BEGIN
  -----------------------------------------------------
  combi_nextState: PROCESS(curState, x)
  BEGIN
    CASE curState IS
      --count = 0;
      en = '0';
      WHEN BIT_0 =>
        IF x='0' THEN 
          nextState <= BIT_1;
          en <= '1';
        ELSE
          nextState <= BIT_0;
          en <= '0';
        END IF;
      WHEN BIT_1 =>
        IF x='0' THEN
          nextState <= BIT_1;
          en <= '1';
        ELSE IF count_num = '01110' THEN
          count_num <= '00000';
          nextState <= BIT_2;
          en <= '1';
        END IF;
      WHEN BIT_2 =>
        IF x='1' THEN 
          nextState <= BIT_2;
          en <= '1';
        ELSE IF x='0' THEN
          count_num <= '00000'
          en <= '1';
          nextState <= BIT_0;
        ELSE IF (x='1') AND (count_num = '10000') THEN
          nextState <= BIT_0
          en <= '0';
          
        END IF;

    END CASE;
    
  END PROCESS; -- combi_nextState
  -----------------------------------------------------
  combi_out: PROCESS(curState, x)
  BEGIN
    y <= '0'; -- assign default value
    IF (curState = BIT_3) AND x='0' THEN
      y <= '1';
    END IF;
  END PROCESS; -- combi_output
  -------------------STATE----------------------------------
  seq_state: PROCESS (clk, reset)
  BEGIN
    IF reset = '0' THEN
      curState <= BIT_0;
    ELSIF clk'EVENT AND clk='1' THEN
      curState <= nextState;
		  IF en = '1' THEN -- enable
		     count_num <= count_num + 1;
      
    END IF;
  END PROCESS; -- seq
  -----------------------------------------------------
END; -- arch_mealy


--------------------------------------------------------------------------------------------------------------------------------------------------------------------





















