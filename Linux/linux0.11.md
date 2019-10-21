- 分段管理机制
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
- 分页管理机制
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
- 中断机制的建立   
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
  ```
   文件：sched.c
   set_system_gate(0x80,&system_call)
   _system_call:定义在System_call.s
   sys_call_table: Sys.h
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
-
