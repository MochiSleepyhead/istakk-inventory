<?php
	require_once('../../inc/config/constants.php');
	require_once('../../inc/config/db.php');
	
	$vendorDetailsSearchSql = 'SELECT im.productID, eoq, rop, last_updated, itemName, stock, imageURL, i.itemNumber,
    DATE_ADD(CURDATE(), INTERVAL rop DAY) AS applied_rop_date
    FROM inventory_metrics AS im
    INNER JOIN item AS i ON im.productID = i.productID;';
	$vendorDetailsSearchStatement = $conn->prepare($vendorDetailsSearchSql);
	$vendorDetailsSearchStatement->execute();

	$output = '<table id="stockOptimizationTable" class="table table-sm table-striped table-bordered table-hover" style="width:100%">
				<thead>
					<tr>
						<th>Product ID</th>
						<th>Item Name</th>
						<th>Stocks</th>
						<th>EOQ (units)</th>
						<th>ROP (days)</th>
						<th>Applied ROP Date</th>
						<th>Last Updated</th>
						<th>Image</th>
					</tr>
				</thead>
				<tbody>';
	
	// Create table rows from the selected data
	while($row = $vendorDetailsSearchStatement->fetch(PDO::FETCH_ASSOC)){
		$output .= '<tr>' .
						'<td>' . $row['productID'] . '</td>' .
						'<td>' . $row['itemName'] . '</td>' .
						'<td>' . $row['stock'] . '</td>' .
						'<td>' . $row['eoq'] . '</td>' .
						'<td>' . $row['rop'] . '</td>' .
						'<td>' . $row['applied_rop_date'] . '</td>' .
						'<td>' . $row['last_updated'] . '</td>' .
					'<td> <img src="data/item_images/' . $row['itemNumber'] .'/' . $row['imageURL'] . '" alt="Product Image" style="width: 30%; margin-inline:auto;"> </td>';

					'</tr>';
	}
	
	$vendorDetailsSearchStatement->closeCursor();
	
	$output .= '</tbody>
					<tfoot>
						<tr>
							<th>Product ID</th>
							<th>Item Name</th>
							<th>Stocks</th>
							<th>EOQ (units)</th>
							<th>ROP (days)</th>
							<th>Applied ROP Date</th>
							<th>Last Updated</th>
							<th>Image</th>
						</tr>
					</tfoot>
				</table>';
	echo $output;
?>