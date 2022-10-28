# Libraries
library(rgee)
library(raster)
library(rasterdiv) # per calcolare il Rao Index


geometry <- ee$Geometry$Polygon(
            c(c(c(5.382995960953916, 47.6029394590626), 
            c(5.382995960953916, 36.027465277864145),
            c(19.621277210953917, 36.027465277864145),
            c(19.621277210953917, 47.6029394590626)))
            )

collection <- 'COPERNICUS/S2'

vis_false_col <- list(
                       min = 0,
                       max = 3500,
                       bands = c("B8", "B4", "B3"),
                       gamma = .5
                       )
                       
 
sent2 <- ee$ImageCollection(collection)$
     filter(ee$Filter$lt("CLOUDY_PIXEL_PERCENTAGE", 10))$
     filterDate('2020-06-01', '2020-08-30')$
     filterBounds(geometry)

median_pix <- sent2$median()
median_clip <- median_pix$clip(geometry)

Map$addLayer(median_clip, vis_false_col, 'FALSE COLOR ITALY MOSAIC')

it_mosaic <- median_clip

it_mosaic_raster <- ee_as_raster(
   image = it_mosaic,
   region = geometry,
   via = "drive"
 )
 # ci mette tantissimo...
 
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
                  
plot(out_rao, main = 'Italy Rao')
