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