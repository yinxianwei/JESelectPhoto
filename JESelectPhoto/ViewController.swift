//
//  ViewController.swift
//  JESelectPhoto
//
//  Created by 尹现伟 on 15/4/16.
//  Copyright (c) 2015年 尹现伟. All rights reserved.
//

import UIKit

class ViewController: UIViewController,JESPViewControllerDelegate,MLImageCropDelegate {

    @IBOutlet weak var button: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
  
    func cropImage(cropImage: UIImage!, forOriginalImage originalImage: UIImage!) {
        
    }
    @IBAction func push(sender: AnyObject) {

        let button = sender as! UIButton;
        
       
        var flowlayout:UICollectionViewFlowLayout = UICollectionViewFlowLayout();
        flowlayout.scrollDirection = UICollectionViewScrollDirection.Vertical;
        
        

        var s = JESPViewController(collectionViewLayout:flowlayout)
        s.delegate = self;
        s.allowsMultipleSelection = button.tag == 1 ? true : false;
        s.maximumOfSelected = 6;
        self.presentViewController(UINavigationController(rootViewController: s), animated: true) { () -> Void in
            
        };
        
    }
    
    func SPViewControllerdidSelectImages(images: NSArray) {
        println(images);
        let image = images[0] as! UIImage;
        
        button.setBackgroundImage(image, forState: UIControlState.Normal);

    }
    
    func SPViewControllerCancle() {
        
    }
    func SPViewControllerError(error: NSError) {
         println(error);
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
       
        
        
    }


}




//var blocks: NSArray {
//get{
//    if objc_getAssociatedObject(self, gestureRecognizerBlocksArray) == nil {
//        objc_setAssociatedObject(self, gestureRecognizerBlocksArray, NSMutableArray(), UInt(OBJC_ASSOCIATION_RETAIN))
//    }
//    return objc_getAssociatedObject(self, gestureRecognizerBlocksArray) as NSArray
//}
//}
//
//
//static char strAddrKey = 'a';
//
//- (NSString *)addr
//{
//    return objc_getAssociatedObject(self, &strAddrKey);
//    }
//    
//    - (void)setAddr:(NSString *)addr
//{
//    objc_setAssociatedObject(self, &strAddrKey, addr, OBJC_ASSOCIATION_COPY_NONATOMIC);
//}