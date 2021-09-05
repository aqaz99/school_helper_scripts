#!/usr/bin/bash
# run_tests.bash
# Author: James Miners-Webb
# Info:   Student @ CSU Chico
# Desc: Runs a series of input files into a student-written file 
#       and compares the actual output vs expected output. 
#       This greatly speeds up needing to diff manually or run tests one at a time. 

#       As of now, 2 flags are also written, '-v' and '-m'.
#       -v is verbose, prints your output and expected output after each test.
#       -m is make, compile and make your program before running the rest of the script. 
#       Script must live in the same directory as Makefile and source files.

LANG=EN_en
if [ $# -lt 2 ]; then
    echo "Usage: $0 [OPTION] program_to_test location_of_test_files"
    exit
fi

# Check flags
while getopts :vhm flag
do
    case "${flag}" in
        v) verbose=1 
        echo "-- Running Verbose Mode --"
        ;;
        m) echo "-- Compiling Program --"
        make
        if [ $? != 0 ]; then
            echo "-- Program failed to compille --"
            exit
        fi
        ;;
        h) echo "Help is on the way";;
    esac
done

PROGRAM_TO_TEST=${@: -2} # Second to last argument
TEST_FILES=${@: -1}/*.in # Last argument
TEST_FILE_PATH=${@: -1}  # Last argument

rm -rd my_tests 2> /dev/null # Silence output on file/directory not found
mkdir my_tests
for item in $TEST_FILES; do
    # echo $item | sed -e 's/\(t[0-9]\+\)/ \1 /g' 
    TEST_NAME=$(echo $item | sed -e 's/.*\(t[0-9]\+\).*/\1/g')
    MY_TEST_NAME=$(echo 'my_'$TEST_NAME'.out')
    
    MY_TEST_LOCATION=my_tests/$MY_TEST_NAME
    
    OUTPUT_LOCATION=$TEST_FILE_PATH/$TEST_NAME'.out'
    echo "%%" $PROGRAM_TO_TEST "%%"
    $PROGRAM_TO_TEST < $item > my_tests/$MY_TEST_NAME
    
    DIFF_FILES=$(diff my_tests/$MY_TEST_NAME $OUTPUT_LOCATION)

    if [ $? == 1 ]; then # Return code of last command (diff) was not 0, meaning error
        if [ $verbose ]; then
            echo
            echo "-- Test $TEST_NAME failed."
            echo "Your output:"
            cat my_tests/$MY_TEST_NAME
            echo "Expected output:"
            cat $OUTPUT_LOCATION
            echo
        else
            echo "-- Test $TEST_NAME failed."
        fi
    else
        echo "Test $TEST_NAME passed!"
    fi 
done