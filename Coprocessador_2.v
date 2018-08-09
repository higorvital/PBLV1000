module Coprocessador_2(
    input clock_50MHz,
    input [7:0] q,
    input enable_start,
    output reg pixel,
    output reg [11:0] rdaddress,
    output reg [11:0] wraddress,
    output reg enable,
    output ACABOU
);

    reg [9:0] dado_1;
    reg [9:0] dado_2;
    reg [9:0] dado_final;
    reg [7:0] vizinho [0:5];
    reg [2:0] index_vizinho = 0;
    reg [11:0] contador = 65;
    reg [11:0] linhaatual = 126;
    reg [11:0] posvizinho = 1;
    reg [4:0] state = VIZINHO;
    reg fim = 0;

    assign ACABOU = fim;

    parameter [4:0]  VIZINHO = 5'h0,
                    CALCULAR_1 = 5'h1,
                    CALCULAR_2 = 5'h2,
                    CALCULAR_3 = 5'h3,
                    MANDAR_PIXEL = 5'h4,
                    FIM = 5'hff;

    always @(posedge clock_50MHz) begin
        case(state)
            VIZINHO: 
                begin
                    if(enable_start) begin

                        vizinho[index_vizinho] <= q;

                        if(index_vizinho==0) begin
                            posvizinho <= contador - 63;
                        end else if(index_vizinho==1) begin
                            posvizinho <= contador - 1;
                        end else if(index_vizinho==2) begin
                            posvizinho <= contador + 1;
                        end else if(index_vizinho==3) begin
                            posvizinho <= contador + 63;
                        end else if(index_vizinho==4) begin
                            posvizinho <= contador + 64;
                        end else if(index_vizinho==5) begin
                            posvizinho <= contador - 64;
                        end

                        if(index_vizinho>=5) begin
                            index_vizinho <= 0;
                            state <= CALCULAR_1;
                        end else begin
                            index_vizinho <= index_vizinho + 1;
                            state <= VIZINHO;
                        end
                    end else begin
                        state <= VIZINHO;
                    end
                end 
            CALCULAR_1:
                begin

                    if(vizinho[0]>=128) begin
                        vizinho[0] <= 8'b11111111;
                    end else begin
                        vizinho[0] <= vizinho[0] << 1;
                    end

                    if(vizinho[1]>=128) begin
                        vizinho[1] <= 8'b11111111;
                    end else begin
                        vizinho[1] <= vizinho[1] << 1;
                    end 

                    if(vizinho[2]>=128) begin
                        vizinho[2] <= 8'b11111111;
                    end else begin
                        vizinho[2] <= vizinho[2] << 1;
                    end 

                    if(vizinho[3]>=128) begin
                        vizinho[3] <= 8'b11111111;
                    end else begin
                        vizinho[3] <= vizinho[3] << 1;
                    end 

                    if(vizinho[4]>=128) begin
                        vizinho[4] <= 8'b11111111;
                    end else begin
                        vizinho[4] <= vizinho[4] << 1;
                    end 

                    if(vizinho[5]>=128) begin
                        vizinho[5] <= 8'b11111111;
                    end else begin
                        vizinho[5] <= vizinho[5] << 1;
                    end

                    state <= CALCULAR_2;

                end
            CALCULAR_2:
                begin
                    dado_1 = vizinho[0] + vizinho[1] + vizinho[3];
                    dado_2 = vizinho[2] + vizinho[4] + vizinho[5];
                    state <= CALCULAR_3;
                end
            CALCULAR_3:
                begin
                    if(dado_2>dado_1) begin
                        dado_final <=0;
                    end else begin
                        dado_final <= dado_1 - dado_2;
                    end
                    state <= MANDAR_PIXEL;
                end
            MANDAR_PIXEL:
                begin
                    if(contador < 4030) begin
                        if(contador==linhaatual) begin
                            contador <= contador + 3;
                            linhaatual <= linhaatual + 64;
                        end else begin
                            contador <= contador + 1;
                        end
                        state <= VIZINHO;
                    end else begin
                        contador <= 0;
                        state <= FIM;
                    end
                end
        endcase
    end

    always @(state) begin
        case(state)
            VIZINHO:
                begin
                    rdaddress <= posvizinho;
                    enable <= 1;
                end
            CALCULAR_1:
                begin

                end
            CALCULAR_2:
                begin

                end
            CALCULAR_3:
                begin

                end
            MANDAR_PIXEL:
                begin
                    if(dado_final>127) begin
                        pixel <= 1;
                    end else begin
                        pixel <= 0;
                    end
                    wraddress <= contador;
                    enable <= 1;
                end
            FIM: 
                begin
                    enable <= 0;
                    fim <= 1;
                end
        endcase
    end

endmodule