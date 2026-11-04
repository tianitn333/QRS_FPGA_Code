set here [file dirname [file normalize [info script]]]
set root [file dirname $here]
set phy [file join $root project td_project camera_to_dsi_display_Runs phy_1]
set output [file join $root generated]
file mkdir $output
cd $phy
import_device ph1_35p.db -package PH1P35MDG324 -speed 3
eval [format {open_project {%s} -noanalyze} [file join $phy camera_to_dsi_display.prj]]
eval [format {import_db {%s}} [file join $root database hidden.db]]
clear_sdc -user
eval [format {read_sdc {%s}} [file join $root project td_project camera_to_dsi_display.sdc]]
update_timing -mode final
eval [format {report_timing_status -file {%s}} [file join $output timing_status.ts]]
eval [format {report_timing_summary -file {%s} -ep_num 40 -path_num 1} [file join $output timing_summary.timing]]
eval [format {report_area -io_info -file {%s}} [file join $output area.rpt]]
eval [format {bitgen -bit {%s}} [file join $output motion_can_hidden_regenerated.bit]]
puts "SUBMISSION_HIDDEN_BITGEN_COMPLETE"
