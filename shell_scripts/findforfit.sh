nH=0.362
redshift=0.000103

cd /home/romeo/Chandra_data/Xspec-data-Field5

for ((i=1; i<=1; i++))
do
    file_name="${i}-spec-non-nuc_grp.pi"
    log_file="Field5_Source${i}.log"
    
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

    grep -A9999 "show fit" "$log_file" | tail -n +2 > "Field5_Source${i}_showfit.log"
done

