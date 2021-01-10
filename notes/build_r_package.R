
usethis::create_package("<package_name>")
usethis::proj_get()

usethis::use_r("<function_name>")

usethis::use_test("<function_name>")
usethis::use_testthat()

usethis::use_rcpp("<function_name>")
Rcpp::compileAttributes()
roxygen2::roxygenize()

usethis::use_vignette("<function_name>")

usethis::use_news_md()
usethis::use_cran_comments()
usethis::use_readme_md()
usethis::use_readme_rmd()

usethis::use_cc0_license("Yen On Chan")

usethis::use_package_doc()
devtools::document()

devtools::spell_check()
devtools::check()

usethis::use_git()

devtools::build()
devtools::build_manual()

# R CMD check $(pwd)
# R CMD check --as-cran $(pwd)

devtools::release()
