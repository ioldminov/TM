﻿
Перем ОписаниеТиповДок; // Описание типов документов
Перем ТаблицаКонтроляПовтора;



Функция ЗаполнитьТабДокДеревоСвязанныхОбъектов(ТабДок) Экспорт 
	
	ПолучитьДеревоДокументов(ДеревоДокументов);
	КоличествоЭлементовДерева = доДеревоСвязаныхОбъектов.ПолучитьКоличествоЭлементовДерева(ДеревоДокументов);
	ВывестиДеревоДокументов(ДеревоДокументов, ТабДок);
	
	Возврат КоличествоЭлементовДерева;
		
КонецФункции

//обход дерева и печать элементов                     
//
// Параметр:
//	Дерево			- ДеревоЗначений	- Дерево
//	СтрокаДерева	- Структура			- Строка дерева
//	Макет           - ТабличныйДокумент - Макет
//	Таб             - ТабличныйДокумент - Табличный документ
//	Уровень         - Число				- Уровень
//	спУровни        - Число				- Уровни
//
Процедура ВывестиСтрокуДерева(Дерево, СтрокаДерева, Макет, Таб, Уровень, спУровни)
	Документ= СтрокаДерева.Документ;
	Область	= Макет.ПолучитьОбласть("ГрУгол|В");
	Таб.Вывести(Область, Уровень+1);
	Для к = 1 По Уровень-1 Цикл
		Область	= Макет.ПолучитьОбласть(?(спУровни[к]=1,"ГрЛиния|Линии","ГрПуст|Линии"));
		Таб.Присоединить(Область, Уровень+1);
	КонецЦикла;
	
	Если СтрокаДерева.Родитель.Строки.Индекс(СтрокаДерева)+1 = СтрокаДерева.Родитель.Строки.Количество() Тогда
		Область = Макет.ПолучитьОбласть("ГрУгол|Линии");
		спУровни[Уровень] = 0;
	Иначе
		Область = Макет.ПолучитьОбласть("ГрДвСекция|Линии");
		спУровни[Уровень] = 1;
	КонецЕсли;
	Таб.Присоединить(Область, Уровень+1);
	
	Если Документ = ВыбДокумент Тогда
		Область = Макет.ПолучитьОбласть("ТекДок|Тело");
	Иначе
		Область = Макет.ПолучитьОбласть("Док|Тело");
	КонецЕсли;
	Область.Параметры.Расшифровка	= Новый Структура("Документ" , Документ);
	Попытка
		СтрокаСуть = Символы.ПС + "Суть: " + СокрЛП(Документ.Суть);
	Исключение
		СтрокаСуть = "";
	КонецПопытки; 
	
	//Область.Параметры.ПечДок		= Документ.ХозОперация.Наименование + " № "+СокрЛП(Документ.Номер) + " от "+Формат(Документ.Дата,"ДФ=dd.MM.yyyy hh:mm:ss") + СтрокаСумма;
	//Область.Параметры.Док			= Документ;                                       Объект.Номер)
	//Область.Рисунки[0].Картинка		= ?(Документ.ПометкаУдаления, БиблиотекаКартинок.ДокументПомеченНаУдаление, ?(Документ.Проведен, БиблиотекаКартинок.ДокументПроведен, БиблиотекаКартинок.ДокументНеПроведен));
	Область.Параметры.ПечДок		= Документ.Метаданные().Синоним + " № "+СокрЛП(Общий.офУдалитьЛидирующиеСимволы(Документ.Номер)) + " от " + Формат(Документ.Дата,"ДФ=dd.MM.yyyy") + СтрокаСуть;
	Область.Параметры.Док			= Документ;
	Область.Рисунки[0].Картинка		= ?(Документ.ПометкаУдаления, БиблиотекаКартинок.ПометитьНаУдаление, ?(Документ.Проведен, БиблиотекаКартинок.ЗаписатьИЗакрыть, БиблиотекаКартинок.Документ));
	
	ОбластьВыводаЗадачи = Область.Область("R2C1:R3C11");
	ОбластьВыводаЗадачи.ЦветФона = Общий.обПолучитьЦветСостоянияЗадачи(Документ.СостояниеЗадачи, Документ.Исполнитель, Документ.ИсполнительОтклик);;
	
	Таб.Присоединить(Область, Уровень+1);
	
	Для Каждого Строка Из СтрокаДерева.Строки Цикл
		ВывестиСтрокуДерева(Дерево, Строка, Макет, Таб, Уровень+1, спУровни);
	КонецЦикла;
КонецПроцедуры // ВывестиСтрокуДерева()

//функция, получает максимальную глубину дерева документов
//
// Параметр:
//	Дерево			- ДеревоЗначений	- Дерево
//	ТекГлубина		- Число				- Текущая глубина
//	ГлубинаДерева	- Число				- Глубина дерева
//
// Возвращаемое значение:
// Число			- Максимальная глубина дерева
//
Функция ПолучитьГлубинуДерева(Дерево, ТекГлубина, ГлубинаДерева)
	ПредГлубина  =  ТекГлубина;
	Для Каждого Строка Из Дерево.Строки Цикл
		ТекГлубина  =  ПолучитьГлубинуДерева(Строка , ТекГлубина+1 , ГлубинаДерева);
	КонецЦикла;
	Если ПредГлубина < ТекГлубина Тогда
		ГлубинаДерева  =  ГлубинаДерева + 1;
	КонецЕсли;
	Возврат ТекГлубина;    	
КонецФункции // ПолучитьГлубинуДерева()

//обход дерева документов и добавление в дерево
//
// Параметр:
//	Строка			- Массив			- Массив строк			
//	ДокументКорень	- ДокументСсылка	- Документ корень
//
Процедура ДобавитьВДерево(Строка, ДокументКорень)
	
	ТекстЗапроса = 
	"ВЫБРАТЬ 
	|	ПодчиненныеДокументы.Документ,
	|	ПодчиненныеДокументы.Документ.Дата КАК ДатаДокумента
	|ИЗ ("+доДеревоСвязаныхОбъектов.ПолучитьТекстЗапросаККритериюОтбора("Задачи", ДокументКорень, "Основание", "Документ")+") КАК ПодчиненныеДокументы
	|УПОРЯДОЧИТЬ ПО
	|	ПодчиненныеДокументы.Документ.Дата
	|";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Основание",ДокументКорень);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Если НЕ (ТаблицаКонтроляПовтора.Найти(Выборка.Документ) = Неопределено) Тогда
			Продолжить;
		КонецЕсли;
		СтрокаДерева = Строка.Строки.Добавить();
		ТаблицаКонтроляПовтора.Добавить(Выборка.Документ);
		текДок = Выборка.Документ;
		СтрокаДерева.Документ = текДок;
		СтрокаДерева.ВидДокумента = текДок.Метаданные().Синоним;
		СтрокаДерева.Дата = текДок.Дата;
		СтрокаДерева.Номер = текДок.Номер;
		//Соловьев И.В. 25.09.2012 {
		ОбъектыМетаданных = Метаданные.Документы;
		
		Если ОбъектыМетаданных[текДок.Метаданные().Имя].Реквизиты.Найти("Организация") <> Неопределено Тогда
			СтрокаДерева.Организация = текДок.Организация;
		КонецЕсли;
		Если ОбъектыМетаданных[текДок.Метаданные().Имя].Реквизиты.Найти("ПодразделениеКомпании") <> Неопределено Тогда
			СтрокаДерева.Подразделение = текДок.ПодразделениеКомпании;
		КонецЕсли;
		Если ОбъектыМетаданных[текДок.Метаданные().Имя].Реквизиты.Найти("Автор") <> Неопределено Тогда
			СтрокаДерева.Автор = текДок.Автор;
		КонецЕсли;		
		Если ОбъектыМетаданных[текДок.Метаданные().Имя].Реквизиты.Найти("СуммаДокумента") <> Неопределено Тогда
			СтрокаДерева.СуммаДокумента = текДок.СуммаДокумента;
		КонецЕсли;	
		//Соловьев И.В. 25.09.2012 }
		ДобавитьВДерево(СтрокаДерева,текДок);
	КонецЦикла;
КонецПроцедуры // ДобавитьВДерево()


// Процедура получения дерева документов
// ДеревоДокументов - ДеревоЗначений ,  результат выполнения процедуры
// Использует Реквизит Отчета - ВыбранныйДокумент - ссылка на выбранный документ
//
// Параметр:
// ДеревоДокументов		- ДеревоЗначений	- Дерево документов
//
Процедура ПолучитьДеревоДокументов(ДеревоДокументов) Экспорт
	ДеревоДокументов.Строки.Очистить();
	ДеревоДокументов.Колонки.Очистить();
	Если ВыбДокумент  =  Неопределено Тогда
		Возврат;			
	КонецЕсли; 
	МассивТипов  =  Новый Массив;
	Для Каждого Документ Из Метаданные.Документы Цикл
		МассивТипов.Добавить(Тип("ДокументСсылка."+Документ.Имя));    	
	КонецЦикла;
	//Соловьев И.В. 25.09.2012 {
	Для Каждого Задача Из Метаданные.Задачи Цикл
		МассивТипов.Добавить(Тип("ЗадачаСсылка."+Задача.Имя));    	
	КонецЦикла;
	//Соловьев И.В. 25.09.2012 }
	ОписаниеТиповДок  =  Новый ОписаниеТипов(МассивТипов ,  ,  , );
	ОписаниеТиповДата = Новый ОписаниеТипов("Дата");
	ДеревоДокументов.Колонки.Добавить("ВидДокумента" ,  , "Операция" , 40);
	ДеревоДокументов.Колонки.Добавить("Номер" ,  , "Номер" , 11);
	ДеревоДокументов.Колонки.Добавить("Дата" , ОписаниеТиповДата , "Дата" , 10);
	ДеревоДокументов.Колонки.Добавить("Организация" ,  , "Организация" , 15);
	ДеревоДокументов.Колонки.Добавить("Подразделение" ,  , "Подразделение" , 15);
	ДеревоДокументов.Колонки.Добавить("Автор" ,  , "Автор" , 15);	
	ДеревоДокументов.Колонки.Добавить("СуммаДокумента" ,  , "Сумма" , );	
	ДеревоДокументов.Колонки.Добавить("Документ" , ОписаниеТиповДок , "Документ" , 1);	
	ТаблицаКонтроляПовтора.Добавить(ВыбДокумент);
	ДокКорень = ПолучитьКореньДокумента(ВыбДокумент);
	
		
	СтрокаДерева = ДеревоДокументов.Строки.Добавить();
	СтрокаДерева.Документ		= ДокКорень;
	Попытка
		СтрокаДерева.ВидДокумента	= ДокКорень.Метаданные().Синоним;
		СтрокаДерева.Дата			= ДокКорень.Дата;
		СтрокаДерева.Номер			= ДокКорень.Номер;
		Если Метаданные.Документы[ДокКорень.Метаданные().Имя].Реквизиты.Найти("Организация") <> Неопределено Тогда
			СтрокаДерева.Организация = ДокКорень.Организация;
		КонецЕсли;
		Если Метаданные.Документы[ДокКорень.Метаданные().Имя].Реквизиты.Найти("ПодразделениеКомпании") <> Неопределено Тогда
			СтрокаДерева.Подразделение = ДокКорень.ПодразделениеКомпании;
		КонецЕсли;
		Если Метаданные.Документы[ДокКорень.Метаданные().Имя].Реквизиты.Найти("Автор") <> Неопределено Тогда
			СтрокаДерева.Автор = ДокКорень.Автор;
		КонецЕсли;		
		Если Метаданные.Документы[ДокКорень.Метаданные().Имя].Реквизиты.Найти("СуммаДокумента") <> Неопределено Тогда
			СтрокаДерева.СуммаДокумента = ДокКорень.СуммаДокумента;
		КонецЕсли;
	Исключение
	КонецПопытки;
	
	
	ТаблицаКонтроляПовтора = Новый Массив;
	ТаблицаКонтроляПовтора.Добавить(ДокКорень);
	ДобавитьВДерево(СтрокаДерева , ДокКорень);
	
КонецПроцедуры // ПолучитьДеревоДокументов()

// Выводит дерево документов на форму
// Параметры:
//	дзДок - дерево для вывода
//
Процедура ВывестиДеревоДокументов(дзДок, Таб) Экспорт
	Таб.Очистить();
	Макет = ЭтотОбъект.ПолучитьМакет("ДеревоДокументов");
	Область = Макет.ПолучитьОбласть("Кнопки");
	Таб.Вывести(Область);
	ГлубинаДерева = 0;
	ПолучитьГлубинуДерева(ДеревоДокументов,0,ГлубинаДерева);
	спУровни = Новый Массив();
	Для К = 1 По ГлубинаДерева Цикл
		спУровни.Вставить(К,0);
	КонецЦикла; 
	Корень = дзДок.Строки[0];
	Если ГлубинаДерева > 1 Тогда
		спУровни[1] = 1;	
	КонецЕсли;
	Если Корень.Документ = ВыбДокумент Тогда
		Область = Макет.ПолучитьОбласть("КореньТекДок");
	Иначе
		Область = Макет.ПолучитьОбласть("Заголовок");
	КонецЕсли;
	Документ = Корень.Документ;
	Область.Параметры.Расшифровка	= Новый Структура("Документ" , Документ);
	Попытка
		СтрокаСуть = Символы.ПС + "Суть: " + СокрЛП(Документ.Суть);
	Исключение
		СтрокаСуть = "";
	КонецПопытки; 
	
	Попытка
		Область.Параметры.ПечДок		= Документ.Метаданные().Синоним + " № "+СокрЛП(Общий.офУдалитьЛидирующиеСимволы(Документ.Номер)) + " от " + Формат(Документ.Дата,"ДФ=dd.MM.yyyy") + СтрокаСуть;	
	Исключение
	    Область.Параметры.ПечДок        = Документ;
	КонецПопытки;
	
	Область.Параметры.Док			= Документ;
	Попытка
		Область.Рисунки[0].Картинка		= ?(Документ.ПометкаУдаления, БиблиотекаКартинок.ПометитьНаУдаление, ?(Документ.Проведен, БиблиотекаКартинок.ЗаписатьИЗакрыть, БиблиотекаКартинок.Документ));
	Исключение
		Область.Рисунки[0].Картинка  	= БиблиотекаКартинок.ЗаписатьИЗакрыть;
	КонецПопытки;
	
	//Соловьев И.В. 03.06.2014 {
	Таб.НачатьАвтогруппировкуСтрок();
	//Соловьев И.В. 03.06.2014 }
	
	ОбластьВыводаЗадачи = Область.Область("R1C2:R2C12");
	Попытка
		ОбластьВыводаЗадачи.ЦветФона = Общий.обПолучитьЦветСостоянияЗадачи(Документ.СостояниеЗадачи, Документ.Исполнитель, Документ.ИсполнительОтклик);
	Исключение
		ОбластьВыводаЗадачи.ЦветФона = Общий.обПолучитьЦветСостоянияЗадачи(Справочники.СостоянияЗадач.Назначена, Неопределено, Неопределено);
	КонецПопытки;
	
	
	Таб.Вывести(Область, 1);
	

	Для Каждого Строка Из Корень.Строки Цикл
		ВывестиСтрокуДерева(дзДок,Строка,Макет,Таб,1,спУровни);
	КонецЦикла;
	
	//Соловьев И.В. 03.06.2014 {
	Таб.ЗакончитьАвтогруппировкуСтрок();
	//Соловьев И.В. 03.06.2014 }
	
	Таб.ТолькоПросмотр		= ИСТИНА;
	Таб.ОтображатьСетку		= ЛОЖЬ;
	Таб.ОтображатьЗаголовки	= Ложь;
КонецПроцедуры // ВывестиДеревоДокументов()

//функция, получения ссылки на корень дерева документов
//
// Параметр:
//	Док		- ДокументСсылка	- Переданный документ
//
// Возвращаемое значение:
//	ДокументСсылка		- Корень документа
//
Функция ПолучитьКореньДокумента(Док)
	
	// Калита В.С. {
	
	
	//Перем ЗнРеквизит;
	//
	//ЗнРеквизит  =  Неопределено;
	//НашлиРеквизит  =  Ложь;
	//
	//ВидДок  =  Док.Метаданные().Имя;	
	//Для Каждого Реквизит из Метаданные.Документы[ВидДок].Реквизиты Цикл
	//	ЗнРеквизит  =  Док[Реквизит.Имя];
	//	Если (ЗнРеквизит <> Неопределено) и (ОписаниеТиповДок.СодержитТип(ТипЗнч(ЗнРеквизит))) и (ЗнРеквизит <> Документы[ЗнРеквизит.Метаданные().Имя].ПустаяСсылка()) и (ЗнРеквизит <> Док) Тогда
	//		НашлиРеквизит  =  Истина;
	//		Прервать;			
	//	КонецЕсли;
	//КонецЦикла;
	//
	//Если НашлиРеквизит Тогда
	//	Возврат ПолучитьКореньДокумента(ЗнРеквизит);		
	//Иначе
	//	Возврат Док;
	//КонецЕсли;
	
	Перем ЗнРеквизит;
	
	ЗнРеквизит  =  Неопределено;
	НашлиРеквизит  =  Ложь;
	
	ОбъектыМетаданных = Метаданные.Документы;
	
	ВидДок  =  Док.Метаданные().Имя;
	//Соловьев И.В. 11.07.2013 {
	МассивРеквизитов = доДеревоСвязаныхОбъектов.ПолучитьМассивРеквизитовСоставаКритерияОтбора(ВидДок, ОбъектыМетаданных);
	//Для Каждого Реквизит из ОбъектыМетаданных[ВидДок].Реквизиты Цикл
	Для Каждого Реквизит из МассивРеквизитов Цикл
		//Соловьев И.В. 11.07.2013 }
		Попытка
			ЗнРеквизит  =  Док[Реквизит.Имя];
		Исключение
			ЗнРеквизит  =  Неопределено;
		КонецПопытки;
		
		
		допОбъектыМетаданных = Документы;
		
		Если (ЗнРеквизит <> Неопределено) и (ОписаниеТиповДок.СодержитТип(ТипЗнч(ЗнРеквизит))) и (ЗнРеквизит <> допОбъектыМетаданных[ЗнРеквизит.Метаданные().Имя].ПустаяСсылка()) и (ЗнРеквизит <> Док) Тогда
			НашлиРеквизит  =  Истина;
			Прервать;			
		КонецЕсли;
	КонецЦикла;
	
	Если НашлиРеквизит Тогда
		Возврат ПолучитьКореньДокумента(ЗнРеквизит);		
	Иначе
		Возврат Док;
	КонецЕсли;
	
	// Калита В.С. }
	
КонецФункции // ПолучитьКореньДокумента()

Функция ПолучитьКоличествоОбъектовДерева() Экспорт 
	
	ПолучитьДеревоДокументов(ДеревоДокументов);
	
	КоличествоЭлементовДерева = доДеревоСвязаныхОбъектов.ПолучитьКоличествоЭлементовДерева(ДеревоДокументов);
	
	Возврат КоличествоЭлементовДерева;
		
КонецФункции

ТаблицаКонтроляПовтора = Новый Массив;
