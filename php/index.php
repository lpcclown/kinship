<?php
$email = $_POST["email"];
$password = $_POST["password"];
$userId = $_POST["user_id"];

$image_info = getimagesize($_FILES['file']['tmp_name']);//$_FILES['file']['tmp_name']即文件路径
$base64_image_content = file_get_contents($_FILES['file']['tmp_name']);
$img = base64_decode($base64_image_content);
$path = md5(uniqid(rand())).date(Ymdhis).".jpg"; // 产生随机唯一的名字作为文件名


$fh = fopen('result.txt', 'a');
fwrite($fh, '<h1>Hello world!</h1>');
fclose($fh);

unlink('result.txt');

// $target_dir = "wp-content/uploads/2015/02333" . $userId;

// if(!file_exists($target_dir))
// {
// mkdir($target_dir, 0777, true);
// }

// $target_dir = $target_dir . "/" . basename($_FILES["file"]["name"]);
file_put_contents("kinshipPhotos/".$path, $img);

$uploadedImages = scandir("kinshipPhotos/");
foreach ($uploadedImages as $uploadedImage) {
 	$file_parts = pathinfo($uploadedImage); 
 	if ($file_parts['extension'] == "jpg"){
 		$i++;
 	}
 } 

if ($i == 2){
	exec("matlab -nodisplay -nosplash -nodesktop -r \"run('C:/Users/LIU/Desktop/NRML/demo_nrml.m'); quit;\"");
}

if (file_put_contents("kinshipPhotos/archive/".$path, $img)) // 将图片保存到相应位置) 
{
	echo json_encode([
	"Message" => "The file has been uploaded.",
	"Status" => "OK",
	"userId" => $_REQUEST["user_id"]
	]);
} else {
	echo json_encode([
	"Message" => "Sorry, there was an error uploading your file.",
	"Status" => "Error",
	"userId" => $_REQUEST["user_id"]
	]);
}
// chmod($target_dir, 0777);
?>