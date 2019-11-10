+ 磁盘

  1.组成
  + 磁头: <font size=2>通过感应旋转的盘片上的磁场的变化来读取数据,通过改变盘片上的磁场来写入数据。磁头从0开始编号。</font>
  + 磁道: <font size=2>磁道由外向内编号，从0开始。</font>
  + 柱面: <font size=2>磁盘由多个盘片，从上到下排成柱状，不同盘片，相同磁道组成的就叫柱面（cylinder）,柱面从0开始编号。</font>
  + 扇区: <font size=2>磁盘上每个磁道被分成若干个弧段，这些弧段就是扇区。一个扇区通常是512byte,扇区从0开始编号。</font>

  2.寻址方式
  + CHS模式: <font size=2>给定柱面号、磁头号、扇区号，定位到一个准确的扇区。</font>
  + LBA模式: <font size=2>只给一个逻辑号码，根据硬盘的柱面数、每个柱面磁头数、每个磁道的扇区数来计算柱面号、磁头号、扇区号。</font>

  3.相互转换
  ```
  LBA=(柱面号*一个柱面的磁头数+磁头号)*一个磁道的扇区数+(扇区号-1)
  柱面号=LBA/(一个柱面的磁头数*每个磁道扇区数)
  磁头号=[LBA%(一个柱面的磁头数*每个磁道扇区数)]/每个磁道扇区数
  扇区号=LBA%每个磁道扇区数+1
  ```
  4.硬盘操作

  CPU与外设、存储器的连接和数据交换都需要通过接口设备来实现。<br/>
  每个连接到I/O总线上的设备都由自己的I/O地址集，即所谓的I/O端口。<br/>
  每个设备的I/O端口都被组织成为一组专用的寄存器，CPU可给**控制寄存器**发命令对设备进行控制、从**状态寄存器**读取设备状态、可以向**输出寄存器**写入数据来把数据输出到设备、可通过读取**输入寄存器**的内容来从设备取得数据。<br/>
  总之，就是通过读写端口来控制设备。<br/><br/>
  一个普通的PC主板上通常有两个IDE口，分别对应两个IDE通道：primary和secondary,有时也称为IDE0和IDE1.每个IDE通道又能连接两个设备，成为主设备（Master）和从设备（slave）,对不同的IDE通道的访问是通过I/O端口来区分的。IDE，即电子集成驱动器，主要接硬盘和光驱。
  ```
  与0号硬盘有关的I/O端口:
    1F0H 数据寄存器
    1F1H 错误寄存器（读时），features寄存器（写时）
    1F2H 数据扇区计数
    1F3H 扇区数
    1F4H 柱面（低字节）
    1F5H 柱面（高字节）
    1F6H 驱动器/磁头寄存器
    1F7H 状态寄存器（读时），命令寄存器（写时）
  使用：
    可以从端口0x1F0读取数据，若发生错误可以从0x1F1读取错误；
    若要从硬盘读数据可以从0x1F2指定读取的扇区数，0x1F3、0x1F4、0x1F5、0x1F6指定CHS(或LBA);
    可以从0x1F7读取硬盘状态或向硬盘发送命令。
  ```
  5.读取若干扇区

  步骤:
  + 通过状态寄存器查询硬盘状态，看是否空闲，若忙，则等待;
  + 把读取扇区的个数、CHS写入相应端口;
  + 通过命令寄存器向硬盘发送读命令;
  + 从数据寄存器读取数据;

  ```
  #include <harddisk.h>
  #include <io.h>
  #include <font.h>
  #include <graphics.h>

  BOOL harddisk_read(u32 lba, u32 sects_to_read, u8* buffer)
  {
  	u32 cylinder_no, head_no, sect_no, temp;
  	u32 num_of_dwords;

  	cylinder_no = lba / (HD0_HEAD_PER_CYLINDER * HD0_SECT_PER_TRACK);
  	temp		= lba % (HD0_HEAD_PER_CYLINDER * HD0_SECT_PER_TRACK);
  	head_no		= temp / HD0_SECT_PER_TRACK;
  	sect_no		= temp % HD0_SECT_PER_TRACK + 1;

  	/* 检查硬盘是否忙，忙则等待 */
  	while ((inb(HD_PORT_STATUS) & 0x80) != 0);
  	/* 设置读取的扇区数和CHS，
  	   HD_PORT_DRIVE_HEAD端口bit7、bit5需要为1，bit6为0时bit0～bit3表示磁头号，
  	   bit4为驱动器号，0 表示HD0，故下面head_no要或操作10100000即0xa0 */
  	outb(sects_to_read, HD_PORT_SECT_COUNT);
  	outb(sect_no, HD_PORT_SECT_NO);
  	outb(cylinder_no, HD_PORT_CYLINDER_LOW);
  	cylinder_no >>= 8;
  	outb((cylinder_no), HD_PORT_CYLINDER_HIGH);
  	head_no |= 0xa0;
  	outb((head_no), HD_PORT_DRIVE_HEAD);

  	/* 发送读命令 */
  	outb(HD_CMD_READ, HD_PORT_COMMAND);
  	num_of_dwords = (sects_to_read << 7);
  	/* 从HD_PORT_DATA读取数据，每个扇区512字节，即sects_to_read << 7个双字 */
  	insl(HD_PORT_DATA, buffer, num_of_dwords);
  	return TRUE;
  }
  ```
