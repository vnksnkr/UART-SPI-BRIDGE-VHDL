----------------------------------------------------------------------------
--  uart.vhd
--	UART
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

entity uart is
    generic (
        CLKS_PER_BIT : integer := 434
    );
    port (
        clk : in std_logic;
        start : in std_logic;
        din : in std_logic_vector (7 downto 0);

        rx : in std_logic;
        tx : out std_logic;
        tx_dv : in std_logic;
        tx_busy : out std_logic;
        tx_done : out std_logic;
        rx_dv : out std_logic;
        rx_bytes : out std_logic_vector (7 downto 0)
    );

end entity uart;

architecture RTL of uart is
begin

    uart_rx_inst : entity work.uart_rx
        port map (
            clk => clk,
            rx => rx,

            rx_bytes => rx_bytes,
            rx_dv => rx_dv );

    uart_tx_inst : entity work.uart_tx
        port map (
            clk => clk,
            start => start,
            din => din,

            tx => tx,
            tx_done => tx_done,
            tx_busy => tx_busy );

end RTL;