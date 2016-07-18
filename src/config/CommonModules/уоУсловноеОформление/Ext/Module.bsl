﻿
Функция уоПолучитьСтруктуруЭлементаУсловногоОформления(ИмяСтруктуры)
	
	СтруктураЭлемента = Неопределено;
	
	Если ИмяСтруктуры = "Основная" Тогда 
		
		СтруктураЭлемента = Новый Структура("ИдентификаторПользовательскойНастройки, Отбор, ЦветФона, Шрифт");
		
	ИначеЕсли ИмяСтруктуры = "Отбор" Тогда 
		
		СтруктураЭлемента = Новый Структура("ВидСравнения, Использование, ЛевоеЗначение, ПравоеЗначение");
		
	ИначеЕсли ИмяСтруктуры = "ЦветФона" Тогда 
		
		СтруктураЭлемента = Новый Структура("Значение, Использование");
		
	КонецЕсли;
	
	Возврат СтруктураЭлемента;
	
КонецФункции

Функция уоПолучитьМассивЭлементовУОЗадач()
	
	МассивЭлементовУОЗадач = Новый Массив;
	
	// 1. Статус = Нужен отклик, ПользовательОтклик = ТекущийПользователь()
	ЭлементУО = уоПолучитьСтруктуруЭлементаУсловногоОформления("Основная");
	
	ЭлементУО.ИдентификаторПользовательскойНастройки = "НуженОтклик_ТекущийПользователь";
	//ЭлементУО.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Авто;
	
	
	ЭлементУО.Отбор = уоПолучитьСтруктуруЭлементаУсловногоОформления("Отбор");
	
	ЭлементУО.Отбор.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементУО.Отбор.Использование = Истина;
	ЭлементУО.Отбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ОткликОт");
	ЭлементУО.Отбор.ПравоеЗначение = ПараметрыСеанса.ТекущийПользователь;
	
	
	ЭлементУО.ЦветФона = уоПолучитьСтруктуруЭлементаУсловногоОформления("ЦветФона");
	
	ЭлементУО.ЦветФона.Значение = ЦветаСтиля.ЦветНуженОткликЯркий;
	ЭлементУО.ЦветФона.Использование = Истина;
	
	//
	
	МассивЭлементовУОЗадач.Добавить(ЭлементУО);
	
	Возврат МассивЭлементовУОЗадач;
	
КонецФункции

Функция уоНайтиЭлемент(УсловноеОформление, ИдентификаторПользовательскойНастройки)
	
	ЭлементУО = Неопределено;
	
	Для Каждого ТекСтрокаУО Из УсловноеОформление.Элементы Цикл 
		
		Если ТекСтрокаУО.ИдентификаторПользовательскойНастройки = ИдентификаторПользовательскойНастройки Тогда 
			ЭлементУО = ТекСтрокаУО;
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ЭлементУО;
	
КонецФункции

Процедура ДобавитьЭлементУО(УсловноеОформление, ЭлементУО)
	
	Оформление = УсловноеОформление.Элементы.Добавить();
	
	// 1. Добавим отбор
	СтруктураОформления = Неопределено;
	Если ЭлементУО.Свойство("Отбор", СтруктураОформления) Тогда 
		
		Отбор = Оформление.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		
		Отбор.ВидСравнения = СтруктураОформления.ВидСравнения;
		Отбор.Использование = СтруктураОформления.Использование;
		Отбор.ЛевоеЗначение = СтруктураОформления.ЛевоеЗначение;
		Отбор.ПравоеЗначение = СтруктураОформления.ПравоеЗначение;
		
	КонецЕсли;
	
	// 2. Добавим оформление цвета фона
	СтруктураОформления = Неопределено;
	Если ЭлементУО.Свойство("ЦветФона", СтруктураОформления) Тогда 
		
		ЦветФона = Оформление.Оформление.Элементы.Найти("ЦветФона");
		
		ЦветФона.Значение = СтруктураОформления.Значение;
		ЦветФона.Использование = СтруктураОформления.Использование;
	КонецЕсли;
	
КонецПроцедуры

Процедура уоНастроитьУсловноеОформлениеСпискаЗадач(СписокЗадач) Экспорт
	
	мУсловноеОформление = СписокЗадач.УсловноеОформление;
	
	МассивЭлементовУОЗадач = уоПолучитьМассивЭлементовУОЗадач();
	
	Для Каждого ТекУОЗадачи Из МассивЭлементовУОЗадач Цикл 
		
		Если уоНайтиЭлемент(мУсловноеОформление, ТекУОЗадачи.ИдентификаторПользовательскойНастройки) = Неопределено Тогда 
			ДобавитьЭлементУО(мУсловноеОформление, ТекУОЗадачи);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры
