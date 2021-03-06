if (suppressWarnings(
  require("testthat") &&
  require("ggeffects") &&
  require("sjlabelled") &&
  require("survey") &&
  require("sjstats") &&
  require("sjmisc")
)) {
  # svyglm -----

  data(nhanes_sample)

  nhanes_sample$total <- dicho(nhanes_sample$total)

  # create survey design
  des <- svydesign(
    id = ~SDMVPSU,
    strat = ~SDMVSTRA,
    weights = ~WTINT2YR,
    nest = TRUE,
    data = nhanes_sample
  )

  # fit negative binomial regression
  fit <- suppressWarnings(svyglm(total ~ RIAGENDR + age + RIDRETH1, des, family = binomial(link = "logit")))

  test_that("ggpredict, svyglm", {
    expect_s3_class(ggpredict(fit, "age"), "data.frame")
    expect_s3_class(ggpredict(fit, c("age", "RIAGENDR")), "data.frame")
  })

  test_that("ggeffect, svyglm", {
    expect_s3_class(ggeffect(fit, "age"), "data.frame")
    expect_s3_class(ggeffect(fit, c("age", "RIAGENDR")), "data.frame")
  })
}
