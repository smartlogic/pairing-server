## Setup a Server for Remote Pairing

First

    knife bootstrap pairing --template-file ubuntu-12.04-lts.erb

Then setup databags, see samples.

Then

    bundle exec knife cook pairing -V
