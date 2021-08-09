`timescale 1ns / 1ps

module uart_alloc_tb;
    
  reg         clk_i;
  reg         nreset_i;

  reg         rx_i;
  wire        tx_o;


  localparam CLK_SEMIPERIOD = 5;

uart_allocation uut
(
  .clk            (clk_i      ),
  .reset          (nreset_i   ),

  .rx_i           (rx_i       ),
  .tx_o           (tx_o       )  
);

localparam  BIT_RATE        = 9600;
localparam  CLK_HZ          = 100_000_000;

localparam  CLK_PER_10_BIT    = CLK_HZ / BIT_RATE * 10;
localparam  COUNTER_LEN     = 1 + $clog2(CLK_PER_10_BIT / 2);

localparam  CLK_PER_BIT = CLK_PER_10_BIT ;

 initial begin 
     clk_i = 'b0;
     forever begin
       #CLK_SEMIPERIOD clk_i = ~clk_i;
     end
  end

  reg [7:0] data;

 initial begin 

  nreset_i = 'b0;
  rx_i = 1'b1;
  data = 8'b1111_1111;
  
  #5000;


  nreset_i = 'b1;
  #500000;

  data = 8'b1000_0001;
  rx_i = 1'b1;
  #2000;

      //start bit
  rx_i = 1'b0;
  #CLK_PER_BIT;
      //data
  rx_i = data[0];
  #CLK_PER_BIT;
  rx_i = data[1];
  #CLK_PER_BIT;
  rx_i = data[2];
  #CLK_PER_BIT;
  rx_i = data[3];
  #CLK_PER_BIT;
  rx_i = data[4];
  #CLK_PER_BIT;
  rx_i = data[5];
  #CLK_PER_BIT;
  rx_i = data[6];
  #CLK_PER_BIT;
  rx_i = data[7];
  #CLK_PER_BIT;
  // stop bit
  rx_i = 1'b1;
  #CLK_PER_BIT;

 end 
 

endmodule
