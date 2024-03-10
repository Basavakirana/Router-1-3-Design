module router_synchronizer_tb();
reg detect_addr,write_enb_reg,clk,rstn;
reg[1:0]din;
reg re_0,re_1,re_2;
reg empty_0,empty_1,empty_2;
reg full_0,full_1,full_2;
wire fifo_full;
wire valid_out_0,valid_out_1,valid_out_2;
wire soft_rst_0,soft_rst_1,soft_rst_2;
wire [2:0]we;
parameter cycle=10;
router_synchronizer DUT(detect_addr,write_enb_reg,clk,rstn,din,re_0,re_1,re_2,empty_0,empty_1,empty_2,full_0,full_1,full_2,fifo_full,we,soft_rst_0,soft_rst_1,soft_rst_2,valid_out_0,valid_out_1,valid_out_2);
always
begin
        #(cycle/2);
        clk=1'b0;
        #(cycle/2);
        clk=1'b1;
end
task rst_dut();
        begin
                @(negedge clk);
                rstn=1'b0;
                @(negedge clk);
                rstn=1'b1;
        end
endtask
task initialize;
        begin
                detect_addr=1'b0;
                din=2'b00;
                write_enb_reg=1'b0;
                {empty_0,empty_1,empty_2}=3'b111;
                {full_0,full_1,full_2}=3'b000;
                {re_0,re_1,re_2}=3'b000;
        end
endtask
task addr(input[1:0]m);
        begin
                @(negedge clk);
                detect_addr=1'b1;
                @(negedge clk);
                detect_addr=1'b0;
        end
endtask
task write;
        begin
                @(negedge clk);
                write_enb_reg=1;
                @(negedge clk);
                write_enb_reg=0;
        end
endtask
task stimulus;
        begin
                @(negedge clk);
                {full_0,full_1,full_2}=3'b001;
                @(negedge clk);
                {re_0,re_1,re_2}=3'b001;
                @(negedge clk);
                {empty_0,empty_1,empty_2}=3'b110;
        end
endtask
initial
begin
        initialize;
        rst_dut;
        addr(2'b10);
        stimulus;
        #500;
        $finish;
end
endmodule
