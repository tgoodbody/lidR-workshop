This repository contains the material for a two days lidR workshop. You can install the material on your own machine following this README.

## 1. Material

To follow this workshop you need to download the content of this repository. It contains the code, the shapefiles and the lidar data we will use during the workshop.

## 2. R version and Rstudio

* You need to install a recent version of `R` i.e. `R 3.4.4` or `R 3.5.1` (recommended).
* We will work with [Rstudio](https://www.rstudio.com/). This IDE is not mandatory to follow the workshop but is highly recommended.

## 3. R Packages

You need to install the following packages from the CRAN prior to install the `lidR` package. Many of them are likely to be already installed on your machine. The reason you need to do that first is because we will use the new version of `lidR` that is not available on CRAN yet.

```r
install.packages(assertive,concaveman,data.table,future,geometry,glue,grDevices,gstat,lazyeval,imager,RANN,Rcpp,RCSF,rgeos,rgl,rlas,sf,stats,tools,utils)
```

On **linux** the following libraries are required on your system to install all these packages

```
sudo apt-get install libgdal-dev libgeos++-dev libudunit-dev libproj-dev libx11-dev libgl-dev libglu-dev libfreetype6-dev libv8-3.14-dev libcairo2-dev 
```

The following packages can be installed as well. They enhance the package `lidR`.

```r
install.packages(mapview,progress)
```

The following packages are not strictly necessary for the workshop but are recommended to manipulate data easily and solve some exercises:

```r
install.packages(dplyr,ggplo2,pryr)
```

## 4. lidR package

We will not use the released version of lidR available on CRAN (version 1.6.1), but the development version (version 2.0.0) which is not available yet on CRAN and which is deeply different from the previous release. Thus you need to install the package manually following these simple steps.

### Windows

I already prepared binaries for Windows. Download your version:

* For R 3.6: [here](https://drive.google.com/open?id=1dchHA6fIT8TipXAkXUYX-vmhnWGNJtUZ)
* For R 3.5: [here](https://drive.google.com/open?id=1EEUpN2m344VWbf_VsYnUrxuiV63e8ngT)
* For R 3.4: [here](https://drive.google.com/open?id=1Sfd_8uAY7xI4SNWrscsi1v03y_LA2ZVm)

And then run the following code to select and install the file you downloaded.

```r
install.packages(file.choose(), repos=NULL)
```

### Mac

Install `Xcode` from the Mac App Store. Install the `devtools` package and run:

```r
devtools::install_github("Jean-Romain/lidR", ref="devel")
```

Notice that I don't know how to help you with Xcode.

### Linux

Install the R development package, usually called `r-devel` or `r-base-dev` (it is likely to be already installed):

```
sudo apt-get install r-base-dev
```

Install the `devtools` package and run:

```r
devtools::install_github("Jean-Romain/lidR", ref="devel")
```

## 5. Check that everything is ok

Once everything is installed run the following script to ensure everything is ok. For example sometimes Mac users encounter issues with 3D display. This issue is not related to the `lidR` package itself but must be fixed to enjoy the workshop. Please report any trouble before the workshop.

```r
library(RCurl)
url <- "https://gist.githubusercontent.com/Jean-Romain/f711aff6237fa034fb45c88da99e8d0e/raw/daabd8a1c548478f86d353172487c6aa09afad5c/test_workshop.R"
script <- getURL(url, ssl.verifypeer = FALSE)
eval(parse(text = script))
```


