    module Escrever(
        input clock_50MHz,
        output reg pixel,
        output reg [11:0] wraddress,
        output reg enable,
        output ACABOU
    );
        reg [11:0] contador = 0;
        reg [1:0] state = MANDAR_PIXEL;
        reg fim = 0;

        assign ACABOU = fim;

        parameter [1:0]  
                        MANDAR_PIXEL = 2'h0,
                        FIM = 2'h1;

        always @(posedge clock_50MHz) begin
            case(state)
                MANDAR_PIXEL:
                    begin
                        if(contador<4095) begin
                            contador <= contador + 1;
                            state <= MANDAR_PIXEL;
                        end else begin
                            contador <= 0;
                            state <= FIM;
                        end
                    end
                FIM:
                    begin

                    end
            endcase
        end

        always @(state) begin
            case(state)
                MANDAR_PIXEL:
                    begin
                         pixel <= 1;
                         enable <= 1;
                         fim <= 0;
                         wraddress <= contador;
                    end
                FIM: 
                    begin
                        pixel<=0;
                        enable <= 0;
                        fim <= 1;
                    end
            endcase
        end

    endmodule