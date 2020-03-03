library(XML)
path <- "data/export.gpx"

datos = data.frame()
content = readLines(path)
doc = xmlParse(content)
lista = xmlToList(doc)
for (node in 2:(length(lista)-1)) {
  datos = rbind(datos,
                data.frame(name = lista[[node]]$desc,
                           lon = as.numeric(lista[[node]]$.attrs["lon"]),
                           lat = as.numeric(lista[[node]]$.attrs["lat"])
                )
  )
}

library(dplyr)
bancos <- as_tibble(datos)

save(bancos, file = "data/bancos.RData")

library(leaflet)
library(leaflet.extras)

leaflet() %>%
  addTiles() %>%
  addMarkers(lng = bancos$lon, lat = bancos$lat, popup = bancos$name)


leaflet() %>%
  addTiles(urlTemplate='https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
           attribution = 'Tiles &copy; Esri &mdash; Source: Esri, i-cubed, USDA, USGS, AEX, GeoEye, Getmapping, Aerogrid, IGN, IGP, UPR-EGP, and the GIS User Community',
           options = tileOptions(maxZoom = 19))%>%
  addMarkers(lng = bancos$lon, lat = bancos$lat, popup = bancos$name)
