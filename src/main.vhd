library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity main is

port (
		clk_i 	: in std_logic;  -- L3
		rst_ni	: in std_logic;  -- R15
		
		RXD_o		: out  std_logic; -- B13
		TXD_i		: in   std_logic; -- A13
		
		led_dbg_o: out std_logic_vector(1 downto 0)
			);

end entity;


architecture beh of main is

	--Components
	component ram_dp
		PORT
		(
			byteena_a	: IN STD_LOGIC_VECTOR (3 DOWNTO 0) 		:=  (OTHERS => '1');
			clock			: IN STD_LOGIC ;
			data			: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			rdaddress	: IN STD_LOGIC_VECTOR (9  DOWNTO 0);
			wraddress	: IN STD_LOGIC_VECTOR (9  DOWNTO 0);
			wren			: IN STD_LOGIC  								:= '0';
			q				: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
		);

	end component;

	component sha256 --tested :)
		port
			(
				-- Input ports
				clk_i	 		: in  std_logic;
				rst_ni 		: in  std_logic;
				
				--Handshaking
				vld_chunk_i	: in std_logic;
				rdy_o			: out std_logic;
				chunk_id_i 	: in std_logic_vector(5 downto 0);
				
				--Mem IF
				mem_addr_o  : out std_logic_vector(3 downto 0); 
				mem_rdata_i : in 	std_logic_vector(31 downto 0);
				
				-- HASH VAL
				vld_hash_o	: out std_logic;
				hash_o 		: out std_logic_vector(255 downto 0)
			);
	end component;


	component rs_232 -- tested :)
		 Port(clk_i 	: in  	STD_LOGIC; -- has to be a 50MHz for BaudRate 9600
				rst_ni 	: in  	STD_LOGIC;
				
				-- External TX RX
				TXD_o 	: out  	STD_LOGIC;
				RXD_i 	: in  	STD_LOGIC;
				
				-- Handshaking
				wvld_i   : in 		std_logic;
				rvld_o 	: out		std_logic;
				rdy_o  	: out 	std_logic;
				
				-- Data
				data_i	: in 		std_logic_vector(7 downto 0);  -- data to send
				data_o 	: out 	std_logic_vector(7 downto 0); -- data received
				
				--DbgLed
				dbg_led_o : out std_logic_vector(1 downto 0)
				);
	end component;

	component pll
		PORT
		(
			inclk0	: IN STD_LOGIC;
			c0			: OUT STD_LOGIC
		);
	end component;

	-- Types
	type fsm is (IDLE, MSG_IN, MSG_PAD, SHA_256, MSG_OUT);
	

	-- Signals
	signal state : fsm := IDLE;
	
	-- GLobal
	signal clk_50MHz	: std_logic;

	--RamDP signals
	signal mem_byte_en		: STD_LOGIC_VECTOR (0  TO 3) :=  (OTHERS => '1');
	signal mem_wdata			: STD_LOGIC_VECTOR (31 DOWNTO 0);
	signal mem_raddr			: STD_LOGIC_VECTOR (9 DOWNTO 0);
	signal mem_waddr			: STD_LOGIC_VECTOR (9 DOWNTO 0);
	signal mem_we				: STD_LOGIC  := '0';

	-- UART signals
	signal uart_wvld			: std_logic;
	signal uart_rvld			: std_logic;
	signal uart_rdy 			: std_logic;
	signal uart_rdata			: std_logic_vector(7 downto 0);
	signal uart_wdata			: std_logic_vector(7 downto 0);

	-- SHA signals
	signal vld_chunk			: std_logic;
	signal vld_hash			: std_logic;
	signal sha256_rdy			: std_logic;
	signal chunk_id			: std_logic_vector(5   downto 0);
	signal chunk_rdata		: std_logic_vector(31  downto 0);
	signal chunk_mem_addr	: std_logic_vector(3   downto 0);
	signal hash					: std_logic_vector(255 downto 0);
	
	
	-- MAIN SIGNALS
	signal msg_length 		: std_logic_vector(63 downto 0);
	signal chunk_cnt			: integer range 0 to 64 := 0;
	signal chunk_i		 	   : integer range 0 to 64 := 0;
	
	signal last_waddr			: STD_LOGIC_VECTOR (9 DOWNTO 0);
	signal last_byte_cnt 	: integer range 0 to 3  	:= 0;
	
	type mem_wdata_arr is array(0 to 3) of std_logic_vector(7 downto 0);
	signal wdata_arr : mem_wdata_arr := (others => (others => '0'));
	type mem_len_arr is array(7 downto 0) of std_logic_vector(7 downto 0);
	signal msg_len_packed : mem_len_arr := (others => (others => '0'));
	
	type pad_fsm is (bitappend, zeros, len);
	signal padding_state : pad_fsm := bitappend;
	
	signal low32_len : std_logic := '0';
	
	signal final_hash : std_logic_vector(255 downto 0);
	type final_hash_pack is array(0 to 31) of std_logic_vector(7 downto 0);
	signal final_hash_packed : final_hash_pack := (others => (others => '0'));
	
	
	type msg_out_fsm is (NEWLINE_1, NEWLINE_2, DATA, EOT);
	signal uart_send_state : msg_out_fsm := NEWLINE_1;
	
	signal uart_i : integer range 0 to 32 := 0;
	
	
	signal lock : std_logic := '0';
	
	
begin

	pll_50_inst : pll
	port map(inclk0 => clk_i,
				c0 => clk_50MHz);

	uart_inst : rs_232
	port map(clk_i			=> clk_50MHz,
				rst_ni 		=> rst_ni,
				TXD_o 		=> RXD_o,
				RXD_i 		=> TXD_i,
				wvld_i 		=> uart_wvld,
				rvld_o 		=> uart_rvld,
				rdy_o 		=> uart_rdy,
				data_i 		=> uart_wdata,
				data_o 		=> uart_rdata,
				dbg_led_o	=> led_dbg_o);
				
	sha256_inst : sha256
	port map(clk_i 		=> clk_50MHz,
				rst_ni 		=> rst_ni,
				vld_chunk_i => vld_chunk,
				rdy_o 		=> sha256_rdy,
				chunk_id_i 	=> chunk_id,
				mem_addr_o 	=> chunk_mem_addr,
				mem_rdata_i => chunk_rdata,
				vld_hash_o	=> vld_hash,
				hash_o 		=> hash);
				
	ram_dp_inst : ram_dp
	port map(clock 		=> clk_50MHz,
				byteena_a 	=> mem_byte_en,
				data 			=> mem_wdata,
				rdaddress 	=> mem_raddr,
				wraddress 	=> mem_waddr,
				wren 			=> mem_we,
				q 				=> chunk_rdata);
	
	
	mem_wdata <= wdata_arr(0) & wdata_arr(1) & wdata_arr(2) & wdata_arr(3);
	
	mem_len_packing: for i in 0 to 7 generate
		msg_len_packed(i) <= msg_length(8*(i+1) -1 downto 8*i);
	end generate;

	fsm_proc: process (clk_50MHz, rst_ni)
		variable mem_byte_cnt : integer range 0 to 3  	:= 0;
	begin
		if rst_ni = '0' then
			state				<= IDLE;
			chunk_id 		<= (others => '0');
			vld_chunk 		<= '0';
			msg_length 		<= (others => '0');
			
			chunk_cnt 		<= 0;
			
			uart_wdata		<= (others => '0');
			uart_wvld		<= '0';
			
			mem_waddr 		<= (others => '0');
			mem_byte_cnt	:=  0;
			mem_we 			<= '0';
			wdata_arr 		<= (others => (others => '0'));
			msg_length		<= (others => '0');
			
			padding_state 	<= BITAPPEND;
			chunk_i 			<= 0;
			
			low32_len 		<= '0';
			last_waddr		<= (others => '0');
			
			last_byte_cnt 	<= 0;
			
			uart_send_state<= NEWLINE_1;
			uart_i			<= 0;
			
			final_hash		<= (others => '0');
			
			lock 				<= '0';

		elsif rising_edge(clk_50MHz) then
			case state is 
				when IDLE =>
					mem_waddr 		<= (others => '0');
					mem_we 			<= '0';
					wdata_arr 		<= (others => (others => '0'));
					msg_length		<= (others => '0');
					mem_byte_cnt	:= 0;
					low32_len 		<= '0';
					last_byte_cnt 	<= 0;
					lock 				<= '0';
					
					if  uart_rvld = '1' and uart_rdata /= x"04" then -- place 1st MSG CHAR into memory :)
						state 							<= MSG_IN;
						wdata_arr(mem_byte_cnt) 	<= uart_rdata;
						
						mem_byte_en						<= (others => '0');
						mem_byte_en(mem_byte_cnt)	<= '1';
						
						msg_length(63 downto 3) 	<= std_logic_vector(unsigned(msg_length(63 downto 3)) + 1);
						mem_we 							<= '1';
						
					end if;
						
				when MSG_IN =>
					if uart_rvld = '1' then
						if uart_rdata = x"04" then -- EOT [0x04, ^D]
							chunk_i			<= 0;
							low32_len 		<= '0';
							last_waddr		<= mem_waddr;
							last_byte_cnt 	<= mem_byte_cnt + 1;
							state 			<= MSG_PAD;
						else
							-- place the value into memory
							
							if mem_byte_cnt = 3 then
								mem_byte_cnt := 0;
								if unsigned(mem_waddr) mod 16 = 13 then
									mem_waddr		<= std_logic_vector(unsigned(mem_waddr) + 3); --jump to the next CHUNK
									chunk_cnt 		<= chunk_cnt + 1;
								else
									mem_waddr		<= std_logic_vector(unsigned(mem_waddr) + 1);
								end if;
							else
								mem_byte_cnt := mem_byte_cnt + 1;
							end if;
						
							
							wdata_arr(mem_byte_cnt)		<= uart_rdata;
							mem_byte_en						<= (others => '0');
							mem_byte_en(mem_byte_cnt)	<= '1';
							
							mem_we							<= '1';
							
							msg_length(63 downto 3) 	<= std_logic_vector(unsigned(msg_length(63 downto 3)) + 1); -- add 8 every new char
							
						end if;
					else
						mem_we 			<= '0';
					end if;
					
			when MSG_PAD =>
				mem_we <= '1';
				wdata_arr <= (others => (others => '0'));
				
				if chunk_i = chunk_cnt then					
					--1. write "80" to the last waddr
					case padding_state is 
						when BITAPPEND =>
							-- waddr stayes the same
							mem_waddr <= last_waddr;
							case last_byte_cnt  is
								when 3 =>
									mem_byte_en  	<= "0001";
									wdata_arr(3) 	<= x"80";
								when 2 =>
									mem_byte_en  	<= "0011";
									wdata_arr(2) 	<= x"80";
								when 1 =>
									mem_byte_en  	<= "0111";
									wdata_arr(1) 	<= x"80";
								when 0 =>
									mem_byte_en  	<= "1111";
									wdata_arr(0) 	<= x"80";
								when others =>
									mem_byte_en  	<= "0000";
							end case;
							
							padding_state <= ZEROS;						
						when ZEROS =>
							-- 2. filling the rest with Zeroes
							if unsigned(mem_waddr) mod 16 < 13 then
								mem_byte_en <= "1111";
								mem_waddr <= std_logic_vector(unsigned(mem_waddr) + 1);
								
							else
								padding_state <= LEN;
							end if;
						
						when LEN =>
							
							-- 3. Lenght appended at the end
							if unsigned(mem_waddr) mod 16 < 15 then
								mem_waddr <= std_logic_vector(unsigned(mem_waddr) + 1);
							
								mem_byte_en <= "1111";
								if low32_len /= '1' then
									
									for i in 0 to 3 loop
										wdata_arr(i) 	<= msg_len_packed(7-i);
									end loop;
									
									low32_len <= '1';
								else
									low32_len 	<= '0';
									for i in 0 to 3 loop
										wdata_arr(i) 	<= msg_len_packed(3-i);
									end loop;
									state <= SHA_256;

									padding_state <= BITAPPEND; 
									chunk_i <= 0;
								end if;
							end if;
						
						when others =>
							padding_state <= BITAPPEND;
					end case;
				else
					mem_byte_en <= "1111";
					if low32_len /= '1' then
						mem_waddr <= std_logic_vector(to_unsigned((chunk_i+1) * 14, mem_waddr'length));
						wdata_arr(0) <= x"80";
						low32_len <= '1';
					else
						mem_waddr <= std_logic_vector(unsigned(mem_waddr) + 1);
						chunk_i <= chunk_i + 1;
						low32_len <= '0';
					end if;
				end if;
				
				when SHA_256 =>
					mem_byte_en <= "0000";
					
					if chunk_i > chunk_cnt then
						state <= MSG_OUT;
						vld_chunk <= '0';
					else
						if sha256_rdy = '1' then
							vld_chunk <= '1';
							chunk_id <= std_logic_vector(to_unsigned(chunk_i, chunk_id'length));
						else
							vld_chunk <= '0';
							if vld_hash = '1' then
								final_hash <= hash;
								chunk_i <= chunk_i + 1;
							end if;
						end if;
					end if;
				when MSG_OUT =>
					-- set UART VLD
					if uart_rdy = '1' then
						-- choose a value to send
						uart_wvld <= '1';
						
						if lock = '0' then
							lock <= '1';
							case uart_send_state is
								when NEWLINE_1 =>
									uart_wdata 			<= x"0A"; --LF
									uart_send_state 	<= NEWLINE_2;
									
								when NEWLINE_2 =>
									uart_wdata 			<= x"0D"; --CR
									uart_send_state	<= DATA;
									
								when DATA =>
									if uart_i = 32 then
										uart_send_state	<= NEWLINE_1;
										lock 					<= '0';
										state					<= IDLE;
										uart_wvld			<= '0';
										uart_wdata			<= (others => '0');
										uart_i 				<=  0;
									else
										uart_wdata			<= final_hash_packed(uart_i);
										uart_i 				<= uart_i + 1;
									end if;
								when others =>
									uart_wdata <= x"00";
							end case;
								
						end if;
							
					else
						lock 			<= '0';
						uart_wvld 	<= '0';
					end if;
					
				when others =>
					state <= IDLE;
			end case;
		end if;
		
	end process fsm_proc;	
	
	final_hash_packing: for i in 0 to 31 generate
		final_hash_packed(i) <= final_hash(8*(32-i) - 1 downto 8*(31-i));
	end generate;
	
	mem_raddr <= chunk_id & chunk_mem_addr;
	
end beh; 