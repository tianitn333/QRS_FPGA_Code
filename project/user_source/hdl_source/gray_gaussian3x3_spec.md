# gray_gaussian3x3

## Background and edge implementation contract (2026-10-17)

Three register stages; all valid/user/last forwarded, even unsupported positions. Weighted 3x3 sum /16 floor. Output at raster(x,y) corresponds to original center(x-1,y-1); x<2 or y<2 outputs zero. Three ERAM line banks. A valid SOF resets coordinates/write-bank; old frame memory is ignored until full support. No backpressure.

Verification: native ModelSim results and final TD implementation evidence are recorded separately. Missing board evidence is not a pass.

Timing scenario (illustrative register-stage contract; numerical tests are authoritative):
```json
{"signal":[{"name":"clk","wave":"p......"},{"name":"rst_n","wave":"01....."},{"name":"input_valid","wave":"0010000"},{"name":"output_valid","wave":"0000100"}]}
```
