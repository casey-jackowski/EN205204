#
# Program Name: PrintFloat.s
# Author: Casey Jackowski
# Date: 2/18/2024
# Purpose: To read a float using scanf and print it back out using printf
# Input:
#    - input: The floating point number
# Output:
#    - format: Prints the floating point back to the user
#

.text
.global main

main:
    # Save return to OS on stack (PUSH)
    SUB sp, sp, #4
    STR lr, [sp, #0]

    # Print the prompt for the user
    LDR r0, =prompt
    BL printf

    # Read in the float input
    LDR	r0, =input
    LDR	r1, =float
    BL scanf

    # Copy the float into a single precision register
    LDR	r1, =float
    LDR r1, [r1, #0]
    VMOV s0, r1

    # Convert the value in the single precision register (32 bit) into a double precision register pair (64 bit)
    vcvt.f64.f32 d0, s0
    
    # Print the float using 2 of the 32 bit registers to pass in the 64 bit register pair containing the float
    LDR r0, =format
    VMOV r1, r2, d0
    BL printf
    
    # Return to the OS (POP)
    LDR lr, [sp, #0]
    ADD sp, sp, #4
    MOV pc, lr

.data
    prompt: .asciz "Enter a float: "
    float:  .word 0
    input:  .asciz "%f"
    format: .asciz "Your input was: %f\n"
