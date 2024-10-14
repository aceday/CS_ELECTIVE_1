
<?php
$project_name = "Users";

// Database access
$global_db_host = "localhost";
$global_db_port = "3306";
$global_db_user = "root";
$global_db_pass = "Day15@!";
$global_db_name = "online_store";

$global_conn = new mysqli($global_db_host, $global_db_user, $global_db_pass, $global_db_name);

// Test db connection
if ($global_conn -> connect_error) {
  die("Connection failed: " . $global_conn -> connect_error);
}
?>