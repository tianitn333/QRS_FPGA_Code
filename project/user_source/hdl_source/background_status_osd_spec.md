# background_status_osd

## Background and edge implementation contract (2026-10-17)

Frame-latched state at user_i. Combinational hit_o for 5x7 glyphs at2xscale, region x416..511 y680..693. BG SET/CAL/OK selected by busy before ready. Independently visible when detection overlay disabled. Color supplied by mixer; below existing logo/detection/system OSD priority.

Verification: native ModelSim results and final TD implementation evidence are recorded separately. Missing board evidence is not a pass.

Timing scenario (illustrative register-stage contract; numerical tests are authoritative):
```json
{"signal":[{"name":"clk","wave":"p......"},{"name":"rst_n","wave":"01....."},{"name":"input_valid","wave":"0010000"},{"name":"output_valid","wave":"0000100"}]}
```
