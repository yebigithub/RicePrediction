# knitr::opts_chunk$set(echo = TRUE)
# knitr::opts_knit$set(root.dir = "~/OneDrive - Virginia Tech/Research/Codes/research/RiceUNLMetabolites/Prediction/Prediction/Multi_trait")
# setwd("~/Library/CloudStorage/OneDrive-VirginiaTech/Research/Codes/research/RiceUNLMetabolites/Prediction/Multi_trait")
path.out = "./outputs"
path.geno = "../../Geno"

library(tidyverse)
library(BGLR)

load(file=file.path(path.geno, "geno.rr.con.RData")) # 192 385118
# load(file=file.path(path.geno, "geno.rr.trt.RData")) # 188 389854

Gcs_con = scale(geno_con, scale=T, center = T)
Gchnt_con = tcrossprod(Gcs_con)/ncol(Gcs_con)
EVD_Gchnt_con <- eigen(Gchnt_con)


multi_func<-function(group, nCV, mets){
        nCV=nCV
        # CorL <- list()

        for (p in 13:nCV){
        met_trait = read.csv(paste0("./CrossValidation/cv_",p,"/met_trait_scale_",p,".csv"))
        # met_trait <- read.csv(file="./CrossValidation/cv_1/met_trait_scale_1.csv")
        group.df <- met_trait %>% filter(Treatment==group)
        # group.df <- cbind(group.df, pcaL[[group]])

        # traits = c("MajorAxis", "MinorAxis", "Perimeter")
        
        
        traits = "MajorAxis" ##################change here
        
        
        mets = mets
        # CorR <- NULL
        CorR <- matrix(nrow = length(traits), ncol = length(mets), dimnames = list(traits,mets))
        for (i in traits){
          for (j in mets){
            set.seed(100+p)
            cat("Now running Treatment_Trait_Met_CV: ", group, i, j, p, "\n")
            Y0 = cbind(scale(group.df[,i]), group.df[,j]) #just scale traits, no scale mets.
            Y <- Y0
            index = which(group.df$set == "test")
            Y[index, ] = NA
            # table(is.na(y[,1]))
            # table(is.na(y[,2]))


            if(group == "Control"){
                ETA <- list(
                G = list(K=Gchnt_con, model='RKHS')
            )} else{
                ETA <- list(
                G = list(K=Gchnt_trt, model='RKHS')
            )
            }

            fm <- Multitrait(y=Y,ETA=ETA,verbose=F, nIter = 30000, burnIn = 10000, thin = 5 )
            pred = fm$ETAHat[index,]
            real = Y0[index, ]
            CorR[i,j] = cor(pred, real)[1,1]

          }
        }
        # CorL[[p]] = CorR
        path0 = paste0("./outputs/sc1_part2/", group, "_", i, "_cv",p)
        dir.create(file.path(path0), recursive = T)
        saveRDS(CorR, file=paste0(path0, "/scenario1_all", ".rds"))

      }

}

mets0= c(paste0("a",1:10),paste0("b",1:10),paste0("c",1:10),paste0("d",1:10),paste0("e",1:10),paste0("f",1:10),paste0("g",1:10),paste0("h",1:3))
mets = mets0
multi_func(group="Control", nCV=25, mets = mets)


