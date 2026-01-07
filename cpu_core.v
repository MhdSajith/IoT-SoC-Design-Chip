module cpu_core (
    input         clk,
    input         reset_n,
    output [31:0] imem_addr,
    input  [31:0] imem_rdata,
    output [31:0] dmem_addr,
    output [31:0] dmem_wdata,
    output        dmem_we,
    input  [31:0] dmem_rdata
);

    reg [31:0] pc;
    reg [31:0] regfile [0:31];

    wire [6:0] opcode = imem_rdata[6:0];

    assign imem_addr  = pc;
    assign dmem_addr  = regfile[1];   // base address
    assign dmem_wdata = regfile[2];   // data
    assign dmem_we    = (opcode == 7'b0100011); // STORE

    integer i;
    always @(posedge clk or negedge reset_n) begin
        if(!reset_n) begin
            pc <= 0;
            for(i=0;i<32;i=i+1)
                regfile[i] <= 0;
        end else begin
            pc <= pc + 4;
        end
    end

endmodule
