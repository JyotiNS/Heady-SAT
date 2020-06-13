//
//  ProductDetailsViewController.swift
//  SAT
//
//  Created by Jyoti Sanvake on 13/06/20.
//  Copyright © 2020 Heady. All rights reserved.
//

import UIKit

class ProductDetailsViewController: BaseView {

    @IBOutlet weak var variants: UIButton!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var size1: UIButton!
    @IBOutlet weak var size2: UIButton!
    @IBOutlet weak var size3: UIButton!
    @IBOutlet weak var size4: UIButton!
    @IBOutlet weak var size5: UIButton!
    
    var selectedProduct : product?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let selectedProduct = self.selectedProduct {
            
            self.productName.text = selectedProduct.name
            if let productVariants = selectedProduct.variants {
                
                self.price.text = "₹ \(productVariants[0].price ?? 0)"
                
                //self.variants.titleLabel?.text = "\(productVariants.count) Variants"
                self.variants.setTitle("\(productVariants.count) Variants", for: .normal)

                let uniqueMessages = productVariants.unique{$0.size}
                
                if uniqueMessages.indices.contains(0), let size = uniqueMessages[0].size {
                    self.size1.setTitle("\(size)", for: .normal)
                    self.size1.isHidden = false
                }
                if uniqueMessages.indices.contains(1), let size = uniqueMessages[1].size {
                    self.size2.setTitle("\(size)", for: .normal)
                    self.size2.isHidden = false
                }
                if uniqueMessages.indices.contains(2), let size = uniqueMessages[2].size {
                    self.size3.setTitle("\(size)", for: .normal)
                    self.size3.isHidden = false
                }
                if uniqueMessages.indices.contains(3), let size = uniqueMessages[3].size {
//                    self.size4.titleLabel?.text = "\(uniqueMessages[3].size!)"
                    self.size4.setTitle("\(size)", for: .normal)
                    self.size4.isHidden = false
                }
                if uniqueMessages.indices.contains(4) , let size = uniqueMessages[4].size{
//                    self.size5.titleLabel?.text = "\(uniqueMessages[4].size!)"
                    self.size5.setTitle("\(size)", for: .normal)
                    self.size5.isHidden = false
                }

            }
            
        }
        
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
