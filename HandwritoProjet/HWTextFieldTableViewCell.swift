//
//  HWTextFieldTableViewCell.swift
//  HandwritoProjet
//
//  Created by lan yu on 07/01/2017.
//  Copyright © 2017 lan yu. All rights reserved.
//

import UIKit

@objc protocol HWTextFieldTableViewCellDelegate {
    optional func textFieldShouldReturn(text: String)
    optional func textFieldDidBeginEditing(text: String)
    optional func textFieldDidEndEditing(text: String)
}


class HWTextFieldTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var button: UIButton!
    
    var action: (() -> Void)?
    
    weak var delegate: HWTextFieldTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textField.delegate = self
    }
    
    @IBAction func buttonPushed() {
        self.textField.resignFirstResponder()
        self.action?()
    }
}

extension HWTextFieldTableViewCell: UITextFieldDelegate {
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.delegate?.textFieldShouldReturn?(textField.text ?? "")
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.delegate?.textFieldDidBeginEditing?(textField.text ?? "")
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.delegate?.textFieldDidEndEditing?(textField.text ?? "")
    }
}

