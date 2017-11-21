### ACTIVIDAD COLABORATIVA ###


# Environment
rm(list=ls())
setwd('/Users/pabalca/Documents/Master-TelefonicaBI/Modulo3-DatascienceTradicional-R/programas/')
getwd()

# Create dir
if (!file.exists("./datos/dowjones_index")){
  dir.create("./datos/dowjones_index")
}

# Download dataset
if (length(list.files("./datos/dowjones_index")) == 0){
  fileURL <- "https://archive.ics.uci.edu/ml/machine-learning-databases/00312/dow_jones_index.zip"
  download.file(fileURL,destfile = "./datos/dowjones_index/dowjones_index.zip", method="curl")
  unzip("./datos/dowjones_index/dowjones_index.zip", exdir="./datos")
  list.files("./datos/dowjones_index")
  fechaDescarga <- date()
}

# Load dataset
dowjones <- read.table("./datos/dowjones_index/dow_jones_index.data",
                         row.names = NULL, sep = ",", header = TRUE)

# Exploracion general
summary(dowjones)
names(dowjones)

# Nos quedamos solo con las variables que nos interesan y el stock = XOM
dowjones.mod <- dowjones %>% filter(stock=="XOM") %>%
  select(stock,date,open,close,high,low,volume)

# Eliminamos los signos de dolar
dowjones.mod$open  = as.numeric(gsub("\\$", "", dowjones.mod$open))
dowjones.mod$close = as.numeric(gsub("\\$", "", dowjones.mod$close))
dowjones.mod$high  = as.numeric(gsub("\\$", "", dowjones.mod$high))
dowjones.mod$low   = as.numeric(gsub("\\$", "", dowjones.mod$low))

# Fechas en modo cron
dowjones.mod$date <- as.Date(dowjones.mod$date, "%m/%d/%Y")

# Ordenamos por volumen
dowjones.mod <- dowjones.mod[order(xtfrm(dowjones.mod[,7]),decreasing = TRUE), ] 

# Guardamos el dataset
if (!file.exists("./datos/dowjones_index/output")) {
  dir.create("./datos/dowjones_index/output")
  }

dowjones_save <- dowjones.mod[,-1] 
write.table(dowjones_save,file="./datos/dowjones_index/output/xom_data.data", sep=";")



