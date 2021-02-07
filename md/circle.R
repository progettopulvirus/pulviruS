rm(list=objects())
library("data.tree")
library("tidyverse")
library("circlepackeR")


list.files(pattern="^stazioniValide_.+csv$")->ffile
stopifnot(length(ffile)!=0)


purrr::map_dfr(ffile,.f=function(nomeFile){
  
  inquinante<-str_remove(str_remove(nomeFile,"^.+_"),".csv$")
  read_delim(nomeFile,col_names = FALSE,delim=";")->dati
  names(dati)<-c("staz_eu_code","regione")
  dati$inquinante<-inquinante
  
  dati
  
})->finale

finale %>%
  group_by(inquinante,regione) %>%
  summarise(numeroStazioni=n()) %>%
  ungroup()->mydf

mydf %>%
  mutate(pathString=paste("italia",inquinante,regione,sep="/"))->mydf

as.Node(mydf)->prova

circlepackeR(prova,size="numeroStazioni")


finale %>%
  group_by(inquinante,regione,staz_eu_code) %>%
  summarise(numeroStazioni=n()) %>%
  ungroup()->mydf

mydf %>%
  mutate(pathString=paste("italia",inquinante,regione,staz_eu_code,sep="/"))->mydf

as.Node(mydf)->prova

circlepackeR(prova,size="numeroStazioni")


finale %>%
  group_by(inquinante,regione,staz_eu_code) %>%
  summarise(numeroStazioni=n()) %>%
  ungroup()->mydf

mydf %>%
  mutate(pathString=paste("italia",regione,inquinante,staz_eu_code,sep="/"))->mydf

as.Node(mydf)->prova

circlepackeR(prova,size="numeroStazioni")


finale %>%
  group_by(regione,staz_eu_code) %>%
  summarise(numeroStazioni=n()) %>%
  ungroup()->mydf

mydf %>%
  mutate(pathString=paste("italia",regione,staz_eu_code,sep="/"))->mydf

as.Node(mydf)->prova

circlepackeR(prova,size="numeroStazioni")


