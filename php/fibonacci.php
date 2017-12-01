<?php
function fibonacci($first, $second, $countdown) {
    if ($countdown) {
        $next = $first + $second;
        echo $countdown . ': ' . $next . PHP_EOL;
        $countdown--;
        return fibonacci($second, $next, $countdown);
    }

    return;
}

fibonacci(0, 1, 50);
