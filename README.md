# CURIOSity
CURIOSity enables researchers to discover and easily access a wealth of curated, publicly accessible, digitized materials.

## Technology Stack

##### Language
Ruby on Rails

##### Framework
Blacklight / Spotlight

## Running the stack

### Important URLs

dev: http://localhost:3000

### First time spin up

1. Clone the project

```bash
git clone git@github.com:harvard-lts/CURIOSity.git
```

2. Create the .env from env-example. Do NOT commit the .env file

3. Enable full containerization overrides

```bash
cp docker-compose.override.example.yml docker-compose.override.yml
```

4. Build the Docker image(s)

```docker-compose build```

5. Build the Docker image(s) and bring up the stack

```docker-compose up -d --build --force-recreate```

After running the above commands, check that you see the following output in the terminal, then navigate to http://localhost:3000

`curiosity-db_migrate-1 exited with code 0`

NOTE: I still had to shell in and run rails db:migrate

### Admin login info

You can find login credentials in the [db/seeds.rb](db/seeds.rb) file. These SHOUDL NOT be brought in to anything beyond local.

To import these:

```docker exec -it curiosity_web_1 sh
rails db:migrate
rails db:seed
```

### Troubleshooting

- If you get the following error when navigating to http://spotlight.test:

```bash
NoMethodError in Spotlight::ExhibitsController#index
undefined method `current_exhibit = 'for I18n::Backend::ActiveRecord::Translation(Table doesn't exist):Class
```

**Try:** restarting the containers or shelling in and re-running migrations
