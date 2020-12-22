{*******************************************************************************
  ����: dmzn@163.com 2020-12-20
  ����: ͨѶЭ�鶨��
*******************************************************************************}
unit UProtocol;

interface

uses
  Classes, SysUtils, IdGlobal, ULibFun;
  
const
  cFrame_Begin  = Char($FF) + Char($FF) + Char($FF);  //֡ͷ
  cFrame_End    = Char($FE);                          //֡β

  {*������*}
  cFrame_CMD_UpData       = $01;              //�����ϴ�
  cFrame_CMD_QueryData    = $02;              //���ݲ�ѯ

  {*��չ��*}
  cFrame_Ext_RunData      = $01;              //����״̬����
  cFrame_Ext_RunParam     = $01;              //���в�������
  
type
  PFrameData = ^TFrameData;
  TFrameData = packed record
    FHeader     : array[0..2] of Char;        //֡ͷ
    FStation    : Word;                       //�豸ID
    FCommand    : Byte;                       //������
    FExtCMD     : Byte;                       //��չ��
    FDataLen    : Byte;                       //���ݳ���
    FData       : array[0..255] of Char;      //����
    FEnd        : Char;                       //֡β
  end;

  TValFloat = array[0..3] of Char;            //����ֵ

  PRunData = ^TRunData;
  TRunData = packed record
    I00         : Byte;                       //�ϵ�
    I01         : Byte;                       //����λ
    I02         : Byte;                       //�ص�λ
    VD300       : TValFloat;                  //˲ʱ����
    VD304       : TValFloat;                  //�¶�
    VD308       : TValFloat;                  //ѹ��
    VD312       : TValFloat;                  //�ۼ�����
    VD316       : TValFloat;                  //ѹ��
    VD320       : TValFloat;                  //����
    VD324       : TValFloat;                  //�ۼ�����
    VD328       : TValFloat;                  //�¶ȸ����趨
    VD332       : TValFloat;                  //�¶ȵ����趨
    VD336       : TValFloat;                  //ѹ�������趨
    VD340       : TValFloat;                  //ѹ�������趨
    VD348       : TValFloat;                  //����
    VD352       : TValFloat;                  //���
    VD356       : TValFloat;                  //�����趨
    V3650       : Byte;                       //�����Զ�
    V3651       : Byte;                       //�¶ȸ߱���
    V3652       : Byte;                       //�¶ȵͱ���
    V3653       : Byte;                       //ѹ���߱���
    V3654       : Byte;                       //ѹ���ͱ���
    V3655       : Byte;                       //�ܱ���
    V3656       : Byte;                       //���ͱ���
    V3657       : Byte;                       //��������������
    V20000      : Byte;                       //�ֶ�����
    V20001      : Byte;                       //�ֶ��ط�
    V20002      : Byte;                       //������ͣ
  end;

  PRunParams = ^TRunParams;
  TRunParams = packed record
    VD328       : TValFloat;                  //�¶ȸ����趨
    VD332       : TValFloat;                  //�¶ȵ����趨
    VD336       : TValFloat;                  //ѹ�������趨
    VD340       : TValFloat;                  //ѹ�������趨
    VD348       : TValFloat;                  //����
    VD352       : TValFloat;                  //���
    VD356       : TValFloat;                  //�����趨
    V3650       : Byte;                       //�����Զ�
    V20000      : Byte;                       //�ֶ�����
    V20001      : Byte;                       //�ֶ��ط�
    V20002      : Byte;                       //������ͣ
  end;

const
  cSize_Frame_All         = SizeOf(TFrameData);
  cSize_Frame_RunData     = SizeOf(TRunData);
  cSize_Frame_RunParams   = SizeOf(TRunParams);
  cSize_Record_ValFloat   = SizeOf(TValFloat);

const
  sTable_RunData          = 'D_RunData';
  sTable_RunParams        = 'D_RunParams';

procedure PutValFloat(const nVal: Single; var nFloat: TValFloat);
function GetValFloat(const nFloat: TValFloat): Single;
//ת��������
procedure InitFrameData(var nData: TFrameData);
procedure InitRunData(var nData: TRunData);
procedure InitRunParams(var nData: TRunParams);
//��ʼ������
//�������ͻ���
function FrameValidLen(const nData: PFrameData): Integer;
//֡��Ч��С
function BuildRunData(const nFrame: PFrameData; const nRun: PRunData): TIdBytes;
function BuildRunParams(const nFrame: PFrameData; const nParams: PRunParams): TIdBytes;

implementation

//Date: 2020-12-20
//Parm: ����ֵ;����ṹ
//Desc: ��nVal����nFloat��
procedure PutValFloat(const nVal: Single; var nFloat: TValFloat);
var nStr: string;
    nIdx,nLen: Integer;
begin
  nStr := FloatToStr(nVal);
  nLen := Length(nStr);

  while nLen > cSize_Record_ValFloat do //����,�ü�
  begin
    System.Delete(nStr, nLen, 1);
    //ɾ�����һλ,���;���
    Dec(nLen);

    if Pos('.', nStr) = nLen then
    begin
      System.Delete(nStr, nLen, 1);
      //ɾ��С����
      Dec(nLen);
    end;
  end;

  for nIdx:=High(nFloat) downto Low(nFloat) do
  begin
    nFloat[nIdx] := nStr[nLen];
    Dec(nLen);
    if nLen < 1 then Break;
  end;
end;

//Date: 2020-12-20
//Parm: ����ṹ
//Desc: ����nFloat��ֵ
function GetValFloat(const nFloat: TValFloat): Single;
var nStr: string;
    nIdx: Integer;
begin
  nStr := '';
  for nIdx:=High(nFloat) downto Low(nFloat) do
  begin
    if not (nFloat[nIdx] in ['0'..'9', '.']) then Break;
    nStr := nFloat[nIdx] + nStr;
  end;

  if IsNumber(nStr, True) then
       Result := StrToFloat(nStr)
  else Result := 0;
end;

//Date: 2020-12-20
//Parm: ֡����
//Desc: ��ʼ��nData
procedure InitFrameData(var nData: TFrameData);
begin
  FillChar(nData, cSize_Frame_All, #0);
  with nData do
  begin
    FHeader := cFrame_Begin;
    FEnd    := cFrame_End;
  end;
end;

procedure InitRunData(var nData: TRunData);
var nInit: TRunData;
begin
  FillChar(nInit, cSize_Frame_RunData, #0);
  nData := nInit;
end;

procedure InitRunParams(var nData: TRunParams);
var nInit: TRunParams;
begin
  FillChar(nInit, cSize_Frame_RunParams, #0);
  nData := nInit;
end;

//Date: 2020-12-20
//Parm: ֡����
//Desc: ����nData����Ч���ݴ�С
function FrameValidLen(const nData: PFrameData): Integer;
begin
  Result := 5 + 3 + nData.FDataLen + 1;
end;

//Date: 2020-12-20
//Parm: ֡����;��������
//Desc: ��nFrame + nRun���Ϊ���ͻ���
function BuildRunData(const nFrame: PFrameData; const nRun: PRunData): TIdBytes;
begin
  Move(nRun^, nFrame.FData[0], cSize_Frame_RunData);
  //�ϲ���������

  nFrame.FData[cSize_Frame_RunData] := cFrame_End;
  //��֡β

  nFrame.FDataLen := cSize_Frame_RunData;
  Result := RawToBytes(nFrame^, FrameValidLen(nFrame));
end;

//Date: 2020-12-20
//Parm: ֡����;���в���
//Desc: ��nFrame + nParams���Ϊ���ͻ���
function BuildRunParams(const nFrame: PFrameData; const nParams: PRunParams): TIdBytes;
begin
  Move(nParams^, nFrame.FData[0], cSize_Frame_RunParams);
  //�ϲ���������

  nFrame.FData[cSize_Frame_RunParams] := cFrame_End;
  //��֡β

  nFrame.FDataLen := cSize_Frame_RunParams;
  Result := RawToBytes(nFrame^, FrameValidLen(nFrame));
end;

end.
