//
//  ViewController.swift
//  JESelectPhoto
//
//  Created by 尹现伟 on 15/4/16.
//  Copyright (c) 2015年 尹现伟. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
  
    @IBAction func push(sender: AnyObject) {
        
        var flowlayout:UICollectionViewFlowLayout = UICollectionViewFlowLayout();
        flowlayout.scrollDirection = UICollectionViewScrollDirection.Vertical;
        
        

        var s = JESPViewController(collectionViewLayout:flowlayout)
        

        self.presentViewController(UINavigationController(rootViewController: s), animated: true) { () -> Void in
            
        };
//        self.navigationController?.pushViewController(s, animated: true);
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

