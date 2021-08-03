
module uart_rx(

  input             clk_i,
  input             nreset_i,

  input             rx_i,

  input             valid_i,
  output            ready_o, 

  output reg [7:0]  data_o
  
);

localparam  BIT_RATE        = 9600;
localparam  CLK_HZ          = 100_000_000;

localparam  CLKS_PER_BIT    = CLK_HZ / BIT_RATE;
localparam  COUNTER_LEN     = 1 + $clog2(CLKS_PER_BIT / 2);

reg  [COUNTER_LEN - 1:0]  clk_counter;
wire                      cnt_tic;
reg                       is_transmitting;

reg                       start_bit;
reg   [3:0]               bit_cnt;

assign    ready_o   =   ( nreset_i ) && ( !is_transmitting ) ;

always @( posedge clk_i ) begin 
  if ( !nreset_i ) begin
      is_transmitting    <=  1'b0;
  end else begin 
    if ( valid_i && ready_o ) 
        is_transmitting    <= 'b1;
    else if ( bit_cnt == 'd9 && cnt_tic  )
        is_transmitting    <= 'b0;
  end 
end

always @( posedge clk_i ) begin 
  if ( !nreset_i )
    clk_counter   <= 'b0;
  else if ( is_transmitting ) begin
    if ( ( clk_counter == CLKS_PER_BIT / 2) )
      clk_counter <= 1'b0; 
    else 
      clk_counter <= clk_counter + 1'b1;
  end 
end  

assign        cnt_tic = ( clk_counter == ( CLKS_PER_BIT / 2 ) - 1) || ( valid_i && ready_o );

wire          is_second_tic;

always @( posedge clk_i ) begin
  if ( ( !nreset_i ) || ( ready_o && valid_i ) )
    bit_cnt    <= 4'b0;
  else begin 
    if ( is_second_tic && cnt_tic && start_bit)     
      bit_cnt  <= bit_cnt + 1'b1; 
   end
end

reg          is_second_tic_reg;

assign is_second_tic = cnt_tic && is_second_tic_reg;

always @( posedge clk_i ) begin
  if ( !nreset_i )
    is_second_tic_reg <= 1'b0;
  else begin
    if ( ( cnt_tic ) && is_second_tic_reg )  
        is_second_tic_reg <= 1'b0;
    else if ( cnt_tic )
        is_second_tic_reg <= 1'b1;
  end
end
 

always @( posedge clk_i ) begin
  if ( !nreset_i )
    data_o <= 8'b1111_1111;
  else begin
    if ( is_transmitting && is_second_tic ) begin
      data_o[bit_cnt] = rx_i;
    end 
  end
end

always @( posedge clk_i ) begin
  if ( !nreset_i )
    start_bit <= 1'b0;
  else begin
    if (is_transmitting && cnt_tic && !rx_i)
      start_bit <= 1'b1;
    else if ( bit_cnt == 'd9 ) 
      start_bit <= 1'b0; 
  end
end

endmodule