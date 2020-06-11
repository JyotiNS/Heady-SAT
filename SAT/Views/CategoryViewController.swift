//
//  CategoryViewController.swift
//  SAT
//
//  Created by Jyoti Sanvake on 10/06/20.
//  Copyright © 2020 Heady. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UIViewController {

    @IBOutlet weak var categoryCollectionView: UICollectionView!
    var productsVM : ProductsViewModel?
    var collectionDataSource : [category]?
    private let reuseIdentifier = "categoryCellID"
    private let itemsPerRow: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(top: 10.0,
                                             left: 20,
                                             bottom: 0.0,
                                             right: 20)
     let nscontext = ((UIApplication.shared.delegate) as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        productsVM = ProductsViewModel.init(webservice: NetworkManager())
        self.categoryCollectionView.dataSource = self
        self.categoryCollectionView.delegate = self
        self.categoryCollectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
//        self.categoryCollectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: "categoryCellID")
        self.categoryCollectionView.reloadData()
        getCategoryData()
        //self.loadFromDatabase()
    }
    func getCategoryData(){
        
        productsVM?.getProducts(completionHandler: { (categories , error) in
            
            if categories != nil{
                
//                self.collectionDataSource = categories?.categories
                self.saveData(categoryData: categories?.categories)
                
//                self.categoryCollectionView.reloadData()
            }
            
        })
        
    }
    func saveData(categoryData : [category]?){
        
        if let categories = categoryData, categories.count > 0 {
            
            for category in categories {
                let entity = NSEntityDescription.insertNewObject(forEntityName: "Category",
                                        into: nscontext)

                entity.setValue(category.id, forKey: "id")
                entity.setValue(category.name, forKey: "name")
               
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
            self.loadFromDatabase()
            
        }
    }
    func loadFromDatabase(){
        
        
        let context = nscontext
        var locations  = [Category]()  // Login is your Entity name
        let fetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
       fetchRequest.returnsObjectsAsFaults = false
       locations = try! context.fetch(fetchRequest) as! [Category]
       self.collectionDataSource = [category]()
       for location in locations
       {
        
        print("category : \(location.value(forKey: "name") ?? "test")")
        let cat = category.init()
        cat.id = location.value(forKey: "id") as? Int
        cat.name = location.value(forKey: "name") as? String
        
        self.collectionDataSource?.append(cat)// item is your array
        
       }
        self.categoryCollectionView.reloadData()
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension CategoryViewController : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.collectionDataSource?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for:indexPath) as! CategoryCollectionViewCell
        
        if let category = self.collectionDataSource?[indexPath.item] {
            
            cell.categoryName.text = category.name
            
        }
        
        return cell
    }
    
    
    
}

extension CategoryViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedCategory = self.collectionDataSource?[indexPath.item]
        
        if selectedCategory != nil {
            
            if let subcategory = selectedCategory?.childCategories, subcategory.count > 0 {
                
                //show subcategories
            }else{
                
                //show products
                self.performSegue(withIdentifier: "productSegue", sender: self)
            }
            
        }
        
    }
    
}
extension CategoryViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
     
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
      return sectionInsets
    }

    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      return sectionInsets.left
    }
}
