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
	Если СтатистикаСпринта.ЗакрытыхЗадач + СтатистикаСпринта.ОткрытыхЗадач = 0 Тогда
		Элементы.СоставСпринтаПроцентВыполнения.Заголовок = "% выполнения: -";
	Иначе 
		Элементы.СоставСпринтаПроцентВыполнения.Заголовок = "% выполнения: " + Формат(СтатистикаСпринта.ЗакрытыхЗадач / (СтатистикаСпринта.ЗакрытыхЗадач + СтатистикаСпринта.ОткрытыхЗадач) * 100, "ЧДЦ=2");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СоставСпринтаЗадачаОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	Попытка
		СтрокаПоиска = ПараметрыПолученияДанных.СтрокаПоиска;
		
		// если введены только цифры, то есть смысл поискать по номеру задачи
		мНомер = Число(СтрокаПоиска);
		ПараметрыПолученияДанных.СтрокаПоиска = Общий.офДобавитьЛидирующиеСимволы(СтрокаПоиска);
	Исключение
	КонецПопытки;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьИсполнителейНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Пользователи.Ссылка КАК Исполнитель
	|ИЗ
	|	Справочник.Пользователи КАК Пользователи
	|ГДЕ
	|	Пользователи.ОтображатьВПланеВыполненияЗадач = ИСТИНА
	|
	|УПОРЯДОЧИТЬ ПО
	|	Пользователи.Наименование";
	
	Объект.ЗагрузкаИсполнителей.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьИсполнителей(Команда)
	
	Если Объект.ЗагрузкаИсполнителей.Количество() > 0 Тогда 
		
		Оповещение = Новый ОписаниеОповещения("ЗаполнитьИсполнителейЗавершение", ЭтаФорма, Параметры);
		ПоказатьВопрос(Оповещение, "При заполнении исполнителей таблица будет очищена. Продолжить?", РежимДиалогаВопрос.ДаНет, 300);
		
	Иначе
		ЗаполнитьИсполнителейНаСервере();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьИсполнителейЗавершение(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ЗаполнитьИсполнителейНаСервере();
	КонецЕсли;

КонецПроцедуры


&НаСервере
Процедура ОбновитьТекЗагрузкуНаСервере()
	
	Для Каждого ТекСтрока Из Объект.ЗагрузкаИсполнителей Цикл
		
		мОтбор = Новый Структура("ИсполнительРаспределение", ТекСтрока.Исполнитель);
		
		НайденныеСтроки = Объект.СоставСпринта.НайтиСтроки(мОтбор);
		ТЗСоставСпринта = Объект.СоставСпринта.Выгрузить(НайденныеСтроки);
		
		ТекСтрока.СуммарнаяЗагрузка = ТЗСоставСпринта.Итог("ПредполагаемаяДлительность");
		
	КонецЦикла; 
	
КонецПроцедуры


&НаКлиенте
Процедура ОбновитьТекЗагрузку(Команда)
	ОбновитьТекЗагрузкуНаСервере();
КонецПроцедуры


&НаСервере
Функция ПолучитьРеквизитЗадачиНаСервере(Задача, ИмяРеквизита)

	Возврат Задача[ИмяРеквизита];
	
КонецФункции

&НаКлиенте
Процедура СоставСпринтаЗадачаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.СоставСпринта.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда 
		ТекущиеДанные.ИсполнительРаспределение = ПолучитьРеквизитЗадачиНаСервере(ТекущиеДанные.Задача, "Исполнитель");
		ТекущиеДанные.Состояние = ПолучитьРеквизитЗадачиНаСервере(ТекущиеДанные.Задача, "СостояниеЗадачи");
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура СоставСпринтаИсполнительРаспределениеПриИзменении(Элемент)
	ОбновитьТекЗагрузкуНаСервере();
КонецПроцедуры


&НаКлиенте
Процедура СоставСпринтаПредполагаемаяДлительностьПриИзменении(Элемент)
	ОбновитьТекЗагрузкуНаСервере();
КонецПроцедуры

