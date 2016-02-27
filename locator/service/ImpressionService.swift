//
//  ImpressionService.swift
//  locator
//
//  Created by Michael Knoch on 30/01/16.
//  Copyright © 2016 Sergej Birklin. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import PromiseKit

class ImpressionService {

    static func getImpressions(id: String) -> Promise<[AbstractImpression]> {
        return Promise { fulfill, reject in
            
            Alamofire.request(.GET, API.BASE_URL + "/locations/" + id + "/impressions").validate().responseJSON { response in
                
                switch response.result {
                case .Success:
                    
                    if let value = response.result.value {
                        let json = JSON(value)
                        print(json)
                        
                        var impressions = [AbstractImpression]()
                        
                        for (_,subJson):(String, JSON) in json {
                            
                            let user = subJson["user_id"].string!
                            let date = subJson["create_date"].string
                            let type = subJson["type"].string
                            let dataPath = subJson["data"].string!
                            
                            if type == "text" {
                                impressions.append(TextImpression(date:date!, userId: user, text: dataPath))
                            } else if type == "image" {
                                impressions.append(ImageImpression(date:date!, userId: user, imagePath: dataPath))
                            } else if type == "video" {
                                impressions.append(VideoImpression(date:date!, userId: user, videoPath: dataPath))
                            } else if type == "audio" {
                                //TODO
                            }
                        }
                        fulfill(impressions)
                    }
                    
                case .Failure(let error):
                    reject(error)
                }
            }
        }
    }
    
    static func addTextImpression(id: String, data:String) -> Promise<Bool> {
        return Promise { fulfill, reject in
            
            Alamofire.request(.POST, API.BASE_URL + "/locations/" + id + "/impressions/text", parameters: ["data": data]).validate().responseJSON { response in
                switch response.result {
                case .Success:
                    
                    fulfill(true)
                    
                case .Failure(let error):
                    reject(error)
                }
            }
        }
    }
    
    static func addImageImpression(id: String, data:UIImage) -> Promise<Bool> {
        return Promise { fulfill, reject in
            
            Alamofire.upload(
                .POST,
                API.BASE_URL + "/locations/" + id + "/impressions/image",
                multipartFormData: { multipartFormData in
                    multipartFormData.appendBodyPart(data: UIImageJPEGRepresentation(data, 1.0)!, name: "file", fileName: "impression.jpg", mimeType: "image/jpeg")
                },
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .Success( _, _, _):
                        fulfill(true)
                    case .Failure(let encodingError):
                        print(encodingError)
                    }
                }
            )
        }
    }
    
    static func addVideoImpression(id: String, data: NSData) -> Promise<Bool> {
        return Promise { fulfill, reject in
            
            Alamofire.upload(
                .POST,
                API.BASE_URL + "/locations/" + id + "/impressions/video",
                multipartFormData: { multipartFormData in
                    multipartFormData.appendBodyPart(data: data, name: "file", fileName: "impression.mov", mimeType: "video/quicktime")
                },
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .Success(let upload, _, _):
                        upload.responseJSON { response in
                            debugPrint(response)
                        }
                    case .Failure(let encodingError):
                        print(encodingError)
                    }
                }
            )
        }
    }
    
}