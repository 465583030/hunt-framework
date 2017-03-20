module hunt.orm.entity;
import entity;
import std.string;
import ddbc.all;

private __gshared static EntityMetaData _g_schema;
private __gshared string _g_driver;
private __gshared string _g_url;
private __gshared string[string] _g_params;
private __gshared int _g_maxPoolSize;
private __gshared int _g_timeToLive;
private __gshared int _g_waitTimeOut;

void initDB(string driver,string url, string[string]params = null, int maxPoolSize = 2, int timeToLive = 600, int waitTimeOut = 30)
{
	_g_driver = driver;
	_g_url = url;
	_g_params = params;
	_g_maxPoolSize = maxPoolSize;
	_g_timeToLive = timeToLive;
	_g_waitTimeOut = waitTimeOut;
}

final class ORMEntity{
	static ORMEntity _orm;

	private EntityManagerFactory _entityManagerFactory;
	private Dialect _dialect;
	private DataSource _ds;
	private Driver _driver;

	static @property getInstance()
	{
		if(_orm is null)
			_orm = new ORMEntity();
		import std.stdio, core.thread;
		writeln("----", Thread.getThis.id, " orm " , _orm.toHash, " shame ", _g_schema.toHash);
		return _orm;
	}

	void initDB(string driver,string url, string[string]params = null, int maxPoolSize = 2, int timeToLive = 600, int waitTimeOut = 30){
		import std.experimental.logger;
		driver = toLower(driver);
		if(driver == "mysql")
		{
			_dialect = new MySQLDialect();
			_driver = new MySQLDriver();
		}
		else if(driver == "postgresql")
		{
			_dialect = new PGSQLDialect();
			_driver = new PGSQLDriver();
		}
		else if(driver == "")
		{
			_dialect = new SQLiteDialect();
			_driver = new SQLITEDriver();
		}
		else
		{
			assert(false, "not support dialect "~driver);
		}
		_ds = new ConnectionPoolDataSourceImpl(_driver, url, params, maxPoolSize, timeToLive, waitTimeOut);
		trace(_driver, url, params, maxPoolSize, timeToLive, waitTimeOut);
		_entityManagerFactory = new EntityManagerFactory(_g_schema, _dialect, _ds);
	}

	@property EntityManagerFactory entityManagerFactory(){
		if(_entityManagerFactory is null)
		{
			this.initDB(_g_driver,_g_url, _g_params, _g_maxPoolSize, _g_timeToLive, _g_waitTimeOut);
		}
		return _entityManagerFactory;
	}
}



@property static  EntityManagerFactory entityManagerFactory(){
	return ORMEntity.getInstance.entityManagerFactory;
}

void registerEntity(T...)()
{
	_g_schema = new SchemaInfoImpl!(T);
}