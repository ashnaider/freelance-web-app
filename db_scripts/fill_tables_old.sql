
-----FILL TECHNOLOGY----
insert into technology (tech_name) values
	('Python3'),
	('Django'),
	('Flask'),
	('AWS'),
	('PyCharm'),

	('Pandas'),
	('NumPy'),
	('Seaborn'),
	('Tableau'),

	('OpenCV'),
	('Tensorflow'),
	('Keras'),
	('PyTorch'),

	('SQL'),
	('PostgreSQL'),
	('MySQL'),
	('Oracle'),
	('Microsoft SQL Server'),

	('C/C++'),
	('Linux'),
	('Linux Kernel'),
	('FFMPEG'),
	('Bash/Zsh'),
	('GDB'),
	('GCC'),
	('CLang/LLVM'),
	('Visual Studio'),
	('CLion'),

	('Ruby'),
	('RubyOnRails'),

	('HTML'),
	('CSS'),
	('JavaScript'),
	('TypeScript'),
	('React'),
	('Vue'),
	('Angular'),
	('Node.js'),

	('Java'),
	('Spring'),
	('InteliJ'),
	('Kotlin'),
	('Android'),

	('Objective-C'),
	('Swift'),
	('IOS'),

	('C#'),
	('.NET Core'),
	('WinForms'),
	('WPF'),
	('Azure'),

    ('Gradle'),
    ('Docker'),
    ('Kubernetes'),
    ('Jenkins'),
	('git/github')
	;


-----FILL FREELANCER-----
insert into freelancer (first_name, last_name, email, passwd, specialization) values ('Celle', 'Whitlaw', 'cwhitlaw0@patch.com', 'asdfWER45', 'Python developer');
insert into freelancer (first_name, last_name, email, passwd, specialization) values ('Mill', 'Cruddas', 'mcruddas1@wired.com', 'CBrm1TR45', 'Data Analyst');
insert into freelancer (first_name, last_name, email, passwd, specialization) values ('Grigoriy', 'McGorley', 'tmcgorley2@themeforest.net', '72VTsdf1S', 'Front-end developer');
insert into freelancer (first_name, last_name, email, passwd, specialization) values ('Ealasaid', 'Attewill', 'eattewill3@delicious.com', 'Us5HsyXHjtBr', 'Front-end developer');
insert into freelancer (first_name, last_name, email, passwd, specialization) values ('Tammara', 'Folkard', 'tfolkard4@oakley.com', 'i4NYX3qXmZbW', 'Full Stack developer');
insert into freelancer (first_name, last_name, email, passwd, specialization) values ('Guthry', 'Dorian', 'gdorian5@cisco.com', 'c0mv0ds0Nn', 'Back-end .Net developer');
insert into freelancer (first_name, last_name, email, passwd, specialization) values ('Delmar', 'Keems', 'dkeems6@uol.com.br', '9ChyRmZIT1', 'Machine Learning engineer');
insert into freelancer (first_name, last_name, email, passwd, specialization) values ('Abraham', 'McLernon', 'amclernon7@archive.org', 'ZhqHhdf3', 'Data Scientist');
insert into freelancer (first_name, last_name, email, passwd, specialization) values ('Sawyere', 'Moorton', 'smoorton8@goo.ne.jp', '7G6vx7vS', 'Java developer');
insert into freelancer (first_name, last_name, email, passwd, specialization) values ('Ruthy', 'Norwell', 'rnorwell9@tiny.cc', 'TpXZs34l', 'Android developer');
insert into freelancer (first_name, last_name, email, passwd, specialization) values ('Elsa', 'Risman', 'erismana@whitehouse.gov', '6s6u7onQ', 'IOS developer');
insert into freelancer (first_name, last_name, email, passwd, specialization) values ('Giovanni', 'Dunnaway', 'gdunnawayb@over-blog.com', 'CbVG9ZqZsUOx', 'C++ developer');
insert into freelancer (first_name, last_name, email, passwd, specialization) values ('Laural', 'Brun', 'lbrunc@buzzfeed.com', '797IDrmZQb', 'Data Engineer');
insert into freelancer (first_name, last_name, email, passwd, specialization) values ('Malissia', 'Kee', 'mkeed@tmall.com', 'AuieuptGP1', 'Back-end developer');
insert into freelancer (first_name, last_name, email, passwd, specialization) values ('Edvard', 'Swadlen', 'eswadlene@vistaprint.com', 'uWvg234VNI', 'DevOps');
insert into freelancer (first_name, last_name, email, passwd, specialization) values ('Ivan', 'Djmichov', 'gmichovivan@gmail.com', '797IDrm234ZQb', 'DevOps');
insert into freelancer (first_name, last_name, email, passwd, specialization) values ('Valentin', 'Bortnikov', 'bort_val@tmall.com', '234euptGsdfP1', 'DevOps');
insert into freelancer (first_name, last_name, email, passwd, specialization) values ('Nikolay', 'Serebryakov', 'kolya_serebro@gmail.com', 'utWvg234VN234I', 'Java developer');
insert into freelancer (first_name, last_name, email, passwd, specialization) values ('Kostya', 'Merzlyaev', 'kostya_merz@gmail.com', 'sdfj234KJFD', 'Java developer');
insert into freelancer (first_name, last_name, email, passwd, specialization) values ('Misha', 'Lapotkin', 'lapot_misha@gmail.com', 'sldkfjl3245DSfu', 'DevOps');

----FILL TECHNOLOGY STACK-----
insert
    into technology_stack (freelancer_id, technology_id)
        values
            (1, 1),
            (1, 2),
            (1, 3),
            (1, 4),
            (1, 5),
            (1, 14),
            (1, 16),
            (1, 56),

            (2, 1),
            (2, 4),
            (2, 5),
            (2, 6),
            (2, 7),
            (2, 8),
            (2, 9),
            (2, 14),
            (2, 15),

            (3, 31),
            (3, 32),
            (3, 33),
            (3, 35),
            (3, 37),
            (3, 56),

            (4, 31),
            (4, 32),
            (4, 33),
            (4, 34),
            (4, 37),
            (4, 56),

            (5, 29),
            (5, 30),
            (5, 31),
            (5, 32),
            (5, 33),
            (5, 35),
            (5, 36),
            (5, 56),

            (6, 47),
            (6, 48),
            (6, 49),
            (6, 50),
            (6, 51),
            (6, 56),

            (7, 1),
            (7, 4),
            (7, 5),
            (7, 10),
            (7, 11),
            (7, 12),
            (7, 13),
            (7, 20),
            (7, 23),
            (7, 56),

            (8, 1),
            (8, 5),
            (8, 6),
            (8, 7),
            (8, 8),
            (8, 12),
            (8, 14),
            (8, 16),
            (8, 56),

            (9, 39),
            (9, 40),
            (9, 41),
            (9, 31),
            (9, 32),
            (9, 33),
            (9, 56),

            (10, 39),
            (10, 41),
            (10, 42),
            (10, 43),
            (10, 52),
            (10, 31),
            (10, 32),
            (10, 33),
            (10, 56),

            (11, 44),
            (11, 45),
            (11, 46),
            (11, 56),

            (12, 19),
            (12, 20),
            (12, 21),
            (12, 22),
            (12, 23),
            (12, 24),
            (12, 25),
            (12, 28),
            (12, 1),
            (12, 56),

            (13, 1),
            (13, 4),
            (13, 6),
            (13, 14),
            (13, 15),
            (13, 16),
            (13, 18),
            (13, 51),
            (13, 53),
            (13, 56),

            (14, 1),
            (14, 2),
            (14, 3),
            (14, 47),
            (14, 48),
            (14, 56),

            (15, 1),
            (15, 4),
            (15, 14),
            (15, 15),
            (15, 51),
            (15, 52),
            (15, 53),
            (15, 54),
            (15, 55),
            (15, 56),

            (16, 1),
            (16, 4),
            (16, 8),
            (16, 9),
            (16, 19),
            (16, 20),
            (16, 51),
            (16, 53),
            (16, 56),

            (17, 7),
            (17, 4),
            (17, 16),
            (17, 15),
            (17, 20),
            (17, 51),
            (17, 52),
            (17, 55),
            (17, 56),

            (18, 1),
            (18, 2),
            (18, 3),
            (18, 15),
            (18, 20),
            (18, 51),
            (18, 52),
            (18, 56),

            (19, 33),
            (19, 38),
            (19, 4),
            (19, 48),
            (19, 51),
            (19, 52),
            (19, 53),
            (19, 55),
            (19, 56),

            (20, 1),
            (20, 39),
            (20, 14),
            (20, 15),
            (20, 4),
            (20, 20),
            (20, 51),
            (20, 53),
            (20, 54),
            (20, 56)
;



-----FILL CUSTOMER-----
insert into customer (first_name, last_name, login, email, password_, organisation_name) values
    ('Alick', 'Nehls', 'anehls0', 'anehls0@livejournal.com', 'M5hea450', 'Entertainment Gaming Asia Incorporated');

insert into customer (first_name, last_name, login, email, password_, organisation_name) values
    ('Ravi', 'Shillinglaw', 'rshillinglaw1', 'rshillinglaw1@spotify.com', 'TiuFCZ3ujclw', 'Rogers Corporation');

insert into customer (first_name, last_name, login, email, password_, organisation_name) values
    ('Karyn', 'Hargie', 'khargie2', 'khargie2@fema.gov', 'VwirYdtf45xU', 'SunTrust Banks, Inc.');

insert into customer (first_name, last_name, login, email, password_, organisation_name) values
    ('Petrina', 'Cassell', 'pcassell3', 'pcassell3@shutterfly.com', '18R49DFib', 'Herbalife LTD.');

insert into customer (first_name, last_name, login, email, password_, organisation_name) values
    ('Esmaria', 'Tench', 'etench4', 'etench4@topsy.com', 'kXAIwEZ45DG', 'D/B/A Chubb Limited New');

insert into customer (first_name, last_name, login, email, password_, organisation_name) values
    ('Therine', 'Kilgannon', 'tkilgannon5', 'tkilgannon5@hp.com', '2nEF7u23Cid', 'Drive Shack Inc.');

insert into customer (first_name, last_name, login, email, password_, organisation_name) values
    ('Rolph', 'Cottham', 'rcottham6', 'rcottham6@ezinearticles.com', 'fC3YMarFtXF', 'iShares PHLX SOX Semiconductor Sector Index Fund');

insert into customer (first_name, last_name, login, email, password_, organisation_name) values
    ('Marieann', 'Checketts', 'mchecketts7', 'mchecketts7@homestead.com', 'QHgF3CHxw59', 'Nuveen Floating Rate Income Fund');

insert into customer (first_name, last_name, login, email, password_, organisation_name) values
    ('Beulah', 'MacKaig', 'bmackaig8', 'bmackaig8@weibo.com', 'g5rt9Q8h', 'Blackrock Capital and Income Strategies Fund Inc');

insert into customer (first_name, last_name, login, email, password_, organisation_name) values
    ('Amby', 'Tilzey', 'atilzey9', 'atilzey9@addthis.com', 'leQ7YjaXD1ez', 'First Trust Low Duration Opportunities ETF');

insert into customer (first_name, last_name, login, email, password_, organisation_name) values
    ('Ivan', 'Sergeev', 'ivserg1234', 'sergeev_ivan77@gmail.com', 'lzRET453sd', 'ООО ''Рога и Копыта''');

insert into customer (first_name, last_name, login, email, password_, organisation_name) values
    ('Viole', 'Paulon', 'vpaulon0', 'vpaulon0@seattletimes.com', '24abY0dfU', 'Pointer Telocation Ltd.');

insert into customer (first_name, last_name, login, email, password_, organisation_name) values
    ('Mela', 'Canning', 'mcanning1', 'mcanning1@sourceforge.net', 'OgVqJl239', 'J.C. Penney Company, Inc. Holding Company');

insert into customer (first_name, last_name, login, email, password_, organisation_name) values
    ('Alfons', 'Margach', 'amargach2', 'amargach2@cnet.com', 'gfbCoJz234g', 'Gardner Denver Holdings, Inc.');

insert into customer (first_name, last_name, login, email, password_, organisation_name) values
    ('Freddi', 'Sillars', 'fsillars3', 'fsillars3@psu.edu', 'Wne6tIOQ3loP', 'PrivateBancorp, Inc.');

insert into customer (first_name, last_name, login, email, password_, organisation_name) values
    ('Lonnie', 'Self', 'lself4', 'lself4@ucoz.ru', 'eXm2dBBay', 'FormFactor, Inc.');

insert into customer (first_name, last_name, login, email, password_, organisation_name) values
    ('Hasty', 'Diperaus', 'hdiperaus5', 'hdiperaus5@domainmarket.com', 'zgOU1cjjTami', 'Sina Corporation');

insert into customer (first_name, last_name, login, email, password_, organisation_name) values
    ('Jacques', 'Gini', 'jgini6', 'jgini6@vistaprint.com', 'PSE1ANM3FSOg', 'Teekay Tankers Ltd.');

insert into customer (first_name, last_name, login, email, password_, organisation_name) values
    ('Molly', 'Brando', 'mbrando7', 'mbrando7@gov.uk', 'dg2MS6BdCjuk', 'Kimco Realty Corporation');

insert into customer (first_name, last_name, login, email, password_, organisation_name) values
    ('Terrijo', 'Haughton', 'thaughton8', 'thaughton8@tinyurl.com', 'uTwe234KkTD', 'Mattersight Corporation');

insert into customer (first_name, last_name, login, email, password_, organisation_name) values
    ('Patric', 'Hargerie', 'phargerie9', 'phargerie9@dailymail.co.uk', '0cJI4lLclc', 'Fifth Street Asset Management Inc.');



-----FILL NEW-JOB -----
insert into new_job (customer_id, posted, deadline, header_, description, price, hourly_rate)
    values
         (1, '2022-11-10 13:43:12-00', '2023-03-22 18:10:25-00',
               'Сверстать landing page для булочной',
               'Необходимо сверстать лендинг для сети булочных. Дизайн готов и представлен в figma.',
               money(170), 2),

         (2, '2022-11-15 5:30:50-00', '2023-01-4 12:00:00-00',
             'Создать кнопку + прогресс бар(нажал +10% нажал +20% нажал +50% и т.д)',
             'Нужно создать кнопку со ссылкой типо "поделиться". нажав на которую произойдет 2 вещи:' ||
             '1) Всплывет на к примеру VK (стандартная вещь как у всех) на том же яндексе кнопках' ||
             '2) Над кнопкой на прогресс баре появиться значение 10%',

               money(30), 1.7),

        (1, '2022-12-30 06:02:30-00', '2023-02-1 6:10:25-00',
            'Создать одностраничный сайт - Продажа автозапчастей',
            'Создать продающий лендинг, далее будет запускаться контекст' ||
            'Контент есть ',
               money(170), 2),

        (4, '2022-12-26 23:04:10-00', '2023-08-30 23:00:00-00',
            'Создание бэкэнда для сервиса геймификации на Django',
            'Нужно создать бэкэнд для сервиса геймификации на Django ориентируясь на приложенное техническое задание',
               money(378), 3),

        (5, '2022-12-28 04:20:00-00', '2023-02-16 16:30:00-00',
            'Восстановить работу Ebay API',
            ' Есть старый самописный модуль на PHP, лет 5 работавший с Ebay API shopping. После того как Ebay что-то сломал, модуль перестал работать и возвращает ошибку 1199, решения по которой не гуглятся.' ||
            'Задача — или восстановить работу этого модуля, или прикрутить библиотеку на ваш выбор.' ||
            'Все доступы-токены-пароли для Ebay есть.' ||
            'Проект на Гитхабе.',
               money(50), 2),

        (2, '2023-01-14 14:04:20-00', '2023-05-05 00:00:00-00',
            'Доработка мобильного приложения на Kotlin под Android',
            'Нужен разработчик для доработка Android-приложения (Kotlin).\n' ||

            'Нужно реализовать поддержку нескольких новых методов API (бэкэнда) и устранить ряд замечаний по UI. Детали при личном общении.\n' ||

            'Стек: Kotlin, Dagger, RxJava2, Retrofit, Room, Google Maps.',
               money(350), 4),

        (4, '2022-09-29 12:04:10-00', '2023-07-25 20:00:00-6',
            'Ruby проект',
            'Здравствуйте! Мы в поисках рубиста для работы в коммерческом проекте. Стёк: Rails4, ruby 2.4 ActiveAdmin. Если знакомы с webpacker, vue.js, .slim - только плюс. Уровень strong junior або middlе. Больше деталей при обсуждении.',
               money(546), 5),

        (5, '2023-01-01 01:01:10-00', '2023-06-8 12:00:00-00',
            'Бекенд для сбора данных и отправки задач на др.сервер ',
            'Сделать сервис, получающий данные относительно пользовательских файлов, инструкцию относительно того что необходимо сделать с этими данными и отправлять на сервер который работает с этими данными.\n' ||
            '1. Получать запросы от четырех серверов\n' ||
            'Каждый из запросов хорошо сформулирован, сейчас нужно написать инструкцию в постмане на них.\n' ||
            '2. Обрабатывать информацию и сохранять в Postgres\n'||
            '3. Рассчитывать следующие файлы для осуществления работы с ними и отправлять имя, адрес файла и инструкцию о работе. Принимать ответ и записывать его в БД',
               money(770), 6),

        (6, '2022-11-20 16:40:20-00', '2023-03-5 19:50:25-03',
            'Собрать RTSP потоки с 4-х камер и объединить в один',
            'Добрый день. Есть 4ые локальные IP камеры. Требуется собрать с каждой камеры RTSP поток объединить в один, сложив картинки с каждой камеры в ряд и получить один RTSP поток.\n'||
            'Разрешение с каждой камеры желательно HD, битрейт 500-1000, фпс 10-12 ',
               money(350), 4),

        (2, '2022-10-26 19:07:03-00', '2023-09-1 13:13:13-13',
            'Разработать мобильное приложение на Kotlin и Swift ',
            'Нужно создать MVP мобильного на Kotlin (Android), Swift (iOS) + написать серверную часть на GO или Python + базу данных Postgres.\n'||
            'Дизайн и прототип уже готовы.',
               money(950), 5),

        (3, '2022-11-13 13:02:40-00', '2023-04-4 17:23:29-7',
            'Сиздать систему подсчёта хлебов на конвеере',
            'Есть конвеер, на котором едут буханки хлеба, над ним находится камера, зафиксированная в одном положении. ' ||
            'Необходимо производить точный подсчёт продукции.',
               money(850), 10),

        (7, '2022-12-23 20:10:08-00', '2023-08-17 06:10:15-00',
            'Написать мобильное кроссплатформенное приложение для интернет-магазина ',
            'Для интернет-магазина безалкогольных напитков необходимо написать кроссплатформенное мобильное приложение на Android и IOS. Дизайн на стороне заказчика. Мобильное приложение похоже на приложение Азбуки вкуса. \n' ||
            'Методы по API с сайта должны передаваться в мобильное приложение.',
               money(700), 4),

        (8, '2022-12-29 10:30:20-00', '2023-01-19 14:10:27-2',
            'Добавить в docker контейнер поддержку сертификатов Let''s Encrypt',
            'Нужно:\n1. Добавить в процедуру билда докера (скрипт create.sh) параметр "domain", который будет содержать имя домена, и для него генерировать SSL сертификат через Let''s Encrypt внутри докера. Файл сертификата должен размещаться в каталоге /root/cert/. \n'||
            '2. Добавить в cron файл (он уже есть) процедуру обновления сертификата, чтобы он не экспайрился.',
               money(170), 2),

        (9, '2022-12-28 06:20:07-00', '2023-04-12 15:00:30-00',
            'Разработать NLP-модель классификации медицинских текстов',
            'Общая задача: по данным электронной медицинской карты (набор текстов во времени) определить были ли исполнены критерия качества оказания помощи.\n' ||
            'Ограничения: данные в карте могут быть неполными или не соответствовать диагнозу, приемов может быть несколько в рамках лечения одного кейса.',
               money(2200), 14),

        (10, '2022-12-24 15:03:40-00', '2023-05-01 00:10:25-6',
            'Нужно разработать алгоритм автоматического составления расписания ',
            'Нужно разработать алгоритм автоматического составления расписания ориентируясь на приложенное техническое задание',
               money(350), 6),



        (11, '2022-11-29 04:30:50-00', '2023-03-10 12:13:14-5',
            'Ставки на спорт!!',
            'Ставки на спорт!! Высокие коэффициенты!!',
               money(3000), 13),

        (11, '2022-12-05 10:50:20-00', '2023-03-11 14:15:27-00',
            'Быстрый займ!!!',
            'Быстрые займы!!! Нужен только паспорт!!! Низкий процент!!!',
               money(4500), 12),

        (12, '2022-12-17 16:02:08-00', '2023-01-18 19:10:25-07',
            'Взломать страницу ВК',
            'Нужно взломать страницу ВК, ссылку скину в личные сообщения',
               money(150), 8),

        (13, '2022-12-27 12:03:09-00', '2023-02-28 00:00:00-00',
            'Доработать систему оплаты и подмену целевой ссылки в онлайн казино',
            'Имеется онлайн казино, где оплата происходит картой, но при вводе данных, нужно произвести подмену ссылки\n ' ||
            'и перевести пользователя по указанному адресу.',
               money(1000), 10),

         (14, '2022-12-20 21:06:01-00', '2023-04-7 15:00:30-00',
            'Сверстать точную копию сайта Vodafone.ua',
            'Необходимо сверстать точную копию сайта Vodafone.ua и выставить на хостинг с доменом Voodaafone.ue',
               money(700), 6),

         (4, '2022-12-29 13:30:20-00', '2023-03-27',
            'сделать новый фронтенд к продукту (на React или Vue)',
            'Сделать новый фронтенд который будет по сокетам получать и изменять данные в бэке.',
            money(150), 3.5),

         (4, '2022-12-26 16:17:40-00', '2023-04-01',
            'Нужен небольшой микросервис на FastAPI (Python)',
            'Нужен бэк на FastAPI который будет подтягивать данные по REST из одного сервиса, с возможностью записи данных в базу данных.',
            money(300), 4),

        (1, '2022-12-25 09:02:01-00', '2023-02-01',
             'Верстка лендинг пейдж на Тильда',
             'Необходима верстка лендинга на тильде. Лендинг предусматривает товары - без корзины, но с параметрами. см. макет.',
             money(255), 3.5),

        (1, '2022-12-26 07:02:50-00', '2023-03-01',
             'Верстка страницы/лендинга для Адвокатского бюро',
             'Есть шаблон лендинга в фигма, нужно сверстать адаптивный (в т.ч. под мобайл) сайт. За подробностями, пишите',
             money(379), 3.8),

        (1, '2022-12-27 21:19:08-00', '2023-02-25',
             'Разработать приложение под Android для работы с BLE',
             'Необходимо подключаться к устройству, как только оно становится видимым, переподключаться в случае потери связи. Опрашивать службы и отображать информацию. Данные в JSON.',
             money(390), 4),

        (7, '2022-12-28 14:00:30-00', '2023-03-06',
             'Разработать мобильное приложение на ios',
             'нужно разработать мобильное приложение на IOS, по функционалу, идентичное существующему сайту',
             money(250), 5)
;




-----FILL APPLICATION-----
insert into application (date_time, deadline, price, description, freelancer_id, job_id) values
    ('2023-02-04 14:15:27-00', '2023-07-15', money(724), 'Есть большой опыт подобных решений, готов взяться сегодня!', 5, 7);

insert into application (date_time, deadline, price, description, freelancer_id, job_id) values
    ('2023-01-23 12:10:00-00', '2023-12-20', money(350), 'Профессионал с отличной экспертизой. Решу за неделю', 5, 3);

insert into application (date_time, deadline, price, description, freelancer_id, job_id) values
    ('2023-02-13 19:19:03-00', '2023-08-26', money(539), 'Разработчик с опытом 4 года, качественно решу вашу задачу', 10, 12);

insert into application (date_time, deadline, price, description, freelancer_id, job_id) values
    ('2023-02-03 07:09:49-00', '2023-09-17', money(1113), 'Имею обширный опыт построения подобных систем, гарантирую качество и надёжность', 13, 8);

insert into application (date_time, deadline, price, description, freelancer_id, job_id) values
    ('2023-01-21 12:18:00-00', '2023-10-18', money(1222), 'C++ разработчик. Имею опыт работы с высоконагруженными системами и решениями для видеосвязи.', 12, 9);

insert into application (date_time, deadline, price, description, freelancer_id, job_id) values
    ('2023-02-01 14:20:07-00', '2023-05-16', money(400), '2 года опыта в сфере администрирования. Настрою всё по красоте)', 15, 13);

insert into application (date_time, deadline, price, description, freelancer_id, job_id) values
    ('2023-01-22 05:34:29-00', '2023-05-28', money(721), 'Профессиональный IOS разработчик, более 6ти успешных выполненных проектов, много положительных отзывов. Имею сертификат курсов по настройке облачных сервисов', 11, 10);

insert into application (date_time, deadline, price, description, freelancer_id, job_id) values
    ('2023-01-06 20:01:36-00', '2023-07-02', money(420), 'Активный и квалифицированный разработчик, хорошо работаю в команде, 1.5 года опыта как Full stack', 5, 4);

insert into application (date_time, deadline, price, description, freelancer_id, job_id) values
    ('2023-01-17 18:52:23-00', '2023-08-08', money(40), 'Знаю HTML, CSS и JS. Готов решить вашу пролему. Пишите, договоримся', 3, 2);

insert into application (date_time, deadline, price, description, freelancer_id, job_id) values
    ('2023-01-08 13:31:13-00', '2023-11-24', money(51), 'Ранее занимался разработкой API и имею достоаточную экспертизу. Предоставлю решение в кратчайшие сроки', 9, 5);

insert into application (date_time, deadline, price, description, freelancer_id, job_id) values
    ('2023-02-04 19:23:59-00', '2023-07-15', money(175), 'Я фронтенд разработчик, хорошо знаю технологии, работу сделаю качественно', 4, 3);

insert into application (date_time, deadline, price, description, freelancer_id, job_id) values
    ('2023-01-23 15:23:46-00', '2023-12-20', money(2617), 'Фронтенд разработчик, разбираюсь в вопросе хорошо, сделаю быстро', 4, 7);

insert into application (date_time, deadline, price, description, freelancer_id, job_id) values
    ('2023-01-15 10:34:42-00', '2023-02-15', money(165), 'Есть опыт создания подобных сервисов. Могу разместить сайт на облачных серверах',
     19, 3);

insert into application (date_time, deadline, price, description, freelancer_id, job_id) values
    ('2023-01-02 17:23:19-00', '2023-01-15', money(225), 'Имею общирный опыт разработчки решений, основанных на облачных сервисах. Владею docker',
     18, 13);

insert into application (date_time, deadline, price, description, freelancer_id, job_id) values
    ('2023-01-20 11:28:09-00', '2023-03-02', money(53), 'Долго работал с настройкой облачных технологий для государственных сервисов. Займусь вашей проблемой',
     17, 5);

insert into application (date_time, deadline, price, description, freelancer_id, job_id) values
    ('2023-01-15 08:34:38-00', '2023-02-28', money(180), 'Помогу решить вашу задачу, если что, могу прикрутить облачное хранилище или другие сервисы',
     16, 13);

insert into application (date_time, deadline, price, description, freelancer_id, job_id) values
    ('2023-01-13 18:51:06-00', '2023-03-03', money(196), 'Эксперт в области облачных сервисов. Быстро и качественно помогу вам с вашей задачей',
     20, 13);

insert into application (date_time, deadline, price, description, freelancer_id, job_id) values
    ('2023-01-10 17:31:06-00', '2023-03-10', money(280), 'Отлично разбираюсь в тильда, сделаю шикарный лендинг',
     3, 23);

insert into application (date_time, deadline, price, description, freelancer_id, job_id) values
    ('2023-01-02 12:13:09-00', '2023-03-29', money(450), 'Делал много андроид приложений, быстро реализую любые пожелания',
     10, 25);

insert into application (date_time, deadline, price, description, freelancer_id, job_id) values
    ('2023-01-10 17:31:06-00', '2023-03-10', money(280), 'Знаю React и создавал на нём различного уровня сложности проекты. Работаю самостоятельно',
     5, 21);

insert into application (date_time, deadline, price, description, freelancer_id, job_id) values
    ('2023-01-02 12:13:09-00', '2023-03-29', money(450), 'Обширный опыт разработки на Python, в совершенстве владею API',
     1, 22);

insert into application (date_time, deadline, price, description, freelancer_id, job_id) values
    ('2023-01-18 19:27:00-00', '2023-04-25', money(450), 'Android разработчк с большим опытом. Работал как в стартапе так и в корпорации. Работаю быстро',
     10, 6);


------FILL MESSAGE_ ------
insert into message_ (date_time, is_from_customer, text_message, freelancer_id, job_id) values
    ('2023-01-25 14:10:00-00', false, 'Здравствуйте, можете поподробнее рассказать о проблеме?', 4, 1);

insert into message_ (date_time, is_from_customer, text_message, freelancer_id, job_id) values
    ('2022-01-25 14:15:00-00', true, 'Здравствуйте, конечно! Есть сеть магазинов выпечки, нужно сделать сайт.', 4, 1);

insert into message_ (date_time, is_from_customer, text_message, freelancer_id, job_id) values
    ('2023-01-26 8:10:00-00', false, 'А какого типа сайт нужен, landing page? Сколько страниц должно быть', 4, 1);

insert into message_ (date_time, is_from_customer, text_message, freelancer_id, job_id) values
    ('2023-01-26 9:49:00-00', true, 'Страниц 5-6. Стандартные: главная, о нас, продукция, контакты и т.д.', 4, 1);



insert into message_ (date_time, is_from_customer, text_message, freelancer_id, job_id) values
    ('2023-02-03 02:16:07-00', false, 'Добрый день, какой фреймворк используется на сайте?', 3, 2);

insert into message_ (date_time, is_from_customer, text_message, freelancer_id, job_id) values
    ('2023-02-03 02:25:08-00', true, 'Здравствуйте, мы используем vue.js', 3, 2);

insert into message_ (date_time, is_from_customer, text_message, freelancer_id, job_id) values
    ('2023-02-03 02:59:15-00', false, 'Можете скинуть чёткое ТЗ и архив сайта?', 3, 2);

insert into message_ (date_time, is_from_customer, text_message, freelancer_id, job_id) values
    ('2023-02-03 03:18:19-00', true, 'Киньте вашу почту', 3, 2);

insert into message_ (date_time, is_from_customer, text_message, freelancer_id, job_id) values
    ('2023-02-03 04:01:35-00', false, 'вот моя почта: tmcgorley2@themeforest.net', 3, 2);

insert into message_ (date_time, is_from_customer, text_message, freelancer_id, job_id) values
    ('2023-02-03 08:20:01-00', true, 'Отправил, проверяйте, если будут вопросы, пишите', 3, 2);

insert into message_ (date_time, is_from_customer, text_message, freelancer_id, job_id) values
    ('2023-02-03 12:41:15-00', false, 'Это финальная версия, или будут вноситься правки?', 3, 2);



insert into message_ (date_time, is_from_customer, text_message, freelancer_id, job_id) values
    ('2023-02-23 12:20:15-00', false, 'Добрый вечер, готов сделать за неделю.', 4, 3);

insert into message_ (date_time, is_from_customer, text_message, freelancer_id, job_id) values
    ('2023-02-24 13:40:15-00', false, 'Здравствуйте, в каком формате дизайн и на каком фреймворке готов прототип?', 10, 10);

insert into message_ (date_time, is_from_customer, text_message, freelancer_id, job_id) values
    ('2023-02-25 02:30:45-00', false, 'Добрый день, какие требования к модели и какие данные есть?', 7, 14);

insert into message_ (date_time, is_from_customer, text_message, freelancer_id, job_id) values
    ('2023-02-26 18:00:15-00', false, 'Здравствуйте, готов приступить к разработке IOS приложения. Можете выслать ТЗ?', 11, 10);

insert into message_ (date_time, is_from_customer, text_message, freelancer_id, job_id) values
    ('2023-02-27 12:20:01-00', true, 'Добрый вечер, заинтересовала ваша заявка, когда сможете приступить к проекту?', 5, 13);


----FILL PROJECT_DONE----
insert into project_done (date_start, date_finish, freelancer_id, job_id, freelancer_review, customer_review)
    values ('2023-02-21', '2023-11-21', 5, 3, 'Приятный человек, поставляет хорошие ТЗ', 'Профессионал своего дела');

insert into project_done (date_start, date_finish, freelancer_id, job_id, freelancer_review, customer_review)
    values ('2023-01-12', '2023-07-13', 5, 4, 'Ответственный заказчик, своевременная оплата', 'Исполнительный и старательный разработчик');

insert into project_done (date_start, date_finish, freelancer_id, job_id, freelancer_review, customer_review)
    values ('2023-02-22', '2023-11-20', 10, 12, 'Хороший человек, спокойно объясняет правки', 'Медлительный но внимательный специалист');

insert into project_done (date_start, date_finish, freelancer_id, job_id, freelancer_review, customer_review)
    values ('2023-04-01', '2023-06-29', 13, 8, 'Безответственный заказчик, постоянно куда-то пропадает', 'Непунктуальный разработчик, не соблюдает тайминги');

insert into project_done (date_start, date_finish, freelancer_id, job_id, freelancer_review, customer_review)
    values ('2023-03-19', '2023-08-25', 12, 9, 'Нормальный заказчик, но периодически не отвечает на смс', 'Назойливый и грубоватый разработчик, постоянно пишет');

insert into project_done (date_start, date_finish, freelancer_id, job_id, freelancer_review, customer_review)
    values ('2023-01-20', '2023-02-20', 3, 23, 'Приятный заказчик, профессионал своего дела', 'Трудолбивый и старательный исполнитель');

insert into project_done (date_start, date_finish, freelancer_id, job_id, freelancer_review, customer_review)
    values ('2023-01-09', '2023-02-20', 10, 25, 'Приятный заказчик, профессионал своего дела', 'Трудолбивый и старательный исполнитель');

insert into project_done (date_start, date_finish, freelancer_id, job_id, freelancer_review, customer_review)
    values ('2023-01-25', '2023-05-26', 4, 7, 'Обходительный человек, готов пойти на встречу', 'Исполнитель внимательный и понимающий');

insert into project_done (date_start, date_finish, freelancer_id, job_id, freelancer_review, customer_review)
    values ('2023-01-12', '2023-04-04', 5, 21, 'Очень переменчивый заказчик, вносит много правок', 'Терпеливый исполнитель, но затягивает со сроками');

insert into project_done (date_start, date_finish, freelancer_id, job_id, freelancer_review, customer_review)
    values ('2023-01-25', '2023-05-26', 1, 22, 'Всегда занятой и нервный, но платит нормально', 'Хороший исполнитель');

insert into project_done (date_start, date_finish, freelancer_id, job_id, freelancer_review, customer_review)
    values ('2023-01-23', '2023-05-01', 10, 6, 'Спокойный и адекватный заказчик, хорошо объясняет требования', 'Профессиональный разработчк, решает всё в срок и экономит бюджет');




-- 	'inappropriate_content',
-- 	'fraud',
-- 	'illegal_actions',
--     'spam',
-- 	'other'

----FILL JOB_COMPLAINT----
insert into job_complaint (date_time, complaint_type, description, freelancer_id, job_id) values
    ('2023-04-17 16:39:23', 'spam', 'Спам-реклама ставок на спорт', 6, 16);

insert into job_complaint (date_time, complaint_type, description, freelancer_id, job_id) values
    ('2023-02-03 21:56:58', 'fraud', 'Реклама микрокредитов в качестве объявления', 2, 17);

insert into job_complaint (date_time, complaint_type, description, freelancer_id, job_id) values
    ('2023-02-23 08:28:04', 'spam', 'Администрация, вы куда смотрите? у вас спам по объявлениям гуляет', 12, 16);

insert into job_complaint (date_time, complaint_type, description, freelancer_id, job_id) values
    ('2023-01-06 07:30:49', 'illegal_actions', 'Размещено объявление, цель которого нарушить право '||
                                               'на личную переписку и доступ к личным данным', 9, 18);

insert into job_complaint (date_time, complaint_type, description, freelancer_id, job_id) values
    ('2023-06-22 17:15:03', 'fraud', 'Заказ для казино, для подмены ссылки и обмана пользователей, '||
                                     'админ, удали объявление', 1, 19);

insert into job_complaint (date_time, complaint_type, description, freelancer_id, job_id) values
    ('2023-07-26 11:51:47', 'other', 'Неадекватоне задание. Решение NP-полной задачи, вы серьезно?', 8, 15);

insert into job_complaint (date_time, complaint_type, description, freelancer_id, job_id) values
    ('2023-07-14 19:00:39', 'spam', 'Реклама ставок, удалите объявление', 11, 16);

insert into job_complaint (date_time, complaint_type, description, freelancer_id, job_id) values
    ('2023-07-31 05:33:16', 'spam', 'У вас там объявление с рекламой микрокредитов, примите меры', 7, 17);

insert into job_complaint (date_time, complaint_type, description, freelancer_id, job_id) values
    ('2023-08-29 07:49:32', 'fraud', 'Заказчик, очевидно, занимается обманом людей с помощью онлайн казино, заблокируйте заказчика', 6, 19);

insert into job_complaint (date_time, complaint_type, description, freelancer_id, job_id) values
    ('2023-11-26 23:01:40', 'illegal_actions', 'Администрация, тут человек просит сделать копию сайта, ' ||
                                               'и разместить на домене, похожим на оригинальный. ' ||
                                               'Похоже на фишинговый сайт. Разберитесь, пожалуйста', 12, 20);



----FILL USER_COMPLAINT-----
insert into user_complaint (date_time, is_from_customer, complaint_type, description, customer_id, freelancer_id)
    values ('2023-02-02 06:44:36', false, 'fraud', 'Человек обманывает и кидает людей. На звонки и смс не отвечает', 4, 9);

insert into user_complaint (date_time, is_from_customer, complaint_type, description, customer_id, freelancer_id)
    values ('2023-03-04 20:04:51', false, 'spam', 'Заказчик неадекватный, требует выполнить работу за копейки, хотя я даже не подавал заявку', 8, 2);

insert into user_complaint (date_time, is_from_customer, complaint_type, description, customer_id, freelancer_id)
    values ('2023-01-03 18:41:19', false, 'illegal_actions', 'Заказчик предлагает провести оплату окольными путями, в обход налогов', 10, 5);

insert into user_complaint (date_time, is_from_customer, complaint_type, description, customer_id, freelancer_id)
    values ('2023-01-07 17:49:14', true, 'inappropriate_content', 'У исполнителя неприемливое фото на аватарке и странный ник', 1, 4);

insert into user_complaint (date_time, is_from_customer, complaint_type, description, customer_id, freelancer_id)
    values ('2023-01-01 23:25:52', true, 'spam', 'Исполнитель слишком навящивый, написывает о исполнении проекта, хотя я даже его не подтверждал', 2, 11);

insert into user_complaint (date_time, is_from_customer, complaint_type, description, customer_id, freelancer_id)
    values ('2023-01-03 15:02:06', true, 'spam', 'Человек просто неадекватный, не умеет общаться с людьми', 10, 18);

insert into user_complaint (date_time, is_from_customer, complaint_type, description, customer_id, freelancer_id)
    values ('2023-01-06 06:12:51', true, 'spam', 'Исполнитель флудит', 1, 9);

insert into user_complaint (date_time, is_from_customer, complaint_type, description, customer_id, freelancer_id)
    values ('2023-01-06 06:12:51', true, 'fraud', 'Присылает на e-mail фишинговые ссылки', 7, 8);