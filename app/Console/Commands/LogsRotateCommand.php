<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;

class LogsRotateCommand extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'logs:rotate';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Rotate Laravel logs using logrotate';

    /**
     * Execute the console command.
     *
     * @return int
     */
    public function handle()
    {
        $this->info('Rotating logs...');
        exec('/usr/sbin/logrotate /etc/logrotate.d/laravel-log-rotate --state /var/lib/logrotate/status');
        $this->info('Logs have been rotated.');

        return 0;
    }
}
