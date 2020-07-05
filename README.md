## Timestamp Demo

This project demonstrates how DateTime types are saved on and retrived from a MySQL database. For demo, we use Laravel and Spring Frameworks.

### 0 Observations
When Asia/Seoul timezone is given to the application, while the MySQL timezone is set to UTC
- the Laravel application saves the ~~WRONG~~ RIGHT timestamp value to the MySQL table, WHEN IT IS CONFIGURED PROPERLY [see 3](#3-how-laravel-timezone-setting-works)
- the Spring application saves the RIGHT timestamp value in UTC to the MySQL table

### 1 How to run

1.1. Clone the repository
```bash
$ git clone git@github.com:appkr/timestamp-demo.git
# OR git clone https://github.com/appkr/timestamp-demo.git
```

Before run the stack, since we will use MySQL, make sure that your local machine's 3306 port is available.

1.2. Run the application stack
```bash
~/timestamp-demo $ bash run.sh
# Leave the shell as it is
# To quit, Ctrl+C
```

1.3. Test (On the other shell)
```bash
~/timestamp-demo $ bash test.sh
```

> `NOTE` MySQL acccount
>
> - root / secret
> - homestead / secret

### 2 Test log

```bash
$ bash test.sh
# Connection to 127.0.0.1 port 3306 [tcp/mysql] succeeded!
# DB is UP
# Migration table created successfully.
# Migrating: 2020_06_21_000000_create_posts_table
# Migrated:  2020_06_21_000000_create_posts_table (0.09 seconds)
#
# --------------------------------------------------------------------------------
# Testing laravel application
# --------------------------------------------------------------------------------
#
# + curl -s -XPOST -H 'Content-type: application/json' -H 'Accept: application/json' -d '{"body":"test from laravel"}' http://localhost:8080/api/posts
  {"id":1,"body":"test from laravel","createdAt":"2020-07-12T22:31:45+09:00","updatedAt":"2020-07-12T22:31:45+09:00"}
#
# + set +x
#
# --------------------------------------------------------------------------------
# Testing spring application
# --------------------------------------------------------------------------------
#
# + curl -s -XPOST -H 'Content-type: application/json' -H 'Accept: application/json' -d '{"body":"test from spring"}' http://localhost:8082/api/posts
  {"id":2,"body":"test from spring","createdAt":"2020-07-12T22:31:46.456+09:00","updatedAt":"2020-07-12T22:31:46.456+09:00"}
```

In the database
```bash
$ docker exec -it mysql mysql -uroot -p
Enter password:

mysql> select @@global.time_zone, @@session.time_zone, @@system_time_zone;
+--------------------+---------------------+--------------------+
| @@global.time_zone | @@session.time_zone | @@system_time_zone |
+--------------------+---------------------+--------------------+
| SYSTEM             | SYSTEM              | UTC                |
+--------------------+---------------------+--------------------+

mysql> select * from timestamp_demo.posts;
+----+-------------------+-------------------------+-------------------------+
| id | body              | created_at              | updated_at              |
+----+-------------------+-------------------------+-------------------------+
|  1 | test from laravel | 2020-07-12 13:31:45.000 | 2020-07-12 13:31:45.000 |
|  2 | test from spring  | 2020-07-12 13:31:46.456 | 2020-07-12 13:31:46.456 |
+----+-------------------+-------------------------+-------------------------+
```

MySQL general log
```bash
# Laravel
2020-07-12T13:31:45.868547Z    17 Query use `timestamp_demo`
2020-07-12T13:31:45.873249Z    17 Prepare   set names 'utf8mb4' collate 'utf8mb4_unicode_ci'
2020-07-12T13:31:45.873682Z    17 Execute   set names 'utf8mb4' collate 'utf8mb4_unicode_ci'
2020-07-12T13:31:45.873998Z    17 Close stmt

2020-07-12T13:31:45.874209Z    17 Prepare   set time_zone="Asia/Seoul"
2020-07-12T13:31:45.874526Z    17 Execute   set time_zone="Asia/Seoul"
2020-07-12T13:31:45.875076Z    17 Close stmt

2020-07-12T13:31:45.875202Z    17 Prepare   set session sql_mode='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION'
2020-07-12T13:31:45.875508Z    17 Execute   set session sql_mode='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION'
2020-07-12T13:31:45.875876Z    17 Close stmt

2020-07-12T13:31:45.881341Z    17 Prepare   insert into `posts` (`body`, `updated_at`, `created_at`) values (?, ?, ?)
2020-07-12T13:31:45.881731Z    17 Execute   insert into `posts` (`body`, `updated_at`, `created_at`) values ('test from laravel', '2020-07-12 22:31:45', '2020-07-12 22:31:45')
2020-07-12T13:31:45.883236Z    17 Close stmt
```

```bash
# Spring
$ docker exec -it mysql tail -f /var/log/mysql/general.log
2020-07-12T13:31:46.428217Z     2 Query SET autocommit=0
2020-07-12T13:31:46.604578Z     2 Query insert into posts (body, created_at, updated_at) values ('test from spring', '2020-07-12 13:31:46.456', '2020-07-12 13:31:46.456')
2020-07-12T13:31:46.653053Z     2 Query commit
2020-07-12T13:31:46.658120Z     2 Query SET autocommit=1
```

### 3 How Laravel timezone setting works

> The Laravel `app.timezone` configuration unfortunately sets PHP timezone only and has no effect on the underlying MySQL instance.
>
> @see https://laracasts.com/discuss/channels/laravel/laravel-and-mysql-timezone?page=1#reply=547451

PHP platform's timezone setting is ..
```bash
$ docker exec -it laravel php -i | grep timezone
# Default timezone => UTC
# date.timezone => UTC => UTC
```

The Laravel framework overrides the platform's timezone setting at runtime. For this project `app.timezone` is `Asia/Seoul`.
```php
 0 | <?php // vendor/laravel/framework/src/Illuminate/Foundation/Bootstrap/LoadConfiguration.php
12 | class LoadConfiguration
13 | {
20 |     public function bootstrap(Application $app)
21 |     {
49 |         date_default_timezone_set($config->get('app.timezone', 'UTC'));
.. |     }
.. | }
```

When `database.{connection}.timestamp` value is given, the laravel application tries to connect to the database with the given timezone.
```php
0  | <?php // vendor/laravel/framework/src/Illuminate/Foundation/Connectors/MySqlConnector.php
   | class MySqlConnector extends Connector implements ConnectorInterface
   | {
78 |     protected function configureTimezone($connection, array $config)
79 |     {
80 |         if (isset($config['timezone'])) {
81 |             $connection->prepare('set time_zone="'.$config['timezone'].'"')->execute();
82 |         }
83 |     }
   | }
```

When a datetime type is serizlized to JSON, the following code makes a correct response with +09:00 timezone.
```php
<?php // app/Providers/AppServiceProvider.php
class AppServiceProvider extends ServiceProvider
{
    public function boot()
    {
        \Carbon\Carbon::serializeUsing(function (\DateTime $dateTime) {
            return $dateTime->toIso8601String();
        });
    }
}
```
