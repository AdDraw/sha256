-- Adam Drawc
--
-- RS232/UART driver
--
-- 9600 BaudRate
-- 8bit data
-- No Parity
-- 1 Stop Bit
-- HALFDUPLEX

-- Modifications made:
-- 1. Data to send has an internal src
-- 2. Handshaking added
-- 3. states as ENUM type

-- !!! Neccesary - input clock has to be 50MHz for BuadRate 9600


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY rs_232 IS
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
END rs_232;

ARCHITECTURE Behavioral of rs_232 IS
	CONSTANT N: INTEGER	:= 5208;
	
	-- Debouncing signals
	SIGNAL RXD_db					: STD_LOGIC_vector(2 downto 0) := "000";

	type FSM_STATE is (IDLE, RSTART, RDATA, RSTOP, TSTART, TDATA, TSTOP);
	
	SIGNAL state			: fsm_state := IDLE;
	SIGNAL counter			: INTEGER RANGE 0 TO 50000000		:= 0;
	SIGNAL data_received : STD_LOGIC_VECTOR (7 DOWNTO 0)	:= "00000000";
	SIGNAL data_to_send  : STD_LOGIC_VECTOR (7 DOWNTO 0)	:= "00000000";
	SIGNAL data_counter	: INTEGER RANGE 0 TO 7				:= 0;
	
BEGIN

	PROCESS (clk_i, rst_ni)
	BEGIN
		IF rst_ni = '0' THEN
			state 			<= IDLE;
			counter 		   <= 0;
			data_received 	<= (others => '0');
			data_to_send	<= (others => '0');
			data_counter 	<= 0;
			
			RXD_db			<= (others => '0');
			
			rvld_o			<= '0';
			rdy_o 			<= '1';
			
			dbg_led_o		<= "11";
			
		ELSIF rising_edge(clk_i) THEN
			-- debouncing
			RXD_db(0)	<=	RXD_i;
			RXD_db(1)	<=	RXD_db(0);
			RXD_db(2)	<=	RXD_db(1);
			CASE state IS
				WHEN IDLE =>
					TXD_o		<= '1';
					rdy_o 	<= '1';
					rvld_o	<= '0';
					dbg_led_o<= "11";
					
					
					IF RXD_db(2 downto 1) = "10" THEN -- read transaction on the RXD line
						state				<= RSTART;
						dbg_led_o		<= "10";
						rdy_o 			<= '0';
						counter			<= 0;
						
					elsif wvld_i = '1' then -- data to sent is vld
						dbg_led_o		<= "01";
						state	  			<= TSTART;
						data_to_send	<= data_i;
						counter 		 	<= 0;
						rdy_o 			<= '0';
						
					END IF;
					
				WHEN RSTART =>
				
					IF counter = N/2 THEN
						state		<= RDATA;
						counter 	<= 0;
					ELSE
						counter 	<= counter + 1;
					END IF;
					
				WHEN RDATA =>
				
					IF counter = N THEN
						counter <= 0;
						data_received(data_counter) <= RXD_db(2);
						IF data_counter = 7 THEN
							state		 		<= RSTOP;
							data_counter 	<= 0;
						ELSE
							data_counter 	<= data_counter + 1;
						END IF;
					ELSE
						counter <= counter + 1;
					END IF;
					
				WHEN RSTOP => 
				
					IF counter = N THEN
						dbg_led_o		<="11";
						state 			<= IDLE;
						counter			<= 0;
						rvld_o 			<= '1';
					ELSE
						counter 			<= counter + 1;
					END IF;
			
				WHEN TSTART =>
					IF counter = N THEN
						state 	<= TDATA;
						TXD_o		<= '0';
						counter	<= 0;
					ELSE
						counter 	<= counter + 1;
					END IF;
					
				WHEN TDATA =>
				
					IF counter = N THEN
						counter	<= 0;
						TXD_o 	<= data_to_send(data_counter);
						IF data_counter = 7 THEN
							state 			<= TSTOP;
							data_counter 	<= 0;
						ELSE
							data_counter 	<= data_counter + 1;
						END IF;
					ELSE
						counter <= counter + 1;
					END IF;
					
				WHEN TSTOP =>
				
					IF counter = N THEN
						state 	<= IDLE;
						dbg_led_o<= "11";
						TXD_o		<= '1';
						counter	<= 0;
					ELSE
						counter 	<= counter + 1;
					END IF;
					
				WHEN others =>
				
					state 	<= IDLE;
					counter 	<= 0;
					
			END CASE;
		END IF;
	END PROCESS;
	
	data_o <= data_received;
	
END Behavioral;