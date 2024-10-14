<?php
  include './config.php';
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Users List | <?php echo $project_name?></title>
  <link href="./style.css" rel="stylesheet">
</head>
<body>
  <h1>User Page</h1>
  <!-- <p>This is a basic HTML page.</p> -->
  <a href="./add_user.php">Add data</a>
  <table style="border:1px solid #111;min-width:50vw;max-width:50vw;">
    <tr>
      <th>Name</th>
      <th>Age</th>
      <th>Email</th>
      <th colspan="2">Action</th>
    <tr>
    <?php 

    $sql_cmd = "SELECT users.id, users.name, users.age, users.email FROM users";
    $sql_query = $global_conn->query($sql_cmd);

    if ($sql_query->num_rows > 0) {
      $sql_output = $sql_query->fetch_all(MYSQLI_ASSOC);
      for ($i = 0; $i < count($sql_output); $i++) {
        echo "<tr>
                <td>" . $sql_output[$i]["name"] . "</td>
                <td>" . $sql_output[$i]["age"] . "</td>
                <td>" . $sql_output[$i]["email"] . "</td>
                <td> <a href='./edit_user.php?id=" . $sql_output[$i]["id"] . "'>Edit</a> </td>
                <td> <a href='./delete_user.php?id=" . $sql_output[$i]["id"] . "'>Delete</a> </td>
              </tr>";
      }
    } else {
      echo "<tr><td colspan='3' style='text-align: center;'>No record found.</td></tr>";
    }

    ?>

  </table>
</body>
</html>