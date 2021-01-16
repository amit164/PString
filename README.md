# PString
1. [Introduction](#introduction)  
2. [main.s:](#main.s)  
3. [Dependencies:](#dependencies)  


## Introduction
As part of Computer Structur course we were given an exercise implement several methods similar to the string.h, just as pstring i.e. string's length is the first byte and the others are the string it self. The methods are:

1. char pstrlen(Pstring* pstr) - return pstring's length.
2. Pstring* replaceChar(Pstring* pstr, char oldChar, char newChar) - replace all the oldChar with new char in the pstring
3. Pstring* pstrijcpy(Pstring* dst, Pstring* src, char i, char j) - copy the chars in src[i:j] to dst[i:j]
4. Pstring* swapCase(Pstring* pstr) - replace all lower case to upper case and the opposite.
5. int pstrijcmp(Pstring* pstr1, Pstring* pstr2, char i, char j) - compare between src[i:j] to dst[i:j]


## run_main.s:
Getting an int from the user - the length of the first pstring (n), then getting n chars for the first pstirng. Then doing the same procces for the second pstring. Getting a number from the user (50, 52-55 or 60) and run one of the functions above using a switch case statement.

The switch-case options are:
##### 50 or 60:
* Calculate and print the two pstring length
##### 52:
* Getting from the user two chars, oldChar and newChar. Then replace all the instance of the oldChar to the newChar (in the two pstrings).
##### 53:
* Getting from the user two integers, i and j. Than call the pstrijcpy function with src as the second pstring and dst as the first. Then prints the two pstrings.
##### 54:
* Using the swapCase function to swap every upper-case to lower-case in the two pstring.
##### 55:
* Getting from the user two integers, i and j. Then call the pstrijcmp function with pstr1 as the first pstring and pstr2 as the second. Then prints the compare result.


## Dependencies:
* MacOS / Linux
