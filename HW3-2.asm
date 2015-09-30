#     When Harry Met Sally
#
#
# This program finds the earliest point at which Harry and Sally lived in the
# same city.
#
#  required output register usage:
#  $2: earliest year in same city
#
# 9/23/15				John Pratt

.data
Harry:  .alloc  10                     # allocate static space for 5 moves
Sally:  .alloc  10                     # allocate static space for 5 moves

.text

WhenMet:	addi $1, $0, Harry       # set memory base
        	swi  586                 # create timelines and store them

              add  $2, $0, $0          # temp
              # add  $3, $0, $0        # Harry's city and upperbound               O1
              # add  $4, $0, $0        # Sally's city and Upperbound               O2
              addi $6, $0, -4          # Harry's loop counter
              # addi $7, $0, -4        # Sally's loop counter                      O3
              add  $8, $0, $0          # Register for logicals

Loop:         addi $6, $6, 8           # increment Harry's counter by "2"
              addi $7, $0, -4          # puts Sallycounter back to "-1"

SubLoop:      addi $7, $7, 8           # $7 = $7 + "2"
              lw   $3, Harry($6)       # $3 = Harry city
              lw   $4, Sally($7)       # $4 = Sally city   
              bne  $3, $4, SubLoopEnd  # $3 != $4, do SubLoopEnd if so
              addi $3, $0, 36          # if the cities matched, bound years get checked
              beq  $7, $3, SallyUpper  # Set's Sally's Upperbound
              addi $1, $7, 4           # $1 = $7 + "1"
              lw   $4, Sally($1)       # $4 = Sally("i+1")
              j    next2

SallyUpper:   addi $4, $0, 2015        # if our counter reached the end of Sally's timeline, upper year is 2015

next2:        beq  $6, $3, HarryUpper  # Sets Harry's Upperbound
              addi $1, $6, 4
              lw   $3, Harry($1)
              j    next1

HarryUpper:   addi $3, $0, 2015        # if our counter reached the end of Harry's timeline, upper year is 2015

next1:        addi $1, $6, -4         
              lw   $2, Harry($1)       # Store the city into $2
              slt  $8, $2, $4
              beq  $8, $0, SubLoopEnd
              addi $1, $7, -4
              lw   $2, Sally($1)
              slt  $8, $2, $3
              beq  $8, $0, SubLoopEnd  # which year is greater?
              lw   $2, Sally($1)
              addi $1, $6, -4
              lw   $4, Harry($1)
              slt  $8, $2, $4
              beq  $8, $0, Year
              add  $2, $0, $4
              j    Exit

Year:         add  $2, $0, $2
              j    Exit

SubLoopEnd:   slti $8, $7, 29
              bne  $8, $0, SubLoop

MainLoopEnd:  slti $8, $6, 29
              bne  $8, $0, Loop

Exit:         slti $8, $4, 1986
              bne  $8, $0, FixAns
              j    Return

FixAns:       addi $2, $0, 0          # if $4 < 1986, they never met so we need to fix $2



            
Return:       swi 587		        # give answer
              jr  $31                 # return to caller
