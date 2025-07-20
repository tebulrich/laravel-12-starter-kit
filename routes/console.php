<?php

use Illuminate\Foundation\Inspiring;
use Illuminate\Support\Facades\Artisan;

Artisan::command('inspire', function () {
    $this->comment(Inspiring::quote());
})->purpose('Display an inspiring quote');

Artisan::command('logs:rotate', function () {
    $this->info('Rotating logs...');
    exec('/usr/sbin/logrotate /etc/logrotate.d/laravel-log-rotate --state /var/lib/logrotate/status');
    $this->info('Logs have been rotated.');
})->purpose('Rotate Laravel logs using logrotate');
