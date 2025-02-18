module lpffir_axis (
                    input               aclk_i,
                    input               aresetn_i,
                    // AXI-Stream RX interface
                    input               rx_tlast_i,
                    input               rx_tvalid_i,
                    output logic        rx_tready_o,
                    input [15:0]        rx_tdata_i,
                    // AXI-Stream TX interface
                    output logic        tx_tlast_o,
                    output reg          tx_tvalid_o,
                    input               tx_tready_i,
                    output logic [15:0] tx_tdata_o);

   wire lpffir_en;
   reg misc;
   assign                                lpffir_en = rx_tvalid_i && tx_tready_i;

   // AXI-Stream interface
   assign rx_tready_o = lpffir_en;
   assign tx_tvalid_o = lpffir_en;
   assign tx_tlast_o  = rx_tlast_i;

  // DEBUG
  always @(posedge aclk_i or negedge aresetn_i)
    if (!aresetn_i) 
	  misc <= '0;

   // LPFFIR
   lpffir_core core(
                           .clk_i(aclk_i),
                           .rstn_i(aresetn_i),
                           .en_i(lpffir_en),
                           .x_i(rx_tdata_i),
                           .y_o(tx_tdata_o));
						   
						   
						   
						   
property stable_input;
	@(posedge aclk_i) disable iff (!aresetn_i) (!($isunknown(rx_tdata_i)));
endproperty
a_stable_input: assert property(stable_input) else $display("ASSEETION FAILED stable_input");
c_stable_input: cover property(stable_input) $display("COVER stable_input");


property stable_enable;
	@(posedge aclk_i) disable iff (!aresetn_i) (!($isunknown(lpffir_en)));
endproperty
a_stable_enable: assert property(stable_enable) else $display("ASSEETION FAILED stable_enable");
c_stable_enable: cover property(stable_enable) $display("COVER stable_enable");

property stable_ready;
	@(posedge aclk_i) disable iff (!aresetn_i) (!($isunknown(rx_tready_o)));
endproperty
a_stable_ready: assert property(stable_ready) else $display("ASSEETION FAILED sstable_ready");
c_stable_ready: cover property(stable_ready) $display("COVER sstable_ready");

property stable_valid;
	@(posedge aclk_i) disable iff (!aresetn_i) (!($isunknown(tx_tvalid_o)));
endproperty
a_stable_valid: assert property(stable_valid) else $display("ASSEETION FAILED stable_valid");
c_stable_valid: cover property(stable_valid) $display("COVER stable_valid");

property stable_last;
	@(posedge aclk_i) disable iff (!aresetn_i) (!($isunknown(tx_tlast_o )));
endproperty
a_stable_last: assert property(stable_last) else $display("ASSEETION FAILED stable_last");
c_stable_last: cover property(stable_last) $display("COVER stable_last");


/*property enable;
	@(posedge aclk_i) disable iff (!aresetn_i) (!($isunknown(lpffir_en))) |-> (lpffir_en == rx_tvalid_i && tx_tready_i);
endproperty
a_enable: assert property(enable) else $display("ASSEETION FAILED ENABLE");
c_enable: cover property(enable) $display("COVER ENABLE");*/

property ready;
	@(posedge aclk_i) disable iff (!aresetn_i) (($isunknown(lpffir_en))=='0) |-> (rx_tready_o == lpffir_en);
endproperty
a_ready: assert property(ready) else $display("ASSEETION FAILED READY");
c_ready: cover property(ready) $display("COVER READY");


property valid;
	@(posedge aclk_i) disable iff (!aresetn_i) (($isunknown(lpffir_en))=='0) |-> (tx_tvalid_o == lpffir_en);
endproperty
a_valid: assert property(valid) else $display("ASSEETION FAILED VALID");
c_valid: cover property(valid) $display("COVER VALID");

property last;
	@(posedge aclk_i) disable iff (!aresetn_i) (($isunknown(rx_tlast_i))=='0) |-> (tx_tlast_o == rx_tlast_i);
endproperty
a_last: assert property(last) else $display("ASSEETION FAILED LAST");
c_last: cover property(last) $display("COVER LAST");


endmodule






module lpffir_core (
                    input               clk_i,
                    input               rstn_i,
                    input               en_i,
                    input [15:0]        x_i,
                    output logic [15:0] y_o
                    );

   reg [15:0]                           x1;
   reg [15:0]                           x2;
   reg [15:0]                           x3;
   reg [15:0]                           x4;
   reg [15:0]                           x5;

   logic [15:0]                         h0;
   logic [15:0]                         h1;
   logic [15:0]                         h2;
   logic [15:0]                         h01;

   logic                                co0;
   logic                                co1;
   logic                                co2;
   logic                                co3;
   logic                                co4;

   // Linear-phase FIR structure
  rca rca_inst0 (.a(x_i),.b(x5),.ci(1'b0),.co(co0),.s(h0));
  rca rca_inst1 (.a(x1),.b(x4),.ci(1'b0),.co(co1),.s(h1));
  rca rca_inst2 (.a(x2),.b(x3),.ci(1'b0),.co(co2),.s(h2));
  rca rca_inst3 (.a(h0),.b(h1),.ci(1'b0),.co(co3),.s(h01));
  rca rca_inst4 (.a(h01),.b(h2),.ci(1'b0),.co(co4),.s(y_o));

   always_ff @(posedge clk_i or posedge rstn_i)
     if(!rstn_i)
       begin
          x1 <= 0;
          x2 <= 0;
          x3 <= 0;
          x4 <= 0;
          x5 <= 0;
       end
     else if (en_i)
       begin
          x1 <= x_i;
          x2 <= x1;
          x3 <= x2;
          x4 <= x3;
          x5 <= x4;
       end



property stable_x1;
	@(posedge clk_i) disable iff (!rstn_i) (!($isunknown(x1)));
endproperty
a_stable_x1: assert property(stable_x1) else $display("ASSEETION FAILED stable_x1");
c_stable_x1: cover property(stable_x1) $display("COVER stable_x1");

property stable_x2;
	@(posedge clk_i) disable iff (!rstn_i) (!($isunknown(x2)));
endproperty
a_stable_x2: assert property(stable_x2) else $display("ASSEETION FAILED stable_x2");
c_stable_x2: cover property(stable_x2) $display("COVER stable_x2");

property stable_x3;
	@(posedge clk_i) disable iff (!rstn_i) (!($isunknown(x3)));
endproperty
a_stable_x3: assert property(stable_x3) else $display("ASSEETION FAILED stable_x3");
c_stable_x3: cover property(stable_x3) $display("COVER stable_x3");

property stable_x4;
	@(posedge clk_i) disable iff (!rstn_i) (!($isunknown(x4)));
endproperty
a_stable_x4: assert property(stable_x4) else $display("ASSEETION FAILED stable_x4");
c_stable_x4: cover property(stable_x4) $display("COVER stable_x4");

property stable_x5;
	@(posedge clk_i) disable iff (!rstn_i) (!($isunknown(x5)));
endproperty
a_stable_x5: assert property(stable_x5) else $display("ASSEETION FAILED stable_x5");
c_stable_x5: cover property(stable_x5) $display("COVER stable_x5");

property stable_h0;
	@(posedge clk_i) disable iff (!rstn_i) (!($isunknown(h0)));
endproperty
a_stable_h0: assert property(stable_h0) else $display("ASSEETION FAILED stable_h0");
c_stable_h0: cover property(stable_h0) $display("COVER stable_h0");

property stable_h1;
	@(posedge clk_i) disable iff (!rstn_i) (!($isunknown(h1)));
endproperty
a_stable_h1: assert property(stable_h1) else $display("ASSEETION FAILED stable_h1");
c_stable_h1: cover property(stable_h1) $display("COVER stable_h1");

property stable_h2;
	@(posedge clk_i) disable iff (!rstn_i) (!($isunknown(h2)));
endproperty
a_stable_h2: assert property(stable_h2) else $display("ASSEETION FAILED stable_h2");
c_stable_h2: cover property(stable_h2) $display("COVER stable_h2");

property stable_h01;
	@(posedge clk_i) disable iff (!rstn_i) (!($isunknown(h01)));
endproperty
a_stable_h01: assert property(stable_h01) else $display("ASSEETION FAILED stable_h01");
c_stable_h01: cover property(stable_h01) $display("COVER stable_h01");

property res_h0;
	@(posedge clk_i) disable iff (!rstn_i) (!($isunknown(h0)))|-> (h0 == x5 + x_i);
endproperty
a_res_h0: assert property(res_h0) else $display("ASSEETION FAILED res_h0");
c_res_h0: cover property(res_h0) $display("COVER res_h0");

property res_h1;
	@(posedge clk_i) disable iff (!rstn_i) (!($isunknown(h0)))|-> (h1 == x1 + x4);
endproperty
a_res_h1: assert property(res_h1) else $display("ASSEETION FAILED res_h1");
c_res_h1: cover property(res_h1) $display("COVER res_h1");

property res_h2;
	@(posedge clk_i) disable iff (!rstn_i) (!($isunknown(h0)))|-> (h2 == x2 + x3);
endproperty
a_res_h2: assert property(res_h2) else $display("ASSEETION FAILED res_h2");
c_res_h2: cover property(res_h2) $display("COVER res_h2");

property res_h01;
	@(posedge clk_i) disable iff (!rstn_i) (!($isunknown(h0)))|-> (h01 == h0 + h1);
endproperty
a_res_h01: assert property(res_h01) else $display("ASSEETION FAILED res_h01");
c_res_h01: cover property(res_h01) $display("COVER res_h01");

property res_y0;
	@(posedge clk_i) disable iff (!rstn_i) (!($isunknown(y_o)))|-> (y_o == h01 + h2);
endproperty
a_res_y0: assert property(res_y0) else $display("ASSEETION FAILED res_y0");
c_res_y0: cover property(res_y0) $display("COVER res_y0");



endmodule

// Ripple Carry Adder: adds two 16-bit numbers
module rca(
           input [15:0]        a,
           input [15:0]        b,
           input               ci, // Carry Input

           output logic        co, // Carry Output
           output logic [15:0] s // Sum
           );
   
   logic [14:0]c;

   fa fa_inst0(.a(a[0]),.b(b[0]),.ci(ci),.co(c[0]),.s(s[0]));
   fa fa_inst1(.a(a[1]),.b(b[1]),.ci(c[0]),.co(c[1]),.s(s[1]));
   fa fa_inst2(.a(a[2]),.b(b[2]),.ci(c[1]),.co(c[2]),.s(s[2]));
   fa fa_inst3(.a(a[3]),.b(b[3]),.ci(c[2]),.co(c[3]),.s(s[3]));
   fa fa_inst4(.a(a[4]),.b(b[4]),.ci(c[3]),.co(c[4]),.s(s[4]));
   fa fa_inst5(.a(a[5]),.b(b[5]),.ci(c[4]),.co(c[5]),.s(s[5]));
   fa fa_inst6(.a(a[6]),.b(b[6]),.ci(c[5]),.co(c[6]),.s(s[6]));
   fa fa_inst7(.a(a[7]),.b(b[7]),.ci(c[6]),.co(c[7]),.s(s[7]));
   fa fa_inst8(.a(a[8]),.b(b[8]),.ci(c[7]),.co(c[8]),.s(s[8]));
   fa fa_inst9(.a(a[9]),.b(b[9]),.ci(c[8]),.co(c[9]),.s(s[9]));
   fa fa_inst10(.a(a[10]),.b(b[10]),.ci(c[9]),.co(c[10]),.s(s[10]));
   fa fa_inst11(.a(a[11]),.b(b[11]),.ci(c[10]),.co(c[11]),.s(s[11]));
   fa fa_inst12(.a(a[12]),.b(b[12]),.ci(c[11]),.co(c[12]),.s(s[12]));
   fa fa_inst13(.a(a[13]),.b(b[13]),.ci(c[12]),.co(c[13]),.s(s[13]));
   fa fa_inst14(.a(a[14]),.b(b[14]),.ci(c[13]),.co(c[14]),.s(s[14]));
   fa fa_inst15(.a(a[15]),.b(b[15]),.ci(c[14]),.co(co),.s(s[15]));
   

endmodule



module fa(
            input        a,
            input        b,
            input        ci, // Carry Input

            output logic co, // Carry Output
            output logic s // Sum
            );

   logic                 d,e,f;

   xor(s,a,b,ci);
   and(d,a,b);
   and(e,b,ci);
   and(f,a,ci);
   or(co,d,e,f);
endmodule