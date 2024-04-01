

<!DOCTYPE html>
<html>
<head>
	<title><?= "Hello world !" ?></title>
	<link rel="icon" type="image/x-icon" href="/assets/logo/favicon.ico">
	<link rel="manifest" href="/assets/logo/favicon/site.webmanifest" />
	<style>
		.center-image {
			width: 100%;
		}
		.space {
			margin-top: 5px;
			margin-bottom: 5px;
		}
	</style>
</head>

<body>
	<div class="space">
		<h2>Every env vars :</h2>
		<?php
		foreach ($_SERVER as $key => $value) {
			if (is_array($value)) {
				echo $key . " => Array:<br>";
				foreach ($value as $arrayKey => $arrayValue) {
					echo " - " . $arrayKey . ": " . $arrayValue . "<br>";
				}
			} else {
				echo $key . " => " . $value . "<br>";
			}
		}
		?>
	</div>

</body>
</html>
