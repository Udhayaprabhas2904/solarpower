# Load necessary libraries
library(tidyverse)        
library(caret)            
library(randomForest)     
library(lubridate)

# 1. Import the dataset
data <- read.csv("C:/Users/user/Downloads/archive (7)/spg.csv")

# 2. Prepare the data
if ("date" %in% colnames(data)) {
  data$date <- as.Date(data$date)
} else {
  cat("Date column not found!\n")
}

data <- na.omit(data)

if ("generated_power_kw" %in% colnames(data)) {
  data$generated_power_kw <- as.numeric(data$generated_power_kw)
} else {
  stop("Target column 'generated_power_kw' not found!")
}

# 3. Create training and testing sets
set.seed(123)
trainIndex <- createDataPartition(data$generated_power_kw, p = 0.8, list = FALSE)
train_data <- data[trainIndex, ]
test_data <- data[-trainIndex, ]

# 4. Fit a Random Forest model
rf_model <- randomForest(
  generated_power_kw ~ temperature_2_m_above_gnd + 
    relative_humidity_2_m_above_gnd + 
    mean_sea_level_pressure_MSL + 
    total_precipitation_sfc + 
    snowfall_amount_sfc + 
    total_cloud_cover_sfc + 
    high_cloud_cover_high_cld_lay + 
    medium_cloud_cover_mid_cld_lay + 
    low_cloud_cover_low_cld_lay + 
    shortwave_radiation_backwards_sfc + 
    wind_speed_10_m_above_gnd + 
    wind_direction_10_m_above_gnd + 
    wind_speed_80_m_above_gnd + 
    wind_direction_80_m_above_gnd + 
    wind_speed_900_mb + 
    wind_direction_900_mb + 
    wind_gust_10_m_above_gnd + 
    angle_of_incidence + 
    zenith + 
    azimuth, 
  data = train_data
)

# 5. Predict on test set
predictions <- predict(rf_model, test_data)

# 6. Prepare results dataframe
results <- data.frame(
  Actual = test_data$generated_power_kw,
  Predicted = predictions
)

# 7. Visualizations 

## Scatter Plot: Actual vs Predicted
ggplot(results, aes(x = Actual, y = Predicted)) +
  geom_point(color = "#0072B2", alpha = 0.7, size = 2) +
  geom_abline(slope = 1, intercept = 0, color = "#D55E00", linetype = "dashed", size = 1) +
  labs(
    title = "Actual vs Predicted Solar Power Generation",
    x = "Actual Power Generation (kW)",
    y = "Predicted Power Generation (kW)"
  ) +
  theme_minimal(base_size = 14)

## Bar Plot: Predicted power for first 20 observations
ggplot(results[1:20,], aes(x = factor(seq_along(Predicted)), y = Predicted)) + 
  geom_bar(stat = "identity", fill = "#56B4E9") + 
  labs(
    title = "Predicted Power for Selected Observations",
    x = "Observation Index",
    y = "Predicted Power (kW)"
  ) +
  theme_minimal(base_size = 14) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

## Histogram: Distribution of Actual vs Predicted
ggplot(results) +
  geom_histogram(aes(x = Actual), binwidth = 10, fill = "#009E73", color = "white", alpha = 0.6) +
  geom_histogram(aes(x = Predicted), binwidth = 10, fill = "#F0E442", color = "white", alpha = 0.6) +
  labs(
    title = "Distribution of Actual and Predicted Power",
    x = "Power Generation (kW)",
    y = "Frequency"
  ) +
  theme_minimal(base_size = 14)

## Box Plot: Generated Power by Temperature Group
data <- data %>%
  mutate(temp_group = cut(temperature_2_m_above_gnd, 
                          breaks = c(-Inf, 10, 20, 30, 40, Inf),
                          labels = c("<10°C", "10-20°C", "20-30°C", "30-40°C", ">40°C")))
ggplot(data, aes(x = temp_group, y = generated_power_kw)) +
  geom_boxplot(fill = "#E69F00", color = "black") +
  labs(
    title = "Power Generation by Temperature Group",
    x = "Temperature Range",
    y = "Power Generation (kW)"
  ) +
  theme_minimal(base_size = 14)

## Line Plot: Trend of Actual vs Predicted
ggplot(results, aes(x = seq_along(Actual))) +
  geom_line(aes(y = Actual), color = "#0072B2", size = 1) +
  geom_line(aes(y = Predicted), color = "#D55E00", linetype = "dashed", size = 1) +
  labs(
    title = "Trend of Actual vs Predicted Power Over Time",
    x = "Observation Index",
    y = "Power Generation (kW)"
  ) +
  theme_minimal(base_size = 14)

## Pie Chart: Proportion of Power Generation Levels
results <- results %>%
  mutate(Power_Level = cut(Actual, breaks = c(-Inf, 100, 300, Inf), labels = c("Low", "Medium", "High")))

power_counts <- results %>%
  group_by(Power_Level) %>%
  summarise(count = n(), .groups = "drop")

ggplot(power_counts, aes(x = "", y = count, fill = Power_Level)) +
  geom_col(width = 1, color = "white") +
  coord_polar(theta = "y") +
  labs(title = "Proportion of Power Generation Levels") +
  theme_void(base_size = 14) +
  scale_fill_manual(values = c("#56B4E9", "#F0E442", "#D55E00"))

# 8. Model Evaluation
rmse_value <- sqrt(mean((results$Actual - results$Predicted)^2))
rsq_value <- cor(results$Actual, results$Predicted)^2

# Print metrics
cat("RMSE: ", rmse_value, "\n")
cat("R-squared: ", rsq_value, "\n")
