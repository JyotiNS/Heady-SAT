//
//  DatabaseClass.swift
//  SAT
//
//  Created by Jyoti Sanvake on 13/06/20.
//  Copyright © 2020 Heady. All rights reserved.
//

import UIKit
import CoreData

class DatabaseClass: NSObject {
    
    let nscontext = ((UIApplication.shared.delegate) as! AppDelegate).persistentContainer.viewContext

    class var sharedInstance: DatabaseClass {
        struct Singleton {
            static let instance = DatabaseClass()
        }
        return Singleton.instance
    }
    
    func saveAllData(categrotyData : [category]){
        
        if categrotyData != nil && categrotyData.count > 0 {
        for category in categrotyData {
            if let products = category.products {
                
            for productsInCat in products {
               
                if let tax = productsInCat.tax {
                    let variantEntity = NSEntityDescription.insertNewObject(forEntityName: "Tax",
                                                                     into: nscontext)
                     variantEntity.setValue(tax.name, forKey: "taxName")
                     variantEntity.setValue(tax.value, forKey: "value")
                     variantEntity.setValue(productsInCat.id, forKey: "productID")
                     do
                     {
                         nscontext.mergePolicy =  NSMergeByPropertyObjectTrumpMergePolicy
                         try nscontext.save()
                     }
                     catch
                     {
                         print("Error!!!")
                     }
                }
                if let variants = productsInCat.variants {
                    
                    for variant in variants {
                       let variantEntity = NSEntityDescription.insertNewObject(forEntityName: "Variant",
                                               into: nscontext)
                       variantEntity.setValue(variant.color, forKey: "color")
                       variantEntity.setValue(variant.price, forKey: "price")
                       variantEntity.setValue(variant.size, forKey: "size")
                       variantEntity.setValue(variant.id, forKey: "variantID")
                       variantEntity.setValue(productsInCat.id, forKey: "productID")

                       do
                       {
                           nscontext.mergePolicy =  NSMergeByPropertyObjectTrumpMergePolicy
                           try nscontext.save()
                       }
                       catch
                       {
                           print("Error!!!")
                       }
                    }
                
                }
                let productEntity = NSEntityDescription.insertNewObject(forEntityName: "Product",
                                        into: nscontext)
                productEntity.setValue(productsInCat.id, forKey: "productID")
                productEntity.setValue(productsInCat.name, forKey: "productName")
                productEntity.setValue(productsInCat.dateAdded, forKey: "dateAdded")
                productEntity.setValue(category.id, forKey: "categoryID")
                do
                {
                    nscontext.mergePolicy =  NSMergeByPropertyObjectTrumpMergePolicy
                    try nscontext.save()
                }
                catch
                {
                    print("Error!!!")
                }
                

            }
            
            let categoryEntity = NSEntityDescription.insertNewObject(forEntityName: "Category",
                                    into: nscontext)

            categoryEntity.setValue(category.id, forKey: "id")
            categoryEntity.setValue(category.name, forKey: "name")
                if let childs = category.childCategories, childs.count > 0 {
                    let stringChilds = childs.map { String($0) }
                    let child = stringChilds.joined(separator:",")
                    categoryEntity.setValue(child, forKey: "childCategory")
                    
                }

            do
            {
                nscontext.mergePolicy =  NSMergeByPropertyObjectTrumpMergePolicy
                try nscontext.save()
            }
            catch
            {
                print("Error!!!")
            }
            print("Record Inserted")
            }
            
        }
    }
    }
    func getAllCategoryData()-> [category]{
        
         let context = nscontext
         var locations  = [Category]()  // Login is your Entity name
         let fetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
        fetchRequest.returnsObjectsAsFaults = false
        locations = try! context.fetch(fetchRequest) as! [Category]
        var categoryData = [category]()
        for location in locations
        {
         
         print("category : \(location.value(forKey: "name") ?? "test")")
         let cat = category.init()
         cat.id = location.value(forKey: "id") as? Int
         cat.name = location.value(forKey: "name") as? String
         let stringChilds = location.value(forKey: "childCategory") as? String
         
         let cats = stringChilds?.components(separatedBy: ",")
         
         if stringChilds != nil {
             cat.childCategories = cats!.map { Int($0)! }
         }
         categoryData.append(cat)// item is your array
        
         
        }
        return categoryData
    }
    func getProductsForCategory(categoryId: Int)-> [product] {
        
        let context = nscontext
         var locations  = [Product]()  // Login is your Entity name
        let predicateCategory = NSPredicate.init(format: "categoryID LIKE[c] %@", "\(categoryId)")
         let fetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: "Product")
        
       
        
        fetchRequest.predicate = predicateCategory
        fetchRequest.returnsObjectsAsFaults = false
        locations = try! context.fetch(fetchRequest) as! [Product]
        var prodcutList = [product]()
        for location in locations
        {
         
         print("Product : \(location.value(forKey: "productName") ?? "test")")
         let newProduct = product.init()
         newProduct.id = location.value(forKey: "productID") as? Int
         newProduct.name = location.value(forKey: "productName") as? String
         newProduct.name = location.value(forKey: "productName") as? String
         newProduct.dateAdded  = location.value(forKey: "dateAdded") as? String
         
        let predicatevar = NSPredicate.init(format: "productID LIKE[c] %@", "\(newProduct.id!)")
        let variantfetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: "Variant")
        variantfetchRequest.predicate = predicatevar
        variantfetchRequest.returnsObjectsAsFaults = false
        let variants = try! context.fetch(variantfetchRequest) as! [Variant]
            var variantArray = [variant]()
            for productVariant in variants{
                
                let newVariant = variant.init()
                newVariant.color = productVariant.value(forKey: "color") as? String
                newVariant.size = productVariant.value(forKey: "size") as? Int
                newVariant.id = productVariant.value(forKey: "variantID") as? Int
                newVariant.price = productVariant.value(forKey: "price") as? Int
                variantArray.append(newVariant)
            }
         newProduct.variants = variantArray
         prodcutList.append(newProduct)// item is your array
         
        }
        return prodcutList
        
    }
    func getChildCategories(childArray : [Int]) -> [category]{
        
        let context = nscontext
        var categoryData = [category]()
        if childArray != nil && childArray.count ?? 0 > 0 {
                    
        //        let predicateCategory = NSPredicate.init(format: "categoryID IN %@", "\(stringArray!)")
            let predicateCategory =  NSPredicate(format:"id IN %@", childArray)
                let fetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
                fetchRequest.predicate = predicateCategory
               fetchRequest.returnsObjectsAsFaults = false
                var locations  = [Category]()  // Login is your Entity name

               locations = try! context.fetch(fetchRequest) as! [Category]
               
               for location in locations
               {
                
                print("category : \(location.value(forKey: "name") ?? "test")")
                let cat = category.init()
                cat.id = location.value(forKey: "id") as? Int
                cat.name = location.value(forKey: "name") as? String
                let stringChilds = location.value(forKey: "childCategory") as? String
                
                let cats = stringChilds?.components(separatedBy: ",")
                
                if stringChilds != nil {
                    cat.childCategories = cats!.map { Int($0)! }
                }
                categoryData.append(cat)// item is your array
                
               }
//                self.categoryCollectionView.reloadData()
          
                }
          return categoryData
        
    }
}
