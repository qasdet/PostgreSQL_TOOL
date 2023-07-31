SELECT
	-- OID базы данных, к которой подключён этот серверный процесс
	"datid" as "db_id",
	-- Имя базы данных, к которой подключён этот серверный процесс
	"datname" as "db_name",
	-- Идентификатор серверного процесса
	"pid" as "db_name",
	-- OID пользователя, подключённого к этому серверному процессу
	"usesysid" as "user_id",
	-- Имя пользователя, подключённого к этому серверному процессу
	"usename" as "user_name",
	-- Название приложения
	"application_name" as "application_name",
	-- IP-адрес клиента, подключённого к этому серверному процессу. 
	-- Значение null в этом поле означает, что клиент подключён через сокет Unix на стороне сервера или что это внутренний процесс, 
	-- например, автоочистка.
	"client_addr" as "client_address",
	-- Имя компьютера для подключённого клиента, получаемое в результате обратного поиска в DNS по client_addr. 
	-- Это поле будет отлично от null только в случае соединений по IP и только при включённом режиме log_hostname.
	"client_hostname" as "client_hostname",
	-- Номер TCP-порта, который используется клиентом для соединения с этим серверным процессом, или -1, если используется сокет Unix
	"client_port" as "client_port",
	-- Время запуска процесса, т. е. время, когда клиент подсоединился к серверу
	"backend_start" as "backend_start",
	-- Время начала текущей транзакции в этом процессе или null при отсутствии активной транзакции. 
	-- Если текущий запрос был первым в своей транзакции, то значение в этом столбце совпадает со значением столбца query_start.
	"xact_start" as "xact_start",
	-- Время начала выполнения активного в данный момент запроса, 
	-- или, если state не active, то время начала выполнения последнего запроса
	"query_start" as "query_start",
	-- Время последнего изменения состояния (поля state)
	"state_change" as "state_change",
	-- Тип события, которого ждёт обслуживающий процесс, если это имеет место; в противном случае — NULL.
	/*
	LWLockNamed: Обслуживающий процесс ожидает определённую именованную лёгкую блокировку.
		Такие блокировки защищают определённые структуры данных в разделяемой памяти. Имя блокировки будет показывается в wait_event.
	LWLockTranche: Обслуживающий процесс ожидает одну из группы связанных лёгких блокировок.
		Все блокировки в этой группе выполняют схожие функции; общее предназначение блокировок в этой группе показывается в wait_event.
	Lock: Обслуживающий процесс ожидает тяжёлую блокировку. Тяжёлые блокировки, также называемые блокировками менеджера 
		блокировок или просто блокировками, в основном защищают объекты уровня SQL, такие как таблицы. 
		Однако они также применяются для взаимоисключающего выполнения некоторых внутренних операций, 
		например, для расширения отношений. Тип ожидаемой блокировки показывается в wait_event.
	BufferPin: Серверный процесс ожидает доступа к буферу данных, когда никакой другой процесс не обращается к этому буферу. 
		Ожидание закрепления буфера может растягиваться, если другой процесс удерживает открытый курсор, 
		который читал данные из нужного буфера.
	*/
    "wait_event_type" as "wait_event_type",
	-- Имя ожидаемого события, если обслуживающий процесс находится в состоянии ожидания, а в противном случае — NULL. 
	-- Подробнее: https://postgrespro.ru/docs/postgresql/9.6/monitoring-stats#wait-event-table
	"wait_event" as "wait_event",
	-- Общее текущее состояние этого серверного процесса.
	/*
	active: серверный процесс выполняет запрос.
	idle: серверный процесс ожидает новой команды от клиента.
	idle in transaction: серверный процесс находится внутри транзакции, но в настоящее время не выполняет никакой запрос.
	idle in transaction (aborted): Это состояние подобно idle in transaction, за исключением того, 
		что один из операторов в транзакции вызывал ошибку.
	fastpath function call: серверный процесс выполняет fast-path функцию.
	disabled: Это состояние отображается для серверных процессов, у которых параметр track_activities отключён.
	*/
	"state" as "state",
	-- Идентификатор верхнего уровня транзакции этого серверного процесса или любой другой.
	"backend_xid" as "backend_xid",
	-- текущая граница xmin для серверного процесса.
	"backend_xmin" as "backend_xmin",
	-- Текст последнего запроса этого серверного процесса. 
	-- Еслии state имеет значение active, то в этом поле отображается запрос, 
	-- который выполняется в настоящий момент. Если процесс находится в любом другом состоянии, 
	-- то в этом поле отображается последний выполненный запрос.
	"query" as "query"
FROM pg_stat_activity