module top(input clk,
           output [4:0] led,
           input [7:0] pmod,
           input [15:0] gpib,
           output reg ctrl_led,
           //spi interface
           output spi_miso,
           input spi_mosi,
           input spi_clk,
           input spi_cs_n);
 
   //parameter SPI_MODE = 1; // CPOL = 0, CPHA = 1

   reg [16:0] fifo = 17'd0;
   reg [4:0] counter = 5'd0;
   reg [15:0] gpib_reg = 16'd0; 

   always @ (negedge spi_clk)
   begin
      //fifo <= {fifo[15:0],spi_mosi}; // loopback fifo
      if(counter < 5'd15) begin
            counter <= counter + 1;
      end
      else begin
          gpib_reg <= gpib;
          counter <= 0;
          //led <={fifo[3:0],spi_mosi};
          led <= gpib_reg[4:0];
      end
   end

   always @ (posedge spi_clk)
   begin
      if(spi_cs_n == 0) begin
          //spi_miso<=fifo[7]; // loopback
          //spi_miso<=pmod[counter]; //logic analyzer
          spi_miso<=gpib_reg[counter]; //gpib logic analyzer
      end
   end

   reg blink = 0;
   reg [23:0] ctrl_led_blink_counter = 24'd0;
   always @ (posedge spi_clk)
   begin
      if(ctrl_led_blink_counter < 24'd10000000) begin
          ctrl_led_blink_counter <= ctrl_led_blink_counter + 1;
      end
      else begin
          ctrl_led_blink_counter <= 24'0;
      end

      if(ctrl_led_blink_counter < 24'd5000000) begin
          blink <= 0;
      end
      else begin
          blink <= ~spi_cs_n;
      end

   end

   always @ (posedge clk)
   begin
       if(spi_cs_n == 0) begin
           ctrl_led<=blink;
       end
       else begin
           ctrl_led<=0;
       end
   end
endmodule // top
