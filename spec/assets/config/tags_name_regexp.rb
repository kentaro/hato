Hato::Config.define do
  api_key 'test'
  host    '0.0.0.0'
  port    9699

  tag /(.+) and (.+)/ do |match|
    plugin 'Ikachan' do
      scheme  'http'
      host    'irc.example.com'
      port    4979
      channel 'hato'
    end

    plugin 'Mail' do
      smtp address:   'smtp.example.com',
           port:      587,
           domain:    'example',
           user_name: 'hato',
           password:  'password',
           enable_ssl: true

      subject_template = <<EOS
[<%= args[:tag] %>] Notification
EOS
      body_template = <<EOS
You've got a message:

<%= args[:message] %>
EOS

      message from: 'hato@example.com',
              to:   [
                'foo@example.com',
                'bar@example.com',
              ],
              subject_template: subject_template,
              body_template:    body_template
    end
  end
end
