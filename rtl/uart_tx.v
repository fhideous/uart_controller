module uart_tx #(
   parameter CLK_PER_BIT = 1
)(

  input           clk_i,
  input           nreset_i,

  input  [7:0]    tx_data_i,

  input           ready_i,
  output          valid_o,

  output reg      tx_o

);

localparam  COUNTER_LEN     = 1 + $clog2(CLK_PER_BIT);

reg  [COUNTER_LEN - 1:0]  clk_counter;

reg   [8:0]               reg_data;                    
reg   [3:0]               n_bit;

reg                       is_transmitting;

wire                      cnt_tic;

assign    valid_o   =   ( nreset_i ) && ( !is_transmitting ) ;

always @( posedge clk_i ) begin 
  if ( !nreset_i ) begin
      is_transmitting    <=  1'b0;
      reg_data           <=  9'b1_1111_1111;
  end else if ( valid_o && ready_i ) begin 
      is_transmitting    <= 'b1;
      reg_data           <=  { 1'b1, tx_data_i };
  end else if ( n_bit == 'd9 && cnt_tic  )
      is_transmitting    <= 'b0;
end 

always @( posedge clk_i ) begin 
  if ( !nreset_i )
    clk_counter   <= 'b0;
  else if ( is_transmitting ) begin
    if ( ( clk_counter == CLK_PER_BIT ) )
      clk_counter <= 1'b0; 
    else 
      clk_counter <= clk_counter + 1'b1;
  end 
end  

assign        cnt_tic = ( clk_counter == CLK_PER_BIT - 1);

always @( posedge clk_i ) begin
  if ( ( !nreset_i ) || ( ready_i && valid_o ))
    n_bit    <= 4'b0;
  else begin 
    if ( cnt_tic )
      n_bit  <= n_bit + 1'b1; 
   end
end

always @ ( posedge clk_i ) begin
    if ( ( !nreset_i ) || ( cnt_tic && ( n_bit == 'd9 ) ) )
        tx_o  <=    1'b1;
    else if ( ready_i && valid_o )
        tx_o  <=    1'b0;
    else if ( cnt_tic )
        tx_o  <=    reg_data[n_bit];
end 

endmodule