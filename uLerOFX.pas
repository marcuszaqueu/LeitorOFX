unit uLerOFX;

interface

uses classes, SysUtils;

type
  TOFXItem = class
    MovType: String;
    MovDate: TDateTime;
    Value: String;
    ID: string;
    Document: string;
    Description: string;
  end;

  TLeitorOFX = class(TComponent)
  public
    BankID: String;
    BranchID: string;
    AccountID: string;
    AccountType: string;
    DateStart: string;
    DateEnd: string;
    FinalBalance: String;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Import: boolean;
    function Get(iIndex: integer): TOFXItem;
    function Count: integer;
  private
    FOFXFile: string;
    FListItems: TList;
    procedure Clear;
    procedure Delete(iIndex: integer);
    function Add: TOFXItem;
    function InfLine(sLine: string): string;
    function FindString(sSubString, sString: string): boolean;
  protected
  published
    property OFXFile: string read FOFXFile write FOFXFile;
  end;

procedure Register;

implementation

constructor TLeitorOFX.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FListItems := TList.Create;
end;

destructor TLeitorOFX.Destroy;
begin
  Clear;
  FListItems.Free;
  inherited Destroy;
end;

procedure TLeitorOFX.Delete(iIndex: integer);
begin
  TOFXItem(FListItems.Items[iIndex]).Free;
  FListItems.Delete(iIndex);
end;

procedure TLeitorOFX.Clear;
begin
  while FListItems.Count > 0 do
    Delete(0);
  FListItems.Clear;
end;

function TLeitorOFX.Count: integer;
begin
  Result := FListItems.Count;
end;

function TLeitorOFX.Get(iIndex: integer): TOFXItem;
begin
  Result := TOFXItem(FListItems.Items[iIndex]);
end;

function TLeitorOFX.Import: boolean;
var
  oFile: TStringList;
  i: integer;
  bOFX: boolean;
  oItem: TOFXItem;
  sLine: string;
begin
  Clear;
  DateStart := '';
  DateEnd := '';
  bOFX := false;
  if not FileExists(FOFXFile) then
    raise Exception.Create('Arquivo n�o encontrado!');
  oFile := TStringList.Create;
  try
    oFile.LoadFromFile(FOFXFile);
    i := 0;

    while i < oFile.Count do
    begin
      sLine := oFile.Strings[i];
      if FindString('<OFX>', sLine) or FindString('<OFC>', sLine) then
        bOFX := true;

      if bOFX then
      begin
        // banco
        if FindString('<BANKID>', sLine) then
          BankID := InfLine(sLine);

        // conta
        if FindString('<ACCTID>', sLine) then
          AccountID := InfLine(sLine);

        // tipo da conta
        if FindString('<ACCTTYPE>', sLine) then
          AccountType := InfLine(sLine);

        // data
        if FindString('<DTSTART>', sLine) then
        begin
          if Trim(sLine) <> '' then
            DateStart :=
              DateToStr(EncodeDate(StrToIntDef(copy(InfLine(sLine), 1, 4), 0),
              StrToIntDef(copy(InfLine(sLine), 5, 2), 0),
              StrToIntDef(copy(InfLine(sLine), 7, 2), 0)));
        end;
        if FindString('<DTEND>', sLine) then
        begin
          if Trim(sLine) <> '' then
            DateEnd :=
              DateToStr(EncodeDate(StrToIntDef(copy(InfLine(sLine), 1, 4), 0),
              StrToIntDef(copy(InfLine(sLine), 5, 2), 0),
              StrToIntDef(copy(InfLine(sLine), 7, 2), 0)));
        end;

        // Final
        if FindString('<LEDGER>', sLine) or FindString('<BALAMT>', sLine) then
          FinalBalance := InfLine(sLine);

        // movimento
        if FindString('<STMTTRN>', sLine) then
        begin
          oItem := Add;
          while not FindString('</STMTTRN>', sLine) do
          begin
            Inc(i);
            sLine := oFile.Strings[i];

          if FindString('<TRNTYPE>', sLine) then
          begin
             if (InfLine(sLine) = '0') or (InfLine(sLine) = 'CREDIT')
             OR (InfLine(sLine) = 'DEP') then
                oItem.MovType := 'C'
             else
             if (InfLine(sLine) = '1') or (InfLine(sLine) = 'DEBIT')
             OR (InfLine(sLine) = 'XFER') then
                oItem.MovType := 'D'
              else
                oItem.MovType := 'OTHER';
            end;

            if FindString('<DTPOSTED>', sLine) then
              oItem.MovDate :=
                EncodeDate(StrToIntDef(copy(InfLine(sLine), 1, 4), 0),
                StrToIntDef(copy(InfLine(sLine), 5, 2), 0),
                StrToIntDef(copy(InfLine(sLine), 7, 2), 0));

            if FindString('<FITID>', sLine) then
              oItem.ID := InfLine(sLine);

            if FindString('<CHKNUM>', sLine) or FindString('<CHECKNUM>', sLine) then
              oItem.Document := InfLine(sLine);

            if FindString('<MEMO>', sLine) then
              oItem.Description := InfLine(sLine);

            if FindString('<TRNAMT>', sLine) then
              oItem.Value := InfLine(sLine);
          end;
        end;

      end;
      Inc(i);
    end;
    Result := bOFX;
  finally
    oFile.Free;
  end;
end;

function TLeitorOFX.InfLine(sLine: string): string;
var
  iTemp: integer;
begin
  Result := '';
  sLine := Trim(sLine);
  if FindString('>', sLine) then
  begin
    sLine := Trim(sLine);
    iTemp := Pos('>', sLine);
    if Pos('</', sLine) > 0 then
      Result := copy(sLine, iTemp + 1, Pos('</', sLine) - iTemp - 1)
    else

      Result := copy(sLine, iTemp + 1, length(sLine));
  end;
end;

function TLeitorOFX.Add: TOFXItem;
var
  oItem: TOFXItem;
begin
  oItem := TOFXItem.Create;
  FListItems.Add(oItem);
  Result := oItem;
end;

function TLeitorOFX.FindString(sSubString, sString: string): boolean;
begin
  Result := Pos(UpperCase(sSubString), UpperCase(sString)) > 0;
end;

procedure Register;
begin
  RegisterComponents('LeitorOFX', [TLeitorOFX]);
end;

end.
