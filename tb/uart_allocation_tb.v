`timescale 1ns / 1ps

module uart_allocation_tb;
    
    reg         clk_i;
  reg         nreset_i;
  wire        aresetn_o;
  wire        clk_o;

  reg         s_valid_i;
  reg         m_ready_i;

  wire        s_ready_o;
  wire        m_valid_o;

  reg         rx_i;
  wire  [7:0] rx_o;

  reg   [7:0] tx_i;
  wire        tx_o;


localparam CLK_SEMIPERIOD = 5;

uart_allocation #(
  .BIT_RATE       (9600            ),
  .CLK_HZ         (100_000_000     )
)uut (
  .clk_i          (clk_i      ),
  .aresetn_i      (nreset_i   ),

  .clk_o          (clk_o      ),
  .aresetn_o      (aresetn_o  ),

  .s_valid_i      (s_valid_i  ),
  .s_ready_o      (s_ready_o  ),
  .s_rx_data_i    (rx_i       ),
  .s_rx_data_o    (rx_o       ),

  .m_valid_o      (m_valid_o  ),
  .m_ready_i      (m_ready_i  ),
  .m_tx_data_o    (tx_o       ),  
  .m_tx_data_i    (tx_i       )

);


  initial begin 
     clk_i = 'b0;
     forever begin
       #CLK_SEMIPERIOD clk_i = ~clk_i;
     end
  end

reg  [7:0]  data;

integer   CLKS_PER_BIT    = 100_000_000_0 / 9600;
 
 
 initial begin 


  nreset_i = 'b0;
  tx_i = 8'b1;
  m_ready_i = 'b0;
  rx_i = 1'b1;
  data = 8'b1;
 #5000;
  nreset_i = 'b1;
 #5000;

  data = 8'b1000_0001;
    rx_i = 1'b1;
    s_valid_i = 1'b1;
      #2000;

      //start bit
  rx_i = 1'b0;
  #CLKS_PER_BIT;
  s_valid_i = 1'b0;
      //data
  rx_i = data[0];
  #CLKS_PER_BIT;
  rx_i = data[1];
  #CLKS_PER_BIT;
  rx_i = data[2];
  #CLKS_PER_BIT;
  rx_i = data[3];
  #CLKS_PER_BIT;
  rx_i = data[4];
  #CLKS_PER_BIT;
  rx_i = data[5];
  #CLKS_PER_BIT;
  rx_i = data[6];
  #CLKS_PER_BIT;
  rx_i = data[7];
  #CLKS_PER_BIT;
  // stop bit
  rx_i = 1'b1;
  #CLKS_PER_BIT;
    s_valid_i = 1'b1;
  data = 8'b0010_0110;

      //start bit
  rx_i = 1'b0;
  #CLKS_PER_BIT;
      s_valid_i = 1'b0;
      //data
  rx_i = data[0];
  #CLKS_PER_BIT;
  rx_i = data[1];
  #CLKS_PER_BIT;
  rx_i = data[2];
  #CLKS_PER_BIT;
  rx_i = data[3];
  #CLKS_PER_BIT;
  rx_i = data[4];
  #CLKS_PER_BIT;
  rx_i = data[5];
  #CLKS_PER_BIT;
  rx_i = data[6];
  #CLKS_PER_BIT;
  rx_i = data[7];
  #CLKS_PER_BIT;
  // stop bit
  rx_i = 1'b1;
  #CLKS_PER_BIT;

  #CLKS_PER_BIT;
  #CLKS_PER_BIT;
  #CLKS_PER_BIT;
  #CLKS_PER_BIT;
  #CLKS_PER_BIT;
  #CLKS_PER_BIT;
  #CLKS_PER_BIT;
  #CLKS_PER_BIT;
  #CLKS_PER_BIT;
  #CLKS_PER_BIT;
  #CLKS_PER_BIT;
  #CLKS_PER_BIT;
  #CLKS_PER_BIT;
  #CLKS_PER_BIT;
  #CLKS_PER_BIT;
  #CLKS_PER_BIT;
  #CLKS_PER_BIT;
  #CLKS_PER_BIT;
  #CLKS_PER_BIT;
  #CLKS_PER_BIT;

  data = 8'b1000_1000;

      //start bit
  rx_i = 1'b0;
  #CLKS_PER_BIT;
      //data
  rx_i = data[0];
  #CLKS_PER_BIT;
  rx_i = data[1];
  #CLKS_PER_BIT;
  rx_i = data[2];
  #CLKS_PER_BIT;
  rx_i = data[3];
  #CLKS_PER_BIT;
  rx_i = data[4];
  #CLKS_PER_BIT;
  rx_i = data[5];
  #CLKS_PER_BIT;
  rx_i = data[6];
  #CLKS_PER_BIT;
  rx_i = data[7];
  #CLKS_PER_BIT;
  // stop bit
  rx_i = 1'b1;
  
  #CLKS_PER_BIT;
  tx_i = 8'b1001_1101;
  #CLKS_PER_BIT;
  #CLKS_PER_BIT;
  
  m_ready_i = 1'b1;
  #CLKS_PER_BIT;
  #CLKS_PER_BIT;
  #CLKS_PER_BIT;
  #CLKS_PER_BIT;
  #CLKS_PER_BIT;
  #CLKS_PER_BIT;
  #CLKS_PER_BIT;
  #CLKS_PER_BIT;
  #CLKS_PER_BIT;
  #CLKS_PER_BIT;
  #CLKS_PER_BIT;

  #CLKS_PER_BIT;
  #CLKS_PER_BIT;
  m_ready_i = 1'b0;
  #CLKS_PER_BIT;
  m_ready_i = 1'b1;

 end




endmodule