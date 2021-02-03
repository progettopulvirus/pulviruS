rm(list=objects())
library("tidyverse")
library("leaflet")

read_delim("ana.csv",delim=";",col_names = TRUE)->ana

#file con l'elenco delle stazioni valide per regione
list.files(pattern="^stazioniValide_[np].+csv$")->ffile

stopifnot(length(ffile)!=0)

leggi<-function(.x){
  read_delim(.x,col_names = FALSE,delim=";")->dati
  names(dati)<-c("station_eu_code","regione")
  
  #quale inquinante
  str_remove(str_remove(.x,"^.+_"),"\\.csv")->siglaInquinante
  dati$inquinante<-siglaInquinante
  
  dati
  
}

purrr::map_dfr(ffile,.f=leggi)->stazioni


full_join(stazioni,ana)->stazioni

stazioni %>%
  mutate(testoPop=glue::glue("<h4>{nome_stazione} ({provincia})</h4><p>Regione: {Hmisc::capitalize(regione)}</p><p>Altitudine: {altitudine} m</p> <p>Station EU code: {station_eu_code}</p>"))->stazioni

purrr::partial(.f=addMarkers,lng=~st_x,lat=~st_y,label=~nome_stazione,popup=~testoPop)->mappaMarkers


leaflet() %>%
  leaflet::addTiles() %>%
  mappaMarkers(map=.,data = stazioni %>% filter(inquinante=="pm10"),group="PM10") %>%
  mappaMarkers(map=.,data = stazioni %>% filter(inquinante=="pm25"),group="PM2.5") %>%
  mappaMarkers(map=.,data = stazioni %>% filter(inquinante=="no2"),group="NO2") %>%
  mappaMarkers(map=.,data = stazioni %>% filter(inquinante=="nox"),group="NOx")  %>%
  leaflet::addLayersControl(overlayGroups = c("PM10","PM2.5","NO2","NOx")) %>%
  hideGroup(c("PM2.5","NO2","NOx")) 
  
