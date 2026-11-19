<?php

use PHPUnit\Framework\TestCase;

final class IndexTest extends TestCase
{
    public function testIndexSaysHelloWorld(): void
    {
        $this->expectOutputString('Hello World!');

        require __DIR__ . '/../index.php';
    }
}
