//------------------------------------------------------------------------------
//  Copyright (c) 2011-2024 Anlogic, Inc.
//  All Right Reserved.
//------------------------------------------------------------------------------

////////////////////////////////////////////////////////////////////////////////
//
//  Vendor      : Anlogic
//  Version     : 1.2
//  Description : Anlogic Functional Simulation Model for Physical IP
//                PH1P_PHY_CONFIG
//  Filename    : ph1p_phy_config_v2.v
//
////////////////////////////////////////////////////////////////////////////////
//
//  Revision    :
//      2024-06-07 - 1.21- YF.MENG - add jtag ports
//      2024-04-02 - 1.2 - GS.JI   - Add osc_clk_i input port.
//      2024-02-21 - 1.1 - GS.JI   - Add dualboot_o port.
//      2024-01-18 - 1.0 - XT.XUE  - Add jtag pad virtual ports
//      2024-01-09 - 0.9 - XT.XUE  - Add jtag pib user ports
//      2023-11-15 - 0.8 - RG.Wang - eco_version_o add
//      2023-08-23 - 0.7 - RG.Wang - ecc option change (AL6100-1822)
//      2023-09-11 - 0.6 - RG.Wang - gsrn time change
//      2023-08-23 - 0.5 - RG.Wang - multboot_en_n_i change to multboot_en_i
//      2023-08-21 - 0.4 - RG.Wang - mcu qpsi correct
//      2023-08-18 - 0.3 - RG.Wang - ecc freq delete 22M
//      2023-08-04 - 0.2 - RG.Wang - Add *_v2.
//      2023-07-19 - 0.1 - RG.Wang - Initial version.
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1ps/1ps

module  PH1P_PHY_CONFIG_V2 (
    //Inputs
        osc_clk_i,
        usrtrstn_i, 
        usrtrstn_sel_n_i, 
        jtag_pib_sel_i,
        qspi_pib_sel_i,
        ptck_i,
        ptms_i,
        ptdi_i,
        ipa_out_i, 
        ipb_out_i,
        dna_clk_i, 
        dna_din_i, 
        dna_shift_n_i, 
        ecc_enable_n_i, 
        ecc_endaddrdebug_n_i, 
        ecc_endaddr_i, 
        multboot_en_i, 
        multboot_code_i, 
        multboot_addr_i, 
        usr_gsr_n_i, 
        gsr_sync_clk_i, 
        icap_enable_i,
        icap_clk_i,
        icap_cs_n_i,
        icap_rdwr_n_i,
        icap_data_i,
        tck_i, 
        tms_i, 
        tdi_i,
        ddr3_tdo_i,
        ddr3_tdoen_i,
    //Outputs
        eco_version_o,
        ptdo_o,
        ptdoe_o,
        cwc_rst_o, 
        cwc_scanen_o, 
        cwc_rti_o, 
        cwc_shift_o, 
        cwc_update_o, 
        cwc_tck_o, 
        cwc_tdi_o, 
        cwc_tms_o, 
        dna_do_o, 
        ecc_clk_o, 
        ecc_stop_o, 
        ecc_done_o, 
        ecc_info_o,
        icap_busy_n_o,
        icap_data_o,
        done_o, 
        wakeup_o,
        wakeup_mux_dly20_o,
        tdo_o, 
        tdoe_o,
        ddr3_tck_o,
        ddr3_trst_n_o,
        ddr3_tms_o,
        ddr3_tdi_o,
        s_tck_o,
        s_tms_o,
        s_tdi_o,
        s_tdoen_i,
        s_tdo_i,
        dualboot_o

);

        //----------------------------------------------------------------------------------------------
        input                                   osc_clk_i               ;       //  [tag:clk]  133MHz
        //  dualboot_image_index
        output  [1:0]                           dualboot_o              ;       //  dualboot_image_index
        //      device_version_o
        output  [3:0]                           eco_version_o           ;        // eco version info
        //      jtag trst sel
        input                                   usrtrstn_i              ;       // user active-low TRSTN input
        input                                   usrtrstn_sel_n_i        ;       // select user TRSTN input, active-low

        //      jtag sel
        input                                   jtag_pib_sel_i          ;       // active-high, select user JTAG input
        input                                   ptck_i                  ;       // [tag:clk] user JTAG tck
        input                                   ptms_i                  ;       // user JTAG tms
        input                                   ptdi_i                  ;       // user JTAG tdi
        output                                  ptdo_o                  ;       // user JTAG tdo
        output                                  ptdoe_o                 ;       // user JTAG tdo output enable
        //      qspi sel
        input                                   qspi_pib_sel_i          ;       // active-high, select mcu qspi
        //      cwc
        input                                   ipa_out_i               ;       // cwc dedicated ports
        input                                   ipb_out_i               ;       // cwc dedicated ports
        output                                  cwc_rst_o               ;       // cwc dedicated ports
        output  [1:0]                           cwc_scanen_o            ;       // cwc dedicated ports
        output  [1:0]                           cwc_rti_o               ;       // cwc dedicated ports
        output                                  cwc_shift_o             ;       // cwc dedicated ports
        output                                  cwc_update_o            ;       // cwc dedicated ports
        output                                  cwc_tck_o               ;       // [tag:clk] cwc dedicated ports
        output                                  cwc_tdi_o               ;       // cwc dedicated ports
        output                                  cwc_tms_o               ;       // cwc dedicated ports

        //      dna ip
        input                                   dna_clk_i               ;       // [tag:clk] dna clock, 0~20MHz
        input                                   dna_din_i               ;       // dna serial data input
        input                                   dna_shift_n_i           ;       // active-low shift enable
        output                                  dna_do_o                ;       // dna serial data output

        //      ecc
        input                                   ecc_enable_n_i          ;       // active-low ecc run enable
        input                                   ecc_endaddrdebug_n_i    ;       // active-low ecc debug end address select
        input   [22:0]                          ecc_endaddr_i           ;       // ecc debug end address
        output                                  ecc_clk_o               ;       // [tag:clk] 2~11MHz
        output                                  ecc_stop_o              ;       // ecc run has stopped
        output                                  ecc_done_o              ;       // ecc traveral loop completed
        output  [37:0]                          ecc_info_o              ;       // 37~15: asr address; 14~8: word_index; 7~3: bit_index; 2: sbit_err; 1: dbit_err; 0: gcrc_error

        //      multboot
        input                                   multboot_en_i         ;         // active-high multboot enable,default 0
        input   [7:0]                           multboot_code_i         ;       // when equal to 8'hA5, multboot_en_i take effect
        input   [31:0]                          multboot_addr_i         ;       // Bistream starting address in SPI Flash

        //      user gsrn
        input                                   usr_gsr_n_i             ;       // user gsrn input
        input                                   gsr_sync_clk_i          ;       // gsrn synchronous clock

        //      icap if
        input                                   icap_enable_i           ;       // 0 - disable icap, 1 - enable icap
        input                                   icap_clk_i              ;       // [tag:clk] icap clock max 50MHz
        input                                   icap_cs_n_i             ;       // icap active-low select
        input                                   icap_rdwr_n_i           ;       // 0 - write, 1 - read
        input   [31:0]                          icap_data_i             ;       // support data width 8/16/32
        output                                  icap_busy_n_o           ;       // active-low read data valid
        output  [31:0]                          icap_data_o             ;       // support data width 8/16/32

        //      global control
        output                                  done_o                  ;       // configuration successfully completed
        output                                  wakeup_o                ;       // when high, most user feature beign to work
        output                                  wakeup_mux_dly20_o      ;       // the latest flag indicate fpga goes into user mode
        //      user jtag chain
        input   [1:0]                           ddr3_tdo_i              ;       // user mode jtag chain TDO
        input   [1:0]                           ddr3_tdoen_i            ;       // user mode jtag chain TDOEN
        output  [1:0]                           ddr3_tck_o              ;       // [tag:clk] user mode jtag chain TCK
        output                                  ddr3_trst_n_o           ;       // user mode jtag chain TRSTN
        output                                  ddr3_tms_o              ;       // user mode jtag chain TMS
        output                                  ddr3_tdi_o              ;       // user mode jtag chain TDI
        //      JTAG pad ports soft route
        output                                   s_tck_o                 ;       //[tag:clk] JTAG pad tck  10MHz route
        output                                   s_tms_o                 ;       // JTAG pad tms route
        output                                   s_tdi_o                 ;       // JTAG pad tdi route
        input                                    s_tdoen_i               ;       // JTAG pad tdoen route
        input                                    s_tdo_i                 ;       // JTAG pad tdo route
        //      JTAG pad ports
        input                                   tck_i                   ;       //[tag:clk,virtual] JTAG pad tck  10MHz
        input                                   tms_i                   ;       //[tag:virtual] JTAG pad tms
        input                                   tdi_i                   ;       //[tag:virtual] JTAG pad tdi
        output                                  tdo_o                   ;       //[tag:virtual] JTAG pad tdo
        output                                  tdoe_o                  ;       //[tag:virtual] JTAG pad tdo output enable

        //----------------------------------------------------------------------------------------------
        //      JTAG IO
        //      "ENABLE" -- Select User JTAG Port; "DISABLE" -- Select Config JTAG PAD      
        parameter       PJTAG_EN                =       "DISABLE"               ;       //      "ENABLE","DISABLE"
        //      IO Active-Low PERSIST 
        //      "DISABLE" -- Config Dedicated IO; "ENABLE" -- GPIO
        parameter       JTAG_PERSISTN           =       "DISABLE"               ;       //      "ENABLE", "DISABLE"
        parameter       SPIX4_PERSISTN          =       "ENABLE"                ;       //      "ENABLE", "DISABLE"

        //      MULTBOOT FUSE
        parameter       MULTBOOT_ADDRSRC_SEL    =       "STATIC"                ;       //      "STATIC", "DYNAMIC"
        parameter       MULTBOOT_STATIC_ADDR    =       32'h0080_0000           ;

        //      GSRN SYNC
        //      "ENABLE" -- Select User GSRN Port; "DISABLE" -- Select Config Output GSRN      
        parameter       GSRN_SYNC_SEL           =       "DISABLE"               ;       //      "ENABLE", "DISABLE"
        parameter       USR_GSRN_EN             =       "DISABLE"               ;       //      "ENABLE", "DISABLE"

        //      ECC Logic Parameter, apply to CTRL register in bitstream
        parameter       ECCERR_REPORT_EN        =       "DISABLE"               ;       //      "ENABLE", "DISABLE"
        parameter       ECC_PROTECT             =       "DISABLE"               ;       //      "ENABLE", "DISABLE"
        parameter       SEC_OPTION              =       "CORRECT_AND_CONTINUE"  ;       //      "CONTINUE", "HOLD", "CORRECT_AND_CONTINUE", "CORRECT_AND_HOLD"
        parameter       ECC_FREQ                =       "2MHz"                  ;       //      "2MHz", "3MHz", "5MHz", "11MHz" 
        // PIB ROUTE
        parameter       EXT_DNA_CLK_I           =       "SIG"                   ;       //      "0", "1", "SIG", "INV"  
        parameter       EXT_GSR_SYNC_CLK_I      =       "SIG"                   ;       //      "0", "1", "SIG", "INV"  
        parameter       EXT_ICAP_CLK_I          =       "SIG"                   ;       //      "0", "1", "SIG", "INV" 
 


        //----------------------------------------------------------------------------------------------
        // JTAG IO      
        reg             jtag_flgerr = 1'b0;
        assign ddr3_tck_o[0] = (jtag_pib_sel_i&&(PJTAG_EN=="ENABLE")) ? ptck_i          : tck_i           ;
        assign ddr3_tms_o    = (jtag_pib_sel_i&&(PJTAG_EN=="ENABLE")) ? ptms_i          : tms_i           ;
        assign ddr3_tdi_o    = (jtag_pib_sel_i&&(PJTAG_EN=="ENABLE")) ? ptdi_i          : tdi_i           ;
        assign ptdo_o        = (jtag_pib_sel_i&&(PJTAG_EN=="ENABLE")) ? ddr3_tdo_i[0]   : 1'bz            ;
        assign tdo_o         = (jtag_pib_sel_i&&(PJTAG_EN=="ENABLE")) ? 1'bz            : ddr3_tdo_i[0]   ;
        assign ptdoe_o       = (jtag_pib_sel_i&&(PJTAG_EN=="ENABLE")) ? ddr3_tdoen_i[0] : 1'bz            ;
        assign tdoe_o        = (jtag_pib_sel_i&&(PJTAG_EN=="ENABLE")) ? 1'bz            : ddr3_tdoen_i[0] ;

        always @(*) begin
                if(PJTAG_EN == "DISABLE") ;
                else if(PJTAG_EN == "ENABLE") ;
                else begin
                        $display("Error ! parameter PJTAG_EN can only choose \"DISABLE\", \"ENABLE\", exit();");
                        jtag_flgerr = 1;
                end
                if (jtag_flgerr)begin
                        #5 $finish;
                end     
        end
        //----------------------------------------------------------------------------------------------
        // MBOOT        
        reg             mboot_flgerr = 1'b0;

        always @(*) begin
                if(MULTBOOT_ADDRSRC_SEL == "STATIC") ;
                else if(MULTBOOT_ADDRSRC_SEL == "DYNAMIC") ;
                else begin
                        $display("Error ! parameter MULTBOOT_ADDRSRC_SEL can only choose \"STATIC\", \"DYNAMIC\", exit();");
                        mboot_flgerr = 1;
                end
                if (mboot_flgerr)begin
                        #5 $finish;
                end     
        end

        //----------------------------------------------------------------------------------------------
        // DNA
        localparam                      DNA_DEFAULT = 64'b0;

        wire                            load_dna;

        reg                             dna_clk = 1'b0;
        reg                             dna_flgerr = 1'b0;
        reg             [63:0]          dna_reg = 64'b0;
        reg                             dna_shift_n_r = 1'b0;

        always @(*) begin
                if(EXT_DNA_CLK_I == "SIG") dna_clk = dna_clk_i;
                else if(EXT_DNA_CLK_I == "INV") dna_clk = ~dna_clk_i;
                else if(EXT_DNA_CLK_I == "0") dna_clk = 1'b0;
                else if(EXT_DNA_CLK_I == "1") dna_clk = 1'b1;
                else begin
                        $display("Error ! parameter EXT_DNA_CLK_I can only choose \"SIG\", \"0\", \"1\", \"INV\", exit();");
                        dna_flgerr = 1;
                end
                if (dna_flgerr)begin
                        #5 $finish;
                end
        end

        assign  load_dna        =       ~dna_shift_n_i & dna_shift_n_r;
        assign  dna_do_o        =       dna_reg[0];

        always @(posedge dna_clk) begin
                dna_shift_n_r   <= dna_shift_n_i;
        end     

        always @(posedge dna_clk) begin
                if(load_dna)
                        dna_reg         <= DNA_DEFAULT;
                else if(~dna_shift_n_i & ~load_dna)
                        dna_reg         <= {dna_din_i, dna_reg[63:1]};
        end     

        //----------------------------------------------------------------------------------------------
        // ICAP
        reg                             icap_flgerr0 = 1'b0;

        always @(*) begin
                if(EXT_ICAP_CLK_I == "SIG") ; 
                else if(EXT_ICAP_CLK_I == "INV") ;
                else if(EXT_ICAP_CLK_I == "0") ;
                else if(EXT_ICAP_CLK_I == "1") ;
                else begin
                        $display("Error ! parameter EXT_ICAP_CLK_I can only choose \"SIG\", \"0\", \"1\", \"INV\", exit();");
                        icap_flgerr0 = 1;
                end
                if (icap_flgerr0) begin
                        #5 $finish;
                end
        end

        //----------------------------------------------------------------------------------------------
        // USER GSRN
        reg             [1:0]   usr_gsrn_sync = 2'b0;
        reg                     gsrn_clk_node = 1'b0;
        reg                     gsrn_flgerr0  = 1'b0;
        reg                     gsrn_flgerr1  = 1'b0;
        reg                     gsrn_flgerr2  = 1'b0;

        always @(*) begin
                if(GSRN_SYNC_SEL == "DISABLE") ;
                else if(GSRN_SYNC_SEL == "ENABLE") ;
                else begin
                        $display("Error ! parameter GSRN_SYNC_SEL can only choose \"ENABLE\", \"DISABLE\", \
                        exit();");
                        gsrn_flgerr0 = 1;
                end
                if (gsrn_flgerr0) begin
                        #5 $finish;
                end
        end

        always @(*) begin
                if(USR_GSRN_EN == "DISABLE") ;
                else if(USR_GSRN_EN == "ENABLE") ;
                else begin
                        $display("Error ! parameter USR_GSRN_EN can only choose \"ENABLE\", \"DISABLE\", \
                        exit();");
                        gsrn_flgerr1 = 1;
                end
                if (gsrn_flgerr1) begin
                        #5 $finish;
                end
        end

        always @(*) begin
                if(EXT_GSR_SYNC_CLK_I == "SIG") gsrn_clk_node = gsr_sync_clk_i;
                else if(EXT_GSR_SYNC_CLK_I == "INV") gsrn_clk_node = ~gsr_sync_clk_i;
                else if(EXT_GSR_SYNC_CLK_I == "0") gsrn_clk_node = 1'b0;
                else if(EXT_GSR_SYNC_CLK_I == "1") gsrn_clk_node = 1'b1;
                else begin
                        $display("Error ! parameter EXT_GSR_SYNC_CLK_I can only choose \"SIG\", \"0\", \
                        \"1\", \"INV\", exit();");
                        gsrn_flgerr2 = 1;
                end
                if (gsrn_flgerr2) begin
                        #5 $finish;
                end
        end

        always @(posedge gsrn_clk_node) begin
                usr_gsrn_sync           <= {usr_gsrn_sync[0], usr_gsr_n_i};
        end     

        always @(*) begin
                PH1P_PHY_GSR.usr_gsrn_en = (USR_GSRN_EN == "ENABLE") ? 1'b1 : 1'b0;
                #20_000 PH1P_PHY_GSR.gsrn = (USR_GSRN_EN == "ENABLE") ? ((GSRN_SYNC_SEL == "ENABLE") ?
                                                                          usr_gsrn_sync[1] : usr_gsr_n_i) : 1'b1;
                PH1P_PHY_GSR.gsr                        = ~PH1P_PHY_GSR.gsrn;
        end     


        //----------------------------------------------------------------------------------------------
        // ECC
        reg                     ecc_flgerr0             =       1'b0;
        reg                     ecc_flgerr1             =       1'b0;
        reg                     ecc_flgerr2             =       1'b0;
        reg                     ecc_flgerr3             =       1'b0;

        always @(*) begin
                if(ECCERR_REPORT_EN == "DISABLE") ;
                else if(ECCERR_REPORT_EN == "ENABLE") ;
                else begin
                        $display("Error ! parameter ECCERR_REPORT_EN can only choose \"ENABLE\", \
                        \"DISABLE\", exit();");
                        ecc_flgerr0 = 1;
                end
                if (ecc_flgerr0) begin
                        #5 $finish;
                end
        end 

        always @(*) begin
                if(ECC_PROTECT == "DISABLE") ;
                else if(ECC_PROTECT == "ENABLE") ;
                else begin
                        $display("Error ! parameter ECC_PROTECT can only choose \"ENABLE\", \
                        \"DISABLE\", exit();");
                        ecc_flgerr1 = 1;
                end
                if (ecc_flgerr1) begin
                        #5 $finish;
                end
        end 

        always @(*) begin
                if(SEC_OPTION == "HOLD") ;
                else if(SEC_OPTION == "CONTINUE") ;
                else if(SEC_OPTION == "CORRECT_AND_CONTINUE") ;
                else if(SEC_OPTION == "CORRECT_AND_HOLD") ;
                else begin
                        $display("Error ! parameter SEC_OPTION can only choose \"CONTINUE\", \
                        \"HOLD\", \"CORRECT_AND_CONTINUE\", \"CORRECT_AND_HOLD\", exit();");
                        ecc_flgerr2 = 1;
                end
                if (ecc_flgerr2) begin
                        #5 $finish;
                end
        end     

        always @(*) begin
                if(ECC_FREQ == "2MHz") ;
                else if(ECC_FREQ == "3MHz") ;
                else if(ECC_FREQ == "5MHz") ;
                else if(ECC_FREQ == "11MHz") ;
                else begin
                        $display("Error ! parameter ECC_FREQ can only choose \"2MHz\", \"3MHz\", \
                        \"5MHz\", \"11MHz\", exit();");
                        ecc_flgerr3 = 1;
                end
                if (ecc_flgerr3) begin
                        #5 $finish;
                end
        end 

        //----------------------------------------------------------------------------------------------

endmodule   

`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "Anlogic"
`pragma protect encrypt_agent_info = "Anlogic Encryption Tool anlogic_2019"
`pragma protect key_keyowner = "Synopsys", key_keyname = "SNPS-VCS-RSA-1"
`pragma protect key_method = "rsa"
`pragma protect encoding = (enctype = "BASE64", line_length = 64, bytes = 128)
`pragma protect key_block
su4MlKU8+402CR6LDS9cxwTZKAbsI23atz+mD9jtwCUG7eacE+xXQkUYzN0yJjpg
FFAj5jbDdCzvJvxmkkIGXG8s1C/fENg6HHyaaITD11bUqngugvF+okTDH7FAqFB5
YcKHb8Vlz1iGqKMJ3RZGyeFvWPNf6wusp0y+o8Zh3j4=
`pragma protect key_keyowner = "Synopsys", key_keyname = "SNPS-VCS-RSA-2"
`pragma protect key_method = "rsa"
`pragma protect encoding = (enctype = "BASE64", line_length = 64, bytes = 128)
`pragma protect key_block
f52n19Q4urMvPA1qKx/AvVPCfJ0yZuzrsm98WHnkcOQlG/glV16QDR7S37iyPxbK
qJ6Mq4qZS8TFMon9XwQ5mamrKQ2wYYqeX1G9oi3C8D/wETXUNLVWLbJGs57SByCP
eMsvjeZ4BAgumHa+5qZA/ByP+5ynklqMFAOXYRoArX4=
`pragma protect key_keyowner = "Cadence Design Systems.", key_keyname = "CDS_RSA_KEY_VER_1"
`pragma protect key_method = "rsa"
`pragma protect encoding = (enctype = "BASE64", line_length = 64, bytes = 256)
`pragma protect key_block
pTJ+eXstmGdQcwTO/QGESBpnJ7eRVHKjZvnAOtjDi/AC7c0RzAGnWaRBPSm/UqND
2TpgsuvccOorAUHyIhor3qkv8jtWIr3y9W36nRj4JEO9ijXdvhJXpOQ0+vgo/Tbg
rr3+x9jIzDf4T7CUSpuIqsQW1Fdg7vweZ12PaKHSTU/JTvbSca8jO7tOPwV5KUg3
cutVLwqPAK7sCeAf72D1+eBArtDqZgGSht+D7UxxYrv8RmXUsCGbpO/j8F48U++U
rXTNWYNTJMq0w1/VpcESphLsb8b2TqhkoomVtTmG7YcunwKJpsKaKTl6l48EQvHD
J4DLqYP+wYbFrcnEyEewZg==
`pragma protect key_keyowner = "Mentor Graphics Corporation", key_keyname = "MGC-VERIF-SIM-RSA-1"
`pragma protect key_method = "rsa"
`pragma protect encoding = (enctype = "BASE64", line_length = 64, bytes = 128)
`pragma protect key_block
ZvfzAf7PRkuRm6nsiXQV6BdDpJobl4DYrcQzc86UOyrt/gUme+6RKKiIUiggiGnx
YRvC9KUC4xQI12YYNCPT1rMkcbc3QFfoSbLaVElJDxrf9FahbvTuy/efU/5aIEsa
RBKnW012FMo3+OlUcoKdNOD5K11yix0Y1iIuP0s+xF8=
`pragma protect key_keyowner = "Mentor Graphics Corporation", key_keyname = "MGC-VERIF-SIM-RSA-2"
`pragma protect key_method = "rsa"
`pragma protect encoding = (enctype = "BASE64", line_length = 64, bytes = 256)
`pragma protect key_block
Mq9t6Xrtikv4COKcSVZ3ZshBLHqoVAYuf0jbOug5+ExESnVQkpWhHqHpk9+wI2rg
3/9ZTT8FD4KJVL0+RRUB1UxCVUsCOqDa2+zg1V4Hk0m2ZEBH8Kw4rIT+Y3kBaDWz
wQ5YekxLURcV34ut6OmK7AT5k7UHM2gwt0NSqphPsF0gkGGM1AY8BdLS0T7r/L8j
vnB4ld5WCHGFeLa98WfUte5AiT0TK7XYVf6Dm3HRBziFq9H3oasVOyXvPXvw9BN5
MO37YZq2r2EzGnULbpbUJV9jmpFdgFxNajhKOs5fXSn/Ku/6KbpR6Ty+UKH4ZSUV
9w+dZZBBSQABuSqj0RoDcw==
`pragma protect key_keyowner = "Univista", key_keyname = "UV-ENC-RSA-1"
`pragma protect key_method = "rsa"
`pragma protect encoding = (enctype = "BASE64", line_length = 64, bytes = 256)
`pragma protect key_block
d2lnGYQDieLPRG+78shxbu3QjfNQDUwoe8TYcHXlDthRQgqRCTTGtfNi0HPFs/zh
iaCLIbHbkdc5jWR2W0IXvxJ/OqLBK765y+MvasdyxnAAjn9u4e6SvBpRvjnbUwZT
byEhK5VtRAygzKFgg10UP9kWEmgf3gY3uB3LsilDqkg1xW1LpMCZBW80SNkwpDGy
hTHkLC9pt1MR/BNZiEKy6X0p0nuDQXdBZW8GBg5Mx8SH7nQia/n/2czlE31680lJ
opneOj5gWawQHxg4GEd6YMiqYoPKwWTXH79KFfVFuge8OSevh1nylBWqUMnP89Hs
uDqv1GxFTlUVmR5hQ0ddKw==
`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 64, bytes = 48)
`pragma protect data_block
x8CRoYDY1tGjhtOIgQ9QdhJG7AyClCYRNVYsYgZuuXzlxwgg9X7WDtYnFu8Fp13u
`pragma protect end_protected   
