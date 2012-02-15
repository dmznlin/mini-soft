unit UDataModule;

interface

uses
  Windows, SysUtils, Classes, Forms, UProtocol, USysConst, SPComm;

type
  TFDM = class(TDataModule)
    Comm1: TComm;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure Comm1ReceiveData(Sender: TObject; Buffer: Pointer;
      BufferLength: Word);
  private
    { Private declarations }
    FBuffer: array of Byte;
    //接收缓存
  public
    { Public declarations }
    FWaitCommand: Integer;
    //等待命令字
    FWaitResult: Boolean;
    //等待对象
    FValidBuffer: array of Byte;
    //有效数据
    procedure SetWaitTime(const nDataSize: Word);
    function WaitForTimeOut(var nMsg: string): Boolean;
    //等待超时
  end;

var
  FDM: TFDM;

implementation

{$R *.dfm}

procedure TFDM.DataModuleCreate(Sender: TObject);
begin
  //nothing
end;

procedure TFDM.DataModuleDestroy(Sender: TObject);
begin
  Comm1.StopComm;
end;

//Date: 2009-11-16
//Parm: 错误提示信息
//Desc: 重复进入等待,直到接收到有效数据
function TFDM.WaitForTimeOut(var nMsg: string): Boolean;
var nInit: Int64;
begin
  Result := False;
  nMsg := '与控制器通信超时';

  FWaitResult := False;
  nInit := GetTickCount;

  while GetTickCount - nInit < gSendInterval do
  begin
    Application.ProcessMessages;
    Result := FWaitResult;

    if Result then
         Break
    else Sleep(1);
  end;
end;

//Desc: 设置超时间隔
procedure TFDM.SetWaitTime(const nDataSize: Word);
begin
  gSendInterval := Trunc(nDataSize * 0.5);
  if gSendInterval < cSendInterval_Long then
    gSendInterval := cSendInterval_Long;
  //xxxxx
end;

procedure TFDM.Comm1ReceiveData(Sender: TObject; Buffer: Pointer;
  BufferLength: Word);
var nLen: integer;
    i,nCount: integer;
    nBase: THead_Respond_Base;
begin
  nLen := Length(FBuffer);
  SetLength(FBuffer, nLen + BufferLength);
  Move(Buffer^, FBuffer[nLen], BufferLength);

  nCount := High(FBuffer) - cSize_Respond_Base;
  //保留基本协议头的长度

  for i:=Low(FBuffer) to nCount do
  if (FBuffer[i] = cHead_DataRecv_Hi) and (FBuffer[i+1] = cHead_DataRecv_Low) then
  begin
    Move(FBuffer[i], nBase, cSize_Respond_Base);
    //取基本协议头

    case nBase.FCommand of
      cCmd_SetBorder:     //设置边框
        nLen := cSize_Head_Respond_SetBorder;
      cCmd_SetScanMode:   //扫描模式
        nLen := cSize_Head_Respond_ScanMode;
      cCmd_SetELevel:     //有效电平
        nLen := cSize_Head_Respond_ELevel;
      cCmd_ConnCtrl:      //控制器链接
        nLen := cSize_Head_Respond_ConnCtrl;
      cCmd_SetDeviceNo:   //设置设备号
        nLen := cSize_Head_Respond_SetDeviceNo;
      cCmd_ResetCtrl:     //复位控制器
        nLen := cSize_Head_Respond_ResetCtrl;
      cCmd_SetBright:     //设置亮度
        nLen := cSize_Head_Respond_SetBright;
      cCmd_SetBrightTime: //时段亮度
        nLen := cSize_Head_Respond_SetBrightTime;
      cCmd_AdjustTime:    //校准时间
        nLen := cSize_Head_Respond_AdjustTime;
      cCmd_OpenOrClose:   //开关屏幕
        nLen := cSize_Head_Respond_OpenOrClose;
      cCmd_OCTime:        //开关时间
        nLen := cSize_Head_Respond_OCTime;
      cCmd_PlayDays:      //播放天数
        nLen := cSize_Head_Respond_PlayDays;
      cCmd_ReadStatus:    //读取状态
        nLen := cSize_Head_Respond_ReadStatus;
      cCmd_SetScreenWH:   //屏幕宽高
        nLen := cSize_Head_Respond_SetScreenWH;
      cCmd_DataBegin:     //起始帧
        nLen := cSize_Head_Respond_DataBegin;
      cCmd_DataEnd:       //结束帧
        nLen := cSize_Head_Respond_DataEnd;
      cCmd_SendPicData:   //图片数据
        nLen := cSize_Head_Respond_PicData;
      cCmd_SendSimuClock:   //模拟时钟
        nLen := cSize_Head_Respond_Clock;
      cCmd_SendAnimate:   //动画数据
        nLen := cSize_Head_Respond_Animate
      else
      begin               //无法识别指令
        SetLength(FBuffer, 0); Exit;
      end;
    end;

    if Length(FBuffer) - i >= nLen then
    begin
      if nBase.FCommand = FWaitCommand then
      begin
        FWaitCommand := -1;
        SetLength(FValidBuffer, nLen);

        Move(FBuffer[i], FValidBuffer[0], nLen);
        FWaitResult := True;
      end;

      SetLength(FBuffer, 0);
      Break;
    end;
  end;

  if nLen > 100 then
    SetLength(FBuffer, 0);
  //超长则清空
end;

end.
