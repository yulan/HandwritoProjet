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
        case HWTypeTableViewCellID      =   "HWTypeTableViewCellID"
        case HWTextFieldTableViewCellID =   "HWTextFieldTableViewCellID"
        case HWImageViewTableViewCellID =   "HWImageViewTableViewCellID"
    }
    
    // MARK: Sections
    
    private enum Section {
        case HWType
        case HWInputTextfield
        case HWResultImageView
        
        var itemCount: Int {
            switch self {
            case .HWType :
                return 1
            case .HWInputTextfield:
                return 1
            case .HWResultImageView:
                return 1
            }
        }
    }
    
    private var availableSections: [Section] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        self.availableSections = [Section.HWType, Section.HWInputTextfield]
        
        HWAPIManager.sharedInstance.getHandwritings(20, offset: 0) { (fontList: [HWFontStruct]?, error: HWFontError?) in
            guard error == nil else {
                // An error occured display an error message
                self.handleErrorFont(error!)
                return
            }
            
            guard let fontList = fontList else { return }
            self.fontList = fontList
            print("fontList \(fontList)")
            self.tableView.reloadData()
            
//            guard fontList != nil else {
//                // If the render object is nil, An error occured display an error message
//                self.showErrorAlert("An error occured")
//                return
//            }
//            
//            // Set the Data source
//            self.fontDataSource = fontList!
//            
//            // Set the selected font as the first one
//            if let firstFont = fontList?.first {
//                self.selectedFontId = firstFont.id
//            }
//            
//            for _font in fontList! {
//                self.getFontNameStyleByItsOwnFont(_font)
//            }
        }
        
        
       
    }
    
    func callPngImageService() {
        print("callPngImageService \(self.inputText)")
        let fontId = self.fontList[self.fondIdChosen].id
        HWAPIManager.sharedInstance.getRenderPNGImage(fontId, text: self.inputText, handwriting_size: "", handwriting_color: "",
                                                      width: "", height: "", min_padding: "", line_spacing: 23,
                                                      word_spacing_variance: 23, random_seed: 23) { (image: UIImage?, error: HWFontError?) in
                                                        guard error == nil else {
                                                            // An error occured display an error message
                                                            self.handleErrorFont(error!)
                                                            return
                                                        }
                                                        
                                                        guard let image = image else { return }
                                                        self.pngImage = image
                                                        self.availableSections = [Section.HWType, Section.HWInputTextfield, Section.HWResultImageView]
                                                        self.tableView.reloadData()
                                                        
                                                        //            guard fontList != nil else {
                                                        //                // If the render object is nil, An error occured display an error message
                                                        //                self.showErrorAlert("An error occured")
                                                        //                return
                                                        //            }
                                                        //
                                                        //            // Set the Data source
                                                        //            self.fontDataSource = fontList!
                                                        //
                                                        //            // Set the selected font as the first one
                                                        //            if let firstFont = fontList?.first {
                                                        //                self.selectedFontId = firstFont.id
                                                        //            }
                                                        //
                                                        //            for _font in fontList! {
                                                        //                self.getFontNameStyleByItsOwnFont(_font)
                                                        //            }
        }

    }
    
//    /// Display an error message according to its type
//    /// - parameters:
//    ///   - error: The error to handle
//    private func handleError(error: HWFontError) {
//        var errorMessage = "An error occured"
//        
//        switch error {
//        case .HWUnsupportedCharacterError:
//            errorMessage = "You entered an unsupported character, please try again"
//            break
//        case .RateLimitExceededError:
//            errorMessage = "Rate Limit Exceeded"
//            break
//        default:
//            errorMessage = "An error occured"
//        }
//        
//        self.showErrorAlert(errorMessage)
//    }
    
    
    /// Display an error message according to its type
    /// - parameters:
    ///   - error: The error to handle
    private func handleErrorFont(error: HWFontError) {
        var errorMessage = "An error occured"
        
        switch error {
        case .RateLimitExceededError:
            errorMessage = "Rate Limit Exceeded"
            break
        default:
            errorMessage = "An error occured"
        }
        
        self.showErrorAlert(errorMessage)
    }

    /// Show an error with the error message alert system
    /// - parameters:
    ///   - errorMessage: The error message to show
    private func showErrorAlert(errorMessage: String) {
        // Display an error message
        //self.view.dodo.error(errorMessage)
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
     
    }
}

extension ViewController: HWTypeTableViewCellDelegate {
    func typeChosen(typeID: Int) {
        print("type chose \(typeID)")
        self.fondIdChosen = typeID
    }
}

extension ViewController: HWTextFieldTableViewCellDelegate {
    func textFieldShouldReturn(text: String) {
        self.inputText = text
        print("textFieldShouldReturn \(text)")
    }
    
    func textFieldDidEndEditing(text: String) {
        self.inputText = text
        print("textFieldDidEndEditing \(text)")
    }
}
