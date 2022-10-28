# Libraries
library(rgee)
library(raster)
library(rasterdiv) # per calcolare il Rao Index

# - - - - - - - - - - START - - - - - - - - - -

# create geometry from point coordinates
geometry <- ee$Geometry$Polygon(
            c(c(c(5.382995960953916, 47.6029394590626), 
            c(5.382995960953916, 36.027465277864145),
            c(19.621277210953917, 36.027465277864145),
            c(19.621277210953917, 47.6029394590626)))
            )

# variable containing the details of the collection
collection <- 'COPERNICUS/S2'

# Palette for False color images
vis_false_col <- list(
                       min = 0,
                       max = 3500,
                       bands = c("B8", "B4", "B3"),
                       gamma = .5
                       )

# ndvi palette!
ndvi_plt <- list(
                  min = -1,
                  max = 1,
                  palette = c('ff0000', 'ffbd00', 'faff00', '3eff00', '00c218')
                ) 
                       
# Sentinel 2 image collection, filtered for cloud coverage, date and geometry
sent2 <- ee$ImageCollection(collection)$
     filter(ee$Filter$lt("CLOUDY_PIXEL_PERCENTAGE", 10))$
     filterDate('2020-06-01', '2020-08-30')$
     filterBounds(geometry) 

median_pix <- sent2$median() # median values of pixels
median_clip <- median_pix$clip(geometry) # the clipped image

Map$centerObject(geometry)
Map$addLayer(median_clip, vis_false_col, 'FALSE COLOR ITALY MOSAIC')

it_mosaic <- median_clip

it_mosaic_raster <- ee_as_raster(
   image = it_mosaic,
   region = geometry,
   via = "drive"
 )
# ci mette tantissimo... circa un'ora e qualche minuto...
# manco troppo... dai... grrrrr >:)
 
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
# ci vorrà ovviamente uno sproposito di tempo per far girare questo algoritmo su dati così impegnativi

plot(out_rao, main = 'Italy Rao') # plot basico 

# così facendo però mi importa tutte le bande della collezione e a me non serve..
# teoricamente per il Rao Index mi serve o FCI o NDVI

# per NDVI:
red <- sent2$select('B4') 
nir <- sent2$select('B8')
median_red <- red$reduce(ee$Reducer$median()) # valore mediano banda del rosso per la collezione
median_nir <- nir$reduce(ee$Reducer$median()) # valore mediano banda del nir per la collezione

# calcolo NDVI mediano della collezione filtrata per geometry, data e cloud coverage
median_ndvi <- median_nir$subtract(median_red)$divide(median_nir$add(median_red))
# adesso lo "clippo" con la geometry...
ndvi_clipped <- median_ndvi$clip(geometry)

# stesso procedimento di prima...
# quindi:
# conversione in raster e poi paRao


# - - - - - - - - - -  END (per ora) - - - - - - - - - -

