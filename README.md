# ${envwarden}
Manage your server secrets with [Bitwarden](https://bitwarden.com/)

## How?

Get your secure environment variables from Bitwarden onto your server.

`envwarden` searches your Bitwarden vault for items matching
a search criteria (defaults to 'envwarden').
Then it goes through all custom fields on every item found
and make them available as envirnoment variables.

## Installation

* [Download `envwarden`](https://raw.githubusercontent.com/envwarden/envwarden/master/envwarden)
  (e.g. `wget https://raw.githubusercontent.com/envwarden/envwarden/master/envwarden`)
* `chmod +x envwarden && sudo cp envwarden /usr/local/bin` to make it executable and reachable
* Download and install the [bw CLI](https://github.com/bitwarden/cli#downloadinstall) and
  [jq](https://stedolan.github.io/jq/download/) version 1.6 and above!

### With Docker

* `docker pull envwarden/envwarden`

## Usage

### Adding secrets to Bitwarden

![](https://raw.githubusercontent.com/envwarden/envwarden/master/assets/bitwarden-item-screenshot.png "bitwarden item for envwarden")

* Create an item you'd like to use for storing secrets.
  Try to make its name unique, so envwarden can easily find it
  and not any unrelated items.
  You might want to define the name based on your server or environment
  (e.g. `staging`, `development`, `production`)
* Add custom fields for each secure environment variable you need
  (fields can be text, hidden or boolean)
* You can add as many fields as you need, and you can also create
  multiple items, as long as they match the same search term
  (their secrets would be combined)
* You can also copy attachments on the searched items to a destination folder
* You should use separate logins for each environment, and ideally limit server
  access to only the secrets it needs, but it's up to you how to manage it

### Getting secrets onto your server

* You can store your Bitwarden login credentials inside `~/.envwarden` if you wish
* Otherwise, you would be prompted for your email and password (or both)
* You can then use `eval $(envwarden)` to get your secrets `export`ed to your environment
* Alternatively, you can output your secrets into an `.env` file using `envwarden --dotenv`

```
Usage: envwarden [--help] [--search] [--dotenv] [--copy]

To export environment variables, use: `eval $(envwarden)`
To create an .env file, use: `envwarden --dotenv > .env`

Options:
    -h --help
    -s --search <keyword> (optional) define the search term for bitwarden items (defaults to 'envwarden')
    -d --dotenv (optional) outputs to stdout in .env format
    -k --dotenv-docker (optional) outputs secrets to stdout in a "docker-friendly" .env format (no quotes)
    -c --copy <destination folder> (optional) copies all attachments on the item to a folder
    -g --github envs to github actions compliance

You can use ~/.envwarden to store your credentials (just email, or email:password)
```

### Running with Docker

You can provide your Bitwarden username and password using three methods:

```
# 1. Passing as environment to Docker
docker run -ti -e BW_USER=user@example.com -e BW_PASSWORD=careful envwarden/envwarden

# 2. Mapping your `.envwarden` file
docker run -ti -v $HOME/.envwarden:/root/.envwarden envwarden/envwarden

# 3. Waiting for `bw` to prompt for it for you
docker run -ti envwarden/envwarden
```

### Importing secrets to Kubernetes

[with just 3 lines of bash](https://blog.gingerlime.com/2019/envwarden-and-kubernetes-secrets/)

## Notes

`envwarden` is a very simple bash script that wraps around the `bw` CLI. You can inspect it to make sure it's secure and
doesn't leak your secrets in any way. I tried to keep it as simple as possible, and also secure.

`eval` is generally dangerous to run, but the script makes an effort to protect against command injection.
`--dotenv` might be a slightly safer option if your application can work with `.env` files. Besides that, if you're
worried about command injection from people who have write access to your secrets, you might have bigger problems to
worry about, and perhaps `envwarden` isn't for you :)

`envwarden` would login and sync on every invocation. This isn't the fastest, but ideally you only need to run this when
you bootstrap a new system, when you deploy, or when you need to refresh your secrets (in all cases, it probably makes
sense to fetch the fresh secrets anyway).

`envwarden` is still experimental. Please use at your own risk. Feedback is welcome.

`envwarden` is not affiliated or connected to Bitwarden or its creators 8bit Solutions LLC in any way.
