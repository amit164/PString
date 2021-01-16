#   323784298   Amit    Sharabi

    .section	.rodata
	.align 8

	format_print_string_len:            .string	"first pstring length: %d, second pstring length: %d\n"
	format_print_string_replace_chars:  .string	"old char: %c, new char: %c, first string: %s, second string: %s\n"
	foramt_print_string_len_and_string: .string	"length: %d, string: %s\n"
	format_print_comapare:              .string	"compare result: %d\n"
    format_print_invalid:	            .string	"invalid option!\n"
    format:                             .string "string: %s\n"

    format_get_char:	.string	" %c %c"
  	format_get_int: 	.string	" %d "




.cases:
    .quad   .L560       # case 50 or 60
    .quad   .default    # case 51 (default)
    .quad   .L52        # case 52
    .quad   .L53        # case 53
    .quad   .L54        # case 54
    .quad   .L55        # case 55
    .quad   .default    # case 56 (default)
    .quad   .default    # case 57 (default)
    .quad   .default    # case 58 (default)
    .quad   .default    # case 59 (default)
    .quad   .L560       # case 60

    .text
.global run_func
    .type run_func, @function
run_func:    
    push    %rbp                # save old rbp
    push    %rbx                # save rbx - callee save
    push    %r12                # save r12 - callee save
    movq    %rsp,       %rbp    # update rbp to a new stack frame

    movq    %rsi,       %rbx    # save pointer to the first pstring to rbx
    movq    %rdx,       %r12    # save pointer to the second pstring to r12

    # check cases
    leaq    -50(%rdi),  %rdi    # sub 50 fron option to calculate in jump table
    cmpq    $0,         %rdi    # checks if option is less then 50
    jl      .default             # if option < 0, jump to default
    cmpq    $10,        %rdi    # checks is the option is 60
    jg      .default
    jmp     *.cases(,%rdi,8)    # jump lable according the jump table

.L560:
    subq    $1,                       %rsp      # make "space" in stack
    movq    %rbx,                     %rdi      # passing the pointer to the first pstring to rdi
    call    pstrlen         
    movb    %al,                     (%rsp)     # save the length of the first pstring in stack (rax contaion the return value of pstrlen)
    movq    %r12,                     %rdi      # passing the pointer to the second pstring to rdi
    call    pstrlen
    subq    $1,                       %rsp      # make "space" in stack
    movb    %al,                      (%rsp)    # save the length of the second pstring on stack

    #   print
    movq    $format_print_string_len,  %rdi    # passsing the format to print to rdi
    movq    $0,                        %rsi
    movb    1(%rsp),                   %sil    # passing the length of the first pstring to rsi
    movzbq  (%rsp),                    %rdx    # passing the length of the second pstring to rdx
    movq    $0,                        %rax
    call    printf

    jmp .return

.L52:
    subq    $1,                 %rsp     # make "space" in stack
    movq    $format_get_char,   %rdi     # passsing the format to scanf to rdi             
    movq    %rsp,               %rsi     # passing the address of a place in the stack to rsi
    leaq    -1(%rsp),           %rsp     # allocate a place to save ths second char
    movq    %rsp,               %rdx     # passing adress on stack to save the second char            
    movq    $0,                 %rax
    call    scanf

    #   replaceChar for first pstring
    movq    %rbx,               %rdi    # passing the pointer to the first pstring to rdi
    movzbq  1(%rsp),            %rsi    # passing old char to rsi
    movzbq  (%rsp),             %rdx    # passing mew char to rdx
    call    replaceChar
    
    movq    %rax,               %rbx    # save the pointer to the new first char in rbx
    
    #   replaceChar for second pstring
    movq    %r12,               %rdi    # passing the pointer to the first pstring to rdi
    movzbq  1(%rsp),            %rsi    # passing old char to rsi
    movzbq  (%rsp),             %rdx    # passing mew char to rdx
    call    replaceChar
    
    movq    %rax,               %r12    # save the pointer to the new first char in rbx 

    #   print
    movq    $format_print_string_replace_chars, %rdi    # passsing the format to print to rdi
    movq    1(%rsp),                            %rsi    # passing old char to rsi
    movq    (%rsp),                             %rdx    # passing mew char to rdx
    leaq    1(%rbx),                            %rcx    # passing the pointer to the first pstring to rcx    
    leaq    1(%r12),                            %r8     # passing the pointer to the second pstring to r8
    movq    $0,                                 %rax
    call printf

    jmp .return

.L53:
    movq    $format_get_int,                    %rdi     # passsing the format to scanf to rdi
    subq    $4,                                 %rsp             
    movq    %rsp,                               %rsi     # passing the address of a place in the stack to rsi
    movq    $0,                                 %rax
    call    scanf

    subq    $4,                                 %rsp     # make "space" in stack
    movq    $format_get_int,                    %rdi     # passsing the format to scanf to rdi
    movq    %rsp,                               %rsi     # passing the address of a place in the stack to rsi
    movq    $0,                                 %rax
    call    scanf

    movq    %rbx,       %rdi    # passing the pointer to the first pstring to rdi - to be the first argument for pstrifcpy
    movq    %r12,       %rsi    # passing the pointer to the second pstring to rsi - to be the second argument for pstrifcpy
    movq    $0,         %rdx
    movq    $0,         %rcx
    movl    4(%rsp),    %edx    # passing the start index to rdx - to be the third argument for pstrijcpy
    movl    (%rsp),     %ecx    # passing the end index to rcx - to be the fourth argument for pstrijcpy
    call    pstrijcpy

    movq    %rax,       %rbx    # save pointer to the new pstring

    jmp .print_len_and_string   # print len and string 


.L54:
    movq    %rbx,       %rdi    # passing pointer to the first pstring to rdi
    call    swapCase

    movq    %rax,       %rbx    # save the new pointer to the first pstring

    movq    %r12,       %rdi    # passing pointer to the second pstring to rdi
    call    swapCase

    movq    %rax,       %r12    # save the new pointer to the first pstring

    jmp .print_len_and_string   # print len and string 


.L55:
    movq    $format_get_int,    %rdi     # passsing the format to scanf to rdi 
    subq    $4,                 %rsp            
    movq    %rsp,               %rsi     # passing the address of a place in the stack to rsi
    movq    $0,                 %rax
    call    scanf

    subq    $4,                 %rsp     # make "space" in stack
    movq    $format_get_int,    %rdi     # passsing the format to scanf to rdi
    movq    %rsp,               %rsi     # passing the address of a place in the stack to rsi
    movq    $0,                 %rax
    call    scanf

    movq    $0, %rdx
    movq    $0, %rcx

    movq    %rbx,               %rdi    # passing pointer to the first pstring to rdi
    movq    %r12,               %rsi    # passing pointer to the second pstring to rsi
    movl    4(%rsp),            %edx    # passing the start index to rdx
    movl    (%rsp),             %ecx    # passing the end index to rcx
    call    pstrijcmp
    
    #   print
    movq    $format_print_comapare, %rdi    # passing format to print
    movq    %rax,                   %rsi    # passing the compare result to rsi
    movq    $0,                     %rax
    call    printf

    jmp .return


.default:
    movq    $format_print_invalid,  %rdi    # passing format to print to rdi
    movq    $0,                     %rax
    call    printf

    jmp .return


.print_len_and_string:

    #   print first pstring
    movq    $foramt_print_string_len_and_string,    %rdi   # passing format to print to rdi
    movzbq  0(%rbx),                                %rsi   # passing len of the first pstring to rsi
    incq    %rbx
    movq    %rbx,                                   %rdx   # passing the pointer to the first pstring to rdx
    movq    $0,                                     %rax
    call printf

    #   print second pstring
    movq    $foramt_print_string_len_and_string,    %rdi   # passing format to print to rdi
    movzbq  0(%r12),                                %rsi   # passing len of the second pstring to rsi
    incq    %r12
    movq    %r12,                                   %rdx   # passing the pointer to the second pstring to rdx
    movq    $0,                                     %rax
    call printf

    jmp .return

.return:
    movq    %rbp,   %rsp    # updating rsp to be the start of the frame - rbp
    pop     %r12            # recover old r12
    pop     %rbx            # recover old rbx
    pop     %rbp            # recober old rbp
    ret
