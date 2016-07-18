﻿&НаСервере
Функция СформироватьОтчетНаСервере()
	РеквизитФормыВЗначение("Отчет").СформироватьОтчет(ПолеТабличногоДокумента);
	ПолеТабличногоДокумента.ТолькоПросмотр = Истина;
КонецФункции
                                             
&НаКлиенте
Процедура Сформировать(Команда)
	СформироватьОтчетНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПолеТабличногоДокументаНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	Элементы.ПолеТабличногоДокумента.Редактирование = Истина;
	Элементы.ПолеТабличногоДокумента.ТолькоПросмотр = Ложь;
КонецПроцедуры

&НаКлиенте                                                                                            
Процедура ПолеТабличногоДокументаПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Область)

	Если ТипЗнч(ПараметрыПеретаскивания.Значение) = Тип("Массив") ИЛИ ТипЗнч(ПараметрыПеретаскивания.Значение) = Тип("ДокументСсылка.Задача") Тогда
		// Перетаскивается задача из пула задач или откуда то еще
		
	ИначеЕсли Область.Расшифровка = Неопределено Тогда 
		ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Отмена;
	КонецЕсли;                                             			
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеТабличногоДокументаОкончаниеПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	
	Если Не РазрешитьПеретаскивание Тогда 
		Элементы.ПолеТабличногоДокумента.Редактирование = Ложь;
		Элементы.ПолеТабличногоДокумента.ТолькоПросмотр = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеТабличногоДокументаПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Область)
	
	СтандартнаяОбработка = Ложь;
	Если ТипЗнч(Область.Расшифровка) = Тип("СправочникСсылка.Пользователи") Тогда 
		СледующаяЗадача = Неопределено;
	Иначе
		СледующаяЗадача = Область.Расшифровка;
	КонецЕсли;
	Если ТипЗнч(ПараметрыПеретаскивания.Значение) = Тип("Массив") Тогда
		Попытка
			ТекущаяЗадача = ПараметрыПеретаскивания.Значение[0].Задача;
		Исключение
			ТекущаяЗадача = ПараметрыПеретаскивания.Значение[0];
		КонецПопытки;
		//ТекущаяЗадача = Элементы.СписокЗадач.ТекущиеДанные.Задача;
	ИначеЕсли ТипЗнч(ПараметрыПеретаскивания.Значение) = Тип("ДокументСсылка.Задача") Тогда
	    ТекущаяЗадача = ПараметрыПеретаскивания.Значение;
	Иначе 
		ТекущаяЗадача = ПараметрыПеретаскивания.Значение.ТекущаяОбласть.Расшифровка;
	КонецЕсли;
	
	
	Перетаскивание(СледующаяЗадача, ТекущаяЗадача);
	
	Элементы.ПолеТабличногоДокумента.ТекущаяОбласть = Область;
	
	Если Не РазрешитьПеретаскивание Тогда 
		Элементы.ПолеТабличногоДокумента.Редактирование = Ложь;
		Элементы.ПолеТабличногоДокумента.ТолькоПросмотр = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура Перетаскивание(СледующаяЗадача, ТекущаяЗадача)
	
	НовыйПорядок = Общий.офПолучитьНовыйПорядокЗадачи(ТекущаяЗадача, СледующаяЗадача);
	
	Если НовыйПорядок = Неопределено Тогда
		Общий.офОбновитьПорядокЗадач();
		Сообщить("Порядок задач обновлен!");
		НовыйПорядок = Общий.офПолучитьНовыйПорядокЗадачи(ТекущаяЗадача, СледующаяЗадача);
	КонецЕсли;
	
	Если НовыйПорядок <> Неопределено Тогда
		//Сообщить("Присваиваем новый порядок!");
		Если СледующаяЗадача <> Неопределено Тогда
			ТекущаяЗадачаОбъект = ТекущаяЗадача.ПолучитьОбъект();
			ТекущаяЗадачаОбъект.Исполнитель = СледующаяЗадача.Исполнитель;
			ТекущаяЗадачаОбъект.Записать();
		КонецЕсли;
		
		МенеджерЗаписи = РегистрыСведений.ОперативныйПланЗадач.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Задача = ТекущаяЗадача;
		//МенеджерЗаписи.Прочитать();
		//Если МенеджерЗаписи.Выбран() тогда
		//	МенеджерЗаписи.Порядок = НовыйПорядок;
		//Иначе
		//	МенеджерЗаписи.Задача = ТекущаяЗадача;
			МенеджерЗаписи.Порядок = НовыйПорядок;
		//КонецЕсли;
		МенеджерЗаписи.Записать(Истина);
		
	//ТекущаяЗадачаОбъект.Порядок = НовыйПорядок;
		
		СформироватьОтчетНаСервере();
	Иначе
		Сообщить("Не удалось получить новый порядок!");
		//Предупреждение("Не удалось получить новый порядок!
		//|Обновите порядок задач!");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеТабличногоДокументаОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	//ОбработкаРасшифровки(Расшифровка, СтандартнаяОбработка);
	//Расшифровка.ПолучитьФорму().Открыть();
	СтандартнаяОбработка = Ложь;
	мПараметры = Новый Структура("Ключ", Расшифровка);
	ФормаКонтр = ПолучитьФорму("Документ.Задача.ФормаОбъекта", мПараметры);
	//ФормаКонтр.Объект = Расшифровка;
	ФормаКонтр.Открыть();
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаРасшифровки(Расшифровка, СтандартнаяОбработка)
	
	//СтандартнаяОбработка = Ложь;
	//Расшифровка.ПолучитьФорму().Открыть();
	//	
КонецПроцедуры

&НаКлиенте                                                                                                                          
Процедура СписокЗадачНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	Элементы.ПолеТабличногоДокумента.Редактирование = Истина;
	Элементы.ПолеТабличногоДокумента.ТолькоПросмотр = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ВосстановитьНастройки();
	Сформировать(Неопределено);

КонецПроцедуры

&НаКлиенте
Процедура СписокЗадачПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	Если ТипЗнч(ПараметрыПеретаскивания.Значение) <> Тип("ТабличныйДокумент") Тогда
		ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Отмена;
	ИначеЕсли ТипЗнч(ПараметрыПеретаскивания.Значение.ТекущаяОбласть.Расшифровка) <> Тип("ДокументСсылка.Задача") Тогда 
		ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Отмена;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ИсключитьЗадачуИзПлана(ТекущаяЗадача)
	
	МенеджерЗаписи = РегистрыСведений.ОперативныйПланЗадач.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Задача = ТекущаяЗадача;
	МенеджерЗаписи.Прочитать();
	МенеджерЗаписи.Удалить();
		
КонецПроцедуры


&НаКлиенте
Процедура СписокЗадачПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)

	ТекущаяЗадача = ПараметрыПеретаскивания.Значение.ТекущаяОбласть.Расшифровка;
	ИсключитьЗадачуИзПлана(ТекущаяЗадача);
	СформироватьОтчетНаСервере();
	
	Элементы.ПолеТабличногоДокумента.Редактирование = Ложь;
	Элементы.ПолеТабличногоДокумента.ТолькоПросмотр = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВидимость(Команда)
	
	//Элементы.Содержание.Видимость = Элементы.ИзменитьВидимостьНастроек.Пометка;
	
	Элементы.Список.Видимость = Элементы.ИзменитьВидимостьНастроек.Пометка;
	Элементы.ИзменитьВидимостьНастроек.Пометка = Не Элементы.ИзменитьВидимостьНастроек.Пометка;
	
КонецПроцедуры

&НаСервере
Процедура ВосстановитьНастройки()
	
	КлючОбъекта = ИмяФормы;
	КлючНастроек = "НастройкаОтбораОперативногоПлана";
	ОписаниеНастроек = "";
	Значение ="";
	ИмяПользователя = ПараметрыСеанса.ТекущийПользователь;
	
	ЗначениеНастроек = ХранилищеОбщихНастроек.Загрузить(КлючОбъекта, КлючНастроек, ОписаниеНастроек, ИмяПользователя);
	
	Если ТипЗнч(ЗначениеНастроек) = Тип("Соответствие") Тогда
		
		ЗначениеИзНастройки = ЗначениеНастроек.Получить("ТаблицаЗначений");
		
		//Объект.Реквизит1 = ЗначениеНастроек.Получить("Реквизит1");
		//Объект.Реквизит2 = ЗначениеНастроек.Получить("Реквизит2");
		
		Отчет.СписокПользователей.Загрузить(ЗначениеИзНастройки);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройки()
	
	КлючОбъекта = ИмяФормы;
	КлючНастроек = "НастройкаОтбораОперативногоПлана";
	ОписаниеНастроек = "";
	Значение ="";
	ИмяПользователя = ПараметрыСеанса.ТекущийПользователь;
	
	Настройки = Новый Соответствие;
	
	Настройки.Вставить("ТаблицаЗначений", Отчет.СписокПользователей.Выгрузить());
	
	//Настройки.Вставить("Реквизит1", Объект.Реквизит1);
	//Настройки.Вставить("Реквизит2", Объект.Реквизит2);
	
	ХранилищеОбщихНастроек.Сохранить(КлючОбъекта, КлючНастроек, Настройки, ОписаниеНастроек, ИмяПользователя);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	СохранитьНастройки();
	
КонецПроцедуры


&НаКлиенте
Процедура СформироватьДоскуЗадач(Команда)
	СформироватьДоскуЗадачНаСервере();
КонецПроцедуры

&НаСервере
Функция СформироватьДоскуЗадачНаСервере()
	РеквизитФормыВЗначение("Отчет").СформироватьДоскуЗадач(ТабДокДоскаЗадач);
	ТабДокДоскаЗадач.ТолькоПросмотр = Истина;
КонецФункции


&НаКлиенте
Процедура РазрешитьПеретаскиваниеПриИзменении(Элемент)
	
	Элементы.ПолеТабличногоДокумента.Редактирование = РазрешитьПеретаскивание;
	Элементы.ПолеТабличногоДокумента.ТолькоПросмотр = Не РазрешитьПеретаскивание;
	
КонецПроцедуры


&НаКлиенте
Процедура СписокЗадачОкончаниеПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	
	Если Не РазрешитьПеретаскивание Тогда 
		Элементы.ПолеТабличногоДокумента.Редактирование = Ложь;
		Элементы.ПолеТабличногоДокумента.ТолькоПросмотр = Истина;
	КонецЕсли;
	
КонецПроцедуры
                                             
