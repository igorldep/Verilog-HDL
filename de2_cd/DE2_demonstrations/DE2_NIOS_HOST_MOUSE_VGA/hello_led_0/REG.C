

void OneuSDelay(void)
 {
  unsigned j;
  unsigned i;

  for (i=0;i<0xd0;i++)
   {
	j++;
   };
 }

void uSDelay(unsigned wDlyTime)
 {
  unsigned j;
  unsigned i;

  for (i=0;i<wDlyTime;i++)
   {
	OneuSDelay();
	j++;
   };
 }


unsigned long r32(unsigned char reg_no)
{
 unsigned int result_l,result_h;
 unsigned long result;

 IOWR(ISP1362_BASE,HC_COMMAND_PORT, reg_no);
 uSDelay(10);
 result_l=IORD(ISP1362_BASE,HC_DATA_PORT);
 result_h=IORD(ISP1362_BASE,HC_DATA_PORT);

 result = result_h;
 result = result<<16;
 result = result+result_l;

 return(result);
}

void w32(unsigned char reg_no, unsigned long data2write)
{
 unsigned int low_word;
 unsigned int hi_word;

 low_word=(data2write)&0x0000FFFF;
 hi_word=((data2write)&0xFFFF0000)>>16;

 IOWR(ISP1362_BASE,HC_COMMAND_PORT,reg_no|0x80);
 uSDelay(10);
 IOWR(ISP1362_BASE,HC_DATA_PORT,low_word);
 IOWR(ISP1362_BASE,HC_DATA_PORT,hi_word);
}

unsigned int r16(unsigned char reg_no)
{
 unsigned int result;

 IOWR(ISP1362_BASE,HC_COMMAND_PORT, reg_no);
 uSDelay(10);
 result=IORD(ISP1362_BASE,HC_DATA_PORT);

 return(result);
}

void w16(unsigned char reg_no, unsigned int data2write)
{
 IOWR(ISP1362_BASE,HC_COMMAND_PORT,reg_no|0x80);
 uSDelay(10);
 IOWR(ISP1362_BASE,HC_DATA_PORT,data2write);
}

unsigned long dc_r32(unsigned char reg_no)
{
 unsigned int result_l,result_h;
 unsigned long result;

 outport(dc_com, reg_no);
 uSDelay(10);
 result_l=inport(dc_data);
 result_h=inport(dc_data);

 result = result_h;
 result = result<<16;
 result = result+result_l;

 return(result);
}

void dc_w32(unsigned char reg_no, unsigned long data2write)
{
 unsigned int low_word;
 unsigned int hi_word;

 low_word=(data2write)&0x0000FFFF;
 hi_word=((data2write)&0xFFFF0000)>>16;

 outport(dc_com,reg_no|0x80);
 uSDelay(10);
 outport(dc_data,low_word);
 outport(dc_data,hi_word);
}

unsigned int dc_r16(unsigned char reg_no)
{
 unsigned int result;

 outport(dc_com, reg_no);
 uSDelay(10);
 result=inport(dc_data);

 return(result);
}

void dc_w16(unsigned char reg_no, unsigned int data2write)
{
 outport(dc_com,reg_no|0x80);
 uSDelay(10);
 outport(dc_data,data2write);
}



