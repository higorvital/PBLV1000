module Coprocessador1(
    input clock_50MHz,
    input [31:0] pixel_export,
    input novodado,
    output dadorecebido,
    output reg data,
    output reg [11:0] wraddress
);

    wire inDisplayArea;
    reg clock = 0;
    wire hsync;
    wire vsync;
    reg [3:0] r;
    reg [3:0] g;
    reg [3:0] b;

    reg [3:0] imagem [0:1023];
    reg [11:0] contadorX = 0;
    reg recebido = 0;
    reg enable = 0;
    reg [1:0] state = NOVO_DADO;
    reg [11:0] linhaatual = 65;
    reg [5:0] dado;

    assign dadorecebido = recebido;
    assign VGA_HS = hsync;
    assign VGA_VS = vsync;
    assign VGA_R = r;
    assign VGA_G = g;
    assign VGA_B = b;


    parameter [2:0] NOVO_DADO = 3'h0,
                    DADO_RECEBIDO = 3'h1,
                    CALCULAR = 3'h2,
                    MANDAR = 3'h3,
                    FIM = 3'h4;

    always @(posedge clock_50MHz) begin
        case(state)
            NOVO_DADO: 
                begin
                    if(novodado) begin
                        if(pixel_export[31:24]>=0 && pixel_export[31:24]<16) begin
                            imagem[contadorX] <= 4'b0000;
                        end else if(pixel_export[31:24]>=16 && pixel_export[31:24]<32) begin
                            imagem[contadorX] <= 4'b0001;
                        end else if(pixel_export[31:24]>=32 && pixel_export[31:24]<48) begin
                            imagem[contadorX] <= 4'b0010;
                        end else if(pixel_export[31:24]>=48 && pixel_export[31:24]<64) begin
                            imagem[contadorX] <= 4'b0011;
                        end else if(pixel_export[31:24]>=64 && pixel_export[31:24]<80) begin
                            imagem[contadorX] <= 4'b0100;
                        end else if(pixel_export[31:24]>=80 && pixel_export[31:24]<96) begin
                            imagem[contadorX] <= 4'b0101;
                        end else if(pixel_export[31:24]>96 && pixel_export[31:24]<112) begin
                            imagem[contadorX] <= 4'b0110;
                        end else if(pixel_export[31:24]>=112 && pixel_export[31:24]<128) begin
                            imagem[contadorX] <= 4'b0111;
                        end else if(pixel_export[31:24]>=128 && pixel_export[31:24]<144) begin
                            imagem[contadorX] <= 4'b1000;
                        end else if(pixel_export[31:24]>=144 && pixel_export[31:24]<160) begin
                            imagem[contadorX] <= 4'b1001;
                        end else if(pixel_export[31:24]>=160 && pixel_export[31:24]<176) begin
                            imagem[contadorX] <= 4'b1010;
                        end else if(pixel_export[31:24]>=176 && pixel_export[31:24]<192) begin
                            imagem[contadorX] <= 4'b1011;
                        end else if(pixel_export[31:24]>=192 && pixel_export[31:24]<208) begin
                            imagem[contadorX] <= 4'b1100;
                        end else if(pixel_export[31:24]>=208 && pixel_export[31:24]<224) begin
                            imagem[contadorX] <= 4'b1101;
                        end else if(pixel_export[31:24]>=224 && pixel_export[31:24]<240) begin
                            imagem[contadorX] <= 4'b1110;
                        end else if(pixel_export[31:24]>=240 && pixel_export[31:24]<256) begin
                            imagem[contadorX] <= 4'b1111;
                        end

                        if(pixel_export[23:16]>=0 && pixel_export[31:24]<16) begin
                            imagem[contadorX+1] <= 4'b0000;
                        end else if(pixel_export[23:16]>=16 && pixel_export[31:24]<32) begin
                            imagem[contadorX+1] <= 4'b0001;
                        end else if(pixel_export[23:16]>=32 && pixel_export[31:24]<48) begin
                            imagem[contadorX+1] <= 4'b0010;
                        end else if(pixel_export[23:16]>=48 && pixel_export[31:24]<64) begin
                            imagem[contadorX+1] <= 4'b0011;
                        end else if(pixel_export[23:16]>=64 && pixel_export[31:24]<80) begin
                            imagem[contadorX+1] <= 4'b0100;
                        end else if(pixel_export[23:16]>=80 && pixel_export[31:24]<96) begin
                            imagem[contadorX+1] <= 4'b0101;
                        end else if(pixel_export[23:16]>96 && pixel_export[31:24]<112) begin
                            imagem[contadorX+1] <= 4'b0110;
                        end else if(pixel_export[23:16]>=112 && pixel_export[31:24]<128) begin
                            imagem[contadorX+1] <= 4'b0111;
                        end else if(pixel_export[23:16]>=128 && pixel_export[31:24]<144) begin
                            imagem[contadorX+1] <= 4'b1000;
                        end else if(pixel_export[23:16]>=144 && pixel_export[31:24]<160) begin
                            imagem[contadorX+1] <= 4'b1001;
                        end else if(pixel_export[23:16]>=160 && pixel_export[31:24]<176) begin
                            imagem[contadorX+1] <= 4'b1010;
                        end else if(pixel_export[23:16]>=176 && pixel_export[31:24]<192) begin
                            imagem[contadorX+1] <= 4'b1011;
                        end else if(pixel_export[23:16]>=192 && pixel_export[31:24]<208) begin
                            imagem[contadorX+1] <= 4'b1100;
                        end else if(pixel_export[23:16]>=208 && pixel_export[31:24]<224) begin
                            imagem[contadorX+1] <= 4'b1101;
                        end else if(pixel_export[23:16]>=224 && pixel_export[31:24]<240) begin
                            imagem[contadorX+1] <= 4'b1110;
                        end else if(pixel_export[23:16]>=240 && pixel_export[31:24]<256) begin
                            imagem[contadorX+1] <= 4'b1111;
                        end

                        if(pixel_export[15:8]>=0 && pixel_export[31:24]<16) begin
                            imagem[contadorX+2] <= 4'b0000;
                        end else if(pixel_export[15:8]>=16 && pixel_export[31:24]<32) begin
                            imagem[contadorX+2] <= 4'b0001;
                        end else if(pixel_export[15:8]>=32 && pixel_export[31:24]<48) begin
                            imagem[contadorX+2] <= 4'b0010;
                        end else if(pixel_export[15:8]>=48 && pixel_export[31:24]<64) begin
                            imagem[contadorX+2] <= 4'b0011;
                        end else if(pixel_export[15:8]>=64 && pixel_export[31:24]<80) begin
                            imagem[contadorX+2] <= 4'b0100;
                        end else if(pixel_export[15:8]>=80 && pixel_export[31:24]<96) begin
                            imagem[contadorX+2] <= 4'b0101;
                        end else if(pixel_export[15:8]>96 && pixel_export[31:24]<112) begin
                            imagem[contadorX+2] <= 4'b0110;
                        end else if(pixel_export[15:8]>=112 && pixel_export[31:24]<128) begin
                            imagem[contadorX+2] <= 4'b0111;
                        end else if(pixel_export[15:8]>=128 && pixel_export[31:24]<144) begin
                            imagem[contadorX+2] <= 4'b1000;
                        end else if(pixel_export[15:8]>=144 && pixel_export[31:24]<160) begin
                            imagem[contadorX+2] <= 4'b1001;
                        end else if(pixel_export[15:8]>=160 && pixel_export[31:24]<176) begin
                            imagem[contadorX+2] <= 4'b1010;
                        end else if(pixel_export[15:8]>=176 && pixel_export[31:24]<192) begin
                            imagem[contadorX+2] <= 4'b1011;
                        end else if(pixel_export[15:8]>=192 && pixel_export[31:24]<208) begin
                            imagem[contadorX+2] <= 4'b1100;
                        end else if(pixel_export[15:8]>=208 && pixel_export[31:24]<224) begin
                            imagem[contadorX+2] <= 4'b1101;
                        end else if(pixel_export[15:8]>=224 && pixel_export[31:24]<240) begin
                            imagem[contadorX+2] <= 4'b1110;
                        end else if(pixel_export[15:8]>=240 && pixel_export[31:24]<256) begin
                            imagem[contadorX+2] <= 4'b1111;
                        end

                        if(pixel_export[7:0]>=0 && pixel_export[31:24]<16) begin
                            imagem[contadorX+3] <= 4'b0000;
                        end else if(pixel_export[7:0]>=16 && pixel_export[31:24]<32) begin
                            imagem[contadorX+3] <= 4'b0001;
                        end else if(pixel_export[7:0]>=32 && pixel_export[31:24]<48) begin
                            imagem[contadorX+3] <= 4'b0010;
                        end else if(pixel_export[7:0]>=48 && pixel_export[31:24]<64) begin
                            imagem[contadorX+3] <= 4'b0011;
                        end else if(pixel_export[7:0]>=64 && pixel_export[31:24]<80) begin
                            imagem[contadorX+3] <= 4'b0100;
                        end else if(pixel_export[7:0]>=80 && pixel_export[31:24]<96) begin
                            imagem[contadorX+3] <= 4'b0101;
                        end else if(pixel_export[7:0]>96 && pixel_export[31:24]<112) begin
                            imagem[contadorX+3] <= 4'b0110;
                        end else if(pixel_export[7:0]>=112 && pixel_export[31:24]<128) begin
                            imagem[contadorX+3] <= 4'b0111;
                        end else if(pixel_export[7:0]>=128 && pixel_export[31:24]<144) begin
                            imagem[contadorX+3] <= 4'b1000;
                        end else if(pixel_export[7:0]>=144 && pixel_export[31:24]<160) begin
                            imagem[contadorX+3] <= 4'b1001;
                        end else if(pixel_export[7:0]>=160 && pixel_export[31:24]<176) begin
                            imagem[contadorX+3] <= 4'b1010;
                        end else if(pixel_export[7:0]>=176 && pixel_export[31:24]<192) begin
                            imagem[contadorX+3] <= 4'b1011;
                        end else if(pixel_export[7:0]>=192 && pixel_export[31:24]<208) begin
                            imagem[contadorX+3] <= 4'b1100;
                        end else if(pixel_export[7:0]>=208 && pixel_export[31:24]<224) begin
                            imagem[contadorX+3] <= 4'b1101;
                        end else if(pixel_export[7:0]>=224 && pixel_export[31:24]<240) begin
                            imagem[contadorX+3] <= 4'b1110;
                        end else if(pixel_export[7:0]>=240 && pixel_export[31:24]<256) begin
                            imagem[contadorX+3] <= 4'b1111;
                        end

                        contadorX <= contadorX + 4;

                        state <= DADO_RECEBIDO;
                    end else begin
                        state <= NOVO_DADO;
                    end
                end 
            DADO_RECEBIDO:
                begin
                    if(contadorX>=1023) begin
                       contadorX <= 65;
                       state <= CALCULAR;
                    end else if(~novodado)begin
                       state <= NOVO_DADO; 
                    end else begin
                        state <= DADO_RECEBIDO;
                    end
                end
            CALCULAR:
                begin
                    if(contadorX>=895) begin
                        imagem[0:127] <= imagem[896:1023];
                        contadorX <= 128;
                        state <= NOVO_DADO;
                    end else begin
                        dado <= (imagem[contadorX-64] << 1) + (imagem[contadorX-63] << 1) - (imagem[contadorX-1] << 1) + (imagem[contadorX+1] << 1) - (imagem[contadorX+63] << 1) - (imagem[contadorX+64] << 1);

                        if(contadorX==linhaatual) begin
                            contadorX <= contadorX + 3;
                            linhaatual <= linhaatual + 65;
                        end else begin
                            contadorX <= contadorX + 1;
                        end
                        state <= CALCULAR;
                    end

                end
        endcase
    end

    always @(state) begin
        case(state)
            NOVO_DADO: recebido<=0;
            DADO_RECEBIDO: recebido<=1;
            CALCULAR:
                begin
                    recebido<=0;
                    
                    if(dado>7) begin
                        data<=1'b1;
                    end else if (dado<=7)begin
                        data<= 1'b0;
                    end

                    wraddress <= contadorX;
                    
                end
        endcase
    end



endmodule