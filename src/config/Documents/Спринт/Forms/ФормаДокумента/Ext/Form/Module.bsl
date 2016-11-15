﻿
&НаСервере
Процедура ПеретаскиваниеЗадач(ОбъектПеретаскивания)
	
	Если ТипЗнч(ОбъектПеретаскивания) = Тип("ДокументСсылка.Задача") Тогда
	
		МассивПеретаскивания = Новый Массив;
		МассивПеретаскивания.Добавить(ОбъектПеретаскивания);
		
	Иначе
		
		МассивПеретаскивания = ОбъектПеретаскивания;
		
	КонецЕсли;
	
	Отбор = Новый Структура("Задача");
	Для Каждого ТекСтрока Из МассивПеретаскивания Цикл
		Если ТипЗнч(ТекСтрока) = Тип("ДокументСсылка.Задача") Тогда
			
			Отбор.Задача = ТекСтрока;
			
			Если Объект.СоставСпринта.НайтиСтроки(Отбор).Количество() = 0 Тогда 
				
				НоваяСтрока = Объект.СоставСпринта.Добавить();
				НоваяСтрока.Задача = ТекСтрока;
				
			КонецЕсли;
		
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры


&НаКлиенте
Процедура СоставСпринтаПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	ПеретаскиваниеЗадач(ПараметрыПеретаскивания.Значение);
	ЭтаФорма.Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СоставСпринтаПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	Если ПараметрыПеретаскивания.Значение = Неопределено Тогда
		ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Отмена;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СостоянияЗадач.Параметры.УстановитьЗначениеПараметра("Ссылка", ?(ЗначениеЗаполнено(Объект.Ссылка), Объект.Ссылка, Неопределено));
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	ОбновитьСтатистикуСпринта();
	
КонецПроцедуры

&НаСервере
Функция ПолучитьСтатистикуСпринта()
	
	СтатистикаСпринта = Новый Структура("ОткрытыхЗадач, ЗакрытыхЗадач", 0, 0);
	
	Для Каждого ТекСтрока Из Объект.СоставСпринта Цикл
		
		Если ТекСтрока.Задача.СостояниеЗадачи = Справочники.СостоянияЗадач.Закрыта Тогда
			СтатистикаСпринта.ЗакрытыхЗадач = СтатистикаСпринта.ЗакрытыхЗадач + 1;
		Иначе
			СтатистикаСпринта.ОткрытыхЗадач = СтатистикаСпринта.ОткрытыхЗадач + 1;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат СтатистикаСпринта;
		
КонецФункции


&НаКлиенте
Процедура ОбновитьСтатистикуСпринта()

	СтатистикаСпринта = ПолучитьСтатистикуСпринта();
	
	Элементы.СоставСпринтаОткрытых.Заголовок = "Открыто: " + СтатистикаСпринта.ОткрытыхЗадач;
	Элементы.СоставСпринтаЗакрытых.Заголовок = "Закрыто: " + СтатистикаСпринта.ЗакрытыхЗадач;
	Элементы.СоставСпринтаПроцентВыполнения.Заголовок = "% выполнения: " + Формат(СтатистикаСпринта.ЗакрытыхЗадач / (СтатистикаСпринта.ЗакрытыхЗадач + СтатистикаСпринта.ОткрытыхЗадач) * 100, "ЧДЦ=2");
	
КонецПроцедуры
