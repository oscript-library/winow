#Использовать json

Перем ТекстЗапроса Экспорт;
Перем Заголовки Экспорт;
Перем Тело Экспорт;
Перем ТелоДвоичныеДанные Экспорт;
Перем Метод Экспорт;
Перем ПолныйПуть Экспорт;
Перем Путь Экспорт;
Перем ПараметрыИменные Экспорт;
Перем ПараметрыПорядковые Экспорт;
Перем ДатаПолучения Экспорт;
Перем ДвоичныеДанные Экспорт;
Перем Сессия Экспорт;
Перем КлючРукопожатия Экспорт;

&Пластилин Перем Куки Экспорт;
&Пластилин Перем Парсеры;
&Пластилин Перем Настройки;


&Желудь
&Характер("Компанейский")
Процедура ПриСозданииОбъекта()

	ТекстЗапроса = "";
	Заголовки = Новый Соответствие();
	Тело = "";
	Метод = "";
	ПолныйПуть = "";
	Путь = "";
	ПараметрыИменные = Новый Соответствие();
	ПараметрыПорядковые = Новый Массив();
	ДатаПолучения = ТекущаяДата();

КонецПроцедуры

Функция ЗначенияПараметровДляТочкиМаршрута() Экспорт
	Результат = Новый Структура();
	Результат.Вставить("Запрос", ЭтотОбъект);
	Результат.Вставить("ТекстЗапроса", ТекстЗапроса);
	Результат.Вставить("ЗаголовкиЗапроса", Заголовки);
	Результат.Вставить("ТелоЗапроса", Тело);
	Результат.Вставить("ТелоЗапросаДвоичныеДанные", ТелоДвоичныеДанные);
	Результат.Вставить("МетодЗапроса", Метод);
	Результат.Вставить("ПолныйПутьЗапроса", ПолныйПуть);
	Результат.Вставить("ПутьЗапроса", Путь);
	Результат.Вставить("ПараметрыЗапросаИменные", ПараметрыИменные);
	Результат.Вставить("ПараметрыЗапросаПорядковые", ПараметрыПорядковые);
	Результат.Вставить("ДатаПолученияЗапроса", ДатаПолучения);
	Результат.Вставить("ДвоичныеДанныеЗапроса", ДвоичныеДанные);
	Результат.Вставить("КукиЗапроса", Куки);
	Результат.Вставить("ТелоЗапросОбъект", ТелоЗапросОбъект());

	ДополнитьПараметрамиФормы(Результат);

	Возврат Результат;
КонецФункции

Процедура ДополнитьПараметрамиФормы(Результат)
	Если ЗначениеЗаполнено(Тело) 
		И СокрЛП(Заголовки["Content-Type"]) = "application/x-www-form-urlencoded" Тогда

		Параметры = Парсеры.ПараметрыИзТекста(Тело);
		Для Каждого Параметр из Параметры Цикл
			Результат.Вставить(Параметр.Ключ, Параметр. Значение);
		КонецЦикла;
	КонецЕсли;	
КонецПроцедуры

Функция ТелоЗапросОбъект() Экспорт
	Результат = Неопределено;

	Если ЗначениеЗаполнено(Тело) 
			И СокрЛП(Заголовки["Content-Type"]) = "application/json" Тогда

			Парсер = Новый ПарсерJSON();
			Результат = Парсер.ПрочитатьJSON(Тело, Истина, Ложь, Настройки.АвтоматическиПриводитьОбъектыКСтруктуре);
				
	КонецЕсли;

	Возврат Результат;
КонецФункции

Функция ЭтоЗапросНаВебСокет() Экспорт
	КлючРукопожатия = Заголовки["Sec-WebSocket-Key"];
	Возврат НЕ КлючРукопожатия = Неопределено И НЕ ПустаяСтрока(КлючРукопожатия);
КонецФункции