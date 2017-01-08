//
//  HWTypeTableViewCell.swift
//  HandwritoProjet
//
//  Created by lan yu on 07/01/2017.
//  Copyright © 2017 lan yu. All rights reserved.
//

import UIKit

@objc protocol HWTypeTableViewCellDelegate {
    optional func typeChosen(typeID: Int)
}


class HWTypeTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    
    weak var delegate: HWTypeTableViewCellDelegate?
    
    var pickerDataSource: [HWFontStruct] = []
   
    override func awakeFromNib() {
        super.awakeFromNib()
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
    }
}


extension HWTypeTableViewCell: UIPickerViewDelegate {
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)  {
        self.delegate?.typeChosen?(row)
    }
}


extension HWTypeTableViewCell: UIPickerViewDataSource {
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerDataSource.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerDataSource[row].title
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int  {
        return 1
    }
}


