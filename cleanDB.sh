#!/usr/bin/env bash
#mysql -u "baraza" --password="baraza"  -e 'drop database if exists baraza_development';
#mysql -u "baraza" --password="baraza"  -e 'create database baraza_development';

#cd ../baraza
bundle install
bundle exec rake db:drop db:create db:migrate db:test:prepare
RAILS_ENV=automation rake db:drop
RAILS_ENV=automation rake db:create
RAILS_ENV=automation rake db:migrate
RAILS_ENV=automation rake db:user
RAILS_ENV=automation rake db:admin

RAILS_ENV=automation rake db:category

cd -
#mysql -u "root" --password="" < script/db_insert.sql;

psql -h localhost -U kuhle baraza_automation < script/db_insert.sql;
