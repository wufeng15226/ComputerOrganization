#数据段
	.data
sign0:
	.asciiz "Letters:"
sign1:
	.asciiz "Numbers:"
sign2:
	.asciiz "String Length: "
sign3:
	.asciiz "Reversed String: "
sign4:
	.asciiz "Retype:\n"
sign5:
	.asciiz "Password Right!\n"
sign6:
	.asciiz "Password Error!\n"
	#以上皆为const string
	
	#输入的第一个字符串
tem1:
	.space 64
	
	#输入的第二个字符串，即输入的答案
tem2:
	.space 64
	
	#反向及删除空格处理后字符串
rst:
	.space 64
	
	#用于存to_string(int)的段,max_int = 99999
ch:
	.space 5			#5*char int	e.g. "54321"
	
	.set noreorder		#与流水线相关的一个设置操作
	
#代码段
	.text
.global main
main:
	la $t0, tem1		#passing argument &tem1
	jal readstr			#cin>>tem1
	nop
	addi $s0 ,$t0, 0	#s0=&tem1
	addi $t0, $s0, 0
	jal strsize			#获取tem1长度
	nop
	addi $s1, $v0, 0	#s1=tem1.size
	add $t0, $s0, $s1
	addi $t0, $t0, -2	#without '\n'
	li $t1, 0			#num_count
	li $t2, 0			#letter_count
	li $t3, ' '	
	li $t4, '9'
	la $s2, rst   		#s2=&rst
	addi $t5, $s2, 0
	li $t6, 0			#i=0
	addi $t8, $s1, -1	#without '\n'
loop:
	lb $t7, 0($t0)		#load in tem1_end
	beq $t7, $t3, mid2	#if is ' ', continue
	nop					#else solve it
	ble $t7, $t4, mid1	#if<='9',is a number
	nop					#else is a alphabet
	add $t2, $t2, 1		#letter_count++
	sb $t7, 0($t5)		#save in rst
	addi $t5, $t5, 1	#ptr_to_rst++
	j mid2
	nop
mid1:
	addi $t1, $t1, 1	#num_count++
	sb $t7, 0($t5)		#save in rst
	addi $t5, $t5, 1	#ptr_to_rst++
mid2:					
	addi $t0, $t0, -1	#ptr_to_tem1_end--
	addi $t6, $t6, 1	#i++
	beq	$t6, $t8, end	#if i==tem1.size-1,break
	nop
	j loop				#else continue
	nop
end:
	li $t4, '\n'
	sb $t4,	0($t5)		#rst.add '\n'
	addi $s3, $t2, 0	#s3=letter_count
	addi $s4, $t1, 0	#s4=num_count
	la $t0, sign0		#cout<<sign0
	jal strsize			
	nop
	jal writestr
	nop
	addi $v0, $s3, 0	#cout<<letter_count
	jal writeint
	nop
	la $t0, sign1		#cout<<sign1
	jal strsize
	nop
	jal writestr
	nop
	addi $v0, $s4, 0	#cout<<num_count
	jal writeint
	nop
	la $t0, sign2		#cout<<sign2
	jal strsize
	nop
	jal writestr		
	nop
	addi $v0, $s1, -1	#s1=tem1.size-1,without'\n',cout<<s1
	jal writeint		
	nop
	la $t0, sign3		#cout<<sign3
	jal strsize
	nop
	jal writestr
	nop
	addi $t0, $s2, 0	#cout<<rst
	jal strsize
	nop
	jal writestr
	nop
	la $t0, sign4		#cout<<sign4
	jal strsize
	nop
	jal writestr
	nop
	la $t0, tem2		#cin>>tem2
	jal readstr			
	nop
	addi $s5, $t0, 0	#s5=&tem2
	addi $t0, $s5, 0
	jal strsize
	nop
	addi $s6, $v0, 0	#s6=tem2.size
	addi $t0, $s2, 0	#t0=&rst
	addi $t1, $s5, 0	#t1=$tem2
	li $t2, 0			#i=0
lloop:
	lb $t3, 0($t0)		#load rst.begin
	lb $t4, 0($t1)		#load tem2.begin
	bne $t3,$t4,eend	#if not equal jump to wrong answer
	nop					#else continue solve
	addi $t0, $t0, 1	#ptr_to_rst++	
	addi $t1, $t1, 1	#ptr_to_tem2++
	addi $t2, $t2, 1	#i++
	bne $t2, $s6, lloop	#if i!=tem2.size continue
	nop					#else go to right answer
	la $t0, sign5		#cout<<sign5,right answer
	jal strsize
	nop
	jal writestr
	nop
	j last
	nop
eend:
	la $t0, sign6		#cout<<sign6,wrong answer
	jal strsize
	nop
	jal writestr
	nop
last:					#exit
	li $v0, 4001
    syscall
	nop

#cin>>(t0),len=64
.global readstr
readstr:
	li $v0, 4003
	li $a0, 0
	addi $a1, $t0, 0
	li $a2, 64
	syscall
	jr $ra
	nop

#cout<<(t0),len=v0,							using v0
.global writestr
writestr:
	addi $t1, $v0, 0
	li $v0, 4004
	li $a0, 1	#first_argument is all 0,which is different in the guide,however it works well
	addi $a1, $t0, 0
	addi $a2, $t1, 0
	syscall
	jr $ra
	nop
	
#(t0).size(),return v0,						using t0,t1,t2,t3
.global strsize
strsize:
	li $v0, 0
loop1:	
	add $t1, $t0, $v0
	lb $t2, 0($t1)		#curr=tem1.at(i)
	li $t3, 0			#t3='\0'
	beq $t2, $t3, end1	#if curr=='\0',break
	nop					#else continue
	addi $v0, 1			#i++
	j loop1
	nop
end1:
	jr	$ra
	nop

#cout<<v0,									using t0,t1,t2,t3
.global writeint
writeint:
	#count the length of int first ,t2 
	addi $t0, $v0, 0
	la $t1, ch
	li $t2, 0
	li $t3, 10
	li $t4, 0
loop2:
	div $t0, $t3	
	mflo $t0			#取商
	addi $t2, 1			#len++
	beq $t0, $t4, end2	#if 商==0, break
	nop					#else continue
	j loop2
	nop
end2:
	add $t1, $t1, $t2	#ptr_to_end_rst
	li $t6, '\n'
	sb $t6, 0($t1)		#save '\n'
loop3:
	div $v0, $t3
	mflo $v0			#商
	mfhi $t5			#余数
	addi $t5, $t5, '0'	#int to char
	addi $t1, $t1, -1	#ptr_to_end_rst--
	sb $t5, 0($t1)		#save 
	beq $v0, $t4, end3	#if 商==0, break
	nop					#else continue
	j loop3
	nop
end3:	
	li $v0, 4004
	li $a0, 1
	addi $a1, $t1, 0
	addi $a2, $t2, 1
	syscall
	jr $ra
	nop