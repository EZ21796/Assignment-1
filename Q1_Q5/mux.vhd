ENTITY mux IS
  PORT (a:IN BIT;
    	b:IN BIT;
    	address:IN BIT;
    	q:OUT BIT);
END mux;

-- One entity, two separate architectures.
-- I would prefer to use the sequential implementation as the output only depends on the address and not on a or b
-- and this implementation does not create a latch as all the inputs have been predefined unlike the data flow implementation.
---------------Data Flow----------------------------
ARCHITECTURE dataflow OF mux IS
BEGIN
  q <= a WHEN address = '0' ELSE b;
END dataflow;

---------------Gates----------------------------
ARCHITECTURE gates OF mux IS
SIGNAL int1,int2,int_address: BIT;
BEGIN
  q <= int1 OR int2;
  int1 <= b and address;
  int_address <= NOT address;
  int2 <= int_address AND a;
END gates;

-----------------Sequential-----------------
ARCHITECTURE sequential OF mux IS
BEGIN
	select_proc : PROCESS (a,b,address)
	BEGIN
		IF (address = '0') THEN q <= a;
		ELSIF (address = '1') THEN q <= b;
		END IF;
	END PROCESS select_proc;
END sequential;

-------------------Bool--------------------
ARCHITECTURE bool OF mux IS
BEGIN
	select_proc: PROCESS (a,b,address)
	BEGIN
		q <= (b AND address) OR (a AND NOT address);
	END PROCESS;
END bool;
