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
   
   //assign {co,s} = a + b + ci;

endmodule