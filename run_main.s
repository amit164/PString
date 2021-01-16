#   323784298   Amit    Sharabi

    .section .rodata
format_d:       .string "%hhd"  # string for scanf and printf int
format_string:  .string "%s"    # format for scanf and printf string
empty_string:   .string "\0"    # empty string
format:                             .string "string: %s\n"
format_print_invalid:               .string "invalid option!\n"
    
    .text
    .global run_main
    .type run_main, @function
run_main:
    push    %rbp                        # save old rbp   
    push    %rbx                        # save rbx - calle save
    push    %r12                        # save r12 - calle save
    push    %r13      
    movq    %rsp,           %rbp        # updating rbp

    #   first string
    subq    $1,             %rsp        # allocte space for string size

    movq    $format_d,      %rdi        # passing format for scanf to rdi
    movq    %rsp,           %rsi        # passing adress for rsi
    movq    $0,             %rax
    call    scanf

    movzbq  (%rsp),         %r13        # save first len - n1  

    movb    $0,             (%rsp)      # push '\0' at the end of the pstring
    subq    %r13,           %rsp        # allocate spase

    movq    $format_string, %rdi        # passing format for scanf to rdi
    movq    %rsp,           %rsi        # passing adress for rsi
    movq    $0,             %rax
    call scanf 

    decq    %rsp                        # decreas rsp for the len byte
    movb    %r13b,          (%rsp)      # add the length of the first string to the stack
    movq    %rsp,           %rbx        # rbx hold the pointer to the first pstring 

    #   second string
    subq    $1,              %rsp       # allocte space for string size

    movq    $format_d,       %rdi       # passing format for scanf to rdi
    movq    %rsp,            %rsi       # passing adress for rsi
    movq    $0,              %rax
    call    scanf

    xorq    %r13,            %r13
    movzbq  (%rsp),          %r13       # save first len - n2  

    movb    $0,             (%rsp)      # push '\0' at the end of the pstring
    subq    %r13,           %rsp        # allocate spase


    movq    $format_string, %rdi        # passing format for scanf to rdi
    movq    %rsp,           %rsi        # passing adress for rsi
    movq    $0,             %rax
    call    scanf 

    decq    %rsp
    movb    %r13b,          (%rsp)     # add the length of the first string to the stack
    movq    %rsp,           %r12       # r12 hold the pointer to the second pstring 

    # option in menu
    subq    $1,             %rsp        # allocte space for string size

    movq    $format_d,      %rdi        # passing the format to print to rdi
    movq    %rsp,           %rsi        # passing adress to save the number to rsi
    xorq    %rax,           %rax
    call    scanf

    # call run_func
    movzbq  (%rsp),         %rdi        # passing the option for run_func to rdi
    movq    %rbx,           %rsi        # passing the pointer to the first pstring for run_func to rsi
    movq    %r12,           %rdx        # passing the pointer to the second pstring for run_func to rdx
    movq    $0,             %rax
    call    run_func

    # end function
    movq    %rbp,          %rsp
    pop     %r13
    pop     %r12
    pop     %rbx
    pop     %rbp
    movq    $0,            %rax
    ret
