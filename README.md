# Jail

Found a nice Jquery plugin you'd like to try out ? Now starts the RSIs :
Download, unpack, find the source files, open your app folder, drag in the javascript folder, drag in the stylesheet folder, drag in the images folder...  Oh but wait, there's a better version of (modal/fancybox/slider/datepicker...). Download, unpack, find the source... _This must stop !_

Meet Jail : it puts all your Javascripts (& cie) in Rails, with just a click!

**NOW** With the 158 (sept/12) [CDNJS libraries](/cdnjs/cdnjs).

## Install

    gem 'jail', :group => "development"

config/routes.rb

    mount Jail::Engine => "/jail" if Rails.env.development?

## Usage

http://localhost:3000/jail/

Chose a plugin, follow the link, Install. You're done.


![jail](/charly/jail/raw/master/jail.png)

---

Oh wait you might have to add :

    //=require myplugin.js

And if you're not happy with the actual set of Jquery plugins proposed. Add your own!

config/initializers/jail.rb

    module Jail
      LOGIN = 'login:password' #optional
      Jail::Github.add_githublist(Rails.root.join("config/jail.backboneplugins.yml"))
      Jail::Github.add_githublist(Rails.root.join("config/jail.whatever.yml"))
    end

Buth the list is bound to grow quickly.

## Usage (alt)

While waiting for a bin/jail feature:

    rails console
    > Jail::Github.find("name", "repo").install

But it must exist in the yaml file !!!

## Contribute

The list of plugins are in a yaml file : config/jail.jqueryplugins.yml
Add more plugins and pull a request!
Would it be better to have them in the db ?


## Why an Engine ?

Other approaches where : 
  - create a gem for each jquery plugin. But that means updating the gem with the latest release of each plugin and nobody wants to keep track of dozens of repos. 
  - Do a generator instead but, while the thought came to me while writing this gem, I didn't find any remote feature in Thor (may be wrong though since rails templates has it). **update** : it has one (of course)!

## TODO

  - Pjax for loading plugin
  - plugin installed? (check file existence)
  - plugin outdated? (overkill ?)
  - bin/jail

## Changelog

  ### 0.2.0
    - Cdnjs now shows **subfolder content**
    - fixed bug trying to download a folder
    - (fix) creates non existing path before downloading

  ### 0.1.1
    - CDNJS Integration + Some Github Refactoring

## Thanks to

- [Walter Davis](/walterdavis) for suggesting the awesome idea of including the cdnjs library.

This project rocks and uses MIT-LICENSE.

