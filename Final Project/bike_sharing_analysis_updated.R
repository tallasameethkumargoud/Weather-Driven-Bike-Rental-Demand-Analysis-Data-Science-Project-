#
# Load Required Libraries
#
# install.packages(c("ggplot2", "dplyr", "caret", "rpart", "rpart.plot", "reshape2"))
library(ggplot2)
library(dplyr)
library(caret)
library(rpart)
library(reshape2)


# Load the Data

bike_data <- read.csv("day.csv")
str(bike_data)


# Create a Binary Classification Target

bike_data$high_demand <- ifelse(bike_data$cnt > median(bike_data$cnt), "High", "Low")
bike_data$high_demand <- as.factor(bike_data$high_demand)


# Data Splitting: Train/Test Split

set.seed(123)
trainIndex <- createDataPartition(bike_data$high_demand, p = 0.7, list = FALSE)
train_data <- bike_data[trainIndex, ]
test_data <- bike_data[-trainIndex, ]


# Linear Regression: Predicting Rental Counts

lm_model <- lm(cnt ~ temp + hum + windspeed + season + weathersit + holiday + workingday, data = bike_data)
summary(lm_model)

# Fit simple linear model: cnt ~ temp
simple_lm <- lm(cnt ~ temp, data = bike_data)

temp_lm <- lm(cnt ~ temp, data = bike_data)


# Logistic Regression: Classifying High vs Low Demand

log_model <- glm(high_demand ~ temp + hum + windspeed + season + weathersit,
                 family = binomial, data = train_data)
summary(log_model)

# Logistic Model Evaluation
pred_probs <- predict(log_model, newdata = test_data, type = "response")
predicted_class <- ifelse(pred_probs > 0.5, "High", "Low")
predicted_class <- as.factor(predicted_class)
confusionMatrix(predicted_class, test_data$high_demand)

# Decision Tree Classification

tree_model <- rpart(high_demand ~ temp + hum + windspeed + season + weathersit,
                    data = train_data, method = "class")
summary(tree_model)


# Caret Classification (Cross-Validation)

ctrl <- trainControl(method = "cv", number = 5)
caret_model <- train(high_demand ~ temp + hum + windspeed + season + weathersit,
                     data = train_data,
                     method = "glm",
                     trControl = ctrl,
                     family = "binomial")
print(caret_model)


# Visualizations


# 1. Temperature vs Rentals;
plot(bike_data$temp, bike_data$cnt,
     main = "Bike Rentals vs Temperature",
     xlab = "Normalized Temperature",
     ylab = "Total Rentals",
     pch = 19, col = "steelblue")
abline(lm_model, col = "darkred", lwd = 2)

# 2. Humidity vs Rentals (High/Low Demand);
ggplot(bike_data, aes(x = hum, y = cnt, color = high_demand)) +
  geom_point(alpha = 0.6) +
  labs(title = "Humidity vs Bike Rentals (High vs Low Demand)",
       x = "Humidity",
       y = "Total Rentals") +
  scale_color_manual(values = c("Low" = "blue", "High" = "red"))

# 3. Rentals by Season;
ggplot(bike_data, aes(x = factor(season), y = cnt)) +
  geom_boxplot(fill = "skyblue") +
  labs(title = "Bike Rentals by Season",
       x = "Season (1=Spring, 2=Summer, 3=Fall, 4=Winter)",
       y = "Total Rentals")

# 4. Rentals by Weather Situation;
ggplot(bike_data, aes(x = factor(weathersit), y = cnt)) +
  geom_boxplot(fill = "orange") +
  labs(title = "Bike Rentals by Weather Situation",
       x = "Weather (1=Clear, 2=Mist, 3=Rain/Snow)",
       y = "Total Rentals")

# Confusion Matrix Heatmap;

cm_obj <- confusionMatrix(predicted_class, test_data$high_demand)
cm_data <- as.data.frame(cm_obj$table)
colnames(cm_data) <- c("Prediction", "Reference", "Freq")

ggplot(cm_data, aes(x = Reference, y = Prediction, fill = Freq)) +
  geom_tile(color = "white") +
  geom_text(aes(label = Freq), size = 6) +
  scale_fill_gradient(low = "lightblue", high = "steelblue") +
  labs(title = "Confusion Matrix Heatmap",
       x = "Actual Label",
       y = "Predicted Label") +
  theme_minimal()

