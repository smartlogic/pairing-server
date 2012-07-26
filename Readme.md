## Setup a Server for Remote Pairing

First

    knife bootstrap <pairing_server_name> --template-file ubuntu-12.04-lts.erb

Edit the node json file for what you want

    {
      "domain": "example.com",
      "build-essential" : {
          "compiletime" : true
      },
      "mysql" : {
        "server_root_password" : "SECRET_PASSWORD"
      },
      "postgresql" : {
        "password" : {
          "postgres" : "SECRET_PASSWORD"
        }
      },
      "openssh" : {
        "permit_root_login" : "no",
        "password_authentication": "no"
      },
      "run_list" : [
        "recipe[build-essential]",
        "recipe[annoyances]",
        "recipe[openssl]",
        "recipe[openssh]",
        "recipe[mysql::server]",
        "recipe[postgresql::server]",
        "recipe[packages]",
        "recipe[projects]"
      ]
    }

Then setup databags for people and projects, see samples.

Then

    bundle exec knife cook <pairing_server_name>

### Adding cookbooks

    knife cookbook site install <COOKBOOK NAME>
