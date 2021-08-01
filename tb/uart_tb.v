`timescale 1ns / 1ps

module uart_tb;

    reg          clk_i;
    reg          nreset_i;

    reg   [7:0] tx_data_i;

    reg         ready;
    wire        valid;

    wire        tx_o;
    
    localparam CLK_SEMIPERIOD = 5;
    
    uart_tx uut
    (
            .clk_i(clk_i),
            .nreset_i(nreset_i),

            .tx_data_i(tx_data_i),
                        
            .ready(ready),
            .valid(valid),
            .tx_o(tx_o)
    );
  
    
    initial begin 
      clk_i = 'b0;
      forever begin
           #CLK_SEMIPERIOD clk_i = ~clk_i;
      end
     end

   initial begin 

     nreset_i = 'b0;
        #500;
        forever begin
     ready = 'b0;
  
     nreset_i = 'b1;
     #5000;
      tx_data_i = 'b1001_0101;
      #500000;
     ready = 'b1;
     #700000;

    
     ready = 'b0;
     #1000000;
     tx_data_i = 'b0001_0100;
     #500000;
     ready = 'b1;
     #1000000;
     ready = 'b0;
     #10000000;

     end
   end



endmodule
