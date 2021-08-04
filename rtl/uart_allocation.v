
module uart_allocation(
  input       clk,
  input       reset,

  input       rx_i,
  output      tx_o
);

localparam  BIT_RATE        = 9600;
localparam  CLK_HZ          = 100_000_000;

localparam  CLKS_PER_10_BIT    = CLK_HZ / BIT_RATE * 10;
localparam  COUNTER_LEN     = 1 + $clog2(CLKS_PER_10_BIT / 2);

reg  [COUNTER_LEN - 1:0]  clk_counter;

wire                      cnt_tic;
wire    [7:0]   data;

wire            ready;  
wire            valid;  

reg   [7:0]     cnt;
reg   [7:0]     cnt_static;

wire  [7:0]     data_rx;

uart_tx inst_uart_tx
(
  .clk_i        (clk        ),
  .nreset_i     (reset      ),

  .tx_data_i    (data_rx    ),
  .ready_i      (ready      ),
  .valid_o      (valid      ),
  .tx_o         (tx_o       )
);


always @( posedge clk ) begin 
  if ( !reset )
    clk_counter   <= 'b0;
   else begin
    

if ( ( clk_counter == CLKS_PER_10_BIT ) )
      clk_counter <= 1'b0; 
    else 
      clk_counter <= clk_counter + 1'b1;   
    end  
end

assign        cnt_tic = ( clk_counter == CLKS_PER_10_BIT  - 1);



 uart_rx inst_uart_rx
 (
   .clk_i        (clk        ),
   .nreset_i     (reset      ),

   .rx_i         (rx_i       ),
   .valid_i      (valid      ),
   .ready_o      (ready      ),
   .data_o       (data_rx    )

 );


always @( posedge clk ) begin
    if (!reset)
        cnt_static <= 8'b0000_0000;
    else begin 
        if ( cnt == 'b0 && cnt_tic)
            cnt_static <= 8'b0001_010;
        else 
            cnt_static <= 8'b1000_1101;
     end
end

always @ ( posedge clk ) begin
  if (!reset)
    cnt <= 8'b0000_0000;
  else if (cnt_tic) begin 
    if (cnt >= 8'd100 )
      cnt <= 1'd0;
    else
      cnt <= cnt + 1'd1; 
  end
end

endmodule
