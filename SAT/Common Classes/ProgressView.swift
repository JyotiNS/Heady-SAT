//
//  ProgressView.swift
//  Technosoft Intelligent System
//
//  Created by Jyoti Sanvake on 08/05/20.
//  Copyright © 2020 Technosoft Engineering Projects Ltd. All rights reserved.
//

import Foundation
import NVActivityIndicatorView

class ProgressView : UIViewController, NVActivityIndicatorViewable {
    
    var activityIndicatorView : NVActivityIndicatorView!
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    var containerView : UIView!
    class var sharedInstance: ProgressView {
        struct Singleton {
            static let instance = ProgressView()
        }
        return Singleton.instance
    }
    
    
    func showProgressView(msg: String, onView : UIViewController) {
        
//        self.view.frame = (appDelegate?.window?.frame)!
        containerView = UIView.init(frame: self.view.frame)
        containerView.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.5)
        self.view.addSubview(containerView)
        NVActivityIndicatorPresenter.sharedInstance.setMessage(msg)
        activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50), type: .ballRotateChase, color: .white, padding: 0)
        activityIndicatorView.center = CGPoint(x:self.view.center.x , y: self.view.center.y - 65)
        containerView.addSubview(activityIndicatorView)
        let msgLabel = UILabel.init(frame: CGRect(x: activityIndicatorView.center.x - 50, y: activityIndicatorView.frame.origin.y + activityIndicatorView.frame.height , width: 200, height: 50))
        
        msgLabel.text = msg
        msgLabel.textColor = .white
        containerView.addSubview(msgLabel)
        onView.view.addSubview(containerView)
        activityIndicatorView.startAnimating()
        
    }
    
    func stopProgressView(){
        if activityIndicatorView.isAnimating {
            NVActivityIndicatorPresenter.sharedInstance.setMessage("Done")
            containerView.removeFromSuperview()
            activityIndicatorView.stopAnimating()
        }
        
    }
    
    
}
