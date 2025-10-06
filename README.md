# Модуль JSONHelper.pas JSONValue Helper
## Для чего нужны "Хелперы" (помощники)? 
**Помощник класса** – это способ добавления методов и свойств к классу, который вы не имеете права изменять(как класс библиотеки). Есть классы библиотек чаще всего сторонних возможно даже и собственных, изменения кода которых может привести к множественным изменениям в коде программ, которые их используют  и это не хорошо. Потому что нарушает один из принципов в ООП S.O.L.I.D  №2 "O." Open/Closed Principle (Принцип открытости/закрытости) Классы должны быть **открыты для расширения**, но **закрыты для модификации**
Т.е. нельзя переделывать классы (модифицировать) для нужд конкретной задачи конкретной программы, но можно добавить расширение и новые возможности уже существующим классам для этих целей и были созданы "Помощники" - "Хелперы".
 Предлагаю  хелпер для TJSONValue  
 Слышал от некоторых разработчиков в частности от "Gemul GM", что с  TJSONValue  неудобно работать, так как  неудобно читать данные , особенно если  TJSONValue имеет древовидную структуру т.е.  множественность вложенных объектов и это правда. В частности он предлагает конвертировать JSON oбъекты  в классические объекты посредством методов "DeSerialization" из JSONstring / TJSONObject to  TOblect. 
Например,  Сервер отправляет ответ виде JSON  ответ предлагается преобразовать 
в TRespSvr через десериализатор "TJson.JsonToObject"

```pascal
type
  
  // Прототип класса
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

//  *** 
  var ResponseStr := '{"ok":false,"error_code":404,"description":"Not Found"}';
  var RespSvr := TJson.JsonToObject<TRespSvr>(ResponseStr, [joIndentCaseLower]);
 if Assigned(RespSvr) then
  begin
    show('OK: ' + BoolToStr(RespSvr.OK));
    show('ErroCode: ' + RespSvr.ErrorCode.ToString);
    show('Description: ' + RespSvr.Description);
    RespSvr.Free;
  end;
```
И это удобно, когда у вас объекты не имеют сложной структуры и имеется простой прототип класса, но когда объекты имеют всевозможные вложенные суб-классы то это становится задачей довольно не тривиальной описать целую кучу классов и их суб-классы.  Еще неудобством в использовании десериализаторов и сериализаторов  может быть то, что нужно иметь множество прототипов классов на каждый JSON объект и если что то изменится в структуре данных  JSON то нужно переделывать и прототип класса.  В пользу расширения методов чтения или записи классов TJSONValue  или  TJSONObject говорит тот факт, что они **универсальны** их можно применить к любому объекту TJSONValue с любой иерархией и вложенностью объектов не создавая прототипы классов на каждый случай. 

Например,  не стоит десериализовывать огромную структуру JSON объекта, только что бы 
прочитать из нее значения нескольких полей из вложенных объектов, потому что это нерационально и потому что можно сделать проще. 
Я предлагаю иной подход, который ничего не требует преобразовывать и согласуется c вышеописанным принципом S.O.L.I.D. это иметь расширение "хелпер" который "расширяет" методы для чтения данных класса TJSONVаlue.

1. Функция:
 **GetValueHlpr<T>(const ValueName: string; RaiseUp: Boolean = true): T;** 
    - ищет имя поля и читает в текущем объекте 
   2. Функция:
**GetValueTreeHlpr<T>(const Path: string; const Separator: char; RaiseUp: Boolean = true): T;**
    - ищет заданное имя поля в дереве объектов имена которых нужно записать в виде пути, например так **"user\profile\firstName"**. 
   
**Параметр <T>** -  здесь нужно задать тот тип значения, которые нужно прочитать, которым владеет искомое поле а также можно преобразовывать строковые типы в integer и наоборот. Но если укажете, что нужно прочитать TJSONObject, а значение окажется TJSONArray - произойдет исключение "несоответствие типов" в дном случае а в другом случае исключение с ошибкой памяти и автоматического преобразование не произойдет, нужно иметь ввиду что не все типы можно преобразовать от слова совсем. смотрите примеры.      

**Параметр** **"Separator"**  это разделитель пути, который нужно задавать, потому что в пути поиска можно использовать любые символы разделения пути, что бы избежать коллизий 
например: есть вложенный объект с именем "CPU\Intel" в искомом пути "PC\CPU\Inte\Cores" то использование сепаратора "\" будет приводить к ошибке имя "CPU\Inte" будет разделяться на два имени, значит стоит использовать другой знак сепаратора, например ">" значит вы должны будете написать такой путь "PC>CPU\Inte>Cores" главное, что бы символ не встречался в самих именах.   
       
**Параметры** **ValueName** и **Path** - Задают имя искомого поля и путь до искомого поля
если мы хотим прочитать имя пользователя из поля "firstName" нужно написать такой путь **"user\profile\firstName"**

 Параметр:  **RaiseUp**  - По умолчанию имеет значение "true" - означает будет ли подниматься исключение при ошибках:   
  3.  пустые значения ValueName / Path 
  4.  несоответствие типов данных
  5.  Когда искомое имя Value не найдено

 **Примеры использования:**  
 
 ```pascal

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
 ```
 ![Screenshot](https://github.com/superbot-coder/JSONValueHelper/blob/main/images/Image-01.png "")

##### Telegram channel: https://t.me/delphi_solutions
##### Telegram chat: https://t.me/delphi_solutions_chat
##### Telegram video: https://t.me/delphi_solutions_video