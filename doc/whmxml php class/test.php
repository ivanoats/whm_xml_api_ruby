<?php
//include the whm class file.
require_once('whm.php');

// create a new instance of whm class
$test= new whm;

//initilize the whm object 
//you can use you hostname or an IP below 
//you can find you whm hash when yopu login into your whm account clickong on "Setup Remote Access Key" link.
$test->init('whmhost.com','whm_username','whm_hash');

//This will output the cpanel/whm version.  
$version= $test->version();
echo "Cpanel/whm version is: $version <br>";

//This way you can create an account. 
//This function will return a result set as an array in success and will return false on fail.
$result=$test->createAccount('testdomain.com','testuser','testpassword123','package_test');

//check if creating account was successfull or not.
if($result)
{
	//print the result set
	print_r($result);
}
else
{
	//You can get the errors like this.
	print_r($test->errors);
}

?>