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
                        
                        var promises = [Promise<User>]()
                        for (_,subJson):(String, JSON) in json {
                            
                            let id = subJson["_id"].string!
                            let userId = subJson["user_id"].string!
                            let date = subJson["create_date"].string
                            let type = subJson["type"].string
                            let dataPath = subJson["data"].string!
                            
                            
                            promises.append(UserService.getUser(userId))
                            
                            if type == "text" {
                                impressions.append(TextImpression(id:id, date:date!, userId: userId, text: dataPath))
                            } else if type == "image" {
                                impressions.append(ImageImpression(id:id, date:date!, userId: userId, imagePath: dataPath))
                            } else if type == "video" {
                                impressions.append(VideoImpression(id:id, date:date!, userId: userId, videoPath: dataPath))
                            } else if type == "audio" {
                                //TODO
                            }
                        }
                        
                        when(promises).then {
                            result -> Void in
                            
                            for (index, impression) in impressions.enumerate() {
                                impression.user = result[index]
                                
                            }
                            fulfill(impressions)
                        }
                    
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
                    multipartFormData.appendBodyPart(data: UIImageJPEGRepresentation(data, 0.8)!, name: "file", fileName: "impression.jpg", mimeType: "image/jpeg")
                },
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .Success(let upload, _, _):
                        upload.responseJSON { response in
                            fulfill(true)
                        }
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
                            fulfill(true)
                        }
                    case .Failure(let encodingError):
                        print(encodingError)
                    }
                }
            )
        }
    }
    
}