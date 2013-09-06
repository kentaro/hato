# Pigeon [![BuildStatus](https://secure.travis-ci.org/kentaro/pigeon.png)](http://travis-ci.org/kentaro/pigeon)

Pigeon is a tool to manage notification methods. Once you configure notification methods, you can send notifications via the methods just by posting message to this tool.

## Usage

```
$ pigeon -c config.rb
```

## Configuration

Pigeon provides DSLs for configuration.

e.g. config.rb:

```
Pigeon::Config.define do
  config.api_key = 'test'
  config.host    = '0.0.0.0'
  config.port    = 9699

  tag 'test' do
    plugin 'Ikachan' do
      config.scheme  = 'http'
      config.host    = 'irc.example.com'
      config.port    = 4979
      config.channel = 'pigeon'
    end

    plugin 'Mail' do
      config.smtp = {
        address:   'smtp.example.com',
        port:      587,
        domain:    'example',
        user_name: 'pigeon',
        password:  'password',
        enable_ssl: true,
      }

      subject_template = <<EOS
[<%= args[:tag] %>] Notification
EOS
      body_template = <<EOS
You've got a message:

<%= args[:message] %>
EOS

      config.message = {
        from: 'pigeon@example.com',
        to:   [
          'foo@example.com',
          'bar@example.com',
        ],
        subject_template: subject_template,
        body_template:    body_template,
      }
    end
  end
end
```

## Plugin Architecture

Pigeon bundles several plugins by default:

  * [Pigeon::Plugin::Ikachan](lib/pigeon/plugin/ikachan.rb)
  * [Pigeon::Plugin::Mail](lib/pigeon/plugin/mail.rb)

You can easily extend Pigeon by creating your own plugins. See the source for detail. It's really easy.

## Using Pigeon with Thrid-party Plugins

At first, create a `Gemfile` to manage dependencies:

```
source 'https://rubygems.org'

gem 'pigeon'
gem 'pigeon/plugin/awesome_plugin'
```

Then, execute `bundle exec pigeon -c your_config_file`

## Installation

Add this line to your application's Gemfile:

    gem 'pigeon'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pigeon

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
