## 一.分段管理机制
 ```
  1.
  GDT: 全局段描述符表 (每一项 8byte * 8)
  IDT: 中断描述符表(每一项 8byte * 8)
  LDT: 局部段描述符表 (每一项 8byte * 8)
  2.
  GDTR: 记录GDT开始位置(6byte * 8)
  IDTR: 记录IDT开始位置(6byte * 8)
  3.
   - 段描述符 (8byte * 8)
   - 选择子 (16byte,末尾3位表示段类别[全局0与局部1]和特权级),可区分8192个描述符
```

### 1.1段相关概念
1. 段选择子

  |15-3|2|1-0|
  |-|-|-|
  |索引|表指示标识|请求特权级|

  >`索引:`选择GDT或LDT中8192个描述符中的某一个。处理器将索引值乘以8，然后加上GDT或LDT基地址。<br/>
  >`表指示标识TI:`0-GDT,1-IDT<br/>
  >`请求特权级RPL:`0,1,2,3
2. 段描述符

  |31-24|23|22|21|20|19-16|15|14-13|12|11-8|7-0|
  |-|-|-|-|-|-|-|-|-|-|-|
  |基地址31:24|G|G/B|0|AVL|界限19:16|P|DPL|S|类型|基地址23:16|

  |31-16|15-0|
  |-|-|
  |基地址15:0|界限15:0|

   |名称|作用|
  |-|-|
  |段界限|指定段的大小,总共20位长度。<br/>根据G标志位的不同设置，处理器按两种不同的方式解释段界限：G=0,段大小从1B-1MB字节;G=1，段大小从4kB-4GB|
  |基地址|共32位,确定段的第一个字节在4G地址空间的位置。|
  |类型域|指明段或门的类型，确定段的访问权限和增长方向。如何解释这个域，取决于该描述符是应用程序描述符（代码或数据）还是系统描述符。代码、数据和系统段对类型由不同的编码|
  |S|描述符类型,S=0系统描述符,S=1代码、数据段描述符|
  |DPL|描述符特权级，指明段的特权级|
  |P|指明段是否在内存中（1表示在内存中，0表示不在内存中）|
  |D/B|根据段描述符所指的是可执行代码段、向下扩展的数据段还是堆栈段，这个标志有不同的功能。（对32位的代码或数据段，这个标志位总是被置为1；而16位的代码或数据段，总是被置为0）|
  |G|粒度标志，G=0以字节为单位扩展,G=1以4KB为单位扩展|

### 1.2 系统描述符类型
当段描述符的S位被置0时，则描述符位系统描述符.
- 局部描述符表段描述符
- 任务状态段描述符
- 调用门描述符
- 中断门描述符
- 陷阱门描述符
- 任务门描述符
|类型|11|10|9|8|说明|
|-|-|-|-|-|-|
|0|0|0|0|0|保留|
|1|0|0|0|1|16位TSS(可用)|
|2|0|0|1|0|LDT|
|3|0|0|1|1|16位TSS(忙)|
|4|0|1|0|0|16位调用门|
|5|0|1|0|1|任务门|
|6|0|1|1|0|16位中断门|
|7|0|1|1|1|16位陷阱门|
|8|1|0|0|0|保留|
|9|1|0|0|1|32位TSS(可用)|
|10|1|0|1|0|保留|
|11|1|0|1|1|32位TSS(忙)|
|12|1|1|0|0|32位调用门|
|13|1|1|0|1|保留|
|14|1|1|1|0|32位中断门|
|15|1|1|1|1|32位陷阱门|

### 1.3 内存管理寄存器:
1. GDTR
|47-16|15-0|
|-|-|
|32位线性基地址|16位表界限|
>`基地址:`是指GDT的第一个字节的线性地址</br>
>`表限长:`是指表中的字节个数<br/>
>LGDT和SGDT指令分别用来装载和保存GDTR寄存器<br/>
>上电或复位时，基地址缺省为0，表界限缺省为FFFFH
2. IDTR
|47-16|15-0|
|-|-|
|32位线性基地址|16位表界限|
>`基地址:`是指GDT的第一个字节的线性地址</br>
>`表限长:`是指表中的字节个数<br/>
>LIDT和SIDT指令分别用来装载和保存IDTR寄存器<br/>
>上电或复位时，基地址缺省为0，表界限缺省为FFFFH
3. TR
|15-0||
|-|-|
|段选择子|32位线性基地址|段界限|属性|
>LTR和STR指令专门用来装载和保存TR段选择子那部分。
>上电或复位时，基地址缺省为0，表界限缺省为FFFFH
4. LDTR
|15-0||
|-|-|
|段选择子|32位线性基地址|段界限|属性|
>LLDT和SLDT指令专门用来装载和保存LDTR段选择子那部分。
>上电或复位时，基地址缺省为0，表界限缺省为FFFFH
5. 控制寄存器(CR0,CR1,CR2,CR3,CR4)
|名称|作用|
|-|-|
|CR0|包含系统控制标志，这些标志控制着系统的运行模式和状态|
|CR1|保留|
|CR2|包含页故障的线性地址（引起页故障的线性地址）|
|CR3|包含页目录表的物理基地址和二个标志(PCD和PWT),页目录表的基地址由高20位确定，低12位是0，所以页目录表的地址必须是页边界对齐的（4k字节）.<br/>PCD和PWT标志控制着页目录表在处理器内部数据高速缓存中的高速缓存（但不控制页目录信息的TLB高速缓存）。|
|CR4|包含一组标志，这些标志启用IA-32系统架构上的几个扩展，支持操作系统或管理程序支持处理器的特殊功能。|

**控制寄存器可用MOV指令'从寄存器读或者写到寄存器'的方式来进行读取或者装载。在保护模式下，只能运行在0特权级。**


****
## 二.分页管理机制
 ```
  1. 页目录表
     大小4k,存储1k个记录,每个记录占用4Byte,指向页表位置
  2. 页表
     大小4k,存储1k个记录,每个记录占用4Byte,表示逻辑地址与物理地址映射关系
  3. 页
     大小4k,存储4k数据
  4. 页目录及页表的记录项
     31-12: 记录物理地址
     11--0: 页属性信息
  ```
### 2.1 分页相关概念
 1. 页目录表项
    |31-12|11-9|8|7|6|5|4|3|2|1|0|
    |-|-|-|-|-|-|-|-|-|-|-|
    |页表基址20位|Avail|G|PS|0|A|PCD|PWT|U/S|R/W|P|
 2. 页表项
    |31-12|11-9|8|7|6|5|4|3|2|1|0|
    |-|-|-|-|-|-|-|-|-|-|-|
    |页基址20位|Avail|G|PAT|D|A|PCD|PWT|U/S|R/W|P|

    >|名称|作用|
     |-|-|
     |页表基址|指向一张页表(4k对齐)|
     |P|指明页或者页表是否在内存中|
     |R/W|该标志确定对于一个页或者一组页的读写权限。当被清零时，该页时只读的。当被置位时，该页是可读可写的。|
     |U/S|该标志确定一个页或者一组页是用户特权(1)还是管理特权(0)|
     |PWT|页面直写标志,控制单个页或一组页的直写或回写高速缓存策略.PWT=1时，启用页表的直写高速缓存机制；PWT=0时，回写高速缓存与页或者页表关联；当CR0的CD=1时，处理器忽略这个标志|
     |PCD|页级高速缓存禁用标志，PCD=1时，相关页或页表的高速缓存被禁止；PCD=0时,相关页或页表可以被高速缓存。当CR0的CD=0时，处理器忽略这个标志|
     |A|访问标志，指明页或页表是否曾经被访问过|
     |D|脏位，指明页是否曾经被写入过（在指向页表的页目录项中，不适用该位）|
     |PS|页尺寸。PS=0时,页尺寸位4KB;PS=1时，页尺寸位4MB|
     |avali保留位|第9、10、11位，可供软件使用|

## 三.中断机制的建立
  ```
  1. Head.s
  _idt:	.fill 256,8,0		# idt is uninitialized
  _gdt:	.quad 0x0000000000000000	/* NULL descriptor */
	       .quad 0x00c09a0000000fff	/* 16Mb */
	       .quad 0x00c0920000000fff	/* 16Mb */
	       .quad 0x0000000000000000	/* TEMPORARY - don't use */
	       .fill 252,8,0
  2. main.c
    trap_init()
  3. traps.c
    #define set_trap_gate(n,addr)
      _set_gate(&idt[n],15,0,addr)
    #define _set_gate(gate_addr,type,dpl,addr)
      __asm__ ("movw %%dx,%%ax\n\t" \
  	         "movw %0,%%dx\n\t" \
  	         "movl %%eax,%1\n\t" \
  	         "movl %%edx,%2" \
  	         : \
  	         : "i" ((short) (0x8000+(dpl<<13)+(type<<8))), \
  	         "o" (*((char *) (gate_addr))), \
  	         "o" (*(4+(char *) (gate_addr))), \
  	         "d" ((char *) (addr)),"a" (0x00080000))
  ```
- 调度初始化-系统调用0x80的建立
  ```c
   文件：sched.c
   sched_init(){
     ...
     set_system_gate(0x80,&system_call)
   }
   _system_call:定义在System_call.s
   sys_call_table: Sys.h

   _system_call:
	   cmpl $nr_system_calls-1,%eax
	   ja bad_sys_call
	   push %ds
	   push %es
	   push %fs
	   pushl %edx
	   pushl %ecx		# push %ebx,%ecx,%edx as parameters
	   pushl %ebx		# to the system call
	   movl $0x10,%edx		# set up ds,es to kernel space
	   mov %dx,%ds
	   mov %dx,%es
	   movl $0x17,%edx		# fs points to local data space
	   mov %dx,%fs
	   call _sys_call_table(,%eax,4)
	   pushl %eax
       ...
       iret
  ```
- 缓存初始化
  ```
  struct buffer_head {
    char * b_data;			/* pointer to data block (1024 bytes) */
    unsigned long b_blocknr;	/* block number */
    unsigned short b_dev;		/* device (0 = free) */
    unsigned char b_uptodate;
    unsigned char b_dirt;		/* 0-clean,1-dirty */
    unsigned char b_count;		/* users using this block */
    unsigned char b_lock;		/* 0 - ok, 1 -locked */
    struct task_struct * b_wait;
    struct buffer_head * b_prev;
    struct buffer_head * b_next;
    struct buffer_head * b_prev_free;
    struct buffer_head * b_next_free;
  };

  struct buffer_head * start_buffer = (struct buffer_head *) &end;
  struct buffer_head * hash_table[NR_HASH]; /*NR_HASH=307*/
  static struct buffer_head * free_list;
  static struct task_struct * buffer_wait = NULL;
  ```
- 进程0跳转至用户模式--move_to_user_mode()
  ```
  #define move_to_user_mode() \
  __asm__ ("movl %%esp,%%eax\n\t" \
	"pushl $0x17\n\t" \
	"pushl %%eax\n\t" \
	"pushfl\n\t" \
	"pushl $0x0f\n\t" \
	"pushl $1f\n\t" \
	"iret\n" \
	"1:\tmovl $0x17,%%eax\n\t" \
	"movw %%ax,%%ds\n\t" \
	"movw %%ax,%%es\n\t" \
	"movw %%ax,%%fs\n\t" \
	"movw %%ax,%%gs" \
	:::"ax")
  ```
- 块设备初始化
  ```
    --块设备管理
    struct blk_dev_struct blk_dev[NR_BLK_DEV]={ //NR_BLK_DEV=7
      {NULL,NULL},   /* no_dev  */
      {NULL,NULL},   /* dev mem */
      {NULL,NULL},   /* dev fd  */
      {NULL,NULL},   /* dev hd  */
      {NULL,NULL},   /* dev ttyx*/
      {NULL,NULL},   /* dev tty */
      {NULL,NULL}    /* dev lp  */
    }
    struct request request[NR_REQUEST]; //NR_REQUEST=32

    /--------------------------------
    struct blk_dev_struct{
      void (*request_fn)(void);
      struct request * current_request;
    }
    struct request{
      int dev;
      int cmd;
      int errors;
      unsigned long sector;
      unsigned long nr_sectors;
      char * buffer;
      struct task_struct *waiting;
      struct buffer_head *bh;
      struct request *next;
    }
  ```
- 块设备读取
  ```
   struct buffer_head * bread(int dev,int block){
     struct buffer_head * getblk(int dev,int block);//b_count=1
     void ll_rw_block(int rw,struct buffer_head *bh){
       void make_request(int major,int rw, struct buffer_head * bh);//b_lock=1
       void add_request(struct blk_dev_struct * dev, struct request * req)
     }
   }

  ```
