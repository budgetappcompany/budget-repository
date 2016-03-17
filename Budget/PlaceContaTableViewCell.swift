//
//  PlaceTableViewCell.swift
//  Budget
//
//  Created by Yuri Pereira on 3/14/16.
//  Copyright © 2016 Budget. All rights reserved.
//

import UIKit

class PlaceContaTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTipConta: UILabel!
    @IBOutlet weak var lblConta: UILabel!
    @IBOutlet weak var lblSaldo: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
