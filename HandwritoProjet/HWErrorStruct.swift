//
//  HWErrorStruct.swift
//  HandwritoProjet
//
//  Created by lan yu on 09/01/2017.
//  Copyright © 2017 lan yu. All rights reserved.
//

import Foundation
import SwiftyJSON

struct HWErrorStruct {
    var error: String
    var field: String
    var missingCharacters: [HWMissingCharactersStruct] = []

    init(JSON json: AnyObject) {
        let json = JSON(json)
  
        self.error = json["error"].stringValue
        self.field = json["field"].stringValue
        
        if let missingCharacters = json["missing_characters"].array {
            for missingCharacter in missingCharacters {
                let missingCharacterStruct = HWMissingCharactersStruct.init(JSON: missingCharacter.object)
                self.missingCharacters.append(missingCharacterStruct)
            }
        }
    }
}

struct HWMissingCharactersStruct {
    var character: String
    var hex: String
    var positions: [Int] = []
    var name: String
    
    
    init(JSON json: AnyObject) {
        let json = JSON(json)
        self.character = json["character"].stringValue
        self.hex = json["id"].stringValue
        self.name = json["name"].stringValue
        
        if let positions = json["positions"].array {
            for position in positions {
                self.positions.append(position.intValue)
            }
        }
    }
}

