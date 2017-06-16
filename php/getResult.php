<?php
$uuid = $_POST["uuid"];

$resultFile = fopen("result.txt", "r") or die("Unable to open file!");
$similarityResult = fgets($resultFile);
fclose($resultFile);

echo  $similarityResult;

?>