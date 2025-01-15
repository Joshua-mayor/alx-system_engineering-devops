# Install Nginx
package { 'nginx':
  ensure => installed,
}

# Ensure the Nginx service is running and enabled
service { 'nginx':
  ensure    => running,
  enable    => true,
  require   => Package['nginx'],
}

# Configure Nginx to serve "Hello World!" at the root
file { '/var/www/html/index.html':
  ensure  => file,
  content => '<html>
<head>
    <title>Hello</title>
</head>
<body>
    Hello World!
</body>
</html>',
  require => Package['nginx'],
}

# Set up a 301 redirect for /redirect_me
file { '/etc/nginx/sites-available/default':
  ensure  => file,
  content => template('nginx/default.erb'),
  notify  => Service['nginx'],
}

# Template for the Nginx configuration
file { '/etc/nginx/templates/default.erb':
  ensure  => file,
  content => '
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/html;
    index index.html;

    server_name _;

    location / {
        try_files $uri $uri/ =404;
    }

    location /redirect_me {
        return 301 https://www.youtube.com/watch?v=QH2-TGUlwu4;
    }
}',
  require => Package['nginx'],
  notify  => Service['nginx'],
}
