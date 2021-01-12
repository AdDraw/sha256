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

ENTITY test_main IS
END test_main;

 
ARCHITECTURE behavior OF test_main IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
	component main
		 Port(clk_i 	: in  	STD_LOGIC; -- has to be a 50MHz for BaudRate 9600
				rst_ni 	: in  	STD_LOGIC;
				
				-- External TX RX
				TXD_i 	: in  	STD_LOGIC;
				RXD_o 	: out  	STD_LOGIC;
				
				--DbgLed
				led_dbg_o : out std_logic_vector(1 downto 0)
				);
	end component;
    
	component rs_232
	    Port(clk_i 		: in  	STD_LOGIC; -- has to be a 50MHz for BaudRate 9600
			rst_ni 		: in  	STD_LOGIC;
			
			-- External TX RX
			TXD_o 		: out  	STD_LOGIC;
			RXD_i 		: in  	STD_LOGIC;
			
			-- Handshaking
			wvld_i   	: in 		std_logic;
			rvld_o 		: out		std_logic;
			rdy_o  		: out 	std_logic;
			
			-- Data
			data_i		: in 		std_logic_vector(7 downto 0);  -- data to send
			data_o 		: out 	std_logic_vector(7 downto 0); -- data received
			
			-- Debug Leds to see read and write States
			dbg_led_o	: out std_logic_vector(1 downto 0)
			
			);
	end component;
	
	component pll
			PORT
		(
			inclk0		: IN STD_LOGIC  := '0';
			c0		: OUT STD_LOGIC 
		);
	end component;
	
	 
   --Inputs
   signal clk_i 	: std_logic := '0';
   signal rst_ni 	: std_logic := '1';
   signal TXD_i 	: std_logic := '0';

 	--Outputs
   signal RXD_o 		: std_logic;
	signal led_dbg		: std_logic_vector(1 downto 0);
	
	
	-- UART signals
	signal uart_wvld 	: std_logic := '0';
	signal uart_wdata : std_logic_vector(7 downto 0) := (others => '0');
	signal uTXD			: std_logic;
	
	signal urdy			: std_logic;
	signal urvld		: std_logic;
	signal urdata 		: std_logic_vector(7 downto 0);
	signal dbld   		: std_logic_vector(1 downto 0);
	
	-- PLL signals
	signal clk_50MHz  : std_logic;


   -- Clock period definitions for 9600 BaudRate
   constant clk_i_period : time := 100ns; -- 10 Mhz clock
   constant period : time := 0.10416666ms;
	
	type slv_arr64_8 is array(63 downto 0) of std_logic_vector(7 downto 0);
	
	signal Arr_wData : slv_arr64_8 := (others =>(others => '0'));
	
	signal small_a : std_logic_vector(7 downto 0) := "01100001";
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
	uut: main PORT MAP(
			clk_i => clk_i,
			rst_ni => rst_ni,
			TXD_i => TXD_i,
			RXD_o => RXD_o,
			led_dbg_o => led_dbg
			);
	
	uart: rs_232 PORT MAP(
			clk_i 		=> clk_50MHz,
			rst_ni 		=> rst_ni,
			TXD_o 		=> uTXD,
			RXD_i 		=> RXD_o,
			data_i 		=> uart_wdata,
			data_o 		=> urdata,
			dbg_led_o 	=> dbld,
			rdy_o			=> urdy,	
			wvld_i		=> uart_wvld,
			rvld_o		=> urvld
			);
			
	pll_inst: pll PORT MAP(
			inclk0 => clk_i,
			c0 => clk_50MHz
			);
	
   -- Clock process definitions
   clk_i_process :process
   begin
		clk_i <= '0';
		wait for clk_i_period/2;
		clk_i <= '1';
		wait for clk_i_period/2;
   end process;
 			
	-- Stimulus process
   stim_proc: process
   begin		
	  
		rst_ni <= '0';
	  
		wait for 400ns;
	  
		rst_ni <= '1';
	  
		-- data fill
		for i in 0 to 63 loop
			Arr_wData(i) <= std_logic_vector(unsigned(small_a) + i);
		end loop;
		Arr_wData(5) <= x"04"; --EOT
	
	  -- data write
		for i in 0 to 5 loop
			TXD_i <= '1'; -- Spacer
			wait for period;
			TXD_i <= '0'; -- start
			wait for period;
			TXD_i <= Arr_wData(i)(0); --data0
			wait for period;
			TXD_i <= Arr_wData(i)(1); --data1
			wait for period;
			TXD_i <= Arr_wData(i)(2); --data2
			wait for period;
			TXD_i <= Arr_wData(i)(3); --data3
			wait for period;
			TXD_i <= Arr_wData(i)(4); --data4
			wait for period;
			TXD_i <= Arr_wData(i)(5); --data5
			wait for period;
			TXD_i <= Arr_wData(i)(6); --data6
			wait for period;
			TXD_i <= Arr_wData(i)(7); --data7
			wait for period;
			TXD_i <= '0'; -- STOP
			wait for period;
		end loop;
      -- insert stimulus here 

	  --WriteTests
		wait until urdy = '1' and urdy'STABLE and urdata = x"04";
		
		assert false report "finished simulation" severity failure;
   end process;
END;