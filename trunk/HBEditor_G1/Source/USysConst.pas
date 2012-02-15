{*******************************************************************************
  作者: dmzn@163.com 2010-9-2
  描述: 系统常量定义
*******************************************************************************}
unit USysConst;

interface

uses
  Windows, Classes, Forms, Graphics, dxStatusBar, SysUtils, UMgrLang;

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
  TCodeText = record
    FCode: string;        //代码
    FText: string;        //含义
  end;

const
  cEnterMode: array[0..14] of TCodeText = ((FCode:'00';FText:'直接显示'),
              (FCode:'01';FText:'闪烁三次'), (FCode:'02';FText:'向右移入'),
              (FCode:'03';FText:'向左移入'), (FCode:'04';FText:'向右展开'),
              (FCode:'05';FText:'向左展开'), (FCode:'06';FText:'从左右向中间'),
              (FCode:'07';FText:'从中间向左右'), (FCode:'08';FText:'向上移入'),
              (FCode:'09';FText:'向上展开'), (FCode:'0a';FText:'向下展开'),
              (FCode:'0b';FText:'从上下向中间'), (FCode:'0c';FText:'从中间向上下'),
              (FCode:'0d';FText:'水平百叶窗'), (FCode:'0e';FText:'垂直百叶窗'));

  cExitMode: array[0..14] of TCodeText = ((FCode:'00';FText:'直接消隐'),
              (FCode:'01';FText:'闪烁三次'), (FCode:'02';FText:'向右移出'),
              (FCode:'03';FText:'向左移出'), (FCode:'04';FText:'向右擦除'),
              (FCode:'05';FText:'向左擦除'), (FCode:'06';FText:'从左右向中间'),
              (FCode:'07';FText:'从中间向左右'), (FCode:'08' ;FText:'向上移出'),
              (FCode:'09';FText:'向上擦除'), (FCode:'0a';FText:'向下擦除'),
              (FCode:'0b';FText:'从上下向中间'), (FCode:'0c';FText:'从中间向上下'),
              (FCode:'0d';FText:'水平百叶窗'), (FCode:'0e';FText:'垂直百叶窗'));

  cTimeChar: array[0..1] of TCodeText = ((FCode:'00';FText:'汉字'),
             (FCode:'01';FText:'字符'));
  //时钟格式
  cDispMode: array[0..1] of TCodeText = ((FCode:'00';FText:'固定显示'),
             (FCode:'01';FText:'跟随模式'));
  //显示模式
  cDispPos: array[0..8] of TCodeText = ((FCode:'00';FText:'上端居左'),
            (FCode:'01';FText:'上端居中'), (FCode:'02';FText:'上端居右'),
            (FCode:'03';FText:'中间居左'), (FCode:'04';FText:'中间居中'),
            (FCode:'05';FText:'中间居右'), (FCode:'06';FText:'下端居左'),
            (FCode:'07';FText:'下端居中'), (FCode:'08';FText:'下端居右'));
  //显示位置

//------------------------------------------------------------------------------
const
  cSendInterval_Long = 4200;
  cSendInterval_Short = 1000; //发送超时等待

  cItemColorList: array[0..2] of TColor = (clRed, clGreen, clYellow);
  //颜色列表

//------------------------------------------------------------------------------
type
  TSysParam = record
    FAppTitle: string;                            //程序标题
    FMainTitle: string;                           //主窗口
    FCopyLeft: string;                            //状态栏.版权
    FCopyRight: string;                           //关于.版权

    FIsAdmin: Boolean;                            //管理员登录
    FCOMMPort: string;                            //连接端口
    FCOMMBote: Integer;                           //传输波特率

    FScreenWidth: Integer;
    FScreenHeight: Integer;                       //屏幕宽高

    FEnableClock: Boolean;
    FClockChar: string;
    FClockMode: string;
    FClockPos: string;
    FClockYear: string;
    FClockMonth: string;
    FClockDay: string;
    FClockWeek: string;
    FClockTime: string;                           //时钟参数
    FClockSYear: string;
    FClockSMonth: string;
    FClockSDay: string;
    FClockSHour: string;
    FClockSMin: string;
    FClockSSec: string;
    FClockSWeek: string;                          //时钟数据

    FEnablePD: Boolean;
    FPlayDays: string;                            //播放天数
  end;

var
  gPath: string;                                  //程序所在路径
  gSysParam: TSysParam;                           //系统参数

  gIsSending: Boolean = False;                    //发送状态
  gSendInterval: Word = cSendInterval_Short;      //发送超时
  gStatusBar: TdxStatusBar;                       //全局使用状态栏

  //xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
  sHint: string;                      //多语言常量
  sAsk: string;
  sWarn: string;
  sError: string;

//------------------------------------------------------------------------------
procedure SetRStringMultiLang;
//常量多语言
procedure FillColorList(const nList: TStrings);
//填充颜色
function GetColorIndex(const nList: TStrings; const nColor: TColor): Integer;
//设置颜色
procedure ShowMsgOnLastPanelOfStatusBar(const nMsg: string);
procedure StatusBarMsg(const nMsg: string; const nIdx: integer);
//在状态栏显示信息

resourcestring
  sProgID           = 'HBEdit';                   //程序标示
  sAppTitle         = '汉邦电子';                 //任务栏
  sMainTitle        = '图文编辑器';               //主窗口

  sConfigFile       = 'Config.ini';               //主配置
  sFormConfig       = 'Forms.ini';                //窗体配置
  sBackImage        = 'bg.bmp';                   //背景

  {*语言标记*}
  sMLMain           = 'fFormMain';
  sMLCommon         = 'Common';

  {*默认标题*}
  rsHint            = '提示';
  rsAsk             = '询问';
  rsWarn            = '警告';
  rsError           = '错误';

  sCorConcept       = '※.科技演绎 技术创新 真诚服务 共创未来';
                                                  //企业理念

  sCopyRight        = '※.版权所有: 汉邦电子';    //版权所有
  sInvalidConfig    = '配置文件无效或已经损坏';   //配置文件无效
  
implementation

//Desc: 常量字符串翻译
procedure SetRStringMultiLang;
begin
  sHint := ML(rsHint, sMLCommon);
  sAsk := ML(rsAsk);
  sWarn := ML(rsWarn);
  sError := ML(rsError);
end;

//Desc: 将cItemColorList的颜色填充到nList中
procedure FillColorList(const nList: TStrings);
var nIdx: integer;
begin
  nList.Clear;
  for nIdx:=Low(cItemColorList) to High(cItemColorList) do
  begin
    nList.AddObject(IntToStr(nIdx), TObject(cItemColorList[nIdx]))
  end;
end;

//Desc: 检索nColor在nList中的索引
function GetColorIndex(const nList: TStrings; const nColor: TColor): Integer;
var i: integer;
begin
  Result := -1;
  for i:=nList.Count - 1 downto 0 do
   if nList.Objects[i] = TObject(nColor) then
   begin
     Result := i; Break;
   end;
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
