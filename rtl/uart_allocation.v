
module uart_allocation(
  input       clk,
  input       reset,

  input       rx_i,
  output      tx_o
  );


wire    [7:0]   data;

wire            ready;  
wire            valid;  

reg   [7:0]     cnt;

uart_tx inst_uart_tx
(
  .clk_i        (clk        ),
  .nreset_i     (reset      ),

  .tx_data_i    (cnt        ),
  .ready_i      (ready      ),
  .valid_o      (valid      ),
  .tx_o         (tx_o       )
);

assign ready = 1'b1;
/*reg [7:0] data_rx ;

 uart_rx inst_uart_rx
 (
   .clk_i        (clk        ),
   .nreset_i     (reset      ),

   .rx_i         (rx_i       ),
   .valid_i      (valid      ),
   .ready_o      (ready      ),
   .data_o       (data_rx    )

 );
*/


always @ ( posedge clk ) begin
  if (!reset)
    cnt <= 1'b0;
  else begin 
    if (cnt >= 8'd100)
      cnt <= 1'd0;
    else
      cnt <= cnt + 1'd1; 
  end
end

endmodule
