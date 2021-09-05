# school_helper_scripts
Any scripts I may have used that have helped me in the coding process for my school assignments. Feel free to add, or adjust anything!

# Current Scripts:
  - run_tests.bash
      Runs a series of input files into a student-written file and compares the actual output vs expected output. This greatly speeds up needing to diff manually or       run tests one at a time. As of now, 2 flags are also written, '-v' and '-m'. 
      #### -v is verbose, prints your output and expected output after each test.
      #### -m is make, compile and make your program before running the rest of the script. Script must live in the same directory as Makefile and source files.
      #### -t is tests, list either a series of tests or a singular test that you would like to run. Ex: -t 03-09 or -t 11
      
      Add the script to your path as seen here:https://linuxize.com/post/how-to-add-directory-to-path-in-linux/ to be able to call this script from any directory.
