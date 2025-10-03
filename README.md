**Solar Power Generation Prediction :**
This project predicts solar power generation (in kW) based on **weather and environmental parameters** using a **Random Forest regression model** in R. It helps forecast solar energy output, aiding renewable energy planning and optimization.

---

## Project Overview

Solar power generation is influenced by factors such as temperature, humidity, cloud cover, wind conditions, solar angles, and radiation. This project demonstrates how machine learning can predict solar energy output using historical weather data.

**Key Features:**
- Data preprocessing and cleaning  
- Random Forest model training and testing  
- Predictions on test data  
- Visualizations: scatter plot, histogram, line plot, box plot, and pie chart  
- Model evaluation using RMSE and R-squared  
- Analysis of how weather and solar angles affect power generation  

---

## Dataset

- **File:** `solar power generation.csv`  
- **Features include:**  
  - `temperature_2_m_above_gnd`, `relative_humidity_2_m_above_gnd`, `mean_sea_level_pressure_MSL`, `total_precipitation_sfc`  
  - `snowfall_amount_sfc`, `total_cloud_cover_sfc`, `high_cloud_cover_high_cld_lay`, `medium_cloud_cover_mid_cld_lay`  
  - `low_cloud_cover_low_cld_lay`, `shortwave_radiation_backwards_sfc`, wind speed/direction at multiple heights, solar angles  
- **Target:** `generated_power_kw`  

---

## Installation

1. Install **R**: [https://cran.r-project.org/](https://cran.r-project.org/)  
2. Install required packages in R:

```r
install.packages(c("tidyverse", "caret", "randomForest", "lubridate"))

