# Railway-Defect-Simulation_FinalProject

## Project Overview
Develop a Monte Carlo simulation that examines how the occurrence and severity of railway defects affect train delays and return-to-operation time. It will compare normal, moderate, and severe disruption scenarios using parameters based on available references or clearly identified assumptions.  
**Course:** CS0019 - Modeling and Simulation 
**Members:** Austria, Brianne Paolo; Cuarentas, Justin Kurt; Fojas, Franz Erich; Francisco, Hans Eleazar  

## Progress Update
- **Framework Setup:** Initialized the MATLAB simulation script (`Railway-defect-simulation.m`) implementing the Monte Carlo iteration framework ($1,000$ simulation runs).
- **Scenario Structuring:** Configured data structures for the three approved test scenarios (Normal, Moderate, and Severe operating conditions) covering defect probabilities, delay rates, and recovery times.
- **Visualization Stubs:** Added baseline script structures for generating comparative bar graphs and statistical summary metrics.

## Planned MATLAB Output
The proposed system is planned to output the following information:
* **Histogram:** Shows the frequency and distribution of train delays and recovery times to show how often the situation occurs.
* **Line Graph:** Shows the change in train delays and arrival time under different operating severity scenarios like normal, moderate, and severe through multiple simulations.
* **Bar Graph:** Shows the comparison between average train delay durations and estimated arrival times throughout different operating scenarios (implemented in the current structural script).
* **Summary:** Shows the key result, such as the average train delay durations and the average estimated return of operations per different operating scenarios (computed and printed to the MATLAB Command Window).
