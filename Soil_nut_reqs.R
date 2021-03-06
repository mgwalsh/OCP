#' Soil nutrient requirement site summaries
#' M. Walsh, December 2016

# Required packages
# install.packages(c("devtools","leaderCluster","arm")), dependencies=TRUE)
suppressPackageStartupMessages({
  require(devtools)
  require(leaderCluster)
  require(arm)
})

# Data setup --------------------------------------------------------------
# SourceURL <- "https://raw.githubusercontent.com/mgwalsh/OCP/blob/master/Spatial_pred_setup.R"
# source_url(SourceURL)

LGA <- read.table("LGA_ID.csv", header=T, sep=",")
req <- merge(req, LGA, by="LGA_ID")
loc <- as.matrix(req[,3:4])
sid <- leaderCluster(loc, radius=12000, distance="L2")$cluster_id
req <- cbind(req, sid)

# Oxide equivalents
oP <- 2.2913 ## P to P2O5
oK <- 1.2046 ## K to K2O

# Set nutrient sufficiency levels (in ppm)
rN <- 2000 
rP <- 20
rK <- 120
rS <- 20
rB <- 0.8
rZn <- 2

# Nutrient mass estimates (kg/ha) in delta notation relative to specified reference levels
req$dN <- 2*req$BD20*req$N*10000-2*req$BD20*rN ## convert from % to ppm
req$dP <- 2*req$BD20*req$P*oP-2*req$BD20*rP*oP ## in P2O5 oxide equivalents
req$dK <- 2*req$BD20*req$K*oK-2*req$BD20*rK*oK ## in K2O oxide equivalents
req$dS <- 2*req$BD20*req$S-2*req$BD20*rS
req$dB <- 2*req$BD20*req$B-2*req$BD20*rB
req$dZn <- 2*req$BD20*req$Zn-2*req$BD20*rZn

# LMER summaries ----------------------------------------------------------
# delta N (kg/ha) relative to specified N reference level
dN <- lmer(dN~1+(1|sid), data=req)
display(dN)

# delta P (kg/ha) relative to specified (P2O5) reference level
dP <- lmer(dP~1+(1|sid), data=req)
display(dP)

# delta K (kg/ha) relative to specified (K2O) reference level
dK <- lmer(dK~1+(1|sid), data=req)
display(dK)

# delta S (kg/ha) relative to specified reference level
dS <- lmer(dS~1+(1|sid), data=req)
display(dS)

# delta B (kg/ha) relative to specified reference level
dB <- lmer(dB~1+(1|sid), data=req)
display(dB)

# delta Zn (kg/ha) relative to specified reference level
dZn <- lmer(dZn~1+(1|sid), data=req)
display(dZn)
