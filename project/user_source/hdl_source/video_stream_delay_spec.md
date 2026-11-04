# video_stream_delay

## Background and edge implementation contract (2026-10-17)

All-clock circular raster delay including blanking. Depth=DELAY+1 ensures read address differs from write address. data_o receives input sampled DELAY edges earlier; consuming register introduces its usual next-edge sample. Initial output suppressed until filled. DEPTH<=16384. Mixer uses DELAY=2*H_TOTAL+4; total extra pipeline latency relative baseline is2*H_TOTAL+5.

Verification: native ModelSim results and final TD implementation evidence are recorded separately. Missing board evidence is not a pass.

Timing scenario (illustrative register-stage contract; numerical tests are authoritative):
```json
{"signal":[{"name":"clk","wave":"p......"},{"name":"rst_n","wave":"01....."},{"name":"input_valid","wave":"0010000"},{"name":"output_valid","wave":"0000100"}]}
```
