//
//  JESPViewController.swift
//  JESelectPhoto
//
//  Created by 尹现伟 on 15/4/16.
//  Copyright (c) 2015年 尹现伟. All rights reserved.
//

import UIKit
import AssetsLibrary
let reuseIdentifier = "Cell";

let KEY_GROUPNAME = "groupName";
let KEY_PHOTOS    = "photos";

class JESPViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout,UITableViewDataSource,UITableViewDelegate {
    
    
    var assetsLibrary:ALAssetsLibrary = ALAssetsLibrary();
    var photosArray:NSMutableArray = [];
    var tableView:UITableView = UITableView();
    
    var titleButton:UIButton = UIButton();
    var groupId = -1;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initTabView();
        
        self.initNavBar();
        

        
        self.view.backgroundColor = UIColor.whiteColor();
        

        self.collectionView?.backgroundColor = UIColor.whiteColor();
        
        self.collectionView!.registerClass(JEPhotoCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        self.getAllPhotos({ (photos) -> () in
            println(photos);
            
            self.selectGroup(-1);
            self.tableView.reloadData();
            }, errorBlock: { (error:NSError!) -> Void in
                
                
        });
    }
    
    func initNavBar(){
        
        println(self.navigationController?.navigationBar);
        if(self.navigationController?.navigationBar == nil){
            
        }else{
            
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Done, target: self, action: "dismiss:");

            self.titleButton.frame = CGRectMake(0, 0, 200, 30);
            self.titleButton.addTarget(self, action: "titleButtonClick", forControlEvents: UIControlEvents.TouchUpInside);
            self.navigationItem.titleView = self.titleButton;
            self.titleButton.setTitle("全部", forState: UIControlState.Normal);
            self.titleButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal);
        }
    }
    
    func initTabView(){
        self.tableView.frame = CGRectMake(0, -200, self.view.frame.size.width, 200);
        self.view.addSubview(self.tableView);
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell");
        self.tableView.backgroundColor = UIColor.whiteColor();
    }
    
    func titleButtonClick() {
        
        self.titleButton.selected = !self.titleButton.selected;
        
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            
            self.tableView.frame = CGRectMake(0, self.titleButton.selected ? 64 : -200, self.view.frame.size.width, 200);
            
            }) { (ok :Bool) -> Void in

        }
    }
    
    func dismiss(sender:AnyObject){
        
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        });
    }

    
    
    /**
    选择分组
    
    :param: index -1为全部
    */
    func selectGroup(index:Int){
        self.groupId = index;
        
        self.collectionView?.reloadData();

        
    }
    // MARK: - UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.photosArray.count+1;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell;
        
        if indexPath.row == 0{
            cell.textLabel?.text = "全部";
        }
        else{
            var dict = self.photosArray[indexPath.row-1] as! NSDictionary;
            var name = dict[KEY_GROUPNAME] as! String;
            cell.textLabel?.text = name;
        }
        
        
        return cell;
    }
    
    // MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true);
        
        self.titleButtonClick();
        
        var index = indexPath.row - 1;
        
        if index != self.groupId{
            
            self.selectGroup(indexPath.row-1);
                        
            var titleStr = "全部";
            if groupId != -1{
                var dict = self.photosArray[groupId] as! NSDictionary;
                titleStr = dict[KEY_GROUPNAME] as! String;
            }
            
            self.titleButton.setTitle(titleStr, forState: UIControlState.Normal);

        }
        
    }

    
    // MARK: - UICollectionViewDataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return (self.photosArray.count > 0) ? 1 : 0;
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        if groupId == -1{
            var count = 0;
            for dict in self.photosArray{
               count += (dict[KEY_PHOTOS] as! NSArray).count
            }
            return count+1;
        }
        else{
            var dict = self.photosArray[groupId] as! NSDictionary;
            return (dict[KEY_PHOTOS] as! NSArray).count+1;
        }
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! JEPhotoCollectionViewCell
        
        if indexPath.row == 0{
            cell.imageView.image = nil;
            return cell;
        }
        // Configure the cell
        var imagePath:String!;
        if groupId == -1 {

            var ref = self.getAssetInPhotosWithIndex(indexPath.row - 1)?.thumbnail().takeUnretainedValue();
            
            cell.imageView.image =  UIImage(CGImage: ref);
            
        }else{
            
            var array = self.photosArray[groupId][KEY_PHOTOS] as! NSArray;
            var res = array[indexPath.row - 1] as! ALAsset;
            var ref = res.thumbnail().takeUnretainedValue();
          
            cell.imageView.image =  UIImage(CGImage: ref);

        }

        return cell
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake((self.view.frame.width - 10) / 3, (self.view.frame.width - 10) / 3);
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets{
        
        return UIEdgeInsetsMake(5, 0, 5, 0);
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat{
        return 5;
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat{
        return 5;
    }
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        println(indexPath.row);
        
    }
    
    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        println("--->>\(indexPath.row)");
    }
    
    func getAssetInPhotosWithIndex(index:Int) -> ALAsset? {
        var count = 0;
        var i = 0;
        for dict in self.photosArray{
            var array = dict[KEY_PHOTOS] as! NSArray;
            if array.count>0{
                if ((count+array.count-1) >= index){
                    var res = array[index - count] as! ALAsset;

                    return res;
                }
                count += array.count;
                
                i++;
            }
        }
        return nil;
    }
    
    
    // MARK: UICollectionViewDelegate
    
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
    }
    */
    
    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
    }
    */
    
    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return false
    }
    
    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
    return false
    }
    
    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
    


    
    func getAllPhotos(photoBlock:(photos:NSMutableArray)->(),errorBlock:ALAssetsLibraryAccessFailureBlock!){

        self.photosArray = NSMutableArray();
        
        self.assetsLibrary.enumerateGroupsWithTypes(ALAssetsGroupAll, usingBlock: { (group:ALAssetsGroup!, stop:UnsafeMutablePointer<ObjCBool>) -> Void in
            if group != nil{
                
                var ary = NSMutableArray();
                group.enumerateAssetsUsingBlock({ (result:ALAsset!, index:Int, stop:UnsafeMutablePointer<ObjCBool>) -> Void in
                    if (result != nil){
                        
                        var assetType  = result.valueForProperty(ALAssetPropertyType) as! String;
                        
                        if assetType == ALAssetTypePhoto{
                            
                            ary.addObject(result);
                        }
                        
                    }
                    else
                    {
//                        UIButton().addTarget(self, action: "xxx", forControlEvents: UIControlEvents.TouchUpInside);


                        var dict = NSDictionary(objects: [group.valueForProperty(ALAssetsGroupPropertyName),ary], forKeys:[KEY_GROUPNAME,KEY_PHOTOS] );
                        self.photosArray.addObject(dict);
                    }
                    
                });

            }
            else{
                photoBlock(photos:self.photosArray);
            }
            }, failureBlock: errorBlock);
        
    }
    
    

    /*
    func backwards(s1: String, s2: String , closure:()->()) -> Bool {
        
        closure();
        return s1>s2
    }
    
    func setGroup(group : ALAssetsGroup){
        
        println(group.valueForProperty(ALAssetsGroupPropertyName));
        
        var ary = NSMutableArray();
        
        group.enumerateAssetsUsingBlock { (result:ALAsset!, index:Int, stop:UnsafeMutablePointer<ObjCBool>) -> Void in
            if (result != nil){
                
                var assetType  = result.valueForProperty(ALAssetPropertyType) as! String;
                
                if assetType == ALAssetTypePhoto{
                    
                    var assetUrls:AnyObject! = result.valueForProperty(ALAssetPropertyAssetURL) ;
//                    println("\(assetUrls)");
                    ary.addObject(assetUrls);
                }
                
            }
            else
            {
                self.photosArray.addObject(ary);
                //                    array.addObject(ary);
                //                    println("————————————————————\(array)");
            }
            
            
        }
        
    }
    
    
    
//    func getAllPhotos2(){
//        
//        var  array:NSMutableArray = [];
//        var photoDict:NSMutableDictionary = NSMutableDictionary();
//        
//
// 
//        ALAssetsLibrary().enumerateGroupsWithTypes(ALAssetsGroupAll , usingBlock: { (group:ALAssetsGroup!, stop:UnsafeMutablePointer<ObjCBool>) -> Void in
//            
//            if group != nil{
//                
//                self.setGroup(group);
//                
//                
////                var groupAry:NSMutableArray = [];
////                array.addObject(NSDictionary(dictionary: [group.valueForProperty(ALAssetsGroupPropertyName) as! String:NSMutableArray()]));
////                
////                photoDict.setObject(NSMutableArray(), forKey: group.valueForProperty(ALAssetsGroupPropertyName)as!String);
////               
////                group.enumerateAssetsUsingBlock({ (result:ALAsset!, index:Int, stop:UnsafeMutablePointer<ObjCBool>) -> Void in
////                    
////                    
////                    if result != nil{
////                        var assetType  = result.valueForProperty(ALAssetPropertyType) as! String;
////
////                        if assetType == ALAssetTypePhoto{
////                            
////                            var assetUrls:AnyObject! = result.valueForProperty(ALAssetPropertyAssetURL) ;
////                            
////                            var ary = photoDict.valueForKey(group.valueForProperty(ALAssetsGroupPropertyName) as! String) as! NSMutableArray;
////                            
////                            ary.addObject(assetUrls);
////                            
////                            
////                            println("---\(group.valueForProperty(ALAssetsGroupPropertyName))")
////                            
////                            println("\(assetUrls)");
////                            groupAry.addObject(assetUrls);
//////                            for assetURLKey in assetUrls {
//////                                println("---\(assetURLKey)---")
//////                                
//////                            }
////                        }
////                        array.addObject(groupAry);
////                    }
////
//////                    println(stop.boolValue);
////
////                })
//                
//                
//            }
//            else
//            {
//                println("------\(self.photosArray)");
//
//            }
//            
//            }) { (error:NSError!) -> Void in
//                
//        }
//        
//        
//    }

*/
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




class JEPhotoCollectionViewCell:UICollectionViewCell {
    
    var imageView:UIImageView!;
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.imageView = UIImageView(frame: CGRectMake(0, 0, frame.width, frame.height));
        self.contentView.addSubview(self.imageView);
        self.contentView.backgroundColor = UIColor.blackColor();
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    
}
