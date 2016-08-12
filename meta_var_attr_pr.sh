#!/bin/bash
#
#==========================================================================================================================================
# correct variable attributes for precipitation indices
#==========================================================================================================================================
#
#C.Photiadou 2016/07/25
# Directories
dir_in='/nobackup/users/photiado/icclim_indices_v4.2.3_seapoint_metadata_fixed/EUR-44/BC/pr/'
path_ic_inst='icclim-4-2-3_KNMI'
path_real_bc='r1i1p1_SMHI-RCA4_v1_EUR-44_SMHI-DBS43_EOBS10_bcref-1981-2010_yr'
#=====================
# Variables
#=====================
IFS=$'\n'
gcms=('CCCma-CanESM2' 'CNRM-CM5' 'CSIRO-Mk3-6-0' 'EC-EARTH' 'IPSL-CM5A-MR' 'MIROC5' 'HadGEM2-ES' 'MPI-ESM-LR' 'NorESM1-M' 'GFDL-ESM2M')
ind=('RX1day' 'R95p' 'R20mm' 'RR1' 'R10mm' 'PRCPTOT' 'CDD' 'CWD')
indices=('rx1day' 'r95p' 'r20mm' 'r1mm' 'r10mm' 'prcptot' 'cdd' 'cwd')
invar_vari='prAdjust'
exper=('rcp45' 'rcp85' 'historical' )
bc_method='DBS43' # none
var_gl='pr'
time_cov_start=('20060101' '20060101' '19700101')
time_cov_end=('20991231' '20991231' '20051231')
titles=("rx1day: maximum one-day precipitation" "r95p: very wet days" \
		"r20mm: very heavy precipitation days" \
		"r1mm: wet days" \
		"r10mm: heavy precipitation days" \
		"prcptot: total precipitation in wet days" \
		"consecutive dry days" \
		"consecutive wet days")
summaries=("rx1day is a climate change index definied by the ETCCDI. The indicator measures the maximum one-day precipitation amount during a year for a given location" \
		   "r95p is a climate change index by ECA&D. The indicator counts the days where precipitation (wet days) exceeds the 95th percentile of precipitation at wet days during a year for a given location" \
		   "r20mm is a climate change index definied by the ETCCDI. The indicator counts the days where precipitation is above 20 mm during a year for a given location" \
		   "r1mm is a climate change index definied by the ETCCDI. The indicator counts the wet days (precipitation is >= 1mm) during a year for a given location" \
		   "r10mm is a climate change index definied by the ETCCDI. The indicator counts the days where precipitation is > 10 mm during a year for a given location" \
		   "prcptot is a climate change index definied by the ETCCDI. The indicator measures the total precipitation amount in wet days (>=1mm) during a year for a given location" \
		   "cdd is a climate change index definied by the ETCCDI. The indicator counts the maximum length of dry spell (precipitation < 1mm) during a year for a given location" \
		   "cwd is a climate change index definied by the ETCCDI. The indicator counts the maximum length of wet spell (precipitation >= 1mm) during a year for a given location")

#========================================================================
### Fix issue for EC_EARTH and HadGem but remember to bringit back at the end!
#========================================================================
gcm_ec='EC-EARTH'
gcm_ha='HadGEM2-ES'
had_time_end=('20991130' '20991230' '20051230')

 for k in {0..7}; do #indices	echo
	echo
		echo "Rename EC-EARTH & HadGEM"
	echo
		echo ${indices[k]}
		
	for i in {0..2}; do #exper
		echo ${exper[i]}
	echo
		mv ${dir_in}${indices[k]}_${path_ic_inst}_${gcm_ec}_${exper[i]}_r12i1p1_SMHI-RCA4_v1_EUR-44_SMHI-DBS43_EOBS10_bcref-1981-2010_yr_${time_cov_start[i]}-${time_cov_end[i]}.nc ${dir_in}${indices[k]}_${path_ic_inst}_${gcm_ec}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${time_cov_end[i]}.nc
		
		mv ${dir_in}${indices[k]}_${path_ic_inst}_${gcm_ha}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${had_time_end[i]}.nc ${dir_in}${indices[k]}_${path_ic_inst}_${gcm_ha}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${time_cov_end[i]}.nc
	done
done
#========================================================================
### Add metadata that are different for every GCM, variable, experiment 
#========================================================================
for k in {0..7}; do #indices
	echo
		echo "Append the metadata"
	echo
		echo ${indices[k]}
	for j in {0..9}; do  #gcms
		echo ${gcms[j]}
		for i in {0..2}; do #exper
			echo ${exper[i]}

			ncrename -h -O -v ${ind[k]},${indices[k]} ${dir_in}${indices[k]}_${path_ic_inst}_${gcms[j]}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${time_cov_end[i]}.nc	
			ncatted -O -a standard_name,${indices[k]},o,c,'ETCCDI_indice' -h ${dir_in}${indices[k]}_${path_ic_inst}_${gcms[j]}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${time_cov_end[i]}.nc	

			ncatted -O -a comment,global,o,c,'ETCCDI stands for the joint CCl/CLIVAR/JCOMM Expert Team (ET) on Climate Change Detection and Indices' -h ${dir_in}${indices[k]}_${path_ic_inst}_${gcms[j]}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${time_cov_end[i]}.nc	
			
			ncatted -O -a references,global,o,c,'Klein Tank, A.M.G., Zwiers F.W., and Zhang X: Guidelines on analysis of extremes in a changing climate in support of informed decisions for adaptation, Climate Data and Monitoring, WCDMP-No.72' -h \
				${dir_in}${indices[k]}_${path_ic_inst}_${gcms[j]}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${time_cov_end[i]}.nc	
				
			ncatted -O -a variable_name,global,o,c,${indices[k]} -h ${dir_in}${indices[k]}_${path_ic_inst}_${gcms[j]}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${time_cov_end[i]}.nc

			ncatted -O -a title,global,o,c,${titles[k]} -h ${dir_in}${indices[k]}_${path_ic_inst}_${gcms[j]}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${time_cov_end[i]}.nc
		
			ncatted -O -a summary,global,o,c,${summaries[k]} -h	${dir_in}${indices[k]}_${path_ic_inst}_${gcms[j]}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${time_cov_end[i]}.nc

			ncatted -O -a invar_rcm_model_driver,global,o,c,${gcms[j]} -h ${dir_in}${indices[k]}_${path_ic_inst}_${gcms[j]}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${time_cov_end[i]}.nc

			ncatted -O -a invar_gcm_model_id,global,o,c,' ' -h ${dir_in}${indices[k]}_${path_ic_inst}_${gcms[j]}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${time_cov_end[i]}.nc
		
			ncatted -O -a variable_name,global,o,c,${indices[k]} -h ${dir_in}${indices[k]}_${path_ic_inst}_${gcms[j]}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${time_cov_end[i]}.nc
	
			ncatted -O -a invar_experiment_name,global,o,c,${exper[i]} -h ${dir_in}${indices[k]}_${path_ic_inst}_${gcms[j]}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${time_cov_end[i]}.nc

			ncatted -O -a time_coverage_start,global,o,c,${time_cov_start[i]} -h ${dir_in}${indices[k]}_${path_ic_inst}_${gcms[j]}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${time_cov_end[i]}.nc

			ncatted -O -a time_coverage_end,global,o,c,${time_cov_end[i]} -h ${dir_in}${indices[k]}_${path_ic_inst}_${gcms[j]}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${time_cov_end[i]}.nc

			ncatted -O -a keywords,global,o,c,"ETCCDI, ECA&D, climate, index, ${indices[k]},year, reference, climate model output, EUR-44" -h ${dir_in}${indices[k]}_${path_ic_inst}_${gcms[j]}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${time_cov_end[i]}.nc

			ncatted -O -a tracking_id,global,o,c,$(uuidgen) -h ${dir_in}${indices[k]}_${path_ic_inst}_${gcms[j]}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${time_cov_end[i]}.nc

			ncatted -O -a invar_variable_name,global,o,c,${invar_vari} -h ${dir_in}${indices[k]}_${path_ic_inst}_${gcms[j]}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${time_cov_end[i]}.nc

			ncatted -O -a Conventions,global,o,c,'CF-1.6' -h ${dir_in}${indices[k]}_${path_ic_inst}_${gcms[j]}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${time_cov_end[i]}.nc
		
			ncatted -O -a activity,global,o,c,clipc -h 	${dir_in}${indices[k]}_${path_ic_inst}_${gcms[j]}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${time_cov_end[i]}.nc
			
			ncatted -O -a product,global,o,c,"climate model output" -h ${dir_in}${indices[k]}_${path_ic_inst}_${gcms[j]}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${time_cov_end[i]}.nc
		
			ncatted -O -a package_name,global,o,c,"icclim-4-2-3" -h ${dir_in}${indices[k]}_${path_ic_inst}_${gcms[j]}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${time_cov_end[i]}.nc
	    
			ncatted -O -a package_references,global,o,c,https://github.com/cerfacs-globc/icclim -h ${dir_in}${indices[k]}_${path_ic_inst}_${gcms[j]}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${time_cov_end[i]}.nc

			ncatted -O -a institution_id,global,o,c,KNMI  -h ${dir_in}${indices[k]}_${path_ic_inst}_${gcms[j]}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${time_cov_end[i]}.nc
        
			ncatted -O -a institution_url,global,o,c,knmi.nl -h ${dir_in}${indices[k]}_${path_ic_inst}_${gcms[j]}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${time_cov_end[i]}.nc
	    
			ncatted -O -a contact,global,o,c,eca@knmi.nl -h ${dir_in}${indices[k]}_${path_ic_inst}_${gcms[j]}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${time_cov_end[i]}.nc
		
			ncatted -O -a contributor_name,global,o,c,KNMI -h ${dir_in}${indices[k]}_${path_ic_inst}_${gcms[j]}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${time_cov_end[i]}.nc
		
			ncatted -O -a contributor_role,global,o,c,"This index was calculated by the ECA&D team. More ETCCDI and ECA&D indices are available on www.ecad.eu" -h ${dir_in}${indices[k]}_${path_ic_inst}_${gcms[j]}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${time_cov_end[i]}.nc
					
			ncatted -O -a date_created,global,o,c,'20160725' -h ${dir_in}${indices[k]}_${path_ic_inst}_${gcms[j]}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${time_cov_end[i]}.nc
				
			ncatted -O -a date_issued,global,o,c,'20160801' -h ${dir_in}${indices[k]}_${path_ic_inst}_${gcms[j]}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${time_cov_end[i]}.nc
					
			ncatted -O -a date_modified,global,o,c,' ' -h ${dir_in}${indices[k]}_${path_ic_inst}_${gcms[j]}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${time_cov_end[i]}.nc
				
			ncatted -O -a realisation_id,global,o,c,' ' -h ${dir_in}${indices[k]}_${path_ic_inst}_${gcms[j]}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${time_cov_end[i]}.nc

			ncatted -O -a source_data_id,global,o,c,' ' -h ${dir_in}${indices[k]}_${path_ic_inst}_${gcms[j]}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${time_cov_end[i]}.nc

			ncatted -O -a source_data_id_comment,global,o,c,' ' -h ${dir_in}${indices[k]}_${path_ic_inst}_${gcms[j]}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${time_cov_end[i]}.nc

			ncatted -O -a invar_platform,global,o,c,' ' -h ${dir_in}${indices[k]}_${path_ic_inst}_${gcms[j]}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${time_cov_end[i]}.nc

			ncatted -O -a invar_platform_id,global,o,c,' ' -h ${dir_in}${indices[k]}_${path_ic_inst}_${gcms[j]}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${time_cov_end[i]}.nc

			ncatted -O -a invar_satellite_algorithm,global,o,c,' ' -h ${dir_in}${indices[k]}_${path_ic_inst}_${gcms[j]}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${time_cov_end[i]}.nc

			ncatted -O -a invar_satellite_sensor,global,o,c,' ' -h ${dir_in}${indices[k]}_${path_ic_inst}_${gcms[j]}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${time_cov_end[i]}.nc

			ncatted -O -a invar_rcm_model_id,global,o,c,"SMHI-RCA4_v1" -h ${dir_in}${indices[k]}_${path_ic_inst}_${gcms[j]}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${time_cov_end[i]}.nc

			ncatted -O -a invar_rcm_model_realization_id,global,o,c,' ' -h ${dir_in}${indices[k]}_${path_ic_inst}_${gcms[j]}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${time_cov_end[i]}.nc

            ncatted -O -a invar_reanalysis_id,global,o,c,' ' -h ${dir_in}${indices[k]}_${path_ic_inst}_${gcms[j]}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${time_cov_end[i]}.nc
            
            ncatted -O -a invar_bc_method_id,global,o,c,"SMHI-DBS43" -h ${dir_in}${indices[k]}_${path_ic_inst}_${gcms[j]}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${time_cov_end[i]}.nc

            ncatted -O -a invar_bc_observation_id,global,o,c,EOBS10 -h ${dir_in}${indices[k]}_${path_ic_inst}_${gcms[j]}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${time_cov_end[i]}.nc
              
            ncatted -O -a invar_bc_period,global,o,c,"1981-2010" -h ${dir_in}${indices[k]}_${path_ic_inst}_${gcms[j]}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${time_cov_end[i]}.nc

            ncatted -O -a reference_period,global,o,c,' ' -h ${dir_in}${indices[k]}_${path_ic_inst}_${gcms[j]}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${time_cov_end[i]}.nc

			ncatted -O -a output_frequency,global,o,c,yr -h ${dir_in}${indices[k]}_${path_ic_inst}_${gcms[j]}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${time_cov_end[i]}.nc
            
            ncatted -O -a cdm_datatype,global,o,c,Grid -h ${dir_in}${indices[k]}_${path_ic_inst}_${gcms[j]}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${time_cov_end[i]}.nc

            ncatted -O -a domain,global,o,c,"EUR-44" -h ${dir_in}${indices[k]}_${path_ic_inst}_${gcms[j]}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${time_cov_end[i]}.nc

            ncatted -O -a geospatial_bounds,global,o,c,"CORDEX domain: EUR-44" -h ${dir_in}${indices[k]}_${path_ic_inst}_${gcms[j]}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${time_cov_end[i]}.nc

            ncatted -O -a geospatial_lat_min,global,o,c,' ' -h ${dir_in}${indices[k]}_${path_ic_inst}_${gcms[j]}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${time_cov_end[i]}.nc

            ncatted -O -a geospatial_lat_max,global,o,c,' ' -h ${dir_in}${indices[k]}_${path_ic_inst}_${gcms[j]}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${time_cov_end[i]}.nc

            ncatted -O -a geospatial_lat_resolution,global,o,c,"0.44 degrees" -h ${dir_in}${indices[k]}_${path_ic_inst}_${gcms[j]}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${time_cov_end[i]}.nc

            ncatted -O -a geospatial_lon_min,global,o,c,' ' -h ${dir_in}${indices[k]}_${path_ic_inst}_${gcms[j]}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${time_cov_end[i]}.nc

            ncatted -O -a geospatial_lon_max,global,o,c,' ' -h ${dir_in}${indices[k]}_${path_ic_inst}_${gcms[j]}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${time_cov_end[i]}.nc

            ncatted -O -a geospatial_lon_resolution,global,o,c,"0.44 degrees" -h ${dir_in}${indices[k]}_${path_ic_inst}_${gcms[j]}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${time_cov_end[i]}.nc

            ncatted -O -a tile,global,o,c,' ' -h ${dir_in}${indices[k]}_${path_ic_inst}_${gcms[j]}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${time_cov_end[i]}.nc

            ncatted -O -a history,global,o,c,' ' -h ${dir_in}${indices[k]}_${path_ic_inst}_${gcms[j]}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${time_cov_end[i]}.nc
                       
            ncatted -O -a source,global,d,, -h ${dir_in}${indices[k]}_${path_ic_inst}_${gcms[j]}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${time_cov_end[i]}.nc
                                       
            ncatted -O -a invar_ensemble_member,global,o,c,r1i1p1 -h ${dir_in}${indices[k]}_${path_ic_inst}_${gcms[j]}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${time_cov_end[i]}.nc

            ncatted -O -a invar_tracking_id,global,o,c,' ' -h ${dir_in}${indices[k]}_${path_ic_inst}_${gcms[j]}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${time_cov_end[i]}.nc

			## this is for R95p & prcptot
		  		 if [ "${indices[k]}" = "r95p" ]; then

				ncatted -O -a comment,global,o,c,'ECA&D stands for European Climate Assessment & Dataset' -h ${dir_in}${indices[k]}_${path_ic_inst}_${gcms[j]}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${time_cov_end[i]}.nc	
				
				ncatted -O -a references,global,o,c,http://www.ecad.eu/documents/atbd.pdf -h ${dir_in}${indices[k]}_${path_ic_inst}_${gcms[j]}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${time_cov_end[i]}.nc	

				ncatted -O -a standard_name,${indices[k]},o,c,'ECA&D_indice' -h ${dir_in}${indices[k]}_${path_ic_inst}_${gcms[j]}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${time_cov_end[i]}.nc	

			elif [ "${indices[k]}" = "prcptot" ]; then
				ncatted -O -a long_name,prcptot,o,c,'Precipitation sum in wet days (>1mm)' -h \
				${dir_in}${indices[k]}_${path_ic_inst}_${gcms[j]}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${time_cov_end[i]}.nc	
				
			elif [ "${gcms[j]}" = "EC-EARTH" ]; then
			    ncatted -O -a invar_ensemble_member,global,o,c,r12i1p1 -h ${dir_in}${indices[k]}_${path_ic_inst}_${gcms[j]}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${time_cov_end[i]}.nc

			elif [ "${gcms[j]}" = "HadGEM2-ES" ]; then
				ncatted -O -a time_coverage_end,global,o,c,${had_time_end[i]} -h ${dir_in}${indices[k]}_${path_ic_inst}_${gcms[j]}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${time_cov_end[i]}.nc

			fi
			 
			ncatted -O -a history_of_appended_files,global,d,, -h ${dir_in}${indices[k]}_${path_ic_inst}_${gcms[j]}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${time_cov_end[i]}.nc
			
			ncatted -O -a NCO,global,d,, -h ${dir_in}${indices[k]}_${path_ic_inst}_${gcms[j]}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${time_cov_end[i]}.nc

			ncatted -O -a CDO,global,d,, -h ${dir_in}${indices[k]}_${path_ic_inst}_${gcms[j]}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${time_cov_end[i]}.nc
			
			ncatted -O -a CDI,global,d,, -h ${dir_in}${indices[k]}_${path_ic_inst}_${gcms[j]}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${time_cov_end[i]}.nc

  done
 done
done 

#========================================================================
### Correct filename for EC-EARTH & HadGem!
#========================================================================

for k in {0..7}; do #indices
	echo
		echo "Rename back EC-EARTH & HadGEM"
	echo
		echo ${indices[k]}
	echo
	for i in {0..2}; do #exper
 		echo ${exper[i]}

		mv ${dir_in}${indices[k]}_${path_ic_inst}_${gcm_ec}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${time_cov_end[i]}.nc ${dir_in}${indices[k]}_${path_ic_inst}_${gcm_ec}_${exper[i]}_r12i1p1_SMHI-RCA4_v1_EUR-44_SMHI-DBS43_EOBS10_bcref-1981-2010_yr_${time_cov_start[i]}-${time_cov_end[i]}.nc

		mv ${dir_in}${indices[k]}_${path_ic_inst}_${gcm_ha}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${time_cov_end[i]}.nc ${dir_in}${indices[k]}_${path_ic_inst}_${gcm_ha}_${exper[i]}_${path_real_bc}_${time_cov_start[i]}-${had_time_end[i]}.nc
	done
done 
