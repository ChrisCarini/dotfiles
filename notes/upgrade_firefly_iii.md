# Commands to upgrade / install firefly-iii on Dreamhost hosting (including custom php install)

(*Note:* These are likely incomplete, and will need to be tested for correctness next time I upgrade.)

0. BACKUP ALL THE THINGS!!!
    - Database
    - The current directory
        ```shell script
        cd ~/firefly.*
        
        cp -r firefly-iii firefly-iii-backup-$(date +%F_%H_%M)
        ```
1. Download desired version of PHP, configure, build and install the desired version of PHP.
   ```shell script
    
    # GO TO :> https://www.php.net/downloads.php
    #
    # Find the link of the version you wish to download; file extension `.tar.bz2`
    
    PHP_VERSION_DOWNLOAD_URL=https://www.php.net/distributions/php-7.4.1.tar.bz2
    
    PHP_ARCHIVE_FILENAME=php-*.tar.bz2
    
    wget $PHP_VERSION_DOWNLOAD_URL
    
    sha256sum $PHP_ARCHIVE_FILENAME
    
    tar -vxjf $PHP_ARCHIVE_FILENAME
    
    rm $PHP_ARCHIVE_FILENAME
    
    cd ~/php-*
    
    ./configure  \
        --prefix=$HOME/local \
        --with-ldap \
        --with-openssl \
        --with-curl \
        --enable-bcmath \
        --enable-intl \
        --with-mysql-sock \
        --with-mysqli \
        --with-pdo-mysql \
        --enable-mbstring \
        --disable-mbregex \
        --enable-gd \
        --with-zlib
    #    --enable-mbstring \
    #    --enable-mbregex \
    #    --enable-mbregex-backtrack \
    make
    make install
   ```
    !!!!!!! NOTE !!!!!!!
    If you get the following:
    ```
    Generating phar.phar
    PEAR package PHP_Archive not installed: generated phar will require PHP's phar extension be enabled.
    
    Fatal error: Uncaught InvalidArgumentException: RegexIterator::__construct(): Allocation of JIT memory failed, PCRE JIT will be disabled. This is likely caused by security restrictions. Either grant PHP permission to allocate executable memory, or set pcre.jit=0 in $HOME/php-7.3.13/ext/phar/phar.php:1133
    Stack trace:
    #0 $HOME/php-7.3.13/ext/phar/phar.php(1133): RegexIterator->__construct(Object(RecursiveIteratorIterator), '/\\.svn/')
    #1 $HOME/php-7.3.13/ext/phar/phar.php(1077): PharCommand::phar_add(Object(Phar), 0, '$HOME/p...', NULL, '/\\.svn/', Object(SplFileInfo), NULL, true)
    #2 $HOME/php-7.3.13/ext/phar/phar.php(225): PharCommand->cli_cmd_run_pack(Array)
    #3 $HOME/php-7.3.13/ext/phar/phar.php(2089): CLICommand->__construct(19, Array)
    #4 {main}
      thrown in $HOME/php-7.3.13/ext/phar/phar.php on line 1133
    Makefile:418: recipe for target 'ext/phar/phar.phar' failed
    make: *** [ext/phar/phar.phar] Error 255
    ```
    You can 'solve' it (aka, get passed it) by adding `ini_set("pcre.jit", "0");` in front of the respective line (1133).
    
    You can also pass `-d pcre.jit=0` to the `php` executable (like; `php -d pcre.jit=0 <normal command>`)

1. Change directory into the subdomain folder
    ```shell script
    cd ~/firefly.*
    ```

1. Install PHP Composer (see `install_php_composer.sh` in this directory)

1. Follow the directions at -> https://docs.firefly-iii.org/advanced-installation/upgrade#virtual-or-real-server

    ```shell script
    # PHP_BINARY=/usr/local/php74/bin/php
    PHP_BINARY=$HOME/local/bin/php   # OUR CUSTOM-BUILT PHP INSTALL
    
    $PHP_BINARY -d pcre.jit=0 composer.phar create-project grumpydictator/firefly-iii --no-dev --prefer-dist firefly-iii-updated 5.3.3
    
    cp firefly-iii/.env firefly-iii-updated/.env
    cp firefly-iii/storage/upload/* firefly-iii-updated/storage/upload/
    cp firefly-iii/storage/export/* firefly-iii-updated/storage/export/
    
    cd firefly-iii-updated/
    
    rm -rf bootstrap/cache/*
    
    $PHP_BINARY artisan cache:clear
    $PHP_BINARY artisan migrate --seed
    $PHP_BINARY artisan firefly-iii:upgrade-database
    $PHP_BINARY artisan passport:install
    $PHP_BINARY artisan cache:clear
    
    cd ..
    
    mv firefly-iii firefly-iii-backup-$(date +%F)
    mv firefly-iii-updated firefly-iii
    ``` 
















OLDER NOTES
===========
```shell script

$PHP_BINARY -d pcre.jit=0 ../composer.phar install --no-scripts --no-dev
$PHP_BINARY -d pcre.jit=0 composer.phar install --no-dev
$PHP_BINARY artisan migrate --seed
$PHP_BINARY artisan firefly-iii:decrypt-all
$PHP_BINARY artisan cache:clear
$PHP_BINARY artisan firefly-iii:upgrade-database
$PHP_BINARY artisan passport:install
$PHP_BINARY artisan cache:clear

```


1. Steal the configure command from the default php install
Create a `php_info.php` file:
```php
<? phpinfo(); ?>
```

3. Install and migrate the needed directories from the old installation.
```
cd ~/firefly.*/firefly-iii-github
export PATH=$HOME/local/bin:$PATH
php composer.phar install --no-scripts --no-dev
php composer.phar install --no-dev
php artisan migrate --seed
php artisan firefly-iii:decrypt-all
php artisan cache:clear
php artisan firefly-iii:upgrade-database
php artisan passport:install
php artisan cache:clear
```