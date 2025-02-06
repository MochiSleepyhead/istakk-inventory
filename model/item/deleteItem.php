<?php
require_once('../../inc/config/constants.php');
require_once('../../inc/config/db.php');

if (isset($_POST['itemDetailsItemNumber'])) {
    // Sanitize input
    $itemNumber = htmlentities($_POST['itemDetailsItemNumber']);
    
    if (!empty($itemNumber)) {
        $itemNumber = filter_var($itemNumber, FILTER_SANITIZE_STRING);

        try {
            // Start transaction
            $conn->beginTransaction();

            // Check if the item exists in the database
            $itemSql = 'SELECT productID FROM item WHERE itemNumber = :itemNumber';
            $itemStatement = $conn->prepare($itemSql);
            $itemStatement->execute(['itemNumber' => $itemNumber]);

            if ($itemStatement->rowCount() > 0) {
                // Fetch the productID of the item
                $row = $itemStatement->fetch(PDO::FETCH_ASSOC);
                $productID = $row['productID'];

                // First, delete related records in inventory_metrics
                $deleteMetricsSql = 'DELETE FROM inventory_metrics WHERE productID = :productID';
                $deleteMetricsStatement = $conn->prepare($deleteMetricsSql);
                $deleteMetricsStatement->execute(['productID' => $productID]);

                // Now, delete the item
                $deleteItemSql = 'DELETE FROM item WHERE itemNumber = :itemNumber';
                $deleteItemStatement = $conn->prepare($deleteItemSql);
                $deleteItemStatement->execute(['itemNumber' => $itemNumber]);

                // Commit transaction
                $conn->commit();

                echo '<div class="alert alert-success"><button type="button" class="close" data-dismiss="alert">&times;</button>Item deleted successfully.</div>';
                exit();
            } else {
                // Item does not exist
                $conn->rollBack();
                echo '<div class="alert alert-danger"><button type="button" class="close" data-dismiss="alert">&times;</button>Item does not exist in DB. Therefore, can\'t delete.</div>';
                exit();
            }
        } catch (PDOException $e) {
            // Rollback transaction in case of an error
            $conn->rollBack();
            echo '<div class="alert alert-danger"><button type="button" class="close" data-dismiss="alert">&times;</button>Error: ' . $e->getMessage() . '</div>';
            exit();
        }
    } else {
        // Item number is empty
        echo '<div class="alert alert-danger"><button type="button" class="close" data-dismiss="alert">&times;</button>Please enter the item number</div>';
        exit();
    }
}
?>
