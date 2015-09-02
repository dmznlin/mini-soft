unit UFormMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls, DB, ADODB;

type
  TfFormMain = class(TForm)
    Panel1: TPanel;
    MemoSQL: TMemo;
    stat1: TStatusBar;
    BtnConn: TButton;
    BtnParse: TButton;
    BtnSave: TButton;
    ADOConnection1: TADOConnection;
    Query1: TADOQuery;
    BtnEnum: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnConnClick(Sender: TObject);
    procedure BtnParseClick(Sender: TObject);
    procedure BtnSaveClick(Sender: TObject);
    procedure BtnEnumClick(Sender: TObject);
  private
    { Private declarations }
    FStep: Integer;
    //��������
    procedure InitUIByStep;
  public
    { Public declarations }
  end;

var
  fFormMain: TfFormMain;

implementation

{$R *.dfm}

uses
  ULibFun, UFormConn;

var
  gPath: string;

resourcestring
  sHint = '��ʾ';

procedure TfFormMain.FormCreate(Sender: TObject);
begin
  gPath := ExtractFilePath(Application.ExeName);
  InitGlobalVariant(gPath, gPath + 'Config.ini', gPath + 'Config.ini', gPath + 'DBConn.ini');

  FStep := 1;
  InitUIByStep;
  LoadFormConfig(Self);
end;

procedure TfFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveFormConfig(Self);
end;

procedure TfFormMain.InitUIByStep;
begin
  BtnConn.Enabled := FStep = 1;
  BtnEnum.Enabled := FStep = 1;
  
  BtnParse.Enabled := FStep > 1;
  BtnSave.Enabled := FStep > 2;
end;

function DBConn(const nConnStr: string): Boolean;
begin
  with fFormMain do
  try
    ADOConnection1.Close;
    ADOConnection1.ConnectionString := nConnStr;
    ADOConnection1.Connected := True;
    Result := ADOConnection1.Connected;
  except
    Result := False;
  end;
end;

procedure TfFormMain.BtnConnClick(Sender: TObject);
begin
  if ShowConnectDBSetupForm(@DBConn) then
  try
    ADOConnection1.Close;
    ADOConnection1.ConnectionString := BuildConnectDBStr();
    ADOConnection1.Connected := True;

    FStep := 2;
    InitUIByStep;
    ShowMsg('���ӳɹ�', sHint);
  except
    ShowMsg('�޷����ӵ����ݿ�', sHint);
  end;
end;

//Date: 2015-09-01
//Parm: �ֶ�����;���ж�����
//Desc: �ж�nField�Ƿ�ΪnType����
function IsFixType(const nField: TFieldType; const nType: Byte): Boolean;
begin
  case nField of
   ftUnknown, ftBytes, ftVarBytes, ftAutoInc, ftBlob, ftMemo, ftGraphic, ftFmtMemo,
   ftParadoxOle, ftDBaseOle, ftTypedBinary, ftCursor, ftADT, ftArray, ftReference,
   ftDataSet, ftOraBlob, ftOraClob, ftVariant, ftInterface, ftIDispatch, ftGuid,
   ftTimeStamp, ftFMTBcd:
    Result := nType = 1;     //���账������
   ftFloat,ftCurrency, ftBCD:
    Result := nType = 2;     //������
   ftSmallint, ftInteger, ftWord:
    Result := nType = 3;     //����
   else Result := nType = 4; //�ַ���
  end;
end;

procedure TfFormMain.BtnParseClick(Sender: TObject);
var nStr,nLine,nInfo,nCreate,nAutoInc,nP: string;
    nIdx,nInt: Integer;
    nListA,nListB: TStrings;
begin
  nLine := '--';
  for nIdx:=1 to 100 do
  begin
    if nIdx = 50 then
    begin
      nLine := nLine + ' %s ';
      Continue;
    end;

    if nIdx mod 2 = 0 then
         nLine := nLine + '.'
    else nLine := nLine + '-';
  end;

  MemoSQL.Clear;
  MemoSQL.Lines.Add(Format(nLine, ['All Tables']));

  nListA := TStringList.Create;
  nListB := TStringList.Create;
  try
    ADOConnection1.GetTableNames(nListA);
    for nIdx:=0 to nListA.Count - 1 do
      MemoSQL.Lines.Add('--' + InttoStr(nIdx) + '.' + nListA[nIdx]);
    MemoSQL.Lines.Add('');

    nInfo := 'select column_name,data_type,IS_NULLABLE,character_octet_length,' +
             'collation_name,domain_name,numeric_precision,numeric_scale' +
             ' from information_schema.columns ' +
             'where table_name=''%s'' order by ordinal_position';
    //xxxxx
    
    for nIdx:=0 to nListA.Count - 1 do
    try
      MemoSQL.Lines.Add(Format(nLine, [InttoStr(nIdx) + '.' + nListA[nIdx]]));
      //split

      nStr := 'select [name] from syscolumns where id=object_id(N''%s'')' +
              ' and COLUMNPROPERTY(id,name,''IsIdentity'')=1';
      nStr := Format(nStr, [nListA[nIdx]]);

      Query1.Close;
      Query1.SQL.Text := nStr;
      Query1.Open;

      if Query1.RecordCount > 0 then
           nAutoInc := Query1.Fields[0].AsString
      else nAutoInc := '';

      //------------------------------------------------------------------------
      Query1.Close;
      Query1.SQL.Text := Format(nInfo, [nListA[nIdx]]);
      Query1.Open;

      if Query1.RecordCount > 0 then
      begin
        Query1.First;
        nStr := '--';

        for nInt:=0 to Query1.FieldCount - 1 do
          nStr := nStr + StrWithWidth(Query1.Fields[nInt].FieldName, 25, 1) + '|';
        MemoSQL.Lines.Add(nStr);

        while not Query1.Eof do
        begin
          nStr := '--';
          for nInt:=0 to Query1.FieldCount - 1 do
            nStr := nStr + StrWithWidth(Query1.Fields[nInt].AsString, 25, 1) + '|';
          //xxxxx
          
          MemoSQL.Lines.Add(nStr);
          //field sql
          Query1.Next;
        end;
                        
        nCreate := 'IF EXISTS (SELECT * FROM sys.objects ' +
                   'WHERE object_id = OBJECT_ID(N''[dbo].[%s]'') AND ' +
                   'type in (N''U'')) BEGIN DROP TABLE %s END' + #13#10;
        nCreate := Format(nCreate, [nListA[nIdx], nListA[nIdx]]);
        nCreate := nCreate + Format('CREATE TABLE [dbo].[%s] (', [nListA[nIdx]]) + #13#10;

        Query1.First;
        while not Query1.Eof do
        begin
          nCreate := nCreate + #9 +
                Format('[%s] ', [Query1.FieldByName('column_name').AsString]) +
                Format('[%s] ', [Query1.FieldByName('data_type').AsString]);
          //xxxxx

          if CompareText(nAutoInc, Query1.FieldByName('column_name').AsString) = 0 then
            nCreate := nCreate + 'IDENTITY(1,1) ';
          //auto increment

          nInt := Query1.FieldByName('numeric_scale').AsInteger;
          if nInt >= 1 then
            nCreate := nCreate + Format('(%d,%d) ', [
              Query1.FieldByName('numeric_precision').AsInteger, nInt]);
          //xxxxx

          nInt := Query1.FieldByName('character_octet_length').AsInteger;
          if nInt >= 1 then
            nCreate := nCreate + Format('(%d) ', [nInt]);
          //xxxxx

          nStr := Query1.FieldByName('collation_name').AsString;
          if nStr <> '' then
            nCreate := nCreate + Format('COLLATE %s ', [nStr]);
          //xxxxx

          nStr := Query1.FieldByName('IS_NULLABLE').AsString;
          if CompareText(nStr, 'no') = 0 then
               nCreate := nCreate + 'NOT NULL'
          else nCreate := nCreate + 'NULL';

          Query1.Next;
          if Query1.Eof then
               nCreate := nCreate + ')'
          else nCreate := nCreate +  ',' + #13#10;
        end;

        MemoSQL.Lines.Add(nCreate);
        //create sql
      end;

      MemoSQL.Lines.Add('');
      //------------------------------------------------------------------------
      Query1.Close;
      Query1.SQL.Text := 'Select Top 100 * From ' + nListA[nIdx];
      Query1.Open;

      if Query1.RecordCount < 1 then Continue;
      //no record

      with Query1 do
      begin
        nP := '';
        //clear
        
        for nInt:=0 to FieldCount - 1 do
         if not IsFixType( Fields[nInt].DataType, 1)  then
          nP := nP + Fields[nInt].FieldName + ',';
        System.Delete(nP, Length(nP), 1);
      end;

      nP := Format('Insert Into %s(%s) Values (', [nListA[nIdx], nP]);
      with Query1 do
      begin
        First;

        while not Eof do
        begin
          nStr := nP;
          //xxxxx

          for nInt:=0 to FieldCount - 1 do
          begin
            if IsFixType(Fields[nInt].DataType, 1) then Continue;
            //���账��

            if IsFixType(Fields[nInt].DataType, 2) then
              nStr := nStr + FloatToStr(Fields[nInt].AsFloat) + ',';
            //������

            if IsFixType(Fields[nInt].DataType, 3) then
              nStr := nStr + IntToStr(Fields[nInt].AsInteger) + ',';
            //������

            if IsFixType(Fields[nInt].DataType, 4) then
              nStr := nStr + '''' + Fields[nInt].AsString + ''',';
            //�ַ���
          end;

          System.Delete(nStr, Length(nStr), 1);
          nStr := nStr + ')';
          MemoSQL.Lines.Add(nStr);
          Next;
        end;
      end;

      MemoSQL.Lines.Add('');
      //if nIdx > 5 then Break;
    except
      on E: Exception do
      begin
        MemoSQL.Lines.Add('--Error: ' + E.Message);
      end;
    end;

    //--------------------------------------------------------------------------
    Query1.Close;
    Query1.SQL.Text := 'select  b.[name],a.[text] from  syscomments A' +
                       ' inner   join  sysobjects B  on  A.ID = B.ID' +
                       ' where  b.xtype = ''P'' and b.category=0';
    Query1.Open;

    if Query1.RecordCount > 0 then
    begin
      Query1.First;

      while not Query1.Eof do
      begin
        MemoSQL.Lines.Add(Format(nLine, ['�洢����: ' + Query1.Fields[0].AsString]));
        MemoSQL.Lines.Add(Query1.Fields[1].AsString);

        MemoSQL.Lines.Add(#13#10#13#10);
        Query1.Next;
      end;
    end;

    //--------------------------------------------------------------------------
    Query1.Close;
    Query1.SQL.Text := 'select  b.[name],a.[text] from  syscomments A' +
                       ' inner   join  sysobjects B  on  A.ID = B.ID' +
                       ' where  b.xtype = ''TR'' and b.category=0';
    Query1.Open;

    if Query1.RecordCount > 0 then
    begin
      Query1.First;

      while not Query1.Eof do
      begin
        MemoSQL.Lines.Add(Format(nLine, ['������: ' + Query1.Fields[0].AsString]));
        MemoSQL.Lines.Add(Query1.Fields[1].AsString);

        MemoSQL.Lines.Add(#13#10#13#10);
        Query1.Next;
      end;
    end;

    //--------------------------------------------------------------------------
    Query1.Close;
    Query1.SQL.Text := 'select  b.[name],a.[text] from  syscomments A' +
                       ' inner   join  sysobjects B  on  A.ID = B.ID' +
                       ' where  b.xtype = ''V'' and b.category=0';
    Query1.Open;

    if Query1.RecordCount > 0 then
    begin
      Query1.First;

      while not Query1.Eof do
      begin
        MemoSQL.Lines.Add(Format(nLine, ['��ͼ: ' + Query1.Fields[0].AsString]));
        MemoSQL.Lines.Add(Query1.Fields[1].AsString);

        MemoSQL.Lines.Add(#13#10#13#10);
        Query1.Next;
      end;
    end;

    FStep := 3;
    InitUIByStep;
  finally
    nListA.Free;
    nListB.Free;
  end;   
end;

procedure TfFormMain.BtnSaveClick(Sender: TObject);
var nStr: string;
begin
  with TSaveDialog.Create(Application) do
  try
    Title := '����';
    Filter := 'SQL Script|*.sql';
    DefaultExt := '.sql';
    Options := Options + [ofOverwritePrompt];

    if not Execute then Exit;
    nStr := FileName;
    MemoSQL.Lines.SaveToFile(nStr);
  finally
    Free;
  end;
end;

procedure TfFormMain.BtnEnumClick(Sender: TObject);
var nStr: string;
    nInt: Integer;
begin
  try
    nStr := Trim(ADOConnection1.ConnectionString);
    if nStr = '' then
    begin
      ShowMsg('���"����"������DB=#', sHint);
      Exit;
    end;

    ADOConnection1.Connected := False;
    ADOConnection1.ConnectionString := StringReplace(nStr, '#', 'master', [rfIgnoreCase]);
    ADOConnection1.Connected := True;

    Query1.Close;
    Query1.SQL.Text := 'select dbid as ��ʶ, DB_NAME(dbid) AS ���ݿ� FROM sysdatabases ' +
                       'order by dbid';
    Query1.Open;

    if Query1.RecordCount > 0 then
    begin
      nStr := '';
      for nInt:=0 to Query1.FieldCount - 1 do
        nStr := nStr + StrWithWidth(Query1.Fields[nInt].FieldName, 25, 1) + '|';
      MemoSQL.Lines.Add(nStr);

      Query1.First;
      while not Query1.Eof do
      begin
        nStr := '';
        for nInt:=0 to Query1.FieldCount - 1 do
          nStr := nStr + StrWithWidth(Query1.Fields[nInt].AsString, 25, 1) + '|';
        //xxxxx
        
        MemoSQL.Lines.Add(nStr);
        Query1.Next;
      end;
    end;
  except
    on E: Exception do
    begin
      MemoSQL.Text := E.Message;
    end;
  end;
end;

end.
