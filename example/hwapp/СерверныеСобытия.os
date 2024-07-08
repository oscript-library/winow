
&Пластилин Перем БрокерСообщенийСобытийСервера;
&пластилин Перем ФабрикаОтветов;

Перем КоличествоЛайков;
Перем ИмяТопика;
Перем СейчасСмотрят;
Перем Комментарии;

&Контроллер("/sse")
&Отображение(Шаблон = "./hwapp/view/main_sse.html")
Процедура ПриСозданииОбъекта(&Пластилин ТопикиСерверныхСобытий)

	ИмяТопика = "/sse/acorndiscussion";
	КоличествоЛайков = 3;
	СейчасСмотрят = 0;

	ТопикиСерверныхСобытий.Добавить(ИмяТопика,
									Новый Действие(ЭтотОбъект, "НовоеПодключениеССЕ"),
									Новый Действие(ЭтотОбъект, "ОтключениеССЕ"));

	Комментарии = Новый ТаблицаЗначений();
	Комментарии.Колонки.Добавить("Имя");
	Комментарии.Колонки.Добавить("Комментарий");
	Комментарии.Колонки.Добавить("Дата");

КонецПроцедуры

Процедура НовоеПодключениеССЕ(Сессия, ИД) Экспорт
	СейчасСмотрят = СейчасСмотрят + 1;

	Сообщение = ФабрикаОтветов.СерверноеСобытие();
	Сообщение.ТипСобытия("like")
				 .ДобавитьСтроку(Строка(КоличествоЛайков));
	БрокерСообщенийСобытийСервера.ОтправитьСообщениеПоИдСоединения(ИД, Сообщение);

	Сообщение = ФабрикаОтветов.СерверноеСобытие();
	Сообщение.ТипСобытия("watch")
				 .ДобавитьСтроку(Строка(СейчасСмотрят));
	БрокерСообщенийСобытийСервера.ОтправитьСообщениеВсем(ИмяТопика, Сообщение);

	Для Каждого Комментарий из Комментарии Цикл
		Сообщение = СообщениеИзСтрокиКомментария(Комментарий);
		БрокерСообщенийСобытийСервера.ОтправитьСообщениеПоИдСоединения(ИД, Сообщение);
	КонецЦикла;

КонецПроцедуры

Процедура ОтключениеССЕ(Сессия, ИД) Экспорт
	СейчасСмотрят = СейчасСмотрят - 1;

	Сообщение = ФабрикаОтветов.СерверноеСобытие();
	Сообщение.ТипСобытия("watch")
				 .ДобавитьСтроку(Строка(СейчасСмотрят));
	БрокерСообщенийСобытийСервера.ОтправитьСообщениеВсем(ИмяТопика, Сообщение);
КонецПроцедуры

&ТочкаМаршрута("")
Процедура ОсновнаяТочка() Экспорт
	
КонецПроцедуры

&ТочкаМаршрута("postcomment")
Процедура ЗапоститьКомментарий(ТелоЗапросОбъект) Экспорт
	ДобавитьКомментарий(ТелоЗапросОбъект.name, ТелоЗапросОбъект.comment);
КонецПроцедуры

&ТочкаМаршрута("addLike")
Процедура ПоставитьЛайк() Экспорт
	КоличествоЛайков = КоличествоЛайков + 1;
	Попытка
		Сообщение = ФабрикаОтветов.СерверноеСобытие();
		Сообщение.ТипСобытия("like")
				 .ДобавитьСтроку(Строка(КоличествоЛайков));
		БрокерСообщенийСобытийСервера.ОтправитьСообщениеВсем(ИмяТопика, Сообщение);
	Исключение
		Сообщить(ОписаниеОшибки());
	КонецПопытки;
КонецПроцедуры

Процедура ОповеститьОКомментарии(СтрокаКомментария)

	Сообщение = СообщениеИзСтрокиКомментария(СтрокаКомментария);
	
	БрокерСообщенийСобытийСервера.ОтправитьСообщениеВсем(ИмяТопика, Сообщение);

КонецПроцедуры

Функция СообщениеИзСтрокиКомментария(СтрокаКомментария)
	СтрокаШаблон = "<div class='comment'><div class='comment-header'><span class='comment-name'>%1</span> - <span class='comment-date'>%2</span></div>
					|<div class='comment-body'>%3</div></div>";
	Текст = СтрШаблон(СтрокаШаблон, СтрокаКомментария.Имя, СтрокаКомментария.Дата, СтрокаКомментария.Комментарий);

	Сообщение = ФабрикаОтветов.СерверноеСобытие();
	Сообщение.ТипСобытия("newComment")
				.ДобавитьСтроку(Текст);

	Возврат Сообщение;
КонецФункции

Процедура ДобавитьКомментарий(Имя, Комментарий)

	НовыйКомментарий = Комментарии.Добавить();
	НовыйКомментарий.Имя = Имя;
	НовыйКомментарий.Комментарий = Комментарий;
	НовыйКомментарий.Дата = ТекущаяДата();
	
	ОповеститьОКомментарии(НовыйКомментарий);

КонецПроцедуры