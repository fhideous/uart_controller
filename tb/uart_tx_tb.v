`timescale 1ns / 1ps

module uart_tx_tb;

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
                        
            .ready_i(ready),
            .valid_o(valid),
            .tx_o(tx_o)
    );
    
    integer i = 0;
    
    reg flag_start = 0;
    reg [7:0] data = 0;
    
task task_utx ( input tx_out, input ready, output end_task);
begin
    if (tx_out == 'b0 && !flag_start)
        flag_start = 1'b1;
     else begin
         if (flag_start) begin
            data[i] = tx_out;
            i = i + 1;
         end 
         if (i == 8) begin
            i = 0;
            flag_start = 0;
            end_task = 0;
            $display ("tx_i: %d%d%d%d_%d%d%d%d", data[7], data[6], data[5], data[4], data[3], data[2], data[1], data[0]);
         end else 
            end_task = ready;
     end
end
endtask


  initial begin 
     clk_i = 'b0;
     forever begin
       #CLK_SEMIPERIOD clk_i = ~clk_i;
     end
  end
        integer j = 0;
        reg end_while = 1;
  initial begin 

    nreset_i = 'b0;
    ready = 'b0;
    #500;     
    nreset_i = 'b1;
    tx_data_i = 'b0110_1100;
  
  
    #500;
    ready = 'b1;
     while (end_while) begin
        task_utx (tx_o, ready, end_while);
        #100_000;
    end
    if (tx_o == 'b1)
        $display ("All ok");
     else 
        $display ("Something go wrong");
    $display ("End transmitt");
    end_while = 1;
    ready = 'b0;
    
    
    
    #100_0000;
    ready = 'b1;
    tx_data_i = 'b1000_1000;
     while (end_while) begin
        task_utx (tx_o, ready, end_while);
        #100_000;
    end
    if (tx_o == 'b1)
        $display ("All ok");
     else 
        $display ("Something go wrong");
    $display ("End transmitt");
    end_while = 1;
    ready = 'b0;
    
   
   end


endmodule
