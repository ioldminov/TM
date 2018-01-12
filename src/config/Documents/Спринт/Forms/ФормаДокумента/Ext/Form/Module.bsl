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
	
	//УсловноеОформление.Элементы.Очистить();  
	//
	//ЭлементУО = УсловноеОформление.Элементы.Добавить();
	//ДобавитьОформляемоеПоле(ЭлементУО.Поля, "СоставСпринтаЗадача");
	//
	////ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,	"СоставСпринтаЗадачаСостояниеЗадачи", ВидСравненияКомпоновкиДанных.НеРавно, Справочники.СостоянияЗадач.ВРаботе);
	////ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,	"Объект.СоставСпринта.Задача.СостояниеЗадачи", ВидСравненияКомпоновкиДанных.НеРавно, Справочники.СостоянияЗадач.ВРаботе);
	//ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,	"Объект.СоставСпринта.Состояние", ВидСравненияКомпоновкиДанных.Равно, Справочники.СостоянияЗадач.ВРаботе);
	//
	//ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветФона", ЦветаСтиля.ЦветНовая);	
	
	Для Каждого ТекСтрока Из Объект.СоставСпринта Цикл 
		ТекСтрока.Состояние = ТекСтрока.Задача.СостояниеЗадачи;
	КонецЦикла;
	
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

&НаКлиентеНаСервереБезКонтекста
Функция ЗадачаПрисутствуетВСписке(Задача, СоставСпринта)
	
	мОтбор = Новый Структура("Задача", Задача);
	
	НайденныеСтроки = СоставСпринта.НайтиСтроки(мОтбор);
	Если НайденныеСтроки.Количество() > 0 Тогда
		Результат = Истина;
	Иначе
		Результат = Ложь;
	КонецЕсли;
	
	Возврат Результат;
		
КонецФункции

&НаКлиенте
Процедура ОбновитьРеквизитыСтрокиСоставаСпринта(ТекущиеДанные)
	
	Если Не ЗначениеЗаполнено(ТекущиеДанные.ИсполнительРаспределение) Тогда
		ТекущиеДанные.ИсполнительРаспределение = ПолучитьРеквизитЗадачиНаСервере(ТекущиеДанные.Задача, "Исполнитель");	
	КонецЕсли;
	ТекущиеДанные.Состояние = ПолучитьРеквизитЗадачиНаСервере(ТекущиеДанные.Задача, "СостояниеЗадачи");
		
КонецПроцедуры


&НаКлиенте
Процедура ОбновитьРеквизитыВсехСтрокСоставаСпринта()
	
	Для Каждого ТекущиеДанные Из Объект.СоставСпринта Цикл
		ОбновитьРеквизитыСтрокиСоставаСпринта(ТекущиеДанные);
	КонецЦикла;
		
КонецПроцедуры


&НаКлиенте
Процедура СоставСпринтаЗадачаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.СоставСпринта.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда 
		Если ЗадачаПрисутствуетВСписке(ТекущиеДанные.Задача, Объект.СоставСпринта) Тогда
			Сообщить("" + ТекущиеДанные.Задача + " уже присутствует в списке!");
		КонецЕсли;
		ОбновитьРеквизитыСтрокиСоставаСпринта(ТекущиеДанные);
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

&НаСервере
Функция ДобавитьОформляемоеПоле(КоллекцияОформляемыхПолей, ИмяПоля) Экспорт
    
    ПолеЭлемента         = КоллекцияОформляемыхПолей.Элементы.Добавить();
    ПолеЭлемента.Поле     = Новый ПолеКомпоновкиДанных(ИмяПоля);

    Возврат ПолеЭлемента;
    
КонецФункции

&НаСервере
Функция ДобавитьЭлементКомпоновки(ОбластьДобавления,
                                    Знач ИмяПоля,
                                    Знач ВидСравнения,
                                    Знач ПравоеЗначение = Неопределено,
                                    Знач Представление  = Неопределено,
                                    Знач Использование  = Неопределено,
                                    знач РежимОтображения = Неопределено,
                                    знач ИдентификаторПользовательскойНастройки = Неопределено) Экспорт
    
    Элемент = ОбластьДобавления.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
    Элемент.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ИмяПоля);
    Элемент.ВидСравнения = ВидСравнения;
    
    Если РежимОтображения = Неопределено Тогда
        Элемент.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
    Иначе
        Элемент.РежимОтображения = РежимОтображения;
    КонецЕсли;
    
    Если ПравоеЗначение <> Неопределено Тогда
        Элемент.ПравоеЗначение = ПравоеЗначение;
    КонецЕсли;
    
    Если Представление <> Неопределено Тогда
        Элемент.Представление = Представление;
    КонецЕсли;
    
    Если Использование <> Неопределено Тогда
        Элемент.Использование = Использование;
    КонецЕсли;
    
    // Важно: установка идентификатора должна выполняться
    // в конце настройки элемента, иначе он будет скопирован
    // в пользовательские настройки частично заполненным.
    Если ИдентификаторПользовательскойНастройки <> Неопределено Тогда
        Элемент.ИдентификаторПользовательскойНастройки = ИдентификаторПользовательскойНастройки;
    ИначеЕсли Элемент.РежимОтображения <> РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный Тогда
        Элемент.ИдентификаторПользовательскойНастройки = ИмяПоля;
    КонецЕсли;
    
    Возврат Элемент;
    
КонецФункции

&НаКлиенте
Процедура СоставСпринтаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя = "СоставСпринтаЗадачаСуть" ИЛИ Поле.Имя = "СоставСпринтаЗадачаНомер" Тогда 
		СтандартнаяОбработка = Ложь;
		Если Элемент.ТекущиеДанные <> Неопределено Тогда 
			ОбщийКлиент.ОткрытьЗадачуПоСсылке(Элемент.ТекущиеДанные.Задача);
		КонецЕсли; 
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьЗадачиПоСпискуНомеровНаСервере(СписокЗадач)
	
	Для К = 1 По СтрЧислоСтрок(СписокЗадач) Цикл
		
		Попытка
			
			ТекНомерЗадачи = СтрПолучитьСтроку(СписокЗадач, К);
			мНомер = Число(ТекНомерЗадачи); // если введены только цифры, то есть смысл поискать по номеру задачи. Обрабатывается "попыткой"
			ЗадачаСсылка = Общий.офПолучитьЗадачуПоНомеру("" + ТекНомерЗадачи);
			
			Если ЗначениеЗаполнено(ЗадачаСсылка) Тогда
				Если ЗадачаПрисутствуетВСписке(ЗадачаСсылка, Объект.СоставСпринта) Тогда 
					Сообщить("" + ЗадачаСсылка + " уже присутствует в списке! Добавление строки отменено.");
				Иначе 
					НоваяСтрока = Объект.СоставСпринта.Добавить();
					НоваяСтрока.Задача = ЗадачаСсылка;
				КонецЕсли;
			Иначе 
				Сообщить("Задача с номером <"+ТекНомерЗадачи+"> не обнаружена!");
			КонецЕсли;
			
		Исключение
		КонецПопытки;
		
	КонецЦикла;

	
КонецПроцедуры


&НаКлиенте
Процедура ДобавитьЗадачиПоСпискуНомеров(Команда)
	
	СписокЗадач = "";
	Если ВвестиСтроку(СписокЗадач, "Введите номера задач", 0, Истина) Тогда 
		ДобавитьЗадачиПоСпискуНомеровНаСервере(СписокЗадач);
		ОбновитьРеквизитыВсехСтрокСоставаСпринта();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьРеквизитыСтрок(Команда)
	
	ОбновитьРеквизитыВсехСтрокСоставаСпринта();
	
КонецПроцедуры

&НаСервере
Процедура СортироватьСписокПоТекущейКолонке(ПоУбыванию)
	
	ПутьКДанным = Элементы.СоставСпринта.ТекущийЭлемент.ПутьКДанным;
	
	Если СтрНайти(ПутьКДанным, "Объект.СоставСпринта.Задача.") > 0 Тогда 
		// Это вспомогательная колонка
		ИмяКолонки = СтрЗаменить(ПутьКДанным, "Объект.СоставСпринта.Задача.", "");
		ТЗСортировка = Объект.СоставСпринта.Выгрузить();
		ТЗСортировка.Колонки.Добавить(ИмяКолонки);
		
		Для Каждого ТекСтрока Из ТЗСортировка Цикл
			ТекСтрока[ИмяКолонки] = ТекСтрока.Задача[ИмяКолонки];
		КонецЦикла;
		
		ТЗСортировка.Сортировать(ИмяКолонки + ?(ПоУбыванию, " УБЫВ", ""));
		
		Объект.СоставСпринта.Загрузить(ТЗСортировка);
		//Для Каждого ТекСтрока Из ТЗСортировка Цикл
		//	
		//	мОтбор = Новый Структура("Задача", ТекСтрока.Задача);
		//	
		//	НайденныеСтроки = Объект.СоставСпринта.НайтиСтроки(мОтбор);
		//	Если НайденныеСтроки.Количество() > 0 Тогда
		//		ИндексСтрокиПоиска = Объект.СоставСпринта.Индекс(НайденныеСтроки[0]);
		//	КонецЕсли;
		//	
		//	Объект.СоставСпринта.НайтиСтроки(
		//	Объект.СоставСпринта.Индекс()
		//	Объект.СоставСпринта.Сдвинуть(ИндексСтрокиПоиска, КоличествоПозиций);
		//КонецЦикла;
		
	Иначе
		// Это основная колонка ТЧ
		ИмяКолонки = СтрЗаменить(ПутьКДанным, "Объект.СоставСпринта.", "");
		Объект.СоставСпринта.Сортировать(ИмяКолонки + ?(ПоУбыванию, " УБЫВ", ""));
	КонецЕсли;
		
КонецПроцедуры


&НаКлиенте
Процедура СортироватьПоУбыванию(Команда)
	
	СортироватьСписокПоТекущейКолонке(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СортироватьПоВозрастанию(Команда)
	                           
	СортироватьСписокПоТекущейКолонке(Ложь);
	
КонецПроцедуры
