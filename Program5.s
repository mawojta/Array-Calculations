###########################################################
#	Program 5
#	
#	Name: Michelle Wojta
#	Date: 11/21/2018
#	
#	Program Description:
#		This program will dynamically allocate an array of data structures 
#	and ask the user to fill it out. It will then print the data structure 
#	into the console and then:
#		- Iterate the array and calculate the sum and average of all items.
#		- Iterate the array and find the item category with minimum value 
#				and the item category with maximum value. 
#	Finally, this program will print out: sum, average, minimum, and maximum value. 
#
#	References:
#		Discussion notes, previous labs, previous programs, D2L downloads,  
#			course textbook, TA - Sia, .edu websites such as one below:
#			http://pages.cs.wisc.edu/~markhill/cs354/Fall2008/notes/MAL.instructions.html
#
###########################################################
#		Register Usage
#	$t0 array base address
#	$t1	array size
#   $f4|$f5   sum
#   $f6|$f7   average
#   $f8|$f9   minimum value
#   $f10|$f11 maximum value
###########################################################
		.data
greetings: 		.asciiz	"Hello!"
sum_tot:		.asciiz	"\n\nTotal: "
mean_ave:		.asciiz	"\nAverage: "
minimum:		.asciiz	"\n\nItem with minimum 'value' is: "
maximum:		.asciiz	"\nItem with maximum 'value' is: "
main_id:		.asciiz	"\n\tID: "
main_price:		.asciiz	"  Price: "
main_count:		.asciiz	"  Count: "
array_pointer:  .word 	0	     	#holds address of multi-dimensional dynamic array pointer (address)
array_height:   .word 	0   	 	#holds height (length) of multi-dimensional dynamic array (value)
array_sum:		.word	0
array_ave:		.word	0
###########################################################
		.text
main:
	li $v0, 4
	la $a0, greetings
	syscall	
	
####allocate_structure
	addi $sp, $sp, -4				#$sp <- $sp - 4 (1 word)
	sw $ra, 0($sp)					#stack[0] <- $ra (backup)

	addi $sp, $sp, -8				#$sp <- $sp - 8 (2 words: 0 IN, 2 OUT)
	
	jal allocate_structure			#goes to subprogram to create array
	
	lw $t0, 0($sp)					#$t0 <- base address
	lw $t1, 4($sp)					#$t1 <- array length
	addi $sp, $sp, 8				#$sp <- $sp + 8 (2 words)

	lw $ra, 0($sp)					#$ra <- return address (restore)
	addi $sp, $sp, 4				#$sp <- $sp + 4 (1 words)
	
	la $t9, array_pointer			#load array_pointer into $t9
	sw $t0, 0($t9)					#stores array base address into static memory
	
	la $t9, array_height			#load array_height into $t9
	sw $t1, 0($t9)					#stores array length into static memory
	
####read_structure
	addi $sp, $sp, -4				#$sp <- $sp - 4 (1 word)
	sw $ra, 0($sp)					#stack[0] <- $ra (backup)	
	
	addi $sp, $sp, -8				#Backup
	sw $t0, 0($sp)					
	sw $t1, 4($sp)					

	addi $sp, $sp, -8				#$sp <- $sp - 8 (2 words: 2 IN, 0 OUT)
	sw $t0, 0($sp)					#stack[0] <- array base address
	sw $t1, 4($sp)					#stack[4] <- array length
	
	jal read_structure				#goes to subprogram to fill array
	
	addi $sp, $sp, 8				#$sp <- $sp + 8 (2 words)	
	
	lw $t0, 0($sp)					#$t0 <- base address (OUT)
	lw $t1, 4($sp)					#$t1 <- array length (OUT)
	addi $sp, $sp, 8				#$sp <- $sp + 8 (2 words)
	
	lw $ra, 0($sp)					#$ra <- return address (restore)
	addi $sp, $sp, 4				#$sp <- $sp + 4 (1 words)
	
####print_structure
	addi $sp, $sp, -4				#$sp <- $sp - 4 (1 word)
	sw $ra, 0($sp)					#stack[0] <- $ra (backup)

	addi $sp, $sp, -8				#Backup
	sw $t0, 0($sp)					
	sw $t1, 4($sp)					
	
	addi $sp, $sp, -8				#$sp <- $sp - 8 (2 words: 2 IN, 0 OUT)
	sw $t0, 0($sp)					#stack[0] <- array base address
	sw $t1, 4($sp)					#stack[4] <- array length
	
	jal print_structure				#goes to subprogram to print array
	
	addi $sp, $sp, 8				#$sp <- $sp + 8 (2 words)	
	
	lw $t0, 0($sp)					#$t0 <- base address (OUT)
	lw $t1, 4($sp)					#$t1 <- array length (OUT)
	addi $sp, $sp, 8				#$sp <- $sp + 8 (2 words)

	lw $ra, 0($sp)					#$ra <- return address (restore)
	addi $sp, $sp, 4				#$sp <- $sp + 4 (1 word)
	
####sum_average
	addi $sp, $sp, -4				#$sp <- $sp - 4 (1 word)
	sw $ra, 0($sp)					#stack[0] <- $ra (backup)	
	
	addi $sp, $sp, -8				#Backup
	sw $t0, 0($sp)					
	sw $t1, 4($sp)					

	addi $sp, $sp, -24				#$sp <- $sp - 24 (2/2 words/doubles: 2 IN, 2 OUT)
	sw $t0, 0($sp)					#stack[0] <- array base address
	sw $t1, 4($sp)					#stack[4] <- array length
	
	jal sum_average					#goes to subprogram to get sum & average
	
	l.d $f4, 8($sp)					#$f4 <- array sum
	l.d $f6, 16($sp)				#$f6 <- array average
	addi $sp, $sp, 24				#$sp <- $sp + 8 (4 doubles)	
	
	lw $t0, 0($sp)					#$t0 <- base address (OUT)
	lw $t1, 4($sp)					#$t1 <- array length (OUT)
	addi $sp, $sp, 8				#$sp <- $sp + 8 (2 words)
	
	lw $ra, 0($sp)					#$ra <- return address (restore)
	addi $sp, $sp, 4				#$sp <- $sp + 4 (1 words)
	
	la $t9, array_sum				#load array_sum into $t9
	s.d $f4, 0($t9)					#stores array sum into static memory
	
	la $t9, array_ave				#load array_ave into $t9
	s.d $f6, 0($t9)					#stores array average into static memory
	
	li $v0, 4						#displays text
	la $a0, sum_tot
	syscall

	li $v0, 3						#print (Code in $v0 = 3)
	mov.d $f12, $f4					#sum
	syscall	
		
	li $v0, 4						#displays text
	la $a0, mean_ave
	syscall

	li $v0, 3						#print (Code in $v0 = 3)
	mov.d $f12, $f6					#average
	syscall	
	
####get_min_max
	addi $sp, $sp, -4				#$sp <- $sp - 4 (1 word)
	sw $ra, 0($sp)					#stack[0] <- $ra (backup)	
	
	addi $sp, $sp, -8				#Backup
	sw $t0, 0($sp)					
	sw $t1, 4($sp)					

	addi $sp, $sp, -16				#$sp <- $sp - 16 (4 words/doubles: 2 IN, 2 OUT)
	sw $t0, 0($sp)					#stack[0] <- array base address
	sw $t1, 4($sp)					#stack[4] <- array length
	
	jal get_min_max					#goes to subprogram to get min&max
	
	lw $t8, 8($sp)					#$t8  <- min
	lw $t9, 12($sp)					#$t9  <- max
	addi $sp, $sp, 16				#$sp <- $sp + 16 (4 words)	
	
	lw $t0, 0($sp)					#$t0 <- base address (OUT)
	lw $t1, 4($sp)					#$t1 <- array length (OUT)
	addi $sp, $sp, 8				#$sp <- $sp + 8 (2 words)
	
	lw $ra, 0($sp)					#$ra <- return address (restore)
	addi $sp, $sp, 4				#$sp <- $sp + 4 (1 words)
	
	li $v0, 4						#displays text
	la $a0, minimum
	syscall

	li $v0, 4						#id text
	la $a0, main_id
	syscall
	
	li $v0, 1
	lw $a0, 0($t8)					#print int 
	syscall
	
	li $v0, 4						#price text
	la $a0, main_price
	syscall
	
	li $v0, 3						#print (Code in $v0 = 3)
	l.d $f12, 4($t8)				#loads element @index $t8
	syscall
	
	li $v0, 4						#count text
	la $a0, main_count
	syscall
	
	li $v0, 1
	lw $a0, 12($t8)					#print int
	syscall
	
	li $v0, 4						#displays text
	la $a0, maximum
	syscall

	li $v0, 4						#id text
	la $a0, main_id
	syscall
	
	li $v0, 1
	lw $a0, 0($t9)					#print int 
	syscall
	
	li $v0, 4						#price text
	la $a0, main_price
	syscall
	
	li $v0, 3						#print (Code in $v0 = 3)
	l.d $f12, 4($t9)					#loads element @index $t8
	syscall
	
	li $v0, 4						#count text
	la $a0, main_count
	syscall
	
	li $v0, 1
	lw $a0, 12($t9)					#print int
	syscall
	
exit:
	li $v0, 10						#End Program
	syscall
	
###########################################################
###########################################################
#	allocate_structure
#
#	This subprogram has 0 arguments IN and 2 arguments OUT:
#		-	array base address
#		-	array length
#
#	This subprogram will dynamically allocate an array of data structures.
#	Design:   [itemID(int), intemPrice(double), itemCount(int)]
###########################################################
#		Arguments In and Out of subprogram
#	$sp+0 array base address
#	$sp+4 array size
#	$sp+8
#	$sp+12
###########################################################
#		Register Usage
#	$t0	
#	$t1	structure height (size)
#	$t2	# of data structure columns == 3
#	$t3	Temporary: $t1*$t2 == (# of data structure columns)*(# of rows) 
###########################################################
		.data
length_prompt:	.asciiz	"\nPlease enter an array length (or data structure size): "
length_error:	.asciiz	"Error! Size must be > 0!\n"
###########################################################
		.text
allocate_structure:
	li $t2, 3						#$t2 <- array width

create_structure:
	li $v0, 4
	la $a0, length_prompt
	syscall	
	
	li $v0, 5
	syscall
	
	bgtz $v0, leave_allocate

	li $v0, 4
	la $a0, length_error
	syscall
	
	b create_structure
	
leave_allocate:
	move $t1, $v0					#$t1 <- array length
	sw $t1, 4($sp)
	
	li $v0, 9                       #$v0 <- base address of dynamic array
	mul $t3, $t1, $t2
	sll $a0, $t3, 4					#$a0 <- input length * 2^4 (16 bytes (2ints*4bytes + double*8bytes))
	syscall

	sw $v0, 0($sp)

	jr $ra							#return to calling location
	
###########################################################
###########################################################
#	read_structure 
#
#	This subprogram has 2 arguments IN and 0 arguments OUT:
#		-	array base address
#		-	array length
#
#	This subprogram will ask user to input elements for entire array
#	Inputs are double-precision.
#	Note: element = memory[(array base address) + 2^4 * (array width * row index)]
###########################################################
#		Arguments In and Out of subprogram
#	$sp+0 array base address
#	$sp+4 array length
#	$sp+8
#	$sp+12
###########################################################
#		Register Usage
#   $t0         Holds array index address
#   $t1         Holds array length/loop countdown
#	$t2			# of data structure columns == 3
#	$t3			row pointer
#   $f0|$f1     Holds array entry (double)
###########################################################
		.data
element_id:		.asciiz	"\nEnter item ID: "
element_price:	.asciiz	"Enter item price: "
element_count:	.asciiz	"Enter item count: "
###########################################################
		.text
read_structure:
	lw $t0, 0($sp)					#$t0 <- base address
	lw $t1, 4($sp)					#$t1 <- array length
	li $t2, 3						#$t1 <- array width
	li $t3, 0						#$t1 <- row pointer

get_elements:
	beq $t3, $t1, element_end
	
	mul $t5, $t3, $t2
	sll $t5, $t5, 4
	add $t5, $t0, $t5

	li $v0, 4						#prompt user for array element
	la $a0, element_id
	syscall
	
	li $v0, 5						#user input
	syscall
	
	sw $v0, 0($t5)
	
	li $v0, 4						#prompt user for array element
	la $a0, element_price
	syscall
	
	li $v0, 7						#user input
	syscall
	
	s.d $f0, 4($t5)					#read
	
	li $v0, 4						#prompt user for array element
	la $a0, element_count
	syscall
	
	li $v0, 5						#user input
	syscall
	
	sw $v0, 12($t5)
	
	addi $t3, $t3, 1
	
	b get_elements					#loops back to get_elements until row is full

element_end:
	jr $ra							#return to calling location
	
###########################################################
###########################################################
#	print_structure
#
#	This subprogram will take 2 arguments IN and 0 arguments OUT:
#		-	array length
#		-	array base address
#
#	This subprogram prints out content of each element.
#	Design:   ID: item1id	Price: item1price	Count: item1count
#	Note: element = memory[(array base address) + 2^4 * (array width * row index)]
##########################################################
#		Arguments In and Out of subprogram
#	$sp+0 base array length
#	$sp+4 array base address
#	$sp+8
#	$sp+12
###########################################################
#		Register Usage
#	$t0 array length
#	$t1 array base address
#   $f12|$f13   Holds array value
###########################################################
		.data
data_table:		.asciiz	"\nData Table: "
data_id:		.asciiz	"\n\tID: "
data_price:		.asciiz	"  Price: "
data_count:		.asciiz	"  Count: "
###########################################################
		.text
print_structure:
	lw $t0, 0($sp)					#$t0 <- base address
	lw $t1, 4($sp)					#$t1 <- array length
	li $t2, 3						#$t1 <- array width
	li $t3, 0						#$t1 <- row pointer      
	
	li $v0, 4						#table text
	la $a0, data_table
	syscall

print_elements:
	beq $t3, $t1, print_end
	
	mul $t5, $t3, $t2
	sll $t5, $t5, 4
	add $t5, $t0, $t5

	li $v0, 4						#id text
	la $a0, data_id
	syscall
	
	li $v0, 1
	lw $a0, 0($t5)					#print int 
	syscall
	
	li $v0, 4						#price text
	la $a0, data_price
	syscall
	
	li $v0, 3						#print (Code in $v0 = 3)
	l.d $f12, 4($t5)				#loads element @index $t5
	syscall
	
	li $v0, 4						#count text
	la $a0, data_count
	syscall
		
	li $v0, 1
	lw $a0, 12($t5)					#print int
	syscall
	
	addi $t3, $t3, 1
	
	b print_elements				#loops back to get_elements until row is full

print_end:
	jr $ra							#return to calling location
	
###########################################################
###########################################################
#	sum_average
#
#	This subprogram will take 2 arguments IN:
#		-	array length
#		-	array base address
#	 and 2 arguments OUT:
#		-	sum, double-precision
#		-	average, double-precision
#
#	This subprogram calculates the double-precision sum and average.
#	Note: Total Item Value = (price * count)
#	Note: Average = (total value of all items / total count of all items)
#	Note: element = memory[(array base address) + 4 bytes + 2^4 * (array width * row index)]
#	Note: additional 4 bytes above = to retrieve price 1st we always start @ element: (1, row index)
##########################################################
#		Arguments In and Out of subprogram
#	$sp+0 array length
#	$sp+4 array base address
#	$sp+8 sum (OUT)
#	$sp+12 average (OUT)
###########################################################
#		Register Usage
#	$t0 array base address 
#	$t1 array length
#	$t9 Temporary: count (int)
#   $f4|$f5 array sum
#   $f6|$f7 array average
#   $f8|$f9 Temporary: count (double)
#   $f10|$f11 Total count of all items (double)
#   $f12|$f13   Temporary: price | price*count
###########################################################
		.data
###########################################################
		.text
sum_average:	
	lw $t0, 0($sp)					#$t0 <- array base address
	lw $t1, 4($sp)					#$t1 <- array length
	li $t2, 3						#$t2 <- array width
	li $t3, 0						#$t3 <- row pointer
	li.d $f4, 0.0					#initialize sum to 0
	li.d $f10, 0.0					#initialize to zero = total count of all items
	
get_sum:
	beq $t3, $t1, leave_sum
	
	mul $t5, $t3, $t2
	sll $t5, $t5, 4
	addi $t5, $t5, 4
	add $t5, $t5, $t0

	l.d $f12, 0($t5)				#loads price @index $t5
	lw $t9, 8($t5)					#loads next element, count, @index $t5
	
	mtc1 $t9, $f8					#count to CP1
	cvt.d.w $f8, $f8				#count ==> int to double
	
	mul.d $f12, $f12, $f8			#(price of item) * (count of item)
	
	add.d $f4, $f4, $f12			#sum += (price * count)
	add.d $f10, $f10, $f8			#(Total count of all items) += count of item

	addi $t3, $t3, 1
	
	b get_sum						#keep looping until through all elements

leave_sum:
	div.d $f6, $f4, $f10			#average = sum / (Total count of all items) 
	
	s.d $f4, 8($sp)					#stack[8]  <- sum of the array (OUT)
	s.d $f6, 16($sp)				#stack[16] <- average of the array (OUT)

	jr $ra							#return to calling location
	
###########################################################
###########################################################
#	get_min_max
#
#	This subprogram will take 2 arguments IN:
#		-	array length
#		-	array base address
#	 and 2 arguments OUT:
#		-	minimum, double-precision
#		-	maximum, double-precision
#
#	This subprogram will iterate the array and find the minimum value and maximum value.
#	Note: minimum = (price*count)min
#	Note: maximum = (price*count)max
##########################################################
#		Arguments In and Out of subprogram
#	$sp+0 array base address
#	$sp+4 array length
#	$sp+8 pointer to minimum value (OUT)
#	$sp+12 pointer to max value (OUT)
###########################################################
#		Register Usage
#	$t0 array base address 
#	$t1 array length
#	$t7 Temporary: count (int)
#	$t8 pointer to min data 
#	$t9 pointer to max data 
#   $f4|$f5 minimum value
#   $f6|$f7 maximum value
#   $f8|$f9 Temporary: count (double)
#   $f12|$f13   Temporary: price | price*count
###########################################################
		.data
###########################################################
		.text
get_min_max:	
	lw $t0, 0($sp)					#$t0 <- array base address
	lw $t1, 4($sp)					#$t1 <- array length
	li $t2, 3						#$t2 <- array width
	li $t3, 0						#$t3 <- row pointer
	
	move $t5, $t0					#$t5 <- array base address to initialize min&max
	addi $t5, $t5, 4

	l.d $f12, 0($t5)				#loads price @index $t5
	lw $t7, 8($t5)					#loads next element, count, @index $t5
	
	mtc1 $t7, $f8					#count to CP1
	cvt.d.w $f8, $f8				#count ==> int to double
	
	mul.d $f12, $f12, $f8			#(price of item) * (count of item)
	
	mov.d $f4, $f12					#initialize min == 1st array element
	mov.d $f6, $f12					#initialize max == 1st array element
	
min_max_element:
	beq $t3, $t1, leave_mme
	
	mul $t5, $t3, $t2
	sll $t5, $t5, 4
	add $t5, $t5, $t0

	addi $t3, $t3, 1
	
	l.d $f12, 4($t5)				#loads price @index $t5
	lw $t7, 12($t5)					#loads next element, count, @index $t5
	
	mtc1 $t7, $f8					#count to CP1
	cvt.d.w $f8, $f8				#count ==> int to double
	
	mul.d $f12, $f12, $f8			#(price of item) * (count of item)
	
	c.lt.d $f4, $f12				#Check: $f4 < $f12
	bc1f set_min					#$f12 < $f4 ----> update min
	
	c.le.d $f12, $f6				#Check: $f12 <= $f6
	bc1f set_max					# $f6 < $f12 ----> update max
	
	b min_max_element				#keep looping until through all elements
	
set_min:
	mov.d $f4, $f12					#update min: $f4 = $f12
	move $t8, $t5					#update min: $t8 = $t5 == pointer to min data 
	b min_max_element

set_max:
	mov.d $f6, $f12					#update max: $f6 = $f12
	move $t9, $t5					#update max: $t9 = $t5 == pointer to max data
	b min_max_element

leave_mme:	
	sw $t8, 8($sp)					#stack[8]  <-  pointer to min data (OUT)
	sw $t9, 12($sp)					#stack[12] <-  pointer to max data (OUT)

	jr $ra							#return to calling location
	
###########################################################