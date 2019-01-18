#Использовать "../src"
#Использовать asserts

Перем ЮнитТест;
Перем ТокенАвторизации;

Функция ПолучитьСписокТестов(Знач Тестирование) Экспорт
	
	ЮнитТест = Тестирование;	
	
	ИменаТестов = Новый Массив;
	ИменаТестов.Добавить("ТестДолжен_ПроверитьОтправкуФайлаБезСессии");
	ИменаТестов.Добавить("ТестДолжен_ПроверитьОтправкуФайлаЧерезСессию");
	
	Возврат ИменаТестов;
	
КонецФункции

Процедура ПередЗапускомТеста() Экспорт
	
	// токен апи из файла, если нет нужно создать.
	ИмяФайла = ОбъединитьПути(ТекущийСценарий().Каталог, "..", "features", "token.txt");
	ТД = Новый ТекстовыйДокумент();
	ТД.Прочитать(ИмяФайла);
	ТокенАвторизации = ТД.ПолучитьТекст();
	ТД = Неопределено;
	
КонецПроцедуры

Процедура ТестДолжен_ПроверитьОтправкуФайлаБезСессии() Экспорт
	
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла("txt");
	ТекстовыйДокумент = Новый ТекстовыйДокумент();
	ТекстовыйДокумент.УстановитьТекст("ТестДолжен_ПроверитьОтправкуФайлаБезСессии " + ТекущаяДата());
	ТекстовыйДокумент.Записать(ИмяВременногоФайла, КодировкаТекста.Системная);
	
	Клиент = Новый Dropbox();
	Клиент.УстановитьТокенАвторизации(ТокенАвторизации);
	ОбъектDB = Клиент.ОтправитьФайл(ИмяВременногоФайла, "/ТестДолжен_ПроверитьОтправкуФайлаБезСессии2.txt");
	
	Утверждения.Проверить(ОбъектDB.Идентификатор <> Неопределено, "Не удалось отправить файл в dropbox без сессии (объект dropbox)");

	ОбъектDB = Новый ОбъектDropbox();
	ОбъектDB.Путь = ИмяВременногоФайла;
	ОбъектDB = Клиент.ОтправитьФайл(ОбъектDB, "/ТестДолжен_ПроверитьОтправкуФайлаБезСессии2.txt");

	Утверждения.Проверить(ОбъектDB.Идентификатор <> Неопределено, "Не удалось отправить файл в dropbox без сессии (путь к файлу)");
	
	Попытка
		УдалитьФайлы(ИмяВременногоФайла);
	Исключение	
	КонецПопытки;

КонецПроцедуры

Процедура ТестДолжен_ПроверитьОтправкуФайлаЧерезСессию() Экспорт
	
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла("txt");
	ТекстовыйДокумент = Новый ТекстовыйДокумент();
	ТекстовыйДокумент.УстановитьТекст("ТестДолжен_ПроверитьОтправкуФайлаЧерезСессию " + ТекущаяДата());
	ТекстовыйДокумент.Записать(ИмяВременногоФайла, КодировкаТекста.Системная);
	
	Клиент = Новый Dropbox();
	Клиент.УстановитьТокенАвторизации(ТокенАвторизации);
	ОбъектDB = Клиент.ОтправитьФайл(
		ИмяВременногоФайла, 
		"/ТестДолжен_ПроверитьОтправкуФайлаЧерезСессию.txt",
		Истина); // через сессию
	
	Утверждения.Проверить(ОбъектDB.Идентификатор <> Неопределено, "Не удалось отправить файл в dropbox через сессию (объект dropbox)");

	ОбъектDB = Новый ОбъектDropbox();
	ОбъектDB.Путь = ИмяВременногоФайла; 
	ОбъектDB = Клиент.ОтправитьФайл(
		ОбъектDB, 
		"/ТестДолжен_ПроверитьОтправкуФайлаЧерезСессию.txt",
		Истина); // через сессию
	
	Утверждения.Проверить(ОбъектDB.Идентификатор <> Неопределено, "Не удалось отправить файл в dropbox через сессию (путь к файлу)");

	Попытка
		УдалитьФайлы(ИмяВременногоФайла);
	Исключение	
	КонецПопытки;
	
КонецПроцедуры