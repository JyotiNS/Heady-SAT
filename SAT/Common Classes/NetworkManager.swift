//
//  NetworkManager.swift
//  SAT
//
//  Created by Jyoti Sanvake on 10/06/20.
//  Copyright © 2020 Heady. All rights reserved.
//

import Foundation
import Alamofire


class NetworkManager {
    
    var productsURL = "https://stark-spire-93433.herokuapp.com/json"

    func getProductData(completion :@escaping (Data?,Error?)->()){
        
        let sourcesURL : URL = URL.init(string:productsURL)!
        AF.request(sourcesURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil, interceptor: nil, requestModifier: nil)
            .responseJSON { (response) in
            if let data = response.data {
                
                completion(data,nil)
            }else if let error = response.error {
                
                completion(nil, error)
            }
        }
    }

    
}
