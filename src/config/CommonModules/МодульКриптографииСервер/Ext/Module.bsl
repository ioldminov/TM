﻿Функция ПолучитьЗашифрованныеДанные(ДанныеШифрования,КлючШифрования,ИдентификаторДанных = "0") Экспорт
    
    Попытка
        
        Путь = КаталогВременныхФайлов()+ИдентификаторДанных;
        ПутьФайла = Путь+".txt";
        ПутьАрхива = Путь+".zip";
        ЗаписьТекста = Новый ЗаписьТекста(ПутьФайла);
        ЗаписьТекста.Записать(ДанныеШифрования);
        ЗаписьТекста.Закрыть();
        ЗаписьАрхива = Новый ЗаписьZipФайла(ПутьАрхива,КлючШифрования,,,,МетодШифрованияZIP.AES256);
        ЗаписьАрхива.Добавить(ПутьФайла);
        ЗаписьАрхива.Записать();
        ДвоичныеДанные = Новый ДвоичныеДанные(ПутьАрхива);
        ХранилищеДанных = Новый ХранилищеЗначения(ДвоичныеДанные,Новый СжатиеДанных(9));
        УдалитьФайлы(ПутьФайла);
        УдалитьФайлы(ПутьАрхива);
        Возврат ХранилищеДанных;
        
    Исключение
        Возврат Неопределено;
    КонецПопытки; 

КонецФункции

Функция ПолучитьРасшифрованныеДанные(ХранилищеДанных,КлючШифрования,ИдентификаторДанных = "0") Экспорт
    
    Попытка
        КаталогСохранения = КаталогВременныхФайлов();
        Путь = КаталогСохранения+ИдентификаторДанных;
        ПутьАрхива = Путь+".zip";
        ХранилищеДанных.Получить().Записать(ПутьАрхива);
        ЧтениеАрхива = Новый ЧтениеZipФайла(ПутьАрхива,КлючШифрования);
        ЭлементАрхива = ЧтениеАрхива.Элементы[0];
        ЧтениеАрхива.Извлечь(ЭлементАрхива,КаталогСохранения);
        ЧтениеАрхива.Закрыть();
        ПутьФайла = КаталогСохранения+"\"+ЭлементАрхива.Имя;
        ЧтениеТекста = Новый ЧтениеТекста(ПутьФайла);
        Данные = ЧтениеТекста.Прочитать();
        ЧтениеТекста.Закрыть();
        УдалитьФайлы(ПутьАрхива);
        УдалитьФайлы(ПутьФайла);
        Возврат Данные;
        
    Исключение
        Возврат Неопределено;
    КонецПопытки; 

КонецФункции

Процедура ЗаписатьМастерПарольВПараметрыСеанса(МастерПароль) Экспорт
	
	ПараметрыСеанса.МастерПароль = МастерПароль;
	
КонецПроцедуры

Функция НебходимоВвестиМастерПароль() Экспорт
	
	Результат = Истина;
	
	ХешСуммаХранимогоПароля  = Константы.ХэшМастерПароля.Получить();
	
	Если ЗначениеЗаполнено(ПараметрыСеанса.МастерПароль) Тогда
		
		ОбъектХеш = Новый ХешированиеДанных(ХешФункция.MD5);
		ОбъектХеш.Добавить(ПараметрыСеанса.МастерПароль);
		ХешСуммаВведенногоПароля = Строка(ОбъектХеш.ХешСумма);
		
		Если ХешСуммаВведенногоПароля = ХешСуммаХранимогоПароля Тогда
			Результат = Ложь;
		КонецЕсли; 
	ИначеЕсли Не ЗначениеЗаполнено(ХешСуммаХранимогоПароля) Тогда
		Результат = Ложь;
	КонецЕсли; 
	
	Возврат Результат;
	
КонецФункции

Процедура УстановитьЗначениеМастерПароляНаСервере(НовыйПароль) Экспорт
	
	ОбъектХеш = Новый ХешированиеДанных(ХешФункция.MD5);
	ОбъектХеш.Добавить(НовыйПароль);
	
	Константы.ХэшМастерПароля.Установить(ОбъектХеш.ХешСумма);
	
КонецПроцедуры