//
//  WebService.swift
//  Wazoooom!
//
//  Created by Phumin Abdul Hameed on 01/04/21.
//

import UIKit
import Alamofire

class WebService: NSObject {
    class func getSearchImages(query: String, completionHandler:@escaping([[String:String]],Bool,Error?) -> Void) {
        let url = URL.init(string: String(format: "https://api.unsplash.com/search/photos?page=2&per_page=50&query=%@&client_id=%@",query, "DSccsx-tU2BO4wyloXQoM5BnkzqEzDHeNrWfummjb1I").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        AF.request(URLRequest.init(url: url!))
            .responseJSON { (response) in
                
                if let value = response.value as? [String:Any] {
                    let results = value["results"] as! [[String:Any]]
                    var urlsAdded: [[String:String]] = []
                    for result in results {
                        let urls = result["urls"] as! [String:String]
                        urlsAdded.append(urls)
                    }
                    
                    completionHandler(urlsAdded, true, nil)
                }
                else {
                    completionHandler([], false, response.error)
                }
            }
        
    }
}
