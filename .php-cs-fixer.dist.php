<?php

$finder = PhpCsFixer\Finder::create()
                           ->in([
                                    __DIR__ . '/app',
                                    __DIR__ . '/config',
                                    __DIR__ . '/database',
                                    __DIR__ . '/routes',
                                    __DIR__ . '/tests',
                                ])
                           ->exclude([
                                         'bootstrap/cache',
                                         'docker',
                                         'storage',
                                         'vendor',
                                     ])
                           ->name('*.php');

return new PhpCsFixer\Config()
    ->setRiskyAllowed(true)
    ->setRules([
                   '@PSR12' => true,
                   '@PhpCsFixer' => true, // Adds many additional safe rules
                   'array_syntax' => ['syntax' => 'short'],
                   'binary_operator_spaces' => ['default' => 'align_single_space'],
                   'blank_line_after_namespace' => true,
                   'blank_line_after_opening_tag' => true,
                   'cast_spaces' => ['space' => 'single'],
                   'class_attributes_separation' => ['elements' => ['method' => 'one']],
                   'no_unused_imports' => true,
                   'ordered_imports' => ['sort_algorithm' => 'alpha'],
                   'phpdoc_align' => ['align' => 'left'],
                   'phpdoc_scalar' => true,
                   'phpdoc_summary' => false,
                   'phpdoc_to_comment' => false,
                   'return_type_declaration' => ['space_before' => 'none'],
                   'single_quote' => true,
                   'ternary_operator_spaces' => true,
                   'trailing_comma_in_multiline' => ['elements' => ['arrays']],
                   'unary_operator_spaces' => true,
               ])
    ->setFinder($finder);
