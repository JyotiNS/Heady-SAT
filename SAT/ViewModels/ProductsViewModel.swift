//
//  ProductsViewModel.swift
//  SAT
//
//  Created by Jyoti Sanvake on 10/06/20.
//  Copyright © 2020 Heady. All rights reserved.
//

import UIKit

typealias productsDatacompletion = (_ result: ProductDataModel?, _ error :String?)->()

class ProductsViewModel : NSObject {

        private var webservice : NetworkManager
           init(webservice : NetworkManager) {
                     
                 self.webservice = webservice
                 super.init()
             }

        func getProducts(completionHandler : @escaping productsDatacompletion){
            
            
        //    category
            self.webservice.getProductData { (responseData, error) in
                
             DispatchQueue.main.async {
                    
                if let data = responseData {
                    
                     do {
                         let decoder = JSONDecoder()
//                             let data =  NSKeyedArchiver.archivedData(withRootObject: categories!)
                         decoder.keyDecodingStrategy = .convertFromSnakeCase
                         let categoryData = try decoder.decode(ProductDataModel.self, from: data )
                         completionHandler(categoryData,nil)

                     }catch {
                         print(error)
                         completionHandler(nil,error.localizedDescription)
                    }

                }else if (error != nil) {
                    
                    completionHandler(nil,error?.localizedDescription)

                }
            }
                
            }
        }
    
}

class category : NSObject, Codable {
    var id : Int?
    var name : String?
    var products : [product]?
    var childCategories : Array<Int>?
    
}
class product : NSObject, Codable {
    var id : Int?
    var name : String?
    var dateAdded : String?
    var variants : [variant]?
    var tax : tax?
}
class variant : NSObject, Codable {
    var id : Int?
    var color : String?
    var size : Int?
    var price : Int?
    
}
class tax : NSObject, Codable {
    var name : String?
    var value : Double?
}

class ProductDataModel : NSObject, Codable {
    
//    var _id :Int?
    var categories : [category]?
//    var rankings : [ranking]?
    
    
}

//class rankings : NSObject, Codable {
//
//    var ranking : String?
//    var products : [orderProducts]?
//
//}
//
//class orderProducts : NSObject ,Codable {
//
//    var id : Int?
//    var orderCount : Int?
//
//}
