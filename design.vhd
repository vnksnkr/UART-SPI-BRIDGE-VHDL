library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity top is
	generic (
    		CLKS_PER_BIT : integer := 434
            );
    port	(
    		clk			   : in std_logic;
            din            : in std_logic_vector (7 downto 0);
            start          : in std_logic;
            reset          : in std_logic;
            r_bytes        : out std_logic_vector (7 downto 0);
            spi0_slave_data : out std_logic_vector (7 downto 0);
            spi1_slave_data : out std_logic_vector (7 downto 0);
            spi2_slave_data : out std_logic_vector (15 downto 0);
            spi3_slave_data : out std_logic_vector (15 downto 0)
            );
            
end entity top;

architecture rtl of top is
	
    signal tx1       : std_logic;
    signal tx_dv1    :  std_logic;
    signal tx_busy1  : std_logic;
    signal tx_done1  : std_logic;
    signal rx_dv1    : std_logic;
	signal send_to_spi : std_logic;
    
    signal miso : std_logic;
    signal mosi : std_logic;
    signal sclk : std_logic;
    signal ss0  : std_logic;
    signal ss1  : std_logic;
    signal ss2  : std_logic;
    signal ss3  : std_logic;
    signal spi_recieved : std_logic;
    signal send_to_uart : std_logic;
    
    
    signal spi_data_to   : std_logic_vector (7 downto 0);
    signal spi_data_from : std_logic_vector (7 downto 0);
    
    
    signal length  : std_logic_vector (4 downto 0);
    signal addr    : std_logic_vector (1 downto 0);
    signal to_uart : std_logic_vector (7 downto 0);
    
    
    
    

    signal tx2       : std_logic;
    signal tx_dv2    :  std_logic;
    signal tx_busy2  : std_logic;
    signal tx_done2  : std_logic;
    signal rx_dv2    : std_logic;
    signal ctrl_uart_bytes : std_logic_vector (7 downto 0);
    
    
    component uart
	generic(
    	   CLKS_PER_BIT: integer := 434
    	   );
    port
    	(
        clk   : in std_logic;
        start : in std_logic;
        din   : in std_logic_vector (7 downto 0);
        rx	  : in std_logic;
        tx	  : out std_logic;
        
        tx_dv     : in std_logic;
        tx_busy	  : out std_logic;
        tx_done	  : out std_logic;
        rx_dv	  : out std_logic;
        
        rx_bytes  : out std_logic_vector (7 downto 0)
        );
   end component;
   
   
   component controller
	port(
    	clk   	  	 : in std_logic;
        reset 	  	 : in std_logic;
        start 	  	 : in std_logic;
        from_uart 	 : in std_logic_vector (7 downto 0);
        from_spi  	 : in std_logic_vector (7 downto 0);
        spi_recieved : in std_logic;
        
        length	  : out std_logic_vector (4 downto 0);
        addr	  : out std_logic_vector (1 downto 0);
        to_spi	  : out std_logic_vector (7 downto 0);
        to_uart   : out std_logic_vector (7 downto 0);
        
        send_to_spi  : out std_logic;
        send_to_uart : out std_logic
        );
   end component;
   
   
   component spimaster
	port(
    	
        clk    : in std_logic;
        reset  : in std_logic;
        
        length : in std_logic_vector (4 downto 0);
        addr   : in std_logic_vector (1 downto 0);
        
        t_data 		 : in std_logic_vector (7 downto 0);
        send_to_spi  : in std_logic;
        miso		 : in std_logic;
        
        r_data : out std_logic_vector (7 downto 0);
        sclk   : out std_logic;
        
        ss0	   : out std_logic;
        ss1	   : out std_logic;
        ss2	   : out std_logic;
        ss3	   : out std_logic;
        
        
        mosi   : out std_logic;
        spi_recieved : out std_logic
        );
   end component;
   
   
   component SPI_slave8
	port(
    	SCK  	: in std_logic;
        MOSI 	: in std_logic;
        SSEL 	: in std_logic;
        MISO 	: out std_logic;
        r_bytes : out std_logic_vector(7 downto 0)
        );
   end component;
   
   component SPI_slave16
   port(
    	SCK  	: in std_logic;
        MOSI 	: in std_logic;
        SSEL 	: in std_logic;
        MISO 	: out std_logic;
        r_bytes : out std_logic_vector(15 downto 0)
        );          
   end component;
   
   begin
   
   U1 : uart 
   	port map(
    clk => clk,
    start => start,
    din => din,
	rx => tx2,
	tx => tx1,
	tx_dv => tx_dv1,
	tx_busy => tx_busy1,
	tx_done => tx_done1,
	rx_dv => rx_dv1,
	rx_bytes => r_bytes);
    
    U2 :uart
    port map(
    clk => clk,
    start => send_to_uart,
    din => to_uart,
    rx => tx1,
    tx => tx2,
    tx_dv => tx_dv2,
    tx_busy => tx_busy2,
    tx_done => tx_done2,
    rx_dv => rx_dv2,
	rx_bytes => ctrl_uart_bytes    
    );
    
    U3 : controller
    port map(
    clk => clk,
  	reset => reset,
  	start => rx_dv2,
    from_uart => ctrl_uart_bytes,
    from_spi => spi_data_from,
    spi_recieved => spi_recieved,
    length => length,
    addr => addr,
    to_spi => spi_data_to,
    to_uart => to_uart,
    send_to_spi => send_to_spi,  
    send_to_uart => send_to_uart
    );
    
    
    U4 : spimaster
    port map(
    clk => clk,
    reset => reset,
    length => length,
    addr => addr,  
    t_data => spi_data_to,
    send_to_spi => send_to_spi,
    miso => miso,
    r_data => spi_data_from,
    sclk => sclk,
    ss0  => ss0,
    ss1  => ss1,
    ss2  => ss2 ,
    ss3  => ss3,
    mosi => mosi,
    spi_recieved => spi_recieved    
    );
    
    
    U5 : SPI_slave8
    port map(
    SCK  => sclk,
  	MOSI => mosi,
    SSEL => ss0,
  	MISO => miso,
    r_bytes => spi0_slave_data
	);

    U6 : SPI_slave8
    port map(
    SCK => sclk,
  	MOSI => mosi,
    SSEL => ss1,
  	MISO =>miso,
    r_bytes => spi1_slave_data
	);

    U7 : SPI_slave16
    port map(
    SCK  =>  sclk,
  	MOSI => mosi,
    SSEL => ss2,
  	MISO => miso,
    r_bytes => spi2_slave_data
	);

    U8 : SPI_slave16
    port map(
    SCK  => sclk,
  	MOSI => mosi,
    SSEL => ss3,
  	MISO => miso,
    r_bytes => spi3_slave_data
	);		  
    
end RTL;    
   