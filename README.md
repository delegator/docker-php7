# delegator/php7

[![](https://badge.imagelayers.io/delegator/php7:latest.svg)](https://imagelayers.io/?images=delegator/php7:latest)

[Debian][1] for PHP web applications, based on `php:7.0.2-fpm`. Use this image as
a base for your own Docker images.

# Image contents

Latest stable versions of:

 - [Nginx][2] web server
 - [PHP][3] with all modules required by WordPress and Magento
 - [Ruby][4], and [node.js][5] for any asset building processes you might have

Handy PHP command-line tools:
 - [composer][6]
 - [n98-magerun][7]
 - [wp-cli][8]

# Building from source
```bash
# Plain, vanilla, just-build-the-image command
$ make

# Ignore cache when building layers
$ make force
```

# Testing this image

```bash
# This invokes `docker run --rm -p 3000:80 delegator/php`
$ make test
```

...then visit `http://localhost:3000` in your favorite browser.

# Customizing your derived image

### Nginx

Place your nginx `server` definitions in `/etc/nginx/sites-enabled`. Nginx will
automatically load all `.conf` files that exist in `/etc/nginx/conf.d`. Files
intended to be "included" belong in `/etc/nginx/snippets`.

### php-fpm

The php-fpm process is listening locally on TCP port 9000.

[1]: https://www.debian.org/
[2]: http://nginx.org/
[3]: https://secure.php.net/
[4]: https://www.ruby-lang.org/en/
[5]: https://nodejs.org/
[6]: https://getcomposer.org/
[7]: http://magerun.net/
[8]: http://wp-cli.org/
