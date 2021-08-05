`timescale 1ns / 1ps

module uart_rx_tb;

  reg         clk_i;
  reg         nreset_i;

  reg         rx_i;

  reg         valid;
  wire        ready;

  wire [7:0]  data_rx;

  localparam CLK_SEMIPERIOD = 5;

  uart_rx uut
  (
      .clk_i      (clk_i        ),
      .nreset_i   (nreset_i     ),
  
      .rx_i       (rx_i         ),
                     
      .valid_i    (valid        ),
      .ready_o    (ready        ),
      .data_o     (data_rx      )
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
  rx_i = 1'b1;
  data = 8'b1;

  #5000;
  valid = 'b0;

  nreset_i = 'b1;
  #500000;

  valid = 'b1;
  data = 8'b1001_0100;
      rx_i = 1'b1;
      #2000;

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
  
  
    data = 8'b0001_0010;
   // start bit
  rx_i = 1'b0;
  #CLKS_PER_BIT;
    valid = 1'b0;
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
  rx_i = 1'b1;
  #CLKS_PER_BIT;
  

  
 end 
 

endmodule
