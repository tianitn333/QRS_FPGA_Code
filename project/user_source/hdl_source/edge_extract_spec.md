# edge_extract

## Interface

```verilog
module edge_extract #(
    parameter integer IMG_H = 720
)(
    input wire clk,
    input wire rst_n,
    input wire valid_i,
    input wire user_i,
    input wire last_i,
    input wire edge_i,
    input wire [11:0] x_i,
    input wire [11:0] y_i,
    output reg point_valid_o,
    output reg [11:0] point_x_o,
    output reg [11:0] point_y_o,
    output reg [15:0] point_frame_o,
    output reg run_valid_o,
    output reg [11:0] run_start_o,
    output reg [11:0] run_end_o,
    output reg [11:0] run_y_o,
    output reg [12:0] run_length_o,
    output reg [15:0] run_frame_o,
    output reg frame_done_o,
    output reg [15:0] frame_id_o,
    output reg [23:0] frame_points_o,
    output reg [23:0] frame_runs_o,
    output reg bbox_valid_o,
    output reg [11:0] xmin_o,
    output reg [11:0] xmax_o,
    output reg [11:0] ymin_o,
    output reg [11:0] ymax_o
);
```

## Clock, reset and behavior

75MHz single pixel/clock, active-low asynchronous control reset. Consumes dense valid/user/last/edge/x/y only after a valid frame start. One clock later emits sparse point events and maximal horizontal white runs. Run endpoints are inclusive, length is13-bit and equals end-start+1. Valid gaps pause a run; black pixels and row-end close it. One-pixel runs are retained. Point/run/frame_done are independent channels and may all assert together. At last_i and y_i=IMG_H-1, snapshot includes the final pixel and final run. Empty frames produce zero totals and invalid zero bbox. A new frame start aborts an unfinished prior frame without publishing its totals. Frame IDs increment at input raster user;16-bit modular IDs start at1 and are not camera source-frame IDs.24-bit counters cover1280x720; bbox is global edge extent, not a component or object ID.

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
