//
//  HWAPIManager.swift
//  HandwritoProjet
//
//  Created by lan yu on 08/01/2017.
//  Copyright © 2017 lan yu. All rights reserved.
//
import Foundation
import Alamofire // HTTP Requests
import SwiftyJSON // JSON Parsing

struct HWConfig {
    /// The base API URL of handwriting.io
    static let API_URL = "https://api.handwriting.io"
    
    /// The handwriting.io API Key and Secret (Expired Date: 02-02-2017)
    static let API_KEY = "VQA0DC1SYQMFV0HZ"
    static let API_SECRET = "V3C3TTH96S1WT6M7"
}

/// This is a type used by the call to get a font list. This is composed of an array of `HWFont` type if the operation succeed, and of a `HWFontError` in case of error
typealias ServiceResponseGetFonts = ([HWFontStruct]?, HWErrorStruct?) -> Void
typealias ServiceResponseGetPNGImage = (UIImage?, HWErrorStruct?) -> Void

class HWAPIManager: NSObject {
    
    /// Singleton
    static let sharedInstance = HWAPIManager()
    /// Endpoint to render a handwrited text to a PNG image
    let GET_HANDWRITINGS_ENDPOINT = "/handwritings"
    /// Endpoint to render a handwrited text to a PNG image
    let GET_RENDER_PNGIMAGE_ENDPOINT = "/render/png"
    
    /// Get the HTTP header required to call the Handwriting.io API
    ///
    /// - returns: An array of key-value for each header, containing the Authorization HTTP Header.
    private func getHTTPHeaderForAuthorization() -> [String: String] {
        let loginString = NSString(format: "%@:%@", HWConfig.API_KEY, HWConfig.API_SECRET)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = loginData.base64EncodedStringWithOptions([])
        
        let headers = [
            "Authorization": "Basic \(base64LoginString)"
        ]
        
        return headers
    }
    
    /// Get an array of font
    ///
    /// - parameters:
    ///   - limit: the maximum number of font to fetch.
    ///   - offset: the number of font to be skipped by the fetch
    ///   - onCompletion: a completion callback to handle the success or error result
    func getHandwritings(limit: Int, offset: Int, onCompletion: ServiceResponseGetFonts) {
        
        // Define the URL endpoint
        let requestUrl = HWConfig.API_URL + GET_HANDWRITINGS_ENDPOINT
        
        // Build the array of parameters
        let params = [
            "limit" : limit,
            "offset": offset,
            ]
        
        // Automatically validates status code within 200...299 range, and that the Content-Type header of the response matches the Accept header of the request
        Alamofire.request(.GET, requestUrl, parameters: params, encoding: .URLEncodedInURL, headers: self.getHTTPHeaderForAuthorization())
            .validate() // Test the response is between 200 and 299
            .responseJSON { response in
                
                // If success, execute onCompletion callback with an array of HWFontStruct Model
                // If failed, execute onCompletion callback with an HWHandwriteError error
                switch response.result {
                case .Success(let data):
                    // Get a JSON Object from the data
                    let json = JSON(data)
                    let fontsList = HWFontStruct.fontDateStructsFromJson(JSON: json.object)
                    onCompletion(fontsList, nil)
                    
                case .Failure(let error):
                    if let statusCode = error.userInfo["StatusCode"] as? Int {
                        if statusCode == 429 {
                            onCompletion(nil, HWErrorStruct.init(JSON: JSON(error).object))
                        }
                    }
                    onCompletion(nil, HWErrorStruct.init(JSON: JSON(error).object))
                }
                
        }
    }
    
    /// Get an array of font
    ///
    /// - parameters:
    ///   - handwriting_id: the maximum number of font to fetch.
    ///   - text: the number of font to be skipped by the fetch
    ///   - handwriting_size: the number of font to be skipped by the fetch
    ///   - handwriting_color: the number of font to be skipped by the fetch
    ///   - width: the number of font to be skipped by the fetch
    ///   - height: the number of font to be skipped by the fetch
    ///   - min_padding: the number of font to be skipped by the fetch
    ///   - line_spacing: the number of font to be skipped by the fetch
    ///   - word_spacing_variance: the number of font to be skipped by the fetch
    ///   - random_seed: the number of font to be skipped by the fetch
    ///   - onCompletion: a completion callback to handle the success or error result
    func getRenderPNGImage(handwriting_id: String, text: String, handwriting_size: String, handwriting_color: String,
                           width: String, height: String, min_padding: String, line_spacing: Double,
                           word_spacing_variance: Double, random_seed: Int, onCompletion: ServiceResponseGetPNGImage) {
        
        // Define the URL endpoint
        let requestUrl = HWConfig.API_URL + GET_RENDER_PNGIMAGE_ENDPOINT
        
        // Build the array of parameters
        let params = [
            "handwriting_id" : handwriting_id,
            "text": text,
            "width": "560px",
            "height": "203px"
            ]
        
        // Automatically validates status code within 200...299 range, and that the Content-Type header of the response matches the Accept header of the request
        Alamofire.request(.GET, requestUrl, parameters: params, encoding: .URLEncodedInURL, headers: self.getHTTPHeaderForAuthorization())
            .validate() // Test the response is between 200 and 299
            .responseData { response in
                
                // If success, execute onCompletion callback with an array of HWFontStruct Model
                // If failed, execute onCompletion callback with an HWHandwriteError error
                switch response.result {
                case .Success(let data):
                    let image = UIImage(data: data, scale: 1.0)!
                    onCompletion(image, nil)
                    
                case .Failure(let error):
                    if let statusCode = error.userInfo["StatusCode"] as? Int {
                        if statusCode == 400 {
                            onCompletion(nil, HWErrorStruct.init(JSON: JSON(error).object))
                        } else if statusCode == 429 {
                            onCompletion(nil, HWErrorStruct.init(JSON: JSON(error).object))
                        }
                    }
                    onCompletion(nil, HWErrorStruct.init(JSON: JSON(error).object))
                }
                
        }
    }

}
