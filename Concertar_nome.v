module Concertar_nome(
    input [7:0] data_export,
    input [11:0] wraddress_export,
    input wren_export,
    output [7:0] data,
    output [11:0] wraddress,
    output wren,
	 output enable
);

    assign data = data_export;
    assign wraddress = wraddress_export;
    assign wren = wren_export;
	 assign enable = enable_1;
	 wire enable_1 = (wraddress >= 4095) && (wren == 0);

endmodule