library(rgdal)
library(tmap)
library(gstat)
library(raster)
library(sp)
library(maptools)
library(leaflet)

# get boundaries
main_quad <- readOGR("boundaries/main_quad_d.shp")

# get data
peak <- readOGR("cleandata/peak.geojson")
nonpeak <- readOGR("cleandata/nonpeak.geojson")

# transform CRS
main_quad <- spTransform(main_quad, CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"))

# plot map
tm_shape(main_quad) + 
  tm_polygons() +
  tm_shape(peak) + 
  tm_dots()

# do idw interpolation, code adapted from: https://mgimond.github.io/Spatial/interpolation-in-r.html
getraster<- function(data, name){
  # specify bounding area
  points_test <- data
  points_test@bbox <- main_quad@bbox
  
  # create empty grid
  grd              <- as.data.frame(spsample(points_test, "regular", n=50000))
  names(grd)       <- c("X", "Y")
  coordinates(grd) <- c("X", "Y")
  gridded(grd)     <- TRUE  # Create SpatialPixel object
  fullgrid(grd)    <- TRUE  # Create SpatialGrid object
  proj4string(grd) <- proj4string(points_test)
  
  # do interpolation
  points_test.idw <- gstat::idw(leq_mean ~ 1, points_test, newdata=grd, idp=2.0)
  
  # clip to quad
  r       <- raster(points_test.idw)
  r.m     <- mask(r, main_quad)
  
  
  tm_shape(r.m) + 
    tm_raster(n=10,palette = "OrRd",
              title="Noise Levels in Decibels") + 
    tm_shape(points_test) + tm_dots(size=0.01) +
    tm_legend(legend.outside=TRUE)
  
  # write to raster
  writeRaster(r.m, name, format = "GTiff")
  
}