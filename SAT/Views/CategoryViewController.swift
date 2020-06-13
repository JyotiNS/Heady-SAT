//
//  CategoryViewController.swift
//  SAT
//
//  Created by Jyoti Sanvake on 10/06/20.
//  Copyright © 2020 Heady. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: BaseView {

    @IBOutlet weak var categoryCollectionView: UICollectionView!
    var productsVM : ProductsViewModel?
    var collectionDataSource : [category]?
    private let reuseIdentifier = "categoryCellID"
    var selectedCategory : category?
//     let nscontext = ((UIApplication.shared.delegate) as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        productsVM = ProductsViewModel.init(webservice: NetworkManager())
        self.categoryCollectionView.dataSource = self
        self.categoryCollectionView.delegate = self
        self.categoryCollectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        self.categoryCollectionView.reloadData()
        getCategoryData()
        //self.loadFromDatabase()
    }
    func getCategoryData(){
        
        if self.isIntenetConnected {
        ProgressView.sharedInstance.showProgressView(msg: "Loading Data", onView: self)
        productsVM?.getProducts(completionHandler: { (categories , error) in
            
            if categories != nil{
                
//                self.collectionDataSource = categories?.categories
                self.saveData(categoryData: categories?.categories)
                ProgressView.sharedInstance.stopProgressView()
//                self.categoryCollectionView.reloadData()
            }
            
        })
        }else{
            
        }
        
    }
    func saveData(categoryData : [category]?){
        
        if let categories = categoryData, categories.count > 0 {
            
            DatabaseClass.sharedInstance.saveAllData(categrotyData: categories)
            self.loadFromDatabase()
        }
    }
    func loadFromDatabase(){
        
        let categories =  DatabaseClass.sharedInstance.getAllCategoryData()
        self.collectionDataSource = [category]()
        self.collectionDataSource?.append(contentsOf: categories)// item is your array
        self.categoryCollectionView.reloadData()
        
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "productSegue" {
            
            if let vc : ProductsViewController = segue.destination as? ProductsViewController {
                
                vc.selectedCategoryID = selectedCategory?.id
                vc.selectedCategoryName = selectedCategory?.name
            }
            
        }else if segue.identifier == "productToChildSegue" {
            
            if let vc : ChildCategoryViewController = segue.destination as? ChildCategoryViewController {
                
                vc.selectedCategory = selectedCategory
//                vc.selectedCategoryName = selectedCategory?.name
            }
        }
    }
    

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
        
        selectedCategory = self.collectionDataSource?[indexPath.item]
        
        if selectedCategory != nil {
            
            if let subcategory = selectedCategory?.childCategories, subcategory.count > 0 {
                
                //show subcategories
                self.performSegue(withIdentifier: "productToChildSegue", sender: self)

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
