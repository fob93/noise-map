library(rgdal)
library(tmap)
library(gstat)
library(raster)
library(sp)

#setwd("~/Documents/UCL/Term_2/Sensors and Location/noise-map")
setwd("C:/Users/Junju/Desktop/Masters/Term 2/Sensors and Location/Assignment 2/noise-map")
# read data
main_quad <- readOGR("boundaries/main_quad_d.shp")
#points <- readOGR("cleandata/080319NonPeak.geojson")
points <- readOGR("cleandata/120319NonPeak.geojson")

# plot map
tm_shape(main_quad) + 
  tm_polygons() +
  tm_shape(points) + 
  tm_dots()

# transform CRS
main_quad <- spTransform(main_quad, CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"))

# specify bounding area
points_test <- points
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
  tm_raster(n=10,palette = "OrRd", auto.palette.mapping = FALSE,
            title="Noise Levels in Decibels") + 
  tm_shape(points_test) + tm_dots(size=0.005) +
  tm_legend(legend.outside=TRUE)

# write to raster
#writeRaster(r.m, "noise_raster_test", format = "GTiff")


# # do inv_dw
# grid <- raster(points, res = 100)
# inv_dw <- idw(leq_mean~1,points, as(grid,'SpatialGrid'),idp=2)
# inv_dw_raster <- raster(inv_dw)
# inv_dw_raster.m <- mask(inv_dw_raster,main_quad)
# 
# # plot inv_dw
# tm_shape(inv_dw_raster.m) + 
#   tm_raster(n=10,palette = "RdBu", auto.palette.mapping = FALSE,
#             title="Noise levels in decibels") + 
#   tm_shape(points) + tm_dots(size=0.2) +
#   tm_legend(legend.outside=TRUE)

# library(rgl)
# 
# idw2 <- as.matrix(inv_dw_raster.m)
# persp3d(idw2, col = "red")



