import "dart:math";
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:universal_io/io.dart' as universal_io;

List<Map> globalPredict = [
  {'message': '[ПЬЯНЫЙ] [МУЖЧИНА]', 'sex': 'm'},
  {'message': '[ПЬЯНАЯ] [ЖЕНЩИНА]', 'sex': 'f'},
  {'message': '[ПЬЯНЫЕ] [ЛЮДИ]', 'sex': 'plural'},
  {'message': '[ДВЕ] [ПЬЯНЫЕ] [ЖЕНЩИНЫ]', 'sex': 'plural'},
  {'message': '[ПЬЯНЫЙ] [МУЖЧИНА] из [ГОРОДА]', 'sex': 'm'},
  {'message': '[ПЬЯНАЯ] [ЖЕНЩИНА] из [ГОРОДА]', 'sex': 'f'},
  {'message': '[ПЬЯНЫЕ] [ЛЮДИ] из [ГОРОДА]', 'sex': 'plural'},
  {'message': '[ДВЕ] [ПЬЯНЫЕ] [ЖЕНЩИНЫ] из [ГОРОДА]', 'sex': 'plural'},
  {'message': '[ПЬЯНЫЙ] [МУЖЧИНА] из [ГОРОДА], [РАСЧЛЕНИВШИЙ]', 'sex': 'm'},
  {'message': '[ШКОЛЬНИК]', 'sex': 'm'},
  {'message': '[ШКОЛЬНИЦА]', 'sex': 'f'},
  {'message': '[ДВЕ] [ШКОЛЬНИЦЫ]', 'sex': 'plural'},
  {'message': '[ШКОЛЬНИК] из [ГОРОДА]', 'sex': 'm'},
  {'message': '[ШКОЛЬНИЦА] из [ГОРОДА]', 'sex': 'f'},
  {'message': '[ДВЕ] [ШКОЛЬНИЦЫ] из [ГОРОДА]', 'sex': 'plural'},
  {'message': 'В [ГОРОДЕ] [ПЬЯНЫЙ] [МУЖЧИНА]', 'sex': 'm'},
  {'message': 'В [ГОРОДЕ] [ПЬЯНАЯ] [ЖЕНЩИНА]', 'sex': 'f'},
  {'message': 'В [ГОРОДЕ] [ПЬЯНЫЕ] [ЛЮДИ]', 'sex': 'plural'},
  {'message': 'В [ГОРОДЕ] [ДВЕ] [ПЬЯНЫЕ] [ЖЕНЩИНЫ]', 'sex': 'plural'},
  {'message': 'В [ГОРОДЕ] [ГРУППА_МУЖЧИН]', 'sex': 'plural'},
  {'message': 'В [ГОРОДЕ] [ШКОЛЬНИК]', 'sex': 'm'},
  {'message': 'В [ГОРОДЕ] [ШКОЛЬНИЦА]', 'sex': 'f'},
  {'message': 'В [ГОРОДЕ] [ДВЕ] [ШКОЛЬНИЦЫ]', 'sex': 'plural'},
  {'message': '[ПЬЯНЫЙ] [ЖИТЕЛЬ] [ГОРОДА]', 'sex': 'm'},
  {'message': '[ПЬЯНАЯ] [ЖИТЕЛЬНИЦА] [ГОРОДА]', 'sex': 'f'},
  {'message': '[ПЬЯНЫЕ] [ЖИТЕЛИ] [ГОРОДА]', 'sex': 'plural'},
  {'message': '[ПЬЯНЫЙ] [ОМИЧ]', 'sex': 'm'},
  {'message': '[ПЬЯНЫЙ] [ОМИЧ], [РАСЧЛЕНИВШИЙ]', 'sex': 'm'},
  {'message': '[ПЬЯНЫЙ] [ОМИЧ] [С_ПРЕДМЕТОМ]', 'sex': 'm'},
  {'message': '[МУЖЧИНА]', 'sex': 'm'},
  {'message': '[ЛЮДИ]', 'sex': 'plural'},
  {'message': '[ЖЕНЩИНА]', 'sex': 'f'},
  {'message': '[ЖЕНЩИНЫ]', 'sex': 'plural'},
  {'message': '[ШКОЛЬНИК]', 'sex': 'm'},
  {'message': '[ШКОЛЬНИЦА]', 'sex': 'f'},
  {'message': '[ОДНА_ПЛЮС_ОДНА]', 'sex': 'plural'},
  {'message': '[ДВА] студента [ВУЗА]', 'sex': 'plural'},
];

Map<String, List> globalSets = {
  'МУЖЧИНА': [
    'азиат',
    'болельщик из стоп-листа ФСБ',
    'дебошир',
    'домушник',
    'тунеядец',
    'пенсионер с простреленной ногой',
    'баскетболист местного клуба',
    'азиат',
    'бизнесмен',
    'ветеран ВОВ',
    'Водитель [КАМАЗА]',
    'вор-форточник',
    'грузчик',
    'дворник',
    'директор зоопарка',
    'извращенец',
    'инвалид',
    'лысый самоубийца',
    'меценат',
    'миллионер',
    'министр',
    'мормон',
    'мужчина',
    'наркоман',
    'нищий',
    'охотник',
    'парень',
    'пенсионер',
    'пивовар',
    'пиротехник-самоучка',
    'пожилой учитель',
    'полицейский',
    'Председатель колхоза',
    'лейтенант',
    'программист',
    'протоиерей',
    'рабочий',
    'разнорабочий',
    'азиат',
    'рыбак',
    'сантехник',
    'сатанист',
    'священник',
    'сотрудник росгвардии',
    'социальный работник',
    'судья',
    'телеведущий',
    'транссексуал',
    'футболист',
    'хозяин конопляной лаборатории',
    'чеченец',
    'экспедитор',
    'поджигатель сараев',
  ],
  'МУЖЧИНЫ': [
    'адвокаты',
    'алгоголики',
    'бывшые заключенные',
    'коммунальщики',
    'наркоманы',
    'оппозиционеры',
    'преступники',
    'участники преступной группировки',
  ],
  'ГРУППА_МУЖЧИН': [
    'группа молодых людей',
    'группа томичей',
    'двое чеченцев',
  ],
  'ШКОЛЬНИК': [
    'детдомовец',
    'малолетний вредитель',
    'мальчик',
    'молодой человек',
    'подросток',
    'парень',
    'третьеклассник',
    'четвероклассник',
    'школьник',
  ],
  'ЖЕНЩИНА': [
    'владелица мебельного цеха',
    'воспитательница',
    'двукратная олимпийская чемпионка',
    'жена',
    'женщина',
    'женщина лёгкого поведения',
    'журналистка',
    'известная биатлонистка',
    'мошенница',
    'пенсионерка',
    'писательница',
    'посетительница салона красоты',
    'пьяная продавщица',
    'сотрудница свердловской железной дороги',
    'старушка',
    'уборщица ночного клуба',
    'учительница',
    'учительница физкультуры',
  ],
  'ЖЕНЩИНЫ': [
    'девушки',
    'мошенницы-гипнотизерши',
    'пенсионерки',
    'писательницы',
    'проститутки',
    'пьяные продавщицы',
    'учительницы',
    'посетительницы салона красоты',
    'студентки',
    'старушки',
    'женщины лёгкого поведения',
  ],
  'ШКОЛЬНИЦА': [
    'воспитанница детского дома',
    'девочка',
    'девушка',
    'отличница',
    'студентка',
    'школьница',
  ],
  'ШКОЛЬНИЦЫ': [
    'воспитанницы детского дома',
    'девочки',
    'девушки',
    'отличницы',
    'студентки',
    'школьницы',
  ],
  'ОДНА_ПЛЮС_ОДНА': [
    'беременная женщина с напарницей',
  ],
  'ЖИТЕЛЬ': [
    'глава администрации',
    'Депутат',
    'житель',
    'мэр',
    'почётный гражданин',
    'экс-мэр',
    'экс-прокурор',
  ],
  'ЖИТЕЛЬНИЦА': [
    'жительница',
    'уроженка',
  ],
  'ЖИТЕЛИ': [
    'жители',
    'двое жителей',
    'уроженцы',
  ],
  'МУЖА': ['мужа', 'свекровь', 'сестру'],
  'ОМИЧ': [
    'Донской казак',
    'Казах',
    'Кемеровчанин',
    'Китаец',
    'Нанаец',
    'Немец',
    'Омич',
    'Череповчанин',
    'Харьковчанин',
    'Ярославец',
  ],
  'ОМИЧИ': [
    'Омичи',
  ],
  'ПЕНСИОНЕРОВ': [
    'азиатов',
    'домушников',
    'тунеядцев',
    'баскетболистов местного клуба',
    'бизнесменов',
    'ветеранов ВОВ',
    'водителей',
    'грузчиков',
    'дворников',
    'детдомовцев',
    'жителей коттеджного посёлка',
    'молодых людей',
    'мормонов',
    'мужчин',
    'наркоманов',
    'нищих',
    'охотников',
    'пенсионеров',
    'подростков',
    'пожилых учителей',
    'полицейских',
    'свидетелей иеговы',
    'прихожан местной церкви',
    'программистов',
    'рабочих',
    'рыбаков',
    'сантехников',
    'сатанистов',
    'священников',
    'социальных работников',
    'футболистов',
    'чеченцев',
    'школьников',
  ],
  'ЛЮДИ': [
    'активисты Навального',
    'зоозащитники',
    'пожарные',
    'неизвестные',
    'полицейские',
    'посетители кафе',
    'украинские рыбаки',
    'фанаты макса коржа',
    'хакеры',
  ],
  'СОСЕДА': [
    '',
    'гуся',
    'двух павлинов',
    'двух прохожих',
    'двух студенток',
    'депутата',
    'козу',
    'корову',
    'кошку',
    'несколько зевак',
    'полицейского',
    'прохожего',
    'собаку',
    'соседа',
  ],
  'С_ПРЕДМЕТОМ': [
    'с лазерной указкой',
    'с топором',
  ],
  'ПУТИНЫМ': [
    'медведевым',
    'президентом',
    'губернатором',
    'путиным',
    'премьер-министром Канады'
  ],
  'ЖЕНУ': ['ТЁЩУ', 'ЖЕНУ'],
  'КАМАЗА': [
    'автобуса',
    'белаза',
    'буксира',
    'камаза',
    'катка',
    'маршрутки',
    'мусоровоза',
    'скорой помощи',
    'трамвая',
  ],
  'МАРШРУТКУ': [
    'бетономешалку',
    'катафалк',
    'патрульный катер',
    'ПОЕЗД',
    'танк-экспонат времен ВОВ',
    'трамвай',
    'трактор',
    'троллейбус',
  ],
  'ГОРОДА': [
    'Амурской области',
    'Бобруйска',
    'Бурятии',
    'Владимирской области',
    'Воронежа',
    'Донецка',
    'Иваново',
    'Кавказа',
    'Калининграда',
    'Китая',
    'Колонии-поселения',
    'Костромы',
    'Кузбасса',
    'Крыма',
    'Мурманска',
    'Подмосковья',
    'Прибалтики',
    'Приморья',
    'Санкт-Петербурга',
    'Саратова',
    'Сочи',
    'Ставрополья',
    'Ульяновска',
    'Узбекистана',
    'Хабаровска',
    'Якутии',
    'Ярославской области',
    'анадыря',
    'большого камня',
    'владивостока',
    'калужской области',
    'коттеджного посёлка',
    'крыма',
    'новороссийска',
    'провинциального городка',
    'тюмени',
    'челябинска',
    'якутска',
  ],
  'САРАТОВСКИЙ': [
    'бобруйский',
    'кемеровский',
    'саратовский',
    'тверской',
  ],
  'САРАТОВСКАЯ': [
    'хабаровская',
    'иркутская',
    'московская',
    'краснодарская',
  ],
  'САРАТОВСКИЕ': [
    'новосибирские',
    'владивостокские',
    'сахалинские',
    'ростовские',
    'минские',
    'киевские',
  ],
  'ГОРОДЕ': [
    'Амурске',
    'Баку',
    'Воронеже',
    'Грозном',
    'Дальнегорске',
    'Екатеринбурге',
    'Краснодаре',
    'Казани',
    'Киргизстане',
    'Луганске',
    'Магадане',
    'Новосибирске',
    'Оренбурге',
    'Петербурге',
    'Реутове',
    'Самаре',
    'Ташкенте',
    'Узбекистане',
    'Челябинске',
    'Чите',
  ],
  'СОБАКУ': [
    'СОБАКУ',
    'ЯЩИК ВОДКИ',
    'ламу',
    'льва из местного цирка',
    'деньги дольщиков',
    'теленка',
    'более сотни коров'
  ],
  'СВОЕГО_ЛЮБИМЦА': [
    'СОБАКУ',
    'ЯЩИК ВОДКИ',
    'любимого котёнка',
    'домашнего фазана',
    'деньги дольщиков',
    'теленка',
    'инвалида'
  ],
  'ПЬЯНЫЙ': ['пьяный', 'пожилой'],
  'ПЬЯНАЯ': ['пьяная', 'пожилая'],
  'ПЬЯНЫЕ': ['пьяные', 'пожилые'],
  'НАДРУГАЛАСЬ': ['надругалась'],
  'ЛИШИЛСЯ': [
    'автомобиля',
    'волос',
    'денег',
    'документов',
    'жилища',
    'ноги',
    'пальца',
    'полового органа',
    'руки',
  ],
  'УБИЛИ': [
    'задушили',
    'зарезали',
    'застрелили',
    'казнили',
    'осквернили',
    'подожгли',
    'ранили',
    'убили',
    'унизили',
    'утопили'
  ],
  'УБИЛА': [
    'убила',
    'ранила',
    'казнила',
    'унизила',
    'осквернила',
    'застрелила',
    'задушила',
    'утопила',
    'зарезала'
  ],
  'УБИЛ': [
    'убил ',
    'ранил ',
    'казнил ',
    'унизил ',
    'осквернил ',
    'застрелил ',
    'задушил',
    ' утопил ',
    'зарезал'
  ],
  'ВЗОРВАЛ': ['взорвал', 'поджёг', 'расстрелял'],
  'ВЗОРВАЛА': ['взорвала', 'подожгла', 'расстреляла'],
  'ВЗОРВАЛИ': ['взорвали', 'подожгли', 'расстреляли'],
  'УБИТЬ': ['НАПУГАТЬ', 'УБИТЬ'],
  'ВЕРНУТЬ_М': ['супругу', 'сожительницу', 'жену', 'девушку', 'честь семьи'],
  'ВЕРНУТЬ_Ж': [
    'супруга',
    'сожителя',
    'мужа',
    'ребёнка-наркомана из клиники',
    'честь семьи'
  ],
  'СЛУЧАЙНО': ['случайно', '', '', '', ''],
  'ДВА': ['Два', 'Три'],
  'ДВЕ': ['Две', 'Три'],
  'БУДКУ': [
    'свой гараж',
    'гаражный кооператив',
    'самогонный аппарат',
    'рекламный щит',
    'трансформаторную будку',
    'беседку с молодежью'
  ],
  'ВУЗА': ['филфака МГУ', 'Гнесинки'],
  'РАСЧЛЕНИВШИЙ': [
    'зверски расчленивший соседа',
    'зверски расчленивший лягушку',
    'избивший инвалида',
    'сломавший мужчине ключицу',
    'стрелявший в прохожих из окна',
  ],
};

Map<String, List> globalAction = {
  'm': [
    '[ВЗОРВАЛ] [БУДКУ]',
    'боролся с неприятным запахом в туалете',
    'взял в заложницы тещу',
    'вломился в чужой дом',
    'выстрелил в сожительницу из ружья',
    'выстрелил мужчине в глаз',
    'готовил ужин',
    'залез в дом пенсионерки',
    'в порыве страсти зарезал собутыльницу',
    'заготовил на зиму 3 кг марихуаны',
    'записался на шугаринг',
    'захватил сосны на участке соседей',
    'зашел в строительную фирму',
    'избил несовершеннолетнего',
    'изнасиловал кондуктора',
    'изнасиловал коллектора',
    'купил аккордеон',
    'напал на офис микрозаймов',
    'напоил кота самогонкой',
    'нашёл две гранаты',
    'незаконно охотился на косуль',
    'обесточил посёлок',
    'ОБЛИЛСЯ БЕНЗИНОМ, ЗАГОРЕЛСЯ',
    'обнаружил в подвале скелет',
    'ограбил автомат с игрушками',
    'ограбил супругов, приютивших его на ночь',
    'отравился этанолом',
    'ПОДЖЕГ СВОИ ДОКУМЕНТЫ',
    'поджёг не ту аптеку',
    'подорвался на корпоративе',
    'позарился на самокат соседа',
    'попался на краже велосипеда',
    'поссорился с бабушкой',
    'пошёл на рыбалку',
    'провёл ночь в гнезде аиста',
    'провёл ночь в муравейнике',
    'прочитал лекцию о сексуальной ориентации',
    'пытался провезти [СВОЕГО_ЛЮБИМЦА] в чемодане',
    'РАЗВЕЛ КОСТЕР В МЕТРО',
    'раздал свою зарплату бомжам',
    'ранил ножом двоих полицейских',
    'напал на прохожего с огнетушителем в руках',
    'сбежал из кареты скорой помощи',
    'сбежал из психушки',
    'собирал валежник',
    'убирался в квартире',
    'УГНАЛ [МАРШРУТКУ]',
    'УКРАЛ [СОБАКУ]',
    'украл выручку',
    'украл катафалк, увёз его в деревню',
    'утопил знакомую в ванной',
    'хвастался в Instagram брендовыми вещами',
    'ХОТЕЛ [УБИТЬ] [ЖЕНУ]',
    'хотел устроиться на работу в детский сад',
  ],
  'f': [
    '[ВЗОРВАЛА] [БУДКУ]',
    'брала взятки',
    'взяла в заложники тестя',
    'вломилась в чужой дом',
    'готовила ужин',
    'забрала ёлку в отделении банка',
    'заколола мужа во время застолья',
    'избила новогодней ёлкой директора школы',
    'избила детей скакалкой',
    'не пустила мужа на рыбалку',
    'ОБЛИЛась БЕНЗИНОМ, ЗАГОРЕЛась',
    'ограбила автомат с игрушками',
    'отдала зарплату аферисту',
    'ПОДожгла СВОИ ДОКУМЕНТЫ',
    'пыталась украсть продукты в подгузнике',
    'РАЗВЕЛа КОСТЕР В МЕТРО',
    'раздала зарплату детям-сиротам',
    'сбежала из психушки',
    'сломала самогонный аппарат мужа',
    'снялась обнажённой',
    'снялась в порно',
    'совершила ДТП с трактором',
    'убила сестру банкой муки',
    'УГНАЛА [МАРШРУТКУ]',
    'УКРАЛА [СОБАКУ]',
    'поймала [СОБАКУ]',
    'гонялась за соседским ребёнком',
    'фотографировала льва в цирке',
    'ХОТЕЛа [УБИТЬ] [МУЖА]',
  ],
  'plural': [
    'взорвали [БУДКУ]',
    'вломились в чужой дом',
    'выманили у студентки 2 млн рублей',
    'задержали подростка с автоматом Калашникова',
    'заказали убийство директора',
    'избили на концерте полицейского',
    'изнасиловали кондитера',
    'ограбили автомат с игрушками',
    'осквернили могилу неизвестного солдата',
    'подожгли гаражный кооператив',
    'ПОДожгли СВОИ ДОКУМЕНТЫ',
    'подрались из-за трусов в секонд-хенде',
    'пошли на рыбалку',
    'провезли в метро гроб',
    'пытались покончить с собой',
    'РАЗВЕЛи КОСТЕР В МЕТРО',
    'раздали свою зарплату бомжам',
    'сбежали из психушки',
    'сломали самогонный аппарат',
    'угнали бетономешалку',
    'УГНАЛИ МАРШРУТКУ, НАБРАЛИ ПАССАЖИРОВ',
    'угнали танк-экспонат времен ВОВ',
    'угнали трактор',
    'угнали у фермера стадо баранов',
    'УКРАЛИ [СОБАКУ]',
    'УКРАЛИ чемодан, набитый дошираком',
    'украли ларёк "Твоя любимая шаверма"',
    'украли льва из местного цирка',
    'украли несколько тонн сигарет',
    'украли у горожан 20 млн рублей',
    'устроили поножовщину с Дедом Морозом',
  ]
};

Map<String, List> globalConclusion = {
  'm': [
    'в неадекватном состоянии',
    'и [СЛУЧАЙНО] оскорбил [ПЕНСИОНЕРОВ]',
    'и [СЛУЧАЙНО] [УБИЛ] [СОСЕДА]',
    'и был задержан за мошенничество',
    'и уволился',
    'и выиграл в лотерею',
    'И ЕДВА НЕ ЛИШИЛСЯ [ЛИШИЛСЯ]',
    'и пел матерные частушки',
    'и поджег квартиру',
    'и получил пулю в живот',
    'и просил встречи с [ПУТИНЫМ]',
    'и угнал шесть автомобилей',
    'и украл кошелек с деньгами',
    'и уехал выпивать в деревню',
    'и уехал на товарняке во Владивосток',
    'И УМЕР',
    'и умер от удара током',
    'и устроил пенную вечеринку',
    'и чуть не убил [СВОЕГО_ЛЮБИМЦА]',
    'спасая [СВОЕГО_ЛЮБИМЦА]',
    'чтобы вернуть [ВЕРНУТЬ_М]',
    'чтобы войти в книгу рекордов Гинесса',
    'чтобы его оставили в покое',
    'чтобы замести следы изготовления самогона',
    'чтобы защитить свою честь',
    'чтобы отомстить',
    'ЧТОБЫ СОГРЕТЬСЯ',
    'чтобы уладить конфликт с соседом',
  ],
  'f': [
    'и [СЛУЧАЙНО] [УБИЛА] [СОСЕДА]',
    'и оскорбила [ПЕНСИОНЕРОВ]',
    'и выиграла в лотерею',
    'и выложила фото в инстраграмм',
    'и едва не лишилась [ЛИШИЛСЯ]',
    'и живёт одна уже несколько месяцев',
    'и материлась невпопад',
    'и НАДРУГАЛАСЬ над соседом',
    'И ПОПРОСИЛа НЕ БЕСПОКОИТЬ',
    'И ПРИ ЭТОМ СМЕЯЛась',
    'и скрывается от правосудия',
    'и требовала аудиенции с [ПУТИНЫМ]',
    'И УМЕРла',
    'ради веселья',
    'с особой жестокостью',
    'спасая [СВОЕГО_ЛЮБИМЦА]',
    'чтобы вернуть [ВЕРНУТЬ_Ж]',
    'чтобы вернуть мужа',
    'чтобы войти в книгу рекордов Гинесса',
    'чтобы её не заподозрили в измене',
    'чтобы её оставили в покое',
    'чтобы уладить конфликт с соседкой',
    'ЧТОБЫ СОГРЕТЬСЯ',
  ],
  'plural': [
    'в знак протеста против произвола христиан',
    'и [СЛУЧАЙНО] [УБИЛИ] [СОСЕДА]',
    'и оскорбили [ПЕНСИОНЕРОВ]',
    'И ЕДВА НЕ ЛИШИЛись конечностей',
    'и пели матерные частушки',
    'И ПОПРОСИЛи НЕ БЕСПОКОИТЬ',
    'И ПРИ ЭТОМ СМЕЯЛись',
    'и отправились гулять по железнодорожным путям',
    'и прострелили ногу преступнику с ножом',
    'и скрываются от правосудия',
    'и добивались встречи с [ПУТИНЫМ]',
    'И УМЕРли',
    'и устроили стрельбу из пневматики',
    'ради веселья',
    'с особой жестокостью',
    'с целью друг друга убить',
    'спасая [СВОЕГО_ЛЮБИМЦА]',
    'угрожая оружием',
    'чтобы войти в книгу рекордов Гинесса',
    'чтобы их оставили в покое',
    'чтобы наладить дружеские отношения',
    'чтобы уладить конфликт с соседями',
    'ЧТОБЫ СОГРЕТЬСЯ',
  ]
};

List<Map> globalPredictEn = [
  {'message': '[TWO] students of [UNIVERSITY]', 'sex': 'plural'},
  {'message': '[TWO] [DRUNK] prostitutes from [CITY]', 'sex': 'plural'},
  {'message': '[DRUNK] [GIRL] from [CITY]', 'sex': 'f'},
  {'message': '[DRUNK] citizen from [CITY]', 'sex': 'f'},
  {'message': '[DRUNK] gay activists', 'sex': 'plural'},
  {'message': '[DRUNK] [CONGRESSMAN] from [CITY]', 'sex': 'm'},
  {'message': '[DRUNK] [OLDMAN] in [CITY]', 'sex': 'm'},
  {'message': '[DRUNK] [OLDMAN] from [CITY]', 'sex': 'm'},
  {'message': '[DRUNK] [OLDMAN] from [CITY]', 'sex': 'm'},
  {'message': '[DRUNK] [OLDMAN]', 'sex': 'm'},
  {'message': '[DRUNK] [CITIZEN]', 'sex': 'm'},
  {'message': '[DRUNK] [CITIZEN] with a laser stick', 'sex': 'm'},
  {'message': '[DRUNK] [CITIZENS]', 'sex': 'plural'},
  {'message': 'In [CITY] [TWO] [DRUNK] [GIRLS]', 'sex': 'plural'},
  {'message': 'In [CITY] [DRUNK] [GIRL]', 'sex': 'f'},
  {'message': 'In [CITY] [DRUNK] [OLDMAN]', 'sex': 'm'},
  {'message': 'In [CITY] [DRUNK] Mexican worker', 'sex': 'm'},
  {'message': 'Group of young men from [CITY]', 'sex': 'plural'},
  {'message': 'Some guys from [CITY]', 'sex': 'plural'},
  {'message': 'citizens from [CITY]', 'sex': 'plural'},
  {'message': '[ONE_PLUS_ONE]', 'sex': 'plural'},
  {'message': 'Bigfoot in [CITY]', 'sex': 'bf'},
  {'message': 'Bigfoot', 'sex': 'bf'},
  {'message': 'gay aliens', 'sex': 'aliens'},
  {'message': 'aliens', 'sex': 'aliens'},
];

Map<String, List> globalSetsEn = {
  'GARAGE': [
    'a garage',
    'a weed farm',
    'a billboard',
  ],
  'UNIVERSITY': ['MIT', 'Harvard', 'Stanford', 'Caltech'],
  'GIRL': [
    'GIRL',
    'night club cleaner',
    'old lady',
    'writer',
    'saleswoman',
    'teacher',
    'beauty salon visitor',
    'hooker',
  ],
  'GIRLS': [
    'girls',
    'hypnotist swindlers',
    'retirees',
    'writers',
    'saleswomans',
    'teachers',
    'beauty salon visitors',
    'students',
    'old ladies',
    'hookers',
  ],
  'ONE_PLUS_ONE': [
    'pregnant woman with a friend',
    'KGB officers',
    'CIA officers',
  ],
  'CONGRESSMAN': ['congressman', 'mayor', 'sheriff', 'ex-mayor', 'policemen', 'citizen'],
  'WIFE': ['his wife', 'his dog'],
  'TRAIN': ['a train', 'tractor', 'concrete mixer', 'WW2 tank', 'tram', 'trolleybus', 'patrol boat'],
  'HUSBAND': ['her husband', 'her ex-boyfriend', 'her sister'],
  'CITIZEN': ['NYC citizen', 'LA citizen', 'Mexican', 'German', 'San-Jose citizen'],
  'CITIZENS': ['NYC citizens'],
  'OLDMAN': [
    'Redneck',
    'vampire',
    'Redneck vampire',
    'businessman',
    'WW2 veteran',
    'iraq veteran',
    'old thief',
    'loader',
    'janitor',
    'bald suicide',
    'millionaire',
    'young man',
    'Mormon',
    'drugdealer',
    'beggar',
    'hunter',
    'guy',
    'old man',
    'brewer',
    'fireworker',
    'young arsonist',
    'teenager',
    'old teacher',
    'policeman',
    'programmer',
    'fisherman',
    'lumberjack',
    'plumber',
    'Satanist',
    'Priest',
    'Social worker',
    'football player',
    'ex-prosecutor',
    'ambulance driver',
    'truck driver',
    'post truck driver',
    'garbage truck driver',
    'tractor driver',
    'combine harvester driver',
    'lawn mower driver',
    'tank driver',
  ],
  'MOONSHINE': [
    'moonshine',
    'vodka',
    'meth',
    'heroine',
  ],
  'OLDMANS': [
    'WW2 veterans',
    'iraq veterans',
    'Mormons',
    'drugdealers',
    'hunters',
    'brewers',
    'old teachers',
    'policemans',
    'programmers',
    'fishermans',
    'Satanists',
    'Priests',
    'Social workers',
    'ambulance driver',
    'truck drivers',
  ],
  'CITY': [
    'LA',
    'NYC',
    'Central Europe',
    'Eastern Europe',
    'South Asia',
    'Germany',
    'Mexico',
    'San-Jose',
    'Africa',
    'Australia',
    'Canada',
    'China',
    'Russia',
    'Ukraine',
    'Belorussia',
  ],
  'PET': ['a dog', 'a cat', 'a cow', 'a horse', 'a goat', 'a pig'],
  'NEIGHBOR': ['neighbor', 'passerby', 'two passersby', 'two female students', 'congressman', 'dog', 'goat',
    'cow', 'cat', 'goose', 'two peacocks'],
  'DRUNK': ['', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', 'drunk'],
  'KILLED': ['killed', 'injured', 'executed', 'humiliated', 'shot', 'strangled', 'drowned', 'stabbed', 'outraged'],
  'LOSS': ['his penis', 'all his documents', 'all the money', 'his hand', 'his mind'],
  'BLEW_UP': ['blew up', 'set on fire', 'shot'],
  'KILL': ['scare', 'kill'],
  'RETURN_M': ['female partner', 'wife', 'girlfriend', 'honor of the family'],
  'RETURN_F': ['husband', 'addict child from the clinic', 'honor of the family'],
  'ACCIDENTALLY': ['accidentally', '', '', '', ''],
  'TWO': ['two', 'three', 'four'],
};

Map<String, List> globalActionEn = {
  'm': [
    '[BLEW_UP] [GARAGE]',
    'took bribes',
    'took mother-in-law as a hostage',
    'broke into someone else\'s house',
    'shot a neighbor with a gun',
    'cooked a dinner',
    'got into the pensioner\'s house',
    'in a fit of passion killed a drinking companion',
    'went into a construction firm with a gun',
    'beat a teenager',
    'raped a conductress',
    'bought an accordion',
    'watered the cat with moonshine',
    'Poured out with GASOLINE, BURNED',
    'found a skeleton in the basement',
    'robbed a toys machine',
    'robbed a couple who sheltered him for the night',
    'poisoned with ethanol',
    'BURNED his DOCUMENTS',
    'wanted to steal a NEIGHBOR\'s scooter',
    'caught a bicycle stealing',
    'went fishing',
    'spent the night in a nest of a stork',
    'spent the night in an anthill',
    'tried to carry [PET] in the suitcase',
    'lit a fire in the METRO',
    'gave his wages to homeless people',
    'wounded two policemen with a knife',
    'attacked a passer-by with a fire extinguisher in his hands',
    'escaped from the ambulance',
    'escaped from a psychiatric hospital',
    'hijacked [TRAIN]',
    'stole [PET]',
    'drowned a girlfriend in the bathroom',
    'wanted to [KILL] [WIFE]',
    'wanted to get a job in a kindergarten',
  ],
  'f': [
    '[BLEW_UP] [GARAGE]',
    'took father-in-law as a hostage',
    'broke into someone else\'s house',
    'cooked a dinner',
    'stabbed [HUSBAND] during the dinner',
    'did not let [HUSBAND] go fishing',
    'Poured out with GASOLINE, BURNED',
    'robbed a toys machine',
    'gave her wages to homeless people',
    'gave a salary to a swindler',
    'tried to steal food in a diaper',
    'BURNED her DOCUMENTS',
    'lit a fire in the subway',
    'distributed a salary to orphans',
    'escaped from a psychiatric hospital',
    'broke husband\'s moonshine home brewery',
    'starred naked',
    'starred in porn',
    'has made a road accident with a tractor',
    '[KILLED] sister with a can of flour',
    'hijacked [TRAIN]',
    'stole [PET]',
    'caught [PET]',
    'was chasing a neighbor\'s child',
    'photographed a lion in a circus',
    'wanted to [KILL] [HUSBAND]',
  ],
  'plural': [
    '[BLEW_UP] [GARAGE]',
    'broke into someone else\'s house',
    'stole \$2 million from a female student',
    'detained a teenager with a Kalashnikov assault rifle',
    'ordered to kill their director',
    'raped the priest',
    'robbed a toys machine',
    'desecrated the grave of an unknown soldier',
    'went fishing',
    'tried to commit suicide',
    'distributed their wages to homeless people',
    'escaped from a psychiatric hospital',
    'broke the moonshine brewery',
    'stolen the concrete mixer',
    'hijacked the WW2 tank from the exhibition',
    'hijacked the tractor',
    'hijacked a herd of rams from the farmer',
    'stole [PET]',
    'stole a lion from a local circus',
    'stole several tons of cigarettes',
    'stole \$20 million from the townspeople',
    'BURNED their DOCUMENTS',
    'lit a fire in the subway',
    'hijacked [TRAIN], got passangers',
  ],
  'aliens': [
    'broke into someone\'s house',
    'stole a hundred students',
    'stole [GARAGE]',
    'raped an [OLDMAN]',
    'hijacked the WW2 tank from the exhibition',
    'hijacked the tractor',
    'hijacked a herd of rams from the farmer',
    'stole [PET]',
    'stole a lion from a local circus',
    'stole a weed farm',
  ],
  'bf': [
    'broke into someone\'s house',
    'got into the pensioner\'s house',
    'beat a teenager',
    'raped alien',
    'robbed a bank',
    'poisoned with ethanol',
    'wanted to steal a scooter',
    'caught a bicycle stealing',
    'wounded two policemen',
    'hijacked [TRAIN]',
    'stole [PET]',
  ],
};

List<String> russianLocales = [
  'ru',
  'be',
  'uk',
];

Map<String, List> globalConclusionEn = {
  'm': [
    'and [ACCIDENTALLY] injured [OLDMANS]',
    'and [ACCIDENTALLY] [KILLED] [NEIGHBOR]',
    'and was detained for fraud',
    'and won the lottery',
    'and LOST [LOSS]',
    'and sang dirty ditties',
    'and set fire to the apartment',
    'and got a bullet in the leg',
    'and stole a purse',
    'and nearly killed [PET]',
    'and [ACCIDENTALLY] died',
    'saving [PET]',
    'and died of electric shock',
    'to return [RETURN_M]',
    'to enter the Guinness Book of Records',
    'to be left alone',
    'to cover the traces of making [MOONSHINE]',
    'to protect their honor',
    'to settle a conflict with a neighbor',
  ],
  'f': [
    'and [ACCIDENTALLY] [KILLED] [NEIGHBOR]',
    'and [ACCIDENTALLY] injured [OLDMANS]',
    'and won the lottery',
    'and posted a photo to the instagram',
    'and STRIKED over a neighbor',
    'and ASKED NOT TO DISTURB',
    'and laughed loud',
    'and hiding from justice',
    'and [ACCIDENTALLY] died',
    'with particular cruelty',
    'saving [PET]',
    'to return [RETURN_F]',
    'to enter the Guinness Book of Records',
    'to not be suspected of cheating',
    'to be left alone',
    'to settle a conflict with a neighbor',
  ],
  'plural': [
    'and [ACCIDENTALLY] [KILLED] [NEIGHBOR]',
    'and [ACCIDENTALLY] injured [OLDMANS]',
    'and ASKED NOT TO DISTURB',
    'and laughed loud',
    'and shot armed criminal',
    'and are hiding from justice',
    'and [ACCIDENTALLY] died',
    'and staged shooting from pneumatics',
    'just for fun',
    'with particular cruelty',
    'with the goal of killing each other',
    'saving [PET]',
    'threatening with weapons',
    'to enter the Guinness Book of Records',
    'to be left alone',
    'to settle a conflict with a neighbors',
  ],
  'aliens': [
    'and [KILLED] [NEIGHBOR]',
    'and flew away',
    'eating [PET]',
  ],
  'bf': [
    'and [ACCIDENTALLY] injured [OLDMANS]',
    'and sang mysterious melodies',
    'and ran away',
    'and nearly killed [PET]',
    'and [ACCIDENTALLY] disappeared',
    'to be left alone',
  ],
};

class MadNews {
  String sex = '';
  String personString = '';
  String actionString = '';
  String conclusionString = '';

  MadNews() {
    String locale = universal_io.Platform.localeName.substring(0, 2);
    if (kDebugMode) {
      print('Locale: $locale');
    }
    List<Map> predict = List<Map>.from(globalPredict);
    Map<String, List> localActions = Map<String, List>.from(globalAction);
    Map<String, List> localConclusion = Map<String, List>.from(globalConclusion);
    if (!russianLocales.contains(locale.toLowerCase())) {
      predict = List<Map>.from(globalPredictEn);
      localActions = Map<String, List>.from(globalActionEn);
      localConclusion = Map<String, List>.from(globalConclusionEn);
    }

    if (kDebugMode) {
      print('getPerson');
    }
    var personObject = predict[Random().nextInt(predict.length)];
    sex = personObject['sex'];
    personString = personObject['message'];
    personString = randomizeTemplate(personString).toUpperCase();

    if (kDebugMode) {
      print('getAction');
    }
    if (localActions[sex] == null) {
      localActions[sex] = List.from([]);
    }
    String actionsJSON = json.encode(localActions[sex]);
    List<dynamic> actions = json.decode(actionsJSON);
    actionString = actions[Random().nextInt(actions.length)];
    actionString = randomizeTemplate(actionString).toUpperCase();

    if (kDebugMode) {
      print('getConclusion');
    }
    String conclusionsJSON = json.encode(localConclusion[sex]);
    List<dynamic> conclusions = json.decode(conclusionsJSON);
    conclusionString = conclusions[Random().nextInt(conclusions.length)];
    conclusionString = randomizeTemplate(conclusionString).toUpperCase();
  }

  String getPerson() {
    return personString;
  }

  String getAction() {
    return actionString;
  }

  String getConclusion() {
    return conclusionString;
  }

  String randomizeTemplate(template) {
    String locale = universal_io.Platform.localeName.substring(0, 2);
    Map<String, List> localSets = Map<String, List>.from(globalSets);
    if (!russianLocales.contains(locale.toLowerCase())) {
      localSets = Map<String, List>.from(globalSetsEn);
    }
    RegExp exp = RegExp(
      "[[а-яА-Яa-zA-Z_w]*]",
      caseSensitive: false,
      multiLine: true,
    );
    Iterable<RegExpMatch> matches = exp.allMatches(template);
    if (matches.isNotEmpty) {
      for (var match in matches) {
        var currentMatch = match.group(0);
        if (currentMatch == null) continue;
        if (currentMatch.length < 2) continue;
        List<dynamic>? randomSets = localSets[
            match.group(0)?.substring(0, currentMatch.length - 1).substring(1)
        ];
        if (randomSets != null && randomSets.isNotEmpty) {
          var randomSet = randomSets[Random().nextInt(randomSets.length)];
          template = template.replaceAll(currentMatch, randomSet.toString().trim());
        } else {
          if (kDebugMode) {
            print('randomSets length is 0');
          }
        }
      }
    }
    if (template == null) {
      if (kDebugMode) {
        print('template is null');
        print(template);
      }
      template = '';
    }
    return template;
  }
}