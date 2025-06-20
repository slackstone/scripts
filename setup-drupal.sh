#!/bin/bash

echo "📦 Setting up Drupal from RSVP Composer project..."

DRUPAL_DIR="/var/www/html/gluebox"
COMPOSER_REPO="https://github.com/slackstone/rsvp_composer.git"

if [ ! -d "$DRUPAL_DIR" ]; then
  echo "📁 Cloning RSVP Composer project..."
  git clone "$COMPOSER_REPO" "$DRUPAL_DIR"
else
  echo "📥 Updating existing Drupal project..."
  cd "$DRUPAL_DIR" || exit 1

  # Ensure safe Git usage
  git config --global --add safe.directory "$DRUPAL_DIR"

  # Pull latest changes
  git pull origin main

  # Clean existing install if needed
  rm -rf vendor/
  rm -f composer.lock
fi

cd "$DRUPAL_DIR" || exit 1

echo "📦 Running composer install..."
COMPOSER_ALLOW_SUPERUSER=1 composer install

# Set permissions
echo "🔧 Fixing permissions..."
chown -R www-data:www-data "$DRUPAL_DIR"
chmod -R 755 "$DRUPAL_DIR"

# Apache setup
echo "🔄 Enabling Apache rewrite module..."
a2enmod rewrite || true

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

echo "🔁 Restarting Apache..."
service apache2 restart || echo "⚠️ Apache restart failed (OK in Cubic chroot)"

echo "✅ Drupal is now ready at: http://localhost"
