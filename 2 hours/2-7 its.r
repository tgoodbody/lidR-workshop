library(lidR)
rm(list = ls(globalenv()))

# ======================================
#    INDIVIDUAL TREE DETECTION
# ======================================

ctg = catalog("data/Farm_A/")
col = height.colors(50)

chm = grid_canopy(ctg, 0.5, p2r())

plot(chm, col = col)

ttops = tree_detection(chm, lmf(3))

plot(crop(chm, extent(chm) - 500), col = col)
plot(crop(ttops, extent(ttops) - 500), add = T)

tree = function(cluster, ws = 3, res2 = 0.5)
{
  las = readLAS(cluster)
  if (is.empty(las)) return(NULL)

  las   <- lasfiltersurfacepoints(las, res2)
  ttops <- tree_detection(las, lmf(ws))
  ttops <- raster::crop(ttops, extent(cluster))
  return(ttops)
}

opt_select(ctg) <- "xyz"
opt_filter(ctg) <- "-drop_withheld -drop_z_below 0 -drop_z_above 40"
opt_cores(ctg)  <- 2L
opt_chunk_buffer(ctg) <- 15
opt_chunk_size(ctg) <- 0

output <- catalog_apply(ctg, tree, ws = 3, res2 = 0.5) #~40 sec
output <- do.call(rbind, output)


plot(output, add = T)

rgdal::writeOGR(ttops, "data/output/", "ttops.shp", driver = "ESRI Shapefile")
writeRaster(chm, "data/output/chm.tif")
