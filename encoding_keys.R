# ... hard code the encodings...


exp_All <-c("")

# n = 1/7
# =========================
# explanatory: exp_age_bin
# .. Age ..................
# =========================
# # - sub categories........................ y-axis ordering
# explanatory_value = 0
# # - desired label (for graphing): "<20"        0
# explanatory_value = 20
# # - desired label (for graphing): "21-25"      1
# explanatory_value = 25
# # - desired label (for graphing): "25-29"      2
# explanatory_value = 30
# # - desired label (for graphing): ">30"        3
# .
#  >>>>>> usage >>>>>>>
# exp_age_labels[1]    # returns named vector: "0" = "<20"
# exp_age_labels[[1]]  # returns just value: "<20"
# names(exp_age_labels)[1]  # returns the name/key: "0"
# ....................
exp_age_bin <- c(
  `30` = ">30",
  `25` = "26-30",
  `20` = "21-25",
    `0` = "<20"
)


#explanatory_value = 0
# - desired label (for graphing): "Female"
#explanatory_value = 1
# - desired label (for graphing): "Male"
#explanatory_value = 3
# - desired label (for graphing): "Non-binary third gender"
#explanatory_value = 4
# - desired label (for graphing): "Prefer not to say"
# n = 2/7
# ============================
# explanatory: exp_gender
# .. Gender ..................
# ============================

# Example access:
exp_gender <- c(
  `0` = "Female",
  `1` = "Male",
  `3` = "Non-binary third gender",
  `4` = "Prefer not to say"
)



# n = 3/7
# ============================
# exp_race
# .. Race ....................
# ============================
exp_race <- c(
  '5' = "White",
  '4' = "Native Hawaiian/Other\nPacific Islander",
  '3' = "Black/African American",
  '2' = "Asian",
  '1' = "American Indian/\nNative Alaskan"
  )


# n = 4/7
# ============================
# explanatory: exp_ethnicity
# .. Ethnicity ...............
# ============================
exp_ethnicity <- c(
  '1' = "Non-Hispanic/Non-Latino",
  '2' = "Hispanic/Latino"
)



# n = 5/7
# ============================
# exp_profession
# .. Profession ..............
# ============================
exp_profession <- c(
  '1'="Nursing",
  '0'="Medical"
)



# n = 6/7
# ============================
# explanatory: exp_already_vax
# .. Had COVID vaccine .......
# ============================
exp_already_vax <- c(
  '1'="Yes",
  '0'="No"
)



# n = 7/7
# ============================
# explanatory: exp_flu_vax
# .. Had flu vaccine this year
# ============================
exp_flu_vax <- c(
    '1'="Yes",
  '0'="No"
)


# - ENCODING KEYS: COLS:
# Label mappings for response
response_labels_COLS <- c(
  resp_will_recommend = "I will recommend\n the vaccine to\nfamily, friends,\nand community\nmemebers.",
  resp_trust_info = "I trust\nthe infomation that I\n have received about\nthe vaccines.",
  resp_confidence_science = "I am confident in\nthe scientific\n vetting process for\nthe new COVID\nvaccines.",
  resp_concern_safety = "I am concerned\nabout the safety\nand side effects of\nthe vaccine.",
  resp_feel_safe_at_work = "Getting the vaccine\n will make me feel\nsafer at work.",
  resp_safety = "Based on my\n understanding. I\n believe the vaccine\nis safe."
)


# Labels for rows (explanatory variables), including Gender and Race
# >>>>> USAGE >>>>>>
# Get the first element (value with name "All")
# explanatory_labels_by_total_group_ROWS[1]
# #>All
# #>"All"
#
# # Just the value at index 1
# explanatory_labels_by_total_group_ROWS[[1]]
# #> [1] "All"
#
# # Get name (key) at index 1
# names(explanatory_labels_by_total_group_ROWS)[1]
# #> [1] "All"
explanatory_labels_by_total_group_ROWS <- c(
  All = "All",
  exp_age_bin = "Age",
  exp_gender = "Gender",
  exp_race = "Race",               # Added Race label
  exp_ethnicity = "Ethnicity",
  exp_profession = "Profession",
  exp_already_vax = "Had COVID\n vaccine",
  exp_flu_vax = "Had flu\n vaccine this\n year"
)











