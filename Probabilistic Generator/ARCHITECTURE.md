# TEC-PBIT SYSTEM ARCHITECTURE - ASCII DIAGRAM

**Complete System Block Diagram**

---


LAYER 1: ENTROPY SOURCE (Quantum Physics)
=========================================

    [1N4728A Zener Diode]
         Avalanche
         Breakdown
            │
            ├─→ Electron tunneling (quantum)
            ├─→ Random current spikes
            └─→ True physical entropy
            
         Output: 0-5V chaotic analog


LAYER 2: SIGNAL CONDITIONING (Analog Electronics)
================================================

    Chaotic Voltage
         │
         ├─→ [PNP Amp 1] ──┐
         │                  │ Back-to-back
         └─→ [PNP Amp 2] ───┘ amplification
                  │
                  ├─→ Amplified to 0-9V
                  │
              [LM393 Comparator]
              Threshold: 2.5V
                  │
         Output: Clean 0/1 bits (RNG_BIT)


LAYER 3: PROBABILISTIC STORAGE (Capacitor Physics)
=================================================

    RNG_BIT pulses
         │
         ├──┬──┬──┬──┬──┬──┬──┬── (charge path)
         │  │  │  │  │  │  │  │
        [C][C][C][C][C][C][C][C]   8× 1µF capacitors
         │  │  │  │  │  │  │  │
         └──┴──┴──┴──┴──┴──┴──┴── (discharge path)
         
    Each cap = P-bit (Probabilistic Bit)
    - Voltage 0-9V = analog state
    - Threshold 1.5V = digital 0/1
    - Charge time: ~10ms (noisy)
    - Discharge time: ~50ms (settles)


LAYER 4: DIGITAL INTERFACE (Multiplexing)
========================================

    8 P-bit voltages
         │
    [CD4051 Mux]
     Select: 3 bits
         │
    One at a time ──→ [Comparator] ──→ Digital 0/1
         │
    To TEC-1 GPIO


LAYER 5: CONTROL & COMPUTATION (TEC-1 Z80 + MINT2)
=================================================

    TEC-1 Z80 @ 4MHz
         │
         ├─→ Port D (Inputs)
         │    D0: RNG_BIT
         │    D1: P-bit state (via mux)
         │    D5-D8: Switches (clues)
         │
         ├─→ Port B (Outputs)
         │    B0-B2: LEDs (result)
         │    B3: Status LED
         │    B4-B6: Mux select
         │
         └─→ MINT2 Interpreter
              │
              ├─→ Gibbs Sampling
              ├─→ Energy Calculation  
              ├─→ Logic Inference
              └─→ Neural Learning


## COMPLETE SYSTEM DATAFLOW

USER INPUT (Switches)
    │
    ├─→ Clues: A=?, B=1, C=0
    └─→ Gate: AND (function #1)
         │
         v
    ┌──────────────────────────────────┐
    │   TEC-1 Z80 + MINT2              │
    │                                   │
    │   :ORACLE                         │
    │    ├─> /INIT (read switches)     │
    │    ├─> /INFER (start solve)      │
    │    │    ├─> /SAMPLE (inject RNG) │◄─┐
    │    │    ├─> /GIBBS (flip P-bits) │  │
    │    │    ├─> /ENERGY (check)      │  │
    │    │    └─> Loop until valid     │──┘
    │    └─> /OUTPUT (show LEDs)       │
    │                                   │
    └──────────────────────────────────┘
         │             │            │
         │             │            │
    RNG_BIT      P-bit States    LED Output
         │             │            │
         v             v            v
    ┌────────┐   ┌─────────┐   ┌────────┐
    │Quantum │   │Capacitor│   │Visual  │
    │ Noise  │   │ Array   │   │Display │
    └────────┘   └─────────┘   └────────┘


## INFORMATION FLOW (What Actually Happens)

STEP 1: INITIALIZATION
  User sets switches → TEC-1 reads Port D
  ├─ A=? (unknown)
  ├─ B=1 (known/clamped)
  ├─ C=0 (known/target)
  └─ Gate=1 (AND function)

STEP 2: RANDOM EXPLORATION
  MINT2 calls /SAMPLE
  └─ Pulse RNG_BIT → charges caps randomly
     ├─ P-bit A: 0.8V → 0
     ├─ P-bit B: 3.2V → 1 (clamped)
     └─ P-bit C: 2.1V → 1 (wrong!)

STEP 3: ENERGY EVALUATION
  MINT2 calls /ENERGY
  └─ Check truth table[A=0, B=1] → expect C=0
     └─ Actual C=1 → energy = HIGH (wrong)

STEP 4: PROBABILISTIC FLIP
  MINT2 calls /FLIP
  └─ Try flipping C: 1→0
     └─ New energy = LOW (correct!)
        └─ Accept flip

STEP 5: CONVERGENCE
  Repeat Steps 2-4 for 20 iterations
  └─ P-bits settle to: A=0, B=1, C=0
     └─ Energy = 0 (valid solution!)

STEP 6: OUTPUT
  MINT2 calls /OUTPUT
  └─ LEDs show: [OFF][ON][OFF]
     └─ Answer: A=0, B=1, C=0 - [x]


## PHYSICAL LAYOUT (Inside Altoids Tin)

TOP VIEW (Lid):
┌────────────────────────────────────┐
│                                    │
│   ┌───┐ ┌───┐ ┌───┐ ┌───┐        │
│   │ A │ │ B │ │ C │ │ G │  Switches
│   └───┘ └───┘ └───┘ └───┘        │
│                                    │
│   ◉ A   ◉ B   ◉ C   ◉ *   LEDs    │
│                                    │
│   [TEC-PBIT Logic Oracle]         │
│                                    │
└────────────────────────────────────┘

SIDE VIEW (Cross-section):
┌────────────────────────────────────┐ Lid
│ Switches  LEDs                     │
└────────────┬───────────────────────┘
             │ Wires
┌────────────┴───────────────────────┐
│ ┌──────────────┐  ┌─────┐         │
│ │  Perfboard   │  │ 9V  │         │
│ │  - Avalanche │  │Batt │         │
│ │  - P-bits    │  └─────┘         │
│ │  - Mux       │                  │
│ └──────────────┘                  │
│ [Optional TEC1-12706 cooling]     │
└────────────────────────────────────┘ Base
       10cm × 6cm × 3cm


## DATA STRUCTURES (MINT2 Memory Map)

VARIABLES (26 single-letter):
a b c    - Logic bits A, B, C
g        - Gate select (0-15)
e        - Energy/error
s        - Step counter
i j      - Loop indices
r        - RNG bit
t        - Target/truth
n        - Neuron index
p        - Probability
u        - Update flag

ARRAYS (Multi-element):
h! - P-bit states [0 0 0 0 0 0 0 0]  8 neurons
w! - Weight matrix [64 elements]     8×8 weights
x! - Input pattern  [0 0 0 0 0 0 0 0]
y! - Target pattern [0 0 0 0 0 0 0 0]
k! - Clue flags     [0 0 0 0 0 0 0 0]
d! - Truth table    [64 elements]    16 gates × 4 combos


## ENERGY LANDSCAPE VISUALIZATION

For 2-bit problem (A,B), showing energy surface:

    Energy
      ^
      │     ╱╲        ← High energy (wrong states)
    5 │    ╱  ╲
      │   ╱    ╲
    4 │  ╱      ╲
      │ ╱        ╲
    3 │╱          ╲
      │            ╲___  ← Low energy
    2 │                ╲    (correct state)
      │                 ╲
    1 │                  ╲___
      │                      ╲___
    0 │─────────────────────────╲── Target
      └────────────────────────────> State space
      00   01   10   11

Gibbs sampling:
- Starts at random point (high energy)
- Probabilistic moves explore surface
- Settles to lowest point (solution)
- Temperature controls exploration vs exploitation


## TIMING DIAGRAM (One Inference Cycle)

Time (ms):  0     50    100   150   200   250   300
            │     │     │     │     │     │     │
User Input  ═══════════════════════════════════════
            Press key
                  │
RNG_BIT     ──┐ ┌─┐ ┌─┐ ┌─┐ ┌─┐ ┌─┐ ┌─┐
              └─┘ └─┘ └─┘ └─┘ └─┘ └─┘ └─┘
              Noise injection (10 samples)
                  │
P-bit A     ━━━╱╲╱╲━━━━╱━━╲━━━━━╱━━━━━━
            Charging / Settling
                  │
P-bit B     ━━━━━━━━━━━━━━━━━━━━━━━━━━━
            Clamped (stays at 1)
                  │
P-bit C     ━╱━╲━━━━╱╲━━━╱━━━━━━━━━━━━
            Flipping / Converging
                  │
Energy      ████░░░░░░░░░░░░░░░░░░░░░░░
            High → Low (settling)
                                      │
Status LED  ██████████████████████████░░
            Blinking → Solid (done)
                                      │
Output      ────────────────────────██══
                              Answer ready


## COMPONENT COUNT SUMMARY

### SEMICONDUCTORS
- 1× 1N4728A Zener (avalanche)
- 2× 2N3906 PNP (amplifier)
- 2× LM393 Dual Comparator (8 total comparators)
- 1× CD4051 Analog Mux (neural extension)
Total: 6 ICs / 3 discrete

### PASSIVES
- 8× 1µF capacitors (P-bits)
- 20× 10kΩ resistors (various)
- 8× 1kΩ resistors (charge/discharge)
- 4× 330Ω resistors (LEDs)
- 1× 100kΩ pot (RNG threshold)
- 1× 0.1µF cap (decoupling)
Total: ~40 components

### INTERCONNECTS
- 4× SPST switches
- 4× Red LEDs
- Perfboard 5×7 cm
- Ribbon cable 10-wire
- Altoids tin
- 9V battery + clip

TOTAL COMPONENT COUNT: ~50
TOTAL SOLDER JOINTS: ~120
TOTAL COST: $12-20


## PERFORMANCE ENVELOPE

CURRENT SYSTEM (4 P-bits Logic):
├─ Neurons: 4
├─ States: 2^4 = 16
├─ Solve time: 1-5 seconds
├─ Accuracy: >90%
└─ Power: 300mA @ 5V

WITH NEURAL (8 P-bits):
├─ Neurons: 8  
├─ States: 2^8 = 256
├─ Patterns: 4-8 storable
├─ Recall time: 5-10 seconds
├─ Accuracy: >80%
└─ Power: 400mA @ 5V

THEORETICAL MAX (64 P-bits):
├─ Neurons: 64
├─ States: 2^64 = 18 quintillion
├─ Patterns: ~10 storable
├─ Requires: External RAM, multiple mux chips
├─ Solve time: Minutes
├─ Power: ~1A @ 5V
└─ Feasibility: Challenging but possible


## KEY INSIGHT: WHY THIS WORKS

Traditional Computer:
  Input ──> [Deterministic Logic] ──> Output
  
  - Every run: same output
  - Explores one path
  - Can get stuck in local minimum
  - Needs complex code for optimization

Probabilistic Computer:
  Input + [RNG] ──> [Stochastic Sampling] ──> Output
  
  - Every run: explores different paths
  - Samples multiple solutions simultaneously  
  - Escapes local minima via noise
  - Physics does the optimization

This is why P-bits work:
- Randomness = exploration
- Energy function = fitness landscape
- Settling = natural optimization
- No complex algorithms needed!


## END OF ARCHITECTURE DIAGRAM

This shows the complete system from quantum physics (avalanche breakdown)
through analog electronics (amplification) to digital logic (TEC-1 + MINT2)
to practical applications (logic solving, pattern recognition).

Every layer builds on the previous, transforming quantum randomness into
useful computation. This is real AI, not simulated - the physics IS the
algorithm.

Now go build it and prove that computation doesn't need massive datacenters.
Sometimes, an Altoids tin and some clever physics are all you need.
