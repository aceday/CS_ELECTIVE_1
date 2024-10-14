<?php
include './config.php';

$message = '';

if (isset($_POST["confirm"], $_POST["id"]) && $_POST["confirm"] === "yes") {
    $id = $_POST["id"];
    $stmt = $global_conn->prepare("DELETE FROM users WHERE id = ?");
    $stmt->bind_param("i", $id);
    $stmt->execute();

    $message = $stmt->affected_rows > 0 ? "User deleted successfully." : "Failed to delete user.";

    $stmt->close();
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Delete User | <?php echo htmlspecialchars($project_name); ?></title>
</head>
<body>
    <?php if ($message): ?>
        <p><?php echo htmlspecialchars($message); ?></p>
        <a href="./index.php">Back to Users List</a>
    <?php else: ?>
        <p>Are you sure you want to delete this user?</p>
        <form method="post" action="delete_user.php">
            <input type="hidden" name="id" value="<?php echo htmlspecialchars($_GET['id']); ?>">
            <button type="submit" name="confirm" value="yes">Yes</button>
            <a href="./index.php">No</a>
        </form>
    <?php endif; ?>
</body>
</html>
