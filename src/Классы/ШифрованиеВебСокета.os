
&Желудь
Процедура ПриСозданииОбъекта()

КонецПроцедуры

Функция МагическаяСтрока() Экспорт
	Возврат "258EAFA5-E914-47DA-95CA-C5AB0DC85B11";
КонецФункции

Функция ХешОтветаРукопожатия(КлючРукопожатия) Экспорт
	Результат = СокрЛП(КлючРукопожатия) + МагическаяСтрока();	
	Провайдер = Новый ХешированиеДанных(ХешФункция.SHA1);
	Провайдер.Добавить(Результат);
	Результат = Base64Строка(Провайдер.ХешСумма);
	Возврат Результат;	
КонецФункции

Функция ЗапаковатьСообщениеТекстовоеСообщение(Сообщение) Экспорт

	ДвоичныеДанныеСообщения = ПолучитьДвоичныеДанныеИзСтроки(Сообщение); 
	РзамерСообщения = ДвоичныеДанныеСообщения.Размер();

	Массив = Новый Массив();
	Массив.Добавить(ЧислоВДвоичныеДанные(129));

	Если РзамерСообщения <= 125 Тогда
		Массив.Добавить(ЧислоВДвоичныеДанные(РзамерСообщения));

	ИначеЕсли РзамерСообщения >= 126 И РзамерСообщения <= 65535 Тогда
		Массив.Добавить(ЧислоВДвоичныеДанные(126));
        Массив.Добавить(ЧислоВДвоичныеДанные(ПодготовитьРазмерФреймаДляКодированияОтвета(РзамерСообщения, 8)));
        Массив.Добавить(ЧислоВДвоичныеДанные(ПодготовитьРазмерФреймаДляКодированияОтвета(РзамерСообщения)));
	
	Иначе
		Массив.Добавить(127);
        Массив.Добавить(ЧислоВДвоичныеДанные(ПодготовитьРазмерФреймаДляКодированияОтвета(РзамерСообщения, 56)));
		Массив.Добавить(ЧислоВДвоичныеДанные(ПодготовитьРазмерФреймаДляКодированияОтвета(РзамерСообщения, 48)));
        Массив.Добавить(ЧислоВДвоичныеДанные(ПодготовитьРазмерФреймаДляКодированияОтвета(РзамерСообщения, 40)));
        Массив.Добавить(ЧислоВДвоичныеДанные(ПодготовитьРазмерФреймаДляКодированияОтвета(РзамерСообщения, 32)));
        Массив.Добавить(ЧислоВДвоичныеДанные(ПодготовитьРазмерФреймаДляКодированияОтвета(РзамерСообщения, 24)));
        Массив.Добавить(ЧислоВДвоичныеДанные(ПодготовитьРазмерФреймаДляКодированияОтвета(РзамерСообщения, 16)));
        Массив.Добавить(ЧислоВДвоичныеДанные(ПодготовитьРазмерФреймаДляКодированияОтвета(РзамерСообщения, 8)));
        Массив.Добавить(ЧислоВДвоичныеДанные(ПодготовитьРазмерФреймаДляКодированияОтвета(РзамерСообщения)));

	КонецЕсли;

	Массив.Добавить(ДвоичныеДанныеСообщения);

	Возврат СоединитьДвоичныеДанные(Массив);

КонецФункции

Функция РаспаковатьСообщение(ДвоичныеДанныеСообщения) Экспорт

	ДанныеСообщения = Новый Структура("ТипСообщения, Сообщение");

	Массив = РазделитьДвоичныеДанные(ДвоичныеДанныеСообщения, 1);
	
	ДанныеСообщения.ТипСообщения = ПобитовоеИ(ДвоичныеДанныеВЧисло(Массив[0]), 15);

	ЗначениеРазмера = ДвоичныеДанныеВЧисло(Массив[1]);
	Размер = ПобитовоеИ(ЗначениеРазмера, 127);

	Если Размер = 126 Тогда 
		ИндексНачалаМаски = 4
	ИначеЕсли Размер = 127 Тогда
		ИндексНачалаМаски = 10;
	Иначе
		ИндексНачалаМаски = 2;
	КонецЕсли;

	ИндексНачалаДанных = ИндексНачалаМаски + 4;

	Маска = МассивБайтВМассивЧисел(СрезМассива(Массив, ИндексНачалаМаски, ИндексНачалаДанных - 1));

	Результат = Новый Массив();

	СчетчикМаски = 0;

	Для _Сч = ИндексНачалаДанных По Массив.ВГраница() Цикл
		Код = ПобитовоеИсключительноеИли(ДвоичныеДанныеВЧисло(Массив[_Сч]), Маска[СчетчикМаски % 4]);
		Если НЕ Код = 0 Тогда
			Результат.Добавить(ЧислоВДвоичныеДанные(Код));
		КонецЕсли;
		СчетчикМаски = СчетчикМаски + 1;
	КонецЦикла;

	ДанныеСообщения.Сообщение = СоединитьДвоичныеДанные(Результат);

	Если ДанныеСообщения.ТипСообщения = 1 Тогда // Текстовый фрейм
		ДанныеСообщения.Сообщение = ПолучитьСтрокуИзДвоичныхДанных(ДанныеСообщения.Сообщение);
	КонецЕсли;

	Возврат ДанныеСообщения;
КонецФункции

Функция ПодготовитьРазмерФреймаДляКодированияОтвета(РзамерСообщения, Сдвиг = 0)
	Если Сдвиг > 0 Тогда
		Возврат ПобитовоеИ(ПобитовыйСдвигВправо(РзамерСообщения, Сдвиг), 255);
	Иначе
    	Возврат ПобитовоеИ(РзамерСообщения,  255);
	КонецЕсли;
КонецФункции

Функция СрезМассива(Массив, Знач Начало, Знач Конец)
	Результат = Новый Массив();
	Для Индекс = Начало По Конец Цикл
		Результат.Добавить(Массив[Индекс]);
	КонецЦикла;
	Возврат Результат;
КонецФункции

Функция ДвоичныеДанныеВЧисло(ДвоичныеДанные)
	Возврат ПолучитьБуферДвоичныхДанныхИзДвоичныхДанных(ДвоичныеДанные).Получить(0);
КонецФункции

Функция МассивБайтВМассивЧисел(Массив)
	Результат = Новый Массив();
	Для Каждого Элемент Из Массив Цикл
		Результат.Добавить(ДвоичныеДанныеВЧисло(Элемент));
	КонецЦикла;
	Возврат Результат;
КонецФункции

Функция ЧислоВДвоичныеДанные(Число)
	Поток = Новый ПотокВПамяти();
	ЗаписьДанных = Новый ЗаписьДанных(Поток);
	ЗаписьДанных.ЗаписатьЦелое16(Число);

	Результат = Поток.ЗакрытьИПолучитьДвоичныеДанные();
	ЗаписьДанных.Закрыть();

	Возврат РазделитьДвоичныеДанные(Результат, 1)[0];
	// Возврат Результат;
КонецФункции

Функция ТекстВМассивДвоичныеДанныеДляСообщения(Текст)
	Результат = Новый Массив();

	Для _Сч = 1 По СтрДлина(Текст) Цикл
		Результат.Добавить(ПолучитьДвоичныеДанныеИзСтроки(Сред(Текст, _Сч, 1)));
	КонецЦикла;

	Возврат Результат;
КонецФункции