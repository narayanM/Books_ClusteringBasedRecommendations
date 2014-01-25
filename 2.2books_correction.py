#!/usr/bin/env python
# This python script also cleans the other data input files. adds the missing year values, removes extra tab charac, etc. 

import sys

for line in sys.stdin:
  try:
    # TO DO: Read the columns from books data.  
    (bookid, booktitle, bookauth, year, pub, imgs, imgm, imgl) = line.strip().split("\t")

    sys.stderr.write("reporter:counter:BOOKS,PROCESSED_LINES,1\n")
  except:
    sys.stderr.write("reporter:counter:BOOKS,SKIPPED_LINES,1\n")
    continue

  # Type casting the year: str to int: to update the year
  year = int(year)

  # (A): Handle the case of wrong years
  if bookid == '068160204X':
    year = 1997

  if bookid == '068107468X':
    year = 1998

  if bookid == '068471941X':
    year = 1920

  if bookid == '0590085417':
    year = 1974

  if bookid == '0380000059':
    year = 1925

  if bookid == '3442436893':
    year = 2006

  if bookid == '0671746103':
    year = 1991

  if bookid == '0671791990':
    year = 2003

  if bookid == '0870449842':
    year = 1997

  if bookid == '0870446924':
    year = 1999

  if bookid == '0671266500':
    year = 1961

  if bookid == '0684718022':
    year = 1970

  if bookid == '0671740989':
    year = 1991

  if bookid == '068471809X':
    year = 1970

  if bookid == '0394701658':
    year = 1959

  if bookid == '0140301690':
    year = 1950

  if bookid == '0140201092':
    year = 1950

  # (B): Handle the case of bookids with incorrect length.
  if bookid == '0385722206  0':
    bookid = '0385722206'

  if bookid == '3442248027  3':
    bookid = '3442248027'

  if bookid == '3518365479<90':
    bookid = '3518365479'

  # print the corrected line to standard output
  print "%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s" % (bookid, booktitle, bookauth, str(year), pub, imgs, imgm, imgl)
  
  # (c): Handle the case of wrong bookid with tab character. Delete that record.
  if bookid == '0486404242\t':
    continue 
