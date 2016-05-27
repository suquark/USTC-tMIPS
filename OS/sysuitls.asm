.macro print_int (%x)
	li $v0, 1
	add $a0, $zero, %x
	syscall
.end_macro
	
#print_int ($s0)
#print_int (10)
	
# Printing a string (macro will first assign a label to its parameter in data segment then print it):
.macro print_str (%str)
.data
myLabel: .asciiz %str
.text
li $v0, 4
la $a0, myLabel
syscall
.end_macro

.macro printd (%str,%x)
.data
myLabel: .asciiz %str
.text
li $v0, 4
la $a0, myLabel
syscall
.end_macro

#print an integer
.macro body()
print_int $t0
print_str "\n"
.end_macro
	
#printing 1 to 10:
#for ($t0, 1, 10, body)
#The for macro has 4 parameters. %regIterator should be the name of a register which iterates from %from to %to and in each iteration %bodyMacroName will be expanded and run. Arguments for %from and %to can be either a register name or an immediate value, and %bodyMacroName should be name of a macro that has no parameters.
#Macro source line numbers
#For purpose of error messaging and Text Segment display, MARS attempts to display line numbers for both the definition and use of the pertinent macro statement. If an error message shows the line number in the form "X->Y" (e.g. "20->4"), then X is the line number in the expansion (use) where the error was detected and Y is the line number in the macro definition. In the Text Segment display of source code, the macro definition line number will be displayed within brackets, e.g. "<4>", at the point of expansion. Line numbers should correspond to the numbers you would see in the text editor.
