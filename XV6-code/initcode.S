# Initial process execs /init.
# This code runs in user space.

#include "syscall.h"
#include "traps.h"


# exec(init, argv)
.globl start
start:
  # 这是第一个系统调用exec
  # 先将所需的参数压栈
  pushl $argv
  pushl $init
  #0让这个手动构建的系统调用看起来就像普通的系统调用一样
  pushl $0  // where caller pc would be
  # 在eax存入系统调用号，这里是sys_exec
  #如果运行正常的话，exec不会返回：它会运行名为$init的程序，
  #$init是一个以空字符结尾的字符串，即 /init
  movl $SYS_exec, %eax
  int $T_SYSCALL

# for(;;) exit();
#如果 exec`失败并且返回了，
#initcode会不断调用一个不会返回的系统调用exit
exit:
  movl $SYS_exit, %eax
  int $T_SYSCALL
  jmp exit

# char init[] = "/init\0";
init:
  .string "/init\0"

# char *argv[] = { init, 0 };
.p2align 2
argv:
  .long init
  .long 0

