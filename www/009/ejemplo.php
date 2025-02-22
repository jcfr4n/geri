<!DOCTYPE html>
<html>
  <head>
    <title>Clases</title>
    <meta charset = "utf-8">
    <meta http-equiv = "X-UA-Compatible" content = "IE=edge">
    <meta name = "viewport" content = "width=device-width, initial-scale=1">
    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta1/dist/css/bootstrap.min.css" rel="stylesheet">  
  </head>
  <body>
    <div class = "container">
    <?php
        require_once("clases.php");
        $luis = new Persona();
        $luis->setNombre("Luis Miguel");
        $luis->setApellidos("Cabezas Granado");
        $luis->setDni("08868143X");
    ?>
    <h1>
        Datos de <?= $luis->getNombre() . " " . $luis->getApellidos(); ?>
    </h1>
    <h2>
        DNI <?= $luis->getDni()  ?>
    </h2>

    </div>
  </body>
</html>