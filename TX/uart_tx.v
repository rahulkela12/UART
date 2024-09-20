/*
Module UART Transmitter

Input:  clk_50M - 50 MHz clock
        data    - 8-bit data line to transmit
Output: tx      - UART Transmission Line
*/

// module declaration
module uart_tx(
    input  clk_50M,
    input  [7:0] data,
    output reg tx
);

initial begin
	 tx = 0;
end
reg [8:0] counter = 0;
parameter state_start = 0,state_data = 1,state_stop = 2;
reg[1:0] state = state_data;
reg[3:0] counter_data = 0;

always @(posedge clk_50M) begin
  if(counter == 434) begin
   counter = 0;
	case(state)
	   state_start : begin
		  state = state_data;
		  tx = 0;
		 end
		 state_data : begin
		  tx = data[counter_data];
		  counter_data = counter_data + 1;
		  if(counter_data == 8) begin
		  state = state_stop;
		  counter_data = 0;
		  end
		  else begin
		  state = state_data;
		  end
		  end
		 state_stop: begin
		 state = state_start;
		 tx = 1;
		 end
	endcase
  end
  counter = counter + 1;
  end

endmodule