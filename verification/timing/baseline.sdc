create_clock -name {sys_clk_50m} -period 20.000 -waveform {0.000 10.000} [get_ports {I_sys_clk}]
create_clock -name {mipi_rx_ck_pad} -period 4.167 -waveform {0.000 2.083} [get_nets {IO_rx_clk_pad_p}]

derive_clocks

rename_clock -name {pll_clk_100m} [get_clocks {u_PLL/ph1p_phy_pll_wrapper_25a56e5ce2f9_Inst/u_PH1P_PHY_PLL.clkc[0]}]
rename_clock -name {pll_clk_24m} [get_clocks {u_PLL/ph1p_phy_pll_wrapper_25a56e5ce2f9_Inst/u_PH1P_PHY_PLL.clkc[1]}]
rename_clock -name {HDMI_PIXEL_CLK} [get_clocks {u_PLL/ph1p_phy_pll_wrapper_25a56e5ce2f9_Inst/u_PH1P_PHY_PLL.clkc[4]}]
rename_clock -name {HDMI_SERIAL_CLK} [get_clocks {u_PLL/ph1p_phy_pll_wrapper_25a56e5ce2f9_Inst/u_PH1P_PHY_PLL.clkc[5]}]

rename_clock -name {MIPI_RX_BYTE_CLK} [get_clocks {u_mipi_dphy_rx_ph1p_mipiio_wrapper/u_ph1p_mipiio_rx_wrapper/u_PH1P_LOGIC_DPHY_MIPI_RX.o_fabric_div4_8_clk}]


set_clock_groups -asynchronous \
    -group [get_clocks {mipi_rx_ck_pad MIPI_RX_BYTE_CLK}] \
    -group [get_clocks {sys_clk_50m pll_clk_100m pll_clk_24m HDMI_PIXEL_CLK HDMI_SERIAL_CLK}] \
    -group [get_clocks {u_ph1p35_324_ddr_wrapper/u_ddr2/ddr_clk u_ph1p35_324_ddr_wrapper/u_ddr2/usr_clk}]

# AE source statistics cross MIPI_RX_BYTE_CLK -> pll_clk_24m using a held packet.
# Those clocks are already asynchronous above. No DDR/video paths are changed.
# Telemetry crosses related PLL outputs; exceptions target ONLY mailbox stages.
# Scope handshake nets to the receiving clock, keeping the second synchronizer stage timed.
set_false_path -through [get_nets -hierarchical {*u_ae_display_mailbox/req}] -to [get_clocks {HDMI_PIXEL_CLK}]
set_false_path -through [get_nets -hierarchical {*u_ae_display_mailbox/ack}] -to [get_clocks {pll_clk_24m}]
# Data is held until ACK; req passes two destination synchronizers before capture.
# Bound ALL held-data fanouts to less than two 75 MHz cycles (26.666 ns).
# Either held FF can be packed under an unrelated neighbouring cell name.
# Match exact logical held bus nets (TD bus wildcard), then only the receiver
# clock, preserving all data bits without cutting local feedback or clock domains.
set_max_delay -through [get_nets -hierarchical {*u_ae_display_mailbox/held[*]}] -to [get_clocks {HDMI_PIXEL_CLK}] 25.0 -datapath_only
set_false_path -from [get_ports {I_key[*]}]

# SW1 pin has exactly one data fanout: u_switch_preview/S_sync_meta.
# Cut only this asynchronous port-to-first-stage path in HDMI_PIXEL_CLK.
# S_sync_meta -> S_sync_level is an ordinary timed setup/hold path.
set_false_path -from [get_ports {I_switch_preview}] -to [get_clocks {HDMI_PIXEL_CLK}]

# New asynchronous inputs have exactly one pad sink each (first synchronizer).
# Stage-one to stage-two and all CAN protocol/host paths remain timed at 75MHz.
set_false_path -from [get_ports {I_motor_arm I_motor_reference I_can_receive}] -to [get_clocks {HDMI_PIXEL_CLK}]
set_output_delay -clock [get_clocks {HDMI_PIXEL_CLK}] -max 5.0 [get_ports {O_can_transmit}]
set_output_delay -clock [get_clocks {HDMI_PIXEL_CLK}] -min 0.0 [get_ports {O_can_transmit}]


# Replay: bundled data held through two-stage handshake.
set_max_delay -through [get_nets -hierarchical {*u_replay_request/held[*]}] -to [get_clocks {u_ph1p35_324_ddr_wrapper/u_ddr2/usr_clk}] 25.0 -datapath_only
set_max_delay -through [get_nets -hierarchical {*u_replay_applied/held[*]}] -to [get_clocks {HDMI_PIXEL_CLK}] 25.0 -datapath_only
set_max_delay -through [get_nets -hierarchical {*u_video_store/u_control/held[*]}] -to [get_clocks {u_ph1p35_324_ddr_wrapper/u_ddr2/usr_clk}] 25.0 -datapath_only
set_max_delay -through [get_nets -hierarchical {*u_video_store/u_capture/u_tags/write_gray[*]}] -to [get_clocks {u_ph1p35_324_ddr_wrapper/u_ddr2/usr_clk}] 5.0 -datapath_only
set_max_delay -through [get_nets -hierarchical {*u_video_store/u_capture/u_tags/read_gray[*]}] -to [get_clocks {MIPI_RX_BYTE_CLK}] 5.0 -datapath_only
set_max_delay -through [get_nets -hierarchical {*u_video_store/u_capture/u_starts/write_gray[*]}] -to [get_clocks {u_ph1p35_324_ddr_wrapper/u_ddr2/usr_clk}] 5.0 -datapath_only
set_max_delay -through [get_nets -hierarchical {*u_video_store/u_capture/u_starts/read_gray[*]}] -to [get_clocks {MIPI_RX_BYTE_CLK}] 5.0 -datapath_only
set_max_delay -through [get_nets -hierarchical {*u_video_store/u_capture/u_ends/write_gray[*]}] -to [get_clocks {u_ph1p35_324_ddr_wrapper/u_ddr2/usr_clk}] 5.0 -datapath_only
set_max_delay -through [get_nets -hierarchical {*u_video_store/u_capture/u_ends/read_gray[*]}] -to [get_clocks {MIPI_RX_BYTE_CLK}] 5.0 -datapath_only
set_max_delay -through [get_nets -hierarchical {*u_video_store/u_decisions/write_gray[*]}] -to [get_clocks {u_ph1p35_324_ddr_wrapper/u_ddr2/usr_clk}] 5.0 -datapath_only
set_max_delay -through [get_nets -hierarchical {*u_video_store/u_decisions/read_gray[*]}] -to [get_clocks {MIPI_RX_BYTE_CLK}] 5.0 -datapath_only
