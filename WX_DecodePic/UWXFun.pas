{*******************************************************************************
  ����: dmzn@163.com 2020-05-18
  ����: ΢������㷨
*******************************************************************************}
unit UWXFun;

interface

uses
  System.SysUtils, System.Classes, Winapi.Windows, System.Math, System.StrUtils;

procedure DecryptWXImgFile(const nSrcFile, nSavePath: string);
//��ں���

implementation

const
  C_TypeCodeArr: array of Word = [$4D42, $D8FF, $4947, $5089];
  C_TypeExtArr: array of string = ['.bmp', '.jpeg', '.gif', '.png'];

// ����MagicCode�Լ�ͼƬ����
function CalcMagicCode(const AHeadCode: Word; var AMagicCode: Word;
  var AFileExt: string): Boolean;
var
  I: Integer;
  LByte1, LByte2: Byte;
  LMagicCode: Word;
begin
  Result := False;
  LByte1 := Byte(AHeadCode);
  LByte2 := HiByte(AHeadCode);
  for I := Low(C_TypeCodeArr) to High(C_TypeCodeArr) do
  begin
    LMagicCode := Byte(C_TypeCodeArr[I]) xor LByte1;
    if LMagicCode = (HiByte(C_TypeCodeArr[I]) xor LByte2) then
    begin
      AMagicCode := LMagicCode;
      AFileExt := C_TypeExtArr[I];
      Result := True;
    end;
  end;
end;

procedure MakeFileList(const Path, FileExt: string; AFileList: TStrings);
var
  sch: TSearchRec;
  tmpPath: string;
begin
  if RightStr(Trim(Path), 1) <> '\' then
       tmpPath := Trim(Path) + '\'
  else tmpPath := Trim(Path);

  if not DirectoryExists(tmpPath) then Exit;
  //check dir

  if FindFirst(tmpPath + '*', faAnyFile, sch) = 0 then
  try
    repeat
      if ((sch.Name = '.') or (sch.Name = '..')) then
        Continue;
      if (FileExt = '.*') or
         (UpperCase(ExtractFileExt(tmpPath + sch.Name)) = UpperCase(FileExt)) then
        AFileList.Add(tmpPath + sch.Name);
    until FindNext(sch) <> 0;
  finally
    System.SysUtils.FindClose(sch);
  end;
end;

procedure DecryptWXImgFile(const nSrcFile, nSavePath: string);
var
  LSrcStream: TMemoryStream;
  LDesStream: TFileStream;
  LFilesize, LPos: Integer;
  LBuffer: Word;
  LSrcByte, LDesByte: Byte;
  LMagicCode: Word;
  LFileExt, LFileName: string;
begin
  LSrcStream := TMemoryStream.Create;
  try
    LSrcStream.LoadFromFile(nSrcFile);
    LSrcStream.Position := 0;
    LSrcStream.ReadBuffer(LBuffer, 2);
    if CalcMagicCode(LBuffer, LMagicCode, LFileExt) then
    begin
      LFileName := nSavePath + ChangeFileExt(ExtractFileName(nSrcFile), LFileExt);
      LDesStream := TFileStream.Create(LFileName, fmCreate);
      try
        LPos := 0;
        LFilesize := LSrcStream.Size;
        // �˴�Ч�ʵͣ���Ҫ�Ż�
        while LPos < LFilesize do
        begin
          LSrcStream.Position := LPos;
          LSrcStream.ReadBuffer(LSrcByte, 1);
          LDesByte := LSrcByte xor LMagicCode;
          LDesStream.WriteBuffer(LDesByte, 1);
          Inc(LPos);
        end;
      finally
        LDesStream.Free;
      end;
    end;
  finally
    LSrcStream.Free;
  end;
end;

end.
