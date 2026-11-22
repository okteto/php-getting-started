<?php

// The message under the logo. Change it and save the file to see hot reload.
const MESSAGE = "Built, deployed, and tested on Kubernetes.";

// page serves the page with the Okteto logo.
function page(): void
{
    readfile(__DIR__ . "/static/index.html");
}

// hello returns the message, the PHP version, and the pod that answers.
function hello(): void
{
    header("Content-Type: application/json");
    echo json_encode([
        "message" => MESSAGE,
        "runtime" => "PHP " . PHP_VERSION,
        "pod" => gethostname(),
    ]);
}

// PHP's built-in web server runs this file for every request. PHPUnit loads
// it from the command line, where there is no request to route.
if (PHP_SAPI !== "cli") {
    match (parse_url($_SERVER["REQUEST_URI"], PHP_URL_PATH)) {
        "/" => page(),
        "/api/info" => hello(),
        default => http_response_code(404),
    };
}
