set here [file dirname [file normalize [info script]]]
set root [file dirname $here]
set phy [file join $root project td_project camera_to_dsi_display_Runs phy_1]
set output [file join $root generated]
file mkdir $output
cd $phy
import_device ph1_35p.db -package PH1P35MDG324 -speed 3
eval [format {open_project {%s} -noanalyze} [file join $phy camera_to_dsi_display.prj]]
eval [format {import_db {%s}} [file join $root database hidden.db]]
puts "SUBMISSION_PROJECT_LOAD_COMPLETE"
