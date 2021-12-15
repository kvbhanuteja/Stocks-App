//
//  StockTableViewCell.swift
//  Stocks App
//
//  Created by bhanuteja on 15/12/21.
//

import UIKit

class StockTableViewCell: UITableViewCell {

    @IBOutlet weak var stockName: UILabel!
    @IBOutlet weak var stockValue: UILabel!
    @IBOutlet weak var stockPercentage: UILabel!
    var stock: Stock? {
        didSet {
            if let stock = stock {
                stockName.text = stock.name
                stockValue.text = "\(stock.price)"
                stockPercentage.text = "\(stock.percentage)"
                stockPercentage.backgroundColor = stock.percentage.first == "+"
                ? UIColor.green.withAlphaComponent(0.7)
                : UIColor.red
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
