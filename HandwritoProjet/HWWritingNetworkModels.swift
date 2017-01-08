//
//  HWWritingNetworkModels.swift
//  HandwritoProjet
//
//  Created by lan yu on 08/01/2017.
//  Copyright © 2017 lan yu. All rights reserved.
//

import Foundation
import SwiftyJSON

struct HWFontStruct {
    var ratingEmbellishment: Int
    var id: String
    var ratingCursivity: Int
    var title: String
    var ratingCharacterWidth: Int
    var dateCreated: String
    var dateModified: String
    var ratingNeatness: Int
    
    init(JSON json: AnyObject) {
        let json = JSON(json)
        self.ratingEmbellishment = json["rating_embellishment"].intValue
        self.id = json["id"].stringValue
        self.ratingCursivity = json["rating_cursivity"].intValue
        self.title = json["title"].stringValue
        self.ratingCharacterWidth = json["rating_character_width"].intValue
        self.dateCreated = json["date_created"].stringValue
        self.dateModified = json["date_modified"].stringValue
        self.ratingNeatness = json["testCompleted"].intValue
    }
    
    static func fontDateStructsFromJson(JSON json: AnyObject) -> [HWFontStruct] {
        var fontDateStructList: [HWFontStruct] = []
        
        let jsonArray = JSON(json)
        
        for (_, json) in jsonArray {
            let fontDateStruct = HWFontStruct(JSON: json.object)
            fontDateStructList.append(fontDateStruct)
        }
        
        return fontDateStructList
    }
}
