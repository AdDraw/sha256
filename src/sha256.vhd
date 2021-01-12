-- Adam Drawc 2020/2021
--
-- we are going to make a SHA256 that works on N character messages 
-- where N is equal to allocated mem_size / 8bit 
-- this is due to low memory capability of MAX10 which is

-- data from UART will be passed to memory after padding
-- to end the msg some stop value will be presented EOM 

-- after this we will know what the lenghts of the message is and we will be able to pad the data correctly
-- we will have the L and we will also have the K

-- if the msg will be greater then 448 bits then we will simply accumulate the hashes :)

--
-- SHA 256 algorithm
--  Note 1: All variables are 32 bit unsigned integers and addition is calculated modulo 2^32
--  Note 2: For each round, there is one round constant k(i) and one entry in the message schedule array w(i], 0 ≤ i ≤ 63
--  Note 3: The compression function uses 8 working variables, a through h
--  Note 4: Big-endian convention is used when expressing the constants in this pseudocode,
--   and when parsing message block data from bytes to words, for example,
--   the first word of the input message "abc" after padding is 0x61626380

-- we assume that the data in the memory is prepadded and represents 512 bit chunks :)
-- CHUNK : | 64 bit big_endian L(lenght of the message) | 1 pad bit (?) | K "0" bits | 448 - K bit msg data |


library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.ALL;

entity sha256 is
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
end sha256;

architecture beh of sha256 is

	-- Types
	type fsm is (IDLE, MSG_SCHEDULE, HASH, FINAL);	
	type cnt_arr is array(0 to 2) of unsigned(6 downto 0);
	type slv_arr8_32 	is array(0 to 7) of unsigned(31 downto 0);
	type slv_arr64_32 is array(0 to 63) of unsigned(31 downto 0);
	
	--Constants
	-- SHA-2 hash values initialization												
	constant init_h0 : unsigned(31 downto 0) := x"6a09e667";
	constant init_h1 : unsigned(31 downto 0) := x"bb67ae85";
	constant init_h2 : unsigned(31 downto 0) := x"3c6ef372";
	constant init_h3 : unsigned(31 downto 0) := x"a54ff53a";
	constant init_h4 : unsigned(31 downto 0) := x"510e527f";
	constant init_h5 : unsigned(31 downto 0) := x"9b05688c";
	constant init_h6 : unsigned(31 downto 0) := x"1f83d9ab";
	constant init_h7 : unsigned(31 downto 0) := x"5be0cd19";
														
	-- Initialize array of round constants:
	-- (first 32 bits of the fractional parts of the cube roots of the first 64 primes 2..311):
	constant k 	: slv_arr64_32 :=(x"428a2f98", x"71374491", x"b5c0fbcf", x"e9b5dba5", x"3956c25b", x"59f111f1", x"923f82a4", x"ab1c5ed5",
											x"d807aa98", x"12835b01", x"243185be", x"550c7dc3", x"72be5d74", x"80deb1fe", x"9bdc06a7", x"c19bf174",
											x"e49b69c1", x"efbe4786", x"0fc19dc6", x"240ca1cc", x"2de92c6f", x"4a7484aa", x"5cb0a9dc", x"76f988da",
											x"983e5152", x"a831c66d", x"b00327c8", x"bf597fc7", x"c6e00bf3", x"d5a79147", x"06ca6351", x"14292967",
											x"27b70a85", x"2e1b2138", x"4d2c6dfc", x"53380d13", x"650a7354", x"766a0abb", x"81c2c92e", x"92722c85",
											x"a2bfe8a1", x"a81a664b", x"c24b8b70", x"c76c51a3", x"d192e819", x"d6990624", x"f40e3585", x"106aa070",
											x"19a4c116", x"1e376c08", x"2748774c", x"34b0bcb5", x"391c0cb3", x"4ed8aa4a", x"5b9cca4f", x"682e6ff3",
											x"748f82ee", x"78a5636f", x"84c87814", x"8cc70208", x"90befffa", x"a4506ceb", x"bef9a3f7", x"c67178f2");

	
	-- Signals
	signal state		: fsm := IDLE;
	--counters
	signal i 			: cnt_arr := (others => (others => '0'));
	signal j 			: unsigned(6 downto 0) := (others =>'0');
	
	--expanded msg block W
	signal W 	: slv_arr64_32 := (others => (others => '0'));
	
	--work variables
	signal a : unsigned(31 downto 0);
	signal b : unsigned(31 downto 0);
	signal c : unsigned(31 downto 0);
	signal d : unsigned(31 downto 0);
	signal e : unsigned(31 downto 0);
	signal f : unsigned(31 downto 0);
	signal g : unsigned(31 downto 0);
	signal h : unsigned(31 downto 0);
	
	--hash values
	signal h0 : unsigned(31 downto 0);
	signal h1 : unsigned(31 downto 0);
	signal h2 : unsigned(31 downto 0);
	signal h3 : unsigned(31 downto 0);
	signal h4 : unsigned(31 downto 0);
	signal h5 : unsigned(31 downto 0);
	signal h6 : unsigned(31 downto 0);
	signal h7 : unsigned(31 downto 0);
	
begin

	process (clk_i, rst_ni) 		
		-- extend variables
		variable s0 	: unsigned(31 downto 0) := (others => '0');
		variable s1 	: unsigned(31 downto 0) := (others => '0');
		
		-- compress variables
		variable s_0 	: unsigned(31 downto 0) := (others => '0');
		variable s_1 	: unsigned(31 downto 0) := (others => '0');
		variable t1 	: unsigned(31 downto 0) := (others => '0');
		variable t2 	: unsigned(31 downto 0) := (others => '0');
		variable ch 	: unsigned(31 downto 0) := (others => '0');
		variable maj 	: unsigned(31 downto 0) := (others => '0');
		
	begin
		if rst_ni = '0' then
			i 				<= (others => (others => '0'));
			j 				<= (others => '0');
			
			mem_addr_o	<= (others => '0');		
			W 				<= (others => (others => '0'));
			vld_hash_o 	<= '0';

			h0 			<= init_h0;
			h1 			<= init_h1;
			h2 			<= init_h2;
			h3 			<= init_h3;
			h4 			<= init_h4;
			h5 			<= init_h5;
			h6 			<= init_h6;
			h7 			<= init_h7;

			a 				<= init_h0;
			b 				<= init_h1;
			c 				<= init_h2;
			d 				<= init_h3;
			e 				<= init_h4;
			f 				<= init_h5;
			g 				<= init_h6;
			h 				<= init_h7;

			state 		<= IDLE;
			
		elsif rising_edge(clk_i) then
	
			case state is 
				when IDLE 	=>
					vld_hash_o 	<= '0';
					rdy_o 		<= '1';
					i 				<= (others => (others => '0'));
					j 				<= (others => '0');
					mem_addr_o	<= (others => '0');
					W 				<= (others => (others => '0'));
					
					if vld_chunk_i = '1' then
						state 		<= MSG_SCHEDULE;
						rdy_o 		<=	'0';
						
						-- init working variables
						if chunk_id_i /= "000000" then 
							a <= h0;
							b <= h1;
							c <= h2;
							d <= h3;
							e <= h4;
							f <= h5;
							g <= h6;
							h <= h7;
						else
							h0 <= init_h0;
							h1 <= init_h1;
							h2 <= init_h2;
							h3 <= init_h3;
							h4 <= init_h4;
							h5 <= init_h5;
							h6 <= init_h6;
							h7 <= init_h7;
							
							a <= init_h0;
							b <= init_h1;
							c <= init_h2;
							d <= init_h3;
							e <= init_h4;
							f <= init_h5;
							g <= init_h6;
							h <= init_h7;
						end if;
					end if;
		
				when MSG_SCHEDULE 	=>
					-- load the chunk that will be processed from the memory into first 16 words of the W :)
				
					-- first extend 						
					mem_addr_o <= std_logic_vector(i(0)(3 downto 0));
					W(to_integer(i(2))) <= unsigned(mem_rdata_i);
					
					i(0) <= i(0) + 1;
					i(1) <= i(0);
					i(2) <= i(1);
					
					if i(2)(4) = '1' then
						state <= HASH;
						i(0) <= "0010000";
					end if;
				when HASH =>
					
					if i(0)(6) /= '1' then
						s0 	:= rotate_right( W(to_integer(i(0))-15),  7)  xor rotate_right( W(to_integer(i(0))-15), 18 )  xor shift_right( W(to_integer(i(0))-15), 3 ); 
						s1 	:= rotate_right( W(to_integer(i(0))-2 ),  17) xor rotate_right( W(to_integer(i(0))-2 ), 19 )  xor shift_right( W(to_integer(i(0))-2 ), 10 );
						W(to_integer(i(0))) 	<= s1 + W(to_integer(i(0)) - 7) + s0 +  W(to_integer(i(0))-16);
						i(0)	<= i(0) + 1;
					end if;
					
					s_1 	:= rotate_right( e, 6 ) xor rotate_right( e, 11 ) xor rotate_right( e, 25 ); 

					ch		:= (e and f) xor ((not e) and g);
					
					t1 	:= h + s_1 + ch + k(to_integer(j)) + W(to_integer(j));
					
					s_0 	:= rotate_right(a, 2) xor rotate_right(a, 13) xor rotate_right(a, 22);
					
					maj	:= (a and b) xor (a and c) xor (b and c);
					
					t2 	:= s_0 + maj;
					
					h 		<= g;
					g 		<= f;
					f 		<= e;
					e 		<= d + t1;
					d 		<= c;
					c 		<= b;
					b 		<= a;
					a 		<= t1 + t2;
					
					
					j 	<= j + 1;
					if j = to_unsigned(63, j'length) then
						state <= FINAL;
					end if;
							
				when FINAL =>
					h0 <= h0 + a;
					h1 <= h1 + b;
					h2 <= h2 + c;
					h3 <= h3 + d;
					h4 <= h4 + e;
					h5 <= h5 + f;
					h6 <= h6 + g;
					h7 <= h7 + h;
					
					vld_hash_o <= '1';
					state <= IDLE;
						
				when others =>					
					state <= IDLE;
			end case;
		end if;
	end process;

	hash_o <= 	std_logic_vector(h0) & std_logic_vector(h1) & std_logic_vector(h2) & std_logic_vector(h3)
				& 	std_logic_vector(h4) & std_logic_vector(h5) & std_logic_vector(h6) & std_logic_vector(h7);

end beh;
