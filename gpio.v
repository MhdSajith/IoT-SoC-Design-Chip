module gpio (
    input         PCLK,
    input         PRESETn,
    input         PSEL,
    input         PWRITE,
    input  [31:0] PWDATA,
    output [31:0] PRDATA,
    output [7:0]  gpio_out
);

    reg [7:0] gpio_reg;

    assign gpio_out = gpio_reg;
    assign PRDATA   = {24'h0, gpio_reg};

    always @(posedge PCLK or negedge PRESETn) begin
        if(!PRESETn)
            gpio_reg <= 8'h00;
        else if(PSEL && PWRITE)
            gpio_reg <= PWDATA[7:0];
    end

endmodule
