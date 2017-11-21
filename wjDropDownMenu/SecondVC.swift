//
//  SecondVC.swift
//  wjDropDownMenu
//
//  Created by ulinix on 2017-11-20.
//  Copyright © 2017 wjq. All rights reserved.
//

import UIKit

class SecondVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red
        
        
        updatePreferredContentSizeWithTraitCollection(traitCollection: self.traitCollection)
        // Do any additional setup after loading the view.
    }

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)

    }

    func updatePreferredContentSizeWithTraitCollection(traitCollection: UITraitCollection) {
        self.preferredContentSize = CGSize(width: self.view.bounds.size.width, height: traitCollection.verticalSizeClass == UIUserInterfaceSizeClass.compact ? 100 : 80);
    }
    
   

}
