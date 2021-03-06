﻿
&НаКлиенте
Функция офПолучитьКаталогВременныхФайлов() Экспорт 
	
	КаталогФайлов = КаталогВременныхФайлов() + "МенеджерБТИ\";
	
	СоздатьКаталог(КаталогФайлов);
	
	Возврат КаталогФайлов;
		
КонецФункции


&НаКлиенте
Функция офСохранитьКартинкуИзБуфераНаДиск(ИмяФайла = "") Экспорт
	
	ИмяФайлаКартинки = Неопределено;
	
	#Если Не ВебКлиент Тогда 
	КаталогВФ = КаталогВременныхФайлов();
	ИмяФайлаПрограммы = КаталогВФ + "CbToJPEG.exe";
	ДвоичныеДанныеПрограммы = Общий.офПолучитьОбщийМакет("CbToJPEG");
	ДвоичныеДанныеПрограммы.Записать(ИмяФайлаПрограммы);
	ФайлПрограммы = Новый Файл(ИмяФайлаПрограммы);
	
	Если ПустаяСтрока(ИмяФайла) Тогда 
		ИмяФайла = Формат(ТекущаяДата(), "ДФ=yyyyMMddHHmmss") + "_tmp.JPG";
	КонецЕсли;
	
	ИмяФайлаКартинки = КаталогВФ + Формат(ТекущаяДата(), "ДФ=yyyyMMddHHmmss") + "_tmp.JPG";
	
	СтрокаЗапуска = """"+ФайлПрограммы.ПолноеИмя+""" """+ИмяФайлаКартинки+"""";
	
	WshShell = Новый COMОбъект("WScript.Shell");
	WshShell.Run(СтрокаЗапуска, 0, Истина);
	
	УдалитьФайлы(ИмяФайлаПрограммы);
	
	ФайлКартинки = Новый Файл(ИмяФайлаКартинки);
	Если Не ФайлКартинки.Существует() Тогда 
		ИмяФайлаКартинки = Неопределено;
	КонецЕсли;
	#КонецЕсли
	
	Возврат ИмяФайлаКартинки;
		
КонецФункции

&НаКлиенте
Функция ЗадатьВопросОЗавершенииРаботы(Отказ) Экспорт
	
	Режим = РежимДиалогаВопрос.ДаНет;
	Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопроса", ОбщийКлиент);
	Отказ = Истина;
	ПоказатьВопрос(Оповещение, НСтр("ru = 'Продолжить выполнение операции?';"
	    + " en = 'Do you want to continue?'"), Режим, 0);
	
		
КонецФункции


&НаКлиенте
Процедура ПослеЗакрытияВопроса(Результат, Параметры) Экспорт
	
    Если Результат = КодВозвратаДиалога.Да Тогда
        ПрекратитьРаботуСистемы();
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЗадачуПоСсылке(Задача) Экспорт 
	
	мПараметры = Новый Структура("Ключ", Задача);
	ФормаЗадача = ПолучитьФорму("Документ.Задача.ФормаОбъекта", мПараметры);
	ФормаЗадача.Открыть();
	
КонецПроцедуры

