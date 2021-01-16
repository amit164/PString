#   323784298   Amit    Sharabi

    .data
    .align 4

.section .rodata

format_invalid_input:  .string "invalid input!\n"

.text
.global pstrlen
.type pstrlen, @function
pstrlen:
    push    %rbp                # save old rbp
    movq    %rsp,       %rbp    # update rbp

    movzbq  0(%rdi),    %rax    # %rax contains the length

    movq    %rbp,       %rsp    # updating rsp to be the start of the frame - rbp
    pop     %rbp                # recover old rbp
    ret

.global replaceChar
.type replaceChar, @function
replaceChar:
    push	%rbp                            # save old rbp   
    push    %rbx                            # save rbx - calle save
    movq    %rsp,                   %rbp    # upsate rbp

    movq    %rdi,                   %rbx    # save pointer to pstring in %rbx
.Loop:
    cmpb	$0,			            0(%rdi) # check if r13b is 0
    je		.Return
    cmpb	0(%rdi),	            %sil    # check if the char is the old char               
    je		.Change
	jne		.Not_Equal

.Change:
    movb    %dl,                    0(%rdi) # mov new char to the pstring
	
.Not_Equal:
	incq    %rdi                            # increease pointer to pstring 
    jmp     .Loop
        
.Return:
    movq    %rbp,                   %rsp    # back to the old stack frame
	movq    %rbx,                   %rax    # return pointer to the new pstring
    pop     %rbx                            # get old rbx
    pop     %rbp                            # get old rbp
    ret

.global pstrijcpy
.type pstrijcpy, @function
pstrijcpy:
	push    %rbp                            # save old rbp
	push	%rbx							# save old rbx
    movq    %rsp,                   %rbp    # upsate rsp to a new stack frame

    #   %rdi - dest,    %rsi - source,  %rdx - i,   %rcx - j

	pushq    %rdi							# save pointer to dest pstring on stack
	movq	$0,						%rbx

    cmpb    %dl,                   %cl		# if j < i
    jl      .Invalid
	incq	%rcx							# increase j because index dtarts from 0				
    cmpb    $0,                     %dl		# if i is negative
    jl      .Invalid
    cmpb    %cl,                   0(%rdi) 	# if j > len of dest pstring
    jl      .Invalid 
    cmpb    %cl,                   0(%rsi) 	# if j > len of source pstring
    jl      .Invalid
	decq	%rcx						


	incq	%rdi							# len on the first byte
	incq	%rsi							# len on the first byte
    addq    %rdx,                   %rdi    # start going throgh on rdi from index i on dest pstring
    addq    %rdx,                   %rsi    # start going throgh on rsi from index i on source pstring

.For_Loop:
    cmpb	%dl,                   	%cl    # if j < i
    jl		.Finish
    movb    0(%rsi),				%bl		# mov source char to bl
	movb	%bl,					0(%rdi) # mov char from source to dest               
    incq    %rdi                            # increease pointer to dest pstring
    incq    %rsi                            # increease pointer to source pstring
    incq    %rdx                            # increease i 
    jmp     .For_Loop

.Invalid:
    movq    $format_invalid_input,	%rdi    # format to print invalid input
    movq    $0,                     %rax    
    call    printf    
	jmp		.Finish

.Finish:
	popq	%rax							# dest pstring pointer is on stack
    movq    %rbp,                   %rsp    # recover old stack frame
	pop		%rbx
    pop     %rbp                            # recover old rbp
    ret


.global swapCase
.type swapCase, @function
swapCase:
    push	%rbp                            # save old rbp   
    push    %rbx                            # save rbx - calle save
    movq    %rsp,                   %rbp    # upsate rbp

    movq    %rdi,                   %rbx    # save pointer to pstring in %rbx
    incq    %rdi

.Loop2:
    cmpb	$0,			            0(%rdi) # check if r13b is 0
    je		.Return
    cmpb	$65,	                0(%rdi) # check if the char > 'A'              
    jge		.If_Change
	jmp		.Increase

.If_Change:
    cmpb    $91,                    0(%rdi) # check if the char < 'Z'
    jl      .Change_Capital_To_L  
    cmpb    $97,                    0(%rdi) # check if char > 'a'
    jge     .If_Change2
    jmp     .Increase

.If_Change2:
    cmpb    $123,                    0(%rdi) # check if the char < 'z'
    jl     .Change_Letter_To_C  
    jmp     .Increase  

.Change_Capital_To_L:
    addq    $32,                    0(%rdi) # add to Capital letter 
    jmp     .Increase

.Change_Letter_To_C:
    subq    $32,                    0(%rdi) # sub from a letter
	
.Increase:
	incq    %rdi                            # increease pointer to pstring 
    jmp     .Loop2
        
.Done:
    movq    %rbp,                   %rsp    # back to the old stack frame
	movq    %rbx,                   %rax    # return pointer to the new pstring
    pop     %rbx                            # get old rbx
    pop     %rbp                            # get old rbp
    ret


    .global pstrijcmp
.type pstrijcmp, @function
pstrijcmp:
    push    %rbp                            # save old rbp
	push	%rbx							# save old rbx
    push    %r12                            # save old r12
    movq    %rsp,                   %rbp    # upsate rsp to a new stack frame

    #   %rdi - pstr1,    %rsi - pstr2,  %rdx - i,   %rcx - j

	movq	$0,						%rbx    # initialize %rbx
    movq    $0,                     %r12    # initialize %r12
    movq	$0,						%rax    # initialize %rax

    cmpb    %dl,                    %cl		# if j < i
    jl      .Invalid_Input_CMP
	incq	%rcx							# increase j because index dtarts from 0				
    cmpb    $0,                     %dl		# if i is negative
    jl      .Invalid_Input_CMP
    cmpb    %cl,                   0(%rdi) 	# if j > len of pstring1
    jl      .Invalid_Input_CMP 
    cmpb    %cl,                   0(%rsi) 	# if j > len of pstring2
    jl      .Invalid_Input_CMP
	decq	%rcx						


	incq	%rdi							# len on the first byte
	incq	%rsi							# len on the first byte
    addq    %rdx,                   %rdi    # start going throgh on rdi from index i on pstring1
    addq    %rdx,                   %rsi    # start going throgh on rsi from index i on pstring2

.Check_String:
    cmpb	%dl,                   	%cl    # if j < i
    jl		.End_Func
    movb    0(%rdi),				%r12b   # mov pstr1 char to r12b
    movb    0(%rsi),				%bl		# mov pstr2 char to bl
    cmpb    %r12b,                  %bl     # compare char from pstr1 and pstr2
    jl      .Pstr1_Bigger                   # pstr1 > pstr2
    jg      .Pstr2_Bigger                   # pstr2 > pstr1
    incq    %rdi                            # increease pointer to pstring1
    incq    %rsi                            # increease pointer to pstring2
    incq    %rdx                            # increease i 
    jmp     .Check_String

.Pstr1_Bigger:
    movq    $1,                     %rax    # pstr1 is bigger than pstr2 -> return 1
    jmp     .End_Func

.Pstr2_Bigger:
    movq    $-1,                     %rax    # pstr1 is bigger than pstr2 -> return -1
    jmp     .End_Func

.Invalid_Input_CMP:
   	movq    $format_invalid_input,  %rdi    # format to print invalid input
    movq    $0,                     %rax    
    call    printf
	movq	$-2,					%rax	# invalid input -> return compare result -2    
	jmp		.End_Func

.End_Func:	
    movq    %rbp,                   %rsp    # recover old stack frame
    popq    %r12
	pop		%rbx
    pop     %rbp                            # recover old rbp
    ret
