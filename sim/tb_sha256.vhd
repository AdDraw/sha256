--------------------------------------------------------------------------------
-- Author: Adam Drawc
--
-- Module Name:   test_rs232
-- Project Name:  SHA256
-- Target Device:  
-- Tool versions:  
-- Description:   
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;
use std.textio.all;
use ieee.std_logic_textio.all;

ENTITY test_sha256 IS
END test_sha256;

 
ARCHITECTURE behavior OF test_sha256 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
	component sha256
		port
			(
				-- Input ports
				clk_i	 : in  std_logic;
				rst_ni : in  std_logic;
				
				--Handshaking
				vld_chunk_i	: in std_logic;
				rdy_o			: out std_logic;
				chunk_id_i 	: in std_logic_vector(5 downto 0);
				
				mem_addr_o  : out std_logic_vector(3 downto 0); 
				mem_rdata_i : in 	std_logic_vector(31 downto 0);
				
				vld_hash_o	: out std_logic;
				hash_o 		: out std_logic_vector(255 downto 0)
			);
	end component;
    

   --Inputs
   signal clk_i 		: std_logic := '0';
   signal rst_ni 		: std_logic := '1';
	signal chunk_id	: std_logic_vector(5 downto 0) := (others => '0');
	signal vld_chunk 	: std_logic := '0';
	signal rdata		: std_logic_vector(31 downto 0) := (others => '0');


 	--Outputs
	signal rdy 			: std_logic;
	signal raddr		: std_logic_vector(3 downto 0);
	signal hash			: std_logic_vector(255 downto 0);
	signal vld_hash	: std_logic; 
	

   -- Clock period definitions for 50MHz clock
   constant clk_i_period : time := 20ns; -- 50 Mhz clock

	type slv_arr16_8 is array(0 to 15) of std_logic_vector(31 downto 0);
	
	constant chunk_abc 		: slv_arr16_8 := (x"61626380", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
															x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000018");
	
	constant chunk_blank 	: slv_arr16_8 := (x"80000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
															x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000");
	
	constant chunk_aga		: slv_arr16_8 := (x"61676120", x"80000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
															x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000020");

	constant chunk_naga		: slv_arr16_8 := (x"6E616761", x"80000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
															x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000020");

	constant chunk_aga_naga : slv_arr16_8 := (x"61676120", x"6E616761", x"80000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
															x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000040");

	constant chunker_p1 : slv_arr16_8 := (x"31323334", x"35363738",
													  x"31323334", x"35363738",
													  x"31323334", x"35363738",
													  x"31323334", x"35363738",
													  x"31323334", x"35363738",
													  x"31323334", x"35363738",
													  x"31323334", x"35363780", --addition of '1'
													  x"00000000", x"000001B8"); -- LENGHT
--	constant chunker_p2 : slv_arr16_8
												
	constant p1 : slv_arr16_8 := (	x"61626364", x"62636465", x"63646566", x"64656667", x"65666768", x"66676869", x"6768696a", x"68696a6b",
												x"696a6b6c", x"6a6b6c6d", x"6b6c6d6e", x"6c6d6e6f", x"6d6e6f70", x"6e6f7071", x"80000000", x"00000000");

	constant p1_small : slv_arr16_8 := (	x"61626364", x"62636465", x"63646566", x"64656667", x"65666768", x"66676869", x"6768696a", x"68696a6b",
														x"696a6b6c", x"6a6b6c6d", x"6b6c6d6e", x"6c6d6e6f", x"6d6e6f70", x"6e6f7080", x"00000000", x"000001b8");		
										
	constant p2 : slv_arr16_8 := (	x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",  
												x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"000001c0");								
						
						
--	signal hash_1p_chunker : std_logic_vector(255 downto 0) := x"19bfecd2de7f330f6629bd0c23b69908174d2f7171fe3a3d5114d88c63719582";
										  
	
	signal Mem : slv_arr16_8 := (others => (others => '0'));
	
	signal start_proc	 	: std_logic	:= '0';
	signal finished 		: std_logic	:= '0';
	
	
	function to_hstring (SLV : std_logic_vector) return string is
		variable L : LINE;
	begin
		hwrite(L,SLV);
		return L.all;
	end function to_hstring;

BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: sha256 PORT MAP (
          clk_i 			=> clk_i,
          rst_ni 			=> rst_ni,
			 vld_chunk_i	=> vld_chunk,
			 rdy_o			=> rdy,
			 chunk_id_i		=> chunk_id,
			 mem_addr_o		=> raddr,
			 mem_rdata_i	=> rdata,
			 vld_hash_o 	=> vld_hash,
			 hash_o			=> hash);

   -- Clock process definitions
   clk_i_process :process
   begin
		clk_i <= '0';
		wait for clk_i_period/2;
		clk_i <= '1';
		wait for clk_i_period/2;
   end process;
 	
	mem_proc : process (clk_i)
	begin
		if rising_edge(clk_i) then
			rdata <= Mem(to_integer(unsigned(raddr)));
		end if;
	end process;
	
	write_proc: process (clk_i)
	begin
		if rising_edge(clk_i) then
			if rdy = '1' then
				vld_chunk <= '1';
			else
				vld_chunk <= '0';
			end if;
		end if;
	end process;
	
	-- Stimulus process
   stim_proc: process
   begin		
	  -- data fill
--	  for i in 0 to 63 loop
--		Arr_wData(i) <= std_logic_vector(unsigned(small_a) + i);
--	  end loop;
		
--	  start_writing <= '1';

		-- place blank chunk in the memory
		chunk_id  <= (others => '0');
		Mem <= chunk_blank;

		-- reset
		rst_ni <= '0';	  
		wait for 400ns;
		rst_ni <= '1';

		wait until vld_hash = '1' and vld_hash'stable;
	  
		assert hash = x"e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
			report "Hash of '' is not e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855!";
		report "Val_Of_HASH: " & to_hstring(hash);
	  
		-- place abc chunk in the memory
		chunk_id  <= (others => '0');
		Mem <= chunk_abc;

		wait until vld_hash = '1' and vld_hash'stable;
	  
		assert hash = x"ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad"
				report "Hash of 'abc' is not ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad!";
		report "Val_Of_HASH: " & to_hstring(hash); 
	  		
		-- 1. send aga_ chunk
		chunk_id  <= (others => '0');
		Mem <= chunk_aga;
	  
		wait until vld_hash = '1' and vld_hash'stable;
	  
		assert hash = x"e13fb754f56b8a729d9a54e878e692eda25658ff5ce756004dd3fd22ef3e863a"
			report "Hash of 'aga ' is not e13fb754f56b8a729d9a54e878e692eda25658ff5ce756004dd3fd22ef3e863a!";
		report "Val_Of_HASH: " & to_hstring(hash); 

		-- 2. send naga chunk, inc the chunk_id
		chunk_id  	<= (others => '0');
		Mem <= chunk_naga;
	  
		wait until vld_hash = '1' and vld_hash'stable;
	  
		assert hash = x"55235d10c95c19c7bb7dfd3f9f2cbac184b8662ae36b009a26005070b80b717f"
			report "Hash of 'naga' is not 55235d10c95c19c7bb7dfd3f9f2cbac184b8662ae36b009a26005070b80b717f!";
		report "Val_Of_HASH: " & to_hstring(hash); 

		--3 send aga_naga chunk
		
		chunk_id  	<= (others => '0');
		Mem <= chunk_aga_naga;
	  
		wait until vld_hash = '1' and vld_hash'stable;
	  
		assert hash = x"e1f67b2a5c62af7d40bd7966211f339b24f9f80eaf7e07fb064920ab78e49c7e"
			report "Hash of 'aga naga ' is not e1f67b2a5c62af7d40bd7966211f339b24f9f80eaf7e07fb064920ab78e49c7e!";
		report "Val_Of_HASH: " & to_hstring(hash); 
		
		
		--4 BIG CHUNKO
		chunk_id  	<= (others => '0');
		Mem <= chunker_p1;
	  
		wait until vld_hash = '1' and vld_hash'stable;
	  
		assert hash = x"8381b3fa5110b7ef27ffb06386b11ffdff56dc3985d3741719c14c63b9b0cbef" 
			report "Hash of '123456781234567812345678123456781234567812345678123456781234567' is not 8381b3fa5110b7ef27ffb06386b11ffdff56dc3985d3741719c14c63b9b0cbef!";
		report "Val_Of_HASH: " & to_hstring(hash); 
		
		
		--5. 2 CHUNKO BUNGO
		chunk_id  	<= (others => '0');
		Mem <= p1;
	  
		wait until vld_hash = '1' and vld_hash'stable;
		
		chunk_id  	<= (others => '0');
		chunk_id(0)	<= '1';
		Mem <= p2;
	  
		wait until vld_hash = '1' and vld_hash'stable;
		
		assert hash = x"248d6a61d20638b8e5c026930c3e6039a33ce45964ff2167f6ecedd419db06c1" 
			report "Hash of 'abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq' is not 248d6a61d20638b8e5c026930c3e6039a33ce45964ff2167f6ecedd419db06c1!";
		report "Val_Of_HASH: " & to_hstring(hash); 
		
		--6 BIG CHUNKO 2nd attempt
		chunk_id  	<= (others => '0');
		Mem <= p1_small;
	  
		wait until vld_hash = '1' and vld_hash'stable;
	  
		assert hash = x"aa353e009edbaebfc6e494c8d847696896cb8b398e0173a4b5c1b636292d87c7" 
			report "Hash of 'abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnop' is not aa353e009edbaebfc6e494c8d847696896cb8b398e0173a4b5c1b636292d87c7!";
		report "Val_Of_HASH: " & to_hstring(hash); 
		
		
		-- finish the sim
		wait until rdy = '1' and rdy'stable;	 
		assert false report "finished simulation" severity failure;
   end process;
END;