//
//  ProductsViewController.swift
//  SAT
//
//  Created by Jyoti Sanvake on 11/06/20.
//  Copyright © 2020 Heady. All rights reserved.
//

import UIKit
import CoreData

class ProductsViewController: BaseView {

    @IBOutlet weak var productsCollectionView: UICollectionView!
    private let reuseIdentifier = "productCellID"
    var collectionDataSource : [product]?
    var selectedCategoryID : Int?
    var selectedCategoryName : String?
    var selectedProduct : product?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.title = self.selectedCategoryName
        self.navigationItem.title  = self.selectedCategoryName
        self.productsCollectionView.register(UINib(nibName: "ProductCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        self.productsCollectionView.reloadData()
        getProductsFromDB()
//
    }
    
    func getProductsFromDB(){
        
        if let selectedCat = self.selectedCategoryID {
            
            let products =  DatabaseClass.sharedInstance.getProductsForCategory(categoryId: selectedCat)
            self.collectionDataSource = [product]()
            self.collectionDataSource?.append(contentsOf: products)
            self.productsCollectionView.reloadData()
        }
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "productDetailSegue" {
                   
           if let vc : ProductDetailsViewController = segue.destination as? ProductDetailsViewController {
               
               vc.selectedProduct = selectedProduct
           }
           
       }
        
    }
    

}
extension ProductsViewController : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.collectionDataSource?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for:indexPath) as! ProductCollectionViewCell
        
        if let product = self.collectionDataSource?[indexPath.item] {
            
            cell.productName.text = product.name
            if let price = product.variants?[0].price{
            cell.price.text = "₹ \(price)"
                
            }
        }
        
        return cell
    }
    
    
    
}

extension ProductsViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedProduct = self.collectionDataSource?[indexPath.item]
        self.selectedProduct = selectedProduct
        if selectedProduct != nil {
            self.performSegue(withIdentifier: "productDetailSegue", sender: self)
            
        }
        
    }
    
}
extension ProductsViewController : UICollectionViewDelegateFlowLayout {
    
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
