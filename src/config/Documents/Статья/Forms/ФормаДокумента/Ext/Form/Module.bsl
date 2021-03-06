﻿// Сделано на основании обработки Батыркина Антона (batyrkin@mail.ru) http://infostart.ru/public/75313/

&НаКлиенте
Перем Документ, Адрес, ПредыдущийРежим;



// Общие процедуры и функции

&НаКлиенте
Процедура ВыборЦвета(Команда)
	
	//ИмяОткрываемойФормы = Лев(ЭтаФорма.ИмяФормы,СтрДлина(ЭтаФорма.ИмяФормы)-5)+ "ВыборЦвета";
	
	// Лучше перенести в общие формы.
	Цвет = ПолучитьФорму("РегистрСведений.ИсторияСтатей.Форма.ВыборЦвета").ОткрытьМодально(); // Насибуллин И.Р. 10.08.2017

	Если Цвет <> Неопределено Тогда
		Кнопка = Сред(Команда.Имя, 8);
		Если Документ.queryCommandSupported(Кнопка) Тогда
			Документ.execCommand(Кнопка, Ложь, "" + ПеревестиИз10(Цвет.Красный) + ПеревестиИз10(Цвет.Зеленый) + ПеревестиИз10(Цвет.Синий));
		КонецЕсли;
	КонецЕсли;
	ПоказатьРежимыКнопок();
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция сПолучитьОбщийМакет(ИмяМакета)
	Возврат ПолучитьОбщийМакет(ИмяМакета);
КонецФункции

&НаСервере
Функция ПолучитьUID()
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Возврат Строка(Объект.Ссылка.УникальныйИдентификатор());		
	КонецЕсли; 
	Возврат "";
КонецФункции

&НаСервере
Функция ПрочитатьВсеПриложенияНаСервере(УИД)
		
	Струк = РегистрыСведений.Файлы.ПрочитатьФайлы(УИД, Объект.Ссылка);
	Возврат Струк
	
КонецФункции

&НаКлиенте
Процедура ПрочитатьВсеПриложения()
	
	КаталогФайлов = КаталогВременныхФайлов() + "МенеджерБТИ\";
	
	СоздатьКаталог(КаталогФайлов);
	
	ОбщаяСтруктура = ПрочитатьВсеПриложенияНаСервере(ЭтаФорма.УникальныйИдентификатор); 
	
	МасПрикрепленныеКартинки = ОбщаяСтруктура.ПрикрепленныеКартинки;
	Если МасПрикрепленныеКартинки.Количество() > 0 Тогда
		Для Каждого ТекСтрока Из МасПрикрепленныеКартинки Цикл
			ТекСтрока.Имя = КаталогФайлов + ТекСтрока.Имя;
		КонецЦикла;
		ПолучитьФайлы(МасПрикрепленныеКартинки,,,Ложь);
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура ЗаписатьПриложениеНаСервере(ВыбранноеИмяФайла, АдресВХранилище)
	
	РегистрыСведений.Файлы.ЗаписатьФайл(ВыбранноеИмяФайла, Объект.Ссылка, АдресВХранилище);
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьНаборФайлов()
	
	Набор = РегистрыСведений.Файлы.СоздатьНаборЗаписей();
	
	Набор.Отбор.Документ.ВидСравнения = ВидСравнения.Равно;
	Набор.Отбор.Документ.Значение = Объект.Ссылка;
	Набор.Отбор.Документ.Использование = Истина;
	
	Набор.Отбор.Скрытый.ВидСравнения = ВидСравнения.Равно;
	Набор.Отбор.Скрытый.Значение = Ложь;
	Набор.Отбор.Скрытый.Использование = Истина;
	
	Набор.Прочитать(); 
	
	ЗначениеВДанныеФормы(Набор,НаборЗаписей);
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьНаборФайлов()
	
	Набор = РеквизитФормыВЗначение("НаборЗаписей");
	Набор.Записать();
	
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьФайлВТемп(ИмяФайлаИсточника)
	
	КаталогВФ = КаталогВременныхФайлов() + "МенеджерБТИ\";
	СоздатьКаталог(КаталогВФ);
	
	ИмяФайлаПриемника = КаталогВФ + Формат(ТекущаяДата(), "ДФ=yyyyMMddHHmmss") +ПолучитьUID()+ "_tmp.JPG";
	КопироватьФайл(ИмяФайлаИсточника, ИмяФайлаПриемника);
	
	ИмяФайлаИсточника = ИмяФайлаПриемника;
	
КонецПроцедуры

&НаКлиенте
Функция ПеревестиИз10(Знач Значение = 0) Экспорт
	
	Значение = Число(Значение);
	Если Значение <= 0 Тогда
		Возврат "00";
	КонецЕсли;
	
	Значение = Цел(Значение);
	Результат = "";
	
	Пока Значение > 0 Цикл
		Результат = Сред("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ",Значение%16+1,1) + Результат;
		Значение = Цел(Значение/16);
	КонецЦикла;
	
	Если СтрДлина(Результат) = 1 Тогда
		Результат = "0" + Результат;
	КонецЕсли; 
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ЭтоНовыйДокумент() Экспорт
	Возврат Объект.Ссылка.Пустая();
КонецФункции


// Нажатия кнопок

&НаКлиенте
Процедура ВыполнитьКоманду(Кнопка)
	
	Документ = Элементы.ПолеHTMLДокумента.Документ;
	Команда = Сред(Кнопка.Имя, 8);
	Если Документ.queryCommandSupported(Команда) Тогда
		Документ.execCommand(Команда, Ложь);
		ПоказатьРежимыКнопок();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьКомандуСписка(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Команда = Сред(Элемент.Имя, 8);
	Если Документ.queryCommandSupported(Команда) Тогда
		Список = Элемент.СписокВыбора;
		Документ.execCommand(Команда, Истина, ВыбранноеЗначение);
		ПоказатьРежимыКнопок();
	КонецЕсли;
	ЭтаФорма.ТекущийЭлемент = Элементы.ПолеHTMLДокумента;
	
КонецПроцедуры

&НаКлиенте
Процедура КоманднаяПанельРежим(Команда)
	
	Кнопка = Элементы.Найти(Команда.Имя);
	Если Кнопка.Пометка Тогда
		Возврат;
	КонецЕсли; 
	
	Элементы.Редактирование.Пометка = Ложь;
	Элементы.Текст.Пометка = Ложь;
	Элементы.Просмотр.Пометка = Ложь;
	Кнопка.Пометка = Истина;
	
	Если Кнопка = Элементы.Текст Тогда
		
		// На некоторых машинах видимо из за настроек безопасности IE раскраска кода не получается
		// Поэтому делаем через попытку
		Попытка 
			sExpression = "
			|document.body.innerText = document.body.innerHTML;
			|document.body.innerHTML = colourCode(document.body.innerHTML);
			|function colourCode(code)
			|{
			|    htmlTag = /(&lt;([\s\S]*?)&gt;)/gi
			|    tableTag = /(&lt;(table|tbody|th|tr|td|\/table|\/tbody|\/th|\/tr|\/td)([\s\S]*?)&gt;)/gi
			|    commentTag = /(&lt;!--([\s\S]*?)&gt;)/gi
			|    imageTag = /(&lt;img([\s\S]*?)&gt;)/gi
			|    linkTag = /(&lt;(a|\/a)([\s\S]*?)&gt;)/gi
			|    scriptTag = /(&lt;(script|\/script)([\s\S]*?)&gt;)/gi
			|    code = code.replace(htmlTag,""<font color=#FF0000>$1</font>"")
			|    code = code.replace(tableTag,""<font color=#008080>$1</font>"")
			|    code = code.replace(commentTag,""<font color=#808080>$1</font>"")
			|    code = code.replace(imageTag,""<font color=#800080>$1</font>"")
			|    code = code.replace(linkTag,""<font color=#008000>$1</font>"")
			|    code = code.replace(scriptTag,""<font color=#800000>$1</font>"")
			|    return code;
			|}";
			Документ.parentWindow.execScript(sExpression);
			
		Исключение
			Документ.Body.InnerText = Документ.Body.InnerHTML;
		КонецПопытки;
		
	ИначеЕсли ПредыдущийРежим = Элементы.Текст Тогда
		Документ.Body.InnerHTML = Документ.Body.InnerText;
	КонецЕсли;
	
	Если Кнопка = Элементы.Просмотр Тогда
		Документ.Body.ContentEditable = "false";
	Иначе
		Документ.Body.ContentEditable = "true";
	КонецЕсли;
	
	ДоступностьКнопок = (Кнопка = Элементы.Редактирование);
	Элементы.КомандаFormatBlock.Доступность = ДоступностьКнопок;
	Элементы.КомандаFontName.Доступность = ДоступностьКнопок;
	Элементы.КомандаFontSize.Доступность = ДоступностьКнопок;
	
	Для каждого Группа Из Элементы.КоманднаяПанельКнопок.ПодчиненныеЭлементы Цикл
		Если Группа.Имя = "ГруппаУправлениеРежимом" Тогда
			УправлятьДоступностью = Ложь;
		Иначе
			УправлятьДоступностью = Истина;
		КонецЕсли;
		
		Для каждого Кн Из Группа.ПодчиненныеЭлементы Цикл
			Если ТипЗнч(Кн) = тип("КнопкаФормы") Тогда
				Если УправлятьДоступностью Тогда
					Кн.Доступность = ДоступностьКнопок
				КонецЕсли; 
			КонецЕсли;
		КонецЦикла;
		
	КонецЦикла; 
	
	ПредыдущийРежим = Кнопка;
	ПоказатьРежимыКнопок();
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеHTMLДокументаДокументСформирован(Элемент)
	
	Элемент.Документ.Body.ContentEditable = "true";
	Элемент.Документ.body.scroll = "Yes";
	Если СтрДлина(ПараметрТекстHTML) > 0 Тогда
		Элемент.Документ.Body.innerHTML = ПараметрТекстHTML;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеHTMLДокументаПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	ПоказатьРежимыКнопок();
	
	Если ДанныеСобытия.Href <> Неопределено  Тогда
		Сцылко = ДанныеСобытия.Href;
		СтандартнаяОбработка = Ложь;
		Если Лев(Сцылко, 6) = "about:" Тогда
			Сцылко = Сред(Сцылко,7);
		КонецЕсли; 
		Если ВРЕГ(Лев(Сцылко, 5)) = "E1CIB" Тогда // Это внутренняя ссылка
			ПерейтиПоНавигационнойСсылке(Сцылко);
		Иначе // внешняя
			Если ВРЕГ(Лев(Сцылко, 7)) = "HTTP://" Тогда
				//
			Иначе
				Сцылко = "http://" + Сцылко;
			КонецЕсли; 
			ПерейтиПоНавигационнойСсылке(Сцылко);
		КонецЕсли;	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВставитьГиперссылку(Команда)
	
	Гиперссылка = ПолучитьФорму("Документ.Статья.Форма.ВыборГиперссылки").ОткрытьМодально();
	Если Гиперссылка <> Неопределено Тогда
		Документ.execCommand("CreateLink", Ложь, Гиперссылка);
		//Сцылко = Документ.createElement("a");
		//Сцылко.setAttribute("href",Гиперссылка);
		//Документ.getElementsByTagName("body")[0].appendChild(Сцылко);				
	КонецЕсли;
	ПоказатьРежимыКнопок();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьПоOK(Команда)
	
	Если Документ.body.innerHTML <> "" Тогда
		Закрыть(Документ.body.innerHTML);
	Иначе
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВставитьКартинкуИзБуфера(Команда)
	#Если Не ВебКлиент Тогда 
		КаталогВФ = КаталогВременныхФайлов() + "МенеджерБТИ\";
		СоздатьКаталог(КаталогВФ);
		ИмяФайлаПрограммы = КаталогВФ + "CbToJPEG.exe";
		ДвоичныеДанныеПрограммы = сПолучитьОбщийМакет("CbToJPEG");
		ДвоичныеДанныеПрограммы.Записать(ИмяФайлаПрограммы);
		ФайлПрограммы = Новый Файл(ИмяФайлаПрограммы);
		
		ИмяФайлаКартинки = КаталогВФ + Формат(ТекущаяДата(), "ДФ=yyyyMMddHHmmss") +ПолучитьUID()+ "_tmp.JPG";
		ИмяДляЗаписи = Формат(ТекущаяДата(), "ДФ=yyyyMMddHHmmss") +ПолучитьUID()+ "_tmp.JPG";
		СтрокаЗапуска = """"+ФайлПрограммы.ПолноеИмя+""" """+ИмяФайлаКартинки+"""";
		
		WshShell = Новый COMОбъект("WScript.Shell");
		WshShell.Run(СтрокаЗапуска, 0, Истина);
		
		ФайлКартинки = Новый Файл(ИмяФайлаКартинки);
		Если Не ФайлКартинки.Существует() Тогда 
			ИмяФайлаКартинки = Неопределено;
		КонецЕсли;
		
		Если ИмяФайлаКартинки <> Неопределено Тогда 
			//мКартинка = Новый Картинка(ИмяФайлаКартинки);
			//мКартинка.ПолучитьДвоичныеДанные();
			АдресВХранилище = "";
			ВыбранноеИмяФайла = "";
			Если ПоместитьФайл(АдресВХранилище,ИмяФайлаКартинки, ВыбранноеИмяФайла,Ложь,ЭтаФорма.УникальныйИдентификатор) Тогда
				//ЗаписатьПриложениеНаСервере(АдресВХранилище,ИмяДляЗаписи);
				СтрокаКартинка = ПрикрепленныеКартинки.Добавить();
				СтрокаКартинка.Имя  = ИмяДляЗаписи;
				СтрокаКартинка.Путь = АдресВХранилище;
				
				ЭтаФорма.Модифицированность = Истина;
			КонецЕсли;
			Отказ = Истина;
			
			// Вставляем картинку в документ.
			Документ.execCommand("InsertImage", Ложь, ИмяФайлаКартинки);
			
			// Надо формировать массив временных файлов, а потом удалять их
			// Или пихать все в дополнительную папку, а ее потом удаять!
			//УдалитьФайлы(ИмяФайлаКартинки);
		КонецЕсли;
		//УдалитьФайлы(ИмяФайлаПрограммы);
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьКартинкуИзФайла(Команда)
	
	
	АдресВХранилище = "";
	ВыбранноеИмяФайла = "";
	Если ПоместитьФайл(АдресВХранилище,, ВыбранноеИмяФайла,Истина,ЭтаФорма.УникальныйИдентификатор) Тогда
		
		ПереместитьФайлВТемп(ВыбранноеИмяФайла);
		
		СтрокаКартинка = ПрикрепленныеКартинки.Добавить();
		СтрокаКартинка.Имя  = ВыбранноеИмяФайла;
		СтрокаКартинка.Путь = АдресВХранилище;
		
		ЭтаФорма.Модифицированность = Истина;
	КонецЕсли;
	
	// Вставляем картинку в документ.
	Документ.execCommand("InsertImage", Ложь, ВыбранноеИмяФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриложенияПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ = Истина; // Аналог стандартнаяОбработка = Ложь;
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		АдресВХранилище = "";
		ВыбранноеИмяФайла = "";
		Если ПоместитьФайл(АдресВХранилище, , ВыбранноеИмяФайла, Истина, ЭтаФорма.УникальныйИдентификатор) Тогда
			ЗаписатьПриложениеНаСервере(ВыбранноеИмяФайла, АдресВХранилище);
		КонецЕсли;
		ПрочитатьНаборФайлов();
	Иначе
		Предупреждение("Перед добавлением необходимо записать документ.");
	КонецЕсли; 
		
КонецПроцедуры

&НаКлиенте
Процедура ПриложенияПослеУдаления(Элемент)
	
	ЗаписатьНаборФайлов();
	ПрочитатьНаборФайлов();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриложенияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	АдресВХранилище = "";
	ПрочитатьПриложениеНаСервере(ВыбраннаяСтрока,АдресВХранилище);
    ПолучитьФайл(АдресВХранилище,НаборЗаписей[ВыбраннаяСтрока].ИмяФайла,Истина);

КонецПроцедуры

&НаСервере
Процедура ПрочитатьПриложениеНаСервере(ВыбраннаяСтрока, Адрес)
	
	МЗ = РегистрыСведений.Файлы.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(МЗ, НаборЗаписей[ВыбраннаяСтрока]);
	МЗ.Прочитать();
	
	Струк = Новый Структура("ИмяФайла, Документ", МЗ.ИмяФайла, Мз.Документ);
	
	Адрес = РегистрыСведений.Файлы.ПрочитатьФайл(Струк, ЭтаФорма.УникальныйИдентификатор); 
	
КонецПроцедуры



// Отображение

&НаКлиенте
Процедура ПоказатьРежимыКнопок()
	
	Для каждого Группа Из Элементы.КоманднаяПанельКнопок.ПодчиненныеЭлементы Цикл
		Для каждого Кнопка Из Группа.ПодчиненныеЭлементы Цикл
			Если ТипЗнч(Кнопка) = тип("КнопкаФормы") Тогда
				Команда = Сред(Кнопка.Имя, 8);
				Если Документ.queryCommandSupported(Команда) Тогда
					Попытка
						Кнопка.Пометка = Документ.queryCommandState(Команда);
					Исключение
					КонецПопытки;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры


// События формы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЭтоНовыйДокумент() Тогда
		Если Параметры <> Неопределено Тогда 
			Если Параметры.Свойство("Задача") Тогда 
				// Заполним статью на основании задачи
				Общий.офЗаполнитьСтатьюПоЗадаче(Объект, Параметры.Задача);
				ЭтаФорма.ПараметрТекстHTML = Объект.ТекстHTML;
			Иначе
				ЗаполнитьЗначенияСвойств(Объект, Параметры);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

	ПрочитатьНаборФайлов();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ЭтаФорма.ПараметрТекстHTML = СтрЗаменить(ЭтаФорма.ПараметрТекстHTML, "%Temp%", КаталогВременныхФайлов() + "МенеджерБТИ\");
	
	Список = Элементы.КомандаformatBlock.СписокВыбора;
	Список.Добавить("<p>", "Обычный");
	Список.Добавить("<h1>", "Заголовок 1");
	Список.Добавить("<h2>", "Заголовок 2");
	Список.Добавить("<h3>", "Заголовок 3");
	Список.Добавить("<h4>", "Заголовок 4");
	Список.Добавить("<h5>", "Заголовок 5");
	Список.Добавить("<h6>", "Заголовок 6");
	Список.Добавить("<pre>", "Форматированный");
	Список.Добавить("<address>", "Адрес");
	ТекЭлемент = Список.НайтиПоИдентификатору(0);
	СтилиТекста = ТекЭлемент.Значение;
	
	// Заполнение списка шрифтов
	Список = Элементы.КомандаFontName.СписокВыбора;
	Список.Добавить("Arial");
	Список.Добавить("Arial Black");
	Список.Добавить("Arial Narrow");
	Список.Добавить("Comic Sans MS");
	Список.Добавить("Courier New");
	Список.Добавить("System");
	Список.Добавить("Tahoma");
	Список.Добавить("Times New Roman");
	Список.Добавить("Verdana");
	Список.Добавить("Wingdings");
	ТекЭлемент = Список.НайтиПоИдентификатору(0);
	ИмяШрифта = ТекЭлемент.Значение;
	
	// Заполнение списка размеров
	Список = Элементы.КомандаFontSize.СписокВыбора;
	Для Ном = 1 По 14 Цикл
		Список.Добавить(Ном);
	КонецЦикла;
	ТекЭлемент = Список.НайтиПоИдентификатору(2);
	РазмерыШрифта = ТекЭлемент.Значение;
	
	ПрочитатьВсеПриложения();
	
	Документ = Элементы.ПолеHTMLДокумента.Документ;
	ПредыдущийРежим = Элементы.Редактирование;
	Элементы.Редактирование.Пометка = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	ЭтаФорма.ПараметрТекстHTML = ТекущийОбъект.ТекстHTML; 
	//Если НЕ ЗначениеЗаполнено(ТекущийОбъект.ТекстHTML) Тогда
	//    Попытка
	//    Этаформа.ПараметрТекстHTML = ТекущийОбъект.ТекстHTML;
	//    Исключение
	//    //Сообщить(НСтр("ru = '"+ОписаниеОшибки()+"'"), СтатусСообщения.Внимание);
	//    КонецПопытки;
	//КонецЕсли
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	ЭтаФорма.ПараметрТекстHTML = Документ.Body.InnerHTML;
	
	КаталогВФ = КаталогВременныхФайлов() + "МенеджерБТИ\";
	КаталогВФОбратный = СтрЗаменить(КаталогВФ, "\","/");
	ЭтаФорма.ПараметрТекстHTML = СтрЗаменить(ЭтаФорма.ПараметрТекстHTML, КаталогВФ, "%Temp%");
	ЭтаФорма.ПараметрТекстHTML = СтрЗаменить(ЭтаФорма.ПараметрТекстHTML, "file:///" + КаталогВФОбратный, "%Temp%");
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТекущийОбъект.ТекстHTML = ЭтаФорма.ПараметрТекстHTML;
	ТекущийОбъект.Автор = ПараметрыСеанса.ТекущийПользователь;
	ТекущийОбъект.Дата  = ТекущаяДата();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Если ПрикрепленныеКартинки.Количество() > 0 Тогда
		МассивКартинок = Новый Массив;
		Для каждого стр Из ПрикрепленныеКартинки Цикл
			 МассивКартинок.Добавить(Новый Структура("Имя, Путь", Стр.Имя, Стр.Путь));
		КонецЦикла; 
		ПослеЗаписиНаСервере(МассивКартинок, Истина);		
	КонецЕсли; 
		
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере (МассивПриложений, Скрытый)
	 РегистрыСведений.Файлы.ЗаписатьФайлы(МассивПриложений, Объект.Ссылка, Скрытый);
КонецПроцедуры




