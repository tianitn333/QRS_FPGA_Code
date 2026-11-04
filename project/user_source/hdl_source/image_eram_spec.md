# image_eram

## Background and edge implementation contract (2026-10-17)

Synchronous one-edge read; explicit PH1P_LOGIC_ERAM 18-bit x1024 banks. Each input address is limited to DEPTH; ADDR_WIDTH<=14, DEPTH<=16384. Unwritten data is unspecified. Consumers must suppress output until storage is valid. No initialization/reset of RAM.

Verification: native ModelSim results and final TD implementation evidence are recorded separately. Missing board evidence is not a pass.

Timing scenario (illustrative register-stage contract; numerical tests are authoritative):
```json
{"signal":[{"name":"clk","wave":"p......"},{"name":"rst_n","wave":"01....."},{"name":"input_valid","wave":"0010000"},{"name":"output_valid","wave":"0000100"}]}
```
