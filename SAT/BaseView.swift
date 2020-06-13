//
//  ViewController.swift
//  SAT
//
//  Created by Jyoti Sanvake on 10/06/20.
//  Copyright © 2020 Heady. All rights reserved.
//

import UIKit

class BaseView: UIViewController {
    
    private let itemsPerRow: CGFloat = 2
       private let sectionInsets = UIEdgeInsets(top: 10.0,
                                                left: 20,
                                                bottom: 0.0,
                                                right: 20)
    let nscontext = ((UIApplication.shared.delegate) as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

