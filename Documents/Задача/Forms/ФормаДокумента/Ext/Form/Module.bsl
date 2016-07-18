﻿//_____________________________________________________________
#Область СобытияФормы

//_____________________________________________________________
// КЛИЕНТ

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ЭтаФорма.Элементы.Автор.ТолькоПросмотр = Общий.ЭтоПользователь();
	ЭтаФорма.Элементы.Дата.ТолькоПросмотр = Не ЭтоНовыйДокумент();
	Если ЭтоНовыйДокумент() Тогда 
		Элементы.Комментарии.Доступность = Ложь;
	КонецЕсли;
	
	ТекстСообщения = "";
	ЗаблокироватьОбъект(ТекстСообщения);
	ПриОткрытииФрагмент();
	Если Не ПустаяСтрока(ТекстСообщения) Тогда 
		ПоказатьПредупреждение(, "Не удалось заблокировать объект для изменения. 
			|Форма может быть открыта только для просмотра.
			|
			|Информация о блокирующем сеансе:
			|" + Общий.офПолучитьСообщениеОБлокировкеОбъекта(ТекстСообщения));
        Возврат;
	КонецЕсли; 
	
	ПодключитьОбработчикОжидания("УстановитьРастягиваниеПоляКомментария", 1, Истина);
	
	Если ЕстьВозможностьБыстройСменыСостояния() Тогда 
		Элементы.ГруппаСменыСостояний.ТекущаяСтраница = Элементы.СтраницаБыстроеИзменениеСостояния;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьРастягиваниеПоляКомментария()
	
	Элементы.ДобавлениеКомментария.РастягиватьПоВертикали = Истина;//Не Элементы.ДобавлениеКомментария.РастягиватьПоВертикали;
	Элементы.ПодробностиИстории.РастягиватьПоВертикали = Истина;//Не Элементы.ДобавлениеКомментария.РастягиватьПоВертикали;
	
КонецПроцедуры

&НаСервере
Функция ЕстьВозможностьБыстройСменыСостояния() 
	
	Результат = Ложь;
	
	Если Объект.Исполнитель = ПараметрыСеанса.ТекущийПользователь
		И Объект.СостояниеЗадачи = Справочники.СостоянияЗадач.Назначена Тогда 
		Результат = Истина;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ПриОткрытииФрагмент()
    
    ОбновитьЗаголовокКомментарии();
    ОбновитьЗаголовокОтслеживающие();
	ОбновитьЗаголовокВложения();
    УправлениеДиалогом();

КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	//МассивСообщений = Новый Массив;
	// ТекДок = РеквизитФормыВЗначение("Объект");
	//ТекДок.ПроверитьКорректностьНаСервере(ЭтаФорма, Отказ, МассивСообщений);
	//
	//Если Отказ Тогда
	//	Сообщение = Новый СообщениеПользователю();
	//	
	//	Для Каждого ТекСтрока Из МассивСообщений Цикл
	//		Сообщение.Текст = ТекСтрока.ТекстСообщения;
	//		Сообщение.Поле = ТекСтрока.Поле;//"Объект.РелизКонфигурации";
	//		Сообщение.УстановитьДанные(Объект);
	//		Сообщение.Сообщить();
	//  	КонецЦикла;
	//КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Элементы.Комментарии.Доступность = Истина;
	ЗаписатьСостояниеЗадачиНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если Не ПустаяСтрока(НовыйКомментарий) Тогда 
		Ответ = Неопределено;
 
		ПоказатьВопрос(Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект), "Добавить введенный комментарий к задаче?" + Символы.ПС + "<"+НовыйКомментарий+">", РежимДиалогаВопрос.ДаНет, 60); 
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    Ответ = РезультатВопроса;
    Если Ответ = КодВозвратаДиалога.Да Тогда
        ДобавитьКомментарийНаСервере(НовыйКомментарий);
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	РазблокироватьОбъект();
	
КонецПроцедуры

//_____________________________________________________________
// СЕРВЕР

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	мЭтоНовыйДокумент = ЭтоНовыйДокумент();
	Если мЭтоНовыйДокумент Тогда
		Объект.Автор = ПараметрыСеанса.ТекущийПользователь;
		Объект.Ответственный = ПараметрыСеанса.ТекущийПользователь;
		Объект.Дата = ТекущаяДата();
		КоментарииКЗадаче.Параметры.УстановитьЗначениеПараметра("Объект", Объект.Ссылка);
		СвязанныеЗадачи.Параметры.УстановитьЗначениеПараметра("Объект", Неопределено);
		ИсторияИзменений.Параметры.УстановитьЗначениеПараметра("Объект", Объект.Ссылка);
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОтслеживающиеПользователиПоУмолчанию.Пользователь
		|ИЗ
		|	РегистрСведений.ОтслеживающиеПользователиПоУмолчанию КАК ОтслеживающиеПользователиПоУмолчанию";
		
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл 
			НоваяСтрока = Объект.ОтслеживающиеПользователи.Добавить();
			НоваяСтрока.Пользователь = Выборка.Пользователь;
		КонецЦикла;
		
	Иначе          
		КоментарииКЗадаче.Параметры.УстановитьЗначениеПараметра("Объект", Объект.Ссылка);
		СвязанныеЗадачи.Параметры.УстановитьЗначениеПараметра("Объект", Объект.Ссылка);
		ИсторияИзменений.Параметры.УстановитьЗначениеПараметра("Объект", Объект.Ссылка);
		НомерЗадачи = Общий.офУдалитьЛидирующиеСимволы(Объект.Номер);
	КонецЕсли;
	
	Элементы.ФД_Подробности.Шрифт = ШрифтыСтиля.ШрифтТекстовыхПолей;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТекущийОбъект._ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
	МассивСообщений = Новый Массив;
	ТекущийОбъект.ПроверитьКорректностьНаСервере(ЭтаФорма, ТекущийОбъект, Отказ, МассивСообщений);
	
	Если Отказ Тогда
	    Сообщение = Новый СообщениеПользователю();
		
		Для Каждого ТекСтрока Из МассивСообщений Цикл
			Сообщение.Текст = ТекСтрока.ТекстСообщения;
			Сообщение.Поле = ТекСтрока.Поле;//"Объект.РелизКонфигурации";
			Сообщение.УстановитьДанные(Объект);
			Сообщение.Сообщить();
  		КонецЦикла;
	КонецЕсли;
	
	Если Не Отказ Тогда 
		ПредставлениеИзменений = ТекущийОбъект.ПолучитьПредставлениеИзмененийОбъекта();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	КоментарииКЗадаче.Параметры.УстановитьЗначениеПараметра("Объект", Объект.Ссылка);
	
	Если мЭтоНовыйДокумент Тогда
		Общий.офОбработатьСобытие(Объект.Ссылка, ПараметрыСеанса.ТекущийПользователь, Справочники.СобытияИстории.СозданиеЗадачи);
		мЭтоНовыйДокумент = ЭтоНовыйДокумент();
	Иначе 
		Если не ПустаяСтрока(ПредставлениеИзменений) Тогда 
			Общий.офОбработатьСобытие(Объект.Ссылка, ПараметрыСеанса.ТекущийПользователь, Справочники.СобытияИстории.ИзмененияПолейЗадачи, ПредставлениеИзменений);
		КонецЕсли;
	КонецЕсли;
	
	НомерЗадачи = Общий.офУдалитьЛидирующиеСимволы(Объект.Номер);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	Если Не ЭтоНовыйДокумент() Тогда 
		ТекущийОбъект._ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	
КонецПроцедуры

#КонецОбласти

//_____________________________________________________________
#Область СобытияЭлементов

//_____________________________________________________________
// КЛИЕНТ

&НаКлиенте
Процедура ДатаЗакрытияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Если Вопрос("Установить текущую дату и время?",РежимДиалогаВопрос.ДаНет)=КодВозвратаДиалога.Да Тогда
		Объект.ДатаЗакрытия = ТекущаяДата();
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ФД_ПодробностиПриИзменении(Элемент)
	ЭтаФорма.Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ФД_ОписаниеРешенияПриИзменении(Элемент)
	ЭтаФорма.Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПриложенияПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	АдресВХранилище = "";
	ВыбранноеИмяФайла = "";
	Если ПоместитьФайл(АдресВХранилище,,ВыбранноеИмяФайла,Истина,ЭтаФорма.УникальныйИдентификатор) Тогда
		ЗаписатьПриложение(АдресВХранилище,ВыбранноеИмяФайла);	
		ЭтаФорма.Модифицированность = Истина;
	КонецЕсли;
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПриложенияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	АдресВХранилище = "";
	ПрочитатьПриложение(ВыбраннаяСтрока,АдресВХранилище);
    ПолучитьФайл(АдресВХранилище,Объект.Приложения[ВыбраннаяСтрока].ИмяФайла,Истина);
КонецПроцедуры

&НаКлиенте
Процедура СостояниеЗадачиПриИзменении(Элемент)
	
	УправлениеДиалогом();
	УстановитьИсполнительОтклик();
	Напоминания = ПолучитьНапоминания("СостояниеЗадачиПриИзменении");
	Если Не ПустаяСтрока(Напоминания) Тогда 
		ПоказатьПредупреждение(, Напоминания);
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура кнВставитьКартинкуИзБуфера(Кнопка)
	
	#Если Не ВебКлиент Тогда 
	КаталогВФ = КаталогВременныхФайлов();
	ИмяФайлаПрограммы = КаталогВФ + "CbToJPEG.exe";
	ДвоичныеДанныеПрограммы = сПолучитьОбщийМакет("CbToJPEG");
	ДвоичныеДанныеПрограммы.Записать(ИмяФайлаПрограммы);
	ФайлПрограммы = Новый Файл(ИмяФайлаПрограммы);
	
	ИмяФайлаКартинки = КаталогВФ + Формат(ТекущаяДата(), "ДФ=yyyyMMddHHmmss") + "_tmp.JPG";
	
	СтрокаЗапуска = """"+ФайлПрограммы.ПолноеИмя+""" """+ИмяФайлаКартинки+"""";
	
	WshShell = Новый COMОбъект("WScript.Shell");
	WshShell.Run(СтрокаЗапуска, 0, Истина);
	
	ФайлКартинки = Новый Файл(ИмяФайлаКартинки);
	Если Не ФайлКартинки.Существует() Тогда 
		ИмяФайлаКартинки = Неопределено;
	КонецЕсли;
	
	Если ИмяФайлаКартинки <> Неопределено Тогда 
		мКартинка = Новый Картинка(ИмяФайлаКартинки);
		
		ПозицияНачала = 0;
		ПозицияОкончания = 0;
		Элементы.ФД_Подробности.ПолучитьГраницыВыделения(ПозицияНачала,ПозицияОкончания);
		
		ВставитьКартинку(ПозицияНачала, мКартинка.ПолучитьДвоичныеДанные());
		УдалитьФайлы(ИмяФайлаКартинки);
	КонецЕсли;
	УдалитьФайлы(ИмяФайлаПрограммы);
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьКомментарий(Команда)
	
	Если ПустаяСтрока(НовыйКомментарий) Тогда 
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Поле комментарий не заполнено!";
		Сообщение.Поле = "НовыйКомментарий";
		Сообщение.УстановитьДанные(Объект);
		Сообщение.Сообщить();
		
		//Сообщить("Поле комментарий не заполнено!");
		Возврат;
	КонецЕсли;
	
	Если ЭтоНовыйДокумент() ИЛИ Модифицированность Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Перед добавлением комментария необходимо записать задачу!";
		Сообщение.Поле = "Элементы.ФормаКоманднаяПанель.ПодчиненныеЭлементы.ФормаЗаписать";
		//Элементы.ФормаКоманднаяПанель.ПодчиненныеЭлементы.
		Сообщение.УстановитьДанные(Объект);
		Сообщение.Сообщить();
		//Сообщить("Перед добавлением комментария необходимо записать задачу!");
		Возврат;
	КонецЕсли;
	
	ДобавитьКомментарийНаСервере(НовыйКомментарий);
	НовыйКомментарий = "";
	Элементы.КоментарииКЗадаче.Обновить();
	
КонецПроцедуры

//_____________________________________________________________
// СЕРВЕР

&НаСервере
Функция ПолучитьНапоминания(ИмяСобытия)
	
	Напоминания = "";
	
	Если ИмяСобытия = "СостояниеЗадачиПриИзменении" Тогда 
		Если Объект.СостояниеЗадачи = Справочники.СостоянияЗадач.Закрыта И Не ПустаяСтрока(Объект.НомерЗадачиВнешний) Тогда 
			Напоминания = "Не забудьте закрыть задачу в Мантис!";
		КонецЕсли;
	КонецЕсли;
	
	Возврат Напоминания;
	
КонецФункции

&НаСервере
Процедура ЗаписатьПриложение(АдресВХранилище,ВыбранноеИмяФайла)
	ТекДок = РеквизитФормыВЗначение("Объект");
	ТекДок._ЗаписатьПриложение(АдресВХранилище,ВыбранноеИмяФайла);
	ЗначениеВРеквизитФормы(ТекДок, "Объект");	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьПриложение(НомерСтроки,АдресВХранилище)
	ТекДок = РеквизитФормыВЗначение("Объект");
	ТекДок._ПрочитатьПриложение(НомерСтроки,АдресВХранилище,ЭтаФорма.УникальныйИдентификатор);	
КонецПроцедуры

&НаСервере
Процедура ДобавитьКомментарийНаСервере(ТекстКомментария)
	
	МенеджерЗаписи = РегистрыСведений.Коментарии.СоздатьМенеджерЗаписи();
	
	МенеджерЗаписи.Объект 			= Объект.Ссылка;
	МенеджерЗаписи.ДатаДобавления 	= ТекущаяДата()+1;
	МенеджерЗаписи.ID 				= Общий.офПолучитьНовыйIDКомментария();
	МенеджерЗаписи.Пользователь 	= ПараметрыСеанса.ТекущийПользователь;
	
	МенеджерЗаписи.Комментарий 		= ТекстКомментария;

	МенеджерЗаписи.Записать(Истина);
	
	Общий.офОбработатьСобытие(Объект.Ссылка, ПараметрыСеанса.ТекущийПользователь, Справочники.СобытияИстории.ДобавлениеКомментария, ТекстКомментария, МенеджерЗаписи.ДатаДобавления);
	
КонецПроцедуры

&НаСервере
Процедура ВставитьКартинкуИзБуфера(ФД_Подробности)
	
	ИмяФайлаКартинки = Общий.офСохранитьКартинкуИзБуфераНаДиск();
	Если ИмяФайлаКартинки <> Неопределено Тогда 
		ФД_Подробности.Добавить(Новый Картинка(ИмяФайлаКартинки), ТипЭлементаФорматированногоДокумента.Картинка); 
		УдалитьФайлы(ИмяФайлаКартинки);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ВставитьКартинку(ЗакладкаНачало, мКартинка)
	
	ЭтаФорма.ФД_Подробности.Вставить(ЗакладкаНачало, мКартинка, ТипЭлементаФорматированногоДокумента.Картинка); 
		
КонецПроцедуры

&НаСервере
Функция ПолучитьВидимостьИсполнительОтклик()
	
	Возврат (Объект.СостояниеЗадачи = Справочники.СостоянияЗадач.НуженОтклик);
	
КонецФункции

&НаСервере
Процедура УстановитьИсполнительОтклик()
	
	Если Объект.СостояниеЗадачи = Справочники.СостоянияЗадач.НуженОтклик Тогда 
		Если ПараметрыСеанса.ТекущийПользователь = Объект.Исполнитель Тогда 
			Если ПараметрыСеанса.ТекущийПользователь <> Объект.Ответственный Тогда 
				Объект.ИсполнительОтклик = Объект.Ответственный;
			КонецЕсли;
		ИначеЕсли ПараметрыСеанса.ТекущийПользователь = Объект.Ответственный Тогда 
			Если ПараметрыСеанса.ТекущийПользователь <> Объект.Исполнитель Тогда 
				Объект.ИсполнительОтклик = Объект.Исполнитель;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьПользователяВОтслеживающиеНаСервере()
	
	ТекущийПользователь = ПараметрыСеанса.ТекущийПользователь;
	НайденныеСтроки = Объект.ОтслеживающиеПользователи.НайтиСтроки(Новый Структура("Пользователь", ТекущийПользователь));
	Если НайденныеСтроки.Количество() = 0 Тогда 
		НоваяСтрка = Объект.ОтслеживающиеПользователи.Добавить();
		НоваяСтрка.Пользователь = ТекущийПользователь;
	Иначе
		Сообщить("Пользователь уже есть в списке!");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция УстановитьЦветСостоянияНаСервере()
	
	Элементы.СостояниеЗадачи.ЦветФона = Общий.обПолучитьЦветСостоянияЗадачи(Объект.СостояниеЗадачи, Объект.Исполнитель, Объект.ИсполнительОтклик);
	
КонецФункции

#КонецОбласти

//_____________________________________________________________
#Область Доп

&НаКлиенте
Процедура УправлениеДиалогом()
	
	Элементы.ИсполнительОтклик.Видимость = ПолучитьВидимостьИсполнительОтклик();
	УстановитьЦветСостоянияНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура Отслеживать(Команда)
	
	ДобавитьПользователяВОтслеживающиеНаСервере();
	
КонецПроцедуры

&НаСервере
Функция ЭтоНовыйДокумент() Экспорт
	Возврат Объект.Ссылка.Пустая();
КонецФункции

&НаСервере
Процедура ЗаблокироватьОбъект(ТекстСообщения)
	
	ТекДок = РеквизитФормыВЗначение("Объект");
	ТекДок._ЗаблокироватьОбъект(ЭтаФорма, ТекДок, ТекстСообщения);
	Если Не ПустаяСтрока(ТекстСообщения) Тогда 
		Общий.обСделатьЭлементыТолькоЧтение(ЭтаФорма);
		Сообщить(Общий.офПолучитьСообщениеОБлокировкеОбъекта(ТекстСообщения));
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура РазблокироватьОбъект()
	
	ТекДок = РеквизитФормыВЗначение("Объект");
	ТекДок._РазблокироватьОбъект(ЭтаФорма, ТекДок);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЗаголовокКомментарии()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КОЛИЧЕСТВО(Коментарии.ДатаДобавления) КАК КоличествоКомментариев
	|ИЗ
	|	РегистрСведений.Коментарии КАК Коментарии
	|ГДЕ
	|	Коментарии.Объект = &Объект";
	
	Запрос.УстановитьПараметр("Объект", Объект.Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();
	ЗаголовокКомментарии = 0;
	Если Выборка.Следующий() Тогда 
		ЗаголовокКомментарии = Выборка.КоличествоКомментариев;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЗаголовокОтслеживающие()
	
	ЗаголовокОтслеживающие = Объект.ОтслеживающиеПользователи.Количество();
	
КонецПроцедуры           

&НаСервере
Процедура ОбновитьЗаголовокВложения()
	
	ЗаголовокВложения = Объект.Приложения.Количество();
	
КонецПроцедуры           

&НаСервереБезКонтекста
Функция сПолучитьОбщийМакет(ИмяМакета)
	Возврат ПолучитьОбщийМакет(ИмяМакета);
КонецФункции

&НаКлиенте
Процедура НадписьНомерЗадачиВнешнийНажатие(Элемент)
	
	НомерЗадачи = Общий.офУдалитьЛидирующиеСимволы(Объект.НомерЗадачиВнешний, "0");
	
	Если Не ПустаяСтрока(НомерЗадачи) Тогда 
		ЗапуститьПриложение("http://support.a-holding.ch:3126/mantisbt/view.php?id=" + НомерЗадачи) ;
	Иначе 
		ПоказатьПредупреждение(, "Не указан номер задачи в Мантис!", 15, "Некорректные данные");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьСтатью(Команда)
	
	СтруктураПараметров = Новый Структура();
	
	СтруктураПараметров.Вставить("Задача", Объект.Ссылка);
	
	ФормаСтатья = ПолучитьФорму("Документ.Статья.ФормаОбъекта", СтруктураПараметров);
	
	ФормаСтатья.Открыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнитьСтатью(Команда)
	// Вставить содержимое обработчика.
КонецПроцедуры

&НаКлиенте
Процедура Команда1(Команда)
	
	Элементы.ДобавлениеКомментария.РастягиватьПоВертикали = Не Элементы.ДобавлениеКомментария.РастягиватьПоВертикали;
	Сообщить("Стало: " + Элементы.ДобавлениеКомментария.РастягиватьПоВертикали);
	
КонецПроцедуры

&НаКлиенте
Процедура Команда2(Команда)
	
	Высота = 0;
	
	Если ВвестиЧисло(Высота, "Введите высоту") Тогда 
		Элементы.ДобавлениеКомментария.Высота = Высота;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция ИзменитьСостояниеНаСервере()
	
	Объект.СостояниеЗадачи = Справочники.СостоянияЗадач.ВРаботе;

КонецФункции

&НаКлиенте
Процедура ОткрытьСтраницуСтандартноеСостояние()
	
	Элементы.ГруппаСменыСостояний.ТекущаяСтраница = Элементы.СтраницаСостояниеЗадачи;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьСостояниеНажатие(Элемент)
	
	ИзменитьСостояниеНаСервере();
	
	ОбъектЗаписан = Записать();
	
	Если ОбъектЗаписан Тогда
		ОткрытьСтраницуСтандартноеСостояние();
		//ПоказатьВопрос(Новый ОписаниеОповещения("ИзменитьСостояниеЗавершение", ЭтотОбъект), "Закрыть форму задачи?", РежимДиалогаВопрос.ДаНет, 60); 
	КонецЕсли;
	
	УправлениеДиалогом();
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьСостояниеЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    Ответ = РезультатВопроса;
    Если Ответ = КодВозвратаДиалога.Да Тогда
        ЭтаФорма.Закрыть();
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСтраницуСтандартноеСостояниеНажатие(Элемент)
	
	ОткрытьСтраницуСтандартноеСостояние();

КонецПроцедуры

&НаСервере
Процедура ЗаписатьСостояниеЗадачиНаСервере()
	
	РеквизитФормыВЗначение("Объект").ЗаписатьСостояниеЗадачи();
	
КонецПроцедуры

&НаКлиенте
Процедура КоментарииКЗадачеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	// Вставить содержимое обработчика.
КонецПроцедуры

&НаСервере
Процедура РедактироватьКомментарийНаСервере(Команда)
	
	
	
КонецПроцедуры


&НаСервереБезКонтекста
Функция ПолучитьЗначениеКлючаЗаписиКомментарийНаСервере(ПараметрыЗаписи)
	
	КоментарииМенеджерЗаписи = РегистрыСведений.Коментарии.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(КоментарииМенеджерЗаписи, ПараметрыЗаписи);
	
	КоментарииМенеджерЗаписи.Прочитать();
	
	КлючЗаписи=Неопределено;
	Если КоментарииМенеджерЗаписи.Выбран() Тогда
		МассивОтбораКлючаЗаписи = Новый Массив;
		
		МассивОтбораКлючаЗаписи.Добавить(ПараметрыЗаписи);
		
		КлючЗаписи = Новый ("РегистрСведенийКлючЗаписи.Коментарии", МассивОтбораКлючаЗаписи);
	КонецЕсли;
	
	Возврат КлючЗаписи;
	
КонецФункции // ПолучитьЗначениеКлючаЗаписиКомментарийНаСервере(ПараметрыЗаписи)

&НаСервереБезКонтекста
Функция ПолучитьПараметрыЗаписиКомментарийНаСервере(Пользователь, ДатаДобавления, Задача, ID)
	
	ПараметрыЗаписи = Новый Структура("Пользователь, ДатаДобавления, Объект, ID", Пользователь, ДатаДобавления, Задача, ID);
	Возврат ПараметрыЗаписи;
	
КонецФункции // ПолучитьПараметрыЗаписиКомментарийНаСервере(Задача)

&НаСервереБезКонтекста
Функция ЭтоКомментарийТекущегоПользователя(Пользователь)
	
	Если Пользователь = ПараметрыСеанса.ТекущийПользователь Тогда 
		Результат = Истина;
	Иначе
		Результат = Ложь;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции // ПолучитьПараметрыЗаписиКомментарийНаСервере(Задача)

&НаКлиенте
Процедура РедактироватьКомментарий(Команда)
	
	ТекущиеДанные = Элементы.КоментарииКЗадаче.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда 
		Если ЭтоКомментарийТекущегоПользователя(ТекущиеДанные.Пользователь) Тогда 

			ПараметрыЗаписи = ПолучитьПараметрыЗаписиКомментарийНаСервере(ТекущиеДанные.Пользователь, ТекущиеДанные.ДатаДобавления, Объект.Ссылка, ТекущиеДанные.ID);
			КлючЗаписи = ПолучитьЗначениеКлючаЗаписиКомментарийНаСервере(ПараметрыЗаписи);
			
			ФормаЗаписи=ПолучитьФорму("РегистрСведений.Коментарии.ФормаЗаписи",	Новый Структура("Ключ, ОткрытаДляРедактирования", КлючЗаписи, Истина));
			
			Если КлючЗаписи = Неопределено Тогда
				ЗаполнитьЗначенияСвойств(ФормаЗаписи.Запись, ПараметрыЗаписи);
			КонецЕсли;
			
			ФормаЗаписи.ОткрытьМодально();
			
			Элементы.КоментарииКЗадаче.Обновить();
			
		Иначе
			ПоказатьПредупреждение(, "Запрещено редактировать комментарии других пользователей!", 15);
		КонецЕсли; 
	КонецЕсли; 
		
КонецПроцедуры




#КонецОбласти

