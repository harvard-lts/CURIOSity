# README

## Running the stack

### Important URLs

dev: https://spotlight.test


### Dory

you will need to enter your sudo credentials to bring the 2 dory containers up.

```bash
gem install dory
dory up
```


### stack_car

stack_car is an alternative way to run the project.

1. Install stack car for the first time

```bash
gem install stack_car
```

2. Run the project with stack car

```bash
sc up
```


### Running the project for your first time or if there have been changes to config files

  1. clone the project with SSH

  - SSH
    ```bash
    git clone git@gitlab.com:notch8/harvard-spotlight.git
    ```

  2. build the project
   -  ```bash
      docker compose build
      ```

  3. start the project
  - ```bash
    docker compose up
    ```

after running the above command, check that you see the following output in the terminal, then navigate to https://spotlight.test

`harvard-spotlight-db_migrate-1 exited with code 0`

now after building, you should just be able to run the project with
  - ```bash
    docker compose up
    ```



## Admin login info

You can find login credentials in the `db/seeds.rb` file


## Other useful commands

  - Run migrations & seeds
    ```bash
    sc be rails db:migrate
    sc be rails db:seed
    ```


  - Bash into the container
    ```bash
    sc exec sh
    ```

## Troubleshooting

- If you get the following error

  ```bash
  NoMethodError in Spotlight::ExhibitsController#index
  undefined method `current_exhibit = 'for I18n::Backend::ActiveRecord::Translation(Table doesn't exist):Class
  ```

  **try:** restarting your containers

    ```bash
    docker compose stop
    docker compose up
    ```


