# tec-RANDOM

![image](https://github.com/user-attachments/assets/6aeeeb65-7aea-4baa-918d-274110d2e5c7)


### hw
- avalanche diode

![image](https://github.com/user-attachments/assets/69a8e34a-8691-4e02-8b8d-50d4ec015fa6)

- back to back PNP

![image](https://github.com/user-attachments/assets/3a32faad-976f-4aa8-af45-2da9d48f40b1)

- 555

![image](https://github.com/user-attachments/assets/b3e00cb7-73ce-48cd-ad3b-4df04e27b0e1)



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

1. Integrates PRNG (:A function)
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

To use:
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


## result of analysis
- matlab code test

![image](https://github.com/user-attachments/assets/15522533-46a8-4c5f-8fbb-900a1a035393)

  Serial Correlation: -1.988
Randomness Metrics:
    Distribution Bias Penalty: 0.18
    Autocorrelation Penalty: 6.56
    Chi-square Penalty: 20.00
    Entropy Penalty: 0.00
Overall Randomness Score: 73.26/100


 
