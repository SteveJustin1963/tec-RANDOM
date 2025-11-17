# TEC-PBIT LOGIC ORACLE - BUILD GUIDE

**Practical Construction for TEC-1 Z80**

---


### PROJECT SUMMARY
A hardware probabilistic computer that solves boolean logic using:
- Real quantum noise (avalanche diode)
- Capacitor-based P-bits (probabilistic bits)
- MINT2 Gibbs sampling algorithm
- Path to 8-neuron neural network

Time to build: 4-6 hours
Cost: ~$12 (excluding TEC-1)
Difficulty: Intermediate (soldering, basic electronics)

## PHASE 1: AVALANCHE RNG (60 minutes)

OBJECTIVE: Build and test the noise source

### PARTS FOR THIS PHASE
- 1N4728A Zener diode (3.3V)
- 2× 2N3906 PNP transistors
- 1× 10kΩ resistor
- 1× 1kΩ resistor
- Small piece of perfboard (2cm × 3cm)
- 9V battery + clip

### CIRCUIT
```
    9V+ ────┬─── 10kΩ ─── [1N4728A Cathode]
            │                      │
            │                  Anode ── GND
            │                      │
            │                   Q1 Base (2N3906)
            │                   Q1 Emit ── 9V+
            │                   Q1 Coll ──┐
            │                              │
            │                          Q2 Base
            │                          Q2 Emit ── GND
            └──────────────────────── Q2 Coll = [NOISE_OUT]
```

### BUILD STEPS
1. IDENTIFY DIODE POLARITY:
   - Cathode has a line/band marking
   - This MUST connect to +9V through 10kΩ
   - Anode (no marking) to GND

2. IDENTIFY TRANSISTOR PINS (2N3906):
   - Flat side facing you: E-B-C (left to right)
   - E=Emitter, B=Base, C=Collector

3. SOLDER SEQUENCE:
   a) Diode: Cathode to one end of 10kΩ resistor
   b) 10kΩ other end to +9V rail
   c) Diode anode to GND rail
   d) Q1: Emitter to +9V, Base to diode anode
   e) Q2: Emitter to GND, Base to Q1 collector
   f) Leave Q2 collector wire long (this is output)

4. TEST:
   - Connect 9V battery
   - Measure voltage at Q2 collector with multimeter
   - Should fluctuate: 0-5V chaotically
   - NOT constant (if stuck, diode polarity is wrong)
   - NOT zero (if zero, transistor connections wrong)

### EXPECTED BEHAVIOR
- Voltage bounces around 2-3V
- Changes every few milliseconds
- No pattern visible

### TROUBLESHOOTING
Problem             Cause                   Fix
-------             -----                   ---
No voltage          Battery dead            Replace battery
Stuck at 9V         Diode backwards         Reverse diode
Stuck at 0V         Q2 Base not connected   Check Q1 Coll → Q2 Base
Steady voltage      Not in avalanche        Increase 10kΩ to 22kΩ
Weak noise          Low breakdown current   Decrease 10kΩ to 4.7kΩ

### PASS CRITERIA
- [x] Voltage varies continuously
- [x] Average around 2-3V
- [x] No stuck states for >1 second

## PHASE 2: RNG DIGITIZER (45 minutes)

OBJECTIVE: Convert analog noise to clean 0/1 bits

### PARTS FOR THIS PHASE
- LM393 comparator IC
- 100kΩ potentiometer
- 2× 10kΩ resistors
- Small capacitor 0.1µF (decoupling)
- Perfboard section

### CIRCUIT
```
    NOISE_OUT ─── 10kΩ ─── LM393 Pin 3 (+)
    
    9V+ ─── 100kΩ Pot ─┬─── LM393 Pin 2 (-)
                       │
                      GND
    
    LM393 Pin 1 (OUT) ──> [RNG_BIT] ──> To TEC-1
    LM393 Pin 8 ── 9V+
    LM393 Pin 4 ── GND
    Pin 8 to Pin 4: 0.1µF cap (near IC)
```

### BUILD STEPS
1. SOCKET THE IC (recommended):
   - Use 8-pin DIP socket
   - Solves "did I fry the IC?" problems

2. POWER CONNECTIONS:
   - Pin 8 to +9V rail (top right)
   - Pin 4 to GND rail (bottom right)
   - Solder 0.1µF cap between these pins (CLOSE to IC)

3. INPUT CONNECTIONS:
   - NOISE_OUT from Phase 1 → 10kΩ → Pin 3
   - 10kΩ other end to GND (pull-down)

4. THRESHOLD SETUP:
   - 9V+ to pot terminal 1
   - GND to pot terminal 3
   - Pot wiper (terminal 2) to Pin 2

5. OUTPUT:
   - Pin 1 to long wire (will connect to TEC-1 later)

### TEST
1. With multimeter on Pin 1 (output):
   - Should see 0V or 9V (clean digital)
   - Should flip occasionally (1-100 Hz)

2. Tune potentiometer:
   - Turn until flipping is frequent
   - ~50% duty cycle (equal time high/low)
   - This sets your bias point

3. Frequency test:
   - Connect LED + 330Ω resistor to Pin 1
   - LED should flicker randomly
   - Not too fast (>100Hz = invisible)
   - Not too slow (<1Hz = boring)

### PASS CRITERIA
- [x] Clean 0/9V output (no analog voltages)
- [x] Visible random flickering on LED
- [x] Pot adjustment changes flicker rate

## PHASE 3: P-BIT STORAGE (90 minutes)

OBJECTIVE: Build 4 capacitor-based probabilistic bits

### PARTS FOR THIS PHASE
- 4× 1µF capacitors (electrolytic or ceramic)
- 4× 10kΩ resistors (discharge)
- 4× 1kΩ resistors (charge limit)
- 4× 1N4148 diodes (rectifier)
- 4× 2N3904 NPN transistors (drivers)
- Perfboard section

### CONCEPT
Each P-bit is a capacitor that:
- Charges when RNG_BIT pulses high
- Discharges slowly through 10kΩ
- State = voltage > threshold (1.5V)

CIRCUIT (repeat 4×):
```
    RNG_BIT ─── 1kΩ ─── Diode ─┬─── [CAP+] 1µF ─── 10kΩ ─── GND
                                │
                            To comparator/TEC-1
```

### BUILD STEPS
1. LAYOUT:
   - 4 P-bits in a row on perfboard
   - Label: A, B, C, Spare
   - Keep spacing consistent (~2cm apart)

2. PER P-BIT:
   a) Solder 1µF cap: + leg up, - leg to GND rail
   b) Solder 10kΩ from cap+ to GND (slow discharge)
   c) Solder diode anode to RNG_BIT line
   d) Solder diode cathode through 1kΩ to cap+
   e) Leave wire from cap+ for readout

3. COMMON CONNECTIONS:
   - All cap negative legs → GND rail
   - All 1kΩ charge resistors → common RNG_BIT line
   - RNG_BIT line → from Phase 2 output

4. CHARGE DRIVER (optional, improves reliability):
   ```
   RNG_BIT → NPN Base (through 1kΩ)
   NPN Collector → 9V+
   NPN Emitter → to all 1kΩ charge resistors
   ```
   This boosts drive current for fast charging

### TEST
1. Charge test (per P-bit):
   - Apply 9V to RNG_BIT line (simulate pulse)
   - Measure cap voltage: should rise to ~8V
   - Time: <50ms
   
2. Discharge test:
   - Remove 9V
   - Measure cap voltage: should decay
   - Time constant: ~10ms (10kΩ × 1µF)
   
3. Random test:
   - Connect RNG_BIT to Phase 2 output
   - Measure all 4 caps with multimeter
   - Should see random voltages 0-8V
   - Should change when poked/vibrated

### CALIBRATION
- If caps charge too slow: Reduce 1kΩ to 470Ω
- If caps discharge too fast: Increase 10kΩ to 22kΩ
- If all caps same voltage: RNG not working (recheck Phase 2)

### PASS CRITERIA
- [x] Each cap can charge to >7V
- [x] Each cap discharges in ~10-50ms
- [x] Voltages differ randomly across 4 caps

## PHASE 4: DIGITAL INTERFACE (60 minutes)

OBJECTIVE: Connect P-bits to TEC-1 as digital inputs

### PARTS FOR THIS PHASE
- 4× LM393 comparators (or 2× LM393 dual ICs)
- 4× 10kΩ resistors (reference divider)
- Ribbon cable (8-wire)
- Pin header (connect to TEC-1)

### WHY NEEDED
TEC-1 has no ADC, so we threshold each cap voltage:
- Voltage > 1.5V → output 1
- Voltage < 1.5V → output 0

CIRCUIT (per P-bit):
```
    CAP+ ────────────────── Comparator (+)
    
    9V+ ─── 10kΩ ─┬─ 1.5V ─ Comparator (-)
                  │
                 10kΩ
                  │
                 GND
                 
    Comparator OUT ──> TEC-1 port D bit
```

### BUILD STEPS
1. REFERENCE VOLTAGE (1.5V):
   - Use 2× 10kΩ in series between 9V and GND
   - Midpoint = 4.5V (too high)
   - Use 3× 10kΩ: 9V - 10k - 10k - 10k - GND
   - Tap at first 10k: 9V × (20k/30k) = 6V (still high)
   - BETTER: Use 5.1V Zener + 10kΩ divider = 2.55V
   - OR: Just use 1.5V directly from TEC-1 if available

2. SIMPLE SOLUTION (if TEC-1 has 3.3V or 5V rail):
   ```
   3.3V ─── 10kΩ ─┬─ 1.65V ─ Comparator (-)
                  │
                 10kΩ
                  │
                 GND
   ```

3. CONNECT 4 COMPARATORS:
   - IC 1: Handles A and B
   - IC 2: Handles C and Spare
   - All share same 1.5V reference
   - All outputs go to ribbon cable

4. TEC-1 INTERFACE:
   - D0: RNG_BIT input
   - D1: P-bit A state
   - D2: P-bit B state  
   - D3: P-bit C state
   - D4: P-bit Spare state
   - D5-D8: Reserved for switches

### TEST
1. Static test:
   - Charge a cap to 3V (above threshold)
   - Comparator output should be HIGH
   - Discharge cap to 1V (below threshold)
   - Comparator output should be LOW

2. Dynamic test:
   - Let RNG run
   - Watch comparator outputs with LEDs
   - Should see random flickering
   - All 4 should be independent

### PASS CRITERIA
- [x] Comparator outputs are 0V or 5V (clean digital)
- [x] Threshold at ~1.5V (adjust if needed)
- [x] Outputs follow cap voltage correctly

## PHASE 5: INPUT/OUTPUT (45 minutes)

OBJECTIVE: Add switches and LEDs for user interaction

### PARTS FOR THIS PHASE
- 4× SPST switches (DIP switch package ideal)
- 4× LEDs (red, 5mm)
- 4× 330Ω resistors (LED current limit)
- Ribbon cable to TEC-1

### SWITCH WIRING
```
For each switch:
    TEC-1 GPIO ───┬─── Switch ─── GND
                  │
                 10kΩ (pull-up)
                  │
                 5V
                 
When pressed: GPIO reads 0 (pulled to GND)
When open: GPIO reads 1 (pulled up to 5V)
```

### LED WIRING
```
For each LED:
    TEC-1 GPIO ─── 330Ω ─── LED Anode
                            LED Cathode ─── GND
                            
When GPIO high: LED lights
When GPIO low: LED off
```

### ASSIGNMENT
- Switch A (D5): Clamp input A
- Switch B (D6): Clamp input B
- Switch C (D7): Clamp output C
- Switch Gate (D8): Gate select bit 0 (expand to 4 bits for full 16 gates)

- LED A (B0): Show A result
- LED B (B1): Show B result
- LED C (B2): Show C result
- LED Status (B3): Blink during inference

### BUILD STEPS
1. Mount DIP switches on lid of Altoids tin
2. Drill holes for LEDs next to switches
3. Wire switches with pull-ups to ribbon cable
4. Wire LEDs with resistors to ribbon cable
5. Connect ribbon cable to TEC-1 port headers

### TEST
- Press switch → TEC-1 should read 0
- Release switch → TEC-1 should read 1
- Set GPIO high → LED should light
- Set GPIO low → LED should turn off

## PHASE 6: FINAL INTEGRATION (60 minutes)

OBJECTIVE: Assemble complete system in Altoids tin

### LAYOUT
Base of tin (bottom up):
1. TEC1-12706 Peltier (optional, for thermal stability)
2. Perfboard with all circuits
3. 9V battery compartment

Lid of tin:
1. 4× switches
2. 4× LEDs  
3. Label strip

### ASSEMBLY
1. MOUNT PELTIER (if using):
   - Apply thermal paste to cold side
   - Stick copper tape to cold side
   - Mount avalanche circuit on copper
   - Heatsink + fan on hot side (outside tin)

2. SECURE PERFBOARD:
   - Use standoffs or hot glue
   - Keep away from tin walls (short risk)
   - Avalanche section near Peltier cold side

3. WIRE MANAGEMENT:
   - Ribbon cable exits tin through slot
   - Strain relief with cable tie
   - Label each wire (D0-D8, B0-B3)

4. POWER:
   - 9V battery in corner
   - Clip accessible for replacement
   - Switch on power line (optional)

5. LID:
   - Drill 8 holes (4 switches, 4 LEDs)
   - Label with permanent marker:
     [A] [B] [C] [G] | (A) (B) (C) (*)
   - Test fit before final assembly

CABLE CONNECTIONS TO TEC-1:

Pin  Signal       Function
---  ------       --------
D0   RNG_BIT      Random input from avalanche
D1   PBIT_A       P-bit A state
D2   PBIT_B       P-bit B state
D3   PBIT_C       P-bit C state
D4   PBIT_SPARE   P-bit spare state
D5   SW_A         Clue: A is known
D6   SW_B         Clue: B is known
D7   SW_C         Clue: C is known
D8   SW_GATE      Gate select (LSB)
B0   LED_A        Output A display
B1   LED_B        Output B display
B2   LED_C        Output C display
B3   LED_STATUS   Status indicator

## PHASE 7: SOFTWARE UPLOAD (30 minutes)

OBJECTIVE: Upload MINT2 code to TEC-1

### PROCESS
1. Connect TEC-1 to terminal (serial or keyboard+display)

2. Reset TEC-1, enter MINT2 mode

3. Upload chunks 1-7 from tec-pbit-oracle-mint2.txt
   - Type each chunk exactly as written
   - Wait for ">" prompt before next chunk
   - MINT2 will echo and compile

4. After chunk 7, you should see:
   ```
   Test functions ready
   Type DEMO to test
   Type ORACLE to run
   >
   ```

5. Type: DEMO
   - Runs 3 test cases
   - Verifies hardware connections
   - Should see LEDs flash during tests

6. Type: ORACLE
   - Enters interactive mode
   - Set switches for your problem
   - Press any key to start inference
   - Watch LEDs settle to solution

## PHASE 8: TESTING & CALIBRATION (60 minutes)

### TEST 1: RNG QUALITY
Objective: Verify entropy source is working

1. Run MINT2 command: /RND
2. Should return different values each time
3. Run 100 times, count 0s and 1s
4. Expect: 40-60 of each (within 20% of 50/50)

If too biased: Adjust pot in Phase 2

### TEST 2: P-BIT INDEPENDENCE
Objective: Verify caps aren't coupled

1. Read all 4 P-bit states repeatedly
2. Should see different random patterns
3. Not all same (shorted)
4. Not correlated (coupling)

If coupled: Check for accidental shorts on perfboard

### TEST 3: LOGIC FUNCTIONS
Objective: Test all 16 boolean functions

For each gate (0-15):
1. Set A=0, B=0, Gate=g, run inference
2. Record output C
3. Repeat for A=0,B=1 / A=1,B=0 / A=1,B=1
4. Compare to truth table

Expected results:
Gate 1 (AND): 0,0->0  0,1->0  1,0->0  1,1->1
Gate 6 (XOR): 0,0->0  0,1->1  1,0->1  1,1->0
Gate 7 (OR):  0,0->0  0,1->1  1,0->1  1,1->1
etc.

Accuracy: >90% correct (some noise expected)

### TEST 4: CONVERGENCE SPEED
Objective: Measure solve time

1. Set up simple problem (e.g., 1 AND 1 = ?)
2. Time from keypress to solution
3. Expect: 1-5 seconds
4. If timeout: Increase /SAMPLE count or /GIBBS steps

### TEST 5: BACKWARD INFERENCE
Objective: Test constraint satisfaction

1. Set A=?, B=?, C=0, Gate=AND
2. Run inference
3. Expect: A=0 and B=(0 or 1), or A=(0 or 1) and B=0
4. Many valid solutions, should find one

## TROUBLESHOOTING GUIDE

SYMPTOM: No random activity, LEDs stuck
CAUSE: RNG not working
FIX: Check Phase 1-2, verify NOISE_OUT voltage varies

SYMPTOM: All P-bits always same value
CAUSE: Caps shorted together or to rail
FIX: Check for solder bridges, verify isolation

SYMPTOM: Wrong answers
CAUSE: Threshold voltage off, or truth table bug
FIX: Measure comparator reference, should be 1.5V ±0.3V

SYMPTOM: Never converges, timeout
CAUSE: Too much noise, or not enough Gibbs steps
FIX: Increase :GIBBS step count to 50 or 100

SYMPTOM: LEDs don't update
CAUSE: /OUTPUT function not being called, or port B not connected
FIX: Check TEC-1 port B wiring, verify with simple LED test

SYMPTOM: Switches don't work
CAUSE: Port D input not being read, or switches wired backwards
FIX: Test with multimeter, should read 0V when pressed

SYMPTOM: Solution wrong but consistent
CAUSE: Truth table bug in MINT2 code
FIX: Verify TABLE array in Chunk 2, check indexing math

## PERFORMANCE METRICS

### EXPECTED SPECIFICATIONS
- Entropy rate: 1-100 kbps
- Entropy quality: ~73/100 (chi-square test)
- Inference time: 1-5 seconds
- Accuracy: >90% for valid problems
- Power: 200-300mA @ 5V (without Peltier)
- Power: 1-1.5A @ 12V (with Peltier)

If your build doesn't meet these, revisit calibration steps.

## NEXT STEPS: NEURAL NETWORK EXPANSION

Once logic oracle is working, expand to 8-neuron network:

### HARDWARE
- Add 4 more P-bits (duplicate Phase 3)
- Add CD4051 8-to-1 mux for efficient readout
- Expand comparator section

### SOFTWARE
- Expand h! array to 8 elements
- Add w! array (8×8 = 64 weights)
- Implement :TRAIN function (Hebbian)
- Replace :LOOKUP with matrix multiply
- Add pattern storage and recall

See tec-pbit-neural.txt for full neural implementation.

## CONCLUSION

You now have a working probabilistic computer that:
- [x] Uses real quantum noise
- [x] Solves boolean logic via physics
- [x] Runs MINT2 Gibbs sampling
- [x] Cost <$15
- [x] Fits in an Altoids tin
- [x] Demonstrates P-bit computing

This is not a toy. This is a functional demonstration of:
- Stochastic computing
- Simulated annealing
- Ising model minimization
- Hardware random number generation
- Thermodynamic computing principles

Share your build! Document your tests! This proves that AI doesn't need
massive GPUs - sometimes physics and clever algorithms are enough.

==============================================================================
