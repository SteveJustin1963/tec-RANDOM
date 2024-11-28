# tec-RANDOM
### hw
- avalanche diode 
- back to back PNP
- 

### sw
- rule 30 https://en.wikipedia.org/wiki/Rule_30
- https://en.wikipedia.org/wiki/Elementary_cellular_automaton
- https://mathworld.wolfram.com/CellularAutomaton.html
- https://www.math.utah.edu/~alfeld/Random/Random.html
- https://svijaykoushik.github.io/blog/2019/10/04/three-awesome-ways-to-generate-random-number-in-javascript/


### MINT code
```
// mint 2.0
:A 7 x * 3 + " x! 32555 > (`_`) /E (`|`);
:B 10000(A);
```
![](https://github.com/SteveJustin1963/tec-RANDOM/blob/master/Pics/out.png) 
- 


## analyzer for PRNG 

1. Integrates your original PRNG (:A function)
2. Adds comprehensive analysis:
   - Ones/Zeros distribution
   - Run length analysis
   - Value distribution across 10 bins
   - Basic chi-square calculation
   - Overall randomness score

3. Provides periodic reports every 1000 iterations showing:
   - Current statistics
   - Distribution analysis
   - Pattern detection
   - Randomness scoring

4. Calculates a randomness score (0-100) based on:
   - Distribution evenness
   - Run length patterns
   - Statistical deviation

To use it:
1. Just run the M function:
```mint
M
```

The system will:
- Run your PRNG for 10000 iterations
- Show the same visual output (_|) as your original code
- Display analysis reports every 1000 iterations
- Provide a final comprehensive report

The analysis includes:
- Distribution metrics
- Run length analysis
- Chi-square approximation
- Overall randomness score

todo:
1. additional statistical tests
2. reporting frequency
3. scoring system
4. more detailed analysis in an area
   

 
