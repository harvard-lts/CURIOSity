# CURIOSity
CURIOSity enables researchers to discover and easily access a wealth of curated, publicly accessible, digitized materials.

## Technology Stack

##### Language
Ruby on Rails

##### Framework
Blacklight / Spotlight

## Running the stack

### Important URLs

dev: http://spotlight.test

### Dependencies

#### Dory

[Dory](https://github.com/FreedomBen/dory) is required to run this project using Docker. Installation instructions can be found [here](https://github.com/FreedomBen/dory#installation).

Also, you will need to configure Dory to use the `.test` domain; instructions for this can be found [here](https://playbook-staging.notch8.com/en/dev/environment/run-dory-without-password).

#### stack_car

The [stack_car](https://rubygems.org/gems/stack_car) gem is an alternative to docker-compose.

> Stack Car is an opinionated set of tools around Docker and Rails.  It provides convenent methods to start and stop docker-compose, to deploy with rancher and a set of templates to get a new Rails app in to docker as quickly as possible.

`stack_car` **is not required** to run this project; you can use docker-compose commands if you prefer. However, relevant documentation will assume that you are using `stack_car`.

1. Install `stack_car` for the first time

```bash
gem install stack_car
```

2. Run the project with stack car

```bash
sc up
```

### Running within a fully containerized Docker setup

#### First time spin up

1. Clone the project

```bash
git clone git@github.com:harvard-lts/CURIOSity.git
```

2. Enable full containerization overrides

```bash
cp docker-compose.override.example.yml docker-compose.override.yml
```

3. Build the Docker image(s) using `stack_car`

```bash
sc build
```

4. Start the Docker containers

```bash
dory up
sc up
```

After running the above commands, check that you see the following output in the terminal, then navigate to http://spotlight.test

`curiosity-db_migrate-1 exited with code 0`

After running these initial steps, you should be able to run the project just by running:

```bash
sc up
```

#### Admin login info

You can find login credentials in the [db/seeds.rb](db/seeds.rb) file.

#### Other useful commands

- Run migrations & seeds

```bash
sc be rails db:migrate
sc be rails db:seed
```

- Bash into the web container

```bash
sc sh
```

### Troubleshooting

- If you get the following error when navigating to http://spotlight.test:

```bash
NoMethodError in Spotlight::ExhibitsController#index
undefined method `current_exhibit = 'for I18n::Backend::ActiveRecord::Translation(Table doesn't exist):Class
```

**Try:** restarting the containers

```bash
sc stop
sc up
```
