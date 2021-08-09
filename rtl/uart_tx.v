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

reg   [9:0]               reg_data;                    
reg   [3:0]               n_bit;

reg                       is_transmitting;

wire                      cnt_tic;

assign    valid_o   =   ( nreset_i ) && ( is_transmitting ) ;


reg                       is_new_message;

always @( posedge clk_i ) begin
  if ( !nreset_i ) 
    is_new_message <= 'b0;
  else begin  
    if ( !ready_i )
      is_new_message <= 'b1;
    else 
      is_new_message <= 'b0; 
  end
end

always @( posedge clk_i ) begin 
  if ( !nreset_i ) begin
      is_transmitting    <=  1'b0;
      reg_data           <=  10'b1_1111_1111_0;
  end else if ( !is_transmitting && ready_i && is_new_message) begin 
      is_transmitting    <= 'b1;
      reg_data           <=  { 1'b1, tx_data_i, 1'b0};
  end else if ( n_bit == 'd10 && cnt_tic  )
      is_transmitting    <= 'b0;
end 

always @( posedge clk_i ) begin 
  if ( !nreset_i )
    clk_counter   <= 'b0;
  else if ( is_transmitting ) begin
    if ( ( clk_counter == CLK_PER_BIT ) || ( n_bit == 'd10 && cnt_tic ) )
      clk_counter <= 1'b0; 
    else 
      clk_counter <= clk_counter + 1'b1;
  end 
end  

assign        cnt_tic = ( clk_counter == CLK_PER_BIT - 1) || ( ( !clk_counter ) && ( is_transmitting ) 
                                                                                && ( !n_bit )  );

always @( posedge clk_i ) begin
  if ( ( !nreset_i ) )
    n_bit    <= 4'b0;
  else begin 
    if (      ( ( n_bit == 'd10 )      && ( cnt_tic          ) )
             || ( ready_i              && ( !is_transmitting ) ) )
      n_bit  <= 'b0; 
    else if ( cnt_tic )
      n_bit  <= n_bit + 1'b1; 
   end
end

always @ ( posedge clk_i ) begin
    if ( !nreset_i )
        tx_o  <=    1'b1;
    else begin
      if ( ( !is_transmitting ) || ( cnt_tic && ( n_bit == 'd10 ) ) )
        tx_o  <=    1'b1;
      else if ( cnt_tic )
        tx_o  <=    reg_data[n_bit];
      end 
end

endmodule