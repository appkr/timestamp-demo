## Timestamp Demo

This project demonstrates how DateTime types are saved on and retrived from a MySQL database. For demo, we use Laravel and Spring Frameworks.

### How to run

Clone the repository
```bash
$ git clone git@github.com:appkr/timestamp-demo.git
# OR git clone https://github.com/appkr/timestamp-demo.git
```

Before run the stack, make sure that your local machine's 3306 port is available.
Install dependant libraries and run the application including MySQL database.
```bash
~/timestamp-demo $ bash run.sh
# Leave the shell as it is
# To quit, Ctrl+C
```

Test (On the other shell)
```bash
~/timestamp-demo $ bash test.sh
```

> MySQL acccount
>
> - root / secret
> - homestead / secret

### Test Result
#### Laravel

PHP timezone setting
```bash
$ docker exec -it laravel php -i | grep timezone
# Default timezone => UTC
# date.timezone => UTC => UTC
```

```php
 0 | <?php // vendor/laravel/framework/src/Illuminate/Foundation/Bootstrap/LoadConfiguration.php:49
12 | class LoadConfiguration
13 | {
20 |     public function bootstrap(Application $app)
21 |     {
49 |         date_default_timezone_set($config->get('app.timezone', 'UTC'));
.. |     }
.. | }
```

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


MySQL general log
```bash
# Laravel
$ docker exec -it mysql tail -f /var/log/mysql/general.log
2020-07-12T06:07:36.731891Z    30 Connect   homestead@172.20.0.3 on timestamp_demo using TCP/IP
2020-07-12T06:07:36.733762Z    30 Query use `timestamp_demo`
2020-07-12T06:07:36.734716Z    30 Prepare   set names 'utf8mb4' collate 'utf8mb4_unicode_ci'
2020-07-12T06:07:36.734912Z    30 Execute   set names 'utf8mb4' collate 'utf8mb4_unicode_ci'
2020-07-12T06:07:36.735121Z    30 Close stmt
2020-07-12T06:07:36.735466Z    30 Prepare   set session sql_mode='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION'
2020-07-12T06:07:36.735633Z    30 Execute   set session sql_mode='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION'
2020-07-12T06:07:36.735825Z    30 Close stmt
2020-07-12T06:07:36.737960Z    30 Prepare   insert into `posts` (`body`, `updated_at`, `created_at`) values (?, ?, ?)
2020-07-12T06:07:36.738244Z    30 Execute   insert into `posts` (`body`, `updated_at`, `created_at`) values ('test', '2020-07-12 15:07:36', '2020-07-12 15:07:36')
2020-07-12T06:07:36.744203Z    30 Close stmt
2020-07-12T06:07:36.755509Z    30 Prepare   select * from `posts` where `id` = ? limit 1
2020-07-12T06:07:36.761101Z    30 Execute   select * from `posts` where `id` = 7 limit 1
2020-07-12T06:07:36.761654Z    30 Close stmt
2020-07-12T06:07:36.819087Z    30 Quit
```
