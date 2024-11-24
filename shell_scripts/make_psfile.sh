cd /home/romeo/Chandra_data/Xspec-data-Field5

for ((i=1 ; i<=16 ; i++))
do
    xcm_file="F5_S${i}.xcm"
    
    echo "Running XSPEC script: ${xcm_file}"
    
    xspec - <<EOF
cpd /xw
setpl en

@${xcm_file}

pl ld delc
fit
ipl
time off
lab t Field5_Source${i}
lab y keV(Photons cm-2 s-1 keV-1)
r y 0.0001 0.7
r y2 -3 3
cs 1.2
plot
h F5_S${i}.ps/ps

exit
EOF

    #if [ $? -eq 0 ]; then
       # echo "XSPEC script completed successfully: ${xcm_file}"
   # else
       # echo "Error executing XSPEC script: ${xcm_file}"
    #fi

done

