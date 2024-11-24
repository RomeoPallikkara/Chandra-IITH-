nH=0.0106
redshift=0.00814
Field_number=211
Folder_path=/home/romeo/Chandra_data/Xspec-data-Field${Field_number}

cd ${Folder_path}

# Remove existing files if present
rm -f para_F${Field_number}_S*.txt
rm -f para_F${Field_number}_S*.txt
rm -f para_F${Field_number}_S*.txt
rm -f para_F${Field_number}_S*.txt
rm -f para_F${Field_number}_S*.txt

rm -f F${Field_number}_Source*.xcm
rm -f chi.txt
rm -f *.fitting_model1.txt
rm -f *.fitting_model2.txt
rm -f *.fitting_model3.txt
rm -f *.fitting_model4.txt
rm -f *.fitting_model5.txt
rm -f model-1_Field-${Field_number}_Source-*.xcm
rm -f model-2_Field-${Field_number}_Source-*.xcm
rm -f model-3_Field-${Field_number}_Source-*.xcm
rm -f model-4_Field-${Field_number}_Source-*.xcm
rm -f model-5_Field-${Field_number}_Source-*.xcm
rm -f *.ps
rm -f *parameter_file.txt

# Array to store fitted sources
fitted_sources=()
non_fitted_sources=()
fit_result=()
for ((i=1; i<=21; i++))
do
    xspec <<EOF > "$i-fitting_model1.txt"
    data $i-spec-non-nuc_grp.pi
    cpd /xs
    pl ld
    setp e
    ig **-0.3 8.0-**
    mo ztbabs*zpowerlw
    ${nH}
    ${redshift}
    2
    ${redshift}
    1
    query yes
    renorm
    fit 
    newpar 3 2 0.001 1.2 1.8 2.5 3.5
    newpar 1 ${nH} -1
    fit
    renorm
    fit
    pl ld delc
    save all "model-1_Field-${Field_number}_Source-$i.xcm"
    quit
    exit
EOF

    # Extract reduced chi-square value after model 1 fitting
    tail -n 6 "$i-fitting_model1.txt" | head -n 2 > chi.txt
    chisq=$(grep -oE '[0-9]+\.[0-9]+' chi.txt | tail -n 2 | head -n 1)
    dof=$(grep -oE '[0-9]+' chi.txt | tail -n 1 | head -n 2)
    redchisq=$(echo "scale=4; $chisq/$dof" | bc)

    echo "Using model 1 (ztbabs*zpowerlw) Source $i: Reduced Chi-square = $redchisq"
    rm $i-fitting_model1.txt
    if (( $(echo "$redchisq >= 0.6" | bc -l) )) && (( $(echo "$redchisq <= 1.3" | bc -l) )); then
        # Add the fitted source to the array
        fitted_sources+=("Source $i: Reduced Chi-square = $redchisq")
        fit_result+=("Source $i: model = ztbabs*zpowerlw                : Reduced Chi-square = $redchisq")

        xspec <<EOF > "para_F${Field_number}_S$i.txt"
        data $i-spec-non-nuc_grp.pi
        cpd /xs
        pl ld
        setp e
        ig **-0.3 8.0-**
        mo ztbabs*zpowerlw
        ${nH}
        ${redshift}
        2
        ${redshift}
        1
        query yes
        renorm
        fit 
        newpar 3 2 0.001 1.2 1.8 2.5 3.5
        newpar 1 ${nH} -1
        fit
        renorm
        fit
        pl ld delc
        chatter 5
        err 1. 1-5
        save all "F${Field_number}_Source$i.xcm"
        quit
        exit
    
EOF
    

    	
        continue
    fi
    non_fitted_sources+=("Source $i: model = ztbabs*zpowerlw                : Reduced Chi-square = $redchisq") 
    xspec <<EOF > "$i-fitting_model2.txt"
    data $i-spec-non-nuc_grp.pi
    cpd /xs
    pl ld
    setp e
    ig **-0.3 8.0-**
    mo ztbabs*ztbabs*zpowerlw
    ${nH} -1
    ${redshift}
    0.01
    ${redshift}
    2
    ${redshift}
    1
    query yes
    renorm
    fit 
    newpar 3 1.0 0.001 0.5 0.7 1.4 3.0
    newpar 5 2 0.001 1.2 1.8 2.5 3.5
    newpar 1 ${nH} -1
    fit
    renorm
    fit
    pl ld delc
    save all "model-2_Field-${Field_number}_Source-$i.xcm"
    quit
    exit
EOF

    # Extract reduced chi-square value after model 2 fitting
    tail -n 6 "$i-fitting_model2.txt" | head -n 2 > chi.txt
    chisq=$(grep -oE '[0-9]+\.[0-9]+' chi.txt | tail -n 2 | head -n 1)
    dof=$(grep -oE '[0-9]+' chi.txt | tail -n 1 | head -n 2)
    redchisq=$(echo "scale=4; $chisq/$dof" | bc)

    echo "Using model 2 (ztbabs*ztbabs*zpowerlw) Source $i: Reduced Chi-square = $redchisq"
    rm $i-fitting_model2.txt
    rm chi.txt

    if (( $(echo "$redchisq >= 0.6" | bc -l) )) && (( $(echo "$redchisq <= 1.3" | bc -l) )); then
        # Add the fitted source to the array
        fitted_sources+=("Source $i: Reduced Chi-square = $redchisq")
        fit_result+=("Source $i: model = ztbabs*ztbabs*zpowerlw         : Reduced Chi-square = $redchisq") 

        xspec <<EOF > "para_F${Field_number}_S$i.txt"
        data $i-spec-non-nuc_grp.pi
        cpd /xs
        pl ld
        setp e
        ig **-0.3 8.0-**
        mo ztbabs*ztbabs*zpowerlw
        ${nH} -1
        ${redshift}
        0.01
        ${redshift}
        2
        ${redshift}
        1
        query yes
        renorm
        fit 
        newpar 3 1.0 0.001 0.5 0.7 1.4 3.0
        newpar 5 2 0.001 1.2 1.8 2.5 3.5
        newpar 1 ${nH} -1
        fit
        renorm
        fit
        pl ld delc
        chatter 5
        err 1. 1-7
        save all "F${Field_number}_Source$i.xcm"
        quit
        exit
EOF

    

    	
        continue
    fi
    non_fitted_sources+=("Source $i: model = ztbabs*ztbabs*zpowerlw         : Reduced Chi-square = $redchisq") 
    xspec <<EOF > "$i-fitting_model3.txt"
    data $i-spec-non-nuc_grp.pi
    cpd /xs
    pl ld 
    setp e
    ig **-0.3 8.0-**
    mo ztbabs*ztbabs(apec + zpowerlw)
    ${nH} -1
    ${redshift}
    0.01
    ${redshift}
    1
    1
    ${redshift}
    1
    2
    ${redshift}
    1
    query yes
    renorm
    fit  
    newpar 3 1.0 0.001 0.5 0.7 1.4 3.0
    newpar 9 2 0.001 1.2 1.8 2.5 3.5
    newpar 1 ${nH} -1
    fit
    renorm
    fit
    save all "model-3_Field-${Field_number}_Source-$i.xcm"
    pl ld delc
    quit
    exit
EOF

    # Extract reduced chi-square value after model 3 fitting
    tail -n 6 "$i-fitting_model3.txt" | head -n 2 > chi.txt
    chisq=$(grep -oE '[0-9]+\.[0-9]+' chi.txt | tail -n 2 | head -n 1)
    dof=$(grep -oE '[0-9]+' chi.txt | tail -n 1 | head -n 2)
    redchisq=$(echo "scale=4; $chisq/$dof" | bc)

    echo "Using model 3 (ztbabs*ztbabs*apec+zpowerlw) Source $i: Reduced Chi-square = $redchisq"
    rm $i-fitting_model3.txt
    rm chi.txt

    if (( $(echo "$redchisq >= 0.6" | bc -l) )) && (( $(echo "$redchisq <= 1.3" | bc -l) )); then
        # Add the fitted source to the array
        fitted_sources+=("Source $i: Reduced Chi-square = $redchisq")
        fit_result+=("Source $i: model = ztbabs*ztbabs(apec +zpowerlw)  : Reduced Chi-square = $redchisq")
        xspec <<EOF > "para_F${Field_number}_S$i.txt"
        data $i-spec-non-nuc_grp.pi
        cpd /xs
        pl ld 
        setp e
        ig **-0.3 8.0-**
        mo ztbabs*ztbabs(apec + zpowerlw)
        ${nH} -1
        ${redshift}
        0.01
        ${redshift}
        1
        1
        ${redshift}
        1
        2
        ${redshift}
        1
        query yes
        renorm
        fit  
        newpar 3 1.0 0.001 0.5 0.7 1.4 3.0
        newpar 9 2 0.001 1.2 1.8 2.5 3.5
        newpar 1 ${nH} -1
        fit
        renorm
        fit
        pl ld delc
        chatter 5
        err 1. 1-11
        save all "F${Field_number}_Source$i.xcm"
        quit
        exit
EOF
    


	continue
    fi
    
    non_fitted_sources+=("Source $i: model = ztbabs*ztbabs(apec +zpowerlw)  : Reduced Chi-square = $redchisq") 
    xspec <<EOF > "$i-fitting_model4.txt"
    data $i-spec-non-nuc_grp.pi
    cpd /xs
    pl ld 
    setp e
    ig **-0.3 8.0-**
    mo ztbabs*ztbabs(diskbb + zpowerlw)
    ${nH} -1
    ${redshift}
    0.01
    ${redshift}
    1
    1
    2
    ${redshift}
    1
    query yes
    renorm
    fit  
    newpar 3 1.0 0.001 0.5 0.7 1.4 3.0
    newpar 7 2 0.001 1.2 1.8 2.5 3.5
    newpar 1 ${nH} -1
    fit
    renorm
    fit
    save all "model-4_Field-${Field_number}_Source-$i.xcm"
    pl ld delc
    quit
    exit
EOF

    # Extract reduced chi-square value after model 3 fitting
    tail -n 6 "$i-fitting_model4.txt" | head -n 2 > chi.txt
    chisq=$(grep -oE '[0-9]+\.[0-9]+' chi.txt | tail -n 2 | head -n 1)
    dof=$(grep -oE '[0-9]+' chi.txt | tail -n 1 | head -n 2)
    redchisq=$(echo "scale=4; $chisq/$dof" | bc)

    echo "Using model 4 (ztbabs*ztbabs*diskbb+zpowerlw) Source $i: Reduced Chi-square = $redchisq"
    rm $i-fitting_model4.txt
    rm chi.txt

    if (( $(echo "$redchisq >= 0.6" | bc -l) )) && (( $(echo "$redchisq <= 1.3" | bc -l) )); then
        # Add the fitted source to the array
        fitted_sources+=("Source $i: Reduced Chi-square = $redchisq")
        fit_result+=("Source $i: model = ztbabs*ztbabs(diskbb +zpowerlw): Reduced Chi-square = $redchisq")
        xspec <<EOF > "para_F${Field_number}_S$i.txt"
        data $i-spec-non-nuc_grp.pi
        cpd /xs
        pl ld 
        setp e
        ig **-0.3 8.0-**
        mo ztbabs*ztbabs(diskbb + zpowerlw)
        ${nH} -1
        ${redshift}
        0.01
        ${redshift}
        1
        1
        2
        ${redshift}
        1
        query yes
        renorm
        fit  
        newpar 3 1.0 0.001 0.5 0.7 1.4 3.0
        newpar 7 2 0.001 1.2 1.8 2.5 3.5
        newpar 1 ${nH} -1
        fit
        renorm
        fit
        pl ld delc
        chatter 5
        err 1. 1-9
        save all "F${Field_number}_Source$i.xcm"
        quit
        exit
EOF
    


	continue
    fi
    
    non_fitted_sources+=("Source $i: model = ztbabs*ztbabs(diskbb +zpowerlw): Reduced Chi-square = $redchisq") 
    xspec <<EOF > "$i-fitting_model5.txt"
    data $i-spec-non-nuc_grp.pi
    cpd /xs
    pl ld 
    setp e
    ig **-0.3 8.0-**
    mo ztbabs*ztbabs(bbody + zpowerlw)
    ${nH} -1
    ${redshift}
    0.01
    ${redshift}
    1
    1
    2
    ${redshift}
    1
    query yes
    renorm
    fit  
    newpar 3 1.0 0.001 0.5 0.7 1.4 3.0
    newpar 7 2 0.001 1.2 1.8 2.5 3.5
    newpar 1 ${nH} -1
    fit
    renorm
    fit
    save all "model-5_Field-${Field_number}_Source-$i.xcm"
    pl ld delc
    quit
    exit
EOF

    # Extract reduced chi-square value after model 3 fitting
    tail -n 6 "$i-fitting_model5.txt" | head -n 2 > chi.txt
    chisq=$(grep -oE '[0-9]+\.[0-9]+' chi.txt | tail -n 2 | head -n 1)
    dof=$(grep -oE '[0-9]+' chi.txt | tail -n 1 | head -n 2)
    redchisq=$(echo "scale=4; $chisq/$dof" | bc)

    echo "Using model 5 (ztbabs*ztbabs*bbody+zpowerlw) Source $i: Reduced Chi-square = $redchisq"
    rm $i-fitting_model5.txt
    rm chi.txt

    if (( $(echo "$redchisq >= 0.6" | bc -l) )) && (( $(echo "$redchisq <= 1.3" | bc -l) )); then
        # Add the fitted source to the array
        fitted_sources+=("Source $i: Reduced Chi-square = $redchisq")
        fit_result+=("Source $i: model = ztbabs*ztbabs(bbody +zpowerlw) : Reduced Chi-square = $redchisq")

        xspec <<EOF > "para_F${Field_number}_S$i.txt"
        data $i-spec-non-nuc_grp.pi
        cpd /xs
        pl ld 
        setp e
        ig **-0.3 8.0-**
        mo ztbabs*ztbabs(bbody + zpowerlw)
        ${nH} -1
        ${redshift}
        0.01
        ${redshift}
        1
        1
        2
        ${redshift}
        1
        query yes
        renorm
        fit  
        newpar 3 1.0 0.001 0.5 0.7 1.4 3.0
        newpar 7 2 0.001 1.2 1.8 2.5 3.5
        newpar 1 ${nH} -1
        fit
        renorm
        fit
        pl ld delc
        chatter 5
        err 1. 1-9
        save all "F${Field_number}_Source$i.xcm"
        quit
        exit
EOF

    else    
    	echo "Source $i is not fitted by any models"
    	non_fitted_sources+=("Source $i: model = ztbabs*ztbabs(bbody +zpowerlw) : Reduced Chi-square = $redchisq") 
    fi


done



#plotting code for the .ps plots
for ((i=1; i<=21; i++))
do
xspec - <<EOF
cpd /xw
setpl en
@F${Field_number}_Source${i}.xcm
fit
pl ld delc
ipl
time off
lab t Field${Field_number}_Source${i}
r y 0.0001 0.7
r y2 -3 3
cs 1.2
plot
h F${Field_number}_S${i}.ps/ps
exit
EOF

done


#This code will save the fitted sources as a txt file 
# Create a string with the contents of the fit_result array
result_string=$(printf "%s\n" "${fit_result[@]}")

# Save the result_string to a file
echo "$result_string" > fit_result.txt


printf "%s\n" "${non_fitted_sources[@]}" > need.txt



#code to show which all sources have been fitted as a list
echo "Non Fitted sources:"
#!/bin/bash

# Read fit_result.txt and extract the first column into source_list
source_list=$(awk -F ': ' '{print $1}' fit_result.txt)

# Iterate over each line in need.txt and save non-matching lines to non_fit_result.txt
while IFS= read -r line; do
    # Check if any element from source_list exists in the line
    if grep -vqF "${source_list[*]}" <<< "$line"; then
        echo "$line" 
        echo "$line" >> non_fit_result.txt
    fi
done < need.txt







#code to show which all sources have been fitted as a list
echo "Fitted sources:"
for source in "${fitted_sources[@]}"; do
    echo "$source"
done



# Remove the model files if they exist
for ((i=1; i<=21; i++))
do
    if [ -e model-1_Field-${Field_number}_Source-$i.xcm ]; then
        rm model-1_Field-${Field_number}_Source-$i.xcm
    fi
    if [ -e model-2_Field-${Field_number}_Source-$i.xcm ]; then
        rm model-2_Field-${Field_number}_Source-$i.xcm
    fi
    if [ -e model-3_Field-${Field_number}_Source-$i.xcm ]; then
        rm model-3_Field-${Field_number}_Source-$i.xcm
    fi
    if [ -e model-4_Field-${Field_number}_Source-$i.xcm ]; then
        rm model-4_Field-${Field_number}_Source-$i.xcm
    fi
    if [ -e model-5_Field-${Field_number}_Source-$i.xcm ]; then
        rm model-5_Field-${Field_number}_Source-$i.xcm
    fi
done


#code to save the chatter parametrs which have been extracted from the log files
rm -f *parameter_file.txt


for file in "${Folder_path}"/*.txt
do
	filename=$(basename "$file" .txt)
	for ((i = 1; i <= 5; i++)); do
	grep -E "^     [1-9]|^    1[0-1]" "$file" | grep -v "ignored" | awk '{arr[$1]=$0} END{for(i=1;i<=11;i++) if(i in arr) print arr[i]}' > "${filename}_parameter_file.txt"
done


done

#making folder and saving into it
for ((i=1; i<=21; i++))
do
destination="/home/romeo/CHANDRA_FINAL"
mkdir -p "$destination/$Field_number"
#mv F${Field_number}_Source$i.xcm $destination/$Field_number/
mv para_F${Field_number}_S$i.txt $destination/$Field_number/
mv F${Field_number}_S${i}.ps $destination/$Field_number/
mv non_fit_result.txt $destination/$Field_number/
mv fit_result.txt $destination/$Field_number/


done

##this thing works for the nfs
#awk 'NR > 1 { if ($3 < min[$1] || min[$1] == "") { min[$1] = $3; line[$1] = $0 } } END { for (source in line) print line[source] }' non_fitted_so.txt | sort -k1n


rm -f *parameter_file.txt
rm -f chi.txt


