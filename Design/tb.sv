module testbench;

reg               aclk_i = '1;
reg               aresetn_i;
    // AXI-Stream RX interface
reg               rx_tlast_i;
reg               rx_tvalid_i;
wire              rx_tready_o;
reg         [15:0]rx_tdata_i;
    // AXI-Stream TX interface
wire       		  tx_tlast_o;
wire          	  tx_tvalid_o;
reg               tx_tready_i;
wire 	    [15:0]tx_tdata_o;
longint clk_count = 0;

lpffir_axis LPFFIR (.aclk_i(aclk_i), .aresetn_i(aresetn_i), .rx_tlast_i(rx_tlast_i), .rx_tvalid_i(rx_tvalid_i), .rx_tready_o(rx_tready_o), .rx_tdata_i(rx_tdata_i), .tx_tlast_o(tx_tlast_o), .tx_tvalid_o(tx_tvalid_o), .tx_tready_i(tx_tready_i), .tx_tdata_o(tx_tdata_o));


initial
begin
	forever #5 aclk_i = ~aclk_i;
end


always@(posedge aclk_i)
begin
	clk_count = clk_count+1;
end

initial
begin

    // Initialize signals
    aresetn_i   = 0;
    rx_tlast_i  = 0;
    rx_tvalid_i = 0;
    rx_tdata_i  = 0;
    tx_tready_i = 1; // Always ready to accept data

    // Reset the design
    #20;
    aresetn_i = 1;
	$display("reset done");
    // Apply input samples and observe the results
    //$display("Time: %0t | rx_tdata_i | tx_tdata_o", $time);

    for (int i = 0; i < 101; i++)
	begin
		@(posedge aclk_i)
		rx_tvalid_i = 1;
		rx_tdata_i  = $urandom;
		rx_tlast_i  = 0;
		#2 check(rx_tlast_i, rx_tvalid_i, rx_tdata_i, tx_tready_i);
	end
	@(posedge aclk_i);
	rx_tvalid_i = 0;
    rx_tlast_i  = 0;
    @(posedge aclk_i);
	
    // Wait for results to propagate
    repeat (10) @(posedge aclk_i);
    $finish;
  end

  // Monitor output data
  initial begin
      $monitor("Time: %0t	| Clock Count: %0d | Input: %0d | x1: %0d | x2: %0d | x3: %0d | x4: %0d | x5: %0d | h0: %0d	| h1: %0d | h2: %0d	| h01: %0d | Output: %0d", $time, clk_count, rx_tdata_i, LPFFIR.core.x1, LPFFIR.core.x2, LPFFIR.core.x3, LPFFIR.core.x4, LPFFIR.core.x5, LPFFIR.core.h0, LPFFIR.core.h1, LPFFIR.core.h2, LPFFIR.core.h01, tx_tdata_o);
  end
  
  function static check(tlast_i, tvalid_i, [15:0]tdata, ready_i);
  
  logic [15:0]sdata[0:5];
  static int init_flag = 1;
  static int save_pnt = 5;  
  
  logic [15:0]ref_value;
  
  if (tvalid_i && ready_i) 
  begin
	if ((rx_tready_o === '1	&&	tx_tvalid_o === '1) )
	begin
		//$display("Time: %0t	| Clock Count: %0d | Input: %0d |	CONTROL SIGNALS PASSED	|	rx_tready_o:	%0d	|	tx_tvalid_o: %0d", $time, clk_count, rx_tdata_i, LPFFIR.rx_tready_o,	LPFFIR.tx_tvalid_o );
	end
	else
	begin
		$display("Time: %0t	| Clock Count: %0d | Input: %0d |	CONTROL SIGNALS ERROR	|	rx_tready_o:	%0d	|	tx_tvalid_o: %0d", $time, clk_count, rx_tdata_i, LPFFIR.rx_tready_o,	LPFFIR.tx_tvalid_o );
	end	
  end
  
  
  if (init_flag == 1)
  begin
	init_flag = 0;
	foreach (sdata[j])
		sdata[j] = 0;
  end
	
	
  if (save_pnt > 5)
  begin 
	save_pnt = 0;
	//$display("tdata: %0d", tdata);
  	sdata[save_pnt] = tdata;
	//$display("sdata[%0d]: %0d", save_pnt, sdata[save_pnt]);
	save_pnt++;
    ref_value = sdata[0] + sdata[3] + sdata[1] + sdata[2] + sdata[4] + sdata[5];
  end
  else
  begin
    //$display("tdata: %0d", tdata);
  	sdata[save_pnt] = tdata;
	//$display("sdata[%0d]: %0d", save_pnt, sdata[save_pnt]);
	save_pnt++;
    ref_value = sdata[0] + sdata[3] + sdata[1] + sdata[2] + sdata[4] + sdata[5];
  end

  if (tx_tdata_o === ref_value)
  begin
	//$display("Stored data values: %0d %0d %0d %0d %0d %0d", sdata[0], sdata[1], sdata[2], sdata[3], sdata[4], sdata[5]);
    //$display("Time: %0t	| Clock Count: %0d | Input: %0d |	DATA PASSED	| Output: %0d | ref_value = %0d	", $time, clk_count, rx_tdata_i, tx_tdata_o, ref_value);
  end
  else 
  begin
    //$display("Stored data values: %0d %0d %0d %0d %0d %0d", sdata[0], sdata[1], sdata[2], sdata[3], sdata[4], sdata[5]);
    $display("Time: %0t	| Clock Count: %0d | Input: %0d |	DATA FAILED	| Output: %0d | ref_value = %0d	", $time, clk_count, rx_tdata_i, tx_tdata_o, ref_value);
  end
	
  endfunction

endmodule
























/*// Sample 1
    @(posedge aclk_i);
    rx_tvalid_i = 1;
    rx_tdata_i  = 16'd50;
    rx_tlast_i  = 0;
	#2 check(rx_tlast_i, rx_tvalid_i, rx_tdata_i, tx_tready_i);
	@(posedge aclk_i);
    
	// Sample 2
    rx_tdata_i  = 16'd60;
	#2 check(rx_tlast_i, rx_tvalid_i, rx_tdata_i, tx_tready_i);
    @(posedge aclk_i)

    // Sample 3
    rx_tdata_i  = 16'd70;
	#2 check(rx_tlast_i, rx_tvalid_i, rx_tdata_i, tx_tready_i);
    @(posedge aclk_i);

    // Sample 4
    rx_tdata_i  = 16'd80;
	#2 check(rx_tlast_i, rx_tvalid_i, rx_tdata_i, tx_tready_i);
    @(posedge aclk_i);

    // Sample 5
    rx_tdata_i  = 16'd90;
	#2 check(rx_tlast_i, rx_tvalid_i, rx_tdata_i, tx_tready_i);
    @(posedge aclk_i);

    // Sample 6
    rx_tdata_i  = 16'd100;
    rx_tlast_i  = 1;
	#2 check(rx_tlast_i, rx_tvalid_i, rx_tdata_i, tx_tready_i);
    @(posedge aclk_i);

    // Finish
    rx_tvalid_i = 0;
    rx_tlast_i  = 0;
    @(posedge aclk_i);*/
