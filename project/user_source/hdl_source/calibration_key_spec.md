# calibration_key

## Background and edge implementation contract (2026-10-17)

Debounce active-low KEY2. Short and long events occur only on release, mutually exclusive. HOLD_CYCLES=150000000 at 75 MHz is two seconds. No event while held. Three input synchronizers; asynchronous active-low reset clears all state.

Verification: native ModelSim results and final TD implementation evidence are recorded separately. Missing board evidence is not a pass.

Timing scenario (illustrative register-stage contract; numerical tests are authoritative):
```json
{"signal":[{"name":"clk","wave":"p......"},{"name":"rst_n","wave":"01....."},{"name":"input_valid","wave":"0010000"},{"name":"output_valid","wave":"0000100"}]}
```
