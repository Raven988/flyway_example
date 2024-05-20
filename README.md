# flyway
**Flyway** — это популярный инструмент для управления миграциями базы данных. Он помогает автоматизировать процесс развертывания изменений в структуре базы данных (например, создание таблиц, изменение столбцов, добавление индексов и т.д.) в различных окружениях (разработка, тестирование, продакшн).

Основные функции Flyway включают:

 * Версионирование базы данных: Flyway позволяет отслеживать изменения в базе данных через версионированные скрипты миграций. Каждый скрипт имеет уникальный идентификатор, который позволяет определить порядок их выполнения.

 * Автоматическое применение миграций: Flyway автоматически находит новые миграции и применяет их к базе данных в правильном порядке. Это помогает избежать пропущенных или повторно выполненных миграций.

 * Совместимость: Flyway поддерживает множество реляционных баз данных, таких как PostgreSQL, MySQL, Oracle, SQL Server и другие. Это делает его универсальным инструментом для различных проектов.

 * Интеграция с CI/CD: Flyway легко интегрируется с системами непрерывной интеграции и доставки, что позволяет автоматизировать процесс развертывания изменений базы данных вместе с развертыванием приложения.

 * Консистентность окружений: Используя Flyway, можно гарантировать, что все окружения (разработка, тестирование, продакшн) имеют одинаковую структуру базы данных, что уменьшает вероятность ошибок, связанных с различиями в схемах базы данных.

# Установка flyway на Linux/Unix
## загрузка установочных файлов
Скачать с [официального сайта.](https://www.red-gate.com/products/flyway/editions)  

К сожаления, на 20.05.2024 возможность загрузки с официального сайта без использования VPN недоступна.  

## установка с помощью snapd
Возможно потребуется добавление репозиториев для установки snapd.
```bash
sudo apt update
sudo apt install snapd
sudo snap install core
```
```bash
sudo snap install flyway
```
```bash
export PATH=$PATH:/snap/bin
```
```bash
flyway -v
```
## Пример использования flyway с Postgresql
Предварительно установлен и настроен Postgresql.  

Примерная структура проекта: [[https://github.com/Raven988/flyway_example|GitHub]]
```
project/  
├── sources/  
│   └─ db/  
│      ├── migrations/  
|      |      ├── V1__create_cars_table.sql
|      |      ├── V2__create_price_table.sql
|      |      ├── V3__add_cars_color.sql
|      |      ├── V4__add_price_currency.sql
|      |      ├── B4__baseline_migration.sql
|      |      └── V5__add_cars_type_body.sql 
|      | 
│      └── flyway.conf  
├── .gitignore  
└── README.md  
```

Настройки для подключения flyway к базе данных.  
flyway.conf:
```
flyway.url=jdbc:postgresql://localhost:5432/postgres
flyway.user=postgres
flyway.password=postgres
flyway.locations=filesystem:./sources/db/
```

V1__create_cars_table.sql:
```sql
create table cars (
    id bigint not null,
    model varchar(50) not null,
    brand varchar(50) not null,
    primary key (id)
);
```
V2__create_price_table.sql:
```
create table prices (
    id bigint not null,
    price varchar(50) not null,
    car_id bigint,
    primary key (id)
);
```
V3__add_cars_color.sql:
```
alter table cars
add column color varchar(50);
```
V4__add_price_currency.sql:
```
alter table prices
add column currency varchar(50);
```
V5__add_cars_type_body.sql:
```
alter table cars
add column type_body varchar(50);
```

B4__baseline_migration.sql:
```
create table cars (
    id bigint not null,
    model varchar(50) not null,
    mark varchar(50) not null,
    primary key (id)
);

create table prices (
    id bigint not null,
    price varchar(50) not null,
    car_id bigint,
    primary key (id)
);

alter table cars
add column color varchar(50);

alter table prices
add column currency varchar(50);
```
B4__baseline_migration.sql является объеденяющим скриптом, flyway просканирует директорию, выполнит этот срипт и пойдет дальше искать более новые версии V5-V6...Vn.

Находясь в директории проекта, выполните команду в терминале:
```bash
flyway info migrate
```
info - для побробной информации.

## Пример команды для запуска flyway в контейнере 
Проще всего воспользоваться Docker контейнером.

```bash
docker pull redgate/flyway
```

```bash
docker run --rm -v "{absolute path to folder containing sql migrations}:/flyway/sql" -v "{absolute path to folder containing conf file}:/flyway/conf" redgate/flyway migrate
```
 * Отредактируйте flyway.conf - удалите строчку flyway.locations=filesystem:./sources/db/
 * Замените {absolute path to folder containing sql migrations} на абсолютный путь к каталогу с миграциями
 * Замените {absolute path to folder containing conf file} на абсолютный путь к .conf файлу
