//
//  Validador.swift
//  Budget
//
//  Created by Yuri Pereira on 3/28/16.
//  Copyright © 2016 Budget. All rights reserved.
//

import Foundation

class Validador{
    
    static func vazio(campo: String) -> Bool{
        return campo == "" || campo.characters.count == 0
    }
    
}