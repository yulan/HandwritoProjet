//
//  ViewController.swift
//  HandwritoProjet
//
//  Created by lan yu on 06/01/2017.
//  Copyright © 2017 lan yu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    private var fontList: [HWFontStruct] = []
    private var pngImage: UIImage?
    private var inputText: String = ""
    private var fondIdChosen: Int = 0
    // MARK: Cell Type
    
    private enum CellType: String {
        case HWTypeTableViewCellID              =   "HWTypeTableViewCellID"
        case HWTextFieldTableViewCellID         =   "HWTextFieldTableViewCellID"
        case HWImageViewTableViewCellID         =   "HWImageViewTableViewCellID"
        case HWActivityIndicatorTableViewCellID =   "HWActivityIndicatorTableViewCellID"
    }
    
    // MARK: Sections
    
    private enum Section {
        case HWType
        case HWInputTextfield
        case HWResultImageView
        case HWActivityIndicator
    }
    
    private var availableSections: [Section] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        self.availableSections = [Section.HWType, Section.HWInputTextfield]
        
        /// Get a font list (20 fonts) 
        HWAPIManager.sharedInstance.getHandwritings(20, offset: 0) { (fontList: [HWFontStruct]?, error: HWErrorStruct?) in
            guard error == nil else {
                // An error occured display an error message
                self.handleErrorFont(error!)
                return
            }
            
            guard let fontList = fontList else { return }
            self.fontList = fontList
            self.tableView.reloadData()
        }
    }
    
    /// Call get png image WS
    func callPngImageService() {
            
        self.availableSections = [Section.HWType, Section.HWInputTextfield, Section.HWActivityIndicator]
        self.tableView.reloadData()
        
        let fontId = self.fontList[self.fondIdChosen].id
        HWAPIManager.sharedInstance.getRenderPNGImage(fontId, text: self.inputText, handwriting_size: "", handwriting_color: "",
                                                      width: "", height: "", min_padding: "", line_spacing: 23,
                                                      word_spacing_variance: 23, random_seed: 23) { (image: UIImage?, error: HWErrorStruct?) in
                                                        guard error == nil else {
                                                            // An error occured display an error message
                                                            self.handleErrorFont(error!)
                                                            return
                                                        }
                                                        
                                                        guard let image = image else { return }
                                                        self.pngImage = image
                                                        self.availableSections = [Section.HWType, Section.HWInputTextfield, Section.HWResultImageView]
                                                        self.tableView.reloadData()
                            }
        

    }
    
    /// Display an error message according to its type
    /// - parameters:
    ///   - error: The error to handle
    private func handleErrorFont(errors: HWErrorStruct) {
        self.availableSections = [Section.HWType, Section.HWInputTextfield]
        self.tableView.reloadData()
        
        var errorMessage = "An error occured"
        if errors.error != "" {
            errorMessage = errors.error
            if errors.field != "" {
              errorMessage = "\(errorMessage)\n field: \(errors.field)"
                
                    for missingCharacter in errors.missingCharacters {
                        errorMessage = "\(errorMessage)\n missing_characters: \(missingCharacter.positions)\n\(missingCharacter.character)\n\(missingCharacter.hex)\n\(missingCharacter.name)"
                    }
            }
        }
        
        self.showErrorAlert(errorMessage)
        
    }

    /// Show an error with the error message alert system
    /// - parameters:
    ///  - errorMessage: The error message to show
    private func showErrorAlert(errorMessage: String) {
        let alertVC = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .Alert)
        let okButton = UIAlertAction.init(title: "OK", style: .Cancel, handler: nil)
        alertVC.addAction(okButton)
        presentViewController(alertVC, animated: true, completion: nil)
    }
}

extension ViewController : UITableViewDataSource {
    
    // MARK: - UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.availableSections.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        let section = self.availableSections[indexPath.section]
        
        switch section {
        case .HWType:
            cell = tableView.dequeueReusableCellWithIdentifier(CellType.HWTypeTableViewCellID.rawValue, forIndexPath: indexPath)
            if let cell = cell as? HWTypeTableViewCell {
                cell.delegate = self
                cell.pickerDataSource = self.fontList
                cell.pickerView.reloadAllComponents()
            }
            
        case .HWInputTextfield:
            cell = tableView.dequeueReusableCellWithIdentifier(CellType.HWTextFieldTableViewCellID.rawValue, forIndexPath: indexPath)
            
            if let cell = cell as? HWTextFieldTableViewCell {
                cell.delegate = self
                cell.action = { self.callPngImageService() }
            }
            
        case .HWResultImageView:
            cell = tableView.dequeueReusableCellWithIdentifier(CellType.HWImageViewTableViewCellID.rawValue, forIndexPath: indexPath)
            if let cell = cell as? HWImageViewTableViewCell {
                cell.imageView?.image = self.pngImage
            }
            
        case .HWActivityIndicator:
            cell = tableView.dequeueReusableCellWithIdentifier(CellType.HWActivityIndicatorTableViewCellID.rawValue, forIndexPath: indexPath)
        }
        
        return cell
    }
    
}

extension ViewController: UITableViewDelegate {
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

extension ViewController: HWTypeTableViewCellDelegate {
    // MARK: - HWTypeTableViewCellDelegate
    
    func typeChosen(typeID: Int) {
        self.fondIdChosen = typeID
    }
}

extension ViewController: HWTextFieldTableViewCellDelegate {
    // MARK: - HWTextFieldTableViewCellDelegate
    func textFieldShouldReturn(text: String) {
        self.inputText = text
    }
    
    func textFieldDidEndEditing(text: String) {
        self.inputText = text
    }
}
