# Модуль JSONHelper.pas JSONValue Helper
## Для чего нужны "Хелперы" (помощники)? 
**Помощник класса** – это способ добавления методов и свойств к классу, который вы не имеете права изменять(как класс библиотеки). Есть классы библиотек чаще всего сторонних возможно даже и собственных, изменения кода которых может привести к множественным изменениям в коде программ, которые их используют  и это не хорошо. Потому что нарушает один из принципов S.O.L.I.D  2. "O" Open/Closed Principle (Принцип открытости/закрытости) Классы должны быть **открыты для расширения**, но **закрыты для модификации**
Т.е. нельзя переделывать классы (модифицировать) для нужд конкретной задачи конкретной программы, но можно добавить расширение и новые возможности уже существующим классам для этих целей и были созданы "Помощники" - "Хелперы".
 Предлагаю  хелпер для TJSONValue  
 Слышал от некоторых разработчиков в частности от "Gemul GM", что с  TJSONValue  неудобно работать, так как  неудобно читать данные , особенно если  TJSONValue имеет древовидную структуру т.е.  множественность вложенных объектов и это правда. В частности он предлагает конвертировать JSON oбъекты  в классические объекты посредством методов "DeSerialization" SJONObject to TOblect. 
Например,  Сервер отправляет ответ виде JSON  и ответ предлагается преобразовать 
в ТОbject 

```pascal
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
И на первый взгляд это удобно, когда у вас объекты не имеют сложной структуры и имеется простой прототип класса, но когда наоборот  объекты имеют всевозможные вложенные суб-классы то это становится задачей довольно не тривиальной описать целую кучу классов и их суб-классы, даже в демо-программе в примере я ограничился простым примером использования десериализатора и простенького класса, и не стал делать класс прототип для основного файла примера Exmple.json. Хоть файл примера .json и простой, но потребовал бы написать довольно много кода. Еще, что я считаю минусом в использовании десериализаторов и сериализаторов это то, что нужно иметь множество прототипов классов, и если что то изменится в протоколе то их нужно переделывать. Отсюда вытекает мысль, что это нужно использовать там где без этого не обойтись.

Например,  не стоит десериализовывать огромную структуру JSON объекта, только что бы 
прочитать из нее значения нескольких полей из вложенных объектов, потому что это нерационально и потому что можно сделать проще. 
Я предлагаю иной подход, который ничего не требует преобразовывать и согласуется c вышеописанным принципам S.O.L.I.D. Это иметь расширение "хелпер" т.е. дополнительные методы для чтения данных непосредственно из TJSONVаlue.

1. Функция **GetValueHlpr** - ищет имя поля и читает в текущем объекте 
2. Функция **GetValueFromTreeHlpr** - ищет заданное имя поля в дереве объектов имена которых нужно записать в виде пути, например так **"user\profile\firstName"**. 
   
**Параметр <T>** -  здесь нужно задать тот тип значения, которые нужно прочитать, которым владеет искомое поле а также можно преобразовывать строковые типы в integer и наоборот. Но если укажете, что нужно прочитать TJSONObject, а значение окажется TJSONArray - произойдет исключение "несоответствие типов" в дном случае а в другом случае исключение с ошибкой памяти и автоматического преобразование не произойдет, нужно иметь ввиду что не все типы можно преобразовать от слова совсем. смотрите примеры.      

**Параметр** **"Separator"**  это разделитель пути, который нужно задавать, потому что в пути поиска можно использовать любые символы разделения пути, что бы избежать коллизий 
например: есть вложенный объект с именем "CPU\Intel" в искомом пути "PC\CPU\Inte\Cores" то использование сепаратора "\" будет приводить к ошибке имя "CPU\Inte" будет разделяться на два имени, значит стоит использовать другой знак сепаратора, например ";" значит вы должны юудете написать такой путь "PC;CPU\Inte;Cores" или что то бодобное.  
       
**Параметры** **ValueName** и **Path** - Задают имя искомого поля и путь до искомого поля
если мы хотим прочитать имя пользователя из поля "firstName" нужно написать такой путь **"user\profile\firstName"**

 Параметр:  **RaiseUp**  - По умолчанию имеет значение "true" - означает будет ли подниматься исключение при ошибках:   
  3.  пустые значения ValueName / Path 
  4.  несоответствие типов данных
  5.  Когда искомое имя Value не найдено

 **Примеры использования:**  
 
 ```pascal

  show('get string value fom path ' + edValueName.Text + ': ' +
         FJSON.GetValueFromTreeHlpr<String>(edValueName.Text, '\'));

  // Чтение значение integer как integer
  show('get integer value as integer fom path: "user\profile\age": ' +
       FJSON.GetValueFromTreeHlpr<integer>('user\profile\age', '\').ToString);

  // Чтение значения integer как string
  show('get integer value as string fom path: "user\profile\age": ' +
       FJSON.GetValueFromTreeHlpr<String>('user\profile\age', '\'));

  // Чтение объекта как TJSONObject
  var profile := FJSON.GetValueFromTreeHlpr<TJSONObject>('user\profile', '\');
  if Assigned(profile) then
    show('get JSONObject value as toString fom path: "user\profile": '+ profile.ToString);

  // Чтение массива как TJSONArray
  var friends := FJSON.GetValueFromTreeHlpr<TJSONArray>('user\friends', '\');
  if Assigned(friends) then
   show('get array form path: "user\friends": ' + friends.ToString);

  // Чтение массива как TJSONObject получим исключение
  var friends_error := FJSON.GetValueFromTreeHlpr<TJSONObject>('user\friends', '\');
  if Assigned(friends_error) then
   show('get array form path: "user\friends": ' + friends_error.ToString);
 ```
 ![Screenshot](https://github.com/superbot-coder/JSONValueHelper/blob/main/images/Image-01.png "")

##### Telegram channel: https://t.me/delphi_solutions
##### Telegram chat: https://t.me/delphi_solutions_chat
##### Telegram video: https://t.me/delphi_solutions_video