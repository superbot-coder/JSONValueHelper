unit UFrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, SynEdit, Vcl.Menus,
  System.IOUtils, System.JSON, System.Generics.Collections, SynEditHighlighter,
  SynEditCodeFolding, SynHighlighterJSON, Vcl.StdCtrls, System.StrUtils,
  REST.Json,
  JSONHelper;

type

  TRespSvr = class
  private
    FOK: Boolean;
    FErrorCode: integer;
    FDescript: string;
  public
    property OK: Boolean read FOK write FOK;
    property ErrorCode: integer read FErrorCode write FErrorCode;
    property Description: string read FDescript write FDescript;
  end;

  TForm1 = class(TForm)
    SynEdit: TSynEdit;
    PanelBar: TPanel;
    MainMenu: TMainMenu;
    MenuFile: TMenuItem;
    MenuOpenJSON: TMenuItem;
    MenuExit: TMenuItem;
    MenuSpliet: TMenuItem;
    MenuHelp: TMenuItem;
    MenuAbout: TMenuItem;
    OpenDialog: TOpenDialog;
    SynJSONSyn: TSynJSONSyn;
    BtnGetValue: TButton;
    Memo: TMemo;
    edValueName: TEdit;
    Splitter: TSplitter;
    LblValuePath: TLabel;
    BtnDeSerialize: TButton;
    procedure FormCreate(Sender: TObject);
    procedure MenuOpenJSONClick(Sender: TObject);
    procedure BtnGetValueClick(Sender: TObject);
    procedure BtnDeSerializeClick(Sender: TObject);
  private
    { Private declarations }
    FJSON: TJSONValue;
  public
    { Public declarations }
    procedure Show(const StrValue: String);
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.BtnDeSerializeClick(Sender: TObject);
begin
  var ResponseStr := '{"ok":false,"error_code":404,"description":"Not Found"}';
  var RespSvr := TJson.JsonToObject<TRespSvr>(ResponseStr, [joIndentCaseLower]);
  if Assigned(RespSvr) then
  begin
    show('OK: ' + BoolToStr(RespSvr.OK, true));
    show('ErroCode: ' + RespSvr.ErrorCode.ToString);
    show('Description: ' + RespSvr.Description);
    RespSvr.Free;
  end;



end;

procedure TForm1.BtnGetValueClick(Sender: TObject);
var
  A: TArray<string>;
  path: string;
begin


  if Assigned(FJSON.FindValue('user\profile\age')) then
    show('FindValue = true')
  else
    show('FindValue = false');

  //
  show('get string value fom path ' + edValueName.Text + ': ' +
         FJSON.GetValueTreeHlpr<String>(edValueName.Text, '\'));

  // Чтение значение integer как integer
  show('get integer value as integer fom path: "user\profile\age": ' +
       FJSON.GetValueTreeHlpr<integer>('user\profile\age', '\').ToString);

  // Чтение значения integer как string
  show('get integer value as string fom path: "user\profile\age": ' +
       FJSON.GetValueTreeHlpr<String>('user\profile\age', '\'));

  // Чтение объекта как TJSONObject
  var profile := FJSON.GetValueTreeHlpr<TJSONObject>('user\profile', '\');
  if Assigned(profile) then
    show('get JSONObject value as toString fom path: "user\profile": '+ profile.ToString);

  // Чтение массива как TJSONArray
  var friends := FJSON.GetValueTreeHlpr<TJSONArray>('user\friends', '\');
  if Assigned(friends) then
   show('get array form path: "user\friends": ' + friends.ToString);

  // Чтение массива как TJSONObject получим исключение
  var friends_error := FJSON.GetValueTreeHlpr<TJSONObject>('user\friends', '\');
  if Assigned(friends_error) then
   show('get array form path: "user\friends": ' + friends_error.ToString);


end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  PanelBar.Caption := '';
  SynEdit.Clear;
  memo.Clear;
  edValueName.Text := '';

  FJSON := TJSONObject.ParseJSONValue(TFile.ReadAllText('..\..\Example.json', TEncoding.UTF8));
  if Assigned(FJSON) then
  begin
    SynEdit.Text := TJSONAncestor(FJSON).Format;
    edValueName.Text := 'user\profile\firstName';
  end;
end;

procedure TForm1.MenuOpenJSONClick(Sender: TObject);
begin
  if Not OpenDialog.Execute then
    Exit;

  If Assigned(FJSON) then
    FreeAndNil(FJSON);

  FJSON := TJSONObject.ParseJSONValue(TFile.ReadAllText(OpenDialog.FileName, TEncoding.UTF8));
  if Assigned(FJSON) then
    SynEdit.Text := TJSONAncestor(FJSON).Format;

end;

procedure TForm1.Show(const StrValue: String);
begin
  Memo.Lines.Add(StrValue);
end;

end.
