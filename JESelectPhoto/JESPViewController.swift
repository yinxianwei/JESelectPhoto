//
//  JESPViewController.swift
//  JESelectPhoto
//
//  Created by 尹现伟 on 15/4/16.
//  Copyright (c) 2015年 尹现伟. All rights reserved.
//

import UIKit
import AssetsLibrary
/*
》获取所有的照片列表
》coll加载所有照片
》第一个为相机
》title为照片文件夹选择
》选择照片调用代理
》相机拍照选择调用代理
*/
class JESPViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor();
        self.getAllPhotos();
        
    }
    func getAllPhotos(){
        
        var array:NSMutableArray = [];
        
        
        ALAssetsLibrary().enumerateGroupsWithTypes(ALAssetsGroupAll , usingBlock: { (group:ALAssetsGroup!, stop:UnsafeMutablePointer<ObjCBool>) -> Void in
            
            if group != nil{
                
                var groupAry:NSMutableArray = [];
                
                group.enumerateAssetsUsingBlock({ (result:ALAsset!, index:Int, stop:UnsafeMutablePointer<ObjCBool>) -> Void in
                    if result != nil{
                        var assetType  = result.valueForProperty(ALAssetPropertyType) as! String;

                        if assetType == ALAssetTypePhoto{
                            
                            var assetUrls:AnyObject! = result.valueForProperty(ALAssetPropertyAssetURL) ;


//                            for assetURLKey in assetUrls {
//                                println("---\(assetURLKey)---")
//                                
//                            }
                        }
                        array.addObject(groupAry);
                    }

                })
            }
            
            }) { (error:NSError!) -> Void in
                
        }
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
