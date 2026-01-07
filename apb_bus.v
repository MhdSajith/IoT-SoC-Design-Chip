module apb_bus (
    input  [31:0] addr,
    output        gpio_sel,
    output        uart_sel
);

    assign gpio_sel = (addr[15:8] == 8'h01); // 0x0100
    assign uart_sel = (addr[15:8] == 8'h02); // 0x0200

endmodule
