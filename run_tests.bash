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

# Functions
usage() { 
    echo "Usage: $0 [OPTION] program_to_test location_of_test_files" 
}

display_test(){
    MY_TEST_NAME=$(echo 'my_'$TEST_NAME'.out')
    MY_TEST_LOCATION=my_tests/$MY_TEST_NAME
    OUTPUT_LOCATION=$TEST_FILE_PATH/$TEST_NAME'.out'
    $PROGRAM_TO_TEST < $item > my_tests/$MY_TEST_NAME
    DIFF_FILES=$(diff my_tests/$MY_TEST_NAME $OUTPUT_LOCATION)

    if [ $? == 1 ]; then # Return code of last command (diff) was not 0, meaning error
        echo "-- Test $TEST_NAME failed."
        if [ $verbose ]; then
            echo "Your output:"
            cat my_tests/$MY_TEST_NAME
            echo
            echo "Expected output:"
            cat $OUTPUT_LOCATION
            echo
        fi 
    else
        echo "Test $TEST_NAME passed!"
        if [ ! $hide_passing ]; then
            if [ $verbose ]; then
                echo "Your output:"
                cat my_tests/$MY_TEST_NAME
                echo
                echo "Expected output:"
                cat $OUTPUT_LOCATION
                echo
            fi 
        fi
    fi

    
}

if [ $# -lt 2 ]; then
    usage
    exit
fi

LAST_TEST=""
# Check flags
while getopts :vphmt: flag
do
    case "${flag}" in
        v) verbose=1 
        echo "-- Running Verbose Mode --"
        ;;
        p) hide_passing=1
        ;;
        m) echo "-- Compiling Program --"
        make
        if [ $? != 0 ]; then
            echo "-- Program failed to compille --"
            exit
        fi
        ;;
        h) echo "Help is on the way"
        ;;
        t) tests=${OPTARG}
        SECOND_TO_LAST=$(echo ${@: -2} | cut -d ' ' -f1)
        if [[ -z "$tests" || $tests == $SECOND_TO_LAST ]]; then # User provided no tests
            usage 
            exit
        else
            if [[ "$tests" == *"-"* ]]; then # User has provided multiple tests ex: 0-9
                FIRST_TEST=$(echo $tests | sed -e 's/\(.*\)-\(.*\)/\1 \2/g' | cut -d ' ' -f1)
                LAST_TEST=$(echo $tests | sed -e 's/\(.*\)-\(.*\)/\1 \2/g' | cut -d ' ' -f2)
                if [ $FIRST_TEST -gt $LAST_TEST ]; then
                    usage
                    echo "Error: First test is greater than last test."
                    exit
                fi
                echo "-- Running tests $FIRST_TEST through $LAST_TEST --"
            else
                # User wants to run just one test
                echo "-- Running test $tests --"
                LAST_TEST=$tests
            fi
            
            
        fi
        ;;
    esac
done

PROGRAM_TO_TEST=$(echo ${@: -2} | cut -d ' ' -f1) # Second to last argument
TEST_FILES=${@: -1}/*.in # Last argument
TEST_FILE_PATH=${@: -1}  # Last argument

rm -rd my_tests 2> /dev/null # Silence output on file/directory not found
mkdir my_tests

if [ "$LAST_TEST" == "" ];then # User did not provide test numbers
    for item in $TEST_FILES; do
        TEST_NAME=$(echo $item | sed -e 's/.*\(t[0-9]\+\).*/\1/g')
        display_test
    done

else 
    FOUND_FIRST=0 # Checks for -t tests
    for item in $TEST_FILES; do
        TEST_NAME=$(echo $item | sed -e 's/.*\(t[0-9]\+\).*/\1/g')
        
        if [ $TEST_NAME == 't'$LAST_TEST ]; then # Exit after last test
            display_test
            exit
        fi

        if [ $TEST_NAME == 't'$FIRST_TEST ]; then
            FOUND_FIRST=1
            display_test
        else
            if [ $FOUND_FIRST == 1 ]; then
                display_test
            fi
        fi
        
    done
fi
