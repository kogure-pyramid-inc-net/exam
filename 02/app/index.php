<html>
<?PHP
$fname = "index.html";
$fp = fopen( $fname, "r" );
$org_contents = fread( $fp, filesize( $fname ) );
fclose( $fp );

$contents = str_replace( "images", "assets", $org_contents );

echo $contents;
?>
</html>