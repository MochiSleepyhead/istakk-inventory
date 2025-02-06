<?php
    require_once('../../inc/config/constants.php');
    require_once('../../inc/config/db.php');

    $initialStock = 0;
    $baseImageFolder = '../../data/item_images/';
    $itemImageFolder = '';

    if ($_SERVER['REQUEST_METHOD'] == 'POST') {

        $itemNumber = isset($_POST['itemDetailsItemNumber']) ? htmlentities($_POST['itemDetailsItemNumber']) : '';
        $itemName = isset($_POST['itemDetailsItemName']) ? htmlentities($_POST['itemDetailsItemName']) : '';
        $discount = isset($_POST['itemDetailsDiscount']) ? htmlentities($_POST['itemDetailsDiscount']) : '0';
        $quantity = isset($_POST['itemDetailsQuantity']) ? htmlentities($_POST['itemDetailsQuantity']) : '0';
        $unitPrice = isset($_POST['itemDetailsUnitPrice']) ? htmlentities($_POST['itemDetailsUnitPrice']) : '0';
        $status = isset($_POST['itemDetailsStatus']) ? htmlentities($_POST['itemDetailsStatus']) : '';
        $description = isset($_POST['itemDetailsDescription']) ? htmlentities($_POST['itemDetailsDescription']) : '';

        // Fix: Ensure required inventory fields are not missing
        $demand = isset($_POST['itemDemand']) ? htmlentities($_POST['itemDemand']) : '0';
        $orderingCost = isset($_POST['itemOrderingCost']) ? htmlentities($_POST['itemOrderingCost']) : '0';
        $holdingCost = isset($_POST['itemHoldingCost']) ? htmlentities($_POST['itemHoldingCost']) : '0';
        $leadTime = isset($_POST['itemLeadTime']) ? htmlentities($_POST['itemLeadTime']) : '0';
        $safetyStock = isset($_POST['itemSafetyStock']) ? htmlentities($_POST['itemSafetyStock']) : '0'; // Fixed spelling issue from 'satefyStock'

        // Check if required fields are empty
        if (!empty($itemNumber) && !empty($itemName) && isset($quantity) && isset($unitPrice) && isset($demand) && isset($orderingCost) && isset($holdingCost) && isset($leadTime) && isset($safetyStock)) {
            
            // Sanitize item number
            $itemNumber = filter_var($itemNumber, FILTER_SANITIZE_STRING);

            // Validate item quantity
            if (!filter_var($quantity, FILTER_VALIDATE_INT) && $quantity !== '0') {
                echo '<div class="alert alert-danger"><button type="button" class="close" data-dismiss="alert">&times;</button>Please enter a valid number for quantity</div>';
                exit();
            }

            // Validate unit price
            if (!filter_var($unitPrice, FILTER_VALIDATE_FLOAT) && $unitPrice !== '0.0') {
                echo '<div class="alert alert-danger"><button type="button" class="close" data-dismiss="alert">&times;</button>Please enter a valid number for unit price</div>';
                exit();
            }

            // Validate discount
            if (!empty($discount) && !filter_var($discount, FILTER_VALIDATE_FLOAT)) {
                echo '<div class="alert alert-danger"><button type="button" class="close" data-dismiss="alert">&times;</button>Please enter a valid discount amount</div>';
                exit();
            }

            // Create image folder for item if it doesn’t exist
            $itemImageFolder = $baseImageFolder . $itemNumber;
            if (!is_dir($itemImageFolder)) {
                mkdir($itemImageFolder);
            }

            // Check if the item already exists in DB
            $stockSql = 'SELECT stock FROM item WHERE itemNumber=:itemNumber';
            $stockStatement = $conn->prepare($stockSql);
            $stockStatement->execute(['itemNumber' => $itemNumber]);

            if ($stockStatement->rowCount() > 0) {
                echo '<div class="alert alert-danger"><button type="button" class="close" data-dismiss="alert">&times;</button>Item already exists in DB. Please click the <strong>Update</strong> button to update the details. Or use a different Item Number.</div>';
                exit();
            } else {
                // Insert the new item into the database
                $insertItemSql = 'INSERT INTO item (itemNumber, itemName, discount, stock, unitPrice, status, description, demand, ordering_cost, holding_cost, lead_time, safety_stock) 
                                  VALUES (:itemNumber, :itemName, :discount, :stock, :unitPrice, :status, :description, :demand, :ordering_cost, :holding_cost, :lead_time, :safety_stock)';

                $insertItemStatement = $conn->prepare($insertItemSql);
                $insertItemStatement->execute([
                    'itemNumber' => $itemNumber, 
                    'itemName' => $itemName, 
                    'discount' => $discount, 
                    'stock' => $quantity, 
                    'unitPrice' => $unitPrice, 
                    'status' => $status, 
                    'description' => $description, 
                    'demand' => $demand, 
                    'ordering_cost' => $orderingCost, 
                    'holding_cost' => $holdingCost, 
                    'lead_time' => $leadTime, 
                    'safety_stock' => $safetyStock
                ]);

                echo '<div class="alert alert-success"><button type="button" class="close" data-dismiss="alert">&times;</button>Item added to database.</div>';

				$optimizationQuery = "INSERT INTO `inventory_metrics` (`productID`, `eoq`, `rop`)
				SELECT i.productID, 
					SQRT((2 * i.demand * i.ordering_cost) / i.holding_cost),
					((i.demand / 365) * i.lead_time) + i.safety_stock
				FROM item i WHERE i.itemNumber = :itemNumber
				ON DUPLICATE KEY UPDATE 
					eoq = VALUES(eoq), 
					rop = VALUES(rop);";
			
					// ✅ Prepare & execute query correctly
					$stmt = $conn->prepare($optimizationQuery);
					$stmt->bindValue(':itemNumber', $itemNumber, PDO::PARAM_STR); // Bind itemNumber
					$stmt->execute();
			
			// ✅ Corrected row count check
			if ($stmt->rowCount() > 0) {
				header("Refresh:0");
			} else {
				echo "No changes made or item not found.";
			}

                exit();
            }
        } else {
            // Show an error if required fields are missing
            echo '<div class="alert alert-danger"><button type="button" class="close" data-dismiss="alert">&times;</button>Please enter all fields marked with a (*)</div>';
            exit();
        }
    }
?>
