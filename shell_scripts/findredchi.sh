#!/bin/bash

for ((i=1; i<=1; i++))
do
    filename="Field5_Source${i}_showfit.log"

    # Extract the chi-squared value using grep and sed
    chi_squared=$(grep -oP 'Fit statistic\s+:\s+Chi-Squared\s+\K(\d+\.\d+)' "$filename")

    # Extract the degrees of freedom using grep and awk
    degrees_of_freedom=$(grep -oP 'Null hypothesis probability of [\d.e-]+\s+with\s+\K(\d+)' "$filename")

    # Calculate the reduced chi-square
    if [[ -n $chi_squared ]] && [[ -n $degrees_of_freedom ]] && ((degrees_of_freedom > 0)); then
        reduced_chi_square=$(awk "BEGIN { print $chi_squared / $degrees_of_freedom }")
    else
        reduced_chi_square=""
    fi

    # Print the extracted values
    echo "File: $filename"
    echo "Chi-Squared: $chi_squared"
    echo "Degrees of Freedom: $degrees_of_freedom"
    echo "Reduced Chi-Square: $reduced_chi_square"
    echo
done

