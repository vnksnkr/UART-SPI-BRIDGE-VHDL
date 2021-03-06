----------------------------------------------------------------------------
--  spislave8.vhd
--	SPI SLAVE (8 bit)
--	
--
--  Copyright (C) 2021 Vinayak Sankar
--
--	This program is free software: you can redistribute it and/or
--	modify it under the terms of the GNU General Public License
--	as published by the Free Software Foundation, either version
--	2 of the License, or (at your option) any later version.
--
----------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SPI_slave8 is
    port (
        SCK : in std_logic;
        MOSI : in std_logic;
        SSEL : in std_logic;
        MISO : out std_logic;
        r_bytes : out std_logic_vector(7 downto 0)
    );
end entity SPI_slave8;

architecture RTL of SPI_slave8 is

    signal r_bitcnt : integer range 0 to 7 := 0;
    signal t_bytes : std_logic_vector(7 downto 0) := "10101010";

    signal MISO_r : std_logic := '0';

begin

    process (SCK)
    begin
        if rising_edge(SCK) then
            if SSEL = '0' then
                if r_bitcnt < 7 then
                    r_bitcnt <= r_bitcnt + 1;
                else
                    r_bitcnt <= 0;
                end if;

                r_bytes(r_bitcnt) <= MOSI;
                t_bytes <= '1' & t_bytes(7 downto 1);
            end if;
        end if;

    end process;
    MISO <= t_bytes(0) when SSEL = '0' else
        'Z';
end RTL;