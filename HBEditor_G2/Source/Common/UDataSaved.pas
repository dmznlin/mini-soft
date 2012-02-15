{*******************************************************************************
  作者: dmzn@163.com 2010-5-19
  描述: 数据持久化
*******************************************************************************}
unit UDataSaved;

interface

uses
  Windows, Classes, Controls, Graphics, SysUtils, NativeXML, USysConst,
  UMovedControl, UMovedItems, UBoderControl;

type
  TScreensData = array of TScreenItem;
  TMoviesData = array of TZnBorderControl;

  TDataManager = class(TObject)
  private
    FXML: TNativeXml;
    //数据对象
    FDataFile: string;
    //数据文件
    FMovieParent: TWinControl;
    //节目容器
    FScreens: TScreensData;
    FMovies: TMoviesData;
    //屏幕&节目
  public
    constructor Create;
    destructor Destroy; override;
    //创建释放
    function SaveToFile(const nFile: string): Boolean;
    function LoadFromFile(const nFile: string): Boolean;
    //保存载入
    procedure ResetBlank(const nAll: Boolean);
    //空文件名
    property DataFile: string read FDataFile;
    property Screens: TScreensData read FScreens;
    property Movies: TMoviesData read FMovies;
    property MovieParent: TWinControl read FMovieParent write FMovieParent;
  end;

var
  gDataManager: TDataManager = nil;
  //全局使用

implementation

constructor TDataManager.Create;
begin
  ResetBlank(True);
  FMovieParent := nil;
  FXML := TNativeXml.Create;
end;

destructor TDataManager.Destroy;
begin
  FXML.Free;
  inherited;
end;

procedure TDataManager.ResetBlank(const nAll: Boolean);
begin
  SetLength(FMovies, 0);
  SetLength(FScreens, 0);
  if nAll then FDataFile := '';
end;

//------------------------------------------------------------------------------
//Desc: 读取或保存字体
procedure NodeFont(const nNode: TXmlNode; const nFont: TFont; nSave: Boolean);
begin
  if nSave then
  begin
    nNode.NodeNew('Name').ValueAsString := EncodeBase64(nFont.Name);
    nNode.NodeNew('Size').ValueAsInteger := nFont.Size;
    nNode.NodeNew('Color').ValueAsInteger := nFont.Color;
    nNode.NodeNew('Charset').ValueAsInteger := nFont.Charset;

    nNode.NodeNew('fsBold').ValueAsBool := fsBold in nFont.Style;
    nNode.NodeNew('fsItalic').ValueAsBool := fsItalic in nFont.Style;
    nNode.NodeNew('fsUnderline').ValueAsBool := fsUnderline in nFont.Style;
    nNode.NodeNew('fsStrikeOut').ValueAsBool := fsStrikeOut in nFont.Style;
  end else
  begin
    nFont.Name := DecodeBase64(nNode.NodeByName('Name').ValueAsString);
    nFont.Size := nNode.NodeByName('Size').ValueAsInteger;
    nFont.Color := nNode.NodeByName('Color').ValueAsInteger;
    nFont.Charset := nNode.NodeByName('Charset').ValueAsInteger;

    nFont.Style := [];
    if nNode.NodeByName('fsBold').ValueAsBool then
      nFont.Style := [fsBold];
    if nNode.NodeByName('fsItalic').ValueAsBool then
      nFont.Style := nFont.Style + [fsItalic];
    if nNode.NodeByName('fsUnderline').ValueAsBool then
      nFont.Style := nFont.Style + [fsUnderline];
    if nNode.NodeByName('fsStrikeOut').ValueAsBool then
      nFont.Style := nFont.Style + [fsStrikeOut];
  end;
end;

//Desc: 读取或保存nNode节点里nItem的属性
procedure NodeZnMovedControl(const nNode: TXmlNode; const nItem: TZnMovedControl;
 const nSave: Boolean);
begin
  if nSave then
  begin
    nNode.NodeNew('ShortName').ValueAsString := EncodeBase64(nItem.ShortName);
    nNode.NodeNew('Byte_LTWH').ValueAsBool := nItem.Byte_LTWH;
    nNode.NodeNew('ModeEnter').ValueAsInteger := nItem.ModeEnter;
    nNode.NodeNew('ModeExit').ValueAsInteger := nItem.ModeExit;
    nNode.NodeNew('SpeedEnter').ValueAsInteger := nItem.SpeedEnter;
    nNode.NodeNew('SpeedExit').ValueAsInteger := nItem.SpeedExit;
    nNode.NodeNew('KeedTime').ValueAsInteger := nItem.KeedTime;
    nNode.NodeNew('ModeSerial').ValueAsInteger := nItem.ModeSerial;
                                                   
    NodeFont(nNode.NodeNew('Font'), nItem.Font, True);
    nNode.NodeNew('ParentFont').ValueAsBool := nItem.ParentFont;
    nNode.NodeNew('Color').ValueAsInteger := nItem.Color;
  end else
  begin
    nItem.ShortName := DecodeBase64(nNode.NodeByName('ShortName').ValueAsString);
    nItem.Byte_LTWH := nNode.NodeByName('Byte_LTWH').ValueAsBool;
    nItem.ModeEnter := nNode.NodeByName('ModeEnter').ValueAsInteger;
    nItem.ModeExit := nNode.NodeByName('ModeExit').ValueAsInteger;
    nItem.SpeedEnter := nNode.NodeByName('SpeedEnter').ValueAsInteger;
    nItem.SpeedExit := nNode.NodeByName('SpeedExit').ValueAsInteger;
    nItem.KeedTime := nNode.NodeByName('KeedTime').ValueAsInteger;
    nItem.ModeSerial := nNode.NodeByName('ModeSerial').ValueAsInteger;
                                                   
    NodeFont(nNode.NodeByName('Font'), nItem.Font, False);
    nItem.ParentFont := nNode.NodeByName('ParentFont').ValueAsBool;
    nItem.Color := nNode.NodeByName('Color').ValueAsInteger;
  end;
end;

//Desc: 读取或保存nItem文本项
procedure NodeTextMovedItem(const nNode: TXmlNode; const nItem: TTextMovedItem;
 const nSave: Boolean);
begin
  if nSave then
  begin
    nNode.NodeNew('Text').ValueAsString := EncodeBase64(nItem.Text);
  end else
  begin
    nItem.Text := DecodeBase64(nNode.NodeByName('Text').ValueAsString);
  end;
end;

//Desc: 读取或保存nItem图文项
procedure NodePictureMovedItem(const nNode: TXmlNode; const nItem: TPictureMovedItem;
 const nSave: Boolean);
var nStr: string;
    nTop,nTmp: TXmlNode;
    i,nLen,nIdx: Integer;
begin
  if nSave then
  begin
    nNode.NodeNew('Text').ValueAsString := EncodeBase64(nItem.Text);
    nNode.NodeNew('Stretch').ValueAsBool := nItem.Stretch;

    nTop := nNode.NodeNew('Images');
    nLen := nItem.DataList.Count - 1;

    for i:=0 to nLen do
    with PPictureData(nItem.DataList[i])^ do
    begin
      nTmp := nTop.NodeNew('Image');
      nTmp.NodeNew('File').ValueAsString := EncodeBase64(FFile);
      nTmp.NodeNew('Type').ValueAsInteger := Ord(FType);
      nTmp.NodeNew('SingleLine').ValueAsBool := FSingleLine;
      nTmp.NodeNew('ModeEnter').ValueAsInteger := FModeEnter;
      nTmp.NodeNew('ModeExit').ValueAsInteger := FModeExit;
      nTmp.NodeNew('SpeedEnter').ValueAsInteger := FSpeedEnter;
      nTmp.NodeNew('SpeedExit').ValueAsInteger := FSpeedExit;
      nTmp.NodeNew('KeedTime').ValueAsInteger := FKeedTime;
      nTmp.NodeNew('ModeSerial').ValueAsInteger := FModeSerial;
    end;
  end else
  begin
    nItem.Text := DecodeBase64(nNode.NodeByName('Text').ValueAsString);
    nItem.Stretch := nNode.NodeByName('Stretch').ValueAsBool;
    nTop := nNode.NodeByName('Images');

    nLen := nTop.NodeCount - 1;
    for i:=0 to nLen do
    begin
      nTmp := nTop.Nodes[i];
      if nTmp.Name <> 'Image' then Continue;

      nStr := DecodeBase64(nTmp.NodeByName('File').ValueAsString);
      nIdx := nTmp.NodeByName('Type').ValueAsInteger;
      nIdx := nItem.AddData(nStr, TPictureDataType(nIdx));

      with PPictureData(nItem.DataList[nIdx])^ do
      begin
        FSingleLine := nTmp.NodeByName('SingleLine').ValueAsBool;
        FModeEnter := nTmp.NodeByName('ModeEnter').ValueAsInteger;
        FModeExit := nTmp.NodeByName('ModeExit').ValueAsInteger;
        FSpeedEnter := nTmp.NodeByName('SpeedEnter').ValueAsInteger;
        FSpeedExit := nTmp.NodeByName('SpeedExit').ValueAsInteger;
        FKeedTime := nTmp.NodeByName('KeedTime').ValueAsInteger;
        FModeSerial := nTmp.NodeByName('ModeSerial').ValueAsInteger;
      end;
    end;
  end;
end;

//Desc: 读取或保存nItem动画
procedure NodeAnimateMovedItem(const nNode: TXmlNode; const nItem: TAnimateMovedItem;
 const nSave: Boolean);
var nStr: string;
begin
  if nSave then
  begin
    nNode.NodeNew('Text').ValueAsString := EncodeBase64(nItem.Text);
    nNode.NodeNew('ImageFile').ValueAsString := EncodeBase64(nItem.ImageFile);
    nNode.NodeNew('Speed').ValueAsInteger := nItem.Speed;
    nNode.NodeNew('Reverse').ValueAsBool := nItem.Reverse;
    nNode.NodeNew('Stretch').ValueAsBool := nItem.Stretch;
  end else
  begin
    nItem.Text := DecodeBase64(nNode.NodeByName('Text').ValueAsString);
    nStr := DecodeBase64(nNode.NodeByName('ImageFile').ValueAsString);
    if FileExists(nStr) then nItem.ImageFile := nStr;

    nItem.Speed := nNode.NodeByName('Speed').ValueAsInteger;
    nItem.Reverse := nNode.NodeByName('Reverse').ValueAsBool;
    nItem.Stretch := nNode.NodeByName('Stretch').ValueAsBool;
  end;
end;

//Desc: 读取或保存nItem时钟
procedure NodeTimeMovedItem(const nNode: TXmlNode; const nItem: TTimeMovedItem;
 const nSave: Boolean);
begin
  if nSave then
  begin
    nNode.NodeNew('FixText').ValueAsString :=  EncodeBase64(nItem.FixText);
    nNode.NodeNew('DateText').ValueAsString := EncodeBase64(nItem.DateText);
    nNode.NodeNew('WeekText').ValueAsString := EncodeBase64(nItem.WeekText);
    nNode.NodeNew('TimeText').ValueAsString := EncodeBase64(nItem.TimeText);

    nNode.NodeNew('FixColor').ValueAsInteger := nItem.FixColor;
    nNode.NodeNew('DateColor').ValueAsInteger := nItem.DateColor;
    nNode.NodeNew('WeekColor').ValueAsInteger := nItem.WeekColor;
    nNode.NodeNew('TimeColor').ValueAsInteger := nItem.TimeColor;
    nNode.NodeNew('ModeChar').ValueAsInteger := nItem.ModeChar;
    nNode.NodeNew('ModeLine').ValueAsInteger := nItem.ModeLine;
    nNode.NodeNew('ModeDate').ValueAsInteger := nItem.ModeDate;
    nNode.NodeNew('ModeWeek').ValueAsInteger := nItem.ModeWeek;
    nNode.NodeNew('ModeTime').ValueAsInteger := nItem.ModeTime;
  end else
  begin
    nItem.FixText := DecodeBase64(nNode.NodeByName('FixText').ValueAsString);
    nItem.DateText := DecodeBase64(nNode.NodeByName('DateText').ValueAsString);
    nItem.WeekText := DecodeBase64(nNode.NodeByName('WeekText').ValueAsString);
    nItem.TimeText := DecodeBase64(nNode.NodeByName('TimeText').ValueAsString);

    nItem.FixColor := nNode.NodeByName('FixColor').ValueAsInteger;
    nItem.DateColor := nNode.NodeByName('DateColor').ValueAsInteger;
    nItem.WeekColor := nNode.NodeByName('WeekColor').ValueAsInteger;
    nItem.TimeColor := nNode.NodeByName('TimeColor').ValueAsInteger;
    nItem.ModeChar := nNode.NodeByName('ModeChar').ValueAsInteger;
    nItem.ModeLine := nNode.NodeByName('ModeLine').ValueAsInteger;
    nItem.ModeDate := nNode.NodeByName('ModeDate').ValueAsInteger;
    nItem.ModeWeek := nNode.NodeByName('ModeWeek').ValueAsInteger;
    nItem.ModeTime := nNode.NodeByName('ModeTime').ValueAsInteger;
  end;
end;

//Desc: 读取或保存nItem表盘
procedure NodeClockMovedItem(const nNode: TXmlNode; const nItem: TClockMovedItem;
 const nSave: Boolean);
var nTmp: TXmlNode;
    nStream: TStringStream;
begin
  if nSave then
  begin
    nNode.NodeNew('Text').ValueAsString := EncodeBase64(nItem.Text);
    nNode.NodeNew('AutoDot').ValueAsBool := nItem.AutoDot;

    nNode.NodeNew('DotX').ValueAsInteger := nItem.DotPoint.X;
    nNode.NodeNew('DotY').ValueAsInteger := nItem.DotPoint.Y;
    nNode.NodeNew('ColorHour').ValueAsInteger := nItem.ColorHour;
    nNode.NodeNew('ColorMin').ValueAsInteger := nItem.ColorMin;
    nNode.NodeNew('ColorSec').ValueAsInteger := nItem.ColorSec;

    if Assigned(nItem.Image.Graphic) then
    begin
      nStream := TStringStream.Create('');
      nItem.Image.Bitmap.SaveToStream(nStream);
      nNode.NodeNew('Image').ValueAsString := EncodeBinHex(nStream.DataString);
      nStream.Free;
    end;
  end else
  begin
    nItem.Text := DecodeBase64(nNode.NodeNew('Text').ValueAsString);
    nItem.AutoDot := nNode.NodeByName('AutoDot').ValueAsBool;

    nItem.DotPoint := Point(nNode.NodeByName('DotX').ValueAsInteger,
                            nNode.NodeByName('DotY').ValueAsInteger);
    nItem.ColorHour := nNode.NodeByName('ColorHour').ValueAsInteger;
    nItem.ColorMin := nNode.NodeByName('ColorMin').ValueAsInteger;
    nItem.ColorSec := nNode.NodeByName('ColorSec').ValueAsInteger;

    nTmp := nNode.FindNode('Image');
    if Assigned(nTmp) then
    begin
      nStream := TStringStream.Create(DecodeBinHex(nTmp.ValueAsString));
      nItem.Image.Bitmap.LoadFromStream(nStream);
      nStream.Free;
    end;
  end;
end;

//Desc: 读取或保存nItem屏幕项
procedure NodeScreenItem(const nNode: TXmlNode; const nItem: PScreenItem;
 const nSave: Boolean);
var nTmp: TXmlNode;
    i,nLen: Integer;
begin
  if nSave then
  begin
    nNode.NodeNew('ID').ValueAsInteger := nItem.FID;
    nNode.NodeNew('Name').ValueAsString := EncodeBase64(nItem.FName);
    nNode.NodeNew('Card').ValueAsInteger := nItem.FCard;
    nNode.NodeNew('LenX').ValueAsInteger := nItem.FLenX;
    nNode.NodeNew('LenY').ValueAsInteger := nItem.FLenY;
    nNode.NodeNew('Type').ValueAsInteger := Ord(nItem.FType);
    nNode.NodeNew('Port').ValueAsString := nItem.FPort;
    nNode.NodeNew('Bote').ValueAsInteger := nItem.FBote;

    nTmp := nNode.NodeNew('Devices');
    nLen := High(nItem.FDevice);

    for i:=Low(nItem.FDevice) to nLen do
    with nTmp.NodeNew('Device') do
    begin
      AttributeAdd('ID', nItem.FDevice[i].FID);
      AttributeAdd('Name', EncodeBase64(nItem.FDevice[i].FName));
    end;
  end else
  begin
    nItem.FID := nNode.NodeByName('ID').ValueAsInteger;
    nItem.FName := DecodeBase64(nNode.NodeByName('Name').ValueAsString);
    nItem.FCard := nNode.NodeByName('Card').ValueAsInteger;
    nItem.FLenX := nNode.NodeByName('LenX').ValueAsInteger;
    nItem.FLenY := nNode.NodeByName('LenY').ValueAsInteger;
    nItem.FType := TScreenType(nNode.NodeByName('Type').ValueAsInteger);
    nItem.FPort := nNode.NodeByName('Port').ValueAsString;
    nItem.FBote := nNode.NodeByName('Bote').ValueAsInteger;

    nTmp := nNode.NodeByName('Devices');
    SetLength(nItem.FDevice, nTmp.NodeCount);
    nLen := nTmp.NodeCount - 1;

    for i:=0 to nLen do
    begin
      nItem.FDevice[i].FID := StrToInt(nTmp.Nodes[i].AttributeByName['ID']);
      nItem.FDevice[i].FName := DecodeBase64(nTmp.Nodes[i].AttributeByName['Name']);
    end;
  end;
end;

//Desc: 读取或保存nItem的内容
procedure NodeMovieItem(const nNode: TXmlNode; var nItem: TControl;
 const nSave: Boolean);
var nStr: string;
    nPCtrl: TWinControl;
begin
  if nSave then
  begin
    nNode.AttributeAdd('Name', nItem.Name);
    nNode.AttributeAdd('Class', nItem.ClassName);

    nNode.NodeNew('Left').ValueAsInteger := nItem.Left;
    nNode.NodeNew('Top').ValueAsInteger := nItem.Top;
    nNode.NodeNew('Width').ValueAsInteger := nItem.Width;
    nNode.NodeNew('Height').ValueAsInteger := nItem.Height;
  end else
  begin
    nPCtrl := TWinControl(nItem);
    nItem := nil;
    nStr := nNode.AttributeByName['Class'];

    if nStr = TTextMovedItem.ClassName then
      nItem := TTextMovedItem.Create(nPCtrl) else
    //文本

    if nStr = TPictureMovedItem.ClassName then
      nItem := TPictureMovedItem.Create(nPCtrl) else
    //图文

    if nStr = TAnimateMovedItem.ClassName then
      nItem := TAnimateMovedItem.Create(nPCtrl) else
    //动画

    if nStr = TTimeMovedItem.ClassName then
      nItem := TTimeMovedItem.Create(nPCtrl) else
    //时钟

    if nStr = TClockMovedItem.ClassName then
      nItem := TClockMovedItem.Create(nPCtrl) else Exit;
    //表盘

    nItem.Parent := nPCtrl;
    nItem.Left := nNode.NodeByName('Left').ValueAsInteger;
    nItem.Top := nNode.NodeByName('Top').ValueAsInteger;
    nItem.Width := nNode.NodeByName('Width').ValueAsInteger;
    nItem.Height := nNode.NodeByName('Height').ValueAsInteger;
  end;

  if nItem is TZnMovedControl then
    NodeZnMovedControl(nNode, TZnMovedControl(nItem), nSave);
  //基类属性

  if nItem is TTextMovedItem then
    NodeTextMovedItem(nNode, TTextMovedItem(nItem), nSave);
  //文本

  if nItem is TPictureMovedItem then
    NodePictureMovedItem(nNode, TPictureMovedItem(nItem), nSave);
  //图文

  if nItem is TAnimateMovedItem then
    NodeAnimateMovedItem(nNode, TAnimateMovedItem(nItem), nSave);
  //动画

  if nItem is TTimeMovedItem then
    NodeTimeMovedItem(nNode, TTimeMovedItem(nItem), nSave);
  //时钟

  if nItem is TClockMovedItem then
    NodeClockMovedItem(nNode, TClockMovedItem(nItem), nSave);
  //表盘
end;

//Desc: 载入nFile文件
function TDataManager.LoadFromFile(const nFile: string): Boolean;
var nCtrl: TControl;
    i,nIdx,nLen: Integer;
    nNode,nTmp: TXmlNode;
begin
  Result := False;
  if not FileExists(nFile) then Exit;

  try
    FXML.LoadFromFile(nFile);

    nNode := FXML.Root.NodeByName('Screens');
    SetLength(FScreens, nNode.NodeCount);
    nLen := nNode.NodeCount - 1;

    for i:=0 to nLen do
      NodeScreenItem(nNode.Nodes[i], @FScreens[i], False);
    //屏幕列表

    nNode := FXML.Root.NodeByName('Movies');
    SetLength(FMovies, nNode.NodeCount);
    nLen := nNode.NodeCount - 1;

    for i:=0 to nLen do
    with nNode.Nodes[i] do
    begin
      FMovies[i] := TZnBorderControl.Create(FMovieParent);
      with FMovies[i] do
      begin
        Parent := FMovieParent;
        Tag := NodeByName('Screen').ValueAsInteger;

        Width := NodeByName('Width').ValueAsInteger;
        Height := NodeByName('Height').ValueAsInteger;

        HasBorder := NodeByName('HasBorder').ValueAsBool;
        BorderSpeed := NodeByName('BorderSpeed').ValueAsInteger;
        BorderWidth := NodeByName('BorderWidth').ValueAsInteger;
        BorderColor := NodeByName('BorderColor').ValueAsInteger;
        BorderEffect := NodeByName('BorderEffect').ValueAsInteger;
      end;

      nIdx := 0;
      nTmp := NodeByName('Items');

      while nIdx < nTmp.NodeCount do
      begin
        nCtrl := FMovies[i];
        NodeMovieItem(nTmp.Nodes[nIdx], nCtrl, False);
        Inc(nIdx);
      end;
    end;

    Result := True;
    FDataFile := nFile;
  except
    //ignor any error
  end;
end;

//Date: 2010-5-20
//Parm: 文件名
//Desc: 将屏幕和节目数据存入nFile
function TDataManager.SaveToFile(const nFile: string): Boolean;
var nCtrl: TControl;
    i,nIdx,nLen: Integer;
    nNode,nTmp: TXmlNode;
begin
  Result := False;
  if FileExists(nFile) and (not DeleteFile(nFile)) then Exit;

  FXML.Clear;
  FXML.Utf8Encoded := True;
  FXML.EncodingString := 'utf-8';
  FXML.XmlFormat := xfReadable;
  
  FXML.Root.Name := 'HBMData';
  nNode := FXML.Root.NodeNew('Screens');

  nLen := gScreenList.Count - 1;
  for i:=0 to nLen do
  begin
    nTmp := nNode.NodeNew('Screen');
    NodeScreenItem(nTmp, PScreenItem(gScreenList[i]), True);
  end;

  nNode := FXML.Root.NodeNew('Movies');
  nLen := FMovieParent.ControlCount - 1;

  for i:=0 to nLen do
  if FMovieParent.Controls[i] is TZnBorderControl then
  with TZnBorderControl(FMovieParent.Controls[i]) do
  begin
    nTmp := nNode.NodeNew('Movie');
    nTmp.NodeNew('Screen').ValueAsInteger := Tag;
    nTmp.NodeNew('Width').ValueAsInteger := Width;
    nTmp.NodeNew('Height').ValueAsInteger := Height;

    nTmp.NodeNew('HasBorder').ValueAsBool := HasBorder;
    nTmp.NodeNew('BorderSpeed').ValueAsInteger := BorderSpeed;
    nTmp.NodeNew('BorderWidth').ValueAsInteger := BorderWidth;
    nTmp.NodeNew('BorderColor').ValueAsInteger := BorderColor;
    nTmp.NodeNew('BorderEffect').ValueAsInteger := Ord(BorderEffect);

    nIdx := 0;
    nTmp := nTmp.NodeNew('Items');

    while nIdx < ControlCount do
    begin
      nCtrl := Controls[nIdx];
      NodeMovieItem(nTmp.NodeNew('Item'), nCtrl, True);
      Inc(nIdx);
    end;
  end;  

  FXML.SaveToFile(nFile);
  Result := True;
end;

initialization
  gDataManager := TDataManager.Create;
finalization
  FreeAndNil(gDataManager);
end.
