﻿
&НаКлиенте
Процедура ОК(Команда)
	ОбновлениеОтображения();
	Закрыть(Элементы.ПолеКартинкиЦвета.ЦветФона);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	СтруктураЦветов = Новый Структура("К240248255, К250235215, К127255212, К240255255, К245245220, К255228196, К000000000, К255235205, К000000255, К138043226, К165042042, К222184135, К095158160, К127255000, К210105030, К255127080, К100149237, К255248220, К255248220, К220020060, К000255255, К000000139, К000139139, К184134011, К169169169, К000100000, К189183107, К139000128, К085107047, К255140000, К153050204, К139000000, К233150122, К143188143, К072061139, К047079079, К000206209, К148000211, К255020147, К000191255, К105105105, К030144255, К178034034, К255250240, К034139034, К255000255, К220220220, К248248255, К255215000, К218165032, К128128128, К000128000, К173255047, К240255240, К255105180, К205092092, К075000130, К255255240, К240230140, К230230250, К255240245, К124252000, К255250205, К173216230, К240128128, К224255255, К255236139, К250250210, К211211211, К144238144, К255182193, К255160122, К032178170, К135206250, К132112255, К119136153, К176196222, К255255224, К000255000, К050205050, К250240230, К255000255, К128000000, К102205170, К000000205, К160160164, К192220192, К186085211, К147112219, К060179113, К123104238, К000250154, К072209204, К199021133, К025025112, К245255250, К255228225, К255228181, К255222173, К000000128, К253245230, К128128000, К107142035, К255165000, К255069000, К218112214, К238232170, К152251152, К175238238, К219112147, К255239213, К255218185, К205133063, К255192203, К221160221, К176224230, К128000128, К255000000, К188143143, К065105225, К139069019, К250128114, К244164096, К255245238, К046139087, К160082045, К192192192, К135206235, К106090205, К112128128, К255250250, К000255127, К070130180, К210180140, К000128128, К216191216, К255099071, К064224208, К238130238, К208032144, К245222179, К255255255, К245245245, К255255000, К154205050","Акварельно-синий", "Антик Белый", "Аквамарин", "Лазурный", "Бежевый", "Светло-коричневый", "Черный", "Бледно-миндальный", "Синий", "Сине-фиолетовый", "Коричневый", "Древесный", "Серо-синий", "Зеленовато-желтый", "Шоколадный", "Коралловый", "Васильковый", "Шелковый Оттенок", "Кремовый", "Малиновый", "Циан", "Темно-синий", "Циан Темный", "Темно-золотистый", "Темно-серый", "Темно-зеленый", "Хаки Темный", "Фуксин Темный", "Темно-оливково-зеленый", "Темно-оранжевый", "Орхидея Темный", "Темно-красный", "Лосось Темный", "Цвет морской волны Темный", "Темно-грифельно-синий", "Темно-грифельно-серый", "Темно-бирюзовый", "Темно-фиолетовый", "Насыщенно-розовый", "Насыщенно-небесно-голубой", "Тускло-серый", "Серо-синий", "Кирпичный", "Цветок Белый", "Зеленый Лес", "Фуксия", "Серебристо-серый", "Призрачно-белый", "Золотой", "Золотистый", "Серый", "Зеленый", "Зелено-желтый", "Роса", "Тепло-розовый", "Киноварь", "Индиго", "Слоновая Кость", "Хаки", "Бледно-лиловый", "Голубой с красным оттенком", "Зеленая Лужайка", "Лимонный", "Голубой", "Светло-коралловый", "Циан Светлый", "Светло-золотистый", "Светло-желтый-золотистый", "Светло-серый", "Светло-зеленый", "Светло-розовый", "Лосось Светлый", "Цвет морской волны светлый", "Светло-небесно-голубой", "Светло-грифельно-синий", "Светло-грифельно-серый", "Голубой со стальным оттенком", "Светло-желтый", "Зеленовато-лимонный", "Лимонно-зеленый", "Льняной", "Фуксин", "Темно-бордовый", "Нейтрально-аквамариновый", "Нейтрально-синий", "Нейтрально-серый", "Нейтрально-зеленый", "Орхидея-нейтральный", "Нейтрально-пурпурный", "Цвет морской волны нейтральный", "Нейтрально-грифельно-синий", "Нейтрально-весенне-зеленый", "Нейтрально-бирюзовый", "Нейтрально-фиолетово-красный", "Полночно-синий", "Мятный Крем", "Тускло-розовый", "Замша Светлый", "Навахо Белый", "Ультрамарин", "Старое Кружево", "Оливковый", "Тускло-оливковый", "Оранжевый", "Оранжево-красный", "Орхидея", "Бледно-золотистый", "Бледно-зеленый", "Бледно-бирюзовый", "Бледно-красно-фиолетовый", "Топленое Молоко", "Персиковый", "Нейтрально-коричневый", "Розовый", "Сливовый", "Синий с пороховым оттенком", "Пурпурный", "Красный", "Розово-коричневый", "Королевски голубой", "Кожано-коричневый", "Лосось", "Песочно-коричневый", "Перламутровый", "Цвет морской волны", "Охра", "Серебряный", "Небесно-голубой", "Грифельно-синий", "Грифельно-серый", "Белоснежный", "Весенне-зеленый", "Синий со стальным оттенком", "Рыжевато-коричневый", "Циан Нейтральный", "Бледно-сиреневый", "Томатный", "Бирюзовый", "Фиолетовый", "Красно-фиолетовый", "Пшеничный", "Белый", "Дымчато-белый", "Желтый", "Желто-зеленый");
	Для каждого Цвет Из СтруктураЦветов Цикл
		Стр = ТабличноеПоле.Добавить();
		Стр.НазваниеЦвета = Цвет.Значение;
		Стр.ЗначениеЦвета = Прав(Цвет.Ключ, 9);
		//Красный = Число(Лев(Стр.ЗначениеЦвета, 3));
		//Зеленый = Число(Сред(Стр.ЗначениеЦвета, 4, 3));
		//Синий = Число(Прав(Стр.ЗначениеЦвета, 3));
		//ТекЦвет = Новый Цвет(Красный, Зеленый, Синий);
		//Элементы.ТабличноеПолеКартинкаЦвета.ЦветФона = ТекЦвет;
	КонецЦикла;
	ТабличноеПоле.Сортировать("НазваниеЦвета Возр");
	ОбновлениеОтображения();
КонецПроцедуры

&НаКлиенте
Процедура ОбновлениеОтображения()
	ТекЦвет = Новый Цвет(Красный,Зеленый,Синий);
	Элементы.ПолеКартинкиЦвета.ЦветФона = ТекЦвет;
КонецПроцедуры

&НаКлиенте
Процедура ТабличноеПолеПриАктивизацииСтроки(Элемент)
	ЗначениеЦвета = Элемент.ТекущиеДанные.ЗначениеЦвета;
	Красный = Число(Лев(ЗначениеЦвета, 3));
	Зеленый = Число(Сред(ЗначениеЦвета, 4, 3));
	Синий = Число(Прав(ЗначениеЦвета, 3));
	ОбновлениеОтображения();
КонецПроцедуры

&НаКлиенте
Процедура ТабличноеПолеВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ОбновлениеОтображения();
	Закрыть(Элементы.ПолеКартинкиЦвета.ЦветФона);	
КонецПроцедуры


&НаКлиенте
Процедура ПолеВводаЦветаПриИзменении(Элемент)
	ОбновлениеОтображения();
КонецПроцедуры

