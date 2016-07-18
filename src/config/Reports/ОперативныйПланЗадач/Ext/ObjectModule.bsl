﻿
Функция РазбитьСтроку(Знач Текст, МаксДлина)
	
	Результат = "";
	
	Пока СтрДлина(Текст) > МаксДлина Цикл 
		ТекПоз = МаксДлина - 10;
		ГраницаПоиска = Мин(СтрДлина(Текст), МаксДлина + 20);
		Пока Сред(Текст, ТекПоз, 1) <> " " И ТекПоз < ГраницаПоиска Цикл
			ТекПоз = ТекПоз + 1;
		КонецЦикла;
		
		Результат = Результат + Лев(Текст, ТекПоз) + Символы.ПС;
		Текст = Сред(Текст, ТекПоз + 1);
	КонецЦикла;
	Результат = Результат + Текст;
	
	Возврат Результат;
	
КонецФункции


Процедура СформироватьОтчет(ТабДок) Экспорт

	Макет = ПолучитьМакет("ПланЗадач");
	ОбластьИсполнитель = Макет.ПолучитьОбласть("ОбластьИсполнительСтрока|ОбластьИсполнительКолонка");
	ОбластьЗадача = Макет.ПолучитьОбласть("ЗадачаСтрока|ОбластьИсполнительКолонка");
	ОбластьРазделитель = Макет.ПолучитьОбласть("ОбластьРазделитель");
	ОбластьПустаяЗадача = Макет.ПолучитьОбласть("ПустаяЗадачаСтрока|ОбластьИсполнительКолонка");
	ТабДок.Очистить();

	ТабДок.Вывести(ОбластьРазделитель); 
	
	Запрос = Новый Запрос;
	ТекстОтборОперативныйПланЗадач = "";
	ТекстОтборЗадачиНуженОтклик = "";
	Если СписокПользователей.Количество() > 0 Тогда
		ТекстОтборОперативныйПланЗадач = " И ОперативныйПланЗадач.Задача.Исполнитель В (&СписокПользователей) ";
		ТекстОтборЗадачиНуженОтклик = " И ДокЗадача.ИсполнительОтклик В (&СписокПользователей) ";
		Запрос.УстановитьПараметр("СписокПользователей", СписокПользователей.ВыгрузитьКолонку("Пользователь"));
	КонецЕсли;
	
	ТекстЗапроса = 
	
	"ВЫБРАТЬ
	|	ОперативныйПланЗадач.Задача КАК Задача,
	|	ОперативныйПланЗадач.Порядок КАК Порядок,
	|	ОперативныйПланЗадач.Задача.Представление,
	|	ОперативныйПланЗадач.Задача.Исполнитель КАК Исполнитель,
	|	ОперативныйПланЗадач.Задача.Ответственный КАК Ответственный,
	|	ОперативныйПланЗадач.Задача.Суть КАК Суть,
	|	ВЫРАЗИТЬ(ОперативныйПланЗадач.Задача.Подробности КАК Строка(1000)) КАК Подробности,
	|	ОперативныйПланЗадач.Задача.СостояниеЗадачи КАК Состояние,
	|	ОперативныйПланЗадач.Задача.Исполнитель КАК ЗадачаИсполнитель,
	|	ОперативныйПланЗадач.Задача.ИсполнительОтклик КАК ЗадачаИсполнительОтклик
	|ПОМЕСТИТЬ ВТОперативныйПланЗадач
	|ИЗ
	|	РегистрСведений.ОперативныйПланЗадач КАК ОперативныйПланЗадач
	|ГДЕ
	|	ОперативныйПланЗадач.Задача.СостояниеЗадачи <> ЗНАЧЕНИЕ(Справочник.СостоянияЗадач.Закрыта)
	|	//ТекстОтборОперативныйПланЗадач
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДокЗадача.Ссылка КАК Задача,
	|	ДокЗадача.Представление,
	|	ДокЗадача.ИсполнительОтклик КАК Исполнитель,
	|	ДокЗадача.Ответственный КАК Ответственный,
	|	ДокЗадача.Суть КАК Суть,
	|	ВЫРАЗИТЬ(ДокЗадача.Подробности КАК Строка(1000)) КАК Подробности,
	|	ДокЗадача.СостояниеЗадачи КАК Состояние,
	|	ДокЗадача.Исполнитель КАК ЗадачаИсполнитель,
	|	ДокЗадача.ИсполнительОтклик КАК ЗадачаИсполнительОтклик,
	|	ЕСТЬNULL(ВТОперативныйПланЗадач.Порядок, 0) КАК Порядок
	|ПОМЕСТИТЬ ВТЗадачиНуженОтклик
	|ИЗ
	|	Документ.Задача КАК ДокЗадача
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТОперативныйПланЗадач КАК ВТОперативныйПланЗадач
	|		ПО ДокЗадача.Ссылка = ВТОперативныйПланЗадач.Задача
	|ГДЕ
	|	((ДокЗадача.СостояниеЗадачи = ЗНАЧЕНИЕ(Справочник.СостоянияЗадач.НуженОтклик)
	|	И ДокЗадача.ИсполнительОтклик <> ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка)
	|	И НЕ ДокЗадача.Ссылка В
	|				(ВЫБРАТЬ
	|					ВТОперативныйПланЗадач.Задача
	|				ИЗ
	|					ВТОперативныйПланЗадач КАК ВТОперативныйПланЗадач
	|				ГДЕ
	|					ВТОперативныйПланЗадач.ЗадачаИсполнитель = ВТОперативныйПланЗадач.ЗадачаИсполнительОтклик)))
	|	//ТекстОтборЗадачиНуженОтклик
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДокЗадача.Ссылка КАК Задача,
	|	ДокЗадача.Представление,
	|	ДокЗадача.Исполнитель КАК Исполнитель,
	|	ДокЗадача.Ответственный КАК Ответственный,
	|	ДокЗадача.Суть КАК Суть,
	|	ВЫРАЗИТЬ(ДокЗадача.Подробности КАК Строка(1000)) КАК Подробности,
	|	ДокЗадача.СостояниеЗадачи КАК Состояние,
	|	ДокЗадача.Исполнитель КАК ЗадачаИсполнитель,
	|	ДокЗадача.ИсполнительОтклик КАК ЗадачаИсполнительОтклик,
	|	ЕСТЬNULL(ВТОперативныйПланЗадач.Порядок, 0) КАК Порядок
	|ПОМЕСТИТЬ ВТЗадачиПрочие
	|ИЗ
	|	Документ.Задача КАК ДокЗадача
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТОперативныйПланЗадач КАК ВТОперативныйПланЗадач
	|		ПО ДокЗадача.Ссылка = ВТОперативныйПланЗадач.Задача
	|ГДЕ
	|	(ДокЗадача.СостояниеЗадачи = ЗНАЧЕНИЕ(Справочник.СостоянияЗадач.Отработана)
	|	ИЛИ ДокЗадача.СостояниеЗадачи = ЗНАЧЕНИЕ(Справочник.СостоянияЗадач.ВРаботе))
	|	И НЕ ДокЗадача.Ссылка В
	|				(ВЫБРАТЬ
	|					ВТОперативныйПланЗадач.Задача
	|				ИЗ
	|					ВТОперативныйПланЗадач КАК ВТОперативныйПланЗадач)
	|	// Т_екстОтборЗадачиНуженОтклик
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТОперативныйПланЗадач.Исполнитель КАК Исполнитель,
	|	ВТОперативныйПланЗадач.Задача,
	|	ВТОперативныйПланЗадач.Порядок КАК Порядок,
	|	ВТОперативныйПланЗадач.ЗадачаПредставление КАК Представление,
	|	ВТОперативныйПланЗадач.Исполнитель.Наименование КАК ИсполнительНаименование,
	|	ПРЕДСТАВЛЕНИЕ(ВТОперативныйПланЗадач.Исполнитель) КАК ИсполнительПредставление,
	|	ВТОперативныйПланЗадач.Ответственный,
	|	ПРЕДСТАВЛЕНИЕ(ВТОперативныйПланЗадач.Ответственный) КАК ОтветственныйПредставление,
	|	ВТОперативныйПланЗадач.Суть,
	|	ВТОперативныйПланЗадач.Подробности,
	|	ВТОперативныйПланЗадач.Состояние,
	|	ВТОперативныйПланЗадач.ЗадачаИсполнитель,
	|	ВТОперативныйПланЗадач.ЗадачаИсполнительОтклик
	|ИЗ
	|	ВТОперативныйПланЗадач КАК ВТОперативныйПланЗадач
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВТЗадачиНуженОтклик.Исполнитель,
	|	ВТЗадачиНуженОтклик.Задача,
	|	ВТЗадачиНуженОтклик.Порядок,
	|	ВТЗадачиНуженОтклик.Представление,
	|	ВТЗадачиНуженОтклик.Исполнитель.Наименование,
	|	ПРЕДСТАВЛЕНИЕ(ВТЗадачиНуженОтклик.Исполнитель),
	|	ВТЗадачиНуженОтклик.Ответственный,
	|	ПРЕДСТАВЛЕНИЕ(ВТЗадачиНуженОтклик.Ответственный),
	|	ВТЗадачиНуженОтклик.Суть,
	|	ВТЗадачиНуженОтклик.Подробности,
	|	ВТЗадачиНуженОтклик.Состояние,
	|	ВТЗадачиНуженОтклик.ЗадачаИсполнитель,
	|	ВТЗадачиНуженОтклик.ЗадачаИсполнительОтклик
	|ИЗ
	|	ВТЗадачиНуженОтклик КАК ВТЗадачиНуженОтклик
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	ВТЗадачиПрочие.Исполнитель,
	|	ВТЗадачиПрочие.Задача,
	|	ВТЗадачиПрочие.Порядок,
	|	ВТЗадачиПрочие.Представление,
	|	ВТЗадачиПрочие.Исполнитель.Наименование,
	|	ПРЕДСТАВЛЕНИЕ(ВТЗадачиПрочие.Исполнитель),
	|	ВТЗадачиПрочие.Ответственный,
	|	ПРЕДСТАВЛЕНИЕ(ВТЗадачиПрочие.Ответственный),
	|	ВТЗадачиПрочие.Суть,
	|	ВТЗадачиПрочие.Подробности,
	|	ВТЗадачиПрочие.Состояние,
	|	ВТЗадачиПрочие.ЗадачаИсполнитель,
	|	ВТЗадачиПрочие.ЗадачаИсполнительОтклик
	|ИЗ
	|	ВТЗадачиПрочие КАК ВТЗадачиПрочие
	|
	|УПОРЯДОЧИТЬ ПО
	|	ИсполнительНаименование,
	|	Порядок
	|ИТОГИ ПО
	|	Исполнитель
	|АВТОУПОРЯДОЧИВАНИЕ";

	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//ТекстОтборОперативныйПланЗадач", ТекстОтборОперативныйПланЗадач);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//ТекстОтборЗадачиНуженОтклик", ТекстОтборЗадачиНуженОтклик);
	
	Запрос.Текст = ТекстЗапроса;
	Результат = Запрос.Выполнить();
	
	ВыборкаИсполнитель = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ТаблицаЗадач = Новый ТаблицаЗначений; // таблица, столбцы которой - исполнители
	СоответствиеКолонок = Новый Соответствие;
	НомерКолонки = 1;
	Пока ВыборкаИсполнитель.Следующий() Цикл
		ОбластьИсполнитель.Параметры.Заполнить(ВыборкаИсполнитель);
		ТабДок.Присоединить(ОбластьИсполнитель);
		
		ТаблицаЗадач.Колонки.Добавить("ИСП" + НомерКолонки, , ВыборкаИсполнитель.ИсполнительПредставление);
		СоответствиеКолонок.Вставить(ВыборкаИсполнитель.Исполнитель, "ИСП" + НомерКолонки);
		НомерКолонки = НомерКолонки + 1;
	КонецЦикла;
	
	ТабДок.ФиксацияСверху = 3;
	           
	ВыборкаИсполнитель.Сбросить();
	Пока ВыборкаИсполнитель.Следующий() Цикл
		ВыборкаЗадача = ВыборкаИсполнитель.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		КоличествоЗадач = ВыборкаЗадача.Количество();
		КоличествоСтрок = ТаблицаЗадач.Количество();
		Если КоличествоЗадач > КоличествоСтрок Тогда 
			// создать строки таблицы задач
			Для К = КоличествоСтрок По КоличествоЗадач - 1 Цикл
				ТаблицаЗадач.Добавить();
		 	КонецЦикла;
		КонецЕсли;
			
		Колонка = СоответствиеКолонок.Получить(ВыборкаИсполнитель.Исполнитель);
		НомерСтроки = 0;
		
		Пока ВыборкаЗадача.Следующий() Цикл
			СтруктураЗадачи = Новый Структура("Задача, Ответственный, Исполнитель, Суть, Подробности, Состояние, ЗадачаИсполнитель, ЗадачаИсполнительОтклик");
			ЗаполнитьЗначенияСвойств(СтруктураЗадачи, ВыборкаЗадача);
			ТаблицаЗадач[НомерСтроки][Колонка] = СтруктураЗадачи;
			НомерСтроки = НомерСтроки + 1;
		КонецЦикла;
	КонецЦикла;
	
	ЦветНуженОтклик = Новый Цвет(230, 200, 230);
	ТаблицаЗадачКолонки = ТаблицаЗадач.Колонки;
	Для Каждого ТекСтрока Из ТаблицаЗадач Цикл
		ВыводитьСНовойСтроки = Истина;
		Для Каждого ТекКолонка Из ТаблицаЗадачКолонки Цикл
			СтруктураЗадачи = ТекСтрока[ТекКолонка.Имя];
			Если СтруктураЗадачи <> Неопределено Тогда
				ОбластьЗадача.Параметры.Заполнить(СтруктураЗадачи);
				
				ОкрашиватьЗаголовок = Ложь;
				ЦветФона = Общий.обПолучитьЦветСостоянияЗадачи(СтруктураЗадачи.Состояние, СтруктураЗадачи.Исполнитель, СтруктураЗадачи.ЗадачаИсполнительОтклик);
				Если СтруктураЗадачи.Состояние = Справочники.СостоянияЗадач.НуженОтклик Тогда 
					Если СтруктураЗадачи.Исполнитель = СтруктураЗадачи.ЗадачаИсполнительОтклик Тогда 
						ОкрашиватьЗаголовок = Истина;
					Иначе
						ОбластьЗадача.Параметры.Состояние = "Ожидание отклика";
					КонецЕсли;
				КонецЕсли;
				
				//Если СтруктураЗадачи.Состояние = Справочники.СостоянияЗадач.Назначена Тогда 
				//	ЦветФона = WebЦвета.Белый;
				//ИначеЕсли СтруктураЗадачи.Состояние = Справочники.СостоянияЗадач.ВРаботе Тогда 
				//	ЦветФона = WebЦвета.Желтый;
				//ИначеЕсли СтруктураЗадачи.Состояние = Справочники.СостоянияЗадач.НуженОтклик Тогда 
				//	ЦветФона = WebЦвета.Фиолетовый;
				//	Если СтруктураЗадачи.Исполнитель = СтруктураЗадачи.ЗадачаИсполнительОтклик Тогда 
				//		ОкрашиватьЗаголовок = Истина;
				//	Иначе
				//		ЦветФона = ЦветНуженОтклик;
				//		ОбластьЗадача.Параметры.Состояние = "Ожидание отклика";
				//	КонецЕсли;
				//ИначеЕсли СтруктураЗадачи.Состояние = Справочники.СостоянияЗадач.Отработана Тогда 
				//	ЦветФона = WebЦвета.СветлоЗеленый;
				//ИначеЕсли СтруктураЗадачи.Состояние = Справочники.СостоянияЗадач.Закрыта Тогда 
				//	ЦветФона = WebЦвета.СеребристоСерый;
				//Иначе 
				//	ЦветФона = WebЦвета.Белый;
				//КонецЕсли;
				
				ОбластьВыводаЗадачи = ОбластьЗадача.Область("R2C2:R5C3");
				ОбластьВыводаЗадачи.ЦветФона = ЦветФона;
				
				Если ОкрашиватьЗаголовок Тогда 
					ОбластьВыводаЗадачи = ОбластьЗадача.Область("R4C3:R4C3");
					ОбластьВыводаЗадачи.ЦветФона = WebЦвета.ОранжевоКрасный;
				КонецЕсли;
				
				ОбластьПримечание = ОбластьЗадача.Область("R5C2:R5C2");
				ОбластьПримечание.Примечание.Текст = РазбитьСтроку(СтруктураЗадачи.Подробности, 100);             

				ТекОбласть = ОбластьЗадача;
			Иначе
				ТекОбласть = ОбластьПустаяЗадача;
			КонецЕсли;
			Если ВыводитьСНовойСтроки Тогда
				ВыводитьСНовойСтроки = Ложь;
				ТабДок.Вывести(ТекОбласть);
			Иначе
				ТабДок.Присоединить(ТекОбласть);
			КонецЕсли;
		КонецЦикла;
		//ТабДок.Вывести(ОбластьРазделитель);
	КонецЦикла;

КонецПроцедуры

Процедура СформироватьДоскуЗадач(ТабДок) Экспорт

	Макет = ПолучитьМакет("ДоскаЗадач");
	ОбластьСостояние = Макет.ПолучитьОбласть("ОбластьСостояниеСтрока|ОбластьСостояниеКолонка");
	ОбластьЗадача = Макет.ПолучитьОбласть("ЗадачаСтрока|ОбластьСостояниеКолонка");
	ОбластьРазделитель = Макет.ПолучитьОбласть("ОбластьРазделитель");
	ОбластьПустаяЗадача = Макет.ПолучитьОбласть("ПустаяЗадачаСтрока|ОбластьСостояниеКолонка");
	ТабДок.Очистить();

	ТабДок.Вывести(ОбластьРазделитель); 
	
	Запрос = Новый Запрос;
	ТекстОтборОперативныйПланЗадач = "";
	ТекстОтборЗадачиНуженОтклик = "";
	//Если СписокПользователей.Количество() > 0 Тогда
	//	ТекстОтборОперативныйПланЗадач = " И ОперативныйПланЗадач.Задача.Исполнитель В (&СписокПользователей) ";
	//	ТекстОтборЗадачиНуженОтклик = " И ДокЗадача.ИсполнительОтклик В (&СписокПользователей) ";
	//	Запрос.УстановитьПараметр("СписокПользователей", СписокПользователей.ВыгрузитьКолонку("Пользователь"));
	//КонецЕсли;
	
	Если ЗначениеЗаполнено(Спринт) Тогда
		ТекстОтборПоСпринту = " И Задача.Ссылка В (&СписокЗадачСпринта) ";
		Запрос.УстановитьПараметр("СписокЗадачСпринта", Спринт.СоставСпринта.ВыгрузитьКолонку("Задача"));
	КонецЕсли;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	Задача.Номер КАК Номер,
	|	Задача.Ссылка КАК Задача,
	|	Задача.Ссылка.Представление КАК ЗадачаПредставление,
	|	Задача.Исполнитель КАК Исполнитель,
	|	Задача.Ответственный КАК Ответственный,
	|	Задача.Суть КАК Суть,
	|	Задача.Подробности КАК Подробности,
	|	Задача.СостояниеЗадачи КАК Состояние,
	|	Задача.Исполнитель КАК ЗадачаИсполнитель,
	|	Задача.ИсполнительОтклик КАК ЗадачаИсполнительОтклик
	|ПОМЕСТИТЬ ВТОперативныйПланЗадач
	|ИЗ
	|	Документ.Задача КАК Задача
	|ГДЕ
	|	Задача.Статус <> ЗНАЧЕНИЕ(Перечисление.СтатусЗадачи.Отменена) //ТекстОтборПоСпринту 
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТОперативныйПланЗадач.Номер,
	|	ВТОперативныйПланЗадач.Задача,
	|	ВТОперативныйПланЗадач.ЗадачаПредставление КАК Представление,
	|	ВТОперативныйПланЗадач.Исполнитель КАК Исполнитель,
	|	ВТОперативныйПланЗадач.Исполнитель.Наименование КАК ИсполнительНаименование,
	|	ПРЕДСТАВЛЕНИЕ(ВТОперативныйПланЗадач.Исполнитель) КАК ИсполнительПредставление,
	|	ВТОперативныйПланЗадач.Ответственный,
	|	ПРЕДСТАВЛЕНИЕ(ВТОперативныйПланЗадач.Ответственный) КАК ОтветственныйПредставление,
	|	ВТОперативныйПланЗадач.Суть,
	|	ВТОперативныйПланЗадач.Подробности,
	|	ВТОперативныйПланЗадач.Состояние КАК Состояние,
	|	ВТОперативныйПланЗадач.ЗадачаИсполнитель,
	|	ВТОперативныйПланЗадач.ЗадачаИсполнительОтклик
	|ИЗ
	|	ВТОперативныйПланЗадач КАК ВТОперативныйПланЗадач
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВТОперативныйПланЗадач.Состояние,
	|	ВТОперативныйПланЗадач.Номер
	|ИТОГИ ПО
	|	Состояние
	|АВТОУПОРЯДОЧИВАНИЕ";

	//ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//ТекстОтборОперативныйПланЗадач", ТекстОтборОперативныйПланЗадач);
	//ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//ТекстОтборЗадачиНуженОтклик", ТекстОтборЗадачиНуженОтклик);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//ТекстОтборПоСпринту", ТекстОтборПоСпринту);
	
	Запрос.Текст = ТекстЗапроса;
	
	Результат = Запрос.Выполнить();
	
	
	
	
	МассивСостояний = Новый Массив;
	//МассивСостояний.Добавить(Справочники.СостоянияЗадач.Новая);
	МассивСостояний.Добавить(Справочники.СостоянияЗадач.Назначена);
	МассивСостояний.Добавить(Справочники.СостоянияЗадач.НуженОтклик);
	МассивСостояний.Добавить(Справочники.СостоянияЗадач.ВРаботе);
	МассивСостояний.Добавить(Справочники.СостоянияЗадач.Отработана);
	МассивСостояний.Добавить(Справочники.СостоянияЗадач.Закрыта);
	
	
	ТаблицаЗадач = Новый ТаблицаЗначений; // таблица, столбцы которой - исполнители
	СоответствиеКолонок = Новый Соответствие;
	НомерКолонки = 1;
	Для Каждого ТекСостояние Из МассивСостояний Цикл
		ОбластьСостояние.Параметры.Состояние = ТекСостояние;
		ТабДок.Присоединить(ОбластьСостояние);
		
		ТаблицаЗадач.Колонки.Добавить("ИСП" + НомерКолонки, , ТекСостояние);
		СоответствиеКолонок.Вставить(ТекСостояние, "ИСП" + НомерКолонки);
		НомерКолонки = НомерКолонки + 1;
	КонецЦикла;
	
	ТабДок.ФиксацияСверху = 3;
	           
	ВыборкаСостояние = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаСостояние.Следующий() Цикл
		ВыборкаЗадача = ВыборкаСостояние.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		КоличествоЗадач = ВыборкаЗадача.Количество();
		КоличествоСтрок = ТаблицаЗадач.Количество();
		Если КоличествоЗадач > КоличествоСтрок Тогда 
			// создать строки таблицы задач
			Для К = КоличествоСтрок По КоличествоЗадач - 1 Цикл
				ТаблицаЗадач.Добавить();
		 	КонецЦикла;
		КонецЕсли;
			
		Колонка = СоответствиеКолонок.Получить(ВыборкаСостояние.Состояние);
		НомерСтроки = 0;
		
		Пока ВыборкаЗадача.Следующий() Цикл
			СтруктураЗадачи = Новый Структура("Задача, Ответственный, Исполнитель, Суть, Подробности, Состояние, ЗадачаИсполнитель, ЗадачаИсполнительОтклик");
			ЗаполнитьЗначенияСвойств(СтруктураЗадачи, ВыборкаЗадача);
			ТаблицаЗадач[НомерСтроки][Колонка] = СтруктураЗадачи;
			НомерСтроки = НомерСтроки + 1;
		КонецЦикла;
	КонецЦикла;
	
	ЦветНуженОтклик = Новый Цвет(230, 200, 230);
	ТаблицаЗадачКолонки = ТаблицаЗадач.Колонки;
	Для Каждого ТекСтрока Из ТаблицаЗадач Цикл
		ВыводитьСНовойСтроки = Истина;
		Для Каждого ТекКолонка Из ТаблицаЗадачКолонки Цикл
			СтруктураЗадачи = ТекСтрока[ТекКолонка.Имя];
			Если СтруктураЗадачи <> Неопределено Тогда
				ОбластьЗадача.Параметры.Заполнить(СтруктураЗадачи);
				
				ОкрашиватьЗаголовок = Ложь;
				ЦветФона = Общий.обПолучитьЦветСостоянияЗадачи(СтруктураЗадачи.Состояние, СтруктураЗадачи.Исполнитель, СтруктураЗадачи.ЗадачаИсполнительОтклик);
				Если СтруктураЗадачи.Состояние = Справочники.СостоянияЗадач.НуженОтклик Тогда 
					Если СтруктураЗадачи.Исполнитель = СтруктураЗадачи.ЗадачаИсполнительОтклик Тогда 
						ОкрашиватьЗаголовок = Истина;
					Иначе
						ОбластьЗадача.Параметры.Состояние = "Ожидание отклика";
					КонецЕсли;
				КонецЕсли;
				
				//Если СтруктураЗадачи.Состояние = Справочники.СостоянияЗадач.Назначена Тогда 
				//	ЦветФона = WebЦвета.Белый;
				//ИначеЕсли СтруктураЗадачи.Состояние = Справочники.СостоянияЗадач.ВРаботе Тогда 
				//	ЦветФона = WebЦвета.Желтый;
				//ИначеЕсли СтруктураЗадачи.Состояние = Справочники.СостоянияЗадач.НуженОтклик Тогда 
				//	ЦветФона = WebЦвета.Фиолетовый;
				//	Если СтруктураЗадачи.Исполнитель = СтруктураЗадачи.ЗадачаИсполнительОтклик Тогда 
				//		ОкрашиватьЗаголовок = Истина;
				//	Иначе
				//		ЦветФона = ЦветНуженОтклик;
				//		ОбластьЗадача.Параметры.Состояние = "Ожидание отклика";
				//	КонецЕсли;
				//ИначеЕсли СтруктураЗадачи.Состояние = Справочники.СостоянияЗадач.Отработана Тогда 
				//	ЦветФона = WebЦвета.СветлоЗеленый;
				//ИначеЕсли СтруктураЗадачи.Состояние = Справочники.СостоянияЗадач.Закрыта Тогда 
				//	ЦветФона = WebЦвета.СеребристоСерый;
				//Иначе 
				//	ЦветФона = WebЦвета.Белый;
				//КонецЕсли;
				
				ОбластьВыводаЗадачи = ОбластьЗадача.Область("R2C2:R6C3");
				ОбластьВыводаЗадачи.ЦветФона = ЦветФона;
				
				Если ОкрашиватьЗаголовок Тогда 
					ОбластьВыводаЗадачи = ОбластьЗадача.Область("R5C3:R5C3");
					ОбластьВыводаЗадачи.ЦветФона = WebЦвета.ОранжевоКрасный;
				КонецЕсли;
				
				ОбластьПримечание = ОбластьЗадача.Область("R6C2:R6C2");
				ОбластьПримечание.Примечание.Текст = РазбитьСтроку(СтруктураЗадачи.Подробности, 100);             

				ТекОбласть = ОбластьЗадача;
			Иначе
				ТекОбласть = ОбластьПустаяЗадача;
			КонецЕсли;
			Если ВыводитьСНовойСтроки Тогда
				ВыводитьСНовойСтроки = Ложь;
				ТабДок.Вывести(ТекОбласть);
			Иначе
				ТабДок.Присоединить(ТекОбласть);
			КонецЕсли;
		КонецЦикла;
		//ТабДок.Вывести(ОбластьРазделитель);
	КонецЦикла;

КонецПроцедуры
