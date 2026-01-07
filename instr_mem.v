module instr_mem (
    input  [31:0] addr,
    output [31:0] rdata
);

    reg [31:0] mem [0:255];

    initial begin
        mem[0] = 32'h0020A023; // Example STORE instruction
    end

    assign rdata = mem[addr[9:2]];

endmodule
