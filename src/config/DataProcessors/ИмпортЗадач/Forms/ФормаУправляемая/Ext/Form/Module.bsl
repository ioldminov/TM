﻿
&НаКлиенте
Процедура Загрузить(Команда)
	ЗагрузитьНаСервере();
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьНаСервере()
	РеквизитФормыВЗначение("Объект").ЗагрузитьДанные(ПолеТабличногоДокумента);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПриОткрытииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПриОткрытииНаСервере()
	
	РеквизитФормыВЗначение("Объект").ПриОткрытии(ПолеТабличногоДокумента);
	Элементы.ПолеТабличногоДокумента.Редактирование = Истина;
	Элементы.ПолеТабличногоДокумента.ТолькоПросмотр = Ложь;
	Элементы.ПолеТабличногоДокумента.ОтображатьСетку = Истина;
	Элементы.ПолеТабличногоДокумента.ОтображатьЗаголовки = Истина;
	
КонецПроцедуры
