#!/bin/bash

nH=0.0741
redshift=0.001761

cd /home/romeo/Chandra_data/Xspec-data-Field207

declare -a source_numbers
declare -a reduced_chi_squares_1
declare -a reduced_chi_squares_2
declare -a reduced_chi_squares_3

echo "Source Number | Code 1 (ztbabs*zpowerlw) | Code 2 (ztbabs*ztbabs(apec+zpowerlw)) | Code 3 (ztbabs*ztbabs(zpowerlw))"
echo "--------------|--------------------------|------------------------------------|--------------------------"

for ((i=1; i<=39; i++))
do
    file_name="${i}-spec-non-nuc_grp.pi"
    log_file="Field207_Source${i}_model1.log"
    showfit_log_file="Field207_Source${i}_showfit_model1.log"

    # Code 1 (ztbabs*zpowerlw)
    xspec - <<EOF > "$log_file"
    cpd /xw
    da ${file_name}
    setpl en
    ig **-0.3 8.0-**
    pl ld
    mo ztbabs*zpowerlw
    ${nH} -1
    ${redshift}
    1
    ${redshift}
    1
    renorm
    fit
    newpar 3 2 0.001 1.2 1.8 2.5 3.5
    fit
    show fit
    exit
EOF

    grep -A9999 "show fit" "$log_file" | tail -n +2 > "$showfit_log_file"

    chi_squared=$(grep -oP 'Fit statistic\s+:\s+Chi-Squared\s+\K(\d+\.\d+)' "$showfit_log_file")
    degrees_of_freedom=$(grep -oP 'Null hypothesis probability of [\d.e-]+\s+with\s+\K(\d+)' "$showfit_log_file")

    if [[ -n $chi_squared ]] && [[ -n $degrees_of_freedom ]] && ((degrees_of_freedom > 0)); then
        reduced_chi_square_1=$(awk "BEGIN { print $chi_squared / $degrees_of_freedom }")
    else
        reduced_chi_square_1=""
    fi

    # Code 2 (ztbabs*ztbabs(apec+zpowerlw))
    log_file="Field207_Source${i}_model2.log"
    showfit_log_file="Field207_Source${i}_showfit_model2.log"

    xspec - <<EOF > "$log_file"
    cpd /xw
    da ${file_name}
    setpl en
    ig **-0.3 8.0-**
    pl ld
    mo ztbabs*ztbabs(apec+zpowerlw)
    ${nH} -1
    ${redshift}
    # Skip position 1 (pressing enter)
    ${redshift}
    # Skip position 2 (pressing enter)
    # Skip position 3 (pressing enter)
    ${redshift}
    1
    # Skip position 4 (pressing enter)
    ${redshift}
    1
    renorm
    fit
    newpar 9 2 0.001 1.2 1.8 2.5 3.5
    fit
    show fit
    exit
EOF

    grep -A9999 "show fit" "$log_file" | tail -n +2 > "$showfit_log_file"

    chi_squared=$(grep -oP 'Fit statistic\s+:\s+Chi-Squared\s+\K(\d+\.\d+)' "$showfit_log_file")
    degrees_of_freedom=$(grep -oP 'Null hypothesis probability of [\d.e-]+\s+with\s+\K(\d+)' "$showfit_log_file")

    if [[ -n $chi_squared ]] && [[ -n $degrees_of_freedom ]] && ((degrees_of_freedom > 0)); then
        reduced_chi_square_2=$(awk "BEGIN { print $chi_squared / $degrees_of_freedom }")
    else
        reduced_chi_square_2=""
    fi

        # Code 3 (ztbabs*ztbabs(zpowerlw))
        log_file="Field207_Source${i}_model3.log"
        showfit_log_file="Field207_Source${i}_showfit_model3.log"

        xspec - <<EOF > "$log_file"
        cpd /xw
        da ${file_name}
        setpl en
        ig **-0.3 8.0-**
        pl ld
        mo ztbabs*ztbabs(zpowerlw)
        ${nH} -1
        ${redshift}
        #
        ${redshift}
        #
        ${redshift}
        1
        renorm
        fit
        newpar 5 2 0.001 1.2 1.8 2.5 3.5
        fit
        show fit
        exit
EOF

        grep -A9999 "show fit" "$log_file" | tail -n +2 > "$showfit_log_file"

        chi_squared=$(grep -oP 'Fit statistic\s+:\s+Chi-Squared\s+\K(\d+\.\d+)' "$showfit_log_file")
        degrees_of_freedom=$(grep -oP 'Null hypothesis probability of [\d.e-]+\s+with\s+\K(\d+)' "$showfit_log_file")

        if [[ -n $chi_squared ]] && [[ -n $degrees_of_freedom ]] && ((degrees_of_freedom > 0)); then
            reduced_chi_square_3=$(awk "BEGIN { print $chi_squared / $degrees_of_freedom }")
        else
            reduced_chi_square_3=""
        fi

        source_numbers+=("$i")
        reduced_chi_squares_1+=("$reduced_chi_square_1")
        reduced_chi_squares_2+=("$reduced_chi_square_2")
        reduced_chi_squares_3+=("$reduced_chi_square_3")

        echo "Source $i       | $reduced_chi_square_1                   | $reduced_chi_square_2                  | $reduced_chi_square_3"

    done

    # Plot the table
    echo
    echo "Final Table:"
    echo "Source Number | Code 1 (ztbabs*zpowerlw) | Code 2 (ztbabs*ztbabs(apec+zpowerlw)) | Code 3 (ztbabs*ztbabs(zpowerlw))"
    echo "--------------|--------------------------|------------------------------------|--------------------------"

    for ((i=0; i<${#source_numbers[@]}; i++))
    do
        echo "Source ${source_numbers[i]}       | ${reduced_chi_squares_1[i]}             | ${reduced_chi_squares_2[i]}              | ${reduced_chi_squares_3[i]}"
    done

 # Remove log files
for ((i=1; i<=39; i++))
do
    rm "Field207_Source${i}_model1.log"
    rm "Field207_Source${i}_model2.log"
    rm "Field207_Source${i}_model3.log"
    rm "Field207_Source${i}_showfit_model1.log"
    rm "Field207_Source${i}_showfit_model2.log"
    rm "Field207_Source${i}_showfit_model3.log"
done
done


