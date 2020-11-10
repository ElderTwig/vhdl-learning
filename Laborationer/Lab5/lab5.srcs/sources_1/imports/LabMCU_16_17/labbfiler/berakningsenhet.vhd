----------------------------------------------------------------------------------
-- Namn:        berakningsenhet
-- Filnamn:     berakningsenhet.vhd
-- Testbench:   berakningsenhet_tb.vhd
--
-- Insignaler:
--      clk     - klocksignal, all uppdatering av register sker vid stigande flank
--      n_rst   - synkron resetsignal, aktiv l�g
--      DATA    - data fr�n instruktionen
--      INPUT   - insignalen JA synkroniserad i IO-blocket
--      DEST    - v�ljer om R0 eller R1 i registerblocket ska vara aktivt
--      ALUsrc  - v�ljer om det asktiva registret eller insignalen JA fr�n IO-blocket 
--                ska anv�ndas som operand till ALU
--      ALUop   - styr vilken operation ALu ska utf�ra
--      RegEna  - laddsignal till registerblocket, h�gt v�rde medf�r att det aktiva 
--                registret ska uppdateras med resultatet fr�n ALU
--
-- Utsignaler:
--      OUTPUT - data som ska skrivs till signalen JB
--      Z      - zero-flagga, h�g om resultet fr�n ALU �r noll
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.all;
use work.cpu_pkg.all;


entity berakningsenhet is
    port(
        clk, n_rst : in std_logic;
        DATA : in std_logic_vector(7 downto 0);
        INPUT : in std_logic_vector(7 downto 0);
        DEST : in std_logic;
        ALUSrc : in std_logic;
        ALUOp : in std_logic_vector(2 downto 0);
        RegEna : in std_logic;
        OUTPUT : out std_logic_vector(7 downto 0);
        Z : out std_logic
    );
end entity;

architecture structural of berakningsenhet is
    
    signal RegOut, ALUOut, operandB : STD_LOGIC_VECTOR(7 downto 0);
    
begin
    
    OUTPUT <= ALUOut;
   
ALU_i:entity ALU8 port map(
    A => DATA,
    B => operandB,
    S => ALUOp,
    Z => Z,
    F => ALUOut
);
    
opreand_B_mux_i:entity MUX2x8 port map( 
    IN0 => RegOut,
    IN1 => INPUT,
    O => operandB,
    SEL => ALUSrc
);

register_file_i:entity registerblock port map(
    clk => clk,
    n_rst => n_rst,
    F => ALUOut,
    RegOut => RegOut,
    DEST => DEST,
    RegEna => RegEna
);
    
end architecture;