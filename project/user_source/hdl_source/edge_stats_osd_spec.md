# edge_stats_osd

## Interface

```verilog
module edge_stats_osd #(
    parameter integer IMG_H=720
)(
    input wire clk,
    input wire rst_n,
    input wire frame_done_i,
    input wire [23:0] points_i,
    input wire [23:0] runs_i,
    input wire frame_start_i,
    input wire enable_i,
    input wire de_i,
    input wire [11:0] x_i,
    input wire [11:0] y_i,
    output wire hit_o
);
```

## Clock, reset and behavior

75MHz single pixel/clock, active-low asynchronous control reset. Six decimal point/run digits Pxxxxxx Sxxxxxx in a240x16 window at x16 and yIMG_H-20. Inputs are frame snapshot counters; fixed1280x720 counts fit six digits and20-bit conversion. Parallel shift/add3 conversion uses20 clocks. Results are atomically committed at a raster frame start; normally they describe the previous completed frame. Insufficient interframe blanking may delay a displayed update by one more frame. No effect on point/run/binary outputs. Disabled or invalid positions produce no hit; official osd_char_lib is reused unchanged. No render for IMG_H<32.

## Constraints and verification

No backpressure. Input valid markers and x/y form a complete dense raster. First marker follows reset; RAM contents are not reset and unsupported borders are masked. Native tests cover original behavior, full-precision spatial oracle, sparse point and offline row-run oracle, counts, empty/full/one-pixel/last-pixel cases, invalid gaps, abort/restart, reset, ID wrap, full720p, decimal conversion, glyph pixels and display isolation. ADC/SDC remain unchanged; actual native timing and bitstream evidence must be checked independently.

## Timing illustration

```json
{
  "signal": [
    {
      "name": "clk",
      "wave": "p......."
    },
    {
      "name": "rst_n",
      "wave": "01......"
    },
    {
      "name": "dense_valid",
      "wave": "00111100"
    },
    {
      "name": "event_valid",
      "wave": "00011110"
    }
  ]
}
```

WaveJSON is illustrative; exact latencies are stated above and asserted in native tests. No rendered SVG is provided.
