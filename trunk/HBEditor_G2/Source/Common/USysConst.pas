{*******************************************************************************
  作者: dmzn 2009-2-6
  描述: 共用常量,函数定义单元
*******************************************************************************}
unit USysConst;

{$I link.inc}
interface

uses
  Windows, Classes, Controls, ComCtrls, Graphics, StdCtrls, SysUtils, Forms,
  IniFiles, UTitleBar, UMovedControl;

const
  cImgScreen    = 4;   //屏幕图标
  cImgMovie     = 5;   //节目图标
  cImgText      = 6;   //文本图标
  cImgPicture   = 7;   //图文图标
  cImgClock     = 9;   //时钟图标
  cImgTime      = 10;  //时间图标

  cItemColorList: array[0..2] of TColor = (clRed, clGreen, clYellow);
  //颜色列表

//------------------------------------------------------------------------------  
type
  TDynamicByteArray = array of Byte;
  TByteData = array[0..7] of Byte;

  TByteInt = record
    FB1,FB2,FB3,FB4: Byte;
  end;

const
  cByteMask: TByteData = (128, 64, 32, 16, 8, 4, 2, 1);

//------------------------------------------------------------------------------
type
  TCardAreaType = (atText, atPic, atAnimate, atClock, atTime);
  //卡区域类型

  TCardForbid = set of TCardAreaType;
  //不支持区域类型

  TCardItem = record
    FCard: Byte;             //类型
    FName: string;           //名称
    FLimite: Byte;           //区域限制
    FForbid: TCardForbid;    //不支持区域
  end;

const
  cCardList: array[0..6] of TCardItem = (
       (FCard: 0;FName: 'HB-F0'; FLimite: 3; FForbid: [atAnimate, atClock]),
       (FCard: 1;FName: 'HB-F1'; FLimite: 3; FForbid: [atAnimate]),
       (FCard: 2;FName: 'HB-F2'; FLimite: 3; FForbid: [atAnimate]),
       (FCard: 3;FName: 'HB-F3'; FLimite: 6; FForbid: []),
       (FCard: 4;FName: 'HB-F4'; FLimite: 8; FForbid: []),
       (FCard: 5;FName: 'HB-F5'; FLimite: 10; FForbid: []),
       (FCard: 6;FName: 'HB-F6'; FLimite: 16; FForbid: []));
  //卡类型

type
  TConnType = (ctComm, ctGPRS, ctNet);
  //通信模式

  TConnItem = record
    FType: TConnType;
    FName: string;
  end;

const
  cConnList: array[0..2] of TConnItem = (
             (FType: ctComm; FName: '串行通信(默认)'),
             (FType: ctGPRS; FName: 'GPRS通信'),
             (FType: ctNet; FName: '网络通讯'));
  //通信类型

//------------------------------------------------------------------------------
type
  TEffectMode = record
    FMode: Byte;
    FText: string;
  end;

const
  cEnterMode: array[0..22] of TEffectMode = ((FMode:0 ;FText: '直接显示'),
              (FMode:1 ;FText: '闪烁三次'), (FMode:2 ;FText: '向右移入'),
              (FMode:3 ;FText: '向左移入'), (FMode:4 ;FText: '向右展开'),
              (FMode:5 ;FText: '向左展开'), (FMode:6 ;FText: '从左右向中间'),
              (FMode:7 ;FText: '从中间向左右'), (FMode:8 ;FText: '向上移入'),
              (FMode:9 ;FText: '向上展开'), (FMode:10 ;FText: '向下展开'),
              (FMode:11 ;FText: '从上下向中间'), (FMode:12 ;FText: '从中间向上下'),
              (FMode:13 ;FText: '水平百叶窗'), (FMode:14 ;FText: '垂直百叶窗'),

              (FMode:15 ;FText: '左上角插入'), (FMode:16 ;FText: '右上角插入'),
              (FMode:17 ;FText: '上下交叉对进'), (FMode:18 ;FText: '左右交叉对展'),
              (FMode:19 ;FText: '反白闪烁'), (FMode:20 ;FText: '斜向下展开'),
              (FMode:21 ;FText: '菱形展开'), (FMode:22 ;FText: '下雨'));

  cExitMode: array[0..22] of TEffectMode = ((FMode:0 ;FText: '直接消隐'),
              (FMode:1 ;FText: '闪烁三次'), (FMode:2 ;FText: '向右移出'),
              (FMode:3 ;FText: '向左移出'), (FMode:4 ;FText: '向右擦除'),
              (FMode:5 ;FText: '向左擦除'), (FMode:6 ;FText: '从左右向中间'),
              (FMode:7 ;FText: '从中间向左右'), (FMode:8 ;FText: '向上移出'),
              (FMode:9 ;FText: '向上擦除'), (FMode:10 ;FText: '向下擦除'),
              (FMode:11 ;FText: '从上下向中间'), (FMode:12 ;FText: '从中间向上下'),
              (FMode:13 ;FText: '水平百叶窗'), (FMode:14 ;FText: '垂直百叶窗'),

              (FMode:15 ;FText: '左下角退出'), (FMode:16 ;FText: '右下角退出'),
              (FMode:17 ;FText: '上下交叉擦除'), (FMode:18 ;FText: '左右交叉擦除'),
              (FMode:19 ;FText: '反白闪烁退出'), (FMode:20 ;FText: '斜向下退出'),
              (FMode:21 ;FText: '菱形退出'), (FMode:22 ;FText: '下雨'));

//------------------------------------------------------------------------------
type
  TDeviceItem = record
    FID: integer;
    FName: string;
  end;

  TScreenType = (stSingle, stDouble, stFull);

  PScreenItem = ^TScreenItem;
  TScreenItem = record
    FID: integer;
    FName: string;
    FCard: Byte;
    FLenX: Word;
    FLenY: Word;
    FType: TScreenType;
    FPort: string;
    FBote: Integer;
    FDevice: array of TDeviceItem;
  end;

type
  PMovedItemData = ^TMovedItemData;
  TMovedItemData = record
    FItem: TZnMovedControl;  //组件
    FPosX: integer;
    FPosY: integer;          //左上角坐标
    FWidth: integer;
    FHeight: integer;        //宽高
    FLevel: Byte;            //优先级
    FTypeIdx: Byte;          //区域编号
  end;
  
  PBitmapDataItem = ^TBitmapDataItem;
  TBitmapDataItem = record
    FBitmap: TBitmap;
    //图片内容
    FModeEnter: Byte;
    FModeExit: Byte;
    //进出场模式
    FSpeedEnter: Byte;
    FSpeedExit: Byte;
    //进出场速度
    FKeedTime: Byte;
    FModeSerial: Byte;
    //停留时间,跟随前屏
  end;

  TDynamicBitmapArray = array of TBitmap;
  //图片数组
  TDynamicBitmapDataArray = array of TBitmapDataItem;
  //图片数据数组

const
  cSendInterval_Long = 4200;
  cSendInterval_Short = 1000; //发送超时等待

//------------------------------------------------------------------------------
type
  TSysParam = record
    FAppTitle: string;                            //程序标题
    FMainTitle: string;                           //主窗口
    FCopyLeft: string;                            //状态栏.版权
    FCopyRight: string;                           //关于.版权
  end;

var
  gPath: string;                                  //程序所在路径
  gSysParam: TSysParam;                           //系统参数

  gScreenList: TList;                             //屏列表
  gSendInterval: Word = cSendInterval_Short;      //发送超时
  gIsFullColor: Boolean;                          //是否全彩
  gStatusBar: TStatusBar;                         //全局使用状态栏

  //xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
  sHint: string;
  sAsk: string;
  sError: string;

  sCaptionScreen: string;
  sCaptionMovie: string;
  sCaptionText: string;
  sCaptionPicture: string;
  sCaptionAnimate: string;
  sCaptionTime: string;
  sCaptionClock: string;                          //全局字符常量
  
//------------------------------------------------------------------------------
procedure SetRStringMultiLang;
//常量多语言
procedure SetTitleBarStatus(const nCtrl: TWinControl; const nActive: Boolean);
//设置标题栏状态
procedure FillColorCombox(const nCombox: TComboBox);
//填充颜色
procedure SetColorComboxIndex(const nCombox: TComboBox; const nColor: TColor);
//设置颜色
function CardItemIndex(const nCard: Byte): Integer;
//获取卡索引
procedure ClearMovedItemDataList(const nList: TList; const nFree: Boolean);
//清理控件列表
procedure ShowMsgOnLastPanelOfStatusBar(const nMsg: string);
procedure StatusBarMsg(const nMsg: string; const nIdx: integer);
//在状态栏显示信息

ResourceString
  sProgID           = 'HBEdit';                   //程序标示
  sAppTitle         = '汉邦电子';                 //任务栏
  sMainTitle        = '图文编辑器';               //主窗口

  sConfigFile       = 'Config.ini';               //主配置
  sFormConfig       = 'Forms.ini';                //窗体配置
  sScreenConfig     = 'Screen.ini';               //屏幕配置
  sBackImage        = 'bg.bmp';                   //背景
  sDocument         = 'Document\';                //文本目录

  sCorConcept       = '※.科技演绎 技术创新 真诚服务 共创未来';
                                                  //企业理念
  {$IFDEF mhkj}
  sCopyRight        = '※.版权所有: 魔幻科技';
  {$ELSE}
  sCopyRight        = '※.版权所有: 汉邦电子';
  {$ENDIF}

  sInvalidConfig    = '配置文件无效或已经损坏';   //配置文件无效

  sMLCommon         = 'Common';                   //多语言公共段
  sMLFrame          = 'FrameItem';                //多语言编辑器
  sMLMain           = 'fFormMain';                //多语言主窗体
  sMLSend           = 'fFormSendData';            //多语言发送
  sMLTxtEdt         = 'fFormTextEditor';          //多语言富文本

implementation

uses UMgrLang;

resourcestring
  {$IFDEF en}
  rsHint             = 'hint';
  rsAsk              = 'ask';
  rsError            = 'error';

  rsCaptionScreen    = '%d-Screen';                //屏幕标题
  rsCaptionMovie     = 'Programm-%d';              //节目标题
  rsCaptionText      = 'Text-%d';                  //字幕标题
  rsCaptionPicture   = 'Pic&Txt-%d';               //图文标题
  rsCaptionAnimate   = 'Animate-%d';               //图文标题
  rsCaptionTime      = 'Time-%d';                  //时间标题
  rsCaptionClock     = 'Clock-%d';                 //时间标题
  {$ELSE}
  rsHint             = '提示';
  rsAsk              = '询问';
  rsError            = '未知';

  rsCaptionScreen    = '%d-显示屏';                //屏幕标题
  rsCaptionMovie     = '节目-%d';                  //节目标题
  rsCaptionText      = '字幕-%d';                  //字幕标题
  rsCaptionPicture   = '图文-%d';                  //图文标题
  rsCaptionAnimate   = '动画-%d';                  //图文标题
  rsCaptionTime      = '时间-%d';                  //时间标题
  rsCaptionClock     = '时钟-%d';                  //时间标题
  {$ENDIF}

procedure SetRStringMultiLang;
begin
  sHint := ML(rsHint, sMLCommon);
  sAsk := ML(rsAsk);
  sError := ML(rsError);

  sCaptionScreen := ML(rsCaptionScreen);
  sCaptionMovie := ML(rsCaptionMovie);
  sCaptionText := ML(rsCaptionText);
  sCaptionPicture := ML(rsCaptionPicture);
  sCaptionAnimate := ML(rsCaptionAnimate);
  sCaptionTime := ML(rsCaptionTime);
  sCaptionClock := ML(rsCaptionClock);
end;

//------------------------------------------------------------------------------
//Desc: 将cItemColorList的颜色填充到nCombox中
procedure FillColorCombox(const nCombox: TComboBox);
var nIdx: integer;
begin
  nCombox.Clear;
  for nIdx:=Low(cItemColorList) to High(cItemColorList) do
  begin
    nCombox.Items.AddObject(IntToStr(nIdx), TObject(cItemColorList[nIdx]))
  end;
end;

//Desc: 设置nCombox的颜色值为nColor
procedure SetColorComboxIndex(const nCombox: TComboBox; const nColor: TColor);
var i: integer;
begin
  nCombox.ItemIndex := -1;
  for i:=nCombox.Items.Count - 1 downto 0 do
   if nCombox.Items.Objects[i] = TObject(nColor) then
   begin
     nCombox.ItemIndex := i; Break;
   end;
end;

//Desc: 设置nCtrl上标题栏的状态
procedure SetTitleBarStatus(const nCtrl: TWinControl; const nActive: Boolean);
var i,nCount: integer;
begin
  nCount := nCtrl.ControlCount - 1;
  for i:=0 to nCount do
   if nCtrl.Controls[i] is TZnTitleBar then
     TZnTitleBar(nCtrl.Controls[i]).Active := nActive;
end;

//Desc: 获取nCard在卡列表的索引
function CardItemIndex(const nCard: Byte): Integer;
begin
  for Result:=Low(cCardList) to High(cCardList) do
   if cCardList[Result].FCard = nCard then Exit;
  Result := -1;
end;

//Desc: 清理nList控件列表
procedure ClearMovedItemDataList(const nList: TList; const nFree: Boolean);
var nIdx: integer;
begin
  for nIdx:=nList.Count - 1 downto 0 do
  begin
    Dispose(PMovedItemData(nList[nIdx]));
    nList.Delete(nIdx);
  end;

  if nFree then nList.Free;
end;

//------------------------------------------------------------------------------
//Desc: 在全局状态栏最后一个Panel上显示nMsg消息
procedure ShowMsgOnLastPanelOfStatusBar(const nMsg: string);
begin
  if Assigned(gStatusBar) and (gStatusBar.Panels.Count > 0) then
  begin
    gStatusBar.Panels[gStatusBar.Panels.Count - 1].Text := nMsg;
    Application.ProcessMessages;
  end;
end;

//Desc: 在索引nIdx的Panel上显示nMsg消息
procedure StatusBarMsg(const nMsg: string; const nIdx: integer);
begin
  if Assigned(gStatusBar) and (gStatusBar.Panels.Count > nIdx) and
     (nIdx > -1) then
  begin
    gStatusBar.Panels[nIdx].Text := nMsg;
    gStatusBar.Panels[nIdx].Width := gStatusBar.Canvas.TextWidth(nMsg) + 20;
    Application.ProcessMessages;
  end;
end;

end.
