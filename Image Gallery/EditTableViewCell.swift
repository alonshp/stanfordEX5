//
//  EditTableViewCell.swift
//  Image Gallery
//
//  Created by Alon Shprung on 4/3/18.
//  Copyright © 2018 Alon Shprung. All rights reserved.
//

import UIKit

class EditTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField! {
        didSet{
            textField.delegate = self
        }
    }
    
    var resignationHandler: (() -> Void)?
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        resignationHandler?()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
