<?php

use PHPUnit\Framework\TestCase;

require_once __DIR__ . '/../index.php';

final class IndexTest extends TestCase
{
    public function testHello(): void
    {
        ob_start();
        hello();
        $info = json_decode(ob_get_clean(), true);

        $this->assertSame(MESSAGE, $info['message']);
        $this->assertStringStartsWith('PHP ', $info['runtime']);
    }

    public function testPage(): void
    {
        $this->expectOutputRegex('/id="message"/');

        page();
    }
}
