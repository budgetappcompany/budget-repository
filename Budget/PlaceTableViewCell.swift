//
//  PlaceTableViewCell.swift
//  Budget
//
//  Created by Yuri Pereira on 3/14/16.
//  Copyright © 2016 Budget. All rights reserved.
//

import UIKit

class PlaceTableViewCell: UITableViewCell {

    @IBOutlet weak var txtTipConta: UILabel!
    @IBOutlet weak var txtConta: UILabel!
    @IBOutlet weak var txtSaldo: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
