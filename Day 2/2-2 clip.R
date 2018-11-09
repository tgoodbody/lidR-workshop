library(lidR)
rm(list = ls(globalenv()))

# ======================================
#    SELECTION OF REGIONS OF INTEREST
# ======================================

ctg = catalog("data/Farm_A/")

# A. Select simple geometries
# =============================

x = 207830
y = 7357410

plot(ctg)
points(x,y)

subset = lasclipCircle(ctg, x, y, 30)

plot(subset, clear_artifact = TRUE)

subset2 = lasclipRectangle(ctg, x, y, x + 50, y + 60)

plot(subset2, clear_artifact = TRUE)

x = c(207846, 208131, 208010, 207852)
y = c(7357315, 7357537, 7357372, 7357548)

plot(ctg)
points(x,y)

subsets1 = lasclipCircle(ctg, x, y, 30)

plot(subsets1[[1]], clear_artifact = TRUE)
plot(subsets1[[3]], clear_artifact = TRUE)

lascheck(subsets1[[1]])
lascheck(subsets1[[3]])

# B. Introduction to catalog processing engine
# ============================================

?lasclip

# 1. Propagate the filter option to readLAS
# -----------------------------------------

opt_filter(ctg) <- "-drop_withheld"

subsets1 = lasclipCircle(ctg, x, y, 30)

lascheck(subsets1[[1]])
lascheck(subsets1[[3]])

# 2. Propagate the select option to readLAS
# -----------------------------------------

opt_select(ctg) <- "xyz"

subsets1 = lasclipCircle(ctg, x, y, 30)

subsets1[[1]]

# 3. Use multicore
# -----------------------------------------

opt_cores(ctg) <- 2

subsets1 = lasclipCircle(ctg, x, y, 30)

# 4. Look at current options
# -----------------------------------------

summary(ctg)

# 5. Do not return the output to R
# ----------------------------------------

opt_output_files(ctg) <- "data/output/test_lasclip1/plot_{ID}"

summary(ctg)

subsets1 = lasclipCircle(ctg, x, y, 30)

subsets1

plot(subsets1)

las = readLAS(subsets1$filename[2])

# lidar data do not match with satellite data (probably different times)
plot(las)

# D. Extraction of complexe geometries
# ====================================

ctg      = catalog("data/Farm_A/")
planting = shapefile("data/shapefiles/Farm_A.shp")

plot(planting)
plot(ctg, map = F, add = T)

# 1. clip from the shapefile and return the output in R (not recommanded)
# ---------------------------------------------------

# Do not run this snipets, it will load 1 GB of data in memory

las_planting = lasclip(ctg, planting)
las_planting = Filter(Negate(is.empty), las_planting)

plot(las_planting[[2]])

# 2. clip from the shapefile and write in files (recommanded)
# ---------------------------------------------------

opt_output_files(ctg) <- "data/output/test_lasclip2/{OBJECTID}_{SUBTALHAO}_{FAZENDA}"
opt_laz_compression(ctg) <- TRUE
opt_cores(ctg) <- 4

summary(ctg)

new_ctg = lasclip(ctg, planting) # a bit long computation

plot(new_ctg)

new_ctg$filename

las = readLAS(new_ctg$filename[3], select = "xyz")
plot(las, bg = "white")

# E. Exercice: extract a ground inventory
# ========================================

# The shapefile in data/shapefiles/ named ground_inventories.shp contains centers of plots
# Extract each plot with a radius of 20 m

ctg = catalog("data/Farm_A/")
plot_centers = shapefile("data/shapefiles/ground_inventories.shp")

plot(ctg)
plot(plot_centers, add = T, col = "red")

summary(ctg)

lasclip(ctg, plot_centers, radius = 20)
