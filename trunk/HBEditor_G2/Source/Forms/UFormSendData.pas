{*******************************************************************************
  作者: dmzn@163.com 2009-11-10
  描述: 发送数据
*******************************************************************************}
unit UFormSendData;

{$I Link.inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  ULibFun, UDataModule, USysConst, UProtocol, UMovedItems, UMovedControl,
  UFormWait, UFormTextEditor, UFormSetWH, UFormConnTest, GIFImage, UFormBorder,
  UMgrLang, UMgrFontSmooth, UBoderControl, ComCtrls, StdCtrls;

type
  TfFormSendData = class(TForm)
    GroupBox1: TGroupBox;
    BtnSend: TButton;
    BtnExit: TButton;
    Label2: TLabel;
    EditDevice: TComboBox;
    Label1: TLabel;
    ListItems: TListView;
    Check1: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnExitClick(Sender: TObject);
    procedure BtnSendClick(Sender: TObject);
  private
    { Private declarations }
    FScreen: PScreenItem;
    //屏幕对象
    FItemList: TList;
    //组件列表
    procedure InitFormData;
    //初始化数据
    procedure OnTrans(const nItem: TComponent; var nNext: Boolean);
    //翻译
  public
    { Public declarations }
  end;

function ShowSendDataForm(const nScreen: PScreenItem;
  const nItems: TList): Boolean;
function SendDataToDevice(const nScreen: PScreenItem; const nDevice: Integer;
  const nItems: TList): Boolean;
function ReadDeviceStatus(const nScreen: PScreenItem; const nDevice: Integer;
  var nStatus: THead_Respond_ReadStatus; var nHint: string): Boolean;
//入口函数

var
  gIsSending: Boolean = False;
  //发送中
  gNeedAdjustWH: Boolean = False;
  //需校正宽高

implementation

{$R *.dfm}

type
  TPictureDataItem = record
    FData: PPictureData;
    FBuffer: TDynamicBitmapArray;
  end;

const
  cThreshole_Red   = 32;
  cThreshole_Green = 32;
  cThreshole_Blue  = 32; //三色阀值

var
  gInvertScan: Boolean = False;
  //反相扫描

//------------------------------------------------------------------------------
//Date: 2009-11-18
//Parm: 屏幕索引;组件列表
//Desc: 向nScreen发送nItems列表指定的组件数据
function ShowSendDataForm(const nScreen: PScreenItem;
  const nItems: TList): Boolean;
begin
  with TfFormSendData.Create(Application) do
  begin
    Caption := ML('发送数据');
    FItemList := nItems;
    FScreen := nScreen;

    InitFormData;
    Result := ShowModal = mrOk;
    Free;
  end;
end;

//------------------------------------------------------------------------------
procedure TfFormSendData.FormCreate(Sender: TObject);
begin
  LoadFormConfig(Self);
  gMultiLangManager.SectionID := Name;

  gMultiLangManager.OnTransItem := OnTrans;
  gMultiLangManager.TranslateAllCtrl(Self);
  gMultiLangManager.OnTransItem := nil;  
end;

procedure TfFormSendData.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if gIsSending then
       Action := caNone
  else SaveFormConfig(Self);
end;

procedure TfFormSendData.BtnExitClick(Sender: TObject);
begin
  Close;
end;

//Desc: 翻译
procedure TfFormSendData.OnTrans(const nItem: TComponent; var nNext: Boolean);
var nIdx: Integer;
begin
  if nItem = ListItems then
  begin
    nNext := False;
    for nIdx:=ListItems.Columns.Count - 1 downto 0 do
      ListItems.Columns[nIdx].Caption := ML(ListItems.Columns[nIdx].Caption);
    //xxxxx
  end;
end;

//------------------------------------------------------------------------------
//Desc: 初始化界面
procedure TfFormSendData.InitFormData;
var nStr: string;
    nIdx: integer;
    nItem: PMovedItemData;
begin
  Check1.Checked := gInvertScan;
  EditDevice.Clear;
  EditDevice.Items.Add(ML('全部设备'));
  
  for nIdx:=Low(FScreen.FDevice) to High(FScreen.FDevice) do
  begin
    nStr := Format('%d-%s', [FScreen.FDevice[nIdx].FID, FScreen.FDevice[nIdx].FName]);
    EditDevice.Items.Add(nStr);
  end;

  EditDevice.ItemIndex := 0;
  ListItems.Items.Clear;

  for nIdx:=0 to FItemList.Count - 1 do
  with ListItems.Items.Add do
  begin
    nItem := FItemList[nIdx];
    Caption := IntToStr(nIdx);
    SubItems.Add(TZnMovedControl(nItem.FItem).ShortName);
  end;
end;

//Desc: 发送数据
procedure TfFormSendData.BtnSendClick(Sender: TObject);
begin
  ShowWaitForm(ML('数据发送中'));
  try
    gInvertScan := Check1.Checked;
    BtnSend.Enabled := False;

    if SendDataToDevice(FScreen, EditDevice.ItemIndex - 1, FItemList) then
    begin
      ModalResult := mrOk;
      ShowMsg(ML('发送成功'), sHint);
    end;
  finally
    CloseWaitForm;
    BtnSend.Enabled := True;
  end;
end;

//------------------------------------------------------------------------------
//Desc: 用nData构建一个字节
function MakeByte(const nData: TByteData): Byte;
var i,nLen: integer;
begin
  Result := 255;
  nLen := High(nData);

  for i:=Low(nData) to nLen do
  if nData[i] = 1 then
       Result := Result or cByteMask[i]
  else Result := Result and (255 xor cByteMask[i]);
end;

//Desc: 将nData放入nByte字节组中
procedure CharToByte(const nData: string; var nByte: TByteData);
var nIdx: integer;
begin
  for nIdx:=1 to 8 do
    nByte[nIdx - 1] := StrToInt(nData[nIdx]);
end;

//Desc: 用nData构建nArray字节组
procedure MakeByteArray(const nData: string; var nArray: TDynamicByteArray);
var nStr: string;
    nBit: TByteData;
    i,nIdx,nLen: integer;
begin
  nLen := Length(nData);
  if nLen mod 8 = 0 then
       nStr := nData
  else nStr := nData + StringOfChar('0', 8 - nLen mod 8);

  nLen := Length(nStr);
  i := nLen div 8;
  SetLength(nArray, i);

  nIdx := 0;
  for i:=1 to nLen do
   if i mod 8 = 0 then
   begin
     CharToByte(Copy(nStr, nIdx * 8 + 1, 8), nBit);
     nArray[nIdx] := MakeByte(nBit);
     Inc(nIdx);
   end;
end;

//------------------------------------------------------------------------------
//Desc: 合并nS数据到nD中
procedure CombinByteArray(var nS,nD: TDynamicByteArray);
var nInt,nLen: integer;
begin
  nInt := Length(nS);
  nLen := Length(nD);
  
  SetLength(nD, nInt + nLen);
  Move(nS[Low(nS)], nD[nLen], nInt);
end;

//Desc: 测试nColor中是否有nFix颜色分量
function HasFixColor(const nFix,nColor: TColor): Boolean;
var nVal: Byte;
begin
  case nFix of
   clRed:
    begin
      nVal := GetRValue(nColor);
      Result := nVal >= cThreshole_Red;
    end;
   clGreen:
    begin
      nVal := GetGValue(nColor);
      Result := nVal >= cThreshole_Green;
    end;
   clBlue:
    begin
      nVal := GetBValue(nColor);
      Result := nVal >= cThreshole_Blue;
    end else
    begin
      Result := False; Exit;
    end;
  end;
end;

//Desc: 使用单色编码扫描nBmp,存入nData缓冲中
procedure ScanWithSingleMode(const nBmp: TBitmap; const nBgColor: TColor;
 var nData: TDynamicByteArray);
var nBuf: string;
    nX,nY: integer;
    nBits: TDynamicByteArray;
begin
  SetLength(nData, 0);
  SetLength(nBuf, nBmp.Width);

  for nY :=0 to nBmp.Height - 1 do
  begin
    for nX:=0 to nBmp.Width - 1 do
    begin
      if nBmp.Canvas.Pixels[nX, nY] = nBgColor then
           nBuf[nX + 1] := '1'
      else nBuf[nX + 1] := '0';

      if gInvertScan then
       if nBuf[nX + 1] = '0' then
            nBuf[nX + 1] := '1'
       else nBuf[nX + 1] := '0';
    end;

    MakeByteArray(nBuf, nBits);
    CombinByteArray(nBits, nData);
  end;
end;

//Desc: 使用双色编码扫描nBmp,存入nData缓冲中
procedure ScanWithDoubleMode(const nBmp: TBitmap; var nData: TDynamicByteArray);
var nX,nY: integer;
    nColor: Integer;
    nSR,nSG: string;
    nBits: TDynamicByteArray;
begin
  SetLength(nData, 0);
  SetLength(nSR, nBmp.Width);
  SetLength(nSG, nBmp.Width);

  for nY :=0 to nBmp.Height - 1 do
  begin
    for nX:=0 to nBmp.Width - 1 do
    begin
      nColor := ColorToRGB(nBmp.Canvas.Pixels[nX, nY]);
      if HasFixColor(clRed, nColor) then
           nSR[nX + 1] := '0'
      else nSR[nX + 1] := '1';

      if HasFixColor(clGreen, nColor) then
           nSG[nX + 1] := '0'
      else nSG[nX + 1] := '1';

      if gInvertScan then
       if nSR[nX + 1] = '0' then
            nSR[nX + 1] := '1'
       else nSR[nX + 1] := '0';

      if gInvertScan then
       if nSG[nX + 1] = '0' then
            nSG[nX + 1] := '1'
       else nSG[nX + 1] := '0';
    end;

    MakeByteArray(nSR, nBits);
    CombinByteArray(nBits, nData);

    MakeByteArray(nSG, nBits);
    CombinByteArray(nBits, nData);
  end;
end;

//Desc: 使用全色编码扫描nBmp,存入nData缓冲中
procedure ScanWithFullMode(const nBmp: TBitmap; var nData: TDynamicByteArray);
var nX,nY: integer;
    nColor: Integer;
    nSR,nSG,nSB: string;
    nBits: TDynamicByteArray;
begin
  SetLength(nData, 0);
  SetLength(nSR, nBmp.Width);
  SetLength(nSG, nBmp.Width);
  SetLength(nSB, nBmp.Width);

  for nY :=0 to nBmp.Height - 1 do
  begin
    for nX:=0 to nBmp.Width - 1 do
    begin
      nColor := ColorToRGB(nBmp.Canvas.Pixels[nX, nY]);
      if HasFixColor(clRed, nColor) then
           nSR[nX + 1] := '0'
      else nSR[nX + 1] := '1';

      if HasFixColor(clGreen, nColor) then
           nSG[nX + 1] := '0'
      else nSG[nX + 1] := '1';

      if HasFixColor(clBlue, nColor) then
           nSB[nX + 1] := '0'
      else nSB[nX + 1] := '1';

      if gInvertScan then
       if nSR[nX + 1] = '0' then
            nSR[nX + 1] := '1'
       else nSR[nX + 1] := '0';

      if gInvertScan then
       if nSG[nX + 1] = '0' then
            nSG[nX + 1] := '1'
       else nSG[nX + 1] := '0';

      if gInvertScan then
       if nSB[nX + 1] = '0' then
            nSB[nX + 1] := '1'
       else nSB[nX + 1] := '0';
    end;

    MakeByteArray(nSR, nBits);
    CombinByteArray(nBits, nData);

    MakeByteArray(nSG, nBits);
    CombinByteArray(nBits, nData);

    MakeByteArray(nSB, nBits);
    CombinByteArray(nBits, nData);
  end;
end;

//------------------------------------------------------------------------------
//Desc: 将nBmp按照nW,nH大小拆分,结果存入nData中.
function SplitPicture(const nBmp: TBitmap; const nW,nH: Integer;
 var nData: TDynamicBitmapArray): Boolean;
var nSR,nDR: TRect;
    nL,nT,nIdx: integer;
begin
  nT := 0;
  SetLength(nData, 0);    
  
  while nT < nBmp.Height do
  begin
    nL := 0;

    while nL < nBmp.Width do
    begin
      nIdx := Length(nData);
      SetLength(nData, nIdx + 1);

      nData[nIdx] := TBitmap.Create;
      nData[nIdx].Width := nW;
      nData[nIdx].Height := nH;

      nSR := Rect(nL, nT, nL + nW, nT + nH);
      nDR := Rect(0, 0, nW, nH);

      nData[nIdx].Canvas.CopyRect(nDR, nBmp.Canvas, nSR);
      //复制区域图片
      Inc(nL, nW); 
    end;

    Inc(nT, nH);
  end;

  Result := Length(nData) > 0;
end;

//Desc: 扫描文本组件nItem的数据,以图片方式存入nData中
function BuildTextItemData(const nItem: PMovedItemData;
 var nData: TDynamicBitmapDataArray): Boolean;
var nText: string;
    nBmp: TBitmap;
    nTItem: TTextMovedItem;
    nBuf: TDynamicBitmapArray;
    i,nCount,nIdx,nW,nNum: Integer;
begin
  nTItem := TTextMovedItem(nItem.FItem);
  try
    nText := nTItem.Text;
    if not nTItem.SplitText then
    begin
      Result := True; Exit;
    end;

    nBmp := nil;
    SetLength(nData, 0);
    nCount := nTItem.Lines.Count - 1;

    for i:=0 to nCount do
    try
      nTItem.Text := nTItem.Lines[i];
      nBmp := TBitmap.Create;
      nBmp.Canvas.Font.Assign(nTItem.Font);

      nW := nBmp.Canvas.TextWidth(nTItem.Text);
      nNum := Trunc(nW / nTItem.Width);
      if nW mod nTItem.Width <> 0 then Inc(nNum);
      //不够整屏则补一屏

      nBmp.Height := nTItem.Height;
      nBmp.Width := nTItem.Width * nNum;
      nTItem.DoPaint(nBmp.Canvas, Rect(0, 0, nBmp.Width, nBmp.Height));
      //绘制内容
      
      if SplitPicture(nBmp, nTItem.Width, nTItem.Height, nBuf) then
      begin
        nIdx := Length(nData);
        nNum := nIdx + Length(nBuf);
        SetLength(nData, nNum);

        nW := 0;
        while nIdx < nNum do
        begin
          nData[nIdx].FBitmap := nBuf[nW];
          Inc(nW);
          
          nData[nIdx].FModeEnter := nTItem.ModeEnter;
          nData[nIdx].FModeExit := nTItem.ModeExit;
          nData[nIdx].FSpeedEnter := nTItem.SpeedEnter;
          nData[nIdx].FSpeedExit := nTItem.SpeedExit;
          nData[nIdx].FKeedTime := nTItem.KeedTime;
          nData[nIdx].FModeSerial := nTItem.ModeSerial; Inc(nIdx);
        end;
      end; //拆分图片
    finally
      nBmp.Free;
    end;

    Result := Length(nData) > 0;
    if not Result then
      raise Exception.Create('');
    nTItem.Text := nText;
  except
    Result := False;
    nTItem.Text := nText;

    nText := ML('扫描组件[%s]时发生错误,无法生成图片数据!!');
    ShowDlg(Format(nText, [nItem.FItem.ShortName]), sHint);
  end;
end;

//Desc: 将nItem中nPic数据项扫描为图片组
function ScanPictureData(const nItem: TPictureMovedItem; const nPic: PPictureData;
 var nData: TDynamicBitmapArray): Boolean;
var nRect: TRect;
    nBmp: TPicture;
    nGif: TGIFImage;
    i,nCount,nLen: integer;
begin
  nBmp := nil;
  Result := False;

  if nPic.FType = ptPic then
  try
    nBmp := TPicture.Create;
    nBmp.LoadFromFile(nPic.FFile);

    if nBmp.Graphic is TGIFImage then
    begin
      nGif := TGIFImage(nBmp.Graphic);
      SetLength(nData, 0);

      nCount := nGif.Images.Count - 1;
      for i:=0 to nCount do
      begin
        nLen := Length(nData);
        SetLength(nData, nLen + 1);

        nData[nLen] := TBitmap.Create;
        nData[nLen].Width := nItem.Width;
        nData[nLen].Height := nItem.Height;

        nRect := Rect(0, 0, nItem.Width, nItem.Height);
        nData[nLen].Canvas.StretchDraw(nRect, nGif.Images[i].Bitmap);
      end;

      Result := Length(nData) > 0;
      Exit;
    end; //Gif动画

    SetLength(nData, 1);
    nData[0] := TBitmap.Create;
    nData[0].Width := nItem.Width;
    nData[0].Height := nItem.Height;
    
    nRect := Rect(0, 0, nItem.Width, nItem.Height);
    nData[0].Canvas.StretchDraw(nRect, nBmp.Graphic);

    Result := True;
    Exit;
    //图片扫描完毕
  finally
    if Assigned(nBmp) then nBmp.Free;
  end;

  if nPic.FType = ptText then
    Result := LoadFileToBitmap(nPic.FFile, nData, nItem.Width, nItem.Height,
                                False, nPic.FSingleLine);
  //扫描文本
end;

//Desc: 扫描图文组件nItem的数据,以图片方式存入nData中
function BuildPictureItemData(const nItem: PMovedItemData;
 var nData: TDynamicBitmapDataArray): Boolean;
var nStr: string;
    nPic: PPictureData;
    nPItem: TPictureMovedItem;
    nBuf: TDynamicBitmapArray;
    i,nCount,nIdx,nLen,nNum: Integer;
begin
  nPItem := TPictureMovedItem(nItem.FItem);
  try
    SetLength(nData, 0);
    nCount := nPItem.DataList.Count - 1;

    if nCount < 0 then
    begin
      Result := True; Exit;
    end;

    for i:=0 to nCount do
    begin
      nPic := nPItem.DataList[i];
      if not ScanPictureData(nPItem, nPic, nBuf) then Continue;

      nIdx := Length(nData);
      nLen := nIdx + Length(nBuf);
      SetLength(nData, nLen);

      nNum := 0;
      while nIdx < nLen do
      begin
        nData[nIdx].FBitmap := nBuf[nNum];
        Inc(nNum);
          
        nData[nIdx].FModeEnter := nPic.FModeEnter;
        nData[nIdx].FModeExit := nPic.FModeExit;
        nData[nIdx].FSpeedEnter := nPic.FSpeedEnter;
        nData[nIdx].FSpeedExit := nPic.FSpeedExit;
        nData[nIdx].FKeedTime := nPic.FKeedTime;
        nData[nIdx].FModeSerial := nPic.FModeSerial; Inc(nIdx);
      end;
    end;
    
    Result := Length(nData) > 0;
    if not Result then
      raise Exception.Create('');
    //xxxxx
  except
    Result := False;
    nStr := ML('扫描组件[%s]时发生错误,无法生成图片数据!!');
    ShowDlg(Format(nStr, [nItem.FItem.ShortName]), sHint);
  end;
end;

//Desc: 扫描动画组件nItem的数据,以图片方式存入nData中
function BuildAnimateItemData(const nItem: PMovedItemData;
 var nData: TDynamicBitmapDataArray): Boolean;
var nStr: string;
    nRect: TRect;
    nGif: TGIFImage;
    i,nCount,nLen: Integer;
    nAnimate: TAnimateMovedItem;
begin
  nGif := nil;
  SetLength(nData, 0);
  nAnimate := TAnimateMovedItem(nItem.FItem);
  try
    if not FileExists(nAnimate.ImageFile) then
    begin
      Result := True; Exit;
    end;

    nGif := TGIFImage.Create;
    nGif.LoadFromFile(nAnimate.ImageFile);
    nCount := nGif.Images.Count - 1;

    for i:=0 to nCount do
    begin
      nLen := Length(nData);
      SetLength(nData, nLen + 1);
      FillChar(nData[nLen], SizeOf(TBitmapDataItem), #0);

      nData[nLen].FBitmap := TBitmap.Create;
      nData[nLen].FBitmap.Width := nAnimate.Width;
      nData[nLen].FBitmap.Height := nAnimate.Height;

      nRect := Rect(0, 0, nAnimate.Width, nAnimate.Height);
      nData[nLen].FBitmap.Canvas.StretchDraw(nRect, nGif.Images[i].Bitmap);
    end;
    
    Result := Length(nData) > 0;
    if not Result then
      raise Exception.Create('');
    //xxxxx
  except
    nGif.Free;
    Result := False;
    
    nStr := ML('扫描组件[%s]时发生错误,无法生成图片数据!!');
    ShowDlg(Format(nStr, [nItem.FItem.ShortName]), sHint);
  end;
end;

//Desc: 发送nData图片数据到下位机
function SendPictureDataToDevice(nItem: PMovedItemData; nScreen: PScreenItem;
  nDevice: Integer; nData: TDynamicBitmapDataArray): Boolean;
var nStr: string;
    nCRC: Word;
    nIdx,nCount,nLen: integer;
    nBuf: TDynamicByteArray;
    nSend: THead_Send_PicData;
    nRespond: THead_Respond_PicData;
begin
  Result := True;
  FillChar(nSend, cSize_Head_Send_PicData, #0);

  nSend.FHead := Swap(cHead_DataSend); 
  nSend.FCardType := nScreen.FCard;
  nSend.FCommand := cCmd_SendPicData;

  if nDevice > -1 then
       nSend.FDevice := Swap(nScreen.FDevice[nDevice].FID)
  else nSend.FDevice := sFlag_BroadCast;

  nSend.FAllID := Swap(Length(nData));
  nSend.FLevel := nItem.FLevel;
  nSend.FIndexID := nItem.FTypeIdx;
  
  with nItem^ do
  begin
    nSend.FPosX := Swap(FPosX);
    nSend.FPosY := Swap(FPosY);
    nSend.FWidth := Swap(FWidth);
    nSend.FHeight := Swap(FHeight);
  end;

  try
    nCount := High(nData);
    for nIdx:=Low(nData) to nCount do
    begin
      nStr := ML('生成组件[ %s ]第[ %d ]幕数据时失败!!');
      nStr := Format(nStr, [nItem.FItem.ShortName, nIdx]);

      case nScreen.FType of
        stSingle: ScanWithSingleMode(nData[nIdx].FBitmap, nItem.FItem.Color, nBuf);
        stDouble: ScanWithDoubleMode(nData[nIdx].FBitmap, nBuf);
        stFull: ScanWithFullMode(nData[nIdx].FBitmap, nBuf);
      end;

      nSend.FNowID := Swap(nIdx);
      nSend.FLen := Swap(Length(nBuf) + cSize_Head_Send_PicData + 2);
      //调整协议数据

      nSend.FMode[0] := nData[nIdx].FModeEnter;
      nSend.FMode[1] := nData[nIdx].FSpeedEnter;
      nSend.FMode[2] := nData[nIdx].FKeedTime;
      nSend.FMode[3] := nData[nIdx].FModeExit;
      nSend.FMode[4] := nData[nIdx].FSpeedExit;
      nSend.FMode[5] := nData[nIdx].FModeSerial;
      nSend.FMode[6] := Ord(nScreen.FType) + 1;
      //填充模式

      nStr := '发送组件[ %s ]第[ %d ]幕数据时失败!!';
      nStr := Format(nStr, [nItem.FItem.ShortName, nIdx]);
      FDM.FWaitCommand := nSend.FCommand;
      Result := FDM.Comm1.WriteCommData(@nSend, cSize_Head_Send_PicData);

      if Result then
      begin
        nLen := Length(nBuf);
        FDM.SetWaitTime(nLen);
        Result := FDM.Comm1.WriteCommData(@nBuf[Low(nBuf)], nLen);
      end;
      //图片数据

      if Result then
      begin
        nCRC := 0;
        Result := FDM.Comm1.WriteCommData(@nCRC, SizeOf(nCRC));
      end;
      //校验位
      if not Result then Break;

      Result := FDM.WaitForTimeOut(nStr);
      if not Result then
      begin
        nStr := ML('发送组件[ %s ]第[ %d ]幕数据时下位机无响应!!');
        nStr := Format(nStr, [nItem.FItem.ShortName, nIdx]); Break;
      end;

      nStr := ML('组件[ %s ]第[ %d ]幕数据已成功发送,但下位机处理异常!!');
      nStr := Format(nStr, [nItem.FItem.ShortName, nIdx]);
      Move(FDM.FValidBuffer[0], nRespond, cSize_Head_Respond_PicData);
      
      Result := nRespond.FFlag = sFlag_OK;
      if Result then
      begin
        nStr := ML('※.发送组件[ %s ]第[ %d/%d ]幕数据成功!!');
        nStr := Format(nStr, [nItem.FItem.ShortName, nIdx, nCount]);
        ShowMsgOnLastPanelOfStatusBar(nStr);
      end else Break;
    end;
  except
    //ignor any Error
  end;

  if not Result then
    ShowDlg(nStr, sHint);
  //xxxxx
end;

//Desc: 发送nData动画数据到下位机
function SendAnimateDataToDevice(nItem: PMovedItemData; nScreen: PScreenItem;
  nDevice: Integer; nData: TDynamicBitmapDataArray): Boolean;
var nStr: string;
    nCRC: Word;
    nIdx,nCount,nLen: integer;
    nBuf: TDynamicByteArray;
    nSend: THead_Send_Animate;
    nRespond: THead_Respond_Animate;
begin
  Result := True;
  FillChar(nSend, cSize_Head_Send_Animate, #0);

  nSend.FHead := Swap(cHead_DataSend); 
  nSend.FCardType := nScreen.FCard;
  nSend.FCommand := cCmd_SendAnimate;

  if nDevice > -1 then
       nSend.FDevice := Swap(nScreen.FDevice[nDevice].FID)
  else nSend.FDevice := sFlag_BroadCast;
  
  nSend.FAllID := Swap(Length(nData));
  nSend.FLevel := nItem.FLevel;
  nSend.FIndexID := nItem.FTypeIdx;
  nSend.FSpeed := TAnimateMovedItem(nItem.FItem).Speed;
  
  with nItem^ do
  begin
    nSend.FPosX := Swap(FPosX);
    nSend.FPosY := Swap(FPosY);
    nSend.FWidth := Swap(FWidth);
    nSend.FHeight := Swap(FHeight);
  end;

  try
    nCount := High(nData);
    for nIdx:=Low(nData) to nCount do
    begin
      nStr := ML('生成组件[ %s ]第[ %d ]幕数据时失败!!');
      nStr := Format(nStr, [nItem.FItem.ShortName, nIdx]);

      case nScreen.FType of
        stSingle: ScanWithSingleMode(nData[nIdx].FBitmap, nItem.FItem.Color, nBuf);
        stDouble: ScanWithDoubleMode(nData[nIdx].FBitmap, nBuf);
        stFull: ScanWithFullMode(nData[nIdx].FBitmap, nBuf);
      end;

      nSend.FNowID := Swap(nIdx);
      nSend.FLen := Swap(Length(nBuf) + cSize_Head_Send_Animate + 2);
      //调整协议数据

      nStr := ML('发送组件[ %s ]第[ %d ]幕数据时失败!!');
      nStr := Format(nStr, [nItem.FItem.ShortName, nIdx]);
      FDM.FWaitCommand := nSend.FCommand;
      Result := FDM.Comm1.WriteCommData(@nSend, cSize_Head_Send_Animate);

      if Result then
      begin
        nLen := Length(nBuf);
        FDM.SetWaitTime(nLen);
        Result := FDM.Comm1.WriteCommData(@nBuf[Low(nBuf)], nLen);
      end;
      //图片数据

      if Result then
      begin
        nCRC := 0;
        Result := FDM.Comm1.WriteCommData(@nCRC, SizeOf(nCRC));
      end;
      //校验位
      if not Result then Break;

      Result := FDM.WaitForTimeOut(nStr);
      if not Result then
      begin
        nStr := ML('发送组件[ %s ]第[ %d ]幕数据时下位机无响应!!');
        nStr := Format(nStr, [nItem.FItem.ShortName, nIdx]); Break;
      end;

      nStr := ML('组件[ %s ]第[ %d ]幕数据已成功发送,但下位机处理异常!!');
      nStr := Format(nStr, [nItem.FItem.ShortName, nIdx]);
      Move(FDM.FValidBuffer[0], nRespond, cSize_Head_Respond_Animate);
      
      Result := nRespond.FFlag = sFlag_OK;
      if Result then
      begin
        nStr := ML('※.发送动画[ %s ]第[ %d/%d ]幕数据成功!!');
        nStr := Format(nStr, [nItem.FItem.ShortName, nIdx, nCount]);
        ShowMsgOnLastPanelOfStatusBar(nStr);
      end else Break;
    end;
  except
    //ignor any Error
  end;

  if not Result then
    ShowDlg(nStr, sHint);
  //xxxxx
end;

//Desc: 获取nColor对应的索引
function ColorOrder(const nColor: TColor): Byte;
begin
  case nColor of
   clRed: Result := 1;
   clGreen: Result := 2;
   clYellow: Result := 3 else Result := 1;
  end;
end;

//Desc: 发送模拟时钟到下位机
function SendClockItemToDevice(nItem: PMovedItemData; nScreen: PScreenItem;
  nDevice: Integer): Boolean;
var nStr: string;
    nCRC: Word;
    nBmp: TBitmap;
    nLen: Integer;
    nCItem: TClockMovedItem;
    nSend: THead_Send_Clock;
    nBuf: TDynamicByteArray;
    nRespond: THead_Respond_Clock;
begin
  Result := True;
  nCItem := TClockMovedItem(nItem.FItem);
  FillChar(nSend, cSize_Head_Send_Clock, #0);

  nSend.FHead := Swap(cHead_DataSend);
  nSend.FCardType := nScreen.FCard;
  
  if nDevice > -1 then
       nSend.FDevice := Swap(nScreen.FDevice[nDevice].FID)
  else nSend.FDevice := sFlag_BroadCast;

  nSend.FCommand := cCmd_SendSimuClock;
  nSend.FLevel := nItem.FLevel;
  nSend.FIndexID := nItem.FTypeIdx;

  with nItem^ do
  begin
    nSend.FPosX := Swap(FPosX);
    nSend.FPosY := Swap(FPosY);
    nSend.FWidth := Swap(FWidth);
    nSend.FHeight := Swap(FHeight);
  end;

  nSend.FParam := Swap($12);
  nSend.FPointX := Swap(nCItem.DotPoint.X);
  nSend.FPointY := Swap(nCItem.DotPoint.Y);
  nSend.FZhenColor[0] := ColorOrder(nCItem.ColorHour);
  nSend.FZhenColor[1] := ColorOrder(nCItem.ColorMin);
  nSend.FZhenColor[2] := ColorOrder(nCItem.ColorSec);

  try
    nBmp := nil;
    SetLength(nBuf, 0);

    if Assigned(nCItem.Image.Graphic) then
    try
      nBmp := TBitmap.Create;
      nBmp.Width := nCItem.Width;
      nBmp.Height := nCItem.Height;
      nBmp.Canvas.StretchDraw(nCItem.ClientRect, nCItem.Image.Graphic);

      case nScreen.FType of
        stSingle: ScanWithSingleMode(nBmp, nItem.FItem.Color, nBuf);
        stDouble: ScanWithDoubleMode(nBmp, nBuf);
        stFull: ScanWithFullMode(nBmp, nBuf);
      end;
    finally
      nBmp.Free;
    end;

    nStr := ML('发送组件[ %s ]第[ %d ]幕数据时失败!!');
    nSend.FParam := Swap(Length(nBuf) + 8);
    nSend.FLen := Swap(cSize_Head_Send_Clock + Length(nBuf) + 2);

    FDM.FWaitCommand := nSend.FCommand;
    Result := FDM.Comm1.WriteCommData(@nSend, cSize_Head_Send_Clock);

    if Result and (Length(nBuf) > 0) then
    begin
      nLen := Length(nBuf);
      FDM.SetWaitTime(nLen);
      Result := FDM.Comm1.WriteCommData(@nBuf[Low(nBuf)], nLen);
    end;
    //图片数据

    if Result then
    begin
      nCRC := 0;
      Result := FDM.Comm1.WriteCommData(@nCRC, SizeOf(nCRC));
    end;
    //校验位
    
    if not Result then
      raise Exception.Create('');
    //xxxxx

    Result :=  FDM.WaitForTimeOut(nStr);
    if not Result then
    begin
      nStr := ML('发送组件[ %s ]时下位机无响应!!');
      nStr := Format(nStr, [nItem.FItem.ShortName]);
      raise Exception.Create('');
    end;

    Move(FDM.FValidBuffer[0], nRespond, cSize_Head_Respond_Clock);
    Result := nRespond.FFlag = sFlag_OK;

    if not Result then
    begin
      nStr := ML('组件[ %s ]数据已成功发送,但下位机处理异常!!');
      nStr := Format(nStr, [nItem.FItem.ShortName]);
      raise Exception.Create('');
    end;
  except
    //ignor any Error
  end;

  if not Result then
    ShowDlg(nStr, sHint);
  //xxxxx
end;

//Desc: 发送数字时钟到下位机
function SendTimeItemToDevice(nItem: PMovedItemData; nScreen: PScreenItem;
  nDevice: Integer): Boolean;
var nStr: string;
    nTItem: TTimeMovedItem;
    nSend: THead_Send_AreaTime;
    nRespond: THead_Respond_AreaTime;
begin
  Result := True;
  nTItem := TTimeMovedItem(nItem.FItem);
  FillChar(nSend, cSize_Head_Send_AreaTime, #0);

  nSend.FHead := Swap(cHead_DataSend);
  nSend.FCardType := nScreen.FCard;
  nSend.FLen := Swap(cSize_Head_Send_AreaTime);

  if nDevice > -1 then
       nSend.FDevice := Swap(nScreen.FDevice[nDevice].FID)
  else nSend.FDevice := sFlag_BroadCast;

  nSend.FCommand := cCmd_SendAreaTime;
  nSend.FLevel := nItem.FLevel;
  nSend.FIndexID := nItem.FTypeIdx;

  with nItem^ do
  begin
    nSend.FPosX := Swap(FPosX);
    nSend.FPosY := Swap(FPosY);
    nSend.FWidth := Swap(FWidth);
    nSend.FHeight := Swap(FHeight);
  end;

  nSend.FParam := Swap($12);
  nSend.FModeChar := nTItem.ModeChar;
  nSend.FModeLine := nTItem.ModeLine;
  nSend.FModeDate := nTItem.ModeDate;
  nSend.FModeWeek := nTItem.ModeWeek;
  nSend.FModeTime := nTItem.ModeTime;
  
  try
    FDM.FWaitCommand := nSend.FCommand;
    FDM.Comm1.WriteCommData(@nSend, cSize_Head_Send_AreaTime);

    Result :=  FDM.WaitForTimeOut(nStr);
    begin
      nStr := '发送组件[ %s ]时下位机无响应!!';
      nStr := Format(nStr, [nItem.FItem.ShortName]);
    end;

    Move(FDM.FValidBuffer[0], nRespond, cSize_Head_Respond_AreaTime);
    Result := nRespond.FFlag = sFlag_OK;

    if not Result then
    begin
      nStr := ML('组件[ %s ]数据已成功发送,但下位机处理异常!!');
      nStr := Format(nStr, [nItem.FItem.ShortName]);
    end;
  except
    //ignor any Error
  end;

  if not Result then
    ShowDlg(nStr, sHint);
  //xxxxx
end;

//Desc: 发送nItem的数据到下位机
function SendItemData(nItem: PMovedItemData; nScreen: PScreenItem;
  nDevice: integer): Boolean;
var nIdx: integer;
    nReverse: Boolean;
    nData: TDynamicBitmapDataArray;
begin
  nReverse := gInvertScan;
  SetLength(nData, 0);
  try
    if nItem.FItem is TTextMovedItem then
    begin
      Result := BuildTextItemData(nItem, nData);
      //扫描数据
      if Result then
        Result := SendPictureDataToDevice(nItem, nScreen, nDevice, nData);
      //发送数据
    end else

    if nItem.FItem  is TPictureMovedItem then
    begin
      Result := BuildPictureItemData(nItem, nData);
      //扫描数据
      if Result then
        Result := SendPictureDataToDevice(nItem, nScreen, nDevice, nData);
      //图文混排
    end else

    if nItem.FItem is TAnimateMovedItem then
    begin
      gInvertScan := TAnimateMovedItem(nItem.FItem).Reverse;
      //切换扫描模式
      
      Result := BuildAnimateItemData(nItem, nData);
      //扫描数据
      if Result then
        Result := SendAnimateDataToDevice(nItem, nScreen, nDevice, nData);
      //动画
    end else

    if nItem.FItem is TClockMovedItem then
    begin
      Result := SendClockItemToDevice(nItem, nScreen, nDevice);
      //模拟时钟
    end else

    if nItem.FItem is TTimeMovedItem then
    begin
      Result := SendTimeItemToDevice(nItem, nScreen, nDevice);
      //时间组件
    end else Result := False;
  finally
    gInvertScan := nReverse;
    for nIdx:=Low(nData) to High(nData) do
      nData[nIdx].FBitmap.Free;
    //xxxxx
  end;
end;

//Desc: 发送"数据传输开始帧"
function OpenSendData(nScreen: PScreenItem; nDevice,nAreaNum: Integer): Boolean;
var nStr: string;
    nData: THead_Send_DataBegin;
    nRespond: THead_Respond_DataBegin;
begin
  {$IFDEF VCom}
  Result := True; Exit;
  {$ENDIF}

  Result := False;
  FillChar(nData, cSize_Head_Send_DataBegin, #0);

  nData.FHead := Swap(cHead_DataSend);
  nData.FLen := Swap(cSize_Head_Send_DataBegin);
  nData.FCardType := nScreen.FCard;
  nData.FColorType := Ord(nScreen.FType) + 1;

  if nDevice > -1 then
       nData.FDevice := Swap(nScreen.FDevice[nDevice].FID)
  else nData.FDevice := sFlag_BroadCast;
  
  nData.FAreaNum := nAreaNum;
  nData.FCommand := cCmd_DataBegin;  

  with FDM do
  try
    FWaitCommand := nData.FCommand;
    Result := Comm1.WriteCommData(@nData, cSize_Head_Send_DataBegin);

    if not Result then
    begin
      nStr := ML('"开始帧"数据发送失败,无法打开传输模式!!');
      ShowDlg(nStr, sHint);  Exit;
    end;

    Result := WaitForTimeOut(nStr);
    if not Result then
    begin
      nStr := ML('等待"开始帧"响应超时,无法打开传输模式!!');
      ShowDlg(nStr, sHint);  Exit;
    end;

    Move(FDM.FValidBuffer[0], nRespond, cSize_Head_Respond_DataBegin);
    Result := nRespond.FFlag = sFlag_OK;

    if Result then
    begin
      nStr := ML('※.打开传输模式,开始发送数据!');
      ShowMsgOnLastPanelOfStatusBar(nStr);
    end else
    begin
      nStr := ML('"开始帧"发送成功,但下位机打开传输模式失败!!');
      ShowDlg(nStr, sHint);  Exit;
    end;
  except
    ShowMsg(ML('无法打开传输模式'), sHint);
  end;
end;

//Desc: 发送"数据传输结束帧"
function CloseSendData(nScreen: PScreenItem; nDevice: Integer): Boolean;
var nStr: string;
    nSend: THead_Send_DataEnd;
    nRespond: THead_Respond_DataEnd;
begin
  {$IFDEF VCom}
  Result := True; Exit;
  {$ENDIF}
  
  Result := False;
  FillChar(nSend, cSize_Head_Send_DataEnd, #0);

  nSend.FHead := Swap(cHead_DataSend);
  nSend.FLen := Swap(cSize_Head_Send_DataEnd);
  nSend.FCardType := nScreen.FCard;
  nSend.FCommand := cCmd_DataEnd;

  if nDevice > -1 then
       nSend.FDevice := Swap(nScreen.FDevice[nDevice].FID)
  else nSend.FDevice := sFlag_BroadCast;

  with FDM do
  try
    FWaitCommand := nSend.FCommand;
    Result := Comm1.WriteCommData(@nSend, cSize_Head_Send_DataEnd);

    if not Result then
    begin
      nStr := ML('"结束帧"数据发送失败,无法关闭传输模式!!');
      ShowDlg(nStr, sHint);  Exit;
    end;

    Result := WaitForTimeOut(nStr);
    if not Result then
    begin
      nStr := ML('等待"结束帧"响应超时,无法关闭传输模式!!');
      ShowDlg(nStr, sHint);  Exit;
    end;

    Move(FDM.FValidBuffer[0], nRespond, cSize_Head_Respond_DataEnd);
    Result := nRespond.FFlag = sFlag_OK;

    if Result then
    begin
      nStr := ML('※.关闭传输模式,数据发送完毕!');
      ShowMsgOnLastPanelOfStatusBar(nStr);
    end else
    begin
      nStr := ML('"结束帧"发送成功,但下位机关闭传输模式失败!!');
      ShowDlg(nStr, sHint);  Exit;
    end;
  except
    ShowMsg(ML('无法关闭传输模式'), sHint);
  end;
end;

//Date: 2009-12-06
//Parm: 屏幕;设备索引
//Desc: 当nDevice>0时,同步nScreen.nDevice的宽高.
function AdjustScreenWH(const nScreen: PScreenItem; nDevice: Integer): Boolean;
var nStr: string;
    nData: THead_Respond_ConnCtrl;
begin
  if (nDevice < 0) and (not gNeedAdjustWH) then
  begin
    Result := True; Exit;
  end;

  Result := ConnectCtrl(nScreen, nDevice, nData, nStr, True);
  if not Result  then
  begin
    ShowMsg(nStr, sHint); Exit;
  end;

  if nData.FCardType <> nScreen.FCard then
  begin
    Result := False;
    ShowWaitForm('', False);

    nStr := '当前屏幕卡类型与控制器不一致,操作已取消!!' + #13#10 +
            '请在"设置屏参"菜单中修改卡类型.';
    ShowDlg(ML(nStr), sHint); Exit;
  end;

  if (nData.FScreen[0] * 8 = nScreen.FLenY) and
     (nData.FScreen[1] * 8 = nScreen.FLenX) then Exit;

  ShowWaitForm('', False);
  try
    nStr := '当前屏幕尺寸与控制器不一致,会影响内容的显示.' + #13#10 +
            '是否同步屏幕尺寸? 选择"否"将继续发送.';
    if not QueryDlg(ML(nStr), sAsk) then Exit;
  finally
    ShowWaitForm('', True);
  end;

  Result := SetDeviceWH(nScreen, nDevice, nScreen.FLenX, nScreen.FLenY, nStr);
  if not Result then ShowMsg(nStr, sHint);
end;

//Date: 2009-11-23
//Parm: 屏幕对象;设备索引;组件列表
//Desc: 向nScreen.nDevice发送nItems列表指定的组件数据
function SendDataToDevice(const nScreen: PScreenItem; const nDevice: Integer;
  const nItems: TList): Boolean;
var nStr: string;
    nPCtrl: TObject;
    i,nCount: integer;
begin
  Result := False;
  gMultiLangManager.SectionID := sMLSend;

  i := CardItemIndex(nScreen.FCard);
  if (i > -1) and (nItems.Count > cCardList[i].FLimite) then
  begin
    ShowWaitForm('', False);
    nStr := '待发送区域数为[ %d ],已超出接收卡[ %d ]个区的上限!' + #13#10#13#10 +
            '可能会导致接收卡工作异常,是否继续发送?';
    nStr := Format(ML(nStr), [nItems.Count, cCardList[i].FLimite]);

    if QueryDlg(nStr, sAsk) then
         ShowWaitForm('', True)
    else Exit;
  end;

  with FDM do
  try
    gIsSending := True;
    try
      Comm1.StopComm;
      Comm1.CommName := nScreen.FPort;
      Comm1.BaudRate := nScreen.FBote;

      {$IFNDEF VCom}
      Comm1.StartComm;
      Sleep(500);
      {$ENDIF}

      if not AdjustScreenWH(nScreen, nDevice) then Exit;
      //调整宽高
      if not OpenSendData(nScreen, nDevice, nItems.Count) then Exit;
      //无法开启传输模式

      gSmoothSwitcher.CloseSmooth;
      //关闭平滑字体
      gSendInterval := cSendInterval_Long;
      nCount := nItems.Count - 1;

      for i:=0 to nCount do
      try
        nStr := ML('※.正在发送组件[ %s ]的数据...');
        nStr := Format(nStr, [PMovedItemData(nItems[i]).FItem.ShortName]);
        ShowMsgOnLastPanelOfStatusBar(nStr);

        Result := SendItemData(nItems[i], nScreen, nDevice);
        if not Result then Break;
      except
        //ignor any error
      end;

      if not CloseSendData(nScreen, nDevice) then
        Result := False;
      //xxxxx

      nPCtrl := PMovedItemData(nItems[0]).FItem.Owner;
      if not SendBorderToDevice(nScreen, nDevice, TZnBorderControl(nPCtrl), nStr) then
      begin
        Result := False;
        ShowDlg(nStr, sError);
      end; //发送边框
    finally
      gIsSending := False;
      gSendInterval := cSendInterval_Short;
      gSmoothSwitcher.OpenSmooth;
      
      Comm1.StopComm;
      ShowMsgOnLastPanelOfStatusBar(ML(sCorConcept, sMLMain));      
    end;
  except
    ShowMsg(ML('与控制器通信失败'), sHint);
  end;
end;

//Date: 2009-12-06
//Parm: 屏幕;设备编号;状态;信息提示
//Desc: 读取nScreen.nDevice的状态,调用前需要连接Comm1.
function ReadDeviceStatus(const nScreen: PScreenItem; const nDevice: Integer;
  var nStatus: THead_Respond_ReadStatus; var nHint: string): Boolean;
var nStr: string;
    nData: THead_Send_ReadStatus;
begin
  {$IFDEF VCom}
  Result := True; Exit;
  {$ENDIF}

  Result := False;
  FillChar(nData, cSize_Head_Send_ReadStatus, #0);

  nData.FHead := Swap(cHead_DataSend);
  nData.FLen := Swap(cSize_Head_Send_ReadStatus);
  nData.FCardType := nScreen.FCard;

  if nDevice > -1 then
       nData.FDevice := Swap(nScreen.FDevice[nDevice].FID)
  else nData.FDevice := sFlag_BroadCast;
  nData.FCommand := cCmd_ReadStatus;

  with FDM do
  try
    nHint := ML('发送状态查询命令失败', sMLSend);
    FWaitCommand := nData.FCommand;

    Result := Comm1.WriteCommData(@nData, cSize_Head_Send_ReadStatus);
    if not Result then Exit;

    nHint := ML('状态查询命令响应超时', sMLSend);
    Result := WaitForTimeOut(nStr);
    if not Result then Exit;

    Move(FDM.FValidBuffer[0], nStatus, cSize_Head_Respond_ReadStatus);
    Result := nStatus.FFlag = sFlag_OK;

    if Result then
         nHint := ''
    else nHint := ML('查询控制器状态失败', sMLSend);
  except
    //ingnor any error
  end;
end;

end.
