# TalkingPts Monitoring Bots.

A set of [bot][bot.docs] scripts to monitor use case scenarios of production services.

[bot.docs]: https://github.com/TalkingPts/Infrastructure/blob/master/docs/uwsbot.md

# Development.

## Setup.

To build the bots engine container locally just run:

	$ make build

It will download the latest release of the bot's engine so you can run scripts locally.

To upgrade the container/force the build:

	$ make upgrade

All scripts are run against **staging** environment. You need a `credentials.yml` file
so the bot can authenticate to the api.

Download [credentials.yml][bot.auth] file and save it under `docker/auth` directory
inside this repository. You need a personal **certificate** to get the credentials file.

[bot.auth]: https://jsbatch.uws.talkingpts.org/uwsbot/credentials.yml

## Documentation.

Run `./docs.sh` script and it will show you some help about the modules and functions
available for the scripts. It runs a container to show you a text file, quite a waste
of resources, but it's included in the container so it gets updated on new releases.

## bot.ank

Bots are defined using the `<botname>/bot.ank` file. In example: [api/bot.ank](./api/bot.ank).

That file is the *core* of the bot. It's the common code for all the scripts.
That code is run as part of the load process of the bot. So it's the first code any script
will run. All the defined/declared functions and variables there will be available for all the
scripts.

## Scripts.

Scrips are placed under `<botname>/run` directory. In example: [api/run](./api/run/).
Only `.ank` files will be used. Like [api/run/login_logout.ank](api/run/login_logout.ank).

They all run as a separate process. So they do not share any global scope. Not even variables declared in `bot.ank` file. That code is ran for each script on its own
process scope.

## Run.

To run bot's scripts you can use `<botname>/run.sh`. In example, to run *api* bot scripts you can do the following:

    $ ./api/run.sh

That will run all scripts (in parallel) under `api/run` directory.

If you want to run just one script, you can call `api/run.sh` with the script's name, which is the filename *without* the `.ank` extension. In example, to only run
`api/run/login_logout.ank` script you can do the following:

    $ ./api/run.sh login_logout

## Debug.

You can get some debug information setting `UWS_LOG` env var as `debug`. In example:

    $ UWS_LOG=debug ./api/run.sh login_logout

Or `export UWS_LOG=debug` to set it globally (in the current shell session).

Error messages will be reported anyway, you don't need to enable debug logs for that.

## Config.

Bots load a configuration file based on the environment its running under. In example,
for *staging* environment the *staging.yml* configuration file will be loaded.

Configuration files *MUST* be present, even if empty.

And should be saved as `<botname>/config/<env>.yml`.
In example: [api/config/staging.yml](api/config/staging.yml).

Other files can be included (only one level of depth) using the `include:` setting.
It's the only *reserved word*, you can *not* have config settings called *include*, you
*can* use *INCLUDE* though or any other combination.

Usually an env config loads [api/config/default.yml](api/config/default.yml) file first
and then only the specific settings for this environment are changed.

Config setting values can be expanded to other config settings. In example:

    # example-config.yml
    PREFIX: /uws
    BOTDIR: ${PREFIX}/share/uwsbot

Values are only expanded when requested, so you can refer to non-existent (yet) values in
the config file as they are not expanded during parsing time.

**Only** `${VARNAME}` syntax is allowed.

# Deploy.

Bots can be deployed to *jsbatch* server via a `git push`. You can set it up as follows:

	$ git remote add deploy uwsrun@jsbatch.uws.talkingpts.org:/srv/deploy/monbots.git

And then just:

	$ git push deploy

But you need authorization first for that.

# Stats.

* [Staging](https://jsbatch.uws.talkingpts.org/munin/staging.t.o/app.staging.t.o/index.html#uwsbot)
* [Production](https://jsbatch.uws.talkingpts.org/munin/t.o/app.t.o/index.html#uwsbot)
