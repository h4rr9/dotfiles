#!/bin/bash

exec_name="$PWD/$1"
input_name="$PWD/$2"
output_name="$PWD/$3"
temp_output_name="$PWD/$4"
output_trimmed=$output_name".trimmed"
temp_output_trimmed=$temp_output_name".trimmed"


eval $($exec_name < $input_name > $temp_output_name 2> /dev/null)
tr '[:blank:]' '\n' < $temp_output_name > $temp_output_trimmed
tr '[:blank:]' '\n' < $output_name > $output_trimmed
diff -bBZq $output_trimmed $temp_output_trimmed
rm $output_trimmed $temp_output_trimmed


