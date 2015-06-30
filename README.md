# Billycom Web
Web-based telecommunications billing platform that automates and performs telecom billing functions for telecom providers, interconnect companies, telephone lines and long distance resellers. This web-based telecom billing system allows you to import the call detail records (CDR) that you receive from your telecom providers and automatically generates the bills for your end clients, based on the rates you set up by using Billycom’s user interface. Then you can either print these invoices or send them directly to your end clients via email.

![](https://shinyhelmets.files.wordpress.com/2010/06/picture-7.png)

### Requisites
* MySQL Database
* Ruby 1.9.3-p374
* Rails 3.2.11
* An Amazon S3 account (Billycom Web is designed to store uploaded CDRs and generated bills in Amazon S3)

### Setting up Billycom Web
1. Fill the database connection info for development, test and production in `config/databases.yml`
2. Enter your Amazon S3 credentials in `config/initializers/carrierwave.rb` (A S3 account is required in order to store CDRs and generated Invoices)
3. Enter your SMTP config parameters in `config/initializers/settings.rb` (A SMTP server is required in order to send invoices to clients via email)
4. Run `bundle install` from the top folder in order to install the required gems.
5. Run `RAILS_ENV=[your_environment_name_here] rake db:migrate` from the top folder in order to run the database scripts.

### Running Billycom Web locally
1. Start the billing engine by running `script/delayed_job start`
2. Start the web server: `rails server` (run with --help for options)
3. Go to http://localhost:3000/

### Create your First Company Account
See [Creating a Company Account](https://github.com/reinaldo13/billycom-web/wiki/Creating-a-Company-Account) document in our [documentation](https://github.com/reinaldo13/billycom-web/wiki/Billycom-Web-Documentation) Wiki.

### Using Billycom Web
See our [documentation](https://github.com/reinaldo13/billycom-web/wiki/Billycom-Web-Documentation)

### Description of Contents
The directory structure:
```
  |-- app
  |   |-- assets
  |       |-- images
  |       |-- javascripts
  |       `-- stylesheets
  |   |-- controllers
  |   |-- helpers
  |   |-- mailers
  |   |-- models
  |   `-- views
  |       `-- layouts
  |-- config
  |   |-- environments
  |   |-- initializers
  |   `-- locales
  |-- db
  |-- doc
  |-- lib
  |   `-- tasks
  |-- log
  |-- public
  |-- script
  |-- test
  |   |-- fixtures
  |   |-- functional
  |   |-- integration
  |   |-- performance
  |   `-- unit
  |-- tmp
  |   |-- cache
  |   |-- pids
  |   |-- sessions
  |   `-- sockets
  `-- vendor
      |-- assets
          `-- stylesheets
      `-- plugins
```

* app: Holds all the code that's specific to this particular application.
* app/assets: Contains subdirectories for images, stylesheets, and JavaScript files.
* app/controllers: Holds controllers that should be named like weblogs_controller.rb for automated URL mapping. All controllers should descend from ApplicationController which itself descends from ActionController::Base.
* app/models: Holds models that should be named like post.rb. Models descend from ActiveRecord::Base by default.
* app/views: Holds the template files for the view that should be named like weblogs/index.html.erb for the WeblogsController#index action. All views use eRuby syntax by default.
* app/views/layouts: Holds the template files for layouts to be used with views. This models the common header/footer method of wrapping views. In your views, define a layout using the <tt>layout :default</tt> and create a file named default.html.erb. Inside default.html.erb, call <% yield %> to render the view using this layout.
* app/helpers: Holds view helpers that should be named like weblogs_helper.rb. These are generated for you automatically when using generators for controllers. Helpers can be used to wrap functionality for your views into methods.
* config: Configuration files for the Rails environment, the routing map, the database, and other dependencies.
* db: Contains the database schema in schema.rb. db/migrate contains all the sequence of Migrations for your schema.
* doc: This directory is where your application documentation will be stored when generated using <tt>rake doc:app</tt>
* lib: Application specific libraries. Basically, any kind of custom code that doesn't belong under controllers, models, or helpers. This directory is in the load path.
* public: The directory available for the web server. Also contains the dispatchers and the default HTML files. This should be set as the DOCUMENT_ROOT of your web server.
* script: Helper scripts for automation and generation.
* test: Unit and functional tests along with fixtures. When using the rails generate command, template test files will be generated for you and placed in this directory.
* vendor: External libraries that the application depends on. Also includes the plugins subdirectory. If the app has frozen rails, those gems also go here, under vendor/rails/. This directory is in the load path.
Support

### License
MIT License: You can do anything you want with this code **as long as you provide attribution back to me and don’t hold me liable**.

### Support
* To ask questions, report defects or make suggestions please go to: https://github.com/reinaldo13/billycom-web/issues
* To enquire about consulting services including installation, training and customization please contact me at reinaldo13+github@gmail.com
