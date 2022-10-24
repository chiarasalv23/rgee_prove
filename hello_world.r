img <- ee$Image("insert_satellite_name/insert_image_name")
# try with: "LANDSAT/LC8_L1T_TOA/LC80440342014077LGN00" 
# San Francisco Bay Area!

# get bands infos
img$bandNames()$getInfo()

# computing NDVI
ndvi <- img$normalizedDifference(c("B5", "B4"))

# create false color image
vis_false_col <- list(
                      min = 0,
                      max = 0.5,
                      bands = c("B5", "B4", "B3"),
                      gamma = c(0.95, 1.1, 1)
                      )

# create natural color image
vis_nat_col <- list(
                      min = 0,
                      max = 0.5,
                      bands = c("B4", "B3", "B1"),
                      gamma = c(0.95, 1.1, 1)
                      )
                      
# ndvi palette!
# translated from JavaScript --->   var ndvi_plt = {min: -1, max: 1, palette: ['ff0000', 'ffbd00', 'faff00', '3eff00', '00c218']};
ndvi_plt <- list(
                  min = -1,
                  max = 1,
                  palette = c('ff0000', 'ffbd00', 'faff00', '3eff00', '00c218')
                ) 
                      
                      
Map$setCenter("insert_coordx", "insert_coordx")
# Set the center of the map on these coordinate
# try with: -122.1899, 37.5010, 10

Map$addLayer(img, vis_false_col) # or vis_nat_col
# Add a given layer to the map, applying the specifyed visualization parameters

Map$addLayer(ndvi, ndvi_plt)
# in this case, the parameters are the ndvi and the palette, not the bands parameters!


                     
