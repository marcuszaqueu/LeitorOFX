unit frmLeitorOFX;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Mask,  DB, DBClient, StdCtrls, ExtCtrls, RxToolEdit;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Memo1: TMemo;
    Button1: TButton;
    FilenameEdit1: TFilenameEdit;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses uLerOFX;

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var LerOFX: TLeitorOFX;
    i: Integer;
begin
   try
      LerOFX := TLeitorOFX.Create(nil);

      LerOFX.OFXFile := FilenameEdit1.Text;
      try
         LerOFX.Import;
      except on E: Exception do
         raise Exception.Create('Erro: ' + E.Message);
      end;

      Memo1.Clear;
      Memo1.Lines.Add('Banco: ' + LerOFX.BankID);
      Memo1.Lines.Add('Conta: ' + LerOFX.AccountID);
      Memo1.Lines.Add('----------------');

      for i := 0 to LerOFX.Count-1 do
      begin
        Memo1.Lines.Add('#         | '+IntToStr(i));
        Memo1.Lines.Add('ID        | '+ LerOFX.Get(i).ID);
        Memo1.Lines.Add('Documento | '+ LerOFX.Get(i).Document);
        Memo1.Lines.Add('Data      | '+ DateToStr(LerOFX.Get(i).MovDate));
        Memo1.Lines.Add('Tipo      | '+ LerOFX.Get(i).MovType);
        Memo1.Lines.Add('Valor     | '+ LerOFX.Get(i).Value);
        Memo1.Lines.Add('Descricao | '+ LerOFX.Get(i).Description);

      end;

      Memo1.Lines.Add('----------------');
      Memo1.Lines.Add('Saldo Final: ' + LerOFX.FinalBalance);

   finally
      FreeAndNil(LerOFX);
   end;
end;

end.
