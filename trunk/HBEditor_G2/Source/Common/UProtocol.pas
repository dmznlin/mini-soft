{*******************************************************************************
  作者: dmzn@163.com 2009-10-31
  描述: 通信协议
*******************************************************************************}
unit UProtocol;

interface

const
  cHead_DataSend          = $4842;          //数据发送
  cHead_DataRecv          = $4153;          //数据接收
  cHead_DataRecv_Hi       = $41;
  cHead_DataRecv_Low      = $53;

  cCmd_SetBorder          = $07;            //设置边框
  cCmd_SetScanMode        = $08;            //扫描模式
  cCmd_SetELevel          = $09;            //有效电平

  cCmd_ConnCtrl           = $10;            //控制器链接
  cCmd_SetDeviceNo        = $11;            //设置设备号
  cCmd_ResetCtrl          = $12;            //复位控制器
  cCmd_SetBright          = $13;            //设置亮度
  cCmd_SetBrightTime      = $14;            //时段亮度
  cCmd_AdjustTime         = $15;            //校准时间
  cCmd_OpenOrClose        = $16;            //开关屏幕
  cCmd_OCTime             = $17;            //开关时间
  cCmd_PlayDays           = $18;            //播放天数
  cCmd_ReadStatus         = $19;            //读取状态
  cCmd_SetScreenWH        = $1A;            //屏幕宽高
  cCmd_DataBegin          = $1B;            //起始帧
  cCmd_DataEnd            = $1C;            //结束帧

  cCmd_SendPicData        = $20;            //发送图片
  cCmd_SendAnimate        = $30;            //发送动画
  cCmd_SendSimuClock      = $40;            //模拟时钟
  cCmd_SendAreaTime       = $41;            //区域信息

  sFlag_OK                = 1;              //成功
  sFlag_Err               = 0;              //失败
  sFlag_BroadCast         = $FFFF;          //广播模式

type
  //应答基准协议头
  THead_Respond_Base = packed record
    FHead: Word;                            //帧头
    FLen: Byte;                             //帧长度
    FCardType: Byte;                        //卡类别
    FDevice: Word;                          //设备号
    FCommand: Byte;                         //命令号
  end;

  //控制器链接(PC -> Ctrl)
  THead_Send_ConnCtrl = packed record
    FHead: Word;                            //帧头
    FLen: Word;                             //帧长度
    FCardType: Byte;                        //卡类别
    FDevice: Word;                          //设备号
    FCommand: Byte;                         //命令号
    FExtend: array[0..5] of Byte;           //备用
    FCRC16: Word;                           //校验位
  end;

  //控制器链接应答(PC <- Ctrl)
  THead_Respond_ConnCtrl = packed record
    FHead: Word;                            //帧头
    FLen: Byte;                             //帧长度
    FCardType: Byte;                        //卡类别
    FDevice: Word;                          //设备号
    FCommand: Byte;                         //命令号
    FScreen: array[0..1] of Byte;           //屏行,列
    FCRC16: Word;                           //校验位
  end;

  //指定控制器设备号(PC -> Ctrl)
  THead_Send_SetDeviceNo = packed record
    FHead: Word;                            //帧头
    FLen: Word;                             //帧长度
    FCardType: Byte;                        //卡类别
    FNo: Word;                              //编号
    FCommand: Byte;                         //命令号
    FExtend: array[0..5] of Byte;           //备用
    FCRC16: Word;                           //校验位
  end;

  //控制器应答(PC <- Ctrl)
  THead_Respond_SetDeviceNo = packed record
    FHead: Word;                            //帧头
    FLen: Byte;                             //帧长度
    FCardType: Byte;                        //卡类别
    FDevice: Word;                          //设备号
    FCommand: Byte;                         //命令号
    FFlag: Byte;                            //标志(1,成功;0,失败)
    FCRC16: Word;                           //校验位
  end;

  //复位控制器(PC -> Ctrl)
  THead_Send_ResetCtrl = packed record
    FHead: Word;                            //帧头
    FLen: Word;                             //帧长度
    FCardType: Byte;                        //卡类别
    FDevice: Word;                          //设备号
    FCommand: Byte;                         //命令号
    FExtend: array[0..5] of Byte;           //备用
    FCRC16: Word;                           //校验位
  end;

  //复位控制器(PC <- Ctrl)
  THead_Respond_ResetCtrl = packed record
    FHead: Word;                            //帧头
    FLen: Byte;                             //帧长度
    FCardType: Byte;                        //卡类别
    FDevice: Word;                          //设备号
    FCommand: Byte;                         //命令号
    FFlag: Byte;                            //标志(1,成功;0,失败)
    FCRC16: Word;                           //校验位
  end;

  //设定显示屏亮度(PC -> Ctrl)
  THead_Send_SetBright = packed record
    FHead: Word;                            //帧头
    FLen: Word;                             //帧长度
    FCardType: Byte;                        //卡类别
    FDevice: Word;                          //设备号
    FCommand: Byte;                         //命令号
    FBright: Byte;                          //亮度值
    FExtend: array[0..4] of Byte;           //备用
    FCRC16: Word;                           //校验位
  end;

  //设定显示屏亮度(PC <- Ctrl)
  THead_Respond_SetBright = packed record
    FHead: Word;                            //帧头
    FLen: Byte;                             //帧长度
    FCardType: Byte;                        //卡类别
    FDevice: Word;                          //设备号
    FCommand: Byte;                         //命令号
    FFlag: Byte;                            //标志(1,成功;0,失败)
    FCRC16: Word;                           //校验位
  end;

  //设定时间段控制亮度(PC -> Ctrl)
  THead_Send_SetBrightTime = packed record
    FHead: Word;                            //帧头
    FLen: Word;                             //帧长度
    FCardType: Byte;                        //卡类别
    FDevice: Word;                          //设备号
    FCommand: Byte;                         //命令号
    FBright: Byte;                          //亮度值
    FTimeBegin: array[0..1]of Byte;         //开始时间
    FTimeEnd: array[0..1]of Byte;           //结束时间
    FExtend: Byte;                          //备用
    FCRC16: Word;                           //校验位
  end;

  //设定时间段控制亮度(PC <- Ctrl)
  THead_Respond_SetBrightTime = packed record
    FHead: Word;                            //帧头
    FLen: Byte;                             //帧长度
    FCardType: Byte;                        //卡类别
    FDevice: Word;                          //设备号
    FCommand: Byte;                         //命令号
    FFlag: Byte;                            //标志(1,成功;0,失败)
    FCRC16: Word;                           //校验位
  end;

  //校准控制器时间(PC -> Ctrl)
  THead_Send_AdjustTime = packed record
    FHead: Word;                            //帧头
    FLen: Word;                             //帧长度
    FCardType: Byte;                        //卡类别
    FDevice: Word;                          //设备号
    FCommand: Byte;                         //命令号
    FTime: array[0..6] of Byte;             //校准时间
    FCRC16: Word;                           //校验位
  end;

  //校准控制器时间(PC <- Ctrl)
  THead_Respond_AdjustTime = packed record
    FHead: Word;                            //帧头
    FLen: Byte;                             //帧长度
    FCardType: Byte;                        //卡类别
    FDevice: Word;                          //设备号
    FCommand: Byte;                         //命令号
    FFlag: Byte;                            //标志(1,成功;0,失败)
    FCRC16: Word;                           //校验位
  end;

  //手动开/关屏幕(PC -> Ctrl)
  THead_Send_OpenOrClose = packed record
    FHead: Word;                            //帧头
    FLen: Word;                             //帧长度
    FCardType: Byte;                        //卡类别
    FDevice: Word;                          //设备号
    FCommand: Byte;                         //命令号
    FFlag: Byte;                            //开关标记(0,关;1,开)
    FExtend: array[0..4] of Byte;           //备用
    FCRC16: Word;                           //校验位
  end;

  //手动开/关屏幕(PC <- Ctrl)
  THead_Respond_OpenOrClose = packed record
    FHead: Word;                            //帧头
    FLen: Byte;                             //帧长度
    FCardType: Byte;                        //卡类别
    FDevice: Word;                          //设备号
    FCommand: Byte;                         //命令号
    FFlag: Byte;                            //标志(1,成功;0,失败)
    FCRC16: Word;                           //校验位
  end;

  //自动开关屏幕时间(PC -> Ctrl)
  THead_Send_OCTime = packed record
    FHead: Word;                            //帧头
    FLen: Word;                             //帧长度
    FCardType: Byte;                        //卡类别
    FDevice: Word;                          //设备号
    FCommand: Byte;                         //命令号
    FFlag: Byte;                            //开关标记(0,关;1,开)
    FTimeBegin: array[0..1] of Byte;        //开始时间
    FTimeEnd: array[0..1] of Byte;          //结束时间
    FExtend: Byte;                          //备用
    FCRC16: Word;                           //校验位
  end;

  //自动开关屏幕时间(PC <- Ctrl)
  THead_Respond_OCTime = packed record
    FHead: Word;                            //帧头
    FLen: Byte;                             //帧长度
    FCardType: Byte;                        //卡类别
    FDevice: Word;                          //设备号
    FCommand: Byte;                         //命令号
    FFlag: Byte;                            //标志(1,成功;0,失败)
    FCRC16: Word;                           //校验位
  end;

  //设置播放天数(PC -> Ctrl)
  THead_Send_PlayDays = packed record
    FHead: Word;                            //帧头
    FLen: Word;                             //帧长度
    FCardType: Byte;                        //卡类别
    FDevice: Word;                          //设备号
    FCommand: Byte;                         //命令号
    FDays: Word;                            //设置天数
    FExtend: array[0..3] of Byte;           //备用
    FCRC16: Word;                           //校验位
  end;

  //设置播放天数(PC <- Ctrl)
  THead_Respond_PlayDays = packed record
    FHead: Word;                            //帧头
    FLen: Byte;                             //帧长度
    FCardType: Byte;                        //卡类别
    FDevice: Word;                          //设备号
    FCommand: Byte;                         //命令号
    FFlag: Byte;                            //标志(1,成功;0,失败)
    FCRC16: Word;                           //校验位
  end;

  //读取控制器运行状态(PC -> Ctrl)
  THead_Send_ReadStatus = packed record
    FHead: Word;                            //帧头
    FLen: Word;                             //帧长度
    FCardType: Byte;                        //卡类别
    FDevice: Word;                          //设备号
    FCommand: Byte;                         //命令号
    FExtend: array[0..5] of Byte;           //备用
    FCRC16: Word;                           //校验位
  end;

  //读取控制器运行状态(PC <- Ctrl)
  THead_Respond_ReadStatus = packed record
    FHead: Word;                            //帧头
    FLen: Byte;                             //帧长度
    FCardType: Byte;                        //卡类别
    FDevice: Word;                          //设备号
    FCommand: Byte;                         //命令号
    FFlag: Byte;                            //状态字(1,真;0,假)
    FScreenWH: array[0..1] of Byte;         //行列
    FPlayDays: array[0..1] of Word;         //播放天数
    FOpenTime: array[0..1] of Byte;         //开屏时间
    FCloseTime: array[0..1] of Byte;        //关屏时间
    FBright: Byte;                          //当前亮度
    FItemID: array[0..7] of Byte;           //幕序号
    FNowTime: array[0..6] of Byte;          //当前时间
    FExtend: array[0..5] of Byte;           //备用
    FCRC16: Word;                           //校验位
  end;

  //设置屏幕宽高(PC -> Ctrl)
  THead_Send_SetScreenWH = packed record
    FHead: Word;                            //帧头
    FLen: Word;                             //帧长度
    FCardType: Byte;                        //卡类别
    FDevice: Word;                          //设备号
    FCommand: Byte;                         //命令号
    FScreenWH: array[0..1] of Byte;         //屏幕宽高
    FExtend: array[0..3] of Byte;           //备用
    FCRC16: Word;                           //校验位
  end;

  //设置屏幕宽高(PC <- Ctrl)
  THead_Respond_SetScreenWH = packed record
    FHead: Word;                            //帧头
    FLen: Byte;                             //帧长度
    FCardType: Byte;                        //卡类别
    FDevice: Word;                          //设备号
    FCommand: Byte;                         //命令号
    FFlag: Byte;                            //标志(1,成功;0,失败)
    FCRC16: Word;                           //校验位
  end;

  //数据发起帧(PC -> Ctrl)
  THead_Send_DataBegin = packed record
    FHead: Word;                            //帧头
    FLen: Word;                             //帧长度
    FCardType: Byte;                        //卡类别
    FDevice: Word;                          //设备号
    FCommand: Byte;                         //命令号
    FAreaNum: Byte;                         //总区个数
    FColorType: Byte;                       //屏幕类型
    FExtend: array[0..3] of Byte;           //备用
    FCRC16: Word;                           //校验位
  end;

  //数据发起帧(PC <- Ctrl)
  THead_Respond_DataBegin = packed record
    FHead: Word;                            //帧头
    FLen: Byte;                             //帧长度
    FCardType: Byte;                        //卡类别
    FDevice: Word;                          //设备号
    FCommand: Byte;                         //命令号
    FFlag: Byte;                            //标志(1,成功;0,失败)
    FCRC16: Word;                           //校验位
  end;

  //数据结束帧(PC -> Ctrl)
  THead_Send_DataEnd = packed record
    FHead: Word;                            //帧头
    FLen: Word;                             //帧长度
    FCardType: Byte;                        //卡类别
    FDevice: Word;                          //设备号
    FCommand: Byte;                         //命令号
    FExtend: array[0..5] of Byte;           //备用
    FCRC16: Word;                           //校验位
  end;

  //数据结束帧(PC <- Ctrl)
  THead_Respond_DataEnd = packed record
    FHead: Word;                            //帧头
    FLen: Byte;                             //帧长度
    FCardType: Byte;                        //卡类别
    FDevice: Word;                          //设备号
    FCommand: Byte;                         //命令号
    FFlag: Byte;                            //标志(1,成功;0,失败)
    FCRC16: Word;                           //校验位
  end;

  //图片发送帧(PC -> Ctrl)
  THead_Send_PicData = packed record
    FHead: Word;                            //帧头
    FLen: Word;                             //帧长度
    FCardType: Byte;                        //卡类别
    FDevice: Word;                          //设备号
    FCommand: Byte;                         //命令号
    FIndexID: Byte;                         //区域编号
    FLevel: Byte;                           //优先级
    FPosX: Word;
    FPosY: Word;                            //区域坐标
    FWidth: Word;
    FHeight: Word;                          //区域宽高
    FAllID: Word;
    FNowID: Word;                           //总幕,当前幕
    FExtend: array[0..8] of Byte;           //备用
    FMode: array[0..6] of Byte;             //播放模式
    //FData: array of Byte;                   //数据
    //FCRC16: Word;                           //校验位
  end;

  //图片应答帧(PC <- Ctrl)
  THead_Respond_PicData = packed record
    FHead: Word;                            //帧头
    FLen: Byte;                             //帧长度
    FCardType: Byte;                        //卡类别
    FDevice: Word;                          //设备号
    FCommand: Byte;                         //命令号
    FFlag: Byte;                            //标志(1,成功;0,失败)
    FCRC16: Word;                           //校验位
  end;

  //动画发送帧(PC -> Ctrl)
  THead_Send_Animate = packed record
    FHead: Word;                            //帧头
    FLen: Word;                             //帧长度
    FCardType: Byte;                        //卡类别
    FDevice: Word;                          //设备号
    FCommand: Byte;                         //命令号
    FIndexID: Byte;                         //区域编号
    FLevel: Byte;                           //优先级
    FPosX: Word;
    FPosY: Word;                            //区域坐标
    FWidth: Word;
    FHeight: Word;                          //区域宽高
    FAllID: Word;
    FNowID: Word;                           //总帧数,当前帧
    FSpeed: Byte;                           //播放速度
    FExtend: array[0..4] of Byte;           //备用
    //FData: array of Byte;                   //数据
    //FCRC16: Word;                           //校验位
  end;

  //动画应答帧(PC <- Ctrl)
  THead_Respond_Animate = packed record
    FHead: Word;                            //帧头
    FLen: Byte;                             //帧长度
    FCardType: Byte;                        //卡类别
    FDevice: Word;                          //设备号
    FCommand: Byte;                         //命令号
    FFlag: Byte;                            //标志(1,成功;0,失败)
    FCRC16: Word;                           //校验位
  end;

  //区域时间信息(PC -> Ctrl)
  THead_Send_AreaTime = packed record
    FHead: Word;                            //帧头
    FLen: Word;                             //帧长度
    FCardType: Byte;                        //卡类别
    FDevice: Word;                          //设备号
    FCommand: Byte;                         //命令号
    FIndexID: Byte;                         //区域编号
    FLevel: Byte;                           //优先级
    FPosX: Word;
    FPosY: Word;                            //区域坐标
    FWidth: Word;
    FHeight: Word;                          //区域宽高
    FParam: Word;                           //参数长度
    FModeChar: Byte;                        //字符模式(0,字符;1,汉字)
    FModeLine: Byte;                        //行显模式(0,单;1,多)
    FModeDate: Byte;                        //日期选择(0,不显;1,显示)
    FModeWeek: Byte;                        //星期选择(0,不显;1,显示)
    FModeTime: Byte;                        //时间选择(0,不显;1,显示)
    FExtend: array[0..12] of Byte;          //备用
    FCRC16: Word;                           //校验位
  end;

  //区域时间信息(PC <- Ctrl)
  THead_Respond_AreaTime = packed record
    FHead: Word;                            //帧头
    FLen: Byte;                             //帧长度
    FCardType: Byte;                        //卡类别
    FDevice: Word;                          //设备号
    FCommand: Byte;                         //命令号
    FFlag: Byte;                            //标志(1,成功;0,失败)
    FCRC16: Word;                           //校验位
  end;

  //模拟时钟(PC -> Ctrl)
  THead_Send_Clock = packed record
    FHead: Word;                            //帧头
    FLen: Word;                             //帧长度
    FCardType: Byte;                        //卡类别
    FDevice: Word;                          //设备号
    FCommand: Byte;                         //命令号
    FIndexID: Byte;                         //区域编号
    FLevel: Byte;                           //优先级
    FPosX: Word;
    FPosY: Word;                            //区域坐标
    FWidth: Word;
    FHeight: Word;                          //区域宽高
    FParam: Word;                           //参数长度
    FPointX: Word;
    FPointY: Word;                          //表盘圆心坐标
    FZhenColor: array[0..2] of Byte;        //表针颜色(时,分,秒)
    FExtend: array[0..0] of Byte;           //备用
    //FData: array of Byte;                 //模拟表盘
    //FCRC16: Word;                         //校验位
  end;

  //模拟时钟(PC <- Ctrl)
  THead_Respond_Clock = packed record
    FHead: Word;                            //帧头
    FLen: Byte;                             //帧长度
    FCardType: Byte;                        //卡类别
    FDevice: Word;                          //设备号
    FCommand: Byte;                         //命令号
    FFlag: Byte;                            //标志(1,成功;0,失败)
    FCRC16: Word;                           //校验位
  end;

  THead_Send_SetBorder = packed record
    FHead: Word;                            //帧头
    FLen: Word;                             //帧长度
    FCardType: Byte;                        //卡类别
    FDevice: Word;                          //设备号
    FCommand: Byte;                         //命令号
    FHasBorder: Byte;                       //是否显示(0,不显示;1,显示)
    FEffect: Byte;                          //特效
    FSpeed: Byte;                           //速度
    FWidth: Byte;                           //点宽
    FExtend: array[0..1] of Byte;           //备用 
    FCRC16: Word;                           //校验位
  end;

  THead_Respond_SetBorder = packed record
    FHead: Word;                            //帧头
    FLen: Byte;                             //帧长度
    FCardType: Byte;                        //卡类别
    FDevice: Word;                          //设备号
    FCommand: Byte;                         //命令号
    FFlag: Byte;                            //标志(1,成功;0,失败)
    FCRC16: Word;                           //校验位
  end;

  THead_Send_ScanMode = packed record
    FHead: Word;                            //帧头
    FLen: Word;                             //帧长度
    FCardType: Byte;                        //卡类别
    FDevice: Word;                          //设备号
    FCommand: Byte;                         //命令号
    FKeepMode: Byte;                        //保持模式(1,保存;0,不保存)
    FExtend: array[0..4] of Byte;           //备用
    FCRC16: Word;                           //校验位
  end;

  THead_Respond_ScanMode = packed record
    FHead: Word;                            //帧头
    FLen: Byte;                             //帧长度
    FCardType: Byte;                        //卡类别
    FDevice: Word;                          //设备号
    FCommand: Byte;                         //命令号
    FFlag: Byte;                            //标志(1,成功;0,失败)
    FCRC16: Word;                           //校验位
  end;

  THead_Send_ELevel = packed record
    FHead: Word;                            //帧头
    FLen: Word;                             //帧长度
    FCardType: Byte;                        //卡类别
    FDevice: Word;                          //设备号
    FCommand: Byte;                         //命令号
    FKeepMode: Byte;                        //保持模式(1,保存;0,不保存)
    FExtend: array[0..4] of Byte;           //备用
    FCRC16: Word;                           //校验位
  end;

  THead_Respond_ELevel = packed record
    FHead: Word;                            //帧头
    FLen: Byte;                             //帧长度
    FCardType: Byte;                        //卡类别
    FDevice: Word;                          //设备号
    FCommand: Byte;                         //命令号
    FFlag: Byte;                            //标志(1,成功;0,失败)
    FCRC16: Word;                           //校验位
  end;

const
  cSize_Respond_Base = SizeOf(THead_Respond_Base);
  cSize_Head_Send_ConnCtrl = SizeOf(THead_Send_ConnCtrl);
  cSize_Head_Respond_ConnCtrl = SizeOf(THead_Respond_ConnCtrl);

  cSize_Head_Send_SetDeviceNo = SizeOf(THead_Send_SetDeviceNo);
  cSize_Head_Respond_SetDeviceNo = SizeOf(THead_Respond_SetDeviceNo);

  cSize_Head_Send_ResetCtrl = SizeOf(THead_Send_ResetCtrl);
  cSize_Head_Respond_ResetCtrl = SizeOf(THead_Respond_ResetCtrl);

  cSize_Head_Send_SetBright = SizeOf(THead_Send_SetBright);
  cSize_Head_Respond_SetBright = SizeOf(THead_Respond_SetBright);

  cSize_Head_Send_SetBrightTime = SizeOf(THead_Send_SetBrightTime);
  cSize_Head_Respond_SetBrightTime = SizeOf(THead_Respond_SetBrightTime);

  cSize_Head_Send_AdjustTime = SizeOf(THead_Send_AdjustTime);
  cSize_Head_Respond_AdjustTime = SizeOf(THead_Respond_AdjustTime);

  cSize_Head_Send_OpenOrClose = SizeOf(THead_Send_OpenOrClose);
  cSize_Head_Respond_OpenOrClose = SizeOf(THead_Respond_OpenOrClose);

  cSize_Head_Send_OCTime = SizeOf(THead_Send_OCTime);
  cSize_Head_Respond_OCTime = SizeOf(THead_Respond_OCTime);

  cSize_Head_Send_PlayDays = SizeOf(THead_Send_PlayDays);
  cSize_Head_Respond_PlayDays = SizeOf(THead_Respond_PlayDays);

  cSize_Head_Send_ReadStatus = SizeOf(THead_Send_ReadStatus);
  cSize_Head_Respond_ReadStatus = SizeOf(THead_Respond_ReadStatus);

  cSize_Head_Send_SetScreenWH = SizeOf(THead_Send_SetScreenWH);
  cSize_Head_Respond_SetScreenWH = SizeOf(THead_Respond_SetScreenWH);

  cSize_Head_Send_DataBegin = SizeOf(THead_Send_DataBegin);
  cSize_Head_Respond_DataBegin = SizeOf(THead_Respond_DataBegin);

  cSize_Head_Send_DataEnd = SizeOf(THead_Send_DataEnd);
  cSize_Head_Respond_DataEnd = SizeOf(THead_Respond_DataEnd);

  cSize_Head_Send_PicData = SizeOf(THead_Send_PicData);
  cSize_Head_Respond_PicData = SizeOf(THead_Respond_PicData);

  cSize_Head_Send_Animate = SizeOf(THead_Send_Animate);
  cSize_Head_Respond_Animate = SizeOf(THead_Respond_Animate);

  cSize_Head_Send_AreaTime = SizeOf(THead_Send_AreaTime);
  cSize_Head_Respond_AreaTime = SizeOf(THead_Respond_AreaTime);

  cSize_Head_Send_Clock = SizeOf(THead_Send_Clock);
  cSize_Head_Respond_Clock = SizeOf(THead_Respond_Clock);

  cSize_Head_Send_SetBorder = SizeOf(THead_Send_SetBorder);
  cSize_Head_Respond_SetBorder = SizeOf(THead_Respond_SetBorder);

  cSize_Head_Send_ScanMode = SizeOf(THead_Send_ScanMode);
  cSize_Head_Respond_ScanMode = SizeOf(THead_Respond_ScanMode);

  cSize_Head_Send_ELevel = SizeOf(THead_Send_ELevel);
  cSize_Head_Respond_ELevel = SizeOf(THead_Respond_ELevel);
implementation

end.
