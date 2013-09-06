Pigeon::Config.define do
  config.api_key = 'YOUR API KEY'
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
        domain:    'example.com',
        user_name: 'pigeon',
        password:  'password',
      }
      config.message = {
        from: 'pigeon@example.com',
        to:   [
          'foo@example.com',
          'bar@example.com',
        ],
        subject_template: <<EOS,
[<%= args[:tag] %>] Notification
EOS
        body_template: <<EOS,
You've got a message:

[<%= args[:message] %>]
EOS
      }
    end
  end
end
