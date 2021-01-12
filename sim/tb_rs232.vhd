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

ENTITY test_rs232 IS
END test_rs232;

 
ARCHITECTURE behavior OF test_rs232 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
	component rs_232
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
    

   --Inputs
   signal clk_i 	: std_logic := '0';
   signal rst_ni 	: std_logic := '1';
   signal RXD_i 	: std_logic := '0';
	signal wdata	: std_logic_vector(7 downto 0) := (others => '0');
	signal wvld 	: std_logic := '0';


 	--Outputs
   signal TXD_o 		: std_logic;
	signal led_dbg_o	: std_logic_vector(1 downto 0);
	signal rdata 		: std_logic_vector(7 downto 0);
	signal rvld 		: std_logic;
	signal rdy 			: std_logic;
	


   -- Clock period definitions for 9600 BaudRate
   constant clk_i_period : time := 20ns; -- 50 Mhz clock
   constant period : time := 0.10416666ms;
	
	type slv_arr64_8 is array(63 downto 0) of std_logic_vector(7 downto 0);
	
	signal Arr_wData : slv_arr64_8 := (others =>(others => '0'));
	signal Arr_rData : slv_arr64_8 := (others =>(others => '0'));
	
	signal small_a : std_logic_vector(7 downto 0) := "01100001";
	
	signal start_writing : std_logic	:= '0';
	signal finished 		: std_logic	:= '0';
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: rs_232 PORT MAP (
          clk_i => clk_i,
          rst_ni => rst_ni,
          TXD_o => TXD_o,
          RXD_i => RXD_i,
			 wvld_i => wvld,
			 rvld_o => rvld,
			 rdy_o => rdy,
			 data_i => wdata,
			 data_o => rdata,
			 dbg_led_o => led_dbg_o
        );

   -- Clock process definitions
   clk_i_process :process
   begin
		clk_i <= '0';
		wait for clk_i_period/2;
		clk_i <= '1';
		wait for clk_i_period/2;
   end process;
 	
	read_proc: process (rvld, clk_i)
		variable rcnt : integer range 0 to 128 := 0;
	begin
		if rising_edge(clk_i) then
			if rvld = '1' then
				Arr_rData(rcnt) <= rdata;
				rcnt := rcnt + 1;
			end if;
		end if;
	end process;
	
	write_proc: process (clk_i)
		variable wcnt : integer range 0 to 64 := 0;
	begin
		if rising_edge(clk_i) then
			if start_writing = '1' then
				if wcnt < 64 then
					if rdy = '1' then
						wdata <= Arr_rData(wcnt);
						wvld 	<= '1';
						wcnt 	:= wcnt + 1;
					else
						wvld 	<= '0';
					end if;
				else
					finished <= '1';
				end if;
			end if;
		end if;
	end process;
	
	-- Stimulus process
   stim_proc: process
	variable fail_cnt, attempt_cnt : integer range 0 to 128 := 0;
   begin		
	  
	  -- data fill
	  for i in 0 to 63 loop
		Arr_wData(i) <= std_logic_vector(unsigned(small_a) + i);
	  end loop;
		
	  -- data write
	  for i in 0 to 63 loop
		  RXD_i <= '1'; -- Spacer
		  wait for period;
		  RXD_i <= '0'; -- start
		  wait for period;
		  RXD_i <= Arr_wData(i)(0); --data0
		  wait for period;
		  RXD_i <= Arr_wData(i)(1); --data1
		  wait for period;
		  RXD_i <= Arr_wData(i)(2); --data2
		  wait for period;
		  RXD_i <= Arr_wData(i)(3); --data3
		  wait for period;
		  RXD_i <= Arr_wData(i)(4); --data4
		  wait for period;
		  RXD_i <= Arr_wData(i)(5); --data5
		  wait for period;
		  RXD_i <= Arr_wData(i)(6); --data6
		  wait for period;
		  RXD_i <= Arr_wData(i)(7); --data7
		  wait for period;
		  RXD_i <= '0'; -- STOP
		  wait for period;
		  attempt_cnt := attempt_cnt + 1;
	  end loop;
      -- insert stimulus here 
	
	  -- compare What was read with reference
	  wait for period;
	  for i in 0 to 63 loop
			if Arr_rData(i) /= Arr_wData(i) then
				fail_cnt := fail_cnt + 1;
			end if;
	  end loop;
	  
	  assert false report "attempts: " & integer'image(attempt_cnt)  severity note;
	  assert false report "fails found: " & integer'image(fail_cnt) severity note;
	  
	  --WriteTests
	  wait for period;
	  start_writing <= '1';

	  wait until finished='1';
	 
	  assert false report "finished simulation" severity failure;
   end process;
END;