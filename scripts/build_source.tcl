# Full source build; does not reproduce the frozen physical placement.
set root [file dirname [file dirname [file normalize [info script]]]]
set runs [file join $root project td_project camera_to_dsi_display_Runs]
cd [file join $runs syn_1]
source camera_to_dsi_display.tcl
cd [file join $runs phy_1]
source camera_to_dsi_display.tcl
puts "SUBMISSION_FULL_SOURCE_PNR_COMPLETE"
