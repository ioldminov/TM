﻿
Функция ПолучитьМассивРелизовКонфигурации() Экспорт 
	
	МассивРелизовКонфигурации = Новый Массив; 
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	РелизыКонфигураций.Наименование КАК Наименование,
	|	РелизыКонфигураций.Код
	|ИЗ
	|	Справочник.РелизыКонфигураций КАК РелизыКонфигураций
	|
	|УПОРЯДОЧИТЬ ПО
	|	Наименование";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	
	Пока Выборка.Следующий() Цикл 
		МассивРелизовКонфигурации.Добавить(Новый Структура("ID, Наименование", Выборка.Код, Выборка.Наименование));
	КонецЦикла;
	
	Возврат МассивРелизовКонфигурации;
	
КонецФункции

Функция ДобавитьТабуляцию(ИсходныйТекст)
	
	Результат = Символы.Таб;
	
	Для К = 1 по СтрЧислоСтрок(ИсходныйТекст) Цикл
		
		Результат = Результат + Символы.Таб + СтрПолучитьСтроку(ИсходныйТекст, К) + Символы.ПС;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ДобавитьПереносыСТрокHTML(ИсходныйТекст)
	
	Результат = "";
	
	Для К = 1 по СтрЧислоСтрок(ИсходныйТекст) Цикл
		
		Результат = Результат + СтрПолучитьСтроку(ИсходныйТекст, К) + "<br />";
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ПолучитьОписаниеПоставки(IDРелиза, ФорматHTML = Ложь) Экспорт 
	
	ОписаниеПоставки = "";
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Задача.ОписаниеРешения,
	|	Задача.Модуль КАК Модуль,
	|	Задача.Модуль.Наименование КАК НаименованиеМодуля
	|ИЗ
	|	Документ.Задача КАК Задача
	|ГДЕ
	|	Задача.ВключатьВОписаниеПоставки = ИСТИНА
	|	И Задача.СостояниеЗадачи = ЗНАЧЕНИЕ(Справочник.СостоянияЗадач.Закрыта)
	|	И Задача.РелизКонфигурации = &РелизКонфигурации
	|	И Задача.ВключатьВОписаниеПоставки = &ВключатьВОписаниеПоставки
	|
	|УПОРЯДОЧИТЬ ПО
	|	НаименованиеМодуля,
	|	Задача.Дата
	|ИТОГИ ПО
	|	Модуль";
	
	Запрос.УстановитьПараметр("РелизКонфигурации", Справочники.РелизыКонфигураций.НайтиПоКоду(IDРелиза));
	Запрос.УстановитьПараметр("ВключатьВОписаниеПоставки", Истина);
	
	ВыборкаМодули = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаМодули.Следующий() Цикл 
		Если ФорматHTML = Истина Тогда 
			ОписаниеПоставки = ОписаниеПоставки + 
			"
			|<tr> 
			|	<td colspan=""2""> <FONT color=#000000 face=Arial><strong>" + ВРЕГ(ВыборкаМодули.НаименованиеМодуля) + "</strong></FONT></td> 
			|</tr>
			|";
		Иначе
			ОписаниеПоставки = ОписаниеПоставки + ВРЕГ(ВыборкаМодули.НаименованиеМодуля) + Символы.ПС + Символы.ПС;
		КонецЕсли;
		
		ВыборкаОписанияРешения = ВыборкаМодули.Выбрать();
		
		Пока ВыборкаОписанияРешения.Следующий() Цикл 
			
												  //ВыборкаОписанияРешения.ОписаниеРешения
			Если ФорматHTML = Истина Тогда 
				ОписаниеПоставки = ОписаниеПоставки + 
				"
				|<tr> 
				|	<td width=""50"">&nbsp;</td> 
				|	<td> <FONT face=Verdana>" + СокрЛП(ДобавитьПереносыСТрокHTML(ВыборкаОписанияРешения.ОписаниеРешения)) + "</FONT></td>
				|</tr>
				|";
			Иначе 
				ОписаниеПоставки = ОписаниеПоставки + Символы.Таб + СокрЛП(ДобавитьТабуляцию(ВыборкаОписанияРешения.ОписаниеРешения)) + Символы.ПС + Символы.ПС;
			КонецЕсли;
		
		КонецЦикла;
	КонецЦикла;
	
	Возврат ОписаниеПоставки;
	
КонецФункции