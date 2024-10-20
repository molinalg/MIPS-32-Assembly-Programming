.text
#-----------------------------------------------------------------------------------------------------------   
	matrixcompare:
    	
    	#We create space for the registers (3) we are going to use as counters to store their initial value and to store $ra
        subu $sp $sp 12
    	#Counter to control the row you are in
        sw $s0 8($sp)
    	#Counter to count the number of repetitions
        sw $s1 4($sp)
        #Adress $ra
        sw $ra ($sp)
        
        blez $a1 badendmat #Can't continue if M = 0
        blez $a2 badendmat #Can't continue if N = 0
        lw $t0 12($sp)
        blez $t0 badendmat #Can't continue if i = 0
        
        #Set counters to 0
        li $s0 0
        li $s1 0
        
	loopmat:
    	#If counter is bigger than the number of rows it finishes
        bge $s0 $a1 goodendmat
        
        #We set the correct parameters for the use of arraycompare (we need to store matrixcompare parameters first)
        subu $sp $sp 16
        sw $a0 12($sp)
        sw $a1 8($sp)
        sw $a2 4($sp)
        sw $a3 ($sp)
        #One of the element in the stack (the parameter i) has to be copied for the function arraycompare to work
        lw $t0 28($sp)
        subu $sp $sp 4
        sw $t0 ($sp)
    	
        #Calculation of N ($a1)
		move $a1 $a2
        #Calculation of A ($a0) by using matrix + N*4*$S0 (address of the beginning of each row)
        move $t0 $a2
        mul $t0 $t0 4
        mul $t0 $t0 $s0
        add $a0 $t0 $a0
        #Number to be searched: x($a2) = 4
   		move $a2 $a3
        #Number of occurrences i(a3) = 2
    	lw $t0 ($sp)
        move $a3 $t0
        
        #Calling function arraycompare to compare one row of the matrix
        jal arraycompare
        
        #Restore the parameters from before
        lw $a0 16($sp)
        lw $a1 12($sp)
        lw $a2 8($sp)
        lw $a3 4($sp)
        addu $sp $sp 20
        
    #Changing the value of $s0 to go check the next row in the matrix and storing in $s1 the sets founded already   
	continuemat:
    	addi $s0 $s0 1
        add $s1 $v1 $s1
        j loopmat
        
    #End of the function in case N = 0, M = 0 or i = 0    
	badendmat:
    	li $v0 -1
        j finishmat
    
    #End of the function in case N != 0, M != 0 and i != 0
    goodendmat:
        li $v0 0
        move $v1 $s1
        
    finishmat:
   		#Restore values of the registers 
    	lw $s0 8($sp)
        lw $s1 4($sp)
        #Restore previous value of $ra
        lw $ra ($sp)
        addu $sp $sp 12
        #Leave function
    	jr $ra     
    
#----------------------------------------------------------------------------------------------------------- 
    arraycompare:
    	#We create space for the registers (3) we are going to use as counters to store their initial value and to store $ra
        subu $sp $sp 16
    	#Counter to control the position in the vector
        sw $s0 12($sp)
    	#Counter to count the number of repetitions
        sw $s1 8($sp)
        #Counter to count the number of sets that match the conditions
        sw $s2 4($sp)
        #Adress $ra
        sw $ra ($sp)
        
    	blez $a1 badend #Can't continue if N = 0
        lw $t0 16($sp)
        blez $t0 badend #Can't continue if i = 0
        
        #Set counters to 0
        li $s0 0
        li $s1 0
        li $s2 0
      
    loop1:
  		#If counter is bigger than the number of elements it finishes
        bge $s0 $a1 goodend
        
        #Given that the function cmp uses $a0 and $a1, we prepare the registers storing the original first
        subu $sp $sp 8
        sw $a0 4($sp)
        sw $a1 ($sp)
    	#Take the number for $a0
    	mul $t1 $s0 4
        addu $t1 $a0 $t1
        lw $a0 ($t1)
        #Introduce in $a1 the number to be searched
        move $a1 $a2
        
        #Check if it is the same as the one we are looking for
        jal cmp
        
        #Restore the registers $a0 and $a1
        lw $a0 4($sp)
        lw $a1 ($sp)
        addu $sp $sp 8
        
        beqz $v0 notequal
        
        #If they are the same, the number of repetitions ascends
        addi $s1 $s1 1
        
        #Check if the number of repetitions is at least the dessired, continues looking if not
        lw $t0 16($sp)
        bne $s1 $t0 continue
        
        #The number of repetitions ascends if we have already found x i times consecutively
        addi $s2 $s2 1
        j continue
        
    #If both numbers aren't the same the number of repetitions is reseted
	notequal:
    	li $s1 0
        
    #Changing the value of $s0 to go check the next element in the vector
    continue:
    	addi $s0 $s0 1
        j loop1
        
    #End of the function in case N = 0 or i = 0
    badend:
    	li $v0 -1
        j finish
        
    #End of the function in case N != 0 and i != 0
    goodend:
        li $v0 0
        move $v1 $s2

    finish:
   		#Restore values of the registers 
    	lw $s0 12($sp)
        lw $s1 8($sp)
        lw $s2 4($sp)
        #Restore previous value of $ra
        lw $ra ($sp)
        addu $sp $sp 16
        #Leave function
    	jr $ra
#----------------------------------------------------------------------------------------------------------- 
