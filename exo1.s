calcul:
    // x*x - 2*x*y - y*y
    push %b

    ld [%sp+2], %b      // b<--x

    mul 2, %b           // b<--2x
    mul [%sp+3], %b     // b<--2xy

    ld [%sp+2], %a      // a<--x
    mul %a, %a          // a<--xx
    sub %b, %a          // a<-- xx - 2xy

    ld [%sp+3], %b      // b<--y
    mul %b, %b          // b<--yy
    sub %b, %a          // a<--x*x - 2*x*y - y*y

    pop %b 
    rtn



prodscal:
    // [x, p, b, rtn, v1, v2, n]
    // le registre b va stocker l'iterateur i
    
    push %b
    push 0                   // p
    push 0                   // x
    ld 0, %b                 // b<--0
    jmp for_condition
    

for_condition:
    
    
    ld [%sp+6], %a           // a<--n
    cmp %b, %a               // if i >= n 
    jge end_prodscal

    ld [%sp+4], %a           // a<--adresse de v1   
    add %b, %a               // a<--adresse de v1[i]
    ld [%a], %a              // a<--v1[i]               

    st %a, [%sp]             // x<--v1[i]

    ld [%sp+5], %a           // a<--adresse de v2  
    add %b, %a               // a<--adresse de v2[i]
    ld [%a], %a              // a<--v2[i] 
 
    mul [%sp], %a            // a<--v1[i]*v2[i]
    add [%sp+1],%a           // a<--p + v1[i]*v2[i]
    
    st  %a,[%sp+1]           // p<--a 
    
    //incrementer i
    add 1, %b                // i++
    jmp for_condition

end_prodscal:
    ld [%sp+1] ,%a
    add 2, %sp
    pop %b
    rtn



racine:
    // [r, sup, inf, b, rtn, n]
    push %b
    push 1                   // inf
    ld [%sp+3], %b           // b<--n
    push %b                  // sup         
    ld [%sp+4], %b           
    add 1, %b
    div 2, %b                // b<--r = (inf+sup) / 2
    push %b
    jmp first_loop_condition

first_loop_condition:
    ld [%sp+5], %a           // a<--n
    ld [%sp], %b             // b<--r
    
    mul %b, %b               // b<--r*r
    cmp %b, %a               // if n <= r*r 
    
    jle second_loop_condition
    jmp if_condition

second_loop_condition:
    ld [%sp], %b             // b<--r
    add 1, %b                // b<--(r+1)
    mul %b, %b               // b<--(r+1)*(r+1)
    cmp %b, %a               // if n <= (r+1)*(r+1) 
    jle else_condition
    ld [%sp],%a
    jmp end_racine

if_condition:
    ld [%sp], %b             // b<--r
    st %b, [%sp+1]           // inf = r

    ld [%sp+1], %a           // a<--sup
    ld [%sp+2], %b           // b<--inf
    
    add %b, %a
    div 2, %a
    
    st %a, [%sp]             // r = (inf+sup) / 2
    jmp first_loop_condition

else_condition:
    // if (r+1)*(r+1) <= n
    ld [%sp], %b             // b<--r
    st %b, [%sp+2]           // sup = r
    ld [%sp+1], %a           // a<-- inf
    
    add %b, %a
    div 2, %a                
    
    st %a, [%sp]             // r = (inf+sup) / 2
    jmp first_loop_condition

end_racine:
    add 3, %sp
    pop %b
    rtn














main_calcul:

    reset


main_prodscal:

    reset

main_racine:
    
    reset
