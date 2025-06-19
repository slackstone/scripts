#!/bin/bash

echo "📦 Setting up Drupal from RSVP Composer project..."

DRUPAL_DIR="/var/www/html/gluebox"
COMPOSER_REPO="https://github.com/slackstone/rsvp_composer.git"

# Clone project if needed
if [ ! -f "$DRUPAL_DIR/composer.json" ]; then
  echo "📁 Cloning RSVP Composer project..."
  git clone "$COMPOSER_REPO" "$DRUPAL_DIR"
fi

cd "$DRUPAL_DIR" || exit 1

# Run composer install safely
echo "📦 Running composer install..."
COMPOSER_ALLOW_SUPERUSER=1 composer install

# Permissions
echo "🔧 Fixing permissions..."
chown -R www-data:www-data "$DRUPAL_DIR"
chmod -R 755 "$DRUPAL_DIR"

# Apache config
echo "🔄 Enabling Apache rewrite module..."
a2enmod rewrite || true

# Create vhost if missing
VHOST="/etc/apache2/sites-available/gluebox.conf"
if [ ! -f "$VHOST" ]; then
  echo "📝 Creating Apache vhost..."
  cat <<EOF > "$VHOST"
<VirtualHost *:80>
  DocumentRoot $DRUPAL_DIR/web
  <Directory $DRUPAL_DIR/web>
    AllowOverride All
    Require all granted
  </Directory>
</VirtualHost>
EOF
  a2ensite gluebox.conf
  a2dissite 000-default.conf
fi

# Try restarting Apache
echo "🔁 Restarting Apache..."
service apache2 restart || echo "⚠️ Apache restart failed (expected in Cubic chroot)"

echo "✅ Drupal should be available at: http://localhost"
