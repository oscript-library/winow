
&Желудь
Процедура ПриСозданииОбъекта()
	
КонецПроцедуры

Функция СформироватьПараметрыТочкиМаршрута(Действие, ТребуемыеПараметры, ВходящийЗапрос, Ответ, Сессия) Экспорт

	ЗначенияПараметров = ЗначенияПараметровДляТочкиМаршрута(ВходящийЗапрос, Ответ, Сессия);

	Если Действие.УрлСодержитШаблон Тогда
		ПутьСПараметрами = ПараметрыИзУрлаСШаблоном(ВходящийЗапрос.Путь, Действие.АдресКонтроллера);
		ДополнитьЗначениямиПараметровУРЛ(Действие.ПараметрыУРЛ, ПутьСПараметрами, ЗначенияПараметров);
	КонецЕсли;

	Возврат СформироватьМассивНеобходимыхПараметров(ТребуемыеПараметры, ЗначенияПараметров);
	
КонецФункции

Функция ПараметрыИзУрлаСШаблоном(Путь, АдресКонтроллера)
	Если АдресКонтроллера = "/" Тогда
		Возврат Сред(Путь, 2);
	Иначе
		Возврат СтрЗаменить(Путь, АдресКонтроллера + "/", "");
	КонецЕсли;
КонецФункции

Функция СформироватьМассивНеобходимыхПараметров(ТребуемыеПараметры, Значения) Экспорт
	Результат = Новый Массив();
	
	Для Каждого Параметр из ТребуемыеПараметры Цикл
		Результат.Добавить(Значения.Получить(Параметр));
	КонецЦикла;

	Возврат Результат;	
КонецФункции

Процедура ДополнитьЗначениямиПараметровУРЛ(ПараметрыУРЛ, Путь, ЗначенияПараметров)
	ПутьВМассив = СтрРазделить(Путь, "/");

	Для каждого ТекПараметрУРЛ Из ПараметрыУРЛ Цикл

		Если ТекПараметрУРЛ.Ключ <= ПутьВМассив.ВГраница() Тогда
			ЗначенияПараметров.Вставить(ТекПараметрУРЛ.Значение, ПутьВМассив[ТекПараметрУРЛ.Ключ]);
		Иначе
			ЗначенияПараметров.Вставить(ТекПараметрУРЛ.Значение);
		КонецЕсли;

	КонецЦикла;
КонецПроцедуры

Функция ЗначенияПараметровДляТочкиМаршрута(ВходящийЗапрос, Ответ, Сессия)
	Значения = Новый Соответствие();	
	ДополнитьСоответствие(Значения, ВходящийЗапрос.ЗначенияПараметровДляТочкиМаршрута());
	ДополнитьСоответствие(Значения, Ответ.ЗначенияПараметровДляТочкиМаршрута());
	ДополнитьСоответствие(Значения, Сессия.ЗначенияПараметровДляТочкиМаршрута());
	Возврат Значения;
КонецФункции

Процедура ДополнитьСоответствие(Приемник, Источник)
	Для Каждого КиЗ Из Источник Цикл
		Приемник.Вставить(КиЗ.Ключ, КиЗ.Значение);
	КонецЦикла;
КонецПроцедуры