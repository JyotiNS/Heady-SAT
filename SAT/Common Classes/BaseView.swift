//
//  BaseView.swift
//  Technosoft Intelligent System
//
//  Created by Jyoti Sanvake on 11/05/20.
//  Copyright © 2020 Technosoft Engineering Projects Ltd. All rights reserved.
//

import Foundation
import UIKit

class BaseView : UIViewController {
    
     let itemsPerRow: CGFloat = 2
     let sectionInsets = UIEdgeInsets(top: 10.0,
                                                 left: 20,
                                                 bottom: 0.0,
                                                 right: 20)
     let nscontext = ((UIApplication.shared.delegate) as! AppDelegate).persistentContainer.viewContext

    var isIntenetConnected = true
    var connectionStatus : Bool?
    override func viewDidLoad() {
        
        NotificationCenter.default
                         .addObserver(self,
                                      selector: #selector(statusManager(_:)),
                                      name: .flagsChanged,
                                      object: nil)
        
        
    }
    //Internet connection status handled
    @objc func statusManager(_ notification: Notification) {
        switch Network.reachability.status {
              case .wwan:
                self.isIntenetConnected = true
                print("reachable")
                break
              case .wifi:
                self.isIntenetConnected = true
                  print("reachable")
                break
             case .unreachable:
               self.isIntenetConnected = false
                break
        }
    }
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    func showAlertWithMesage(msg : String){
           
          let message = msg
          let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
          let okAction = UIAlertAction(title: "OK", style: .default, handler: {
              (alert: UIAlertAction!) -> Void in
          })
          alert.addAction(okAction)
          self.present(alert, animated: true, completion: nil)
       }
}
//public extension UIAlertController {
//
//func show() {
//       let appDelegate = UIApplication.shared.delegate as! AppDelegate
//       let vc = UIViewController()
//       vc.view.backgroundColor = .clear
////       vc.view.tintColor = Theme.mainAccentColor
//       appDelegate.alertWindow.rootViewController = vc
//       appDelegate.alertWindow.makeKeyAndVisible()
//       vc.present(self, animated: true, completion: nil)
//   }
//}
extension Array {
    func unique<T:Hashable>(map: ((Element) -> (T)))  -> [Element] {
        var set = Set<T>() //the unique list kept in a Set for fast retrieval
        var arrayOrdered = [Element]() //keeping the unique list of elements but ordered
        for value in self {
            if !set.contains(map(value)) {
                set.insert(map(value))
                arrayOrdered.append(value)
            }
        }

        return arrayOrdered
    }
}
