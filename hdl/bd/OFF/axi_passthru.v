
  // AXI4-FULL

	module axi_passthru #
	(
		parameter integer C_S_AXI_DATA_WIDTH	= 64,
		parameter integer C_S_AXI_ADDR_WIDTH	= 7
	)
	(
		input   aclk    , // n/c for vivado critical warnings
    input   aresetn , // n/c

  /******************** SLAVE ******************************/
    /* WR ADDR */
    input   wire [C_S_AXI_ADDR_WIDTH-1 : 0] 	  S_AXI_AWADDR    ,
    input   wire [7 : 0]                        S_AXI_AWLEN     ,   // fixed per AXI4 standard
    input   wire [2 : 0]                        S_AXI_AWSIZE    ,   // fixed per AXI4 standard
    input   wire [1 : 0]                        S_AXI_AWBURST   ,   // fixed per AXI4 standard
    input   wire [0 : 0]                        S_AXI_AWLOCK    ,   // fixed per AXI4 standard  N/A for AXI4
    input   wire [3 : 0]                        S_AXI_AWCACHE   ,   // fixed per AXI4 standard
		input   wire [2 : 0] 											  S_AXI_AWPROT    ,
		input   wire [3 : 0]                        S_AXI_AWQOS     ,   // fixed per AXI4 standard
    input   wire  														  S_AXI_AWVALID   ,
		output  wire  														  S_AXI_AWREADY   ,
		/* WR DATA */
    input   wire [C_S_AXI_DATA_WIDTH-1 : 0] 	  S_AXI_WDATA     ,
		input   wire [(C_S_AXI_DATA_WIDTH/8)-1 : 0] S_AXI_WSTRB     ,
    input   wire                                S_AXI_WLAST     ,
		input   wire  														  S_AXI_WVALID    ,
		output  wire  														  S_AXI_WREADY    ,
		/* WR RESPONSE */
    output  wire [1 : 0] 												S_AXI_BRESP     ,
		output  wire  														  S_AXI_BVALID    ,
		input   wire  														  S_AXI_BREADY    ,
		/* RD ADDR */
    input   wire [C_S_AXI_ADDR_WIDTH-1 : 0] 	  S_AXI_ARADDR    ,
		input   wire [7 : 0]                        S_AXI_ARLEN     ,     // fixed per AXI4 standard
    input   wire [2 : 0]                        S_AXI_ARSIZE    ,     // fixed per AXI4 standard  
    input   wire [1 : 0]                        S_AXI_ARBURST   ,     // fixed per AXI4 standard  
    input   wire [0 : 0]                        S_AXI_ARLOCK    ,     // fixed per AXI4 standard  N/A for AXI4  
    input   wire [3 : 0]                        S_AXI_ARCACHE   ,     // fixed per AXI4 standard  
    input   wire [2 : 0] 											  S_AXI_ARPROT    ,
		input   wire [3 : 0]                        S_AXI_ARQOS     ,     // fixed per AXI4 standard
    input   wire  														  S_AXI_ARVALID   ,
		output  wire  														  S_AXI_ARREADY   ,
		/* RD DATA */
    output  wire [C_S_AXI_DATA_WIDTH-1 : 0] 	  S_AXI_RDATA     ,
		output  wire [1 : 0] 												S_AXI_RRESP     ,
		output  wire                                S_AXI_RLAST     ,
    output  wire  														  S_AXI_RVALID    ,
		input   wire  														  S_AXI_RREADY    ,

  /*********************** MASTER *************************/
		output  wire [C_S_AXI_ADDR_WIDTH-1 : 0] 	  M_AXI_AWADDR    ,
    output  wire [7 : 0]                        M_AXI_AWLEN     ,  
    output  wire [2 : 0]                        M_AXI_AWSIZE    ,    
    output  wire [1 : 0]                        M_AXI_AWBURST   ,    
    output  wire [0 : 0]                        M_AXI_AWLOCK    ,    
    output  wire [3 : 0]                        M_AXI_AWCACHE   ,    
		output  wire [2 : 0] 												M_AXI_AWPROT    ,
		output  wire [3 : 0]                        M_AXI_AWQOS     ,
    output  wire  														  M_AXI_AWVALID   ,
		input   wire  														  M_AXI_AWREADY   ,
		
    output  wire [C_S_AXI_DATA_WIDTH-1 : 0] 	  M_AXI_WDATA     ,
		output  wire [(C_S_AXI_DATA_WIDTH/8)-1 : 0]	M_AXI_WSTRB     ,
    output  wire                                M_AXI_WLAST     ,
		output  wire  														  M_AXI_WVALID    ,
		input   wire  														  M_AXI_WREADY    ,
		
    input   wire [1 : 0] 											  M_AXI_BRESP     ,
		input   wire  														  M_AXI_BVALID    ,
		output  wire  														  M_AXI_BREADY    ,
		
    output  wire [C_S_AXI_ADDR_WIDTH-1 : 0] 	  M_AXI_ARADDR    ,
		output  wire [7 : 0]                        M_AXI_ARLEN     ,
    output  wire [2 : 0]                        M_AXI_ARSIZE    ,  
    output  wire [1 : 0]                        M_AXI_ARBURST   ,  
    output  wire [0 : 0]                        M_AXI_ARLOCK    ,  
    output  wire [3 : 0]                        M_AXI_ARCACHE   ,  
		output  wire [2 : 0] 												M_AXI_ARPROT    ,
    output  wire [3 : 0]                        M_AXI_ARQOS     ,
		output  wire  														  M_AXI_ARVALID   ,
		input   wire  														  M_AXI_ARREADY   ,
		
    input   wire [C_S_AXI_DATA_WIDTH-1 : 0] 	  M_AXI_RDATA     ,
		input   wire [1 : 0] 											  M_AXI_RRESP     ,
    input   wire                                M_AXI_RLAST     ,
		input   wire  														  M_AXI_RVALID    ,
		output  wire  														  M_AXI_RREADY
	);


  assign M_AXI_AWADDR   = S_AXI_AWADDR  ;
  assign M_AXI_AWLEN    = S_AXI_AWLEN   ;
  assign M_AXI_AWSIZE   = S_AXI_AWSIZE  ;
  assign M_AXI_AWBURST  = S_AXI_AWBURST ;  
  assign M_AXI_AWLOCK   = S_AXI_AWLOCK  ;
  assign M_AXI_AWCACHE  = S_AXI_AWCACHE ;  
  assign M_AXI_AWPROT   = S_AXI_AWPROT  ;
  assign M_AXI_AWQOS    = S_AXI_AWQOS   ;
  assign M_AXI_AWVALID  = S_AXI_AWVALID ;
  assign S_AXI_AWREADY  = M_AXI_AWREADY ;

  assign M_AXI_WDATA    = S_AXI_WDATA   ;
  assign M_AXI_WSTRB    = S_AXI_WSTRB   ;
  assign M_AXI_WLAST    = S_AXI_WLAST   ;
  assign M_AXI_WVALID   = S_AXI_WVALID  ;
  assign S_AXI_WREADY   = M_AXI_WREADY  ;

  assign S_AXI_BRESP    = M_AXI_BRESP   ;
  assign S_AXI_BVALID   = M_AXI_BVALID  ;
  assign M_AXI_BREADY   = S_AXI_BREADY  ;

  assign M_AXI_ARADDR   = S_AXI_ARADDR  ;
  assign M_AXI_ARLEN    = S_AXI_ARLEN   ;      
  assign M_AXI_ARSIZE   = S_AXI_ARSIZE  ;      
  assign M_AXI_ARBURST  = S_AXI_ARBURST ;          
  assign M_AXI_ARLOCK   = S_AXI_ARLOCK  ;      
  assign M_AXI_ARCACHE  = S_AXI_ARCACHE ;          
  assign M_AXI_ARPROT   = S_AXI_ARPROT  ;
  assign M_AXI_ARQOS    = S_AXI_ARQOS   ;
  assign M_AXI_ARVALID  = S_AXI_ARVALID ;
  assign S_AXI_ARREADY  = M_AXI_ARREADY ;

  assign S_AXI_RDATA    = M_AXI_RDATA   ;
  assign S_AXI_RRESP    = M_AXI_RRESP   ;
  assign S_AXI_RLAST    = M_AXI_RLAST   ;
  assign S_AXI_RVALID   = M_AXI_RVALID  ;
  assign M_AXI_RREADY   = S_AXI_RREADY  ;

	endmodule

/*

	axi_passthru #
	(
		.C_S_AXI_DATA_WIDTH(64)  ,
		.C_S_AXI_ADDR_WIDTH(7 )
	) axi_passthru_inst (
		.aclk           (           )  ,  // input                  
    .aresetn        (           )  ,  // input            
    .S_AXI_AWADDR   (_AWADDR    )  ,  // input    [C_S_AXI_ADDR_WIDTH-1 : 0] 			
    .S_AXI_AWLEN    (_AWLEN     )  ,  // input    [7 : 0]                          
    .S_AXI_AWSIZE   (_AWSIZE    )  ,  // input    [2 : 0]                          
    .S_AXI_AWBURST  (_AWBURST   )  ,  // input    [1 : 0]                          
    .S_AXI_AWLOCK   (_AWLOCK    )  ,  // input    [0 : 0]                          
    .S_AXI_AWCACHE  (_AWCACHE   )  ,  // input    [3 : 0]                          
		.S_AXI_AWPROT   (_AWPROT    )  ,  // input    [2 : 0] 													
		.S_AXI_AWQOS    (_AWQOS     )  ,  // input    [3 : 0]                          
    .S_AXI_AWVALID  (_AWVALID   )  ,  // input     																
		.S_AXI_AWREADY  (_AWREADY   )  ,  // output     																
    .S_AXI_WDATA    (_WDATA     )  ,  // input    [C_S_AXI_DATA_WIDTH-1 : 0] 			
		.S_AXI_WSTRB    (_WSTRB     )  ,  // input    [(C_S_AXI_DATA_WIDTH/8)-1 : 0] 	
    .S_AXI_WLAST    (_WLAST     )  ,  // input                                     
		.S_AXI_WVALID   (_WVALID    )  ,  // input     																
		.S_AXI_WREADY   (_WREADY    )  ,  // output     																
    .S_AXI_BRESP    (_BRESP     )  ,  // output    [1 : 0] 												
		.S_AXI_BVALID   (_BVALID    )  ,  // output     																
		.S_AXI_BREADY   (_BREADY    )  ,  // input     																
    .S_AXI_ARADDR   (_ARADDR    )  ,  // input    [C_S_AXI_ADDR_WIDTH-1 : 0] 			
		.S_AXI_ARLEN    (_ARLEN     )  ,  // input    [7 : 0]                          
    .S_AXI_ARSIZE   (_ARSIZE    )  ,  // input    [2 : 0]                          
    .S_AXI_ARBURST  (_ARBURST   )  ,  // input    [1 : 0]                          
    .S_AXI_ARLOCK   (_ARLOCK    )  ,  // input    [0 : 0]                          
    .S_AXI_ARCACHE  (_ARCACHE   )  ,  // input    [3 : 0]                          
    .S_AXI_ARPROT   (_ARPROT    )  ,  // input    [2 : 0] 													
		.S_AXI_ARQOS    (_ARQOS     )  ,  // input    [3 : 0]                          
    .S_AXI_ARVALID  (_ARVALID   )  ,  // input     																
		.S_AXI_ARREADY  (_ARREADY   )  ,  // output     																
    .S_AXI_RDATA    (_RDATA     )  ,  // output    [C_S_AXI_DATA_WIDTH-1 : 0] 			
		.S_AXI_RRESP    (_RRESP     )  ,  // output    [1 : 0] 												
		.S_AXI_RLAST    (_RLAST     )  ,  // input                                     
    .S_AXI_RVALID   (_RVALID    )  ,  // output     																
		.S_AXI_RREADY   (_RREADY    )  ,  // input     																
		.M_AXI_AWADDR   (_AWADDR    )  ,  // output    [C_S_AXI_ADDR_WIDTH-1 : 0] 			
    .M_AXI_AWLEN    (_AWLEN     )  ,  // output    [7 : 0]                         
    .M_AXI_AWSIZE   (_AWSIZE    )  ,  // output    [2 : 0]                         
    .M_AXI_AWBURST  (_AWBURST   )  ,  // output    [1 : 0]                         
    .M_AXI_AWLOCK   (_AWLOCK    )  ,  // output    [0 : 0]                         
    .M_AXI_AWCACHE  (_AWCACHE   )  ,  // output    [3 : 0]                         
		.M_AXI_AWPROT   (_AWPROT    )  ,  // output    [2 : 0] 												
		.M_AXI_AWQOS    (_AWQOS     )  ,  // output    [3 : 0]                         
    .M_AXI_AWVALID  (_AWVALID   )  ,  // output     																
		.M_AXI_AWREADY  (_AWREADY   )  ,  // input     																
    .M_AXI_WDATA    (_WDATA     )  ,  // output    [C_S_AXI_DATA_WIDTH-1 : 0] 			
		.M_AXI_WSTRB    (_WSTRB     )  ,  // output    [(C_S_AXI_DATA_WIDTH/8)-1 : 0]	
    .M_AXI_WLAST    (_WLAST     )  ,  // output                                    
		.M_AXI_WVALID   (_WVALID    )  ,  // output     																
		.M_AXI_WREADY   (_WREADY    )  ,  // input     																
    .M_AXI_BRESP    (_BRESP     )  ,  // input    [1 : 0] 													
		.M_AXI_BVALID   (_BVALID    )  ,  // input     																
		.M_AXI_BREADY   (_BREADY    )  ,  // output     																
    .M_AXI_ARADDR   (_ARADDR    )  ,  // output    [C_S_AXI_ADDR_WIDTH-1 : 0] 			
		.M_AXI_ARLEN    (_ARLEN     )  ,  // output    [7 : 0]                         
    .M_AXI_ARSIZE   (_ARSIZE    )  ,  // output    [2 : 0]                         
    .M_AXI_ARBURST  (_ARBURST   )  ,  // output    [1 : 0]                         
    .M_AXI_ARLOCK   (_ARLOCK    )  ,  // output    [0 : 0]                         
    .M_AXI_ARCACHE  (_ARCACHE   )  ,  // output    [3 : 0]                         
		.M_AXI_ARPROT   (_ARPROT    )  ,  // output    [2 : 0] 												
    .M_AXI_ARQOS    (_ARQOS     )  ,  // output    [3 : 0]                         
		.M_AXI_ARVALID  (_ARVALID   )  ,  // output     																
		.M_AXI_ARREADY  (_ARREADY   )  ,  // input     																
    .M_AXI_RDATA    (_RDATA     )  ,  // input    [C_S_AXI_DATA_WIDTH-1 : 0] 			
		.M_AXI_RRESP    (_RRESP     )  ,  // input    [1 : 0] 													
    .M_AXI_RLAST    (_RLAST     )  ,  // output                                    
		.M_AXI_RVALID   (_RVALID    )  ,  // input     																
		.M_AXI_RREADY   (_RREADY    )     // output     																
	);


*/

