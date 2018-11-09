---
title: "Plan for the lidR workshop"
author: "Jean-Romain Roussel"
output: 
  pdf_document:
    number_sections: true
    toc: true
    toc_depth: 3
---


# Basic usage of lidR part 1


## Quick introduction

A quick (< 15 minutes) introduction to explain why and how I made lidR + simple usage of `lidR` on a small data loaded in memory (half day).

- **How and why it was designed:** during my phd for my own usage at the beginning and development for the community now. Supported by a canada wide research group and now by the ministry of forest inventory in Quebec.
- **Main purposes:** mainly designed for research and development i.e. to play easily with data and help to explore, build and create tools. Not designed for operationnal usage. That why I'll never ever tell to anybody what they *must* do. Instead I only tells people what they *can* do and *how* they can implement their ideas without any comment on the ideas themselves.
- **The tools in lidR**: quasi exclusively algorithms from the litterature. That way the algorithms have a peer-reviewed documentation. I'm not a judge of the pertinence of the methods, I only provide access to them to allow the community to test what was published.
- **Functionalities:** functionnalities we cannot find in other popular LiDAR processing software. Several published ITS methods, ABA+ITS with user-defined metrics and models, ability to actually manipulate the data and to make your own tools. It is very different from lastools, for example, which is designed for super effecient processing but which cannot easly be used to implement your ideas.
- **Future developments:** I'm expecting to be able to make the workshop on the beta version of the version 2.0 of the package. So we will actually use future developpment in preview

## `io` function family

- **Import ALS data: ** `LAS` formal class. Representation of LAS data in R and few words on the las specifications. Importance of memory usage consideration in R when reading LAS data. Importance of `select` and `filter` options in `readLAS`. 
- **Check ALS data: ** display with `plot.LAS` visual inspection. Limitations of `rgl` as display engine. 
- **Write ALS data: ** function `writeLAS`. Some words about the header in relationship with las specifications.

## `lasfilter` function family

- **Point cloud filtering:** `lasfilter`, `lasfilterground`, `lasfilterfirst`, `lasfiltersurfacepoints` and so on. Speak about deep copies in R. Emphasis on `filter` argument in `readLAS`
- **Point cloud clipping:** `lasclip*` functions. Example on simple geometries and complex polygons. Speak about deep copies in R. Emphasis on `filter` argument in `readLAS`.

## `grid` function family 

- **Area Based Approach:** `grid_metrics` compute any metrics you want, that is the strenght of lidR
- **Digital terrain model:**  `grid_terrain` to model the terrain.
- **Canopy height models:** `grid_canopy` and the different existing algorithms to compute a CHM.

# Basic usages of lidR - part 2

Simple usage of `lidR` on a small data loaded in memory (half day).

## `las` function family

- **Ground points segmentation:** `lasground` is mainly for small to medium size plot. For broad scale lastools (for example) should be preferred. Tell a word about shallow copies in R.
- **Normalization:** `lasnormalize` is mainly for small to medium size plots. For broad scale lastools (for example) should be preferred. Tell a word about shallow copies in R.
- **Geographic data merging:** `lasclassify` tell a word about shallow copies in R.
- **Individual tree segmentation:** `lastrees` studied in next sections

## `tree` function family

- **Individual tree detection:**  `tree_metrics` with several algorithms
- **Individual tree segmentation:** `lastrees` is actually in the las family but studied here for pedagogic purposes.
- **Individual tree metrics: ** `tree_metrics` computes metrics for each tree like `grid_metrics`.

# Extension to entiere catalog (operationnaly oriented)

Simple and semi-advanced usage of lidR on a big catalog too big to be loaded in memory. In this session we will redo the session 1 and 2 but with big dataset not loaded in memory.

## Extending the basics to an entiere catalog

- `LAScatalog` formal class. A class to work with big data. Look at functions `catalog`, `plot.LAScatalog`
- Redo all the basics with a `LAScatalog`. Everybody should now know the basics so it's going to be relatively quick. Emphasis will be made on processing options.
    - Extract (clip) any geometry of point at country wide scales
    - ABA at country wide scales
    - Tree detection at country scales
    - and so on
    
## `catalog` function family

- See some `catalog_*` functions such as `catalog_retile`, `catalog_select`
- Extend the possibilities with `catalog_apply` which is the main catalog function and enable to create your own tools.

# Advanced possibilities (research oriented)

Advanced usage of lidR with usually small catalogs for research and exploration purpose.

## Tree detection algorithms against field data

- **tree detectction**, test algorithms against field data.

## New metrics for biomass predictions

- **Area based approach**, test the relevance of new metrics for biomass predictions.

## Create a noise removal function

- **noise removal**, write your own simple noise removal function. Make a catalog wide version of this function.

## Develop plugins for lidR

- **plugins addition**, plugin system in `lidR`. Package `lidRplugins` or third party plugins.



