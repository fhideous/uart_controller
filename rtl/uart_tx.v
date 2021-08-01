`timescale 1ns / 1ps


module uart_tx(

  input           clk_i,
	input           nreset_i,

	input  [7:0]    tx_data_i,

  input           ready,
  output          valid,

	output wire     tx_o

);


localparam  BIT_RATE        = 9600;
localparam  CLK_HZ          = 100_000_000;

localparam  CLKS_PER_BIT    = CLK_HZ / BIT_RATE;
localparam  COUNTER_LEN     = 1 + $clog2(CLKS_PER_BIT);

reg  [COUNTER_LEN - 1:0]  clk_counter;

reg  [9:0]                reg_data;                    

reg                      is_transmitting;

wire                    cnt_tic;


assign    valid   =   ( nreset_i ) && ( !is_transmitting ) ;

always @ ( posedge clk_i ) begin 
  if ( !nreset_i ) begin
      is_transmitting    <=  1'b0;
      reg_data           <=  10'b11_1111_1111;
  end else if ( valid && ready ) begin 
      is_transmitting    <= 'b1;
      reg_data           <=  {1'b1, tx_data_i, 1'b0};
  end
end 

always @ ( posedge clk_i ) begin 
  if ( !nreset_i )
    clk_counter   <= 'b0;
  else begin
    if ( clk_counter == CLKS_PER_BIT )
      clk_counter <= 1'b0; 
    else 
      clk_counter <= clk_counter + 1'b1;
  end    
end  

reg   [3:0]           n_byte;

assign        cnt_tic = ( clk_counter == CLKS_PER_BIT - 1);

always @( posedge clk_i ) begin
  if ( !nreset_i  )
    n_byte                <= 4'b0;
  else begin 
    if ( n_byte == 'd9 && cnt_tic ) begin
      n_byte              <= 4'b0;
      is_transmitting     <= 1'b0;
      reg_data            <= 10'b11_1111_1111;
    end else if ( cnt_tic )
      n_byte              <= n_byte + 1'b1; 
   end
end


assign tx_o = reg_data[n_byte];

endmodule