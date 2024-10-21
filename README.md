# MIPS 32 Assembly Programming

## Description
Developed in 2021, "MIPS 32 Assembly Programming" is a university project made during the second course of Computer Engineering at UC3M in collaboration with @angelmrtn.

It was made for the subject "Computer Structures" and is the solution to a problem proposed. The main goal of this project was to put in practice our knowledge about the programming language **Assembly** to program simple tasks around the processor MIPS 32.

## Table of Contents
- [Installation and Usage](#installation-and-usage)
- [Problem Proposed](#problem-proposed)
- [License](#license)
- [Contact](#contact)

## Installation and Usage
To execute this code it is necessary to use an environment that allows the execution of Assembly code for the processor MIPS 32.

## Problem Proposed
This repository contains 2 files each corresponding to one of the exercises proposed. The first one plans to built 2 functions with different missions each:

- **ArrayCompare:** Receives an array of numbers, it's size (N), a number to be searched (X) and the consecutive times it must be repeated (i). The function will count how many times "X" is found repeated "i" times. For example, in the array [1,5,2,5,2,2,2,3], if "X" is 2 and "i" is 3, que result will be "1" because the number 2 appears 3 consecutive times 1 time in the array. **This function can return 2 values**, a number indicating if the operation succeeded (0 if it was successful and -1 if not) and the result (only if there wasn't any errors).

- **MatrixCompare:** Similar to the previous one, it uses ArrayCompare to apply a similar task to matrices. The input is a matrix of any size, que number of rows (N), the number of columns (M), the number to look for (X) and the amount of repetitions to look for as before. **The output is again 2 possible numbers** that work the same as before, however this time the function will search for the pattern in all the rows of the matrix.

The second exercise contains one function whose role is to modify matrices. To do so, it will receive a matrix, the number of rows it has (M), the number of columns (N) and one of the coordinates (i and j) of the matrix. The code will process the matrix according to 3 main rules:

- Every number that is not normalized will be changed by the value located in the coordinates passed as parameters.

- If any value is NaN, it's value will be changed to a 0.

- All the other numbers are kept the same.

The matrices used in this second exercise use numbers in format IEEE 754 and can be both decimal and hexadecimal numbers. The output will be -1 if the code encountered an error or 0 if not.

## License
This project is licensed under the **MIT License**. This means you are free to use, modify, and distribute the software, but you must include the original license and copyright notice in any copies or substantial portions of the software.

## Contact
If necessary, contact the owner of this repository.
