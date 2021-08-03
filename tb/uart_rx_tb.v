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

 initial begin 

  nreset_i = 'b0;
  rx_i = 1'b1;
  data = 8'b1;

  #5000;
  valid = 'b0;

  nreset_i = 'b1;
  #500000;

  valid = 'b1;
  data = 8'b1001_0101;
      rx_i = 1'b1;
      #2000;

      //start bit
  rx_i = 1'b0;
  #100_000;
      //data
  rx_i = data[0];
  #100_000;
  rx_i = data[1];
  #100_000;
  rx_i = data[2];
  #100_000;
  rx_i = data[3];
  #100_000;
  rx_i = data[4];
  #100_000;
  rx_i = data[5];
  #100_000;
  rx_i = data[6];
  #100_000;
  rx_i = data[7];
  #100_000;
  
  rx_i = 1'b1;
  #100_000;

  valid = 'b1;
  #10000;
  valid = 'b0;
  #10000;

 end 

endmodule
