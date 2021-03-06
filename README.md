# Hato [![BuildStatus](https://secure.travis-ci.org/kentaro/hato.png)](http://travis-ci.org/kentaro/hato)

Hato is a tool to manage various notification methods. Once you configure notification methods, you can send messages via the methods just by posting them to Hato.

## Usage

Launch Hato with `hato` command:

```
$ hato -c config.rb
```

### Notification

Post your notification message:

```
$ curl -d 'message=test' -d 'tag=test' -d 'api_key=test' http://localhost:9699/notify
```

### WebHook

Hato supports GitHub/GitHub Enterprise-formatted webhook. Path is expected to be `/webhook/:owner/:repository` like below:

```
$ curl -d 'payload={...}' -d 'api_key=test' http://localhost:9699/webhook/kentaro/hato
```

Tag is automatically built from the path. For example, the tag for the path above will be `webhook.kentaro.hato`.

Consult [the documentation](https://help.github.com/articles/post-receive-hooks) for the details of webhook.

## Configuration

Hato provides DSLs for configuration.

e.g. config.rb:

```
Hato::Config.define do
  api_key 'test'
  host    '0.0.0.0'
  port    9699

  # exact string mathing
  tag 'test' do
    plugin 'AwesomePlugin' do
      key1 'value1'
      key2 'value2'
      key3 'value3'
    end
  end

  # regexp matching
  tag /^test2\.([^\.]+)\.([^\.]+)$/ do |matched1, matched2|
    plugin 'AwesomePlugin' do
      key1 matched1
      key2 matched2
    end
  end

  # webhook
  tag /^webhook\.([^\.]+)\.([^\.]+)$/ do |owner, repository|
    plugin 'AwesomePlugin' do
      key1 owner
      key2 repository
    end
  end
end
```

## Plugin Architecture

There have already been some plugins:

  * [Hato::Plugin::Ikachan](https://github.com/kentaro/hato-plugin-ikachan)
  * [Hato::Plugin::Mail](https://github.com/kentaro/hato-plugin-mail)
  * [Hato::Plugin::Hipchat](https://github.com/banyan/hato-plugin-hipchat)
  * [Hato::Plugin::Twitter](https://github.com/kentaro/hato-plugin-twitter)
  * [Hato::Plugin::Imkayac](https://github.com/kitak/hato-plugin-imkayac)

You can easily extend Hato by creating your own plugins. See the source for detail. It's really easy.

## Using Hato with Thrid-party Plugins

At first, create a `Gemfile` to manage dependencies:

```
source 'https://rubygems.org'

gem 'hato'
gem 'hato-plugin-mail'
gem 'hato-plugin-ikachan'
```

Then, execute `bundle exec hato -c your_config_file`

## Installation

Add this line to your application's Gemfile:

    gem 'hato'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hato

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

