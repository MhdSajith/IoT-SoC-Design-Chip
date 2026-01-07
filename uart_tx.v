module uart_tx (
    input         clk,
    input         reset_n,
    input         tx_start,
    input  [7:0]  tx_data,
    output        tx,
    output        busy
);

    reg [9:0] shift;
    reg [3:0] count;
    reg       active;

    assign tx   = active ? shift[0] : 1'b1;
    assign busy = active;

    always @(posedge clk or negedge reset_n) begin
        if(!reset_n) begin
            active <= 0;
        end else begin
            if(tx_start && !active) begin
                shift  <= {1'b1, tx_data, 1'b0}; // stop + data + start
                count  <= 10;
                active <= 1;
            end else if(active) begin
                shift <= shift >> 1;
                count <= count - 1;
                if(count == 1)
                    active <= 0;
            end
        end
    end

endmodule
