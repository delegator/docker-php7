<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>Simple PHP App</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.3.5/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body>
        <div class="container">
            <div class="jumbotron">
                <h1>Hello, PHP!</h1>
                <p>Your PHP application is now running on the host &ldquo;<?php echo gethostname(); ?>&rdquo;.</p>
                <p>This host is running PHP version <?php echo phpversion(); ?>.</p>
                <p><a class="btn btn-primary btn-lg more-info-btn" href="#" role="button">More Info</a></p>
            </div>
            <div class="phpinfo hidden">
                <?php phpinfo(); ?>
            </div>
        </div>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.3.5/js/bootstrap.min.js"></script>
        <script>$('.more-info-btn').on('click',function(){$('.phpinfo').toggleClass('hidden');});</script>
    </body>
</html>
