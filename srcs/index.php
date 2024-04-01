

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
	<h1>Welcome to this default config for PHP with NGinx on Docker !</h1>
	<div class="space">
		<h2>Some informations :</h2>
		<table>
			<tr>
				<td>HTTP_HOST</td>
				<td>HOSTNAME</td>
				<td>SERVER_NAME</td>
				<td>SERVER_PROTOCOL</td>
			</tr>
			<tr>
				<td><?= $_SERVER["HTTP_HOST"]?></td>
				<td><?= $_SERVER["HOSTNAME"]?></td>
				<td><?= $_SERVER["SERVER_NAME"]?></td>
				<td><?= $_SERVER["SERVER_PROTOCOL"]?></td>
			</tr>
		</table>

	</div>
	<h2>Assets :</h2>
	</div>

	<img src="img/surreal.jpg" alt="Centered Image" class="center-image">

</body>
</html>
