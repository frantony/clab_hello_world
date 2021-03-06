/*
   Программа вывода строки через последовательный интерфейс.
   Признак конца строки --- символ с кодом 0.
   vim: sw=8:et:ai
*/

#include "regdef.h"

/* адрес начала блока регистров посл. интерфейса */
#define UART_BASE       0xbff70000
/* смещение регистра передачи данных посл. интерфейса (THR) */
#define UART_TX         0x0

        /* запретить ассемблеру переставлять инструкции с целью оптимизации */
        .set noreorder
        /* поместим идущие ниже команды в сегмент text */
        .text
        /* метка _start глобальная (будет использована компоновщиком) */
        .globl _start

_start:
        /* будем использовать t0 в качестве указателя текущего символа */
        la     t0, hello_world_message  /* загрузить в t0
                                           адрес выводимой строки */

        la     t1, UART_BASE            /* загрузить в t1
                                           адрес начала блока
                                           регистров посл. интерфейса */

outs0:  lbu    t3, 0(t0)                /* получить в t3 очередной символ */

        addi   t0, t0, 1                /* перейдём к следующему символу */
        beqz   t3, end                  /* если t3 == 0, то к end */
        nop                             /* слот задержки */

        sb     t3, UART_TX(t1)          /* записать в регистр данных
                                           посл. интерфейса содержимое a0 */

        j      outs0                    /* перейти к outs0 */
        nop                             /* слот задержки */

end:
        wait                            /* остановить процессор */

hello_world_message:                    /* выводимый текст */
        .ascii  "Hello, world!"         /*   текст сообщения */
        .byte   13,10                   /*   перевод строки */
        .byte   0                       /*   признак конца сообщения */
