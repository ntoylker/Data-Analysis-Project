# Data Analysis Project: The Effect of TMS on Epileptic Discharges

This repository contains the MATLAB code and analysis for the "Data Analysis" course project, completed in December 2024.

---

## 📝 Project Overview

This project investigates the effectiveness of **Transcranial Magnetic Stimulation (TMS)**, a non-invasive method, in mitigating the effects of epileptic discharges (EDs). The core hypothesis is that applying TMS during an ED can reduce its total duration. A key research question is whether the timing of the TMS application—specifically the delay from the onset of an ED (`preTMS`)—influences the remaining duration of the discharge (`postTMS`).

The analysis is performed on a dataset collected at the Laboratory of Transcranial Magnetic Stimulation, 3rd Neurology Clinic of AUTH, which combines EEG and TMS measurements from epileptic patients.

---

## 📊 The Dataset

The data is provided in the `TMS.xlsx` file, containing 254 observations of epileptic discharges. Of these, 135 are control measurements (without TMS) and 119 are measurements where TMS was applied.

The dataset includes the following variables:

| Variable     | Description                                                                 |
| :----------- | :-------------------------------------------------------------------------- |
| `TMS`        | Binary indicator: `1` if TMS was applied, `0` otherwise.                  |
| `EDduration` | Total duration of the epileptic discharge (in seconds).                     |
| `preTMS`     | Time from the start of the ED to the TMS application (in seconds).        |
| `postTMS`    | Time from the TMS application to the end of the ED (in seconds).          |
| `Setup`      | Measurement condition code (1-6), representing a different session/patient. |
| `Stimuli`    | The number of stimuli in a single TMS application.                          |
| `Intensity`  | Intensity of the stimulation as a percentage of the maximum.                |
| `Spike`      | Timing of the first stimulus relative to the ED peak (-1, 0, or 1).         |
| `Frequency`  | Frequency of the stimuli in a TMS application.                              |
| `CoilCode`   | Type of TMS coil used: `1` for figure-eight, `0` for round.               |

---

## 🎯 Project Objectives

The project is structured around a series of analytical tasks designed to explore the dataset from different statistical perspectives:

1.  **Probability Distribution Analysis**: Find the best-fit parametric probability distributions for `EDduration` with and without TMS and compare them graphically.

2.  **Goodness-of-Fit Testing**: Use resampling techniques (1000 random samples) to test if the `EDduration` data follows an exponential distribution for different coil types and compare the results with the standard parametric $\chi^{2}$ test.

3.  **Hypothesis Testing & Confidence Intervals**: For each of the 6 `Setup` conditions, test whether the mean `EDduration` is equal to the overall population mean. This involves using parametric tests for normally distributed data or bootstrap methods otherwise.

4.  **Correlation Analysis**: Investigate the correlation between `preTMS` and `postTMS` within each `Setup`. Both parametric (Student's t-statistic) and non-parametric randomization tests will be performed and compared.

5.  **Simple Linear & Polynomial Regression**: Model the relationship between `EDduration` and the experimental `Setup` to determine if the measurement condition is a significant predictor.

6.  **Multiple Linear Regression & Feature Selection**: Develop a multiple regression model to predict `EDduration` using experimental parameters as predictors (`Setup`, `Stimuli`, `Intensity`, etc.). This task involves comparing a full model against models derived from **Stepwise Regression** and **LASSO** feature selection methods. The impact of a variable with missing values (`Spike`) will also be assessed.

7.  **Model Validation**: Evaluate the predictive performance of the regression models from the previous step by splitting the data into training and testing sets and calculating the mean squared error on the test set.

8.  **Advanced Regression Models**: Extend the multiple regression analysis by including `preTMS` as a predictor and comparing the performance of Stepwise, LASSO, and **Principal Component Regression (PCR)** models.

---

## 💻 Technologies Used

* **MATLAB**

---

## 📈 Results and Conclusions

This section summarizes the key findings from the analysis, based on the executed MATLAB scripts.

### 1. Probability Distribution of ED Duration

* **Best Fit**: After testing 20 different continuous probability distributions, the **Exponential distribution** was found to provide the best fit for the `EDduration` data in both cases: with and without TMS application.
* **Effect of TMS**: While the probability density functions (PDFs) for both datasets appear similar, the histograms reveal a key difference. The application of TMS appears to reduce the occurrence of long-duration EDs, causing a higher concentration of discharges at shorter durations.

---

### 2. Goodness-of-Fit for Exponential Distribution (by Coil Type)

The analysis tested whether the `EDduration` follows an exponential distribution for the two different TMS coil types.

* **Figure-Eight Coil (`CoilCode = 1`)**: Both the resampling method and the standard parametric $\chi^{2}$ test confirmed that the data **does follow an exponential distribution**. The null hypothesis could not be rejected.
* **Round Coil (`CoilCode = 0`)**: For this coil type, both tests concluded that the data **does not follow an exponential distribution**. The null hypothesis was rejected.

The results from both the resampling and parametric methods were consistent for each coil type.

---

### 3. Hypothesis Testing of Mean ED Duration for Each Setup

The mean `EDduration` for each of the 6 `Setup` conditions was compared against the overall mean duration ($\mu_0$). The results are summarized below:

| Setup | TMS Condition | Follows Normal Dist.? | Decision on Mean $\mu_0$ | Method Used |
|:-----:|:-------------:|:---------------------:|:--------------------------:|:---------------------:|
| 1     | No TMS        | No                    | **Accept** (μ₀ is in CI)     | Bootstrap           |
| 2     | No TMS        | No                    | **Accept** (μ₀ is in CI)     | Bootstrap           |
| 3     | No TMS        | (N < 10)              | **Reject** (μ₀ not in CI)    | Bootstrap           |
| 4     | No TMS        | No                    | **Reject** (μ₀ not in CI)    | Bootstrap           |
| 5     | No TMS        | No                    | **Reject** (μ₀ not in CI)    | Bootstrap           |
| 6     | No TMS        | (N < 10)              | **Reject** (μ₀ not in CI)    | Bootstrap           |
| 1     | With TMS      | Yes                   | **Accept** (μ₀ is in CI)     | Parametric (t-test) |
| 2     | With TMS      | No                    | **Reject** (μ₀ not in CI)    | Bootstrap           |
| 3     | With TMS      | Yes                   | **Accept** (μ₀ is in CI)     | Parametric (t-test) |
| 4     | With TMS      | No                    | **Reject** (μ₀ not in CI)    | Bootstrap           |
| 5     | With TMS      | Yes                   | **Accept** (μ₀ is in CI)     | Parametric (t-test) |
| 6     | With TMS      | (N < 10)              | **Reject** (μ₀ not in CI)    | Bootstrap           |

The outcomes for the "With TMS" and "No TMS" cases agree for Setups 1, 4, and 6, but differ for Setups 2, 3, and 5. It is worth noting that the results for setups with very small sample sizes (e.g., Setup 3 and 6 without TMS) may not be fully representative.

---

### 4. Correlation Between `preTMS` and `postTMS`

The analysis investigated the correlation between the time before TMS (`preTMS`) and the time after (`postTMS`) for each of the 6 setups.

* **Overall Finding**: For all 6 setups, both the parametric test (Student's t-statistic) and the randomization test concluded that the null hypothesis **cannot be rejected**. This indicates that there is **no statistically significant linear correlation** between `preTMS` and `postTMS`.
* **Note on Setup 4**: Although the null hypothesis was not rejected for Setup 4, its p-value was close to the 0.05 significance level, which might hint at a weak, but not statistically significant, correlation.
* **Test Reliability**:
    * For **Setups 2 and 4**, which have larger sample sizes (>30), the **parametric test** is considered more reliable.
    * For **Setups 1, 3, 5, and 6**, which have smaller sample sizes, the **randomization test** is the more trustworthy method.
