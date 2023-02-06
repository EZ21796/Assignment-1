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
  TYPE state_type IS (BIT_0, BIT_1, BIT_2, BIT_3);  -- List your states here 	
  SIGNAL curState, nextState: state_type;
BEGIN
  -----------------------------------------------------
  combi_nextState: PROCESS(curState, x)
  BEGIN
    CASE curState IS
      WHEN BIT_0 =>
        IF x='1' THEN 
          nextState <= BIT_1;
        ELSE
          nextState <= BIT_0;
        END IF;
        
      WHEN BIT_1 =>
        IF x='0' THEN
          nextState <= BIT_2;
        ELSE
          nextState <= BIT_1;
        END IF;
      WHEN BIT_2 =>
        IF x='1' THEN 
          nextState <= BIT_3;
        ELSE
          nextState <= BIT_0;
        END IF;
        
      WHEN BIT_3 =>
        IF x='0' THEN
          nextState <= BIT_0;
        ELSE
          nextState <= BIT_1;
        END IF;
      WHEN OTHERS =>
          nextState <= BIT_0;


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
  -----------------------------------------------------
  seq_state: PROCESS (clk, reset)
  BEGIN
    IF reset = '0' THEN
      curState <= BIT_0;
    ELSIF clk'EVENT AND clk='1' THEN
      curState <= nextState;
    END IF;
  END PROCESS; -- seq
  -----------------------------------------------------
END; -- arch_mealy


--------------------------------------------------------------------------------------------------------------------------------------------------------------------

ARCHITECTURE arch_moore OF recog1 IS
  -- State declaration
  TYPE state_type IS (BIT_0, BIT_1, BIT_2, BIT_3, BIT_4);  -- List your states here 	
  SIGNAL curState, nextState: state_type;
BEGIN
  -----------------------------------------------------
  combi_nextState: PROCESS(curState, x)
  BEGIN
    y <= '0';
    CASE curState IS
      WHEN BIT_0 =>
        IF x='1' THEN 
          nextState <= BIT_1;
        ELSE
          nextState <= BIT_0;
        END IF;
        
      WHEN BIT_1 =>
        IF x='0' THEN
          nextState <= BIT_2;
        ELSE
          nextState <= BIT_1;
        END IF;
      WHEN BIT_2 =>
        IF x='1' THEN 
          nextState <= BIT_3;
        ELSE
          nextState <= BIT_0;
        END IF;
        
      WHEN BIT_3 =>
        IF x='0' THEN
          nextState <= BIT_4;
        ELSE
          nextState <= BIT_1;
        END IF;
      WHEN BIT_4 =>
        y <= '1';
        IF x='0' THEN
          nextState <= BIT_0;
        ELSE
          nextState <= BIT_1;
        END IF;
      WHEN OTHERS =>
        nextState <= BIT_0;


    END CASE;
  END PROCESS; -- combi_nextState
  -----------------------------------------------------
--  combi_out: PROCESS(curState, x)
--  BEGIN
--    y <= '0'; -- assign default value
--    IF (curState = BIT_3) AND x='0' THEN
--      y <= '1';
--    END IF;
--  END PROCESS; -- combi_output
  -----------------------------------------------------
  seq_state: PROCESS (clk, reset)
  BEGIN
    IF reset = '0' THEN
      curState <= BIT_0;
    ELSIF clk'EVENT AND clk='1' THEN
      curState <= nextState;
    END IF;
  END PROCESS; -- seq
  -----------------------------------------------------
END; -- arch_mealy
