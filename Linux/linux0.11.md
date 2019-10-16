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
