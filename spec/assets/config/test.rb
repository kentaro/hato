Hato::Config.define do
  config.api_key = 'test'
  config.host    = '0.0.0.0'
  config.port    = 9699

  tag 'test' do
    plugin 'Ikachan' do
      config.scheme  = 'http'
      config.host    = 'irc.example.com'
      config.port    = 4979
      config.channel = 'hato'
    end

    plugin 'Mail' do
      config.smtp = {
        address:   'smtp.example.com',
        port:      587,
        domain:    'example',
        user_name: 'hato',
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
        from: 'hato@example.com',
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
