setup-drupal.sh
#!/bin/bash

echo "📦 Setting up Drupal from RSVP Composer project..."

# Define target directory for installation
DRUPAL_ROOT="/var/www/html/gluebox"

# Composer project repo
COMPOSER_REPO="https://github.com/slackstone/rsvp_composer.git"

# Build if not already installed
if [ ! -f "$DRUPAL_ROOT/composer.json" ]; then
  echo "📁 Cloning RSVP Composer project..."
  git clone "$COMPOSER_REPO" "$DRUPAL_ROOT"
  cd "$DRUPAL_ROOT"
  echo "📦 Running composer install..."
  composer install
else
  echo "✅ Drupal project already present at $DRUPAL_ROOT"
fi

# Set permissions
echo "🔧 Fixing permissions..."
chown -R www-data:www-data "$DRUPAL_ROOT"
chmod -R 755 "$DRUPAL_ROOT"

# Enable Apache rewrite module
echo "🔄 Enabling Apache rewrite..."
a2enmod rewrite

# Create Apache vhost if needed
VHOST="/etc/apache2/sites-available/gluebox.conf"
if [ ! -f "$VHOST" ]; then
  echo "📝 Creating Apache vhost for Drupal..."
  cat <<EOF > "$VHOST"
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    DocumentRoot $DRUPAL_ROOT/web

    <Directory $DRUPAL_ROOT/web>
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/gluebox-error.log
    CustomLog \${APACHE_LOG_DIR}/gluebox-access.log combined
</VirtualHost>
EOF

  a2ensite gluebox.conf
  a2dissite 000-default.conf
fi

# Restart Apache
echo "🔁 Restarting Apache..."
systemctl restart apache2

echo "✅ Drupal is now available at: http://localhost"
