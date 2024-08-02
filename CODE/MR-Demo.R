setwd("working directory")
library(ggplot2)
library(TwoSampleMR)

rm(list = ls())
Exp <- extract_instruments(outcomes = c("ID"),
                           clump = TRUE,
                           p1 = 5e-6,
                           r2 = 0.01,
                           kb = 5000,
                           access_token = NULL) 

write.csv(RA_exp,'Data to be saved.csv', row.names = F)
RA_exp <- read.csv("Data to be saved.csv", header = TRUE)

Out <- extract_outcome_data(snps = Exp$SNP, 
                            outcomes = c("ID"),
                            proxies = FALSE, 
                            maf_threshold = 0.01, 
                            access_token = NULL)
                               
mydata <- harmonise_data(exposure_dat=RA_exp,
                         outcome_dat=PSO_out,
                         action= 2) 
write.csv(mydata, 'Save-analysis-data.csv', row.names = F)
############################################################
res <- mr(mydata)
or <- generate_odds_ratios(res)
write.csv(or, 'Save-MR-analysis-result.csv', row.names = F)

het <- mr_heterogeneity(mydata)
write.csv(het, 'het-analysis-result.csv', row.names = F)
mr(mydata, method_list = c('mr_ivw_mre'))

pleio <- mr_pleiotropy_test(mydata)
write.csv(pleio, 'pleio-analysis-result.csv', row.names = F)

###################### save images ######################
pleiosingle <- mr_leaveoneout(mydata)
p0 <- mr_leaveoneout_plot(pleiosingle)
ggsave(p0[[1]], file = "Save-....Polt.pdf", width = 8, height = 8, dpi = 300)

p1 <- mr_scatter_plot(res,mydata)
ggsave(p1[[1]], file = "Save-....Polt.pdf", width = 8, height= 8, dpi = 300) 


res_single <- mr_singlesnp(mydata)
p2 <- mr_forest_plot(res_single)
ggsave(p2[[1]], file = "Save-....Polt.pdf", width = 8, height = 8, dpi = 300)

p3 <-mr_funnel_plot(res_single)
ggsave(p3[[1]], file= "Save-....Polt.pdf", width = 8, height = 8, dpi = 300) 

#############################################################

library(mr.raps)
mr.raps.all(mydata$beta.exposure, 
            mydata$beta.outcome, 
            mydata$se.exposure, 
            mydata$se.outcome)

# res <- mr.raps(mydata$beta.exposure, 
#                mydata$beta.outcome, 
#                mydata$se.exposure, 
#                mydata$se.outcome, 
#                diagnosis = TRUE)

res <- mr.raps(mydata$beta.exposure,
               mydata$beta.outcome,
               mydata$se.exposure,
               mydata$se.outcome,
               TRUE, "tukey", 
               diagnosis = TRUE)

library(MRPRESSO) 
mr_presso( BetaOutcome = "beta.outcome",
           BetaExposure = "beta.exposure",
           SdOutcome = "se.outcome",
           SdExposure = "se.exposure",
           OUTLIERtest = TRUE,
           DISTORTIONtest = TRUE,
           data = mydata,
           NbDistribution = 50,
           SignifThreshold = 0.05) 

library(RadialMR) 
ivw_radial(r_input = mydata, 
           alpha = 0.05, 
           weights = 1,
           tol = 0.0001, 
           summary = TRUE)