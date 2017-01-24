# delegator/php7

[![](https://images.microbadger.com/badges/image/delegator/php7.svg)](http://microbadger.com/images/delegator/php7)
[![](https://images.microbadger.com/badges/version/delegator/php7.svg)](https://microbadger.com/images/delegator/php7)

[Debian][1] for PHP web applications, based on `php:7.0.15-fpm`. Use this image as
a base for your own Docker images.

# Image contents

Core components:

 - [Nginx][2] web server
 - [PHP][3] with all modules required by WordPress and Magento
 - [Ruby][4] and [node.js][5] for any asset building processes you might have

Handy PHP command-line tools:

 - [composer][6]
 - [n98-magerun][7]
 - [wp-cli][8]

# Building this image from source

```bash
# Describe available make targets
$ make help

# Plain, vanilla, just-build-the-image command
$ make

# Use cache when building layers (useful for debugging)
$ make build
```

# Testing this image

```bash
# Visit http://localhost:3000/ in your favorite browser
$ make test
```

# Customizing your derived image

### Nginx

Place your nginx `server` definitions in `/etc/nginx/sites-enabled`. Nginx will
automatically load all `.conf` files that exist in `/etc/nginx/conf.d`. Files
intended to be "included" belong in `/etc/nginx/snippets`.

### php-fpm

The php-fpm process is listening locally on TCP port 9000.

### nullmailer

This package is included in order to easily funnel email through your favorite
email-as-a-service provider. Be sure to override all files under `/etc/nullmailer`.

An example `remotes` entry for Amazon SES SMTP:

```
email-smtp.us-east-1.amazonaws.com smtp --port=587 --starttls --user=your_username_here --pass=your_password_here
```

[1]: https://www.debian.org/
[2]: http://nginx.org/
[3]: https://secure.php.net/
[4]: https://www.ruby-lang.org/en/
[5]: https://nodejs.org/
[6]: https://getcomposer.org/
[7]: http://magerun.net/
[8]: http://wp-cli.org/
