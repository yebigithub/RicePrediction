#!/bin/bash

### sc1_all_trt_minoraxis.sh   ### <---------- Change me
###########################################################################
## environment & variable setup
####### job customization
#SBATCH --job-name="sc1_all_trt_minoraxis"   ### <---------- Change me
#SBATCH -N 3
#SBATCH -n 16
#SBATCH -t 10:00:00
#SBATCH -p normal_q
#SBATCH --mem-per-cpu=32G
#SBATCH -A multiomicquantgen    #### <------- change me
####### end of job customization
# end of environment & variable setup
###########################################################################
#### add modules on TC/Infer
module load containers/singularity/3.8.5
### from DT/CA, use module load singularity
module list
#end of add modules
###########################################################################
###print script to keep a record of what is done
cat sc1_all_trt_minoraxis.sh  ### <---------- Change me
###########################################################################
echo start running R
## note, on DT/CA, you should replace projects with groups

singularity exec --bind=/work,/projects \
    /projects/arcsingularity/ood-rstudio141717-bio_4.1.0.sif Rscript sc1_all_trt_minoraxis.R   ### <---------- Change me

exit;
