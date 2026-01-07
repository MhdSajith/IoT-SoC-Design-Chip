module iot_soc_top (
    input         clk,
    input         reset_n,
    output [7:0]  gpio_out,
    output        uart_tx
);

    wire [31:0] imem_addr, imem_rdata;
    wire [31:0] dmem_addr, dmem_wdata, dmem_rdata;
    wire        dmem_we;

    wire gpio_sel, uart_sel;
    wire [31:0] gpio_rdata;

    // ================= CPU =================
    cpu_core CPU (
        .clk(clk),
        .reset_n(reset_n),
        .imem_addr(imem_addr),
        .imem_rdata(imem_rdata),
        .dmem_addr(dmem_addr),
        .dmem_wdata(dmem_wdata),
        .dmem_we(dmem_we),
        .dmem_rdata(dmem_rdata)
    );

    // ============ Instruction Memory ============
    instr_mem IMEM (
        .addr(imem_addr),
        .rdata(imem_rdata)
    );

    // ================= APB BUS =================
    apb_bus BUS (
        .addr(dmem_addr),
        .gpio_sel(gpio_sel),
        .uart_sel(uart_sel)
    );

    // ================= GPIO =================
    gpio GPIO (
        .PCLK(clk),
        .PRESETn(reset_n),
        .PSEL(gpio_sel),
        .PWRITE(dmem_we),
        .PWDATA(dmem_wdata),
        .PRDATA(gpio_rdata),
        .gpio_out(gpio_out)
    );

    // ================= UART =================
    uart_tx UART (
        .clk(clk),
        .reset_n(reset_n),
        .tx_start(uart_sel && dmem_we),
        .tx_data(dmem_wdata[7:0]),
        .tx(uart_tx),
        .busy()
    );

    // Read data mux (only GPIO read supported)
    assign dmem_rdata = gpio_sel ? gpio_rdata : 32'h0;

endmodule
