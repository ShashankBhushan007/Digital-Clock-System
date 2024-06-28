library ieee;
use ieee.std_logic_1164.all;
use work.EE232.all;

entity COUNTER_SYNC_SSD_24 is -- Entity declaration
port(CLK : in std_logic; -- Clock input of the counter
 RSTN : inout std_logic; -- Active low reset input of the counter
 UP_DN : in std_logic; -- Count up if UP_DN is high, down if low
 LDN : in std_logic; -- Load D to the counter if LDN is low
 E : in std_logic; -- Count if E is high, retain otherwise
 A : in std_logic_vector(2 downto 0);
 D : in std_logic_vector(3 downto 0); -- Count to load when LDN is low
 A1 : out std_logic_vector(6 downto 0);
 A2 : out std_logic_vector(6 downto 0);
 A3 : out std_logic_vector(6 downto 0);
 A4 : out std_logic_vector(6 downto 0);
 A5 : out std_logic_vector(6 downto 0);
 A6 : out std_logic_vector(6 downto 0);
 LOAD_A : in std_logic;
-- SHOW_A : in std_logic;
 SHOW_T : in std_logic;
 BUZZER :out std_logic := '0';
 ALARM_ON : in std_logic); -- Output state of the counter
end COUNTER_SYNC_SSD_24;

architecture FUNCTIONALITY of COUNTER_SYNC_SSD_24 is
	signal Q1,Q2,Q3,Q4,Q5,Q6 : std_logic_vector(3 downto 0);
	signal F1,F2,F3,F4,F5,F6 : std_logic;
	signal C1 : std_logic;
	signal UP_DN_N: std_logic := not UP_DN;
	signal Q10_N: std_logic := not Q1(0);
	signal Q11_N: std_logic := not Q1(1);
	signal Q12_N: std_logic := not Q1(2);
	signal Q13_N: std_logic := not Q2(3);
	signal Q20_N: std_logic := not Q2(0);
	signal Q21_N: std_logic := not Q2(1);
	signal Q22_N: std_logic := not Q2(2);
	signal Q23_N: std_logic := not Q2(3);
	signal Q30_N: std_logic := not Q3(0);
	signal Q31_N: std_logic := not Q3(1);
	signal Q32_N: std_logic := not Q3(2);
	signal Q33_N: std_logic := not Q3(3);
	signal Q40_N: std_logic := not Q4(0);
	signal Q41_N: std_logic := not Q4(1);
	signal Q42_N: std_logic := not Q4(2);
	signal Q43_N: std_logic := not Q4(3);
	signal Q50_N: std_logic := not Q5(0);
	signal Q51_N: std_logic := not Q5(1);
	signal Q52_N: std_logic := not Q5(2);
	signal Q53_N: std_logic := not Q5(3);
	signal E_1,E_2,E_3,E_4,E_5: std_logic;
	signal Q2_Final,Q4_Final: std_logic_vector(3 downto 0);
	signal Q3_Final,Q5_Final: std_logic_vector(3 downto 0);
	signal D1,D2,D3,D4,D5,D6 : std_logic_vector(3 downto 0);
	signal B1,B2,B1_UP_DN,B1_UP_DN_N,B2_UP_DN_N : std_logic_vector(4 downto 0);
	signal RSTN1,RSTN2 : std_logic;
	signal TIME_DATA : std_logic_vector(23 downto 0);
--	signal SET_DATA : std_logic_vector(23 downto 0);
	signal ALARM_DATA, X : std_logic_vector(23 downto 0);
	signal DISPLAY : std_logic_vector(23 downto 0);

begin
	
	process (Q1,Q2_Final,Q3_Final,Q4_Final,Q5_Final,Q6)
	begin
		if(Q1="1001" and Q2_Final="0101" and Q3_Final="1001" and Q4_Final="0101" and Q5_Final="0011" and Q6="0010"and UP_DN ='1') then
			RSTN1 <= '0';
		else
			RSTN1 <= '1';
		end if;
	end process;
	process (A,LDN, LOAD_A)
	begin
		if(A="001" and LDN='0' and LOAD_A = '0') then
			D1 <= D;
		elsif(A="010" and LDN='0' and LOAD_A = '0') then
			D2 <= D;
		elsif(A="011" and LDN='0' and LOAD_A = '0') then
			D3 <= D;
		elsif(A="100" and LDN='0' and LOAD_A = '0') then
			D4 <= D;
		elsif(A="101" and LDN='0' and LOAD_A = '0') then
			D5 <= D;
		elsif(A="110" and LDN='0' and LOAD_A = '0') then
			D6 <= D;
		elsif(A="001" and LDN='0' and LOAD_A = '1') then
			ALARM_DATA(3 DOWNTO 0) <= D;
		elsif(A="010" and LDN='0' and LOAD_A = '1') then
			ALARM_DATA(7 DOWNTO 4) <= D;
		elsif(A="011" and LDN='0' and LOAD_A = '1') then
			ALARM_DATA(11 DOWNTO 8) <= D;
		elsif(A="100" and LDN='0' and LOAD_A = '1') then
			ALARM_DATA(15 DOWNTO 12) <= D;
		elsif(A="101" and LDN='0' and LOAD_A = '1') then
			ALARM_DATA(19 DOWNTO 16) <= D;
		elsif(A="110" and LDN='0' and LOAD_A = '1') then
			ALARM_DATA(23 DOWNTO 20) <= D;	
		end if;
	end process;
	
		
	Z1 : SIX_TO_ZERO port map(Q2,Q2_Final);
	Z2 : SIX_TO_ZERO port map(Q4,Q4_Final);
	Z3 : TEN_TO_ZERO port map(Q3,Q3_Final);
	Z4 : TEN_TO_ZERO port map(Q5,Q5_Final);
	Z5 : AND_2 port map(RSTN,RSTN1,RSTN2);
	B1(0) <= Q1(3) and Q12_N and Q11_N and Q1(0);
	B1_UP_DN(0) <= B1(0) and UP_DN;
	B2(0) <= Q10_N and Q11_N and Q12_N and Q13_N;
	B1_UP_DN_N(0) <= B2(0) and UP_DN_N;
	E_1 <= B1_UP_DN(0) or B1_UP_DN_N(0);
	
--	M6 : AND_4 port map(Q23_N,Q2(2),Q21_N,Q2(0),B1(1));
	B1(1) <= Q23_N and Q2(2) and Q21_N and Q2(0) and B1(0);
--	M7 : AND_2 port map(B1(1),UP_DN,B1_UP_DN(1));
	B1_UP_DN(1) <= B1(1) and UP_DN;
--	M8 : AND_4 port map(Q20_N,Q21_N,Q22_N,Q23_N,B2(1));
	B2(1) <= Q20_N and Q21_N and Q22_N and Q23_N and B2(0);
--	M9 : AND_2 port map(B2(1),UP_DN_N,B1_UP_DN_N(1));
	B1_UP_DN_N(1) <= B2(1) and UP_DN_N;
--	M10 : OR_2 port map(B1_UP_DN(1),B1_UP_DN_N(1),E_2);
	E_2 <= B1_UP_DN(1) or B1_UP_DN_N(1);
	
--	M11 : AND_4 port map(Q3(3),Q32_N,Q31_N,Q3(0),B1(2));
	B1(2) <= Q3(3) and Q32_N and Q31_N and Q3(0) and B1(1);
--	M12 : AND_2 port map(B1(2),UP_DN,B1_UP_DN(2));
	B1_UP_DN(2) <= B1(2) and UP_DN;
--	M13 : AND_4 port map(Q30_N,Q31_N,Q32_N,Q33_N,B2(2));
	B2(2) <= Q30_N and Q31_N and Q32_N and Q33_N and B2(1);
--	M14 : AND_2 port map(B2(2),UP_DN_N,B1_UP_DN_N(2));
	B1_UP_DN_N(2) <= B2(2) and UP_DN_N;
--	M15 : OR_2 port map(B1_UP_DN(2),B1_UP_DN_N(2),E_3);
	E_3 <= B1_UP_DN(2) or B1_UP_DN_N(2);
	
--	M16 : AND_4 port map(Q43_N,Q4(2),Q41_N,Q4(0),B1(3));
	B1(3) <= Q43_N and Q4(2) and Q41_N and Q4(0) and B1(2);
--	M17 : AND_2 port map(B1(3),UP_DN,B1_UP_DN(3));
	B1_UP_DN(3) <= B1(3) and UP_DN;
--	M18 : AND_4 port map(Q40_N,Q41_N,Q42_N,Q43_N,B2(3));
	B2(3) <= Q40_N and Q41_N and Q42_N and Q43_N and B2(2);
--	M19 : AND_2 port map(B2(3),UP_DN_N,B1_UP_DN_N(3));
	B1_UP_DN_N(3) <= B2(3) and UP_DN_N;
--	M20 : OR_2 port map(B1_UP_DN(3),B1_UP_DN_N(3),E_4);
	E_4 <= B1_UP_DN(3) or B1_UP_DN_N(3);
--	
--	M21 : AND_4 port map(Q5(3),Q52_N,Q51_N,Q5(0),B1(4));
	B1(4) <= Q5(3) and Q52_N and Q51_N and Q5(0) and B1(3);
--	M22 : AND_2 port map(B1(4),UP_DN,B1_UP_DN(4));
	B1_UP_DN(4) <= B1(4) and UP_DN;
--	M23 : AND_4 port map(Q50_N,Q51_N,Q52_N,Q53_N,B2(4));
	B2(4) <= Q50_N and Q51_N and Q52_N and Q53_N and B2(3);
--	M24 : AND_2 port map(B2(4),UP_DN_N,B1_UP_DN_N(4));
	B1_UP_DN_N(4) <= B2(4) and UP_DN_N;
--	M25 : OR_2 port map(B1_UP_DN(4),B1_UP_DN_N(4),E_5);
	E_5 <= B1_UP_DN(4) or B1_UP_DN_N(4);
--	
--	U0 : CLK_DVD port map(CLK,'1',C1);
	
	U1 : COUNTER_SYNC_10 port map(CLK,RSTN,UP_DN,LDN,E,D1,Q1);
	U2 : BCD2SSD port map(DISPLAY(3 downto 0),A1,F1);
	
	U3 : COUNTER_SYNC_6 port map(CLK,RSTN,UP_DN,LDN,E_1,D2,Q2);
	U4 : BCD2SSD port map(DISPLAY(7 downto 4),A2,F2);
	
	U5 : COUNTER_SYNC_11 port map(CLK,RSTN,UP_DN,LDN,E_2,D3,Q3);
	U6 : BCD2SSD port map(DISPLAY(11 downto 8),A3,F3);
	
	U7 : COUNTER_SYNC_6 port map(CLK,RSTN,UP_DN,LDN,E_3,D4,Q4);
	U8 : BCD2SSD port map(DISPLAY(15 downto 12),A4,F4);
	
	U9 : COUNTER_SYNC_11 port map(CLK,RSTN,UP_DN,LDN,E_4,D5,Q5);
	U10 : BCD2SSD port map(DISPLAY(19 downto 16),A5,F5);
	
	U11 : COUNTER_SYNC_6 port map(CLK,RSTN,UP_DN,LDN,E_5,D6,Q6);
	U12 : BCD2SSD port map(DISPLAY(23 downto 20),A6,F6);
	
--	U13 : MUX_2X1_4bit port map (SET_DATA(3 downto 0), ALARM_DATA(3 downto 0), SHOW_A, X(3 downto 0));
--	U14 : MUX_2X1_4bit port map (SET_DATA(7 downto 4), ALARM_DATA(7 downto 4), SHOW_A, X(7 downto 4));
--	U15 : MUX_2X1_4bit port map (SET_DATA(11 downto 8), ALARM_DATA(11 downto 8), SHOW_A, X(11 downto 8));
--	U16 : MUX_2X1_4bit port map (SET_DATA(15 downto 12), ALARM_DATA(15 downto 12), SHOW_A, X(15 downto 12));
--	U17 : MUX_2X1_4bit port map (SET_DATA(19 downto 16), ALARM_DATA(19 downto 16), SHOW_A, X(19 downto 16));
--	U18 : MUX_2X1_4bit port map (SET_DATA(23 downto 20), ALARM_DATA(23 downto 20), SHOW_A, X(23 downto 20));
	
	U19 : MUX_2X1_4bit port map (ALARM_DATA(3 downto 0), TIME_DATA(3 downto 0), SHOW_T, DISPLAY(3 downto 0));
	U20 : MUX_2X1_4bit port map (ALARM_DATA(7 downto 4), TIME_DATA(7 downto 4), SHOW_T, DISPLAY(7 downto 4));
	U21 : MUX_2X1_4bit port map (ALARM_DATA(11 downto 8), TIME_DATA(11 downto 8), SHOW_T, DISPLAY(11 downto 8));
	U22 : MUX_2X1_4bit port map (ALARM_DATA(15 downto 12), TIME_DATA(15 downto 12), SHOW_T, DISPLAY(15 downto 12));
	U23 : MUX_2X1_4bit port map (ALARM_DATA(19 downto 16), TIME_DATA(19 downto 16), SHOW_T, DISPLAY(19 downto 16));
	U24 : MUX_2X1_4bit port map (ALARM_DATA(23 downto 20), TIME_DATA(23 downto 20), SHOW_T, DISPLAY(23 downto 20));
	
	TIME_DATA(3 DOWNTO 0) <= Q1;
	TIME_DATA(7 DOWNTO 4) <= Q2_FINAL;
	TIME_DATA(11 DOWNTO 8) <= Q3_FINAL;
	TIME_DATA(15 DOWNTO 12) <= Q4_FINAL;
	TIME_DATA(19 DOWNTO 16) <= Q5_FINAL;
	TIME_DATA(23 DOWNTO 20) <= Q6;
	
	process(CLK, RSTN, LOAD_A, ALARM_ON, TIME_DATA, ALARM_DATA)
	 
	begin 
	

	  if rising_edge(CLK) then
	    
		 
		 if (ALARM_ON = '1') and (TIME_DATA(23 downto 8) = ALARM_DATA(23 downto 8) ) then
	    BUZZER <= '1';
		
       else
	    BUZZER <= '0';
		 
	    end if;
	 
	  end if;
 end process;
	
end FUNCTIONALITY;