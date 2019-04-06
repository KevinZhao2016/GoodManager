//
//  NoNetViewController.swift
//  GoodManager
//
//  Created by DJ on 2019/4/5.
//  Copyright © 2019 GoodManager. All rights reserved.
//

import UIKit

class NoNetViewController: UIViewController {
    
    var newButton:UIButton = UIButton(frame: CGRect(x: 0, y: 20, width: 50, height: 50))
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .brown
        
        newButton.backgroundColor = UIColor.blue
        newButton.setTitle("刷新", for: .normal)
        newButton.addTarget(self, action: #selector(newButtonAction), for: .touchUpInside)
        self.view.addSubview(newButton)
        
        // Do any additional setup after loading the view.
    }

    @objc func newButtonAction() {
        print("select new button")
    }
}
