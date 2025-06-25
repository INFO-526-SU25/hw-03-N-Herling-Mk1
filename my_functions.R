# .............................................
# ==== store all the functions for HW3 here ===
# .............................................


# ============== Building graphs (beginning) =====================================================>>>
# g0

plot_explanatory_group_dotline_faceted <- function(data) {
  # Define clean response labels
  response_labels <- c(
    resp_will_recommend = "I will recommend\n the vaccine to\nfamily, friends,\nand community\nmemebers.",
    resp_trust_info = "I trust\nthe infomation that I\n have received about\nthe vaccines.",
    resp_confidence_science = "I am confident in\nthe scientific\n vetting process for\nthe new COVID\nvaccines.",
    resp_concern_safety = "I am concerned\nabout the safety\nand side effects of\nthe vaccine.",
    resp_feel_safe_at_work = "Getting the vaccine\n will make me feel\nsafer at work.",
    resp_safety = "Based on my\n understanding. I\n believe the vaccine\nis safe."
  )

  # All unique values in explanatory_value:
  unique_vals <- sort(unique(as.character(data$explanatory_value)))

  age_labels <- c(
    `30` = ">30",
    `25` = "26-30",
    `20` = "21-25",
    `0`  = "<20"
  )
  # Ensure all unique_vals are in age_labels names
  if (!all(unique_vals %in% names(age_labels))) {
    stop("Some explanatory_value levels are missing in age_labels")
  }

  data <- data %>%
    mutate(
      explanatory_value = factor(as.character(explanatory_value), levels = names(age_labels))
    )

  ggplot(data, aes(y = exp_age_bin, x = mean)) +
    geom_errorbarh(aes(xmin = low, xmax = high), height = 0.15, color = "gray50") +
    geom_point(color = "black", size = 3) +
    facet_wrap(~ response, nrow = 1, labeller = labeller(response = response_labels)) +
    scale_x_continuous(limits = c(1, 5), expand = expansion(mult = c(0.05, 0.05))) +
    scale_y_discrete(labels = age_labels) +
    theme_minimal(base_size = 12) +
    theme(
      axis.title = element_blank(),
      axis.ticks.y = element_line(),
      axis.text.y = element_text(size = 10),
      axis.text.x = element_text(size = 9),
      strip.text = element_text(size = 10),
      panel.grid.major.y = element_blank(),
      panel.grid.minor = element_blank(),
      panel.spacing = unit(1.5, "lines")
    ) +
    labs(x = "Mean Response (1–5)")
}













# plot_first_row_patchwork <- function(
#     data,
#     response_labels,
#     explanatory_labels = NULL,
#     set_dot_size = 3,
#     strip_fill_color = "lightgray",
#     strip_placement = "outside",
#     strip_text_size = 12,
#     text_size = 14,
#     bg_color = "white"
# ) {
#   # Ensure factors have levels matching labels for proper ordering
#   data <- data %>%
#     mutate(
#       response = factor(response, levels = names(response_labels)),
#       explanatory = factor(explanatory, levels = names(explanatory_labels))
#     )
#
#   ggplot(data, aes(x = explanatory_value, y = mean)) +
#     geom_errorbar(aes(ymin = low, ymax = high), width = 0.2) +
#     geom_point(size = set_dot_size, color = "black") +
#     coord_flip() +
#     facet_grid(
#       rows = vars(explanatory),
#       cols = vars(response),
#       labeller = labeller(
#         response = as_labeller(response_labels),
#         explanatory = as_labeller(explanatory_labels)
#       )
#     ) +
#     theme_minimal(base_size = text_size) +
#     labs(
#       title = "COVID-19 Vaccine Attitudes by Demographic Group\n",
#       x = NULL,
#       y = NULL
#     ) +
#     theme(
#       plot.background = element_rect(fill = bg_color, color = NA),
#       plot.title = element_text(hjust = 0.5),
#       panel.grid = element_blank(),
#       panel.spacing.x = unit(0.1, "lines"),
#       panel.spacing.y = unit(0., "lines"),
#       strip.background = element_rect(fill = strip_fill_color, color = "black"),
#       strip.placement = strip_placement,
#       strip.text.x = element_text(
#         vjust = 0.5,
#         size = strip_text_size,
#         margin = margin(t = 5, b = 5, r = 6, l = 6)
#       ),
#       strip.text.y.right = element_text(
#         angle = 0,
#         vjust = 0.5,
#         margin = margin(t = 15, b = 15, r = 26, l = 26)
#       ),
#       axis.text.y = element_blank(),
#       axis.text.x = element_blank(),
#       axis.ticks.x = element_blank()
#     )
# }





# ============== Building graphs (end) =====================================================>>>


# ============== Mak'n Tibbles (beginning) =====================================================>>>
# ... preparing
get_covid_survey_summary_stats_by_group <- function(data, group_vars, prob_low, prob_high) {
  data |>
    dplyr::group_by(dplyr::across(dplyr::all_of(group_vars))) |>
    dplyr::summarise(
      mean = mean(response_value, na.rm = TRUE),
      low = quantile(response_value, probs = prob_low, na.rm = TRUE),
      high = quantile(response_value, probs = prob_high, na.rm = TRUE),
      .groups = "drop"
    )
}

#... preparing
get_covid_survey_summary_stats_all <- function(data, prob_low = 0.10, prob_high = 0.90) {
  message("... in 'all creator'...")

  data |>
    dplyr::group_by(response) |>
    dplyr::summarise(
      mean = mean(response_value, na.rm = TRUE),
      low = quantile(response_value, probs = prob_low, na.rm = TRUE),
      high = quantile(response_value, probs = prob_high, na.rm = TRUE),
      explanatory = "All",
      explanatory_value = factor("All"),  # Hardcoded "All"
      .groups = "drop"
    )
}

get_summary_collapsed_to_all <- function(summary_df) {
  summary_df %>%
    dplyr::group_by(response) %>%
    dplyr::summarise(
      mean = mean(mean, na.rm = TRUE),
      low = mean(low, na.rm = TRUE),
      high = mean(high, na.rm = TRUE),
      explanatory = "All",
      explanatory_value = factor("All"),
      .groups = "drop"
    )
}
# ============== Mak'n Tibbles (end) =====================================================>>>



# ..... Variable prep .....................
# ..... prepare the variables. for graphing
# .........................................
# . ethnicity.
filter_ethnicity_data <- function(data) {
  data %>%
    filter(explanatory == "exp_ethnicity") %>%
    filter(is.finite(mean), is.finite(low), is.finite(high)) %>%
    mutate(
      explanatory_value = recode(as.character(explanatory_value),
                                 "1" = "Hispanic/Latino",
                                 "2" = "Non-Hispanic/Non-Latino"),
      explanatory_value = factor(explanatory_value, levels = c(
        "Hispanic/Latino", "Non-Hispanic/Non-Latino"
      )),
      explanatory = factor(explanatory, levels = c(
        "All", "exp_age_bin", "exp_gender", "exp_race", "exp_ethnicity"
      ))
    )
}

# . age
filter_age_data <- function(data) {
  data %>%
    filter(explanatory == "exp_age_bin") %>%
    filter(is.finite(mean), is.finite(low), is.finite(high)) %>%
    mutate(
      explanatory_value = recode(as.character(explanatory_value),
                                 "0" = "<20",
                                 "20" = "21-25",
                                 "25" = "26-30",
                                 "30" = ">30"
      ),
      explanatory_value = factor(explanatory_value, levels = c("<20", "21-25", "26-30", ">30")),
      explanatory = factor(explanatory, levels = c("All", "exp_age_bin", "exp_gender", "exp_race"))
    )
}


# . gender
filter_gender_data <- function(data) {
  data %>%
    filter(explanatory == "exp_gender") %>%
    filter(is.finite(mean), is.finite(low), is.finite(high)) %>%
    mutate(
      explanatory_value = as.character(explanatory_value),
      explanatory_value = fct_recode(factor(explanatory_value),
                                     "Prefer not to say" = "4",
                                     "Non-binary third gender" = "3",
                                     "Male" = "0",
                                     "Female" = "1"
      ),
      explanatory_value = factor(explanatory_value, levels = rev(c(
        "Prefer not to say",
        "Non-binary third gender",
        "Male",
        "Female"
      ))),
      explanatory = factor(explanatory, levels = c("All", "exp_age_bin", "exp_gender", "exp_race"))
    )
}


# . race
filter_race_data <- function(data) {
  data %>%
    filter(explanatory == "exp_race") %>%
    filter(is.finite(mean), is.finite(low), is.finite(high)) %>%
    mutate(
      explanatory_value = recode(as.character(explanatory_value),
                                 "1" = "American Indian/Alaska Native",
                                 "2" = "Asian",
                                 "3" = "Black/African American",
                                 "4" = "Native Hawaiian/Other Pacific Islander",
                                 "5" = "White"
      ),
      explanatory_value = factor(explanatory_value, levels = rev(c(
        "White",
        "Native Hawaiian/Other Pacific Islander",
        "Black/African American",
        "Asian",
        "American Indian/Alaska Native"
      ))),
      explanatory = factor(explanatory, levels = c("All", "exp_age_bin", "exp_gender", "exp_race"))
    )
}

# . profession
filter_profession_data <- function(data) {
  data %>%
    filter(explanatory == "exp_profession") %>%
    filter(is.finite(mean), is.finite(low), is.finite(high)) %>%
    mutate(
      explanatory_value = recode(as.character(explanatory_value),
                                 "1" = "Nursing",
                                 "0" = "Medical"),
      explanatory_value = factor(explanatory_value, levels = c("Medical", "Nursing")),
      explanatory = factor(explanatory, levels = names(explanatory_labels))
    )
}



filter_covid_vax_data <- function(data) {
  data %>%
    filter(explanatory == "exp_already_vax") %>%
    filter(is.finite(mean), is.finite(low), is.finite(high)) %>%
    mutate(
      explanatory_value = factor(explanatory_value, levels = c("No", "Yes")),
      explanatory = factor(explanatory, levels = names(explanatory_labels))
    )
}

# .Flu Vax Data
filter_flu_vax_data <- function(data) {
  #print(unique(data$explanatory_value[data$explanatory == "exp_flu_vax"]))
  data %>%
    filter(explanatory == "exp_flu_vax") %>%
    filter(is.finite(mean), is.finite(low), is.finite(high)) %>%
    mutate(
      explanatory_value = recode(as.character(explanatory_value),
                                 "0" = "No",
                                 "1" = "Yes"),
      explanatory_value = factor(explanatory_value, levels = c("No","Yes")),
      explanatory = factor(explanatory, levels = names(explanatory_labels))
    )
}


# Function to inspect encodings by explanatory variable
print_explanatory_encodings <- function(data) {
  explanatory_vars <- unique(data$explanatory)

  for (var in explanatory_vars) {
    cat(glue::glue("\n==== {var} ====\n"))
    values <- data %>%
      filter(explanatory == var) %>%
      pull(explanatory_value) %>%
      unique()

    print(values)
  }
}


