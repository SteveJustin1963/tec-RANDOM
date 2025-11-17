# TEC-PBIT LOGIC ORACLE - QUICK REFERENCE CARD

**Print this page and keep next to your build**

---


### PINOUT SUMMARY
Port D (Inputs):
  D0: RNG_BIT (avalanche noise)
  D1: P-bit A state (>1.5V = 1)
  D2: P-bit B state
  D3: P-bit C state
  D4: P-bit spare
  D5: Switch A (clue)
  D6: Switch B (clue)
  D7: Switch C (clue)
  D8: Gate select

Port B (Outputs):
  B0: LED A (result)
  B1: LED B (result)
  B2: LED C (result)
  B3: LED status (blink=thinking)

### MINT2 COMMANDS
DEMO        - Run 3 test cases
ORACLE      - Start interactive mode
TEST1       - Test AND function
TEST2       - Test XOR function
TEST3       - Test OR function
/RND        - Read random bit
/SAMPLE     - Charge P-bits
/READ       - Read P-bit states
/GIBBS      - Run one sampling step
/ENERGY     - Calculate error
/OUTPUT     - Update LED display

### TRUTH TABLE (All 16 Gates)
Gate  Name     00  01  10  11    Example
----  ----     --  --  --  --    -------
  0   FALSE    0   0   0   0     Always 0
  1   AND      0   0   0   1     A·B
  2   A&~B     0   0   1   0     A but not B
  3   A        0   0   1   1     Copy A
  4   ~A&B     0   1   0   0     B but not A
  5   B        0   1   0   1     Copy B
  6   XOR      0   1   1   0     A≠B
  7   OR       0   1   1   1     A+B
  8   NOR      1   0   0   0     ~(A+B)
  9   XNOR     1   0   0   1     A=B
 10   ~B       1   0   1   0     Not B
 11   A|~B     1   0   1   1     A or not B
 12   ~A       1   1   0   0     Not A
 13   ~A|B     1   1   0   1     Not A or B
 14   NAND     1   1   1   0     ~(A·B)
 15   TRUE     1   1   1   1     Always 1

### EXAMPLE PROBLEMS
1. Forward: "What is 1 AND 0?"
   Set: A=1(ON), B=0(ON), C=?(OFF), Gate=1
   Expect: C=0

2. Backward: "Find B where 1 XOR B = 1"
   Set: A=1(ON), B=?(OFF), C=1(ON), Gate=6
   Expect: B=0

3. Inverse: "What is NOT 1?"
   Set: A=1(ON), B=?(OFF), C=?(OFF), Gate=12
   Expect: C=0

4. Constraint: "Find inputs where NAND = 0"
   Set: A=?(OFF), B=?(OFF), C=0(ON), Gate=14
   Expect: A=1, B=1

### VOLTAGE CHECKS
Location          Expected     Meaning
--------          --------     -------
Avalanche out     0-5V vary    Noise working
RNG_BIT           0V or 9V     Digitized
P-bit cap         0-8V vary    Charging/discharging
Comparator ref    1.5V ±0.3V   Threshold
LED cathodes      0V           Ground OK
9V battery        >7V          Fresh enough

### COMMON ISSUES & FIXES
Problem: No noise activity
Fix: Check diode polarity (cathode to +V)

Problem: RNG stuck at one value
Fix: Adjust pot, or increase avalanche current

Problem: All P-bits same
Fix: Check for shorts between caps

Problem: Wrong answers
Fix: Verify truth table, check comparator threshold

Problem: Never solves
Fix: Increase Gibbs steps (edit :INFER, line 100)

Problem: LEDs don't change
Fix: Check Port B connections

### CALIBRATION VALUES
RNG pot: ~50% (midpoint)
Avalanche: 10kΩ load (adjust 4.7k-22k for noise)
P-bit charge: 1kΩ (faster = lower, slower = higher)
P-bit discharge: 10kΩ (faster = lower, slower = higher)
Comparator ref: 1.5V (use divider or zener)
LED resistors: 330Ω (dimmer = higher, brighter = lower)

### TIMING SPECS
Avalanche flip rate: 1-100 kHz
P-bit charge time: <50ms
P-bit discharge: ~10ms (τ=RC)
Gibbs step: ~50ms
Full inference: 1-5 seconds (20-100 steps)

### POWER BUDGET
Component         Current     Voltage     Power
---------         -------     -------     -----
TEC-1 Z80         200mA       5V          1.0W
Avalanche         1mA         9V          9mW
Comparators       4mA         9V          36mW
LEDs (all on)     60mA        5V          300mW
TOTAL (no TEC1):  ~265mA      9V/5V       ~1.3W
With Peltier:     +1-3A       12V         +12-36W

### EXPANSION CHECKLIST
For 8-neuron neural network:
- [ ] Add 4 more P-bits (caps + comparators)
- [ ] Add CD4051 mux for readout
- [ ] Expand h! array to [0 0 0 0 0 0 0 0]
- [ ] Add weight matrix w! (8×8 = 64 values)
- [ ] Implement :TRAIN (Hebbian: w_ij += x_i * x_j)
- [ ] Replace :LOOKUP with dot product
- [ ] Add pattern library (0,1,4,7 digits)
- [ ] Test pattern recall

### TESTING CHECKLIST
Phase 1: - [ ] Avalanche voltage varies
Phase 2: - [ ] RNG_BIT flips randomly
Phase 3: - [ ] Caps charge/discharge
Phase 4: - [ ] Comparators threshold at 1.5V
Phase 5: - [ ] Switches read correctly
Phase 5: - [ ] LEDs light on command
Phase 6: - [ ] All connections secure
Phase 7: - [ ] MINT2 code loads
Phase 8: - [ ] DEMO passes all tests
Phase 8: - [ ] ORACLE solves problems

### EMERGENCY FIXES
TEC-1 won't boot:
  - Disconnect tin (short to ground?)
  - Check power supply
  - Verify port connections not shorted

Smoke/smell:
  - Power off immediately
  - Check for shorts
  - Verify IC orientations
  - Check polarity of caps/diodes

Erratic behavior:
  - Check battery voltage (>7V)
  - Re-tune RNG pot
  - Cool down (thermal drift?)
  - Check for loose wires

### RESOURCES
Hardware spec: tec-pbit-oracle-hardware.txt
MINT2 code: tec-pbit-oracle-mint2.txt
Build guide: tec-pbit-build-guide.txt
tec-RANDOM repo: github.com/SteveJustin1963/tec-RANDOM

### PROJECT STATS
Components: 35
Solder joints: ~120
Build time: 4-6 hours
Code size: ~1200 bytes
Success rate: >90%
Cost: $12 (excluding TEC-1)

### ACHIEVEMENTS UNLOCKED
- [ ] Built quantum noise source
- [ ] Created P-bits from caps
- [ ] Ran Gibbs sampling on Z80
- [ ] Solved logic with physics
- [ ] Demonstrated stochastic computing
- [ ] Fit AI in Altoids tin
- [ ] Proved GPUs aren't always needed

## "Not all computation needs silicon. Sometimes physics is enough."
