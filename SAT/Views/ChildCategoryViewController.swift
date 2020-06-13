//
//  ChildCategoryViewController.swift
//  SAT
//
//  Created by Jyoti Sanvake on 13/06/20.
//  Copyright © 2020 Heady. All rights reserved.
//

import UIKit
import CoreData

class ChildCategoryViewController: BaseView {
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!

    var collectionDataSource : [category]?
    private let reuseIdentifier = "categoryCellID"
    var selectedCategory : category?
    var selectedChildCategory : category?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.categoryCollectionView.dataSource = self
        self.categoryCollectionView.delegate = self
         self.categoryCollectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        //        self.categoryCollectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: "categoryCellID")
        self.categoryCollectionView.reloadData()
        loadFromDatabase()
    }
    
    func loadFromDatabase(){
        
//        do {
//        let context = nscontext
//        var locations  = [Category]()  // Login is your Entity name
        let stringArray =  selectedCategory?.childCategories?.map{(Int($0))}
        if stringArray != nil && stringArray?.count ?? 0 > 0 {
            
            let categories =  DatabaseClass.sharedInstance.getChildCategories(childArray: stringArray!)
            self.collectionDataSource = [category]()
            self.collectionDataSource?.append(contentsOf: categories)
            self.categoryCollectionView.reloadData()
        }
//        }
//        catch{
//            print(error)
//        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "childToProducts" {
                   
           if let vc : ProductsViewController = segue.destination as? ProductsViewController {
               
               vc.selectedCategoryID = selectedChildCategory?.id
               vc.selectedCategoryName = selectedChildCategory?.name
           }
           
       }
    }
    

}
extension ChildCategoryViewController : UICollectionViewDataSource {
    
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
extension ChildCategoryViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedCategory = self.collectionDataSource?[indexPath.item]
        
        if selectedCategory != nil {
            
                //show products
                self.selectedChildCategory = selectedCategory
                self.performSegue(withIdentifier: "childToProducts", sender: self)
        }
        
    }
    
}
extension ChildCategoryViewController : UICollectionViewDelegateFlowLayout {
    
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
