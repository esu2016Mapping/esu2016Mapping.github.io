# R

library(ggplot2)
library(maps)
library(mapdata)
library(rgeos)
library(maptools)
library(mapproj)
library(PBSmapping)
library(data.table)

xlim=c(-20,75); ylim=c(10,50)
land="grey"; water="grey80"; bgColor="grey80"

worldmap=map_data("world")
setnames(worldmap,c("X","Y","PID","POS","region","subregion"))
worldmap=clipPolys(worldmap,xlim=xlim,ylim=ylim,keepExtra=TRUE)

# load al-Muqaddasi data with interface
muqaddasi <- read.delim("C:/Users/Pascal/Desktop/Franzi_Mapping/GitHub/esu2016mapping.github.io/projects/minerals/muqaddasi.csv")
# load minerals data with interface
minerals <- read.delim("C:/Users/Pascal/Desktop/Franzi_Mapping/GitHub/esu2016mapping.github.io/projects/minerals/reformatted.csv")

# Explore data

plot(minerals[,7])
plot(minerals[,8])
plot(muqaddasi[,1])
plot(muqaddasi[,7])

# Mineral layer
mineralsTemp = minerals[ with(minerals, grepl("",Type)),]
mineralsLayer=geom_point(data=mineralsTemp,color="grey",alpha=1,size=2,aes(y=latitude,x=longitude))

# Muqaddasi layers
leg1 = "stone"
col1="red"
muqaddasi1=muqaddasi[ with(muqaddasi, grepl("[Ss]tone",NOTABLE.PRODUCTS)),]
muqaddasi1=geom_point(data=muqaddasi1,color=col1,alpha=.75,size=5,aes(y=LAT,x=LON))


leg2 = "wood"
col2="coral4"
muqaddasi2=muqaddasi[ with(muqaddasi, grepl("[Ww]ood",NOTABLE.PRODUCTS)),]
muqaddasi2=geom_point(data=muqaddasi2,color=col2,alpha=.75,size=5,aes(y=LAT+5,x=LON+5))


leg3 = "brick iron"
col3="gold"
header="Muqaddasi Data"
muqaddasi3=muqaddasi[ with(muqaddasi, grepl("[Bb]rick|[Ii]ron",NOTABLE.PRODUCTS)),]
muqaddasi3=geom_point(data=muqaddasi3,color=col3,alpha=.75,size=1,aes(y=LAT+5,x=LON+5))



# creating plot
test = ggplot()+
  coord_map(xlim=xlim,ylim=ylim)+
  geom_polygon(data=worldmap,aes(X,Y,group=PID),size=0.1,colour=land,fill=water,alpha=1)+
  # Header
  annotate("text",x=72,y=12,hjust=1,label=header,size=9,color="grey40")+ 
  # Legend
  annotate("text",x=-10,y=48,hjust=1,label=leg1,size=5,color=col1)+ 
  annotate("text",x=-10,y=47,hjust=1,label=leg2,size=5,color=col2)+ 
  # Layers
  mineralsLayer+
  muqaddasi1+
  muqaddasi2+
  muqaddasi3+
  labs(y="",x="")+
  theme_grey()
test


fileName = "/Users/romanov/Documents/GitProjects/esu2016mapping.github.io/projects/minerals/Muqaddasi_data.png"
ggsave(file=fileName,plot=test,dpi=600,width=7,height=6)
