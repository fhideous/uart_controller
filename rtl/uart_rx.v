module uart_rx #(
   parameter CLK_PER_BIT = 1
)(

  input             clk_i,
  input             nreset_i,

  input             rx_i,

  input             valid_i,
  output            ready_o, 

  output reg [7:0]  data_o
  
);

localparam    COUNTER_LEN     = 1 + $clog2(CLK_PER_BIT / 2);

reg   [COUNTER_LEN - 1:0]    clk_counter;

wire                         is_bod_tic;
wire                         is_second_tic;
reg                          second_bod_tic;

reg   [3:0]                  bit_cnt;

reg   [1:0]                  state;  
reg   [1:0]                  next_state;

reg                          state_1_to_2;
wire                         clk_counter_rm;

localparam    IDLE_S                 = 2'b00;
localparam    START_BIT_S            = 2'b01;  
localparam    RECIVE_DATA_S          = 2'b10;
localparam    WAIT_STOP_BIT_S        = 2'b11;

always @( posedge clk_i ) begin 
  if( !nreset_i )
    clk_counter   <= 'b0;
  else begin 
    if( state != IDLE_S ) begin
      if( (clk_counter >= ( CLK_PER_BIT ) / 2 ) && state != RECIVE_DATA_S )
        clk_counter <= 1'b0;
      else if( ( clk_counter >= CLK_PER_BIT && state == RECIVE_DATA_S  ) 
                          || ( bit_cnt == 'd7 && is_bod_tic ) )
                                                                   
        clk_counter <= 1'b0; 
      else  if( clk_counter_rm )
        clk_counter <= 1'b0; 
      else
        clk_counter <= clk_counter + 1'b1;
    end 
    else 
        clk_counter <= 1'b0;
  end
end  

assign is_bod_tic = ( clk_counter ==  ( CLK_PER_BIT - 1 ) && ( state == RECIVE_DATA_S ) )
            || ( ( clk_counter ==  ( CLK_PER_BIT - 1 ) / 2 ) && ( ( state == START_BIT_S  ) || ( state == WAIT_STOP_BIT_S ) 
                                                               ) ) ;

always @( posedge clk_i ) begin
  if ( !nreset_i )
    state_1_to_2 <= 'b0;
  else begin 
    if( ( state == 'd1 ) && ( next_state == 'd2 ) )
      state_1_to_2 <= 'b1;
    else if( state_1_to_2 )
      state_1_to_2 <= 'b0;
  end 
end

assign clk_counter_rm = state_1_to_2;

always @( posedge clk_i ) begin
  if( !nreset_i )
    bit_cnt <= 1'b0;
  else begin 
    if ( state != RECIVE_DATA_S )
      bit_cnt <= 1'b0;
    else if( ( bit_cnt == 'd8 )  && ( is_bod_tic ) )
      bit_cnt <= 1'b0;
    else if( is_bod_tic )
      bit_cnt <= bit_cnt + 1'b1; 
  end
end

always @( posedge clk_i ) begin
  if( !nreset_i )
    data_o <= 8'b0000_0000;
  else begin 
    if ( ( state == RECIVE_DATA_S )  && ( is_bod_tic ) && bit_cnt < 'd8 )
      data_o[bit_cnt] <= rx_i;
  end 
end 

always @( posedge clk_i )
  if( !nreset_i )
    state <= IDLE_S;
  else
    state <= next_state;

always @( * )
  begin

  case( state )

    IDLE_S:
      begin
        if( valid_i && rx_i == 1'b0 )
          next_state = START_BIT_S;
        else 
          next_state = IDLE_S;
      end

    START_BIT_S:
      begin
        if ( !is_bod_tic ) begin
          next_state  = START_BIT_S;
        end
        else begin
          if( rx_i == 1'b0 ) 
            next_state = RECIVE_DATA_S;
          else 
            next_state = IDLE_S;
        end
      end

    RECIVE_DATA_S:
      begin
        if( !is_bod_tic ) begin
          next_state  = RECIVE_DATA_S;
        end
        else begin
          if ( bit_cnt < 8 )
            next_state   = RECIVE_DATA_S; 
          else 
            next_state   = WAIT_STOP_BIT_S; 
        end
      end

    WAIT_STOP_BIT_S: 
    begin
     if( !is_bod_tic )
        next_state   = WAIT_STOP_BIT_S;
      else 
        next_state   = IDLE_S;
    end
  
    default:
      begin
        next_state = IDLE_S;
      end

  endcase
  end

  reg                       reg_ready;

  always @( posedge clk_i) begin
    if ( !nreset_i ) 
      reg_ready <= 1'b0;
    else begin
      if ( ( state == WAIT_STOP_BIT_S ) && ( is_bod_tic) )
        reg_ready <= 1'b1;
      else if ( state == START_BIT_S )
        reg_ready <= 1'b0;
    end
  end

  assign ready_o = reg_ready;

endmodule
      