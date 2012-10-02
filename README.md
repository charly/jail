# Jail

Copying, pasting, 'curling', running after all those jquery-plugin files, trying to keep track, loosing them, pulling your hair off. This must stop !
Put all your jquery plugins (or any other assets) in rails once and for all. 
And if you want to free them, just open the gate.

## Install

    gem 'jail', :group => "development"

config/routes.rb

    mount Jail::Engine => "/jail"

## Usage

http://localhost:3000/jail/

Chose a plugin, follow the link, Install. You're done.
Oh no wait you still have to add :

    //=require myplugin.js

![jail](/charly/jail/raw/master/jail.png)

## Usage (alt)

While waiting for a bin/jail feature:

    rails console
    > Jail::Github.find("name", "repo").install

But it must exist in the yaml file !!!

## Contribute

The list of plugins are in a yaml file : config/prisoners.yml
Add more plugins and pull a request!
Would it be better to have them in the db ?


## Why an Engine ?

Other approaches where : 
  - create a gem for each jquery plugin. But that means updating the gem with the latest release of each plugin and nobody wants to keep track of dozens of repos. 
  - Do a generator instead but, while the thought came to me while writing this gem, I didn't find any remote feature in Thor (may be wrong though since rails templates has it).

## TODO

- plugin installed? (check file existence)
- plugin outdated? (overkill ?)
- clean routes
- bin/jail


This project rocks and uses MIT-LICENSE.