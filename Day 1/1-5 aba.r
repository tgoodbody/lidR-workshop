library(lidR)
rm(list = ls(globalenv()))

# ======================================
#         AREA BASED APPROACH
# ======================================

las = readLAS("data/MixedEucaNat_normalized.laz")
col = height.colors(50)

# A. Basic usage
# =================

# Mean height of points within 10x10 m pixel

hmean = grid_metrics(las, mean(Z), 10)
hmean
plot(hmean, col = col)

# Max height of points within 10x10 m pixel

hmax = grid_metrics(las, max(Z), 10)
hmax
plot(hmax, col = col)

# Obviously we can compute several metrics at once

metrics = grid_metrics(las, list(hmax = max(Z), hmean = mean(Z)), 10)
metrics
plot(metrics, col = col)

# For simplicity lidR propose a set of metrics

metrics = grid_metrics(las, .stdmetrics_z, 10)
metrics
plot(metrics, col = col)

plot(metrics, "zsd", col = col)

?.stdmetrics

# B. Advanced usage with user defined metrics
# ===========================================

# The strenght of the function is the ability to map almost everything

f = function(x, weight) { sum(x*weight)/sum(weight) }

X = grid_metrics(las, f(Z, Intensity), 10)

plot(X, col = col)

# C. Exercice and question
# ===========================

# 1. Assuming the biomass is predicted by this equation: B = 0.5 * mean Z + 0.9 * 90th percentile of Z
#    map the biomass on this tiny file



