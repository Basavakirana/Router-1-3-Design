module router_fifo(clk,rstn,soft_rst,we,re,din,lfd_state,data_out,empty,full);
parameter depth=16,width=9,addr_bus_width=5;
input clk,rstn,soft_rst,we,re,lfd_state;
input[width-2:0]din;
output reg[width-2:0]data_out;
output full,empty;
reg[addr_bus_width-1:0]wr_pt,rd_pt;
reg fifo_counter;
reg lfd_state_s;
reg[width-1:0]mem[depth-1:0];
integer i;
always@(posedge clk)
begin
        if(~rstn)
                lfd_state_s=1'b0;
        else
                lfd_state_s=lfd_state;
end

always@(posedge clk)
begin
        if(!rstn)
        begin
                for(i=0;i<16;i=i+1) begin
                        mem[i]<=0;
                end
        end
        else if(soft_rst)
        begin
                for(i=0;i<16;i=i+1) begin
                        mem[i]<=0;
                end
        end
        else
        begin
                if(we && !full)
                mem[wr_pt][8]<={lfd_state,din};
end
end
always@(posedge clk)
begin
        if(!rstn)
        begin
                fifo_counter<=0;
        end
        else if(soft_rst)
        begin
                fifo_counter<=0;
        end
        else if(re & ~empty)
        begin
                if(mem[rd_pt[3:0]][8]==1'b1)
                        fifo_counter<=mem[rd_pt[3:0]][7:2]+1'b1;
                else if(fifo_counter!=0)
                        fifo_counter<=fifo_counter-1'b1;
        end
end
always@(posedge clk)
begin
        if(!rstn)
                data_out<=8'b00000000;
        else if(soft_rst)
                data_out<=8'bZZZZZZZZ;
/*      else
        begin
                if(fifo_counter==0 && data_out!=0)
                        data_out<=8'dZ;*/
                else if(re && !empty)
                        data_out<=mem[rd_pt[3:0]];
//      end
end
always@(posedge clk)
begin
        if(!rstn)
        begin
                rd_pt<=5'b00000;
                wr_pt<=5'b00000;
        end
        else if(soft_rst)
        begin
                rd_pt<=5'b00000;
                wr_pt<=5'b00000;
        end
        else
        begin
                if(!full && we)
                        wr_pt<=wr_pt+1;
                else
                        wr_pt<=wr_pt;
                if(!empty && re)
                        rd_pt<=rd_pt+1;
                else
                        rd_pt<=rd_pt;
        end
end
assign full=(wr_pt=={~rd_pt[4],rd_pt[3:0]})?1'b1:1'b0;
assign empty=(wr_pt==rd_pt)?1'b1:1'b0;
endmodule

