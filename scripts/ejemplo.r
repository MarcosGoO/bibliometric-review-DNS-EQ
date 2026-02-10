# Simple R example
print("Hello, R!")

# Create a vector
numbers <- c(1, 2, 3, 4, 5)

# Calculate mean
mean_value <- mean(numbers)
print(paste("Mean:", mean_value))

# Create a data frame
data <- data.frame(
    name = c("Alice", "Bob", "Charlie"),
    age = c(25, 30, 35),
    score = c(85, 90, 78)
)

# Display the data
print(data)

# Summary statistics
summary(data$score)