library(lidR)
rm(list = ls(globalenv()))

# ======================================
#   SELECTION OF POINTS OF INTEREST
# ======================================

las = readLAS("data/MixedEucaNat_normalized.laz", select = "*")

las

plot(las)


# A. lasfilter* function allow for filtering point of interest algoritmically
# ============================================================================

?lasfilter
?lasfilters

# Filter first return

firstreturns = lasfilter(las, ReturnNumber == 1)
firstreturns
plot(firstreturns)

# Filter first return above 5 m.

firstreturnover5 = lasfilter(las, Z >= 5, ReturnNumber == 1)
plot(firstreturnover5)

# filter surface points

surfacepoints = lasfiltersurfacepoints(las, 0.5)
plot(surfacepoints)

# B. Think about memory usage !!
# ==============================

# las + firstreturn + firstreturnover5 ~= 3 copies of the original point cloud. When manipulating
# *big* data, one must be careful. Lidar point clouds maybe huge. Here it does not matters.

pryr::object_size(las)
pryr::object_size(firstreturns)
pryr::object_size(firstreturnover5)

pryr::object_size(las, firstreturns, firstreturnover5)

# One can do the following trick to erase original object

las = lasfilter(las, Z > 5, ReturnNumber == 1)

# But in pratice this is not very efficient because of the way R deals with memory
# (To study this advanced topic search for 'R garbage collector' in a search engine)


# The lasfilter* functions are really useful to the user to filter the data. But we must be careful
# to the memory usage if we manipulate *big* data in memory. This is an specific limitation of R itself.
# To get subset of the data we ACTUALLY NEED to make a copy of the dataset.

# C. Be clever, use the filter argument from readLAS (streaing filter)
# ==================================================

# A more efficient filter (both in term of speed and memory) is to filter the points of interest
# while reading the file. This way, no memory is uselessly allocated at the R level. Everything is
# done at the C++ level.

las = readLAS("data/MixedEucaNat_normalized.laz", filter = "-drop_z_below 5 -keep_first", select = "xyz")
las

plot(las)

# But some filter do not have streaming equivalent for exemple 'lasfiltersurfacepoint'


