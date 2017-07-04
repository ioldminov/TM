﻿
&НаКлиенте
Перем ТекНомерЗадачи, УИДФЗПроверкаНовостей;

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.РежимВыбора Тогда
	    Элементы.Список.РежимВыбора = Истина;
	КонецЕсли;	
	
	ксНастройкаСервер.ВосстановитьНастройкиСписка( ЭтаФорма );
	//уоУсловноеОформление.уоНастроитьУсловноеОформлениеСпискаЗадач(Список);
	
	Новости.Параметры.УстановитьЗначениеПараметра("Адресат", ПараметрыСеанса.ТекущийПользователь);
	Избранное.Параметры.УстановитьЗначениеПараметра("Пользователь", ПараметрыСеанса.ТекущийПользователь);
	ОтображатьПрочитанные = Ложь;
	ОтображатьТолькоСвежие = Ложь;
	УстановитьПараметрыСпискаНовостей();
	УстановитьПараметрыСпискаНовостейТолькоСвежиеНовости();
	
	История.Параметры.УстановитьЗначениеПараметра("ТекущаяЗадача", Неопределено);
	КомментарииТекущейЗадачи.Параметры.УстановитьЗначениеПараметра("ТекущаяЗадача", Неопределено);
	
	//АдресДанныхВХранилище = ПоместитьВоВременноеХранилище(Неопределено, ЭтаФорма.УникальныйИдентификатор);
	
	

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Общий.ЭтоПользователь() Тогда
		ОтборУстановлен = Ложь;
		Для Каждого ЭлОтбора Из Список.Отбор.Элементы Цикл
			Если Строка(ЭлОтбора.ЛевоеЗначение) ="Исполнитель" Тогда
				ЭлОтбора.ПравоеЗначение = Общий.ТекущийПользователь();
				ЭлОтбора.Использование = Истина;
				ОтборУстановлен = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Элементы.Отбор.Видимость = Ложь;
	КонецЕсли;
	
	ПодключитьОбработчикОжидания("НачатьПроверкуНаличияНовыхНовостей", 60);
	//ПодключитьОбработчикОжидания("СохранитьНастройкиСпискаНаКлиенте", 30);

КонецПроцедуры

#Область Новости

&НаСервере
Функция НачатьПроверкуНаличияНовыхНовостейНаСервере(мАдресВХранилище, мМаксДатаНовостей)

    мПараметры = Новый Массив;
    мПараметры.Добавить(мАдресВХранилище);
    мПараметры.Добавить(мМаксДатаНовостей);
	
	мУникальныйИдентификатор = Новый УникальныйИдентификатор;
    
    Задание = ФоновыеЗадания.Выполнить("фзФоновыеЗадания.ПроверитьНаличиеНовыхНовостей", 
        мПараметры, мУникальныйИдентификатор, "Проверить Наличие Новых Новостей");    
		
	Возврат Задание.УникальныйИдентификатор;
                        
КонецФункции

&НаКлиенте
Процедура НачатьПроверкуНаличияНовыхНовостей()
	
	Если Не ЗапретитьОповещениеОПоявленииНовостей Тогда 
		АдресДанныхВХранилище = ПоместитьВоВременноеХранилище(Неопределено, ЭтаФорма.УникальныйИдентификатор);
		УИДФЗПроверкаНовостей = НачатьПроверкуНаличияНовыхНовостейНаСервере(АдресДанныхВХранилище, МаксДатаНовостей);
		ОтключитьОбработчикОжидания("НачатьПроверкуНаличияНовыхНовостей");
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеФЗНаличиеНовостей", 5);
	КонецЕсли;
		
КонецПроцедуры

&НаСервереБезКонтекста
Функция ФЗЗаданиеВыполненоУспешно(мУИДФЗПроверкаНовостей)
	
	Возврат фзФоновыеЗадания.ЗаданиеВыполнено(мУИДФЗПроверкаНовостей);
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеФЗНаличиеНовостей()
	
	ЗаданиеВыполненоУспешно = ФЗЗаданиеВыполненоУспешно(УИДФЗПроверкаНовостей);
	
	Если ЗаданиеВыполненоУспешно Тогда 
		
		ОтключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеФЗНаличиеНовостей");
		ПодключитьОбработчикОжидания("НачатьПроверкуНаличияНовыхНовостей", 60);
			  
		СтруктураОперации = ПолучитьИзВременногоХранилища(АдресДанныхВХранилище);
		СвежиеНовостиПрисутствуют 	= СтруктураОперации.СвежиеНовостиПрисутствуют;
		МаксДатаНовостей 			= СтруктураОперации.МаксДатаНовостей;
		
		Если СвежиеНовостиПрисутствуют Тогда 
			НавигационнаяСсылка = ПолучитьНавигационнуюСсылкуИнформационнойБазы() + "#e1cib/navigationpoint/startpage";
			ПоказатьОповещениеПользователя("НОВОЕ СООБЩЕНИЕ", НавигационнаяСсылка, "В менеджере задач получено новое сообщение!
			|Откройте вкладку <Мои новости>", БиблиотекаКартинок.Внимание);
			//Сообщить("Новости!!");
		Иначе 
			//Сообщить("Новостей нет: " + МаксДатаНовостей);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти




&НаКлиенте
Процедура ОбновитьПорядокЗадач(Команда)

	Общий.офОбновитьПорядокЗадач();
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьПометку(Команда)
	
	Ответ = Вопрос("Установка пометки удаления:
	|	Да - установить пометку на все задачи
	|	Нет - снять пометку со всех задач
	|	Отмена - отменить действие", РежимДиалогаВопрос.ДаНетОтмена, 60);
	Если Ответ <> КодВозвратаДиалога.Да И Ответ <> КодВозвратаДиалога.Нет Тогда
		Возврат;
	ИначеЕсли Ответ = КодВозвратаДиалога.Да Тогда
		Пометка = Истина;
	ИначеЕсли Ответ = КодВозвратаДиалога.Нет Тогда
		Пометка = Ложь;
	КонецЕсли; 
	
	Общий.офИзменитьПометкуЗадач(Пометка);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВидимость(Команда)
	
	
	//Элементы.Содержание.Видимость = Элементы.СписокСодержаниеИзменитьВидимость.Пометка;
	
	Элементы.НастройкиСписка.Видимость = Элементы.СписокСодержаниеИзменитьВидимость.Пометка;
	Элементы.СписокСодержаниеИзменитьВидимость.Пометка = Не Элементы.СписокСодержаниеИзменитьВидимость.Пометка;
	
	
КонецПроцедуры

&НаКлиенте
Процедура НайтиПоНомеру(Команда)

	ОткрытьФормуЗадачи(НомерЗадачи);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуЗадачи(Знач мНомерЗадачи)
	
	мНомерЗадачи = СокрЛП(мНомерЗадачи);
	Если Не ПустаяСтрока(мНомерЗадачи) Тогда 
		ЗадачаСсылка = Общий.офПолучитьЗадачуПоНомеру(мНомерЗадачи);
		
		Если ЗадачаСсылка <> Неопределено Тогда
			мПараметры = Новый Структура("Ключ", ЗадачаСсылка);
			ФормаЗадача = ПолучитьФорму("Документ.Задача.ФормаОбъекта", мПараметры);
			ФормаЗадача.Открыть();
		Иначе 
			Сообщить("По заданному номеру <"+мНомерЗадачи+"> задача не найдена!");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры


&НаСервере
Процедура УстановитьОтборСпискаДанныхПоЗадаче(мНомерЗадачи)
	
	Если Элементы.ГруппаНовостиИсторияКомментарии.ТекущаяСтраница = Элементы.ГруппаИстория Тогда
		ЗадачаСсылка = Общий.офПолучитьЗадачуПоНомеру(мНомерЗадачи);
		История.Параметры.УстановитьЗначениеПараметра("ТекущаяЗадача", ЗадачаСсылка);
		Элементы.История.Обновить();
	ИначеЕсли Элементы.ГруппаНовостиИсторияКомментарии.ТекущаяСтраница = Элементы.ГруппаКомментарииТекущейЗадачи Тогда
		ЗадачаСсылка = Общий.офПолучитьЗадачуПоНомеру(мНомерЗадачи);
		КомментарииТекущейЗадачи.Параметры.УстановитьЗначениеПараметра("ТекущаяЗадача", ЗадачаСсылка);
		Элементы.КомментарииТекущейЗадачи.Обновить();
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура УстановитьТекущуюЗадачуВСписке(мНомерЗадачи)
	
	Если мНомерЗадачи <> "" Тогда 
		ЗадачаСсылка = Общий.офПолучитьЗадачуПоНомеру(мНомерЗадачи);
		Если ЗадачаСсылка <> Неопределено Тогда
			Элементы.Список.ТекущаяСтрока = ЗадачаСсылка;
			Элементы.Список.Обновить();
		Иначе
			Сообщить("По заданному номеру <"+мНомерЗадачи+"> задача не найдена!");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	Если Элементы.ГруппаНовостиИсторияКомментарии.ТекущаяСтраница = Элементы.ГруппаИстория 
		ИЛИ Элементы.ГруппаНовостиИсторияКомментарии.ТекущаяСтраница = Элементы.ГруппаКомментарииТекущейЗадачи Тогда
		
		мНомерЗадачи = Неопределено;
		Если Элемент.ТекущиеДанные <> Неопределено Тогда 
			Попытка
				мНомерЗадачи = Элемент.ТекущиеДанные.Номер;
			Исключение
			КонецПопытки;
		КонецЕсли; 
		
		Если ТекНомерЗадачи <> мНомерЗадачи Тогда  
			УстановитьОтборСпискаДанныхПоЗадаче(мНомерЗадачи);
			ТекНомерЗадачи = мНомерЗадачи;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ПриЗакрытии()
	
	СохранитьНастройкиСпискаНаСервере(); // todo
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьНастройкиСпискаНаКлиенте()
	
	СохранитьНастройкиСпискаНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкиСпискаНаСервере()
	
	ксНастройкаСервер.СохранитьНастройкиСписка(ЭтаФорма);
	
КонецПроцедуры


&НаКлиенте
Процедура ОткрытьЗадачуПоСсылке(Задача)
	
	мПараметры = Новый Структура("Ключ", Задача);
	ФормаЗадача = ПолучитьФорму("Документ.Задача.ФормаОбъекта", мПараметры);
	ФормаЗадача.Открыть();
	
КонецПроцедуры

&НаКлиенте
Процедура НовостиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Элемент.ТекущиеДанные <> Неопределено Тогда 
		ОткрытьЗадачуПоСсылке(Элемент.ТекущиеДанные.Объект);
	КонецЕсли; 
	
КонецПроцедуры


&НаКлиенте
Процедура ОткрытьЗадачу(Команда)
	
	ТекущиеДанные = Элементы.Новости.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда 
		ОткрытьЗадачуПоСсылке(ТекущиеДанные.Объект);
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура УстановитьАктивностьНаСервере(ТекущиеДанные)
	
	МенеджерЗаписи = РегистрыСведений.АдресацияНовостей.СоздатьМенеджерЗаписи();
	
	МенеджерЗаписи.Период		 	= ТекущиеДанные.Период;
	
	МенеджерЗаписи.Объект 			= ТекущиеДанные.Объект;
	МенеджерЗаписи.Адресат 			= ТекущиеДанные.Адресат;
	//МенеджерЗаписи.Пользователь 	= ТекущиеДанные.Пользователь;
	//
	//МенеджерЗаписи.СобытиеИстории	= ТекущиеДанные.СобытиеИстории;
	
	МенеджерЗаписи.Прочитать();
	Если МенеджерЗаписи.Выбран() Тогда
		МенеджерЗаписи.Прочитана = Не МенеджерЗаписи.Прочитана;
	КонецЕсли;
	
	МенеджерЗаписи.Записать(Истина);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьАктивностьМассиваДанныхНаСервере(МассивДанных)
	
	Для Каждого ТекущиеДанные Из МассивДанных Цикл
		УстановитьАктивностьНаСервере(ТекущиеДанные);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьАктивностьВсехЗаписейНаСервере(ТекущиеДанные)
	
	Выборка = ПолучитьВыборкуНовостейПоЗадачеНаСервере(ТекущиеДанные);
	
	Пока Выборка.Следующий() Цикл 
		УстановитьАктивностьНаСервере(Выборка);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьВыборкуНовостейПоЗадачеНаСервере(ТекущиеДанные)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	АдресацияНовостей.Период,
	|	АдресацияНовостей.Объект,
	|	АдресацияНовостей.Адресат
	|ИЗ
	|	РегистрСведений.АдресацияНовостей КАК АдресацияНовостей
	|ГДЕ
	|	АдресацияНовостей.Прочитана = ЛОЖЬ
	|	И АдресацияНовостей.Объект = &Объект
	|	И АдресацияНовостей.Адресат = &Адресат";
	
	Запрос.УстановитьПараметр("Объект", ТекущиеДанные.Объект);
	Запрос.УстановитьПараметр("Адресат", ТекущиеДанные.Адресат);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Возврат Выборка;
	
КонецФункции

&НаСервере
Функция ЕстьНепрочитанныеНовостиПоЗадачеНаСервере(ТекущиеДанные)
	
	ВыборкаНовостейПоЗадаче = ПолучитьВыборкуНовостейПоЗадачеНаСервере(ТекущиеДанные);
	
	Возврат ВыборкаНовостейПоЗадаче.Следующий();
	
КонецФункции


&НаКлиенте
Процедура УстановитьАктивность(Команда)
	
	КоличествоСтрок = Элементы.Новости.ВыделенныеСтроки.Количество();
	
	// Насибуллин (
	ТекущиеДанные = Неопределено;
	МассивДанных = Новый Массив;
	Для Каждого стр Из Элементы.Новости.ВыделенныеСтроки Цикл
		ТекущиеДанные = Элементы.Новости.ДанныеСтроки(стр);
		// Насибуллин )
		Если ТекущиеДанные <> Неопределено Тогда 
			МассивДанных.Добавить(ТекущиеДанные);
			//УстановитьАктивностьНаСервере(ТекущиеДанные);
		КонецЕсли; 
	КонецЦикла;
	
	УстановитьАктивностьМассиваДанныхНаСервере(МассивДанных);
	
	Если КоличествоСтрок = 1 И ОтображатьТолькоСвежиеНовости = Истина И ТекущиеДанные <> Неопределено Тогда
		Если ЕстьНепрочитанныеНовостиПоЗадачеНаСервере(ТекущиеДанные) Тогда
			
			Ответ = Вопрос("По данной задаче обнаружены другие непрочитанные новости.
			|Удалить все непрочитанные новости по данной задаче?", РежимДиалогаВопрос.ДаНет, 30);
			
			Если Ответ = КодВозвратаДиалога.Да Тогда
				УстановитьАктивностьВсехЗаписейНаСервере(ТекущиеДанные);
			КонецЕсли;
			
			
		КонецЕсли;
	КонецЕсли;
	
	
	Элементы.Новости.Обновить();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПараметрыСпискаНовостей()
	
	Новости.Параметры.УстановитьЗначениеПараметра("ОтображатьПрочитанные", ОтображатьПрочитанные);
	
КонецПроцедуры

&НаКлиенте
Процедура КнопкаОтображатьПрочитанные(Команда)
	
	ОтображатьПрочитанные = Не ОтображатьПрочитанные;
	Элементы.Новости.КонтекстноеМеню.ПодчиненныеЭлементы.НовостиКонтекстноеМенюКнопкаОтображатьПрочитанные.Пометка = ОтображатьПрочитанные;
	УстановитьПараметрыСпискаНовостей();
	Элементы.Новости.Обновить();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПараметрыСпискаНовостейТолькоСвежиеНовости()
	
	Новости.Параметры.УстановитьЗначениеПараметра("ОтображатьТолькоСвежие", ОтображатьТолькоСвежиеНовости);
	
КонецПроцедуры

&НаКлиенте
Процедура КнопкаОтображатьТолькоСвежиеНовости(Команда)
	
	ОтображатьТолькоСвежиеНовости = Не ОтображатьТолькоСвежиеНовости;
	Элементы.Новости.КонтекстноеМеню.ПодчиненныеЭлементы.НовостиКонтекстноеМенюКнопкаОтображатьТолькоСвежиеНовости.Пометка = ОтображатьТолькоСвежиеНовости;
	УстановитьПараметрыСпискаНовостейТолькоСвежиеНовости();
	Элементы.Новости.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура КнопкаЗапретитьОповещениеОПоявленииНовостей(Команда)
	
	ЗапретитьОповещениеОПоявленииНовостей = Не ЗапретитьОповещениеОПоявленииНовостей;
	Элементы.Новости.КонтекстноеМеню.ПодчиненныеЭлементы.НовостиКонтекстноеМенюКнопкаЗапретитьОповещениеОПоявленииНовостей.Пометка = ЗапретитьОповещениеОПоявленииНовостей;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВидимостьИстории(Команда)
	
	Элементы.НастройкиСписка.Видимость = Элементы.СписокСодержаниеИзменитьВидимость.Пометка;
	Элементы.СписокСодержаниеИзменитьВидимость.Пометка = Не Элементы.СписокСодержаниеИзменитьВидимость.Пометка;
	
КонецПроцедуры

&НаСервере
Процедура ПеренестиПодробностиИстории()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	АдресацияНовостей.Период,
	|	АдресацияНовостей.Объект,
	|	АдресацияНовостей.ПользовательУДАЛИТЬ КАК Пользователь,
	|	АдресацияНовостей.СобытиеИсторииУДАЛИТЬ КАК СобытиеИстории,
	|	МАКСИМУМ(ВЫРАЗИТЬ(АдресацияНовостей.ПодробностиУДАЛИТЬ КАК СТРОКА(1000))) КАК Подробности
	|ИЗ
	|	РегистрСведений.АдресацияНовостей КАК АдресацияНовостей
	|
	|СГРУППИРОВАТЬ ПО
	|	АдресацияНовостей.Период,
	|	АдресацияНовостей.Объект,
	|	АдресацияНовостей.ПользовательУДАЛИТЬ,
	|	АдресацияНовостей.СобытиеИсторииУДАЛИТЬ";
	
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Общий.офЗафиксироватьСобытиеВПодробнойИстории(Выборка.Объект, Выборка.Пользователь, Выборка.СобытиеИстории, Выборка.Подробности, Выборка.Период);
	КонецЦикла;
	
КонецПроцедуры


&НаКлиенте
Процедура КнопкаПеренестиПодробностиИстории(Команда)
	
	ПеренестиПодробностиИстории();
	
КонецПроцедуры


&НаКлиенте
Процедура НомерЗадачиОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	УстановитьТекущуюЗадачуВСписке(Элемент.ТекстРедактирования);
	
КонецПроцедуры


&НаКлиенте
Процедура НовостиПередУдалением(Элемент, Отказ)
	
	УстановитьАктивность(Неопределено);
	Отказ = Истина;
	
КонецПроцедуры


&НаКлиенте
Процедура НовостиПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
КонецПроцедуры


&НаКлиенте
Процедура ИзбранноеПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	Если Не ИзбранноеПроверкаПеретаскиванияНаСервере(ПараметрыПеретаскивания.Значение, СтандартнаяОбработка) Тогда 
		ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Отмена;
	КонецЕсли;
	
КонецПроцедуры


&НаСервереБезКонтекста
Функция ИзбранноеПроверкаПеретаскиванияНаСервере(Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Результат = Истина;
	
	Если ТипЗнч(Значение) <> Тип("ДокументСсылка.Задача") Тогда 
		Результат = Ложь;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции


&НаКлиенте
Процедура ИзбранноеПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)

	СтандартнаяОбработка = Ложь;
	
	ПараметрыЗаписи = ПолучитьПараметрыЗаписиИзбранноеНаСервере(ПараметрыПеретаскивания.Значение);
	КлючЗаписи = ПолучитьЗначениеКлючаЗаписиИзбранноеНаСервере(ПараметрыЗаписи);
	
	ФормаЗаписи=ПолучитьФорму("РегистрСведений.Избранное.ФормаЗаписи",	Новый Структура("Ключ", КлючЗаписи));
	
	Если КлючЗаписи = Неопределено Тогда
		ЗаполнитьЗначенияСвойств(ФормаЗаписи.Запись, ПараметрыЗаписи);
		ФормаЗаписи.Запись.МодульСистемы = Общий.офПолучитьЗначениеРеквизита(ПараметрыПеретаскивания.Значение, "Модуль");
	КонецЕсли;
	
	ФормаЗаписи.Открыть();
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьЗначениеКлючаЗаписиИзбранноеНаСервере(ПараметрыЗаписи)
	
	ИзбранноеМенеджерЗаписи = РегистрыСведений.Избранное.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(ИзбранноеМенеджерЗаписи, ПараметрыЗаписи);
	
	ИзбранноеМенеджерЗаписи.Прочитать();
	
	КлючЗаписи=Неопределено;
	Если ИзбранноеМенеджерЗаписи.Выбран() Тогда
		МассивОтбораКлючаЗаписи = Новый Массив;
		
		МассивОтбораКлючаЗаписи.Добавить(ПараметрыЗаписи);
		
		КлючЗаписи = Новый ("РегистрСведенийКлючЗаписи.Избранное", МассивОтбораКлючаЗаписи);
	КонецЕсли;
	
	Возврат КлючЗаписи;
	
КонецФункции // ПолучитьЗначениеКлючаЗаписиИзбранноеНаСервере(ПараметрыЗаписи)

&НаСервереБезКонтекста
Функция ПолучитьПараметрыЗаписиИзбранноеНаСервере(Задача)
	
	ПараметрыЗаписи = Новый Структура("Пользователь, Задача", ПараметрыСеанса.ТекущийПользователь, Задача);
	Возврат ПараметрыЗаписи;
	
КонецФункции // ПолучитьПараметрыЗаписиИзбранноеНаСервере(Задача)

&НаКлиенте
Процедура СписокНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	
	ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Выбор;
	
КонецПроцедуры

&НаКлиенте
Процедура НовостиПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры


&НаКлиенте
Процедура ГруппаНовостиИсторияКомментарииПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	мНомерЗадачи = Неопределено;
	Попытка
		мНомерЗадачи = Элементы.Список.ТекущиеДанные.Номер;
	Исключение
	КонецПопытки;
	УстановитьОтборСпискаДанныхПоЗадаче(мНомерЗадачи);
	
КонецПроцедуры


&НаКлиенте
Процедура ОткрытьБазуПаролей(Команда)
	
	ОткрытьФорму("Справочник.Пароли.Форма.ФормаСписка");
	
КонецПроцедуры

&НаСервере
Процедура кнУдалитьНастройкуСпискаНаСервере()
	
	ксНастройкаСервер.УдалитьНастройкиСписка(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура кнУдалитьНастройкуСписка(Команда)
	
	кнУдалитьНастройкуСпискаНаСервере();
	
КонецПроцедуры


