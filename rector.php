<?php

declare(strict_types=1);

use Rector\Config\RectorConfig;
use Rector\Set\ValueObject\SetList;
use Rector\ValueObject\PhpVersion;
use RectorLaravel\Set\LaravelSetList;

return static function (RectorConfig $rectorConfig): void {
    // Define which paths should be analyzed
    $rectorConfig->paths([
        __DIR__ . '/app',
        __DIR__ . '/config',
        __DIR__ . '/routes',
        __DIR__ . '/database',
        __DIR__ . '/tests',
    ]);

    // Exclude docker folder or any other folders with restricted permissions
    $rectorConfig->skip([
        __DIR__ . '/docker',
        __DIR__ . '/vendor',
        __DIR__ . '/storage',
        __DIR__ . '/bootstrap/cache',
        \Rector\DeadCode\Rector\ClassMethod\RemoveUselessReturnTagRector::class,
    ]);

    // Set target PHP version
    $rectorConfig->phpVersion(PhpVersion::PHP_84);

    // Register Laravel-specific rules
    $rectorConfig->import(LaravelSetList::LARAVEL_120);
    $rectorConfig->import(LaravelSetList::LARAVEL_CODE_QUALITY);

    // Register general PHP upgrade and clean code rules
    $rectorConfig->import(SetList::PHP_84);
    $rectorConfig->import(SetList::CODE_QUALITY);
    $rectorConfig->import(SetList::DEAD_CODE);
    $rectorConfig->import(SetList::TYPE_DECLARATION);
    $rectorConfig->import(SetList::PRIVATIZATION);
    $rectorConfig->import(SetList::EARLY_RETURN);
};
