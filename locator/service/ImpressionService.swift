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

    static func getStream(id: String) -> Promise<[AbstractImpression]> {
        return Promise { fulfill, reject in
            
            Alamofire.request(.GET, API.BASE_URL + "/locations/" + id + "/impressions").validate().responseJSON { response in
                
                switch response.result {
                case .Success:
                    
                    if let value = response.result.value {
                        let json = JSON(value)
                        print(json)
                        
                        var impressions = [AbstractImpression]()
                        
                        for (_,subJson):(String, JSON) in json {
                            
                            let user = subJson["user_id"].string
                            let date = subJson["create_date"].string
                            let type = subJson["type"].string
                            let dataPath = subJson["data"].string
                            
                            if type == "text" {
                                let data = dataPath!.dataUsingEncoding(NSUTF8StringEncoding)
                                impressions.append(TextImpression(date:date!, userId: user!, data: data!))
                                break
                                
                            } else if type == "image" {
                                let data = UtilService.dataFromPath(dataPath!)
                                impressions.append(ImageImpression(date:date!, userId: user!, data: data))
                                break
                                
                            } else if type == "audio" {
                                // TODO
                                
                            } else if type == "video" {
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
            
            Alamofire.request(.POST, API.BASE_URL + "/locations/" + id + "/impression/text", parameters: ["data": data]).validate().responseJSON { response in
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
                API.BASE_URL + "/locations/" + id + "/impression/image",
                multipartFormData: { multipartFormData in
                    multipartFormData.appendBodyPart(data: UIImageJPEGRepresentation(data, 1.0)!, name: "file", fileName: "impression.jpg", mimeType: "image/jpeg")
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