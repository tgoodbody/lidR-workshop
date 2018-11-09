library(lidR)
rm(list = ls(globalenv()))

# ======================================
#       CATALOG FUNCTIONS
# ======================================

# We have already seen the function 'catalog'. It exists several other catalog_* functions
# - catalog_retile
# - catalog_select
# - catalog_intersect
# And catalog_apply which is the more important function. It gives access to the catalog processing
# engine. Each lidR function that manipulates a LAScatalog use internally catalog apply. With catalog
# Apply you can build your own process

?catalog_apply


# A. Exemple of catalog apply
# =====================================

# Compute a rumple index for each pixel in an ABA
# - What is a rumple index? (see function rumple_index)
# - On which points it makes sense to compute a rumple index?
# - Rumple index is computationnaly demanding? How to compute it faster?
#
# - Load a single file, make a function that compute a pertinent RI on this single file
# - Scale up this function to apply it over the entire catalog

ctg = catalog("data/Farm_A/")

las = readLAS(ctg$filename[16], filter = "-drop_withheld -drop_z_below 0 -drop_z_above 40")

las = lasfiltersurfacepoints(las, 0.5)

plot(las)

ri = grid_metrics(las, rumple_index(X,Y,Z), 10)


grid_rumple_index = function(las, res1 = 10, res2 = 0.5)
{
  las = lasfiltersurfacepoints(las, res2)
  ri = grid_metrics(las, rumple_index(X,Y,Z), res1)
  return(ri)
}

ri = grid_rumple_index(las)
plot(ri, col = height.colors(50))


grid_rumple_index = function(cluster, res1 = 10, res2 = 0.5)
{
  las = readLAS(cluster)
  if (is.empty(las)) return(NULL)

  las <- lasfiltersurfacepoints(las, res2)
  ri  <- grid_metrics(las, rumple_index(X,Y,Z), res1)
  ri  <- raster::crop(ri, extent(cluster))
  return(ri)
}

opt_select(ctg) <- "xyz"
opt_filter(ctg) <- "-drop_withheld -drop_z_below 0 -drop_z_above 40"
opt_cores(ctg)  <- 2L
opt_chunk_buffer(ctg) <- 15
opt_chunk_size(ctg) <- 0

output = catalog_apply(ctg, grid_rumple_index, res1 = 20, res2 = 0.5)
output = do.call(merge, output)

plot(output, col = height.colors(50))


# B. Exercice
