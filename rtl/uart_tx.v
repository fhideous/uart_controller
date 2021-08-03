module uart_tx(

  input           clk_i,
  input           nreset_i,

  input  [7:0]    tx_data_i,

  input           ready,
  output          valid,

  output reg      tx_o

);

localparam  BIT_RATE        = 9600;
localparam  CLK_HZ          = 100_000_000;

localparam  CLKS_PER_BIT    = CLK_HZ / BIT_RATE;
localparam  COUNTER_LEN     = 1 + $clog2(CLKS_PER_BIT);

reg  [COUNTER_LEN - 1:0]  clk_counter;

reg   [8:0]               reg_data;                    
reg   [3:0]               n_byte;

reg                       is_transmitting;

wire                      cnt_tic;


assign    valid   =   ( nreset_i ) && ( !is_transmitting ) ;

always @( posedge clk_i ) begin 
  if ( !nreset_i ) begin
      is_transmitting    <=  1'b0;
      reg_data           <=  9'b1_1111_1111;
  end else if ( valid && ready ) begin 
      is_transmitting    <= 'b1;
      reg_data           <=  { 1'b1, tx_data_i };
  end else if ( n_byte == 'd9 && cnt_tic  )
      is_transmitting    <= 'b0;
end 

always @( posedge clk_i ) begin 
  if ( !nreset_i )
    clk_counter   <= 'b0;
  else if ( is_transmitting ) begin
    if ( ( clk_counter == CLKS_PER_BIT ) )
      clk_counter <= 1'b0; 
    else 
      clk_counter <= clk_counter + 1'b1;
  end 
end  

assign        cnt_tic = ( clk_counter == CLKS_PER_BIT - 1);

always @( posedge clk_i ) begin
  if ( !nreset_i || ( ready && valid ))
    n_byte    <= 4'b0;
  else begin 
    if ( cnt_tic )
      n_byte  <= n_byte + 1'b1; 
   end
end

always @ ( posedge clk_i ) begin
    if ( ( !nreset_i ) || ( cnt_tic && ( n_byte == 'd9 ) ) )
        tx_o  <=    1'b1;
    else if ( ready && valid )
        tx_o  <=    1'b0;
    else if ( cnt_tic )
        tx_o  <=    reg_data[n_byte];
end 

endmodule