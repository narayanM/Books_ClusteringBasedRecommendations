#!/usr/bin/env python

import sys

for line in sys.stdin:
  try:
    # Read the columns from users data: userid, location, age.
    (userid, location, age) = line.strip().split("\t")
    # Read the location column further into city, state, country based on its delimiter ",".
    (city, state, country) = location.strip().split(",")

	# Print errors if any	
    sys.stderr.write("reporter:counter:USERS,PROCESSED_LINES,1\n")
  except:
    # Print errors if any	
    sys.stderr.write("reporter:counter:USERS,SKIPPED_LINES,1\n")
    continue

  # (A): Handle the case of \n character. update the city without next-line character.
  if userid == '275081':
    city = 'cernusco s'

  # print the corrected line, with 5 fields to standard output
  print "%s\t%s\t%s\t%s\t%s" % (userid, city, state, country, age)