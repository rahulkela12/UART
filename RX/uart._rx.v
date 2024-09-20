/*Module UART Receiver

Input:  clk_50M - 50 MHz clock
        rx      - UART Receiver

Output: rx_msg      - read incoming message
        rx_complete - message received flag
*/

// module declaration
module uart_rx (
  input clk_50M, rx,
  output reg [7:0] rx_msg,
  output reg rx_complete
);


initial begin

rx_msg = 0; rx_complete = 0;

end
parameter state_start = 0,state_data = 1,state_stop = 2;
reg [1:0] state = state_data;

reg [8:0] counter = 0;
reg [3:0] counter_data = 0;
reg [7:0] temp = 0;
reg first = 0;
always @(posedge clk_50M) begin
   if(counter == 434) begin
	counter = 0;
     case(state)
	   state_start : begin
		  state = state_data;
		 end
		 state_data : begin
		  temp[7-counter_data] = rx;
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
		 end
	endcase
	end
	if(state == state_data && counter == 0 && counter_data == 0 && first != 0)begin
	rx_complete = 1;
	rx_msg = temp;
	end
	else if(first == 0 && counter == 0) begin
	rx_complete = 0;
	first = 1;
	end
	else begin
	rx_complete = 0;
	end
   counter = counter + 1;
end

endmodule