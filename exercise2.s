.text   
#-----------------------------------------------------------------------------------------------------------  
	modifymatrix:
    	#We create space for the registers (1) we are going to use as counters to store their initial value and to store $ra
        subu $sp $sp 16
    	#Counter to control the element you are in (address)
        sw $s0 12($sp)
        #Counter to store the address of the last element
        sw $s1 8($sp)
        #Counter to store the element A[i][j]
        sw $s2 4($sp)
        #Adress $ra
        sw $ra ($sp)
        
        blez $a1 badendmat #Can't continue if M = 0
        blez $a2 badendmat #Can't continue if N = 0
        #Calculate M-1
        sub $t0 $a1 1
        bgt $a3 $t0 badendmat #Can't continue if i > M-1
        #Calculate N-1 
        sub $t0 $a2 1
        lw $t1 16($sp)
        bgt $t1 $t0 badendmat #Can't continue if j > N-1
        
        #Calculate the address of the last element (A + 4*M*N - 4)
        #4*M*N - 4
        li $t0 4
        mul $t0 $t0 $a1
        mul $t0 $t0 $a2
        sub $t0 $t0 4
      	#A + 4*M*N - 4
        add $s1 $a0 $t0
        
        #Set the initial value of $s0 (same as A as it is the beginning of the matrix)
        move $s0 $a0
        
        #Obtain the value of A[i][j] (A + 4*N*i + 4*j)
        #4*N*i
        li $t0 4
        mul $t0 $t0 $a2
        mul $t0 $t0 $a3
      	#A + 4*M*N + 4*j
        li $t2 4
        mul $t2 $t2 $t1
        add $s2 $t0 $t2
        add $s2 $s2 $a0
        lw $s2 ($s2)

    
    loopmodify:
        
        #If the addres stored in $s0 is bigger than the one of the last element it finishes
        bgt $s0 $s1 goodendmat
        
        #Obtain the number you are in
        lw $t0 ($s0)
        
        #First check if the number is NaN
        #To do this we first isolate the exponent by shifting one bit to the left (to eliminate the sign) and 24 bits to the right (to eliminate the mantissa)
        sll $t0 $t0 1
        srl $t0 $t0 24
        
        #If the value of $t0 has changed and it is not 0 now we continue with the next itineration
        beq $t0 0x000000ff checknan
        beq $t0 0x00000000 checknormalized
        
        j continue
        
	checknan:        
    	#Now we need to isolate the mantissa
        #Obtain the number you are in again
        lw $t0 ($s0)
        sll $t0 $t0 9
        #Check if the mantissa is different from 0 using AND
        andi $t0 $t0 0x730c3df0
        #If $t0 is now 0 this means that the number is 0 so it is not a NaN
        beq $t0 0x00000000 continue
        #If there is a 1 in $t0 the number is a NaN and it changes the value to 0
        #Change number
        li $t0 0
        sw $t0 ($s0)
        j continue
        
    checknormalized:
    	#Now we need to isolate the mantissa
        #Obtain the number you are in again
        lw $t0 ($s0)
        sll $t0 $t0 9
        #Check if the mantissa is different from 0 using AND
        andi $t0 $t0 0x730c3de7
                
    	#If $t0 is now 0 this means that the number is infinite so it is a normalized number
        beq $t0 0x00000000 continue

        #If there is a 1 in $t0 the number is not normalized and it changes the value by A[i][j]
        #Change number
        sw $s2 ($s0)
        j continue
        
	continue:
    	#We go to the next number
        addi $s0 $s0 4
        j loopmodify
   	
    #The function returns a -1 if there was an error
    badendmat:
    	li $v0 -1
        j finish
    
    #The function returns a 0 if the changes were successful
    goodendmat:
    	li $v0 0
	
    #Leave the function
	finish:
    	#Restore values of the $s registers
        lw $s0 12($sp)
        lw $s1 8($sp)
        lw $s2 4($sp)
        addi $sp $sp 16
    	jr $ra
