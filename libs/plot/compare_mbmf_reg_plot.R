##############################################
library(ggplot2)
library(gghalves)
library(ggpubr)

compare_mbmf_reg_plot <- function(effect) {
  nsub <- 30
  effectall <- c(effect[, 1], effect[, 2], effect[, 3])
  subname <- rep(c(1:nsub), 3)
  drugname <- c(rep(1, nsub), rep(2, nsub), rep(3, nsub))
  df <- data.frame(effectall, subname, drugname) %>%
    mutate(
      drugname = factor(drugname, levels = c("1", "2", "3"), ordered = TRUE)
    )

  # plot(x, y, col = c("#F8766D", "#00BFC4", "#619CFF"))


  plot <- ggplot(df, aes(x = drugname, y = effectall, group = drugname)) +
    geom_half_violin(
      data = subset(df, drugname == "1"), alpha = 0.5,
      aes(x = drugname, y = effectall, group = drugname), size = 0.1,
      fill = "#F8766D", color = "transparent"
    ) +
    geom_half_violin(
      data = subset(df, drugname == "2"), alpha = 0.5,
      aes(x = drugname, y = effectall, group = drugname), size = 0.1,
      fill = "#00BFC4", color = "transparent"
    ) +
    geom_half_violin(
      data = subset(df, drugname == "3"), alpha = 0.5,
      aes(x = drugname, y = effectall, group = drugname), size = 0.1,
      fill = "#619CFF", color = "transparent"
    ) +
    geom_point(size = 0.1, color = "black") +
    geom_line(aes(group = subname), size = 0.1, color = "gray") +
    stat_summary(
      data = subset(df, drugname == "1"), aes(x = drugname, y = effectall),
      geom = "point", shape = 23, color = "red",
      fill = "red", size = 1.5, alpha = 0.6
    ) +
    stat_summary(
      data = subset(df, drugname == "2"), aes(x = drugname, y = effectall),
      geom = "point", shape = 23, color = "red",
      fill = "red", size = 1.5, alpha = 0.6
    ) +
    stat_summary(
      data = subset(df, drugname == "3"), aes(x = drugname, y = effectall),
      geom = "point", shape = 23, color = "red",
      fill = "red", size = 1.5, alpha = 0.6
    ) +
    scale_x_discrete(
      breaks = c("1", "2", "3"),
      labels = c("Propranolol", "Placebo", "Dopamine")
    ) +
    labs(x = NULL, y = NULL) +
    theme_bw() +
    theme(
      axis.title.y = element_text(hjust = 0.5, size = 16),
      axis.title.x = element_text(size = 16),
      axis.text = element_text(size = 14),
      panel.grid = element_blank(),
      axis.line = element_line(colour = "black"),
      panel.border = element_blank(),
      panel.background = element_blank(),
      strip.background = element_blank(),
      strip.text = element_text(face = "bold", vjust = 0, hjust = 0)
    )
  # plot
  return(plot)
}
