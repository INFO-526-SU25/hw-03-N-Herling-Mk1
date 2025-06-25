# .............................................
# ==== store all the functions for HW3 here ===
# .............................................



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


