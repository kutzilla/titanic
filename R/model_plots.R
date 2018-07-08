library(h2o)

plot_model_factors <- function(model) {
  variable_importance <- h2o.varimp(model)
  
  plot <- ggplot(variable_importance) + 
          geom_bar(aes(x = reorder(variable, percentage), weight = percentage),
                   color = "black", fill = "white") +
          coord_flip() +
          labs(title = "Model factors", x = "Factors", y = "Weight")
  
  return(plot)
}

plot_scoring_history <- function(model) {
  
  scoring_history <- h2o.scoreHistory(model)
  
  plot <- ggplot(scoring_history) +
    geom_line(aes(x = as.numeric(row.names(scoring_history)), y = scoring_history$training_rmse), color = "red") +
    geom_line(aes(x = as.numeric(row.names(scoring_history)), y = scoring_history$validation_rmse), color = "white") +
    ylim(0, max(scoring_history$validation_rmse)) +
    labs(title = "Model scoring history based on the RMSE", x = "Epochs", y = "RMSE (red = training, white = validation)")
  
  return(plot)
}