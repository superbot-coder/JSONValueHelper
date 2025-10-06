unit JSONHelper;

interface

USES
  System.SysUtils,
  //System.Classes,
  //System.Generics.Collections,
  System.JSON;

type
  TJSONValueHelper = class helper for TJSONValue
  private
    const
      EMsgValPathEmpty = 'Error: The %s is Empty';
  public
    function GetValueHlpr<T>(const ValueName: string; RaiseUp: Boolean = true): T;
    function GetValueTreeHlpr<T>(const Path: string; const Separator: char; RaiseUp: Boolean = true): T;
    // эта часть будет доделана позже
    // procedure SetValueHlpr<T>(const ValueName: string; const Value: T; RaiseUp: boolean = true);
    // procedure SetValueTreeHlpr<T>(const Path: string; const Value: T; RaiseUp: boolean = true);
  end;

implementation

{ TJSONValueHelper }

function TJSONValueHelper.GetValueHlpr<T>(const ValueName: string; RaiseUp: Boolean = true): T;
begin
  if ValueName.IsEmpty and RaiseUp then
    raise Exception.Create(System.SysUtils.format(EMsgValPathEmpty, ['ValueName']));

  if RaiseUp then
    Result := Self.GetValue<T>(ValueName)
  else
    Self.TryGetValue<T>(ValueName, Result);
end;

(*
procedure TJSONValueHelper.SetValueHlpr<T>(const ValueName: string; const Value: T; RaiseUp: boolean = true);
begin
  if ValueName.IsEmpty and RaiseUp then
    raise Exception.Create(System.SysUtils.format(EMsgValPathEmpty, ['ValueName']));
end;

procedure TJSONValueHelper.SetValueTreeHlpr<T>(const Path: string;
  const Value: T; RaiseUp: boolean);
begin
  if Path.IsEmpty and RaiseUp then
    raise Exception.Create(System.SysUtils.format(EMsgValPathEmpty, ['Path']));
end;
  *)

function TJSONValueHelper.GetValueTreeHlpr<T>(const Path: string;
  const Separator: char; RaiseUp: Boolean = true): T;
var
  ArPath : TArray<string>;
  LenPath : UInt8;
  JSVInput: TJSONValue;
begin
  if (Path.IsEmpty) or (Not Assigned(self)) then
  begin
    if RaiseUp then
      raise Exception.Create(System.SysUtils.format(EMsgValPathEmpty, ['Path']))
    else
      exit;
  end;

  ArPath := Path.Trim([Separator]).Split([Separator]);

  LenPath := High(ArPath);
  if Length(ArPath) = 0 then
    Exit;
  JSVInput := self;
  for var i := 0 to LenPath do
  begin
    var Found := JSVInput.FindValue(ArPath[i]);
    if not Assigned(Found) then
      exit;
    if i <> LenPath  then
    begin
      if Found is TJSONObject then
      begin
        JSVInput := Found;
        Continue;
      end
      else
        if RaiseUp then
          raise Exception.Create('Error: Found Value ' + ArPath[i] + ' not is TJSONObject')
        else
          Exit;
    end
    else
    if RaiseUp then
      Result := Found.AsType<T>
    else
      Found.TryGetValue<T>(Result);
  end;

end;

end.
