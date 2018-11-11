library(lidR)
rm(list = ls(globalenv()))

# ======================================
#         OTHER LASFUNCTIONS
# ======================================

# We have already seen several function families:
#
# - io: to read and write LAS object in las/laz files
# - lasfilter*: to select points of interest (return LAS objects)
# - lasclip*: to select regions of interest (return LAS objects)
# - grid_*: to rasterize the point cloud (return Raster* objects)
#
# We now introduce the other functions las* that return LAS objects

las = readLAS("data/MixedEucaNat_normalized.laz")

# A. lasmergespatial: merge geographic data with the point cloud
# ==========================================================

# 1. With a shapefile of polygons
# -------------------------------

# Load a shapefile

eucalyptus = shapefile("data/shapefiles/MixedEucaNat.shp")

# Merge with the point cloud

lasc = lasmergespatial(las, eucalyptus, "in_plantation")
lasc

# Visualize

plot(lasc, color = "in_plantation")

# Do something: here, for the example, we simply filter the points. You can imagine any application

not_plantation = lasfilter(lasc, in_plantation == FALSE)
plot(not_plantation)

# 2. With a raster
# ----------------------------

# In the past it was possible to get an easy access to the google map API via R to get satellite
# images. Former example consisted in RGB colorization of the point cloud. It is no longer possible
# to access to the google API without a registration key. Thus I replaced the RGB colorization by a
# less nice example.

# Make a raster. Here a CHM

chm = grid_canopy(las, 1, p2r())
plot(chm, col = height.colors(50))

# Merge with the point cloud

lasc = lasmergespatial(las, chm, "hchm")
lasc

# Do something. Here for the example we simply filter a layer below the canopy.
# You can imagine any application. RGB colorization was one of them.

layer = lasfilter(lasc, Z > hchm - 1)
plot(layer)

not_layer = lasfilter(lasc, Z < hchm - 1)
plot(not_layer)

# B. Memory usage consideration
# ===============================

pryr::object_size(las)
pryr::object_size(lasc)

pryr::object_size(las, lasc)

# This is true for any lasfunction that does not change the number of points i.e
# almost all the functions but lasfilter*, lasclip* and lascheck

# C. lassmooth: point cloud based smoothing
# =========================================

# Smooth the point cloud
lass = lassmooth(las, 4)

plot(lass)

# It is not really useful. It may become interesting combined with lasfiltersurfacepoints

lassp = lasfiltersurfacepoints(las, 0.5)
lass = lassmooth(lassp, 2)

plot(lassp)
plot(lass)

# D. lasadddata: add data to a LAS object
# ========================================

A <- runif(nrow(las@data), 10, 100)

# Forbidden

las$Amplitude <- A

# The reason is to force the user to read the documentation of lasadddata
?lasadddata

# lasadddata does what you might expect using <-

las_new = lasadddata(las, A, "Amplitute")

# But the header is not updated

las_new@header

# lasaddextrabyte actually adds data in a way that enables the data to be written in las files

las_new = lasaddextrabytes(las, A, "Amplitude", "Pulse amplitude")

# The header has been updated

las_new@header

# E: lasground: segment ground points
# =======================================

las = readLAS("data/MixedEucaNat.laz")
plot(las)

# The original file contains an outlier

hist(las$Z, n = 30)
range(las$Z)

# Read the file skipping the outlier

las = readLAS("data/MixedEucaNat.laz", filter = "-drop_z_below 740")
plot(las)

# The file is already classified. For the purpose of the example we can clear this classification

las$Classification = 0 # Error, explain why.

plot(las, color = "Classification")

# Segment the ground points with lasground

las = lasground(las, csf(rigidness = 2.5))

plot(las, color = "Classification")

ground = lasfilterground(las)
plot(ground)

# F. lasnormalize: remove topography
# ===================================

# 1. With a DTM
# -------------

dtm = grid_terrain(las, 1, tin())

plot(dtm, col = height.colors(50))
plot_dtm3d(dtm)

lasn = lasnormalize(las, dtm)

plot(lasn)

lascheck(lasn)


# 2. Without a DTM
# -----------------

lasn = lasnormalize(las, tin())
plot(lasn)

lascheck(lasn)

# Explain the difference betwwen the two methods

# G. Other las* functions
# ========================

# lastrees (see next section)
# lassnags
# lasunsmooth
# lasunormalize
# lasflightline
# laspulse
# ...
