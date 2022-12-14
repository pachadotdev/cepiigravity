% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/download.R
\name{cepiigravity_download}
\alias{cepiigravity_download}
\title{Download the Gravity Database to your computer}
\usage{
cepiigravity_download(ver = NULL)
}
\arguments{
\item{ver}{The version to download. By default it is the latest version
available on GitHub. All versions can be viewed at
\url{https://github.com/pachadotdev/cepiigravity/releases}.}
}
\description{
This command downloads the entire database as a single zip file that is
unzipped to create the local database. If you do not want to download the
database on your home computer, run usethis::edit_r_environ() to create the
environment variable GRAVITY_DIR with the path.
}
\examples{
\dontrun{ gravity_download() }
}
