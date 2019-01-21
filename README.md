# README

rafikiTwist is a Ruby on Rails application which utilizes the React Javascript framework. It is designed to work with docker-compose to facilitate a convenient development environment. Docker is the only required dependency to run the app on your machine. Everything else will be installed within the containers when running docker-compose up --build. The purpose of the application is to easily store and discover your favorite recipes.

## Install
docker-compose build
docker-compose run web rake db:create
docker-compose run db bash
su postgres
cd /var/lib/postgresql/data/
initdb
pg_ctl -D /var/lib/postgresql/data -l logfile start
psql
create user deploy;
ALTER USER deploy WITH SUPERUSER;
alter user deploy with password 'YourPassword';
create database recipes_development;
\q
psql recipes_development < /tmp/recipes.sql
