#  Weather-Driven Bike Rental Demand Analysis

##  Project Summary

This project investigates how weather conditions influence daily bike rental demand using the **UCI Bike Sharing Dataset**.  
It was developed as part of the final project for **INFO6105 – Data Science Engineering Methods** at Northeastern University.

🔍 **Key Goals:**
- Predict total bike rentals using weather and calendar data.
- Classify high vs low demand days using interpretable models.
- Visualize trends and model performance in R.

---

##  Dataset Description

- **Source:** [UCI ML Repository – Bike Sharing Dataset](https://archive.ics.uci.edu/ml/datasets/Bike+Sharing+Dataset)  
- **Size:** 731 daily records (2011–2012)
- **Key Features:**
  - `temp`, `hum`, `windspeed`, `season`, `weathersit`
  - `holiday`, `workingday`, `cnt` (target), `high_demand` (engineered)
  
---

##  Technologies Used

- **Language:** R (v4.4.2)
- **Libraries:**
  - `ggplot2` – Visualization
  - `dplyr` – Data wrangling
  - `caret` – Classification and validation
  - `rpart` – Decision trees
  - `reshape2` – Matrix to heatmap formatting

---

## ⚙️ How It Works

### 1.  Data Preprocessing
- Loaded `day.csv` and created a new label: `high_demand` (based on median of `cnt`)

### 2.  Modeling
- **Linear Regression** to predict `cnt`
- **Logistic Regression** and **Decision Tree** to classify demand
- Used **5-fold Cross-Validation** via `caret` for stability

### 3.  Visualization
- Temp vs Rentals
- Humidity impact on High/Low demand
- Rentals by Season & Weather
- Confusion Matrix Heatmap

---

