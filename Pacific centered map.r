## Pacific centered map ##
# author Valentin Stefan (https://github.com/valentinitnelav/valentinitnelav.github.io/blob/master/assets/2020-05-15-pacific-map-voronoi/pacific-map-voronoi.Rmd)
# edited by Leah Shizuru

# The first set of error messages was reached when trying to load in Natural Earth data. Warning messages:

# 1: In RGEOSUnaryPredFunc(spgeom, byid, "rgeos_isvalid"): Ring Self-intersection at or near point 78.719726559999998 31.887646480000001
# 2: In gDifference(world, box_cut):Invalid objects found; consider using set_RGEOS_CheckValidity(2L) 

# The workaround for this was to install and load "geos".

# The second error message was reached when cropping the map area. The error was similar to https://github.com/r-spatial/sf/issues/1762. See code for L.S. modification.

## Install packages
install.packages("rgeos")
install.packages("sf")
install.packages("rnaturalearth")
install.packages("rnaturalearthdata")
install.packages("dplyr")
install.packages("ggplot2")
install.packages("ggrepel")
install.packages("geos")

## Load packages
library(rgeos)
library(sf)
library(rnaturalearth)
library(rnaturalearthdata)
library(dplyr)
library(ggplot2)
library(ggrepel)
library(geos)

## Set ggplot2 theme

theme_set(theme_bw() +theme(panel.background = element_rect(fill = "azure"), panel.grid.major = element_blank(), axis.title = element_blank(), axis.text = element_text(size = 8)))

## Natural Earth data

world <- rnaturalearth::ne_countries(scale = 'medium', returnclass = "sp")
box_cut <- bbox2SP(n = 90, s = -90, w = -70, e = 120, proj4string = world@proj4string)
world_crop <- gDifference(world, box_cut)

#The main steps consist in cutting out the red area and binding the two green ones with shifting the geographical coordinates for a Pacific view as illustrated below:

box_left <- bbox2SP(n = 90, s = -90, w = -180, e = -70, proj4string = world@proj4string)
box_right <- bbox2SP(n = 90, s = -90, w = 120, e = 180, proj4string = world@proj4string)
plot(world)
plot(box_cut, col = rgb(red = 1, green = 0, blue = 0, alpha = 0.5), add = TRUE)
plot(box_left, col = rgb(red = 0, green = 1, blue = 0, alpha = 0.5), add = TRUE)
plot(box_right, col = rgb(red = 0, green = 1, blue = 0, alpha = 0.5), add = TRUE)
plot(world_crop)
plot(box_left, col = rgb(red = 0, green = 1, blue = 0, alpha = 0.5), add = TRUE)
plot(box_right, col = rgb(red = 0, green = 1, blue = 0, alpha = 0.5), add = TRUE)
pacific <- world_crop %>% 
  st_as_sf() %>% 
  st_shift_longitude()
plot(pacific)

#Crop the results from above to a focus area on the Pacific depicted in green below:

plot(pacific)
bbox2SP(n = 30, s = -50,
        w = st_bbox(pacific)[["xmin"]],
        e = st_bbox(pacific)[["xmax"]],
        proj4string = world@proj4string) %>% 
  plot(col = rgb(red = 0, green = 1, blue = 0, alpha = 0.5), add = TRUE)

##L.S. modification. 
sf_use_s2(FALSE)

pacific_crop <- world_crop %>% 
  st_as_sf() %>% 
  st_shift_longitude() %>% 
  st_crop(c(xmin = st_bbox(.)[["xmin"]],
            xmax = st_bbox(.)[["xmax"]],
            ymin = -50,
            ymax = 60))
ggplot() +
  geom_sf(data = pacific_crop)

