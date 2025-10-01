# نختار صورة PHP
FROM php:8.0-fpm


# نثبت بعض المكتبات اللي Laravel كيحتاجها
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zip \
    git \
    unzip \
    curl \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo pdo_mysql gd

# نضيف composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# نحدد مجلد العمل
WORKDIR /var/www

# ننسخ ملفات المشروع
COPY . .

# نثبت dependencies
RUN composer install --no-interaction --prefer-dist --optimize-autoloader

# نضبط صلاحيات التخزين
RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache
