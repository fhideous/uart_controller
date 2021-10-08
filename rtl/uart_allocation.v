
module uart_allocation #(
  parameter BIT_RATE = 9600,
  parameter CLK_HZ   = 100_000_000
)(
  input         clk_i,
  input         aresetn_i,

  output        clk_o,
  output        aresetn_o,

  input         s_rx_data_i,
  input         s_valid_i,
  output        s_ready_o,
  output [7:0]  s_rx_data_o,
  
  input  [7:0]  m_tx_data_i,
  input         m_ready_i,
  output        m_valid_o,
  output        m_tx_data_o

);

localparam  CLK_PER_10_BIT  = CLK_HZ / BIT_RATE * 10;

uart_tx #(
  .CLK_PER_BIT  (CLK_PER_10_BIT / 10    )
) inst_uart_tx (
  .clk_i        (clk_i                  ),
  .nreset_i     (aresetn_i              ),

  .tx_data_i    (m_tx_data_i            ),
  .ready_i      (m_ready_i              ),
  .valid_o      (m_valid_o              ),
  .tx_o         (m_tx_data_o            )
);

 uart_rx #( 
    .CLK_PER_BIT (CLK_PER_10_BIT / 10   )
) inst_uart_rx (
   .clk_i        (clk_i                 ),
   .nreset_i     (aresetn_i             ),

   .rx_i         (s_rx_data_i           ),
   .valid_i      (s_valid_i             ),
   .ready_o      (s_ready_o             ),
   .data_o       (s_rx_data_o           )

 );

assign clk_o      = clk_i;
assign aresetn_o  = aresetn_i; 

endmodule
