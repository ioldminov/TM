﻿
Функция НайтиЗаданиеПоИдентификатору(Знач ИдентификаторЗадания)
	
	Если ТипЗнч(ИдентификаторЗадания) = Тип("Строка") Тогда
		ИдентификаторЗадания = Новый УникальныйИдентификатор(ИдентификаторЗадания);
	КонецЕсли;
	
	Задание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ИдентификаторЗадания);
	Возврат Задание;
	
КонецФункции

// Проверяет состояние фонового задания по переданному идентификатору.
// При аварийном завершении задания вызывает исключение.
//
// Параметры:
//  ИдентификаторЗадания - УникальныйИдентификатор - идентификатор фонового задания. 
//
// Возвращаемое значение:
//  Булево - состояние выполнения задания.
// 
Функция ЗаданиеВыполнено(Знач ИдентификаторЗадания) Экспорт
	
	Задание = НайтиЗаданиеПоИдентификатору(ИдентификаторЗадания);
	
	Если Задание <> Неопределено
		И Задание.Состояние = СостояниеФоновогоЗадания.Активно Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ОперацияНеВыполнена = Истина;
	ПоказатьПолныйТекстОшибки = Ложь;
	мОписаниеОшибки = "";
	Если Задание = Неопределено Тогда
		мОписаниеОшибки = "Длительные операции.Фоновое задание не найдено";
	Иначе
		Если Задание.Состояние = СостояниеФоновогоЗадания.ЗавершеноАварийно Тогда
			ОшибкаЗадания = Задание.ИнформацияОбОшибке;
			Если ОшибкаЗадания <> Неопределено Тогда
				ПоказатьПолныйТекстОшибки = Истина;
			КонецЕсли;
		ИначеЕсли Задание.Состояние = СостояниеФоновогоЗадания.Отменено Тогда
			мОписаниеОшибки = "Длительные операции.Фоновое задание отменено администратором";
		Иначе
			Возврат Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если ПоказатьПолныйТекстОшибки Тогда
		ТекстОшибки = КраткоеПредставлениеОшибки(Задание.ИнформацияОбОшибке);
		ВызватьИсключение(ТекстОшибки);
	ИначеЕсли ОперацияНеВыполнена Тогда
		ВызватьИсключение("Не удалось выполнить данную операцию. Подробности: " + мОписаниеОшибки);
	КонецЕсли;
	
КонецФункции

//////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ

Процедура ВыполнитьДлительнуюОперацию(Длительность, АдресВХранилище) Экспорт
	
	// Имитация продолжительного действия (Длительность сек.).
	ДатаНачалаОперации = ТекущаяДата();
	Пока ТекущаяДата() - ДатаНачалаОперации < Длительность Цикл
		
	КонецЦикла;
	ДатаОкончанияОперации = ТекущаяДата();
	
	Струк = Новый Структура("ДатаНачалаОперации, ДатаОкончанияОперации", ДатаНачалаОперации, ДатаОкончанияОперации);
	ПоместитьВоВременноеХранилище(Струк, АдресВХранилище);
	
КонецПроцедуры

#Область Новости

Функция ПолучитьТаблицуНепрочитанныхНовостей()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	АдресацияНовостей.Период,
	|	АдресацияНовостей.Объект,
	|	АдресацияНовостей.Адресат
	|ИЗ
	|	РегистрСведений.АдресацияНовостей КАК АдресацияНовостей
	|ГДЕ
	|	АдресацияНовостей.Адресат = &Адресат
	|	И АдресацияНовостей.Прочитана = ЛОЖЬ";
	Запрос.УстановитьПараметр("Адресат", ПараметрыСеанса.ТекущийПользователь);
	
	Возврат Запрос.Выполнить().Выгрузить();
		
КонецФункции

Функция ПолучитьМаксДатуНовостей()
	
	МаксДатаНовостей = '0001 01 01';
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	МАКСИМУМ(АдресацияНовостей.Период) КАК Период
	|ИЗ
	|	РегистрСведений.АдресацияНовостей КАК АдресацияНовостей
	|ГДЕ
	|	АдресацияНовостей.Адресат = &Адресат
	|	И АдресацияНовостей.Прочитана = ЛОЖЬ";
	Запрос.УстановитьПараметр("Адресат", ПараметрыСеанса.ТекущийПользователь);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Если Выборка.Период <> Null Тогда 
			МаксДатаНовостей = Выборка.Период;
		КонецЕсли;
	КонецЕсли;
	
	Возврат МаксДатаНовостей;
		
КонецФункции

Функция ПроверитьНаличиеНовыхНовостей(АдресДанныхВХранилище, МаксДатаНовостей) Экспорт 
	
	Результат = Ложь;
	СтруктураВозврата = Новый Структура("СвежиеНовостиПрисутствуют, МаксДатаНовостей");
	
	Если Не ЗначениеЗаполнено(МаксДатаНовостей) Тогда
		
		МаксДатаНовостей = ПолучитьМаксДатуНовостей();
		
	Иначе
		
		МаксДатаНепрочитанныхНовостей = ПолучитьМаксДатуНовостей();
		
		Если МаксДатаНепрочитанныхНовостей > МаксДатаНовостей Тогда 
			
			Результат = Истина;
			МаксДатаНовостей = МаксДатаНепрочитанныхНовостей;
			
		КонецЕсли;
		
	КонецЕсли;
	                                              
	СтруктураВозврата.СвежиеНовостиПрисутствуют = Результат;
	СтруктураВозврата.МаксДатаНовостей = МаксДатаНовостей;
	
	ПоместитьВоВременноеХранилище(СтруктураВозврата, АдресДанныхВХранилище);
	
КонецФункции

#КонецОбласти