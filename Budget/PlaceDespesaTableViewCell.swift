//
//  PlaceDespesaTableViewCell.swift
//  Budget
//
//  Created by Yuri Pereira on 3/19/16.
//  Copyright © 2016 Budget. All rights reserved.
//

import UIKit

class PlaceDespesaTableViewCell: UITableViewCell {

    @IBOutlet weak var lblNome: UILabel!
    @IBOutlet weak var lblCategoria: UILabel!
    @IBOutlet weak var lblValor: UILabel!
    @IBOutlet weak var lblConta: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
