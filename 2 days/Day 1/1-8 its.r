library(lidR)
rm(list = ls(globalenv()))

# ======================================
#      INDIVIDUAL TREE SEGMENTATION
# ======================================

las = readLAS("data/MixedEucaNat_normalized.laz")
col1 = height.colors(50)
col2 = pastel.colors(900)

# A. CHM based methods
# ====================

# 1.Build a CHM
# --------------

chm = grid_canopy(las, 0.5, p2r(0.15))
plot(chm, col = col1)

# 2. OptionaLly smooth the CHM
# ----------------------------

kernel = matrix(1,3,3)
schm = raster::focal(chm, w = kernel, fun = median, na.rm = TRUE)

plot(schm, col = height.colors(30))

# 3. Tree detection
# ------------------

ttops = tree_detection(schm, lmf(2.5))

plot(chm, col = col1)
plot(ttops, col = "black", add = T)

# 4. Segmentation
# -----------------

las = lastrees(las, dalponte2016(schm, ttops))

plot(las, color = "treeID", colorPalette = col2)

tree25 = lasfilter(las, treeID == 25)
tree125 = lasfilter(las, treeID == 125)

plot(tree25)
plot(tree125)

# 5. Working with raster
# --------------------------------

# As said previously lidR deals with point clouds. Thus we used lastrees.
# But here from the CHM the point cloud is not strictly required.

trees = dalponte2016(chm = chm, treetops = ttops)()

plot(trees, col = col2)
plot(ttops, add = TRUE)

# B. Point cloud based methods (No CHM)
# =====================================

# 1. Tree detection
# ------------------

ttops = tree_detection(las, lmf(3, hmin = 5))


x = plot(las)
add_treetops3d(x, ttops)

# 2. What can be done on a raster can be done on a point cloud
# ------------------------------------------------------------

lassp = lasfiltersurfacepoints(las, 0.5)
slassp = lassmooth(lassp, 1.5)
plot(slassp)

ttops = tree_detection(slassp, lmf(3))

x = plot(las)
add_treetops3d(x, ttops)

# 3. Tree segmentation
# --------------------

las = lastrees(las, li2012())

plot(las, color = "treeID", colorPalette = col2)

# This algorithm does not seem pertinent for such a dataset.

# C. Extraction of metrics
# ==========================

ttops = tree_detection(schm, lmf(2.5))
las = lastrees(las, dalponte2016(schm, ttops))

plot(las, color = "treeID", colorPalette = col2)

# 1. tree_metrics works like grid_metrics
# ----------------------------------------

metrics = tree_metrics(las, list(n = length(Z)))
metrics
spplot(metrics, "n")

# 2. It maps any user's function at the tree level
# -----------------------------------------------

f = function(x, y)
{
  ch <- chull(x,y)
  ch <- c(ch, ch[1])
  coords <- data.frame(x = x[ch], y = y[ch])
  p  = sp::Polygon(coords)
  area = p@area

  return(list(A = area))
}

metrics = tree_metrics(las, f(X,Y))
metrics
spplot(metrics, "A")

# 3. Some metrics are already recorded
# ------------------------------------

metrics = tree_metrics(las, .stdtreemetrics)
metrics

# 4. tree_hull give several kinds of tree hull
# -------------------------------------------

# convex hull

cvx_hulls = tree_hulls(las)
cvx_hulls

plot(cvx_hulls)
plot(ttops, add = TRUE)

cvx_hulls$A = metrics$convhull_area

spplot(cvx_hulls, "A")

# concave hulls (long computation)

ccv_hulls = tree_hulls(las, type = "concave")

ccv_hulls$Z = metrics$Z
spplot(ccv_hulls, "Z")


# Conclusion
# =============

# We have seen several function families:
#
# - io: to read and write LAS object in las/laz files
# - lasfilter*: to select points of interest (return LAS objects)
# - lasclip*: to select regions of interest (return LAS objects)
# - grid_*: to rasterize the point cloud (return Raster* objects)
# - las*: to modify las data (return LAS objects)
# - tree_*: that processes point cloud at tree level (return Spatial* objects)
