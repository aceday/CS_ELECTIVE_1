<?php
  include './config.php';

  if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Get the variables
    $name = $_POST["name"];
    $age = $_POST["age"];
    $email = $_POST["email"];

    // Prepare the SQL query
    $sql_cmd = "INSERT INTO users (name, age, email) VALUES ('$name', $age, '$email')";
    $sql_query = $global_conn->query($sql_cmd);

    if ($sql_query) {
      header('Location: ./add_user_success.php');
      exit();
    } else {
      echo "<script>alert('Failed to add user.');</script>";
    }
  }
?>

<head>
  <title>Add User | <?php echo $project_name?></title>
  <link href="./style.css" rel="stylesheet">
</head>

<body>
  <h1>Add User</h1>
  <form action="./add_user.php" method="POST">
    <label for="name">Name:</label>
    <input type="text" name="name" id="name" required>
    <br>
    <label for="age">Age:</label>
    <input type="number" name="age" id="age" required>
    <br>
    <label for="email">Email:</label>
    <input type="email" name="email" id="email" required>
    <br>
    <input type="submit" value="Add User">
  </form>
</body>