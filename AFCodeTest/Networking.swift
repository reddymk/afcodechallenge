//
//  Networking.swift
//  AFCodeTest
//
//  Created by Manish Reddy on 10/30/16.
//  Copyright © 2016 Manish. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

class Networking {
    
    static let sharedInstance = Networking()
    let url = "https://www.abercrombie.com/anf/nativeapp/qa/codetest/codeTest_exploreData.json"
    
    //Completion Handlers
    typealias completionHandler = (_ result: NSArray?, _ success: Bool) -> Void
    typealias imageCompletionHandler = (_ image: UIImage?, _ success: Bool) -> Void

    //Get the Json data from Service
    func getJsonData(completionHandler: @escaping completionHandler ) {
        
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if let result = response.result.value {
                    if let jsonArray = result as? NSArray {
                        completionHandler(jsonArray, true)
                    } else {
                        completionHandler(nil, false)
                    }
                }
            }
    }
    
    //Download the image from the server.
    func downloadImageFromServer(_ url: String, completionHandler: @escaping imageCompletionHandler) {
        
        Alamofire.request(url, method: .get)
            .responseImage { response in
                print(response)
                if let image = response.result.value {
                        completionHandler(image, true)
                }
        }
    }
}

