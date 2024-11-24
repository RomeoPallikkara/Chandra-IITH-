nH=0.362
redshift=0.000103

cd /home/romeo/Chandra_data/Xspec-data-Field5

declare -a source_numbers
declare -a reduced_chi_squares

echo "Source Number | Reduced Chi-Square"
echo "--------------|-------------------"

for ((i=1; i<=16; i++))
do
    file_name="${i}-spec-non-nuc_grp.pi"
    log_file="Field5_Source${i}.log"
    showfit_log_file="Field5_Source${i}_showfit.log"

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
        reduced_chi_square=$(awk "BEGIN { print $chi_squared / $degrees_of_freedom }")
    else
        reduced_chi_square=""
    fi

    source_numbers+=("$i")
    reduced_chi_squares+=("$reduced_chi_square")

    echo "Source $i       | $reduced_chi_square"

done

# Plot the table
echo
echo "Final Table:"
echo "Source Number | Reduced Chi-Square"
echo "--------------|-------------------"
for ((i=0; i<${#source_numbers[@]}; i++))
do
    echo "Source ${source_numbers[i]}       | ${reduced_chi_squares[i]}"
done




