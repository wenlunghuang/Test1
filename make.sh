#!/bin/bash
# Selection for build different models
#wwwww
#wekwjekjlrwe define system build folder
#

#PHP KR Project Start
tpv_build_folder[1]=PHP_KR_91H_50PUN6102_MSD91H_REVA_PANEL1
tpv_panel_type[1]=UHD-60Hz
tpv_qmap_folder[1]=PHP_KR_91H_50PUN6102_PANEL1
tpv_proj_customer[1]=PHP

tpv_build_folder[2]=PHP_KR_91H_50PUN6102_MSD91H_REVA_PANEL2
tpv_panel_type[2]=UHD-60Hz
tpv_qmap_folder[2]=PHP_KR_91H_50PUN6102_PANEL2
tpv_proj_customer[2]=PHP

tpv_build_folder[3]=PHP_KR_91H_55PUN6102_MSD91H_REVA_PANEL1
tpv_panel_type[3]=UHD-60Hz
tpv_qmap_folder[3]=PHP_KR_91H_55PUN6102_PANEL1
tpv_proj_customer[3]=PHP
#PHP KR Project End

# Total array number
total_num=3

#
# show user input prompt
#
#clear
echo -e "***********************************************************************"
#echo -e "\t0. All(default)"
for((i = 1; i <= ${total_num}; i++))
do    
    if [ ${i} -le "9" ]; then
       echo -e  "\t$i.  ${tpv_build_folder[i]} (${tpv_panel_type[i]})" 
    else 
       echo -e  "\t$i. ${tpv_build_folder[i]} (${tpv_panel_type[i]})" 
     fi	
done
echo -e "\tNote: q or Q to Abort"
echo -e "***********************************************************************"
read -p  "Enter your choice =>" MODEL
MODEL=$1
if [ "$MODEL" == "" ]; then
    MODEL=0
elif [ "$MODEL" == "q" ] || [ "$MODEL" == "Q" ]; then
	echo -e "Abort !"
	exit 0
fi
echo -e "Select Result = ${MODEL}"
#
# function prototype f_make_all() from $1 (start) to $2 (end)
#
function f_make_all(){
    echo -e "make_all from $1 to $2"
    for((i = $1; i <= $2; i++))
    do
        echo -e "Building ${tpv_build_folder[i]}"
        echo -e "Copy Qmap files"
        if [ "${tpv_panel_type[i]}" == "UHD-60Hz" ]; then
            cp ./project/TPV_CODE/Video_PQ/${tpv_proj_customer[$1]}/QMAP/${tpv_qmap_folder[$1]}/* ./core/driver/pq/hal/maya/include/
        else
            cp ./project/TPV_CODE/Video_PQ/${tpv_proj_customer[$1]}/QMAP/${tpv_qmap_folder[$1]}/* ./core/driver/pq/hal/eden/include/
        fi

        #Compile start
        make PROJ=${tpv_build_folder[$1]} PROJECT_FILE_PATH=${tpv_proj_customer[$1]}
    done 
}

date
echo -e "Start building image code ...\n"
#
if [ "$MODEL" == "0" ]; then
    f_make_all 1 ${total_num}
else
    f_make_all $MODEL $MODEL
fi

date
echo -e "Building End ...\a\n"
#
exit 0
