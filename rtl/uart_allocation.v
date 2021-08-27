
module uart_allocation #(
  parameter BIT_RATE = 9600,
  parameter CLK_HZ   = 100_000_000
)(
  input       clk,
  input       reset,

  input       rx_i,
  output      tx_o
);

localparam  CLK_PER_10_BIT  = CLK_HZ / BIT_RATE * 10;
localparam  COUNTER_LEN     = 1 + $clog2(CLK_PER_10_BIT / 2);

reg  [COUNTER_LEN - 1:0]  clk_counter;

wire  [7:0]     data;

wire            ready;  
wire            valid;  

reg   [7:0]     cnt;

wire  [7:0]     data_rx;

uart_tx #(
  .CLK_PER_BIT  (CLK_PER_10_BIT / 10    )
) inst_uart_tx (
  .clk_i        (clk                    ),
  .nreset_i     (reset                  ),

  .tx_data_i    (data_rx                ),
  .ready_i      (ready                  ),
  .valid_o      (valid                  ),
  .tx_o         (tx_o                   )
);

 uart_rx #( 
    .CLK_PER_BIT (CLK_PER_10_BIT / 10   )
) inst_uart_rx (
   .clk_i        (clk                   ),
   .nreset_i     (reset                 ),

   .rx_i         (rx_i                  ),
   .valid_i      (valid                 ),
   .ready_o      (ready                 ),
   .data_o       (data_rx               )

 );


endmodule
