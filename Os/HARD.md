### 一. 8259A中断控制器
#### 1.主从两片，从片INT引脚连接至主片IR2  
#### 2.端口：
  - 主: 0x20-0x3f  
  - 从: 0xA0-0xbf

#### 3.中断对应关系
  |引脚|IRQ|中断设备|
  |:-|-|-|
  |IR0|IRQ0|时钟|
  |IR1|IRQ1|键盘|
  |IR2|IRQ2|连接从片|
  |IR3|IRQ3|串行口2|
  |IR4|IRQ4|串行口1|
  |IR5|IRQ5|并行口2|
  |IR6|IRQ6|软盘|
  |IR7|IRQ7|并行口1|
  |IR0|IRQ8|实时钟|
  |IR1|IRQ9|INTOAH|
  |IR2|IRQ10|保留|
  |IR3|IRQ11|保留|
  |IR4|IRQ12|PS2鼠标|
  |IR5|IRQ13|协处理器|
  |IR6|IRQ14|硬盘|
  |IR7|IRQ15|保留|

#### 4.中断处理
  在Linux系统中，将int32-int47对应于8259a发出的中断请求信号

### 二.8253

### 三.设备号命名规则
  设备号=主设备号*256+次设备号（也即dev_no=(major<<8)+minor)   
  主设备号：1内存，2磁盘，3硬盘，4ttyx,5tty,6并行口,7非命名管道
  0x300 /dev/hd0 -代表整个第一个硬盘   
  0x301 /dev/hd1 -代表第一个硬盘第一个分区   
  0x302 /dev/hd2 -代表第一个硬盘第二个分区   
  0x303 /dev/hd3 -代表第一个硬盘第三个分区   
  0x304 /dev/hd4 -代表第一个硬盘第四个分区

  0x305 /dev/hd5 -代表整个第二个硬盘   
  0x306 /dev/hd6 -代表第二个硬盘第一个分区    
  0x307 /dev/hd7 -代表第二个硬盘第二个分区   
  ...  

  linux中软驱的主设备号是2，次设备号=type*4+nr   
   + 其中nr为0-3分别对应软驱A、B、C、D
   + type是软驱的类型（2->1.2M或7->1.44M）
