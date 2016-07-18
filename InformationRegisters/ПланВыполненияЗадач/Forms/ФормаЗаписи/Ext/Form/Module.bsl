﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(Запись.Исполнитель) И ЗначениеЗаполнено(Запись.Задача) Тогда 
		Запись.Исполнитель = Запись.Задача.Исполнитель;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Запись.Период) Тогда 
		Запись.Период = ?(ЗначениеЗаполнено(Запись.ДатаНачалаПлан), Запись.ДатаНачалаПлан, ТекущаяДата());
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаПланПриИзменении(Элемент)
	
	Если Запись.ДатаНачалаПлан > Запись.ДатаОкончанияПлан Тогда 
		Запись.ДатаОкончанияПлан = Запись.ДатаНачалаПлан;
	КонецЕсли;
	
КонецПроцедуры
