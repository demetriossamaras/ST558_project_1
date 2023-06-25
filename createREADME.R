## author: Demetrios Samaras
## date: 6/25/2023 
## purpose: Render Vignette_1.Rmd as a .md file called README.md for my repo.

rmarkdown::render(
  input="Vignette_1",
  output_format = "github_document",
  output_file = "README.md",
  runtime = "static",
  clean = TRUE,
  params = NULL,
  knit_meta = NULL,
  envir = parent.frame(),
  run_pandoc = TRUE,
  quiet = FALSE,
  encoding = "UTF-8"
)