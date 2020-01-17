library(lidR)
rm(list = ls(globalenv()))

# ======================================
#    SELECTION OF REGIONS OF INTEREST
# ======================================

las = readLAS("data/MixedEucaNat_normalized.laz", select = "*")

?lasclip

# A. Select simple geometries
# =============================

subset = lasclipCircle(las, 203890, 7358935, 30)

plot(subset)

subset2 = lasclipRectangle(las, 203890, 7358935, 203890 + 40, 7358935 + 30)

plot(subset2)


x = runif(2, 203830, 203980)
y = runif(2, 7358900, 7359050)

subsets1 = lasclipCircle(las, x, y, 30)

subsets1

plot(subsets1[[1]])
plot(subsets1[[2]])


# D. Extraction of complex geometries
# ====================================

planting = shapefile("data/shapefiles/MixedEucaNat.shp")

plot(las@header, map = FALSE)
plot(planting, add = TRUE)


eucalyptus = lasclip(las, planting)

plot(eucalyptus)
