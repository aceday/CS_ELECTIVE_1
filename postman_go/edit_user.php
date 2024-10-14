<?php
include './config.php';

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Get form data
    $id = $_POST['id'];
    $name = $_POST['name'];
    $age = $_POST['age'];
    $email = $_POST['email'];

    // Prepare and bind
    $stmt = $global_conn->prepare("UPDATE users SET name=?, age=?, email=? WHERE id=?");
    $stmt->bind_param("sisi", $name, $age, $email, $id);

    // Execute the statement
    if ($stmt->execute()) {
        // Redirect to index.php
        header("Location: index.php");
        exit();
    } else {
        echo "Error: " . $stmt->error;
    }

    // Close the statement and connection
    $stmt->close();
    $global_conn->close();
} else {
    // Fetch user data
    $id = $_GET['id'];
    $stmt = $global_conn->prepare("SELECT id, name, age, email FROM users WHERE id=?");
    $stmt->bind_param("i", $id);
    $stmt->execute();
    $result = $stmt->get_result();
    $user = $result->fetch_assoc();

    // Close the statement
    $stmt->close();
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit User</title>
</head>
<body>
    <h1>Edit User</h1>
    <form action="./edit_user.php" method="POST">
        <input type="hidden" name="id" value="<?php echo $user['id']; ?>">
        <label for="name">Name:</label>
        <input type="text" name="name" id="name" value="<?php echo $user['name']; ?>" required>
        <br>
        <label for="age">Age:</label>
        <input type="number" name="age" id="age" value="<?php echo $user['age']; ?>" required>
        <br>
        <label for="email">Email:</label>
        <input type="email" name="email" id="email" value="<?php echo $user['email']; ?>" required>
        <br>
        <input type="submit" value="Update User">
    </form>
</body>
</html>