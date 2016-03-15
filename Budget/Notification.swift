//
//  Notification.swift
//  Budget
//
//  Created by Calebe Santos on 3/14/16.
//  Copyright © 2016 Budget. All rights reserved.
//

import UIKit

public class Notification {
    static func mostrarErro(titulo: String = "Desculpe", mensagem: String = "Erro inesperado") -> UIAlertController{
        
        let detalhes = UIAlertController(title: titulo, message: mensagem, preferredStyle: UIAlertControllerStyle.Alert)
        
        let cancelar = UIAlertAction(title: "Entendido", style: UIAlertActionStyle.Cancel, handler: nil)
        
        detalhes.addAction(cancelar)
        
        return detalhes
    }
}