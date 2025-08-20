
module ServCoreBlackbox 
#(
   parameter MEMFILE_B = "",           // Hex file to be loaded into core RAM.
   parameter MEMSIZE_B = 8192,
   parameter SIM_B = 1'b0,
   parameter RESET_STRATEGY_B = "MINI",
   parameter WITH_CSR_B = 1,
   parameter AW_B       = 32,
   parameter USER_WIDTH = 0,
   parameter ID_WIDTH   = 0
)

(
    // CORE TOP
    input   wire clk,
    input   wire rst,
    input   wire i_timer_irq,

    // AXI2WB -- AXI SIGNALS FROM EXTERNAL(BUS/PERIPHERAL/ADAPTER) TO BRIDGE

    // AXI address write channel
    input   wire [AW_B-1:0] i_awaddr,
    input   wire i_awvalid,
    output  wire o_awready,
     //unused signals
    input  wire [ID_WIDTH:0] i_aw_id,
    input  wire [7:0] i_aw_len,
    input  wire [2:0] i_aw_size,
    input  wire [1:0] i_aw_burst,
    input  wire i_aw_lock,
    input  wire [3:0] i_aw_cache,
    input  wire [2:0] i_aw_prot,
    input  wire [3:0] i_aw_qos,
    input  wire [3:0] i_aw_region,
    input  wire [5:0] i_aw_atop,
    input  wire [USER_WIDTH:0] i_aw_user,

    // AXI address read channel 
    input   wire [AW_B-1:0] i_araddr,
    input   wire i_arvalid,
    output  wire o_arready,
    //unused signals
    input wire [ID_WIDTH:0] i_ar_id,
    input  wire [7:0] i_ar_len,
    input  wire [2:0] i_ar_size,
    input  wire [1:0] i_ar_burst,
    input  wire i_ar_lock,
    input  wire [3:0]i_ar_cache,
    input  wire [2:0]i_ar_prot,
    input  wire [3:0]i_ar_qos,
    input  wire [3:0]i_ar_region,
    input  wire [USER_WIDTH:0] i_ar_user,
   
    // AXI write channel
    input   wire [31:0] i_wdata,
    input   wire [3:0] i_wstrb,
    input   wire i_wvalid,
    output  wire o_wready,
   //unused signals
    input   wire i_w_last,
    input  wire [USER_WIDTH:0] i_w_user,

    // AXI response channel
    input   wire i_bready,
    output  wire [1:0] o_bresp,
    output  wire o_bvalid,
   //unused signals 
   output  wire [ID_WIDTH:0] o_b_id,
   output  wire [USER_WIDTH:0] o_b_user,
    
    // AXI read channel
    input   wire i_rready,
    output  wire [31:0] o_rdata,
    output  wire [1:0] o_rresp,
    output  wire o_rlast,
    output  wire o_rvalid,
    //unused signals
    output  wire [ID_WIDTH:0] o_r_id,
    output  wire [USER_WIDTH:0] o_r_user,
    // ---------------------------------------------------------------- //

    // WB2AXI AXI SIGNALS FROM BRIDGE TO EXTERNAL(PERIPHERAL/ADAPTER/BUS)


    // AXI address write channel
    input   wire i_awmready,
    output  wire [AW_B-1:0] o_awmaddr,
    output  wire o_awmvalid,
    //unused signals
    output  wire [ID_WIDTH:0] o_awm_id,
    output  wire [7:0] o_awm_len,
    output  wire [2:0] o_awm_size,
    output  wire [1:0] o_awm_burst,
    output  wire o_awm_lock,
    output  wire [3:0] o_awm_cache,
    output  wire [2:0] o_awm_prot,
    output  wire [3:0] o_awm_qos,
    output  wire [3:0] o_awm_region,
    output  wire [5:0] o_awm_atop,
    output  wire [USER_WIDTH-1:0] o_awm_user,

    // AXI address read channel
    input   wire i_armready,
    output  wire [AW_B-1:0] o_armaddr,
    output  wire o_armvalid,
    //unused signals
    output  wire [ID_WIDTH:0] o_arm_id,
    output  wire [7:0] o_arm_len,
    output  wire [2:0] o_arm_size,
    output  wire [1:0] o_arm_burst,
    output  wire o_arm_lock,
    output  wire [3:0] o_arm_cache,
    output  wire [2:0] o_arm_prot,
    output  wire [3:0] o_arm_qos,
    output  wire [3:0] o_arm_region,
    output  wire [USER_WIDTH:0] o_arm_user,

    // AXI write channel
    input  wire i_wmready,
    output wire [31:0] o_wmdata,
    output wire [3:0] o_wmstrb,
    output wire o_wmvalid,
    //unused signals
    output  wire o_wm_last,
    output  wire [USER_WIDTH:0] o_wm_user,

    // AXI response channel
    input  wire [1:0] i_bmresp,
    input  wire i_bmvalid,
    output wire o_bmready,
    //unused signals 
    input  wire [ID_WIDTH:0] i_bm_id,
    input  wire [USER_WIDTH:0] i_bm_user,
    
    //AXI read channel
    input   wire [31:0] i_rmdata,
    input   wire [1:0] i_rmresp,
    input   wire i_rmlast,
    input   wire i_rmvalid,
    output  wire o_rmready,
    //unused signals
    input wire [ID_WIDTH:0] i_rm_id,
    input wire [USER_WIDTH:0] i_rm_user

);


ServCore  // Serving (SoClet containing SERV and Servile Wrapper) plus the Bridge for conversion from Wishbone to AXI and vice versa when needed.
#(
        .memfile(MEMFILE_B),
        .memsize(MEMSIZE_B),
        .sim(SIM_B),
        .RESET_STRATEGY(RESET_STRATEGY_B),
        .WITH_CSR(WITH_CSR_B),
        .AW(AW_B),
        .ID_WIDTH(ID_WIDTH),
        .USER_WIDTH(USER_WIDTH)
)

ServCore_uut (
   
    .clk(clk),
    .rst(rst),
    .i_timer_irq(i_timer_irq),

   // AXI SIGNALS FROM TILELINK---->BRIDGE---->SERVING
    .i_awaddr(i_awaddr),
    .i_awvalid(i_awvalid),
    .o_awready(o_awready),
    .i_aw_id(i_aw_id),
    .i_aw_len(i_aw_len),
    .i_aw_size(i_aw_size),
    .i_aw_burst(i_aw_burst),
    .i_aw_lock(i_aw_lock),
    .i_aw_cache(i_aw_cache),
    .i_aw_prot(i_aw_prot),
    .i_aw_qos(i_aw_qos),
    .i_aw_region(i_aw_region),
    .i_aw_atop(i_aw_atop),
    .i_aw_user(i_aw_user),

    .i_araddr(i_araddr),
    .i_arvalid(i_arvalid),
    .o_arready(o_arready),
    .i_ar_id(i_ar_id),
    .i_ar_len(i_ar_len),
    .i_ar_size(i_ar_size),
    .i_ar_burst(i_ar_burst),
    .i_ar_lock(i_ar_lock),
    .i_ar_cache(i_ar_cache),
    .i_ar_prot(i_ar_prot),
    .i_ar_qos(i_ar_qos),
    .i_ar_region(i_ar_region),
    .i_ar_user(i_ar_user),

    .i_wdata(i_wdata),
    .i_wstrb(i_wstrb),
    .i_wvalid(i_wvalid),
    .o_wready(o_wready),
    .i_w_last(i_w_last),
    .i_w_user(i_w_user),

    .o_bresp(o_bresp),
    .o_bvalid(o_bvalid),
    .i_bready(i_bready),
    .o_b_id(o_b_id),
    .o_b_user(o_b_user),

     .o_rdata(o_rdata),
    .o_rresp(o_rresp),
    .o_rlast(o_rlast),
    .o_rvalid(o_rvalid),
    .i_rready(i_rready),
    .o_r_id(o_r_id),
    .o_r_user(o_r_user),
   
// AXI SIGNALS FROM SERVING--->BRIDGE---->TILELINK
    .o_awmaddr(o_awmaddr),
    .o_awmvalid(o_awmvalid),
    .i_awmready(i_awmready),
    .o_awm_id(o_awm_id),
    .o_awm_len(o_awm_len),
    .o_awm_size(o_awm_size),
    .o_awm_burst(o_awm_burst),
    .o_awm_lock(o_awm_lock),
    .o_awm_cache(o_awm_cache),
    .o_awm_prot(o_awm_prot),
    .o_awm_qos(o_awm_qos),
    .o_awm_region(o_awm_region),
    .o_awm_atop(o_awm_atop),
    .o_awm_user(o_awm_user),
   
    .o_armaddr(o_armaddr),
    .o_armvalid(o_armvalid),
    .i_armready(i_armready),
    .o_arm_id(o_arm_id),
    .o_arm_len(o_arm_len),
    .o_arm_size(o_arm_size),
    .o_arm_burst(o_arm_burst),
    .o_arm_lock(o_arm_lock),
    .o_arm_cache(o_arm_cache),
    .o_arm_prot(o_arm_prot),
    .o_arm_qos(o_arm_qos),
    .o_arm_region(o_arm_region),
    .o_arm_user(o_arm_user),

    .o_wmdata(o_wmdata),
    .o_wmstrb(o_wmstrb),
    .o_wmvalid(o_wmvalid),
    .i_wmready(i_wmready),
    .o_wm_last(o_wm_last),
    .o_wm_user(o_wm_user),
   
    .i_bmresp(i_bmresp),
    .i_bmvalid(i_bmvalid),
    .o_bmready(o_bmready),
    .i_bm_id(i_bm_id),
    .i_bm_user(i_bm_user),

    .i_rmdata(i_rmdata),
    .i_rmresp(i_rmresp),
    .i_rmlast(i_rmlast),
    .i_rmvalid(i_rmvalid),
    .o_rmready(o_rmready),
    .i_rm_id(i_rm_id),
    .i_rm_user(i_rm_user)
    );

endmodule
