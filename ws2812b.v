//https://cdn-shop.adafruit.com/datasheets/WS2811B.pdf

module ws2812b(input clk, output sig1, input [0:23] value);
   
   localparam LED_COUNT=6000; // octave> (1000000/120)/(15*1/12)
                               // ans = 6666.666666666667

                         //  G------gR------rB------b
   //reg [23:0] value =  24'b000000010000000000000000;
   reg ready = 0;
   reg [23:0]     divider;
   reg [3:0] state0_counter;
   reg [3:0] state1_counter;
   reg ws2812b_data;
   reg [4:0] state;
   reg [5:0] bit_count = 0; 

   always @(posedge clk) begin
      if (ready) 
        begin
           if (divider == (12000000/120-1)) //120 Hz refresh rate 
             begin
                divider <= 0;
             end
           else 
             divider <= divider + 1;
        end
      else
        begin
           ready <= 1;
           divider <= 0;
        end
   end

   always @(posedge clk) begin
      if (ready) 
        begin
          if (divider == (LED_COUNT*3*8*15-1))
            begin
              state <= 2;
              ws2812b_data <= 0;
            end
          else if (divider == (12000000/120-100*12))
            begin
              state <= 3;
              ws2812b_data <= 0;
            end
          else if (divider == (12000000/120-1)) 
            begin
              state <= 0;
              state0_counter <= 0;
              bit_count <= 0;
              ws2812b_data <= 1;
            end
          else if(state == 0)
            begin
              state0_counter <= state0_counter + 1;
              if(((state0_counter == 9) && (value[bit_count] == 1)) || ((state0_counter == 4) && (value[bit_count] == 0)))
                begin
                  state <= 1;
                  state1_counter <= 0;
                  ws2812b_data <= 0;
                end
            end
          else if(state == 1)
            begin
              state1_counter <= state1_counter + 1;
              if(((state1_counter == 4) && (value[bit_count] == 1)) || ((state1_counter == 9) && (value[bit_count] == 0)))
                begin
                  state <= 0;
                  state0_counter <= 0;
                  ws2812b_data <= 1;
                  if(bit_count == 23)
                      bit_count <= 0;
                  else
                      bit_count <= bit_count + 1;
                end
            end
        end
      else 
        begin
             state <= 0; 
             ws2812b_data <= 1;
             state0_counter <= 0;
             state1_counter <= 0;
             bit_count <= 0;
        end
   end
   
   assign sig1 = ws2812b_data;
endmodule // top
