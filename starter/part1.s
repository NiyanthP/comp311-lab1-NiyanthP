.text
.globl part1

part1:
    # Assumptions:
    #   t0 = base address of values
    #   t1 = available temporary
    #   t2 = available temporary
    #   t3 = result
    #
    # result = values[1] + values[3] + 5;
    lw   t1, 4(t0)        # t1 = values[1]   (1 * 4 bytes)
    lw   t2, 12(t0)       # t2 = values[3]   (3 * 4 bytes)
    add  t3, t1, t2       # t3 = values[1] + values[3]
    addi t3, t3, 5        # t3 = t3 + 5       
    ret
    