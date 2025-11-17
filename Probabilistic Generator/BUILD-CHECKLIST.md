# TEC-PBIT BUILD CHECKLIST

**Print this page and check off as you progress**

---


PROJECT: TEC-PBIT Logic Oracle + Neural Network
BUILDER: ____________________
START DATE: ____ / ____ / ____
TARGET COMPLETION: ____ / ____ / ____

## PRE-BUILD PREPARATION

### DOCUMENTATION
- [ ] Read README.txt (understand file structure)
- [ ] Read tec-pbit-project-overview.txt (big picture)
- [ ] Read tec-pbit-oracle-hardware.txt (circuits)
- [ ] Read tec-pbit-build-guide.txt (assembly steps)
- [ ] Print tec-pbit-quick-ref.txt (keep handy)
- [ ] Print this checklist

### WORKSPACE
- [ ] Clean, well-lit work area
- [ ] Soldering iron + solder
- [ ] Multimeter (required!)
- [ ] Wire strippers/cutters
- [ ] Small screwdriver set
- [ ] ESD mat or wrist strap
- [ ] Good ventilation
- [ ] Coffee/tea/beverage ready

### COMPONENTS ORDERED
- [ ] 1× 1N4728A Zener diode (3.3V)
- [ ] 2× 2N3906 PNP transistors
- [ ] 2× LM393 comparator (dual)
- [ ] 4× 1µF capacitors
- [ ] 20× 10kΩ resistors
- [ ] 8× 1kΩ resistors
- [ ] 4× 330Ω resistors (LED)
- [ ] 1× 100kΩ potentiometer
- [ ] 4× SPST switches
- [ ] 4× Red LEDs (5mm)
- [ ] 8× 1N4148 diodes
- [ ] 1× Perfboard (5×7 cm)
- [ ] 1× Altoids tin
- [ ] 1× 9V battery + clip
- [ ] Hookup wire (22 AWG)
- [ ] Ribbon cable (10 wire)

### FOR NEURAL EXTENSION
- [ ] 4× Additional 1µF caps
- [ ] 1× CD4051 analog mux
- [ ] 8× Additional 10kΩ resistors

### OPTIONAL
- [ ] 1× TEC1-12706 Peltier (cooling)
- [ ] 1× Small heatsink + fan
- [ ] 1× Piezo buzzer

TEC-1 SYSTEM:
- [ ] TEC-1 Z80 SBC working
- [ ] MINT2 loaded and tested
- [ ] Serial/keyboard interface working
- [ ] Power supply adequate (500mA+)

## PHASE 1: AVALANCHE RNG (Target: 60 minutes)

START TIME: ___:___   END TIME: ___:___   ACTUAL: ___ min

### ASSEMBLY
- [ ] Identify 1N4728A polarity (cathode marked)
- [ ] Identify 2N3906 pinout (E-B-C)
- [ ] Solder 10kΩ resistor
- [ ] Solder diode (cathode to resistor)
- [ ] Solder Q1 (emitter to +9V)
- [ ] Solder Q2 (emitter to GND)
- [ ] Connect Q1 collector to Q2 base
- [ ] Leave Q2 collector wire long (output)
- [ ] Check all joints for cold solder

### TESTING
- [ ] Multimeter on Q2 collector
- [ ] Voltage fluctuates 0-5V
- [ ] NOT stuck at 0V or 9V
- [ ] Changes every few milliseconds
- [ ] Average around 2-3V

PASS: - [ ] YES   - [ ] NO
IF NO, ISSUE: _________________________________

## PHASE 2: RNG DIGITIZER (Target: 45 minutes)

START TIME: ___:___   END TIME: ___:___   ACTUAL: ___ min

### ASSEMBLY
- [ ] Socket LM393 (recommended)
- [ ] Connect Pin 8 to +9V (power)
- [ ] Connect Pin 4 to GND (ground)
- [ ] Solder 0.1µF cap Pin 8-Pin 4
- [ ] Wire NOISE_OUT to Pin 3 via 10kΩ
- [ ] Wire pot: 9V to terminal 1
- [ ] Wire pot: GND to terminal 3
- [ ] Wire pot wiper to Pin 2
- [ ] Leave Pin 1 wire long (RNG_BIT output)

### TESTING
- [ ] Pin 1 reads 0V OR 9V (not analog)
- [ ] Flickers when watched
- [ ] LED test shows random blinking
- [ ] Pot adjustment changes rate
- [ ] Settles to ~50% duty cycle

### CALIBRATION
- [ ] Tune pot for maximum flicker
- [ ] Aim for ~50-100 Hz visible rate

PASS: - [ ] YES   - [ ] NO
IF NO, ISSUE: _________________________________

## PHASE 3: P-BIT STORAGE (Target: 90 minutes)

START TIME: ___:___   END TIME: ___:___   ACTUAL: ___ min

ASSEMBLY (repeat 4×):
P-bit A:
- [ ] Solder 1µF cap (+ leg up)
- [ ] Solder 10kΩ cap+ to GND
- [ ] Solder 1N4148 (cathode to cap+)
- [ ] Solder 1kΩ diode anode to RNG_BIT
- [ ] Label "A"

P-bit B:
- [ ] Same as A, label "B"

P-bit C:
- [ ] Same as A, label "C"

P-bit Spare:
- [ ] Same as A, label "Spare"

### COMMON WIRING
- [ ] All cap negative → GND rail
- [ ] All 1kΩ resistors → common RNG_BIT line
- [ ] RNG_BIT line to Phase 2 output

TESTING (per P-bit):
- [ ] Apply 9V to RNG_BIT line
- [ ] Cap charges to >7V
- [ ] Charging time <50ms
- [ ] Remove 9V
- [ ] Cap discharges via 10kΩ
- [ ] Decay time ~10-50ms
- [ ] Repeat for all 4 P-bits

### DYNAMIC TEST
- [ ] Connect RNG_BIT to Phase 2
- [ ] All 4 caps show random voltages
- [ ] Voltages differ (not shorted)
- [ ] Change when shaken/tapped

PASS: - [ ] YES   - [ ] NO
IF NO, ISSUE: _________________________________

## PHASE 4: DIGITAL INTERFACE (Target: 60 minutes)

START TIME: ___:___   END TIME: ___:___   ACTUAL: ___ min

ASSEMBLY (4× comparators for P-bits):
- [ ] Socket 2× LM393 (8 comparators total)
- [ ] Power all: Pin 8 → +9V, Pin 4 → GND
- [ ] Decouple all: 0.1µF caps
- [ ] Wire cap A+ to Comparator 1 Pin 3
- [ ] Wire cap B+ to Comparator 2 Pin 3
- [ ] Wire cap C+ to Comparator 3 Pin 3
- [ ] Wire cap Spare+ to Comparator 4 Pin 3

REFERENCE VOLTAGE (1.5V):
- [ ] Build divider: 3.3V - 10k - 10k - GND
- [ ] OR use Zener + divider
- [ ] Measure: _____ V (target 1.5V ±0.3V)
- [ ] Wire to all comparator Pin 2 (-)

### OUTPUTS
- [ ] Comparator 1 out → PBIT_A line
- [ ] Comparator 2 out → PBIT_B line
- [ ] Comparator 3 out → PBIT_C line
- [ ] Comparator 4 out → PBIT_SPARE line

### TESTING
- [ ] Charge cap to 3V
- [ ] Comparator output = HIGH (9V)
- [ ] Discharge cap to 1V
- [ ] Comparator output = LOW (0V)
- [ ] Repeat for all 4

### DYNAMIC TEST
- [ ] Let RNG run
- [ ] All comparator outputs flicker 0/9V
- [ ] Independent (not synchronized)
- [ ] LED test confirms random pattern

PASS: - [ ] YES   - [ ] NO
IF NO, ISSUE: _________________________________

## PHASE 5: INPUT/OUTPUT (Target: 45 minutes)

START TIME: ___:___   END TIME: ___:___   ACTUAL: ___ min

SWITCHES (4×):
- [ ] Mount switches on tin lid
- [ ] Wire switch A to SW_A line
- [ ] Wire switch B to SW_B line
- [ ] Wire switch C to SW_C line
- [ ] Wire switch Gate to SW_GATE line
- [ ] Add 10kΩ pull-ups to all (to +5V)
- [ ] Switches pull to GND when pressed

LEDS (4×):
- [ ] Drill holes in tin lid
- [ ] Wire LED A: anode via 330Ω to LED_A line
- [ ] Wire LED B: anode via 330Ω to LED_B line
- [ ] Wire LED C: anode via 330Ω to LED_C line
- [ ] Wire LED Status: anode via 330Ω to LED_STATUS
- [ ] All cathodes to GND

### TESTING
- [ ] Press switch → line reads LOW (0V)
- [ ] Release switch → line reads HIGH (5V)
- [ ] Apply 5V to LED line → LED lights
- [ ] Remove 5V → LED off
- [ ] Repeat for all switches/LEDs

PASS: - [ ] YES   - [ ] NO
IF NO, ISSUE: _________________________________

## PHASE 6: FINAL INTEGRATION (Target: 60 minutes)

START TIME: ___:___   END TIME: ___:___   ACTUAL: ___ min

### TIN ASSEMBLY
- [ ] Mount perfboard in base
- [ ] Secure with standoffs or glue
- [ ] Route wires to lid (switches/LEDs)
- [ ] 9V battery in corner
- [ ] Strain relief on ribbon cable

### OPTIONAL PELTIER
- [ ] Thermal paste on cold side
- [ ] Mount avalanche circuit on cold side
- [ ] Heatsink + fan on hot side
- [ ] 12V power separate from 9V
- [ ] Test: cold side gets cool

RIBBON CABLE TO TEC-1:
Pin  Signal        From
---  ------        ----
 1   GND           Common ground
 2   RNG_BIT       Phase 2 output
 3   PBIT_A        Comparator 1 out
 4   PBIT_B        Comparator 2 out
 5   PBIT_C        Comparator 3 out
 6   SW_A          Switch A
 7   SW_B          Switch B
 8   SW_C          Switch C
 9   LED_A         To TEC-1 B0
10   LED_B         To TEC-1 B1
11   LED_C         To TEC-1 B2
12   LED_STATUS    To TEC-1 B3

- [ ] All connections secure
- [ ] No shorts (multimeter check)
- [ ] Cable labeled
- [ ] Strain relief adequate

### POWER TEST
- [ ] Battery installed
- [ ] Turn on power
- [ ] Check voltages:
   - 9V rail: _____ V
   - 5V rail: _____ V  
   - 3.3V rail: _____ V
- [ ] No smoke, smell, or heat
- [ ] All ICs cool to touch
- [ ] LEDs can be lit (test)

PASS: - [ ] YES   - [ ] NO
IF NO, ISSUE: _________________________________

## PHASE 7: SOFTWARE UPLOAD (Target: 30 minutes)

START TIME: ___:___   END TIME: ___:___   ACTUAL: ___ min

MINT2 UPLOAD:
- [ ] Connect TEC-1 to terminal
- [ ] Reset TEC-1, enter MINT2
- [ ] Upload Chunk 1 (Variables)
- [ ] Wait for ">" prompt
- [ ] Upload Chunk 2 (Truth tables)
- [ ] Wait for ">" prompt
- [ ] Upload Chunk 3 (Hardware interface)
- [ ] Wait for ">" prompt
- [ ] Upload Chunk 4 (Energy functions)
- [ ] Wait for ">" prompt
- [ ] Upload Chunk 5 (Gibbs sampling)
- [ ] Wait for ">" prompt
- [ ] Upload Chunk 6 (Main oracle)
- [ ] Wait for ">" prompt
- [ ] Upload Chunk 7 (Test functions)
- [ ] See: "Type DEMO to test"

### VERIFICATION
- [ ] No syntax errors during upload
- [ ] All variables defined
- [ ] All functions defined
- [ ] MINT2 responds to commands

PASS: - [ ] YES   - [ ] NO
IF NO, ISSUE: _________________________________

## PHASE 8: TESTING & CALIBRATION (Target: 60 minutes)

START TIME: ___:___   END TIME: ___:___   ACTUAL: ___ min

TEST 1: DEMO
- [ ] Type: DEMO
- [ ] Test 1 runs (1 AND ? = 0)
   Expected: B=0
   Actual: B=___
- [ ] Test 2 runs (? XOR 1 = 1)
   Expected: A=0
   Actual: A=___
- [ ] Test 3 runs (1 OR 1 = ?)
   Expected: C=1
   Actual: C=___

PASS: - [ ] YES (2-3 correct)   - [ ] NO (0-1 correct)

TEST 2: LOGIC GATES (Sample)
Gate  A  B  Expected C  Actual C  Pass?
----  -  -  ----------  --------  -----
 1    0  0      0         ___      - [ ]
 1    0  1      0         ___      - [ ]
 1    1  0      0         ___      - [ ]
 1    1  1      1         ___      - [ ]
 6    0  0      0         ___      - [ ]
 6    0  1      1         ___      - [ ]
 6    1  0      1         ___      - [ ]
 6    1  1      0         ___      - [ ]
 7    0  0      0         ___      - [ ]
 7    0  1      1         ___      - [ ]
 7    1  0      1         ___      - [ ]
 7    1  1      1         ___      - [ ]

PASS: - [ ] YES (>10/12 correct)   - [ ] NO

TEST 3: CONVERGENCE SPEED
- [ ] Simple problem: 1 AND 1 = ?
- [ ] Time to solution: _____ seconds
- [ ] Expect: 1-5 seconds
- [ ] Within range?

TEST 4: BACKWARD INFERENCE
- [ ] Problem: ? AND ? = 0
- [ ] Solution found: A=___ B=___
- [ ] Valid? (A=0 OR B=0)

CALIBRATION (if needed):
- [ ] RNG too biased → Adjust pot
- [ ] Caps not charging → Reduce 1kΩ
- [ ] Timeout often → Increase Gibbs steps
- [ ] Wrong answers → Check threshold voltage

### FINAL MEASUREMENTS
- [ ] RNG entropy: ____ /100 (expect >70)
- [ ] Solve accuracy: ____ % (expect >90)
- [ ] Average time: ____ seconds (expect 1-5)
- [ ] Power draw: ____ mA (expect <500)

PASS: - [ ] YES   - [ ] NO
IF NO, ISSUE: _________________________________

## LOGIC ORACLE: COMPLETE!

DATE COMPLETED: ____ / ____ / ____
TOTAL BUILD TIME: _____ hours
FINAL STATUS: - [ ] WORKING   - [ ] NEEDS DEBUG

### NOTES / ISSUES / MODIFICATIONS
_____________________________________________________________
_____________________________________________________________
_____________________________________________________________

## NEURAL EXTENSION (Optional)

### START DATE: ____ / ____ / ____

HARDWARE
- [ ] Add 4 more P-bits (same as Phase 3)
- [ ] Add CD4051 mux IC
- [ ] Wire mux inputs to all 8 P-bits
- [ ] Wire mux select to TEC-1 B4-B6
- [ ] Wire mux output to TEC-1 D1
- [ ] Test mux: all neurons readable

### SOFTWARE
- [ ] Upload Chunk 8 (Neural init)
- [ ] Upload Chunk 9 (Mux I/O)
- [ ] Upload Chunk 10 (Neural energy)
- [ ] Upload Chunk 11 (Hebbian training)
- [ ] Upload Chunk 12 (Pattern recall)
- [ ] Upload Chunk 13 (Neural demo)

### TESTING
- [ ] Type: NDEMO
- [ ] Test 1: Pattern completion
   Input: [1 0 1 0 ? ? ? ?]
   Output: [1 0 1 0 ___ ___ ___ ___]
- [ ] Test 2: Classification
   Input: Noisy pattern
   Class: ___
- [ ] Accuracy: ____ % (expect >70)

PASS: - [ ] YES   - [ ] NO

DATE COMPLETED: ____ / ____ / ____

## PROJECT COMPLETE!

### ACHIEVEMENTS UNLOCKED
- [ ] Built quantum noise source
- [ ] Created P-bits from capacitors
- [ ] Implemented Gibbs sampling on Z80
- [ ] Solved logic probabilistically
- [ ] Demonstrated stochastic computing
- [ ] Fit AI in an Altoids tin
- [ ] Proved GPUs aren't always needed
- [ ] Learned something awesome!

TOTAL TIME: _____ hours
TOTAL COST: $_____ 
SUCCESS RATE: _____ %

### NEXT STEPS
- [ ] Document build (photos, blog, video)
- [ ] Share on GitHub / Hackaday / Reddit
- [ ] Try custom applications
- [ ] Scale to 16/32 neurons
- [ ] Teach others to build
- [ ] Inspire next generation!

### FINAL THOUGHTS
_____________________________________________________________
_____________________________________________________________
_____________________________________________________________
_____________________________________________________________

==============================================================================

Congratulations! You've built a working probabilistic computer that
demonstrates cutting-edge AI principles using vintage hardware and
quantum physics. This is real engineering, real science, genuinely cool.

Now share it with the world and inspire others!

==============================================================================
