﻿
Функция ЭтоПользователь() Экспорт
	Возврат Не РольДоступна("Администратор");
КонецФункции

Функция ТекущийПользователь() Экспорт
	Возврат ПараметрыСеанса.ТекущийПользователь;
КонецФункции

Процедура СоздатьПользователяБД(Имя, ВнутрТел, СотТел, Аська, Почта, Роль, Комментарий) Экспорт
	Если ПользователиИнформационнойБазы.НайтиПоИмени(Имя) <> Неопределено Тогда
		Сообщить("Пользователь " + Имя + " уже существует!");
		Возврат;
	КонецЕсли;

	МДРоль = Метаданные.Роли.Найти(Роль);
	Если МДРоль = Неопределено Тогда
		Сообщить("Роль " + Роль + " не найдена!");
		Возврат;
	КонецЕсли;

	НачатьТранзакцию();

	ПИБ = ПользователиИнформационнойБазы.СоздатьПользователя();
	ПИБ.Имя = Имя;
	ПИБ.ПолноеИмя = Имя;
	ПИБ.ПоказыватьВСпискеВыбора = Истина;
	ПИБ.Роли.Добавить(МДРоль);
	ПИБ.Записать();

	Если Справочники.Пользователи.НайтиПоНаименованию(Имя).Пустая() Тогда
		НовЭл = Справочники.Пользователи.СоздатьЭлемент();
		НовЭл.Наименование = Имя;
		НовЭл.ТелефонВнутренний = ВнутрТел;
		НовЭл.ТелефонСотовый = СотТел;
		НовЭл.ICQ = Аська;
		НовЭл.ЭлПочта = Почта;
		НовЭл.Комментарий = Комментарий;
		НовЭл.Записать();
	КонецЕсли;

	Сообщить("Создан новый пользователь " + Имя);

	ЗафиксироватьТранзакцию();

КонецПроцедуры


Функция офПолучитьНовыйIDСтроки(ТаблицаДанных, ИмяКолонки = "КлючСтроки") Экспорт
	
	НовыйКлючСтроки = Новый УникальныйИдентификатор;
	Пока ТаблицаДанных.Найти(НовыйКлючСтроки, ИмяКолонки) <> Неопределено Цикл
		НовыйКлючСтроки = Новый УникальныйИдентификатор;
	КонецЦикла;
	
	Возврат НовыйКлючСтроки;
		               
КонецФункции

Процедура офОткрытьФайлИзХранилища(ИмяФайла, Хранилище) Экспорт
	
	Попытка
		ВременныйФайл = Строка(КаталогВременныхФайлов())+СокрЛП(Строка(ИмяФайла));
		Хранилище.Получить().Записать(ВременныйФайл);
		ЗапуститьПриложение(ВременныйФайл, ,Истина);
		УдалитьФайлы(ВременныйФайл);
	Исключение
		Сообщить("Общий модуль <допОбщиеФункции>: Ошибка при выполнении метода <ОткрытьФайлИзХранилища> - " + ОписаниеОшибки(), СтатусСообщения.Важное);
	КонецПопытки;
	
КонецПроцедуры

Функция офОпределитьТекущегоПользователя() Экспорт

	Если ПустаяСтрока(ИмяПользователя()) Тогда
		ИмяПользователя           = "Администратор";
		ПолноеИмяПользователя     = "Администратор информационной базы";
	Иначе
		ИмяПользователя           = ИмяПользователя();
		Если ПустаяСтрока(ПолноеИмяПользователя()) Тогда
			ПолноеИмяПользователя = ИмяПользователя;
		Иначе
			ПолноеИмяПользователя = ПолноеИмяПользователя();
		КонецЕсли;
	КонецЕсли;
	
	// Попытаемся найти этого пользователя.
	Пользователь = Справочники.Пользователи.НайтиПоКоду(ИмяПользователя);
	Если обЗначениеНеЗаполнено(Пользователь) Тогда
		// Пользователь входит в систему первый раз
		#Если Клиент Тогда
			Предупреждение("Зарегистрирован первый вход в систему для пользователя 
					   |"""+ИмяПользователя + """", 5);
		#Иначе	
			Сообщить("Зарегистрирован первый вход в систему для пользователя "+ИмяПользователя,СтатусСообщения.Важное);
		#КонецЕсли
		ОбъектПользователь = Справочники.Пользователи.СоздатьЭлемент();
		ОбъектПользователь.Код           = ИмяПользователя;
		ОбъектПользователь.Наименование  = ПолноеИмяПользователя;
		ОбъектПользователь.РольПоУмолчанию  = Перечисления.РолиПользователей.АвторЗадач;
		ОбъектПользователь.ОбменДанными.Загрузка = Истина;
		ОбъектПользователь.Записать();
		Пользователь = ОбъектПользователь.Ссылка;
	КонецЕсли;

	Возврат Пользователь;
КонецФункции // обОпределитьТекущегоПользователя()

Функция обЗначениеНеЗаполнено(Значение) Экспорт

	Результат = Ложь;
	
	Попытка
		Результат = Не ЗначениеЗаполнено(Значение)	
	Исключение // Мутабельные типы (Объекты)
		Результат = Ложь
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции // обЗначениеНеЗаполнено()

Функция офПолучитьНовыйПорядокЗадачи(ТекущаяЗадача, СледующаяЗадача) Экспорт 
	
	НовыйПорядокЗадачи = Неопределено;
	
	Если СледующаяЗадача = Неопределено Тогда 
		//Добавим задачу в конец
		НовыйПорядокЗадачи = офПолучитьПорядокНовойЗадачи();
	Иначе
	
		МенеджерЗаписи = РегистрыСведений.ОперативныйПланЗадач.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Задача = СледующаяЗадача;
		МенеджерЗаписи.Прочитать();
		СледующаяЗадачаПорядок = 0;
		Если МенеджерЗаписи.Выбран() тогда
			СледующаяЗадачаПорядок = МенеджерЗаписи.Порядок;
		КонецЕсли;
		
		// получим предыдущую задачу
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ОперативныйПланЗадач.Задача КАК Задача,
		|	ОперативныйПланЗадач.Порядок КАК Порядок
		|ИЗ
		|	РегистрСведений.ОперативныйПланЗадач КАК ОперативныйПланЗадач
		|ГДЕ
		|	ОперативныйПланЗадач.Порядок < &Порядок
		|	И ОперативныйПланЗадач.Задача.ПометкаУдаления = ЛОЖЬ
		|	И ОперативныйПланЗадач.Задача.СостояниеЗадачи <> ЗНАЧЕНИЕ(Справочник.СостоянияЗадач.Закрыта)
		|
		|УПОРЯДОЧИТЬ ПО
		|	ОперативныйПланЗадач.Порядок УБЫВ";
		
		Запрос.УстановитьПараметр("Порядок", СледующаяЗадачаПорядок);
		
		Результат = Запрос.Выполнить().Выбрать();
		ПредыдущаяЗадачаПорядок = 0;
		Если Результат.Следующий() Тогда 
			ПредыдущаяЗадачаПорядок = Результат.Порядок;
		КонецЕсли;
		
		ТекущаяЗадачаПорядокНовый = Цел((СледующаяЗадачаПорядок + ПредыдущаяЗадачаПорядок) / 2);
		
		Если  ПредыдущаяЗадачаПорядок < ТекущаяЗадачаПорядокНовый И ТекущаяЗадачаПорядокНовый < СледующаяЗадачаПорядок Тогда 
			НовыйПорядокЗадачи = ТекущаяЗадачаПорядокНовый;
		КонецЕсли;
	КонецЕсли;
	
	Возврат НовыйПорядокЗадачи;
		
КонецФункции

Процедура офОбновитьПорядокЗадач() Экспорт 
	
	НаборЗаписейОперативныйПланЗадач = РегистрыСведений.ОперативныйПланЗадач.СоздатьНаборЗаписей();
	НаборЗаписейОперативныйПланЗадач.Прочитать();
	
	ТаблицаЗадач = НаборЗаписейОперативныйПланЗадач.Выгрузить();
	ТаблицаЗадач.Сортировать("Порядок");
	
	//Запрос = Новый Запрос;
	//Запрос.Текст = 
	//"ВЫБРАТЬ
	//|	Задача.Ссылка КАК Задача
	//|ИЗ
	//|	Документ.Задача КАК Задача
	//|ГДЕ
	//|	Задача.СостояниеЗадачи <> ЗНАЧЕНИЕ(Справочник.СостоянияЗадач.Закрыта)
	//|	И Задача.ПометкаУдаления = ЛОЖЬ
	//|
	//|ДЛЯ ИЗМЕНЕНИЯ
	//|	Документ.Задача
	//|
	//|УПОРЯДОЧИТЬ ПО
	//|	Задача.Порядок";
	//
	//ТаблицаЗадач = Запрос.Выполнить().Выгрузить();
	ШагПорядкаЗадач = Константы.ШагПорядкаЗадач.Получить();
	НовыйПорядок = ШагПорядкаЗадач;
	Кол = ТаблицаЗадач.Количество();
	
	НачатьТранзакцию();
	Для Каждого ТекСтрока Из ТаблицаЗадач Цикл
		ТекСтрока.Порядок = НовыйПорядок;
		НовыйПорядок = НовыйПорядок + ШагПорядкаЗадач;
	КонецЦикла;
	Попытка
		НаборЗаписейОперативныйПланЗадач.Загрузить(ТаблицаЗадач);
		НаборЗаписейОперативныйПланЗадач.Записать();
	Исключение
		//ОписаниеОшибки()
	КонецПопытки;
	ЗафиксироватьТранзакцию();
	
	
КонецПроцедуры

Функция офПолучитьПорядокНовойЗадачи() Экспорт
	
	Порядок = 0;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	МАКСИМУМ(ОперативныйПланЗадач.Порядок)+ "+Константы.ШагПорядкаЗадач.Получить()+" КАК Порядок
	|ИЗ
	|	РегистрСведений.ОперативныйПланЗадач КАК ОперативныйПланЗадач
	|ГДЕ
	|	ОперативныйПланЗадач.Задача.СостояниеЗадачи <> ЗНАЧЕНИЕ(Справочник.СостоянияЗадач.Закрыта)";
	
	Результат = Запрос.Выполнить().Выбрать();
	Если Результат.Следующий() Тогда 
		Порядок = Результат.Порядок;
	КонецЕсли;
	
	Возврат Порядок;
		
КонецФункции

Процедура офИзменитьПометкуЗадач(ПометкаУдаления) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Задача.Ссылка
	|ИЗ
	|	Документ.Задача КАК Задача";
	
	Результат = Запрос.Выполнить().Выбрать();
	
	Пока Результат.Следующий() Цикл
		ЗадачаОбъект = Результат.Ссылка.ПолучитьОбъект();
		//ЗадачаОбъект = Документы.Задача.СоздатьДокумент();
		ЗадачаОбъект.УстановитьПометкуУдаления(ПометкаУдаления);
	КонецЦикла;
		
КонецПроцедуры

Функция офПолучитьНовыйIDКомментария() Экспорт 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	МАКСИМУМ(Коментарии.ID) КАК ID
	|ИЗ
	|	РегистрСведений.Коментарии КАК Коментарии";
	
	Результат = Запрос.Выполнить().Выбрать();
	
	Если Результат.Следующий() Тогда 
		Если Результат.ID <> Неопределено И Результат.ID <> Null Тогда
			НовыйID = Результат.ID + 1;
		Иначе 
			НовыйID = 1;
		КонецЕсли;
	Иначе 
		НовыйID = 1;
	КонецЕсли;
 
    Возврат НовыйID;
		
КонецФункции

Функция офСохранитьКартинкуИзБуфераНаДиск() Экспорт
	
	КаталогВФ = КаталогВременныхФайлов();
	ИмяФайлаПрограммы = КаталогВФ + "CbToJPEG.exe";
	ДвоичныеДанныеПрограммы = ПолучитьОбщийМакет("CbToJPEG");
	ДвоичныеДанныеПрограммы.Записать(ИмяФайлаПрограммы);
	ФайлПрограммы = Новый Файл(ИмяФайлаПрограммы);
	
	ИмяФайлаКартинки = КаталогВФ + Формат(ТекущаяДата(), "ДФ=yyyyMMddHHmmss") + "_tmp.JPG";
	
	СтрокаЗапуска = """"+ФайлПрограммы.ПолноеИмя+""" """+ИмяФайлаКартинки+"""";
	
	WshShell = Новый COMОбъект("WScript.Shell");
	WshShell.Run(СтрокаЗапуска, 0, Истина);
	
	УдалитьФайлы(ИмяФайлаПрограммы);
	
	ФайлКартинки = Новый Файл(ИмяФайлаКартинки);
	Если Не ФайлКартинки.Существует() Тогда 
		ИмяФайлаКартинки = Неопределено;
	КонецЕсли;
	
	Возврат ИмяФайлаКартинки;
		
КонецФункции

Функция офПолучитьСообщениеОБлокировкеОбъекта(Сообщение) Экспорт 

	ДанныеОСеансе = СокрЛП(Сред(Сообщение, Найти(Сообщение, "компьютер: ")));
	
	ДанныеОСеансе = СтрЗаменить(ДанныеОСеансе, "компьютер: ", Символы.ПС + "Компьютер: ");
	ДанныеОСеансе = СтрЗаменить(ДанныеОСеансе, ", пользователь: ", Символы.ПС + "Пользователь: ");
	ДанныеОСеансе = СтрЗаменить(ДанныеОСеансе, ", сеанс: ", Символы.ПС + "Сеанс: ");
	ДанныеОСеансе = СтрЗаменить(ДанныеОСеансе, ", начат: ", Символы.ПС + "Начат: ");
	ДанныеОСеансе = СтрЗаменить(ДанныеОСеансе, ", приложение: ", Символы.ПС + "Приложение: ");
	
	Возврат ДанныеОСеансе;
	
КонецФункции

Процедура обСделатьЭлементыТолькоЧтение(Элемент) Экспорт
	
	Если Тип("УправляемаяФорма") = Тип(Элемент) Тогда
		Для каждого эл из Элемент.Элементы Цикл
			обСделатьЭлементыТолькоЧтение(эл);
		КонецЦикла;
	ИначеЕсли Тип("ГруппаФормы") = Тип(Элемент) Тогда
		// Ничего
	ИначеЕсли Тип("КнопкаФормы") = Тип(Элемент) Тогда
		Элемент.Доступность = Ложь;
	ИначеЕсли Тип("ПолеФормы")		= Тип(Элемент) Тогда
		Элемент.ТолькоПросмотр = Истина;
	ИначеЕсли Тип("ТаблицаФормы") = Тип(Элемент) Тогда
		Элемент.ТолькоПросмотр = Истина;
	Иначе
		Попытка
			Элемент.ТолькоПросмотр = Истина;
		Исключение
		КонецПопытки;
	КонецЕсли;
	
КонецПроцедуры

Функция обРазностьДат(Дата1, Дата2, ТипФункции) Экспорт
	
	РазнДат = Дата2 - Дата1;
	ВТипФункции = ВРег(ТипФункции);
	Если ВТипФункции = "СЕКУНДА" Тогда 
		Коэфф = 1;
	ИначеЕсли ВТипФункции = "МИНУТА" Тогда 
		Коэфф = 60;
	ИначеЕсли ВТипФункции = "ЧАС" Тогда 
		Коэфф = 3600;
	ИначеЕсли ВТипФункции = "ДЕНЬ" Тогда 
		Коэфф = 86400;
	Иначе
		Коэфф = 0;
		Запрос = Новый Запрос;
		ТекстЗапросаПоДатам = 
		"ВЫБРАТЬ
		|	РАЗНОСТЬДАТ(&Дата1, &Дата2, "+ТипФункции+") КАК Количество";
		
		Запрос.УстановитьПараметр("Дата1", Дата1);
		Запрос.УстановитьПараметр("Дата2", Дата2);
		Запрос.Текст = ТекстЗапросаПоДатам;
		Результат = Запрос.Выполнить().Выбрать();
		Если Результат.Следующий() Тогда 
			Результат = Результат.Количество;
		Иначе 
			Результат = Неопределено;
		КонецЕсли;
	КонецЕсли;
	
	Если Коэфф <> 0 Тогда 
		Результат = ЦЕЛ(РазнДат / Коэфф);
	КонецЕсли;
	
	Возврат Результат;
	

КонецФункции

Функция обПолучитьЦветСостоянияЗадачи(СостояниеЗадачи, Исполнитель, ЗадачаИсполнительОтклик) Экспорт 
	
	Если СостояниеЗадачи = Справочники.СостоянияЗадач.Назначена Тогда 
		ЦветФона = ЦветаСтиля.ЦветНазначена;
	ИначеЕсли СостояниеЗадачи = Справочники.СостоянияЗадач.ВРаботе Тогда 
		ЦветФона = ЦветаСтиля.ЦветВРаботе;
	ИначеЕсли СостояниеЗадачи = Справочники.СостоянияЗадач.НуженОтклик Тогда 
		Если Исполнитель = ЗадачаИсполнительОтклик Тогда 
			ЦветФона = ЦветаСтиля.ЦветНуженОткликЯркий;
		Иначе
			ЦветФона = 	ЦветаСтиля.ЦветНуженОткликБледный;
		КонецЕсли;
	ИначеЕсли СостояниеЗадачи = Справочники.СостоянияЗадач.Отработана Тогда 
		ЦветФона = ЦветаСтиля.ЦветОтработана;
	ИначеЕсли СостояниеЗадачи = Справочники.СостоянияЗадач.Закрыта Тогда 
		ЦветФона = ЦветаСтиля.ЦветЗакрыта;
	Иначе 
		ЦветФона = WebЦвета.Белый;
	КонецЕсли;
	
	Возврат ЦветФона;
		
КонецФункции

Функция обПолучитьУзорЗаливкиСостоянияЗадачи(СостояниеЗадачи, Исполнитель, ЗадачаИсполнительОтклик) Экспорт 
	
	Если СостояниеЗадачи = Справочники.СостоянияЗадач.Назначена Тогда 
		УзорЗаливки = ТипУзораТабличногоДокумента.БезУзора;
	ИначеЕсли СостояниеЗадачи = Справочники.СостоянияЗадач.ВРаботе Тогда 
		УзорЗаливки = ТипУзораТабличногоДокумента.Узор3;
	ИначеЕсли СостояниеЗадачи = Справочники.СостоянияЗадач.НуженОтклик Тогда 
		Если Исполнитель = ЗадачаИсполнительОтклик Тогда 
		УзорЗаливки = ТипУзораТабличногоДокумента.Узор5;
		Иначе
		УзорЗаливки = ТипУзораТабличногоДокумента.Узор5;
		КонецЕсли;
	ИначеЕсли СостояниеЗадачи = Справочники.СостоянияЗадач.Отработана Тогда 
		УзорЗаливки = ТипУзораТабличногоДокумента.Узор14;
	ИначеЕсли СостояниеЗадачи = Справочники.СостоянияЗадач.Закрыта Тогда 
		УзорЗаливки = ТипУзораТабличногоДокумента.Узор2;
	Иначе 
		УзорЗаливки = ТипУзораТабличногоДокумента.БезУзора;
	КонецЕсли;
	
	Возврат УзорЗаливки;
		
КонецФункции

Функция офПолучитьСписокПраздниковРФ(КалендарныйГод) Экспорт

	СписокПраздников = Новый СписокЗначений();
	Если КалендарныйГод < 1994 Тогда
		СписокПраздников.Добавить("0101", "Новый Год");
		СписокПраздников.Добавить("0102", "Новый Год");
		СписокПраздников.Добавить("0107", "Рождество Христово");
		СписокПраздников.Добавить("0308", "Международный женский день");
		СписокПраздников.Добавить("0501", "Праздник Весны и Труда");
		СписокПраздников.Добавить("0502", "Праздник Весны и Труда");
		СписокПраздников.Добавить("0509", "День Победы");
		СписокПраздников.Добавить("0612", "День принятия Декларации о государственном суверенитете Российской Федерации");
		СписокПраздников.Добавить("1107", "годовщина Великой Октябрьской социалистической революции");
	ИначеЕсли КалендарныйГод < 2002 Тогда
		СписокПраздников.Добавить("0101", "Новый Год");
		СписокПраздников.Добавить("0102", "Новый Год");
		СписокПраздников.Добавить("0107", "Рождество Христово");
		СписокПраздников.Добавить("0308", "Международный женский день");
		СписокПраздников.Добавить("0501", "Праздник Весны и Труда");
		СписокПраздников.Добавить("0502", "Праздник Весны и Труда");
		СписокПраздников.Добавить("0509", "День Победы");
		СписокПраздников.Добавить("0612", "День принятия Декларации о государственном суверенитете Российской Федерации");
		СписокПраздников.Добавить("1107", "годовщина Великой Октябрьской социалистической революции");
		СписокПраздников.Добавить("1212", "День Конституции РФ");
	ИначеЕсли КалендарныйГод < 2005 Тогда
		СписокПраздников.Добавить("0101", "Новый Год");
		СписокПраздников.Добавить("0102", "Новый Год");
		СписокПраздников.Добавить("0107", "Рождество Христово");
		СписокПраздников.Добавить("0223", "День защитника Отечества");
		СписокПраздников.Добавить("0308", "Международный женский день");
		СписокПраздников.Добавить("0501", "Праздник Весны и Труда");
		СписокПраздников.Добавить("0502", "Праздник Весны и Труда");
		СписокПраздников.Добавить("0509", "День Победы");
		СписокПраздников.Добавить("0612", "День России");
		СписокПраздников.Добавить("1107", "День согласия и примирения");
		СписокПраздников.Добавить("1212", "День Конституции РФ");
	ИначеЕсли КалендарныйГод < 2013 Тогда  // Федеральный закон от 29 декабря 2004 года № 201-ФЗ 
		СписокПраздников.Добавить("0101", "Новогодние каникулы");
		СписокПраздников.Добавить("0102", "Новогодние каникулы");
		СписокПраздников.Добавить("0103", "Новогодние каникулы");
		СписокПраздников.Добавить("0104", "Новогодние каникулы");
		СписокПраздников.Добавить("0105", "Новогодние каникулы");
		СписокПраздников.Добавить("0107", "Рождество Христово");
		СписокПраздников.Добавить("0223", "День защитника Отечества");
		СписокПраздников.Добавить("0308", "Международный женский день");
		СписокПраздников.Добавить("0501", "Праздник Весны и Труда");
		СписокПраздников.Добавить("0509", "День Победы");
		СписокПраздников.Добавить("0612", "День России");
		СписокПраздников.Добавить("1104", "День народного единства");
	Иначе // Федеральный закон от 23.04.2012 № 35-ФЗ
		СписокПраздников.Добавить("0101", "Новогодние каникулы");
		СписокПраздников.Добавить("0102", "Новогодние каникулы");
		СписокПраздников.Добавить("0103", "Новогодние каникулы");
		СписокПраздников.Добавить("0104", "Новогодние каникулы");
		СписокПраздников.Добавить("0105", "Новогодние каникулы");
		СписокПраздников.Добавить("0106", "Новогодние каникулы");
		СписокПраздников.Добавить("0107", "Рождество Христово");
		СписокПраздников.Добавить("0108", "Новогодние каникулы");
		СписокПраздников.Добавить("0223", "День защитника Отечества");
		СписокПраздников.Добавить("0310", "Международный женский день");
		СписокПраздников.Добавить("0501", "Праздник Весны и Труда");
		СписокПраздников.Добавить("0502", "Праздник Весны и Труда");
		СписокПраздников.Добавить("0509", "День Победы");
		СписокПраздников.Добавить("0612", "День России");
		СписокПраздников.Добавить("0613", "День России2");
		СписокПраздников.Добавить("1104", "День народного единства");	
	КонецЕсли;

	Возврат СписокПраздников

КонецФункции // ПолучитьСписокПраздниковРФ()

Функция офЭтоВыходнойДень(мДата) Экспорт
	
	СписокПраздников = офПолучитьСписокПраздниковРФ(Число(Формат(мДата, "ДФ=yyyy")));
	ЭтоВыходнойДень = Ложь;
	Если ДеньНедели(мДата) = 6 ИЛИ ДеньНедели(мДата) = 7 ИЛИ
		СписокПраздников.НайтиПоЗначению(Формат(мДата, "ДФ=MMdd")) <> Неопределено Тогда 
		ЭтоВыходнойДень = Истина;
	КонецЕсли;
	
	Возврат ЭтоВыходнойДень;
	
КонецФункции

Процедура офЗафиксироватьСобытиеВИстории(Объект, Адресат, Период = Неопределено) Экспорт 
	
	МенеджерЗаписи = РегистрыСведений.АдресацияНовостей.СоздатьМенеджерЗаписи();
	
	Если Период = Неопределено Тогда
		Период = ТекущаяДата();
	КонецЕсли;
	
	МенеджерЗаписи.Период		 	= Период;
	
	МенеджерЗаписи.Объект 			= Объект;
	МенеджерЗаписи.Адресат 			= Адресат;
	//МенеджерЗаписи.Пользователь 	= Пользователь;
	//
	//МенеджерЗаписи.СобытиеИстории	= СобытиеИстории;
	//МенеджерЗаписи.Подробности 		= Подробности;
	
	МенеджерЗаписи.Записать(Истина);
	
КонецПроцедуры

Процедура офЗафиксироватьСобытиеВПодробнойИстории(Объект, Пользователь, СобытиеИстории, Подробности, Период = Неопределено) Экспорт 
	
	МенеджерЗаписи = РегистрыСведений.ИсторияРаботыПодробности.СоздатьМенеджерЗаписи();
	
	Если Период = Неопределено Тогда
		Период = ТекущаяДата();
	КонецЕсли;
	
	МенеджерЗаписи.Период		 	= Период;
	
	МенеджерЗаписи.Объект 			= Объект;
	//МенеджерЗаписи.Адресат 			= Адресат;
	МенеджерЗаписи.Пользователь 	= Пользователь;
	
	МенеджерЗаписи.СобытиеИстории	= СобытиеИстории;
	МенеджерЗаписи.Подробности 		= Подробности;
	
	МенеджерЗаписи.Записать(Истина);
	
КонецПроцедуры

Функция офПолучитьСписокАдресатов(мОбъект, Пользователь)
	
	Если Ложь Тогда
		мОбъект = Документы.Задача.СоздатьДокумент();
	КонецЕсли;
	
	СписокАдресатов = Новый Массив;
	
	Если мОбъект.ОтслеживающиеПользователи.Количество() > 0 Тогда 
		ОтслеживающиеПользователи = мОбъект.ОтслеживающиеПользователи.Выгрузить();
		ОтслеживающиеПользователи.Свернуть("Пользователь");
		Для Каждого ТекСтрока Из ОтслеживающиеПользователи Цикл
			Если ТекСтрока.Пользователь <> Пользователь Тогда 
				СписокАдресатов.Добавить(ТекСтрока.Пользователь);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если мОбъект.Ответственный <> Пользователь И СписокАдресатов.Найти(мОбъект.Ответственный) = Неопределено Тогда 
		СписокАдресатов.Добавить(мОбъект.Ответственный);
	КонецЕсли;
	Если мОбъект.Исполнитель <> Пользователь И СписокАдресатов.Найти(мОбъект.Исполнитель) = Неопределено Тогда
		СписокАдресатов.Добавить(мОбъект.Исполнитель);
	КонецЕсли;
	Если мОбъект.СостояниеЗадачи = Справочники.СостоянияЗадач.НуженОтклик Тогда 
		Если мОбъект.ИсполнительОтклик <> Пользователь И СписокАдресатов.Найти(мОбъект.ИсполнительОтклик) = Неопределено Тогда
			СписокАдресатов.Добавить(мОбъект.ИсполнительОтклик);
		КонецЕсли;
	КонецЕсли;
	
	Возврат СписокАдресатов;
	
КонецФункции


Процедура офОбработатьСобытие(мОбъект, Пользователь, СобытиеИстории, Подробности = Неопределено, Период = Неопределено) Экспорт 
	
	Если Период = Неопределено Тогда
		Период = ТекущаяДата();
	КонецЕсли;
	
	Если ТипЗнч(мОбъект) = Тип("ДокументСсылка.Задача") Тогда
		Если СобытиеИстории = Справочники.СобытияИстории.ДобавлениеКомментария Тогда 
		ИначеЕсли СобытиеИстории = Справочники.СобытияИстории.СозданиеЗадачи Тогда                        
			
			Подробности = 	"Отв: " + СокрЛП(мОбъект.Ответственный) + ";" + Символы.ПС +
							"Исп: " + СокрЛП(мОбъект.Исполнитель) + ";" + Символы.ПС + 
							"Суть: " + СокрЛП(мОбъект.Суть);
			
			// 1. Получить список адресатов
			//СписокАдресатов = офПолучитьСписокАдресатов(мОбъект, Пользователь);
			//
			//// 2. Зафиксировать Событие В Истории для каждого адресата
			//Для Каждого ТекАдресат Из СписокАдресатов Цикл
			//	офЗафиксироватьСобытиеВИстории(мОбъект, ТекАдресат, Период);
			//КонецЦикла;
			//
			//// 3. Зафиксировать Событие В Подробной Истории
			//офЗафиксироватьСобытиеВПодробнойИстории(мОбъект, Пользователь, СобытиеИстории, Подробности, Период);
			//
		ИначеЕсли СобытиеИстории = Справочники.СобытияИстории.ИзмененияПолейЗадачи Тогда                        
			
			
			//// 1. Получим список адресатов
			//СписокАдресатов = офПолучитьСписокАдресатов(мОбъект, Пользователь);
			//
			//// 2. Зафиксировать Событие В Истории для каждого адресата
			//Для Каждого ТекАдресат Из СписокАдресатов Цикл
			//	офЗафиксироватьСобытиеВИстории(мОбъект, ТекАдресат, Период);
			//КонецЦикла;
			//// 3. Зафиксировать Событие В Подробной Истории
			//офЗафиксироватьСобытиеВПодробнойИстории(мОбъект, Пользователь, СобытиеИстории, Подробности, Период);
			//
		КонецЕсли;
		
		// 1. Получим список адресатов
		СписокАдресатов = офПолучитьСписокАдресатов(мОбъект, Пользователь);
		
		// 2. Зафиксировать Событие В Истории для каждого адресата
		Для Каждого ТекАдресат Из СписокАдресатов Цикл
			офЗафиксироватьСобытиеВИстории(мОбъект, ТекАдресат, Период);
		КонецЦикла;
		
		// 3. Зафиксировать Событие В Подробной Истории
		офЗафиксироватьСобытиеВПодробнойИстории(мОбъект, Пользователь, СобытиеИстории, Подробности, Период);
		
	КонецЕсли;
	
КонецПроцедуры

Функция офУдалитьЛидирующиеСимволы(Номер, ЛидСимвол = "0") Экспорт 
	
	мНомер = СокрЛП(Номер);
	
	Если ПустаяСтрока(мНомер) ИЛИ ПустаяСтрока(ЛидСимвол) Тогда 
		Возврат мНомер;
	КонецЕсли;
	
	Пока Лев(мНомер, 1) = ЛидСимвол И СтрДлина(мНомер) > 1 Цикл 
		мНомер = Сред(мНомер, 2);
	КонецЦикла;
	
	Возврат мНомер;
	
КонецФункции
	
Функция офПолучитьЗначениеРеквизита(Объект, ИмяРеквизита) Экспорт 
	
	Возврат Объект[ИмяРеквизита];
	
КонецФункции

Функция офВыполнитьКод(мТекст, П1 = Неопределено, П2 = Неопределено, П3 = Неопределено, П4 = Неопределено, П5 = Неопределено) Экспорт 
	
	Попытка
		Выполнить(мТекст);
		Рез = Истина;
	Исключение
	    Рез = ОписаниеОшибки();
	КонецПопытки;
	
	Возврат Рез;
	
КонецФункции

Функция офПолучитьПредставлениеСсылки(Ссылка) Экспорт
	
	ПредставлениеСсылки = "Задача № " + офУдалитьЛидирующиеСимволы(Ссылка.Номер) + " от " + Формат(Ссылка.Дата, "ДФ=dd.MM.yyyy");
	
	Возврат ПредставлениеСсылки;
		
КонецФункции

Функция офПолучитьТекстHTMLЗадачи(Задача)
	
	ТекстHTML = "";
	
	ЗаголовокСтатьи 	= СокрЛП(Задача.Суть);
	ТелоСтатьи 			= СокрЛП(Задача.ОписаниеРешения);
	СсылкаНаЗадачу 		= ПолучитьНавигационнуюСсылку(Задача);
	ПредставлениеЗадачи = офПолучитьПредставлениеСсылки(Задача);
	
	ТекстHTML = 
	"<H1>" + ЗаголовокСтатьи + "</H1>
	|<P>
	|<HR>
	|" + ТелоСтатьи + "   
	|<P></P>
	|<HR>
	|<H5>Дополнительная информация</H5>
	|<UL>
	|<LI> <A href=""" + СсылкаНаЗадачу + """><FONT size=2>" + ПредставлениеЗадачи + "</FONT></A> </LI>
	|</UL>";
	
	Возврат ТекстHTML;
	
КонецФункции


Процедура офЗаполнитьСтатьюПоЗадаче(Статья, Задача) Экспорт
	
	Статья.Автор = ТекущийПользователь();
	Статья.Наименование = Задача.Суть;
	Статья.Каталог = Задача.Модуль.КаталогПоУмолчанию;
	
	Статья.ТекстHTML = офПолучитьТекстHTMLЗадачи(Задача);
	
КонецПроцедуры

