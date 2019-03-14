library(rgdal)
library(tmap)
library(gstat)
library(raster)
library(sp)

# read data
main_quad <- readOGR("boundaries/main_quad_d.shp")
points <- readOGR("cleandata/080319NonPeak.geojson")

# plot map
tm_shape(main_quad) + 
  tm_polygons() +
  tm_shape(points) + 
  tm_dots()

# transform CRS
main_quad <- spTransform(main_quad, CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"))

# do inv_dw
grid <- raster(main_quad)
inv_dw <- idw(leq_mean~1,points, as(grid,'SpatialGrid'),idp=2)
inv_dw_raster <- raster(inv_dw)
inv_dw_raster.m <- mask(inv_dw_raster,main_quad)

# plot inv_dw
tm_shape(inv_dw_raster.m) + 
  tm_raster(n=10,palette = "RdBu", auto.palette.mapping = FALSE,
            title="Noise levels in decibels") + 
  tm_shape(points) + tm_dots(size=0.2) +
  tm_legend(legend.outside=TRUE)


