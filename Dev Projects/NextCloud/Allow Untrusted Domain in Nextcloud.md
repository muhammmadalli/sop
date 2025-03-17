# Allow Untrusted Domain in Nextcloud

To allow untrusted domains in Nextcloud, you need to modify the `config.php` file in your Nextcloud installation. Here’s how to do it:

## **Locate the** `**config.php**` **File:**

-   The  `config.php` file is typically found in the `config` directory of your Nextcloud installation. The path might look something like this: `/path/to/nextcloud/config/config.php`.

## **Open the** `**config.php**` **File:**

-   Open the file with a text editor. You may need administrative privileges to edit this file.

## **Edit the Trusted Domains Section:**

-   Look for the `trusted_domains` array in the `config.php` file. It will look something like this:

```php
'trusted_domains' => 
array (
  0 => 'localhost',
  1 => 'example.com',
  2 => 'nextcloud.example.com',
),
```

-   Add the domains you want to trust to this array. For example, if you want to add `myuntrusted.domain`, modify it like this:

```php
'trusted_domains' => 
array (
  0 => 'localhost',
  1 => 'example.com',
  2 => 'nextcloud.example.com',
  3 => 'myuntrusted.domain',
),
```

## **Save the** `**config.php**` **File:**

-   Save your changes to the file and exit the text editor.

## **Restart Your Web Server:**

1.  Save your changes to the file and exit the text editor.
2.  If necessary, restart your web server to apply the changes. The command to restart the web server depends on which server software you are using. For example, for Apache, you might use:

```plaintext
sudo service apache2 restart
```

For Nginx, you might use:

```plaintext
sudo service nginx restart
```

By following these steps, you can allow access to Nextcloud from additional, previously untrusted domains.