# rgee x rasterdiv

# step 0: libraries
library(rgee)
library(rgeeExtra)
library(raster)
library(rasterdiv)
library(stars)

# step 1: load ee.Image()
img <- ee$Image("LANDSAT/LC08/C01/T1_SR/LC08_038029_20180810")

# get bands infos
img$bandNames()$getInfo()

# step 2: compute NDVI
ndvi <- img$normalizedDifference(c("B5", "B4"))

# ndvi palette!
ndvi_plt <- list(
                  min = -1,
                  max = 1,
                  palette = c('ff0000', 'ffbd00', 'faff00', '3eff00', '00c218')
                )
                
# step 3: convert the NDVI ee.Image in raster
# first create geometry...
geometry <- ee$Geometry$Rectangle(
   coords = c(-110.8, 44.6, -110.6, 44.7),
   proj = "EPSG:4326",
   geodesic = FALSE
 )
 
# ...and then convert to raster!
img_01 <- ee_as_raster(
   image = ndvi,
   region = geometry,
   via = "drive" # the raster will be stored in google drive
 )
 
 # step 4: read and plot the converted raster
 ndvi_raster <- img_01$layer
 ndvi_raster
 
# class      : RasterLayer 
# dimensions : 373, 531, 198063  (nrow, ncol, ncell)
# resolution : 30, 30  (x, y)
# extent     : 515835, 531765, 4938525, 4949715  (xmin, xmax, ymin, ymax)
# crs        : +proj=utm +zone=12 +datum=WGS84 +units=m +no_defs 
# source     : noid_image.tif 
# names      : layer
 
 # plot...
 plot(ndvi_raster)
 
 # step 4: Rao
 # funzione 'paRao' perché 'Rao' è 'deprecated' 
 out_rao <- paRao(
                  x = ndvi_raster, 
                  area = NULL, 
                  field = NULL, 
                  dist_m = "euclidean", 
                  window = 33, 
                  alpha = 1, 
                  method = "classic", 
                  rasterOut = TRUE, 
                  lambda = 0, 
                  na.tolerance = 1.0, 
                  rescale = FALSE, 
                  diag = TRUE, 
                  simplify = 1, 
                  np = 1, 
                  cluster.type = "SOCK", 
                  debugging = FALSE
                  )
 
out_rao

# $window.33
# $window.33$alpha.1
# class      : RasterLayer 
# dimensions : 373, 531, 198063  (nrow, ncol, ncell)
# resolution : 30, 30  (x, y)
# extent     : 515835, 531765, 4938525, 4949715  (xmin, xmax, ymin, ymax)
# crs        : +proj=utm +zone=12 +datum=WGS84 +units=m +no_defs 
# source     : memory
# names      : layer 
# values     : 0.02094984, 0.2405478  (min, max)
 
 
 rao_raster <- out_rao$window.33$alpha.1
 
 #class      : RasterLayer
 
 # plot 
 plot(rao_raster, main = 'Rao raster')
 
 
 
 
 
 
 
 
