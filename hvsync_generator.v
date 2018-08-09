module hvsync_generator(
    input clk,
    output vga_h_sync,
    output vga_v_sync,
    output reg inDisplayArea,
    output reg zerar,
    output reg frame_imagem,
    output reg [9:0] contadorX,
    output reg [8:0] contadorY
  );
  
    reg vga_HS, vga_VS;

    wire fim_frame_x = (contadorX == 800); // 16 + 48 + 96 + 640
    wire fim_frame_y = (contadorY == 525); // 10 + 2 + 33 + 480

    always @(posedge clk)
    if (fim_frame_x)
      contadorX <= 0;
    else
      contadorX <= contadorX + 1;

    always @(posedge clk)
    begin
      if (fim_frame_x)
      begin
        if(fim_frame_y)
          contadorY <= 0;
        else
          contadorY <= contadorY + 1;
      end
    end

    always @(posedge clk)
    begin
      vga_HS <= (contadorX > (640 + 16) && (contadorX < (640 + 16 + 96)));   // active for 96 clocks
      vga_VS <= (contadorY > (480 + 10) && (contadorY < (480 + 10 + 2)));   // active for 2 clocks
    end

    always @(posedge clk)
    begin
        frame_imagem <= contadorX >= 100 && contadorX < 164 && contadorY >= 100 && contadorY < 164;
        zerar  <= (contadorX >= 164 && contadorY >= 163);
        inDisplayArea <= (contadorX < 640) && (contadorY < 480);
    end

    assign vga_h_sync = ~vga_HS;
    assign vga_v_sync = ~vga_VS;

endmodule