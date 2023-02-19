ENTITY mux IS
  PORT (
    a:IN BIT;
    b:IN BIT;
    address:IN BIT;
    q:OUT BIT
  );
END mux;

-- One entity, two separate architectures.
-- The architecture of choice can be bound to the entity 
-- at the time of instantiation in the testbench.

ARCHITECTURE dataflow OF mux IS
BEGIN
  q <= a WHEN address = '0' ELSE b;
END dataflow;
-----------------------------------

ARCHITECTURE gates OF mux IS
  SIGNAL int1,int2,int_address: BIT;
BEGIN
  q <= int1 OR int2;
  int1 <= b and address;
  int_address <= NOT address;
  int2 <= int_address AND a;
END gates;

-----------------

ARCHITECTURE sequential OF mux IS
    BEGIN
        select_proc : PROCESS (a,b,address)
        BEGIN
            IF (address = '0') THEN
               q <= a;
              ELSIF (address = '1') THEN
                q <= b;
           END IF;
        END PROCESS select_proc;
     END sequential;

-------------------------------------
ARCHITECTURE bool OF mux IS

    BEGIN
        select_proc: PROCESS (a,b,address)
        BEGIN
            q <= (b AND address) OR (a AND NOT address);
        END PROCESS;
END bool;
