﻿
&НаКлиенте
Перем ВремяОткрытияФормы;

//_____________________________________________________________
#Область СобытияФормы

//_____________________________________________________________
// КЛИЕНТ

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Параметры.Ключ.Пустая() Тогда 
		Элементы.Комментарии.Доступность = Ложь;
		Элементы.ГруппаДеревоСвязей.Доступность = Ложь;
	КонецЕсли;
	
	ТекстСообщения = "";
	//ЗаблокироватьОбъект(ТекстСообщения);
	//ПриОткрытииФрагмент();
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
	
	//УстановитьРасширеннуюПодсказкуДляДокументаОснования();
	
	ВремяОткрытияФормы = ТекущаяДата();
	ПодключитьОбработчикОжидания("ПредложитьПринятьЗадачуВРаботу", 300, Ложь); // через пять минут будет предложено принять задачу в работу;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредложитьПринятьЗадачуВРаботу()
	
	Если ЕстьВозможностьБыстройСменыСостояния() Тогда 
		Оповещение = Новый ОписаниеОповещения("ПредложитьПринятьЗадачуВРаботуЗавершение", ЭтаФорма, Параметры);
		ПоказатьВопрос(Оповещение, "Форма задачи открыта вами более пяти минут. 
		|Принять задачу в работу?", РежимДиалогаВопрос.ДаНет, 300);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПредложитьПринятьЗадачуВРаботуЗавершение(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ОтключитьОбработчикОжидания("ПредложитьПринятьЗадачуВРаботу");
		УстановитьСостояниеВРаботе();
	КонецЕсли;

КонецПроцедуры


&НаКлиенте
Процедура УстановитьРастягиваниеПоляКомментария()
	
	Элементы.ДобавлениеКомментария.РастягиватьПоВертикали = Истина;//Не Элементы.ДобавлениеКомментария.РастягиватьПоВертикали;
	Элементы.ПодробностиИстории.РастягиватьПоВертикали = Истина;//Не Элементы.ДобавлениеКомментария.РастягиватьПоВертикали;
	
КонецПроцедуры

&НаСервере
Функция ЕстьВозможностьБыстройСменыСостоянияНаСервере() 
	
	Результат = Ложь;
	
	Если Объект.Исполнитель = ПараметрыСеанса.ТекущийПользователь
		И Объект.СостояниеЗадачи = Справочники.СостоянияЗадач.Назначена Тогда 
		Результат = Истина;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Функция ЕстьВозможностьБыстройСменыСостояния() 
	
	Если флЕстьВозможностьБыстройСменыСостояния = Неопределено Тогда 
		флЕстьВозможностьБыстройСменыСостояния = ЕстьВозможностьБыстройСменыСостоянияНаСервере();
	КонецЕсли;
	
	Возврат флЕстьВозможностьБыстройСменыСостояния;
	
КонецФункции

&НаКлиенте
Процедура ПриОткрытииФрагмент()
    
	//ОбновитьЗаголовокКомментарии();
	//ОбновитьЗаголовокОписаниеДляРелиза();
	//ОбновитьЗаголовокОписаниеДляРелиза();
	//ОбновитьЗаголовокОтслеживающие();
	//ОбновитьЗаголовокВложения();
	//ОбновитьЗаголовокДеревоСвязанныхОбъектов();
	//УправлениеДиалогом();

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
	Элементы.ГруппаДеревоСвязей.Доступность = Истина;
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
Процедура ЗаполнитьСписокСостоянийЗадач()
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СостоянияЗадач.Ссылка,
	|	СостоянияЗадач.Представление
	|ИЗ
	|	Справочник.СостоянияЗадач КАК СостоянияЗадач
	|ГДЕ
	|	СостоянияЗадач.Используется = ИСТИНА
	|
	|УПОРЯДОЧИТЬ ПО
	|	СостоянияЗадач.Порядок";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	СписокВыбора = Элементы.СостояниеЗадачи.СписокВыбора;
	СписокВыбора.Очистить();
	Пока Выборка.Следующий() Цикл 
		
		СписокВыбора.Добавить(Выборка.Ссылка, Выборка.Представление);
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТекстHTML = Неопределено;
	Вложения = Неопределено;
	ФД_Подробности.ПолучитьHTML(ТекстHTML, Вложения);
	//ФД_Подробности.УстановитьHTML(ТекстHTML, Вложения);
	
	мЭтоНовыйДокумент = Параметры.Ключ.Пустая();
	Если мЭтоНовыйДокумент Тогда
		
		// Для установки межстрочного интервала в 1.3 п нужно установить текст HTML.
		ТекстHTML = 
		"<html>
		|  <head>
		|    <meta http-equiv=""Content-Type"" content=""text/html; charset=utf-8"" />
		|    <meta http-equiv=""X-UA-Compatible"" content=""IE=Edge"" />
		|    <meta name=""format-detection"" content=""telephone=no"" />
		|    <style type=""text/css"">
		|      body{
		|        margin:0;
		|        padding:8px;
		|        overflow:auto;
		|        width:100%;
		|        height:100%;
		|      }
		|      p{
		|        line-height: 1.3;
		|        font-family: Verdana;
		|        font-size: 10pt;
		|        margin:0;
		|      }
		|      ol,ul{
		|        margin-top:0;
		|        margin-bottom:0;
		|      }
		|      img{
		|        border:none;
		|      }
		|    </style>
		|  </head>
		|<body>
		//|<p style='line-height: 1.3;text-align: left'><font size=""2""></font></p>
		|<p style='line-height: 1.3'><span style='font-family: Verdana; font-size: 10pt;'> </span></p>
		|</body>
		|</html>";
		ФД_Подробности.УстановитьHTML(ТекстHTML, Вложения);
		ФД_ОписаниеДляРелиза.УстановитьHTML(ТекстHTML, Вложения);
		
		Объект.Автор = ПараметрыСеанса.ТекущийПользователь;
		Объект.Ответственный = ПараметрыСеанса.ТекущийПользователь;
		Объект.Дата = ТекущаяДата();
		Объект.ТипЗадачи = Справочники.ТипыЗадач.Разработка;
		Объект.СостояниеЗадачи = Справочники.СостоянияЗадач.Новая;
		
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
		
		ТипЗадачи = Справочники.ТипыЗадач.Разработка;
		
	Иначе          
		КоментарииКЗадаче.Параметры.УстановитьЗначениеПараметра("Объект", Объект.Ссылка);
		СвязанныеЗадачи.Параметры.УстановитьЗначениеПараметра("Объект", Объект.Ссылка);
		ИсторияИзменений.Параметры.УстановитьЗначениеПараметра("Объект", Объект.Ссылка);
		НомерЗадачи = Общий.офУдалитьЛидирующиеСимволы(Объект.Номер);
	КонецЕсли;
	
	Элементы.ФД_Подробности.Шрифт = ШрифтыСтиля.ШрифтТекстовыхПолей;
	
	ЗаполнитьСписокСостоянийЗадач();
	
	УстановитьРасширеннуюПодсказкуДляДокументаОснования();
	
    ОбновитьЗаголовокКомментарии();
    ОбновитьЗаголовокОписаниеДляРелиза();
    ОбновитьЗаголовокОписаниеДляРелиза();
    ОбновитьЗаголовокОтслеживающие();
	ОбновитьЗаголовокВложения();
	ОбновитьЗаголовокДеревоСвязанныхОбъектов();
	УправлениеДиалогом();
	
	ТекстСообщения = "";
	ЗаблокироватьОбъект(ТекстСообщения);
	
	ЭтаФорма.флЕстьВозможностьБыстройСменыСостояния = ЕстьВозможностьБыстройСменыСостоянияНаСервере();	
	
	Элементы.Автор.ТолькоПросмотр = Общий.ЭтоПользователь();
	Элементы.Дата.ТолькоПросмотр = Не Параметры.Ключ.Пустая();
	
	
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
		
		Если Не ЗначениеЗаполнено(ТекущийОбъект.ТипЗадачи) Тогда 
			ТекущийОбъект.ТипЗадачи = Справочники.ТипыЗадач.Разработка;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	КоментарииКЗадаче.Параметры.УстановитьЗначениеПараметра("Объект", Объект.Ссылка);
	
	Если мЭтоНовыйДокумент Тогда
		Общий.офОбработатьСобытие(Объект.Ссылка, ПараметрыСеанса.ТекущийПользователь, Справочники.СобытияИстории.СозданиеЗадачи);
		мЭтоНовыйДокумент = Параметры.Ключ.Пустая();
	Иначе 
		Если не ПустаяСтрока(ПредставлениеИзменений) Тогда 
			Общий.офОбработатьСобытие(Объект.Ссылка, ПараметрыСеанса.ТекущийПользователь, Справочники.СобытияИстории.ИзмененияПолейЗадачи, ПредставлениеИзменений);
		КонецЕсли;
	КонецЕсли;
	
	НомерЗадачи = Общий.офУдалитьЛидирующиеСимволы(Объект.Номер);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	Если Не Параметры.Ключ.Пустая() Тогда 
		ТекущийОбъект._ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

//_____________________________________________________________
#Область СобытияЭлементов

//_____________________________________________________________
// КЛИЕНТ

&НаКлиенте
Процедура ДатаЗакрытияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	//Если Вопрос("Установить текущую дату и время?",РежимДиалогаВопрос.ДаНет)=КодВозвратаДиалога.Да Тогда
		Объект.ДатаЗакрытия = ТекущаяДата();
	//	СтандартнаяОбработка = Ложь;
	//КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ФД_ПодробностиПриИзменении(Элемент)
	ЭтаФорма.Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ФД_ОписаниеДляРелизаПриИзменении(Элемент)
	ЭтаФорма.Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПриложенияПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	//АдресВХранилище = "";
	//ВыбранноеИмяФайла = "";
	//Если ПоместитьФайл(АдресВХранилище,,ВыбранноеИмяФайла,Истина,ЭтаФорма.УникальныйИдентификатор) Тогда
	//	ЗаписатьПриложение(АдресВХранилище,ВыбранноеИмяФайла);	
	//	ЭтаФорма.Модифицированность = Истина;
	//КонецЕсли;
	ДобавитьФайлВПриложения();
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПриложенияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	АдресВХранилище = "";
	
	Если Элемент.ТекущиеДанные <> Неопределено Тогда 
		ИндексСтроки = Элемент.ТекущиеДанные.НомерСтроки - 1;
		
		ПрочитатьПриложение(ИндексСтроки,АдресВХранилище);
	    ПолучитьФайл(АдресВХранилище,Объект.Приложения[ИндексСтроки].ИмяФайла,Истина);
	КонецЕсли;
		
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
	ИмяФайлаКартинки = ОбщийКлиент.офСохранитьКартинкуИзБуфераНаДиск();

	Если ИмяФайлаКартинки <> Неопределено Тогда 
		мКартинка = Новый Картинка(ИмяФайлаКартинки);
		
		ПозицияНачала = 0;
		ПозицияОкончания = 0;
		Элементы.ФД_Подробности.ПолучитьГраницыВыделения(ПозицияНачала,ПозицияОкончания);
		
		ВставитьКартинку(ПозицияНачала, мКартинка.ПолучитьДвоичныеДанные());
		УдалитьФайлы(ИмяФайлаКартинки);
	КонецЕсли;
	//УдалитьФайлы(ИмяФайлаПрограммы);
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
	         
	Если Параметры.Ключ.Пустая() ИЛИ Модифицированность Тогда
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
Процедура ЗаписатьПриложение(АдресВХранилище, ВыбранноеИмяФайла,  ИмяФайлаВТаблице = "")
	
	ТекДок = РеквизитФормыВЗначение("Объект");
	
	ТекДок._ЗаписатьПриложение(АдресВХранилище, ВыбранноеИмяФайла, ИмяФайлаВТаблице);
	
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

&НаСервере
Процедура УправлениеДиалогом()
	
	Элементы.ИсполнительОтклик.Видимость = ПолучитьВидимостьИсполнительОтклик();
	УстановитьЦветСостоянияНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьФайлВПриложения(ВыбранноеИмяФайла = "", Интерактивно = Истина, УдалятьФайл = Ложь, ИмяФайлВТаблице = "")
	
	АдресВХранилище = "";
	
	Если ПоместитьФайл(АдресВХранилище,ВыбранноеИмяФайла,ВыбранноеИмяФайла,Интерактивно,ЭтаФорма.УникальныйИдентификатор) Тогда
		ЗаписатьПриложение(АдресВХранилище,ВыбранноеИмяФайла, ИмяФайлВТаблице);
		//ЭтаФорма.Модифицированность = Истина;
		Если УдалятьФайл Тогда 
			
			УдалитьФайлы(ВыбранноеИмяФайла);
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Отслеживать(Команда)
	
	ДобавитьПользователяВОтслеживающиеНаСервере();
	
КонецПроцедуры

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
Процедура ОбновитьЗаголовокОписаниеДляРелиза()
	
	ЗаголовокСутьРешенияЗадачи = "";
	Если Не ПустаяСтрока(Объект.ОписаниеДляРелиза) Тогда 
		ЗаголовокСутьРешенияЗадачи = 1;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЗаголовокСутьРешенияЗадачи()
	
	ЗаголовокСутьРешенияЗадачи = "";
	Если Не ПустаяСтрока(Объект.СутьРешенияЗадачи) Тогда 
		ЗаголовокСутьРешенияЗадачи = 1;
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

&НаСервере
Процедура ОбновитьЗаголовокДеревоСвязанныхОбъектов()
	
	Если Не Параметры.Ключ.Пустая() Тогда 
		обДеревоСвязанныхОбъектов = Обработки.ДеревоСвязанныхОбъектов.Создать();
		обДеревоСвязанныхОбъектов.ВыбДокумент = Объект.Ссылка;
		ЗаголовокДеревоСвязанныхОбъектов = обДеревоСвязанныхОбъектов.ПолучитьКоличествоОбъектовДерева() - 1;
	КонецЕсли;
	
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
Процедура УстановитьСостояниеВРаботе()
	
	ИзменитьСостояниеНаСервере();
	
	ОбъектЗаписан = Записать();
	
	Если ОбъектЗаписан Тогда
		ОткрытьСтраницуСтандартноеСостояние();
		//ПоказатьВопрос(Новый ОписаниеОповещения("ИзменитьСостояниеЗавершение", ЭтотОбъект), "Закрыть форму задачи?", РежимДиалогаВопрос.ДаНет, 60); 
	КонецЕсли;
	
	УправлениеДиалогом();
	
КонецПроцедуры


&НаКлиенте
Процедура ИзменитьСостояниеНажатие(Элемент)
	
	УстановитьСостояниеВРаботе();
	
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

&НаКлиенте
Процедура ПоказатьДеревоСвязанныхОбъектов(Команда)
	
	мПараметры = Новый Структура("ВыбДокумент", Объект.Ссылка);
	
	ОткрытьФорму("Обработка.ДеревоСвязанныхОбъектов.Форма.Форма", мПараметры, ЭтаФорма, ЭтаФорма);
	
КонецПроцедуры


&НаСервере
Процедура УстановитьРасширеннуюПодсказкуДляДокументаОснования()
	
	Если ЗначениеЗаполнено(Объект.ДокументОснование) Тогда 
		
		Элементы.ЗадачаОснование.ОтображениеПодсказки = ОтображениеПодсказки.Кнопка;
		Элементы.ЗадачаОснование.РасширеннаяПодсказка.Заголовок = "Суть: " + СокрЛП(Объект.ДокументОснование.Суть);
		
	Иначе
	
		Элементы.ЗадачаОснование.РасширеннаяПодсказка.Заголовок = "";
		Элементы.ЗадачаОснование.ОтображениеПодсказки = ОтображениеПодсказки.Нет;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗадачаОснованиеПриИзменении(Элемент)
	
	УстановитьРасширеннуюПодсказкуДляДокументаОснования();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДеревоСвязанныхДокументовНаСервере()
		
	обДеревоСвязанныхОбъектов = Обработки.ДеревоСвязанныхОбъектов.Создать();
	обДеревоСвязанныхОбъектов.ВыбДокумент = Объект.Ссылка;
	ЗаголовокДеревоСвязанныхОбъектов = обДеревоСвязанныхОбъектов.ЗаполнитьТабДокДеревоСвязанныхОбъектов(ПолеТабличногоДокументаДерево)-1;
	
КонецПроцедуры

&НаКлиенте
Процедура ОписаниеКомментарииПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	Если Элементы.ОписаниеКомментарии.ТекущаяСтраница = Элементы.ГруппаДеревоСвязей Тогда 
		
		ОбновитьДеревоСвязанныхДокументовНаСервере();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьМассивИерархииПроектов()
	
	МассивИерархииПроектов = Новый Массив;
	
	мПроект = Объект.Проект;
	МассивИерархииПроектов.Добавить(мПроект);
	
	ТекРодитель = мПроект.Родитель;
	Пока ЗначениеЗаполнено(ТекРодитель) Цикл 
		
		МассивИерархииПроектов.Добавить(ТекРодитель);
		ТекРодитель = ТекРодитель.Родитель;
		
	КонецЦикла;
	
	Возврат МассивИерархииПроектов;
		
КонецФункции

&НаКлиенте
Процедура РелизКонфигурацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	
	фиксНастройки = Новый НастройкиКомпоновкиДанных;
	
	мОтбор = фиксНастройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	мОтбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Проект");
	мОтбор.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	мОтбор.ПравоеЗначение = ПолучитьМассивИерархииПроектов();
	мОтбор.Использование = Истина;
	
	мОтбор.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный;
	
	
	мОтбор = фиксНастройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	мОтбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Выпущен");
	мОтбор.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	мОтбор.ПравоеЗначение = Ложь;
	мОтбор.Использование = Истина;
	
	мОтбор.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный;
	
	
	мПараметрыВыбора = Новый Структура;
	мПараметрыВыбора.Вставить("ФиксированныеНастройки", фиксНастройки);	
	
	ОткрытьФорму("Справочник.РелизыКонфигураций.ФормаВыбора", мПараметрыВыбора, Элемент);
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьТекстHTMLПодробности()
		
	ТекстHTMLПодробности = "";
	Вложения = Новый Структура;
	ФД_Подробности.ПолучитьHTML(ТекстHTMLПодробности, Вложения);
	
	Для Каждого ТекВложение Из Вложения Цикл
		Картинка = ТекВложение.Значение;
		ИмяФайла = ОбщийКлиент.офПолучитьКаталогВременныхФайлов() + ТекВложение.Ключ + ".jpg";
		Картинка.Записать(ИмяФайла);
		
		ТекстHTMLПодробности = СтрЗаменить(ТекстHTMLПодробности, "<img src='" + ТекВложение.Ключ + "'", "<img src='" + ИмяФайла + "'");
		
	КонецЦикла;
	
	ПозицияНачала = Найти(ТекстHTMLПодробности, "<body>") + 7;
	ПозицияКонца = Найти(ТекстHTMLПодробности, "</body>");
	ТекстHTMLПодробности = Сред(ТекстHTMLПодробности, ПозицияНачала, ПозицияКонца - ПозицияНачала);
	
	Возврат ТекстHTMLПодробности;
	
КонецФункции

&НаСервере
Функция ПолучитьТекстHTMLЗадачи()
	
	ТекстHTMLЗадачи = РеквизитФормыВЗначение("Объект").ПолучитьТекстHTMLЗадачи();
	
	Возврат ТекстHTMLЗадачи;
		
КонецФункции

&НаСервере
Функция ПолучитьТекстHTMLСтиля()
	
	ТекстHTMLСтиля = РеквизитФормыВЗначение("Объект").ПолучитьТекстHTMLСтиля();
	
	Возврат ТекстHTMLСтиля;
		
КонецФункции

&НаСервереБезКонтекста
Процедура УстановитьПараметрHTML(ТекстHTML, ИмяПараметра, Значение)
	
	ТекстHTML = СтрЗаменить(ТекстHTML, "[" + ИмяПараметра + "]", Строка(Значение));
		
КонецПроцедуры

&НаСервере
Функция ПолучитьОтслеживающих()
	
	мОтслеживающие = "";
	
	Для Каждого ТекСтрока Из Объект.ОтслеживающиеПользователи Цикл
		мОтслеживающие = мОтслеживающие + ТекСтрока.Пользователь + "; ";
	КонецЦикла;
	
	Возврат мОтслеживающие;
		
КонецФункции

&НаСервере
Функция ПолучитьВложения()
	
	мПриложения = "";
	
	Для Каждого ТекСтрока Из Объект.Приложения Цикл
		мПриложения = мПриложения + ТекСтрока.ИмяФайла + " - " + ТекСтрока.Пользователь + "<br>";
	КонецЦикла;
	
	Возврат СокрЛП(мПриложения);
		
КонецФункции

&НаСервере
Функция ЛиНуженОтклик()
		
	НуженОтклик = (Объект.СостояниеЗадачи = Справочники.СостоянияЗадач.НуженОтклик);
	Возврат НуженОтклик;
	
КонецФункции

&НаСервере
Функция ПолучитьТекстHTMLКомментариев()
	
	ТекстHTMLКомментариев = "";
	
	ШаблонКомментария = 
	"<tr>
	|   <td class=""nopad"" valign=""top"" width=""20%"">
	|      <table class=""hide"" style=""height: 59px;"" width=""119"" cellspacing=""1"">
	|         <tbody>
	|            <tr>
	|               <td class=""print"">[АвторКомментария]&nbsp;&nbsp;&nbsp;</td>
	|            </tr>
	|            <tr>
	|               <td class=""print"">[ДатаКомментария]</td>
	|            </tr>
	|         </tbody>
	|      </table>
	|   </td>
	|   <td class=""nopad"" valign=""top"" width=""85%"">
	|      <table class=""hide"" style=""height: 51px;"" width=""698"" cellspacing=""1"">
	|         <tbody>
	|            <tr>
	|               <td class=""print"">[ТекстКомментария]</td>
	|            </tr>
	|         </tbody>
	|      </table>
	|   </td>
	|</tr>";
	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Коментарии.ДатаДобавления КАК ДатаДобавления,
	|	Коментарии.Пользователь,
	|	Коментарии.Комментарий
	|ИЗ
	|	РегистрСведений.Коментарии КАК Коментарии
	|ГДЕ
	|	Коментарии.Объект = &Объект
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДатаДобавления";
	
	Запрос.УстановитьПараметр("Объект", Объект.Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();

	Пока Выборка.Следующий() Цикл
		
		ТекКомментарийHTML = ШаблонКомментария;
		
		УстановитьПараметрHTML(ТекКомментарийHTML, "АвторКомментария", СокрЛП(Выборка.Пользователь));
		УстановитьПараметрHTML(ТекКомментарийHTML, "ДатаКомментария",  Выборка.ДатаДобавления);
		УстановитьПараметрHTML(ТекКомментарийHTML, "ТекстКомментария", СокрЛП(Выборка.Комментарий));
		
		ТекстHTMLКомментариев = ТекстHTMLКомментариев + ТекКомментарийHTML;
		
	КонецЦикла;
	
	Возврат ТекстHTMLКомментариев;
	
КонецФункции



&НаКлиенте
Процедура ПечатьЗадачи(Команда)
 
	ТекстHTMLПодробности = ПолучитьТекстHTMLПодробности();
	
	ТекстHTMLЗадачи = ПолучитьТекстHTMLЗадачи();
	
	ТекстHTMLСтиля = ПолучитьТекстHTMLСтиля();
	
	ТекстовыйДок = Новый ТекстовыйДокумент;
	ТекстовыйДок.УстановитьТекст(ТекстHTMLСтиля);
	
	
	ИмяФайлаСтиля = ОбщийКлиент.офПолучитьКаталогВременныхФайлов() + "TMgrDefault.css";
	ТекстовыйДок.Записать(ИмяФайлаСтиля);
	
	УстановитьПараметрHTML(ТекстHTMLЗадачи, "ИмяФайлаСтиля", 	ИмяФайлаСтиля);
	
	УстановитьПараметрHTML(ТекстHTMLЗадачи, "НомерЗадачи", 		Общий.офУдалитьЛидирующиеСимволы(Объект.Номер));
	УстановитьПараметрHTML(ТекстHTMLЗадачи, "ДатаЗадачи", 		Формат(Объект.Дата, "ДФ=dd.MM.yyyy"));
	
	УстановитьПараметрHTML(ТекстHTMLЗадачи, "Автор", 			Объект.Автор);
	УстановитьПараметрHTML(ТекстHTMLЗадачи, "Статус", 			Объект.Статус);
	УстановитьПараметрHTML(ТекстHTMLЗадачи, "Проект", 			Объект.Проект);
	
	УстановитьПараметрHTML(ТекстHTMLЗадачи, "Ответственный", 	Объект.Ответственный);
	УстановитьПараметрHTML(ТекстHTMLЗадачи, "ДатаПлан", 		?(Объект.ПлановаяДатаИсполнения = '00010101', "", Формат(Объект.ПлановаяДатаИсполнения, "ДФ=dd.MM.yyyy")));
	УстановитьПараметрHTML(ТекстHTMLЗадачи, "Модуль", 			Объект.Модуль);
	
	УстановитьПараметрHTML(ТекстHTMLЗадачи, "Исполнитель", 		Объект.Исполнитель);
	УстановитьПараметрHTML(ТекстHTMLЗадачи, "Состояние", 		Объект.СостояниеЗадачи);
	
	НуженОтклик = ЛиНуженОтклик();
	УстановитьПараметрHTML(ТекстHTMLЗадачи, "ТекстОтклик", 		?(НуженОтклик, " от ", ""));
	УстановитьПараметрHTML(ТекстHTMLЗадачи, "ОткликОт", 		?(НуженОтклик, Объект.ИсполнительОтклик, ""));
	
	УстановитьПараметрHTML(ТекстHTMLЗадачи, "Основание", 		Объект.ДокументОснование);
	
	УстановитьПараметрHTML(ТекстHTMLЗадачи, "Суть", 			Объект.Суть);
	УстановитьПараметрHTML(ТекстHTMLЗадачи, "Подробности", 		ТекстHTMLПодробности);
	
	УстановитьПараметрHTML(ТекстHTMLЗадачи, "ОписаниеКРелизу", 	Объект.ОписаниеДляРелиза);
	УстановитьПараметрHTML(ТекстHTMLЗадачи, "СутьРешенияЗадачи", 	Объект.СутьРешенияЗадачи);
	УстановитьПараметрHTML(ТекстHTMLЗадачи, "Отслеживающие", 	ПолучитьОтслеживающих());
	УстановитьПараметрHTML(ТекстHTMLЗадачи, "Вложения", 		ПолучитьВложения());
	
	УстановитьПараметрHTML(ТекстHTMLЗадачи, "Комментарии", 		ПолучитьТекстHTMLКомментариев());

	мПараметры = Новый Структура("ТекстHTML", ТекстHTMLЗадачи);
	
	ОткрытьФорму("Документ.Задача.Форма.ФормаПечатьHTML", мПараметры, ЭтаФорма, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриложенияПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	Если ТипЗнч(ПараметрыПеретаскивания.Значение) = Тип("Файл") Тогда
		
		СтандартнаяОбработка = Ложь;	
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриложенияПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	Если ТипЗнч(ПараметрыПеретаскивания.Значение) = Тип("Файл") Тогда
		
		СтандартнаяОбработка = Ложь;	
		
		ДобавитьФайлВПриложения(ПараметрыПеретаскивания.Значение.ПолноеИмя, Ложь, Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьКартинкуИзБуфераВПриложения(Команда)
	
	ИмяФайлаНаДиске = ОбщийКлиент.офСохранитьКартинкуИзБуфераНаДиск();
	
	Если ИмяФайлаНаДиске <> Неопределено Тогда
		Оповещение = Новый ОписаниеОповещения("ПослеВводаСтрокиДобавитьКартинкуИзБуфераВПриложения", ЭтотОбъект, Новый Структура("ИмяФайлаНаДиске", ИмяФайлаНаДиске));
		ПоказатьВводСтроки(Оповещение, "Изображение", "Укажите имя файла", 30, Ложь);
	Иначе
		Сообщить("Не удалось получить картинку из буфера!", СтатусСообщения.Внимание);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВводаСтрокиДобавитьКартинкуИзБуфераВПриложения(Строка, ПараметрыВызова) Экспорт
	
    Если НЕ Строка = Неопределено Тогда
		
		ДобавитьФайлВПриложения(ПараметрыВызова.ИмяФайлаНаДиске, Ложь, Истина, Строка + ".JPG");
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьИмяФайлаСтрокиВложений(ИндексСтроки, ИмяФайла)
	
	Попытка
		Объект.Приложения[ИндексСтроки].ИмяФайла = ИмяФайла;
		Этаформа.Модифицированность = Истина;
	Исключение
		Сообщить(ОписаниеОшибки());
	КонецПопытки;
	
КонецПроцедуры


&НаКлиенте
Процедура ПослеВводаСтрокиПереименоватьФайл(Строка, ПараметрыВызова) Экспорт
	
	Если НЕ Строка = Неопределено Тогда
		
		Если Не ПустаяСтрока(Строка) И Не Общий.рфЕстьЗапрещенныеСимволыИмени(Строка) Тогда 
			УстановитьИмяФайлаСтрокиВложений(ПараметрыВызова.ИндексСтроки, СокрЛП(Строка) + "." + ПараметрыВызова.РасширениеФайла);
		Иначе 
			Сообщить("Некорректно задано имя файла: Имя не должно быть пустым, и не должно содержать запрещенных знаков: \ / : * ? "" < > |");
			ПоказатьВводСтрокиИмяФайлаПриложений(Строка, ПараметрыВызова.РасширениеФайла, ПараметрыВызова.ИндексСтроки);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьВводСтрокиИмяФайлаПриложений(ИмяФайла, РасширениеФайла, ИндексСтроки)
		
	Оповещение = Новый ОписаниеОповещения("ПослеВводаСтрокиПереименоватьФайл", ЭтотОбъект, Новый Структура("ИмяФайла, РасширениеФайла, ИндексСтроки", ИмяФайла, РасширениеФайла, ИндексСтроки));
	ПоказатьВводСтроки(Оповещение, ИмяФайла, "Укажите имя файла", 70, Ложь);
	
КонецПроцедуры


&НаКлиенте
Процедура ПереименоватьФайл(Команда)
	
	ТекущиеДанные = Элементы.Приложения.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда 
		ИндексСтроки = ТекущиеДанные.НомерСтроки - 1;
		
		ИмяФайла = Общий.рфПолучитьИмяФайлаИзПолногоИмени(ТекущиеДанные.ИмяФайла, Истина);
		РасширениеФайла = Общий.рфПолучитьРасширениеФайла(ТекущиеДанные.ИмяФайла);
		
		ПоказатьВводСтрокиИмяФайлаПриложений(ИмяФайла, РасширениеФайла, ИндексСтроки);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриложенияНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	
	АдресВХранилище = "";
	
	Если Элемент.ТекущиеДанные <> Неопределено Тогда 
		ИндексСтроки = Элемент.ТекущиеДанные.НомерСтроки - 1;
		
		ПрочитатьПриложение(ИндексСтроки, АдресВХранилище);
		
		ПолноеИмяПеретаскиваемогоФайла = ОбщийКлиент.офПолучитьКаталогВременныхФайлов() + Элемент.ТекущиеДанные.ИмяФайла;
		
		ПолучитьФайл(АдресВХранилище, ПолноеИмяПеретаскиваемогоФайла, Ложь);
		
		Если ЗначениеЗаполнено(ПолноеИмяПеретаскиваемогоФайла) Тогда		
			Файл = Новый Файл(ПолноеИмяПеретаскиваемогоФайла);
			ПараметрыПеретаскивания.Значение = Файл;
		КонецЕсли;	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗадачаОснованиеОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	Попытка
		СтрокаПоиска = ПараметрыПолученияДанных.СтрокаПоиска;
		
		// если введены только цифры, то есть смысл поискать по номеру задачи
		мНомер = Число(СтрокаПоиска);
		ПараметрыПолученияДанных.СтрокаПоиска = Общий.офДобавитьЛидирующиеСимволы(СтрокаПоиска);
	Исключение
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

