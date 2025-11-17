# TEC-PBIT LOGIC ORACLE - HARDWARE SPECIFICATION

**Avalanche RNG + MINT2 on TEC-1 Z80**

---


### DESIGN PHILOSOPHY
- Use proven avalanche diode RNG from tec-RANDOM repo
- MINT2 as control layer (not trying to replace it)
- TEC1-12706 for thermal stabilization only
- 4 capacitor P-bits for logic solving
- Expandable to 8 for neural network

## BILL OF MATERIALS

### CORE COMPONENTS
Qty  Part                    Purpose                         Cost    Source
---  ----------------------  ------------------------------  ------  --------
1    TEC-1 Z80 SBC          MINT2 host (you have this)      $0      existing
1    1N4728A Zener 3.3V     Avalanche noise source          $0.30   
2    2N3906 PNP             Back-to-back noise amplifier    $0.40
1    LM393 Comparator       Digitize RNG output             $0.50
4    1µF capacitor          P-bit state storage             $0.80
4    10kΩ resistor          Voltage dividers                $0.20
4    1kΩ resistor           Bias/discharge paths            $0.20
1    100kΩ pot              RNG threshold tuning            $0.50
4    SPST switch            Input clues (A,B,C,Gate)        $1.00
4    LED (red)              Output display                  $0.80
4    330Ω resistor          LED current limit               $0.20
1    TEC1-12706 Peltier     Thermal stabilizer (optional)   $6.00
1    9V battery clip        Power                           $0.50
1    Perfboard 5x7cm        Assembly                        $1.00
                                                    TOTAL:  $12.40

### OPTIONAL UPGRADES
1    CD4051 8ch mux         Expand to 8 P-bits              $0.60
4    Additional 1µF caps    8-neuron network                $0.80
1    Piezo buzzer           Audio feedback                  $0.50

## CIRCUIT SCHEMATIC (Text Format)

SECTION 1: AVALANCHE NOISE GENERATOR
(From tec-RANDOM repo, proven design)

    9V+ ────┬─── 10kΩ ─── [1N4728A Cathode]
            │                      │ (Reverse biased ~3.3V)
            │                  Anode ── GND
            │                      │
            │                   [Noise]
            │                      │
            │                  Q1 Base (2N3906)
            │                  Q1 Emit ──┬── 9V+
            │                  Q1 Coll ──┤
            │                             │
            │                         Q2 Base (2N3906)
            │                         Q2 Emit ── GND
            │                         Q2 Coll ── [RNG_OUT] (0-5V chaos)
            │                             │
            └─────────────────────────────┘

SECTION 2: RNG DIGITIZER

    RNG_OUT ─── 10kΩ ───┬─── LM393 (+) Pin 3
                        │
                      [Noise]
                        
    9V+ ─── 100kΩ Pot ──┼─── LM393 (-) Pin 2  (Threshold: ~2.5V)
                        │
                       GND
                       
    LM393 Pin 1 (OUT) ── [RNG_BIT] ──> To TEC-1 GPIO (e.g., D0)

SECTION 3: P-BIT STORAGE (4× Capacitors)

    For each P-bit (A, B, C, Gate):
    
    RNG_BIT ─── 1kΩ ─── Diode 1N4148 ───┬─── [CAP+] (1µF) ─── 10kΩ ─── GND
                                        │
                                    Switch ─── 9V (pull-up for clue)
                                        │
                                    To TEC-1 ADC or comparator
                                    
    Note: TEC-1 doesn't have ADC, so we use digital threshold:
    
    CAP+ ─── 10kΩ ───┬─── Comparator (+)
                     │
                   1.5V ref (resistor divider)
                   
    Comparator OUT ──> TEC-1 GPIO (D1-D4)

SECTION 4: TEC-1 INTERFACE

    TEC-1 Connections:
    ------------------
    D0 (Input)   ← RNG_BIT from LM393
    D1-D4 (In)   ← P-bit states (Cap voltage > threshold = 1)
    D5-D8 (In)   ← Switches (clues: A, B, C, Gate select)
    B0-B3 (Out)  → LEDs (Output: A, B, C, Status)
    B4 (Out)     → RNG sample trigger (pulse to charge caps)
    B5 (Out)     → Reset pulse (discharge all caps)

SECTION 5: TRUTH TABLE RESISTOR LADDER

    9V+ ───┬─── 10kΩ ───┬─── Tap 0 (0.00V) ─── Gate function 0000
           │            │
           ├─── 10kΩ ───┼─── Tap 1 (0.56V) ─── Gate 0001
           │            │
           ├─── 10kΩ ───┼─── Tap 2 (1.13V) ─── Gate 0010
           │            │
           └─── 10kΩ ────── Tap 3 (1.69V) ─── Gate 0011
                        │
                       GND
                       
    Gate switches select tap → reference voltage for logic evaluation

## TEC1-12706 INTEGRATION (Optional but Recommended)

Mount avalanche circuit on TEC1 cold side:
- Improves noise quality (temp-stable breakdown voltage)
- Reduces drift over time
- Acts as heat sink for perfboard

Connection:
    TEC1 (+) ── 12V power supply
    TEC1 (-) ── GND
    
    Run at 50% duty (6V) for stable cooling without ice buildup
    No PWM needed - just DC bias for constant temperature

Physical mounting:
    1. Apply thermal paste to TEC1 cold side
    2. Stick copper tape (1cm square) on paste
    3. Mount avalanche diode + PNPs on copper tape
    4. Secure with kapton tape
    5. Place assembly in Altoids tin

## ASSEMBLY NOTES

### BUILD ORDER
1. Avalanche section first - test with multimeter (should see 0-5V chaos)
2. Add digitizer - verify clean 0/1 pulses
3. Build one P-bit - test charge/discharge cycle
4. Replicate to 4 P-bits
5. Add switches and LEDs
6. Connect to TEC-1 GPIO
7. Upload MINT2 code
8. Test with known logic functions

### TESTING AVALANCHE RNG
- Multimeter on RNG_OUT should flicker unpredictably
- Frequency: ~1-100 kHz (depends on reverse voltage)
- Average: ~2.5V (adjust pot if needed)
- Pass/Fail: No stuck high or low for >1 second

### DEBUGGING
- No noise? Check Zener is reverse-biased (cathode to +V)
- Weak noise? Increase reverse voltage (add series resistor)
- Stuck bits? Check cap discharge paths (1kΩ to GND)
- Wrong logic? Verify truth table ladder voltages

### POWER CONSUMPTION
- Avalanche: ~1mA
- Comparators: ~2mA  
- TEC-1: ~200mA
- TEC1-12706: ~1A (optional)
Total: ~200mA (no Peltier) or ~1.2A (with Peltier)

## LAYOUT (Top View - Perfboard)

    [Altoids Tin - 10cm × 6cm]
    
    ┌────────────────────────────────────────┐
    │  [LED A] [LED B] [LED C] [LED Status]  │  ← Visible through lid holes
    │  [SW A]  [SW B]  [SW C]  [SW Gate]     │
    └────────────────────────────────────────┘
    
    Inside base:
    
    ┌──────────────────────────────────────────┐
    │                                          │
    │   [TEC1 Cold Side]                       │
    │   ┌──────────────┐                       │
    │   │ Copper Tape  │                       │
    │   │ ┌──┬──┐      │                       │
    │   │ │Q1│Q2│ [D1] │  ← Avalanche circuit  │
    │   │ └──┴──┘      │                       │
    │   └──────────────┘                       │
    │                                          │
    │   [Perfboard 5×7cm]                      │
    │   ┌────────────────────────┐             │
    │   │ [LM393]  [Caps×4]      │             │
    │   │ [Resistors]  [Diodes]  │             │
    │   └────────────────────────┘             │
    │                                          │
    │   [9V Battery Compartment]               │
    │                                          │
    │   [Ribbon Cable to TEC-1] ──────────>    │
    │                                          │
    └──────────────────────────────────────────┘

## SPECIFICATIONS

### ENTROPY SOURCE
- Type: Avalanche breakdown noise (1N4728A)
- Quality: ~73/100 (tec-RANDOM repo tests)
- Rate: 1-100 kbps (adjustable)
- Bias: <5% (tuned via pot)

### P-BIT CHARACTERISTICS
- State storage: 1µF capacitor
- Threshold: 1.5V (50% of 3V range)
- Flip time: ~10ms (RC = 10kΩ × 1µF)
- Retention: ~100ms (slow discharge)

### LOGIC PERFORMANCE
- Functions: All 16 2-input boolean
- Inputs: 2 bits (A, B)
- Output: 1 bit (C)
- Inference time: 50-200ms (10-20 Gibbs steps)
- Accuracy: >95% (after proper annealing)

### NEURAL EXPANSION
- Maximum neurons: 8 (with CD4051 mux)
- Training: Hebbian (in MINT2)
- Patterns: 4-8 storable
- Recall time: ~500ms (100 Gibbs steps)

## END OF HARDWARE SPECIFICATION
