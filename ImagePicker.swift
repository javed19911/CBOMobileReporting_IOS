//
//  ImagePicker.swift
//  CBO Mobile Reporting
//
//  Created by rahul sharma on 01/05/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//

import UIKit
import Photos

protocol ImagePickerDelegate {
    func getImage(image : UIImage )
//    func getImage(image : UIImage , sender : ImagePicker)
}

protocol ImagePickerCancelDelegate {
    func cancelButtonPressed()
}

class ImagePicker: NSObject , UINavigationControllerDelegate, UIImagePickerControllerDelegate  {
    let albumName = "CBO"
    var assetCollection: PHAssetCollection!
    var delegateCancel : ImagePickerCancelDelegate?
    static let camera = UIImagePickerControllerSourceType.camera
    static let gallery = UIImagePickerControllerSourceType.photoLibrary
    
    var delegate : ImagePickerDelegate?
    
    var selectedImage : UIImage!
    var imagePickerController : UIImagePickerController!
    var vc : CustomUIViewController!
    
    static let alert = UIAlertControllerStyle.alert
    static let actionSheet = UIAlertControllerStyle.actionSheet
    
    init( imagePickerController : UIImagePickerController , vc : CustomUIViewController , source : UIImagePickerControllerSourceType) {
        super.init()
        self.vc = vc
      
        selectedImage = UIImage()
        self.imagePickerController = imagePickerController
        onClickRightButton(source : source)
    }
    
    // for choose image from.......
    
    init( imagePickerController : UIImagePickerController , vc : CustomUIViewController  ,alertControllerStyle : UIAlertControllerStyle , title: String) {
        super.init()
        self.vc = vc
        
        selectedImage = UIImage()
        self.imagePickerController = imagePickerController
        onClickRightButton( alertControllerStyle : alertControllerStyle , title : title)
    }
    

    func onClickRightButton(source : UIImagePickerControllerSourceType) {
        if source == UIImagePickerControllerSourceType.camera{
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                imagePickerController.allowsEditing = true
                imagePickerController.sourceType = .camera
                vc.present(imagePickerController, animated: true, completion: nil)
            }
        }else {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                
                imagePickerController.sourceType = .photoLibrary
                vc.present(imagePickerController, animated: true, completion: nil)
            }
        }
    }
    
    private func onClickRightButton( alertControllerStyle : UIAlertControllerStyle ,title: String ){
        
        let alertView = UIAlertController(title:title , message: "", preferredStyle: .alert)
        let camera = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.onClickRightButton(source : ImagePicker.camera)
        }
        let gallery = UIAlertAction(title: "Gallery", style: .default) { (action) in
            self.onClickRightButton(source : ImagePicker.gallery)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertView.addAction(cancel)
        alertView.addAction(camera)
        alertView.addAction(gallery)
        
        vc.present(alertView, animated: true, completion: nil)
        
        
    }
    
    
   
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        delegateCancel?.cancelButtonPressed()
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        delegate?.getImage(image: selectedImage)
//        createFolderinApplicationDirectory(FOLDER_NAME: albumName)
        picker.dismiss(animated: true, completion: nil)
    }

    
    func saveImageDocumentDirectory(fileName: String, image : UIImage ,FOLDER_NAME : String ){
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("/\(FOLDER_NAME)/\(fileName)")
        //        let image = UIImage(named: image)
        print(paths)
        let imageData = UIImageJPEGRepresentation(image, 0.5)
        fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
    }
    
    func createFolderinApplicationDirectory(FOLDER_NAME : String){
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(FOLDER_NAME)
        if !fileManager.fileExists(atPath: paths){
            try! fileManager.createDirectory(atPath: paths, withIntermediateDirectories: true, attributes: nil)
        }else{
            print("Already dictionary created.")
        }
    }
    
    

    func getImageFromApplicationFolder(FOLDER_NAME : String, filename: String) -> String{
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath          = paths.first
        {
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent("\(FOLDER_NAME)/\(filename)")
           // let image    = UIImage(contentsOfFile: imageURL.path)
          
            return imageURL.path
        }else {
            return "error"
        }
    }
}

    
//    func getPhotoFromCustomAlbum() -> UIImage
//    {
//
//        var assetCollection = PHAssetCollection()
//        var albumFound = Bool()
//        var photoAssets = PHFetchResult<AnyObject>()
//
//        let fetchOptions = PHFetchOptions()
//        fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
//        let collection:PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
//
//        if let _:AnyObject = collection.firstObject{
//            //found the album
//            assetCollection = collection.firstObject!
//            albumFound = true
//        }
//        else { albumFound = false }
//        _ = collection.count
//        photoAssets = PHAsset.fetchAssets(in: assetCollection, options: nil) as! PHFetchResult<AnyObject>
//        let imageManager = PHCachingImageManager()
//
//        //        let imageManager = PHImageManager.defaultManager()
//
//        photoAssets.enumerateObjects{(object: AnyObject!,
//            count: Int,
//            stop: UnsafeMutablePointer<ObjCBool>) in
//
//            if object is PHAsset{
//                let asset = object as! PHAsset
//                print("Inside  If object is PHAsset, This is number 1")
//
//                let imageSize = CGSize(width: asset.pixelWidth,
//                                       height: asset.pixelHeight)
//
//                /* For faster performance, and maybe degraded image */
//                let options = PHImageRequestOptions()
//                options.deliveryMode = .fastFormat
//                options.isSynchronous = true
//
//                imageManager.requestImage(for: asset,
//                                          targetSize: imageSize,
//                                          contentMode: .aspectFit ,
//                                          options: options,
//                                          resultHandler: {
//                                            (image, info) -> Void in
//                                            self.selectedImage = image
//                                            print(info!)
//                                            print("Image \(String(describing: image))")
//                                            //self.photo = image!
//                                            /* The image is now available to us */
//                                            //self.addImgToArray(self.photo)
//                                            print("enum for image, This is number 2")
//
//                })
//            }
//        }
//         return selectedImage
//    }
//
//

//    func createAlbumInGallery(){
//
//        if PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.authorized {
//            PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) -> Void in
//                (  self.createAlbum()  )
//            })
//            //  PHPhotoLibrary.requestAuthorization(requestAuthorizationHandler)
//        }
//
//        if let assetCollection = fetchAssetCollectionForAlbum() {
//            self.assetCollection = assetCollection
//            return
//        }
//    }

//    func requestAuthorizationHandler(status: PHAuthorizationStatus) {
//        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
//            // ideally this ensures the creation of the photo album even if authorization wasn't prompted till after init was done
//            print("trying again to create the album")
//            self.createAlbum()
//        } else {
//            print("should really prompt the user to let them know it's failed")
//        }
//    }

//    func createAlbum() {
//        PHPhotoLibrary.shared().performChanges({
//            PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: self.albumName)
//            // create an asset collection with the album name
//        }) { success, error in
//            if success {
//                self.assetCollection = self.fetchAssetCollectionForAlbum()
//            } else {
//                print("error \(String(describing: error))")
//            }
//        }
//    }
//
//    func save(image: UIImage , fileName : String) {
//        if assetCollection == nil {
//            return                          // if there was an error upstream, skip the save
//        }
//
//
//
//        PHPhotoLibrary.shared().performChanges({
//            let assetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
//            let assetPlaceHolder = assetChangeRequest.placeholderForCreatedAsset
//            let albumChangeRequest = PHAssetCollectionChangeRequest(for: self.assetCollection)
//            let enumeration: NSArray = [assetPlaceHolder!]
//            albumChangeRequest!.addAssets(enumeration)
//
//        }, completionHandler: nil)
//    }

    
//    func fetchAssetCollectionForAlbum() -> PHAssetCollection? {
//        let fetchOptions = PHFetchOptions()
//        fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
//
//        print(fetchOptions.predicate!)
//
//        let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
//
//        if let _: AnyObject = collection.firstObject {
//            return collection.firstObject
//        }
//        return nil
//    }
//
//}


//extension ImagePicker{
//    func saveImageDocumentDirectory(fileName: String, image : UIImage){
//        let fileManager = FileManager.default
//        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("/CBOTempImages/\(fileName)")
//        //        let image = UIImage(named: image)
//        print(paths)
//        let imageData = UIImageJPEGRepresentation(image, 0.5)
//        fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
//    }
//
//    func createDirectory(){
//        let fileManager = FileManager.default
//        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("CBOTempImages")
//        if !fileManager.fileExists(atPath: paths){
//            try! fileManager.createDirectory(atPath: paths, withIntermediateDirectories: true, attributes: nil)
//        }else{
//            print("Already dictionary created.")
//        }
//    }
//
//
//    func removeAllPhotoFromCBOTempImages(){
//        let fileManager = FileManager.default
//        let myDocuments = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
//        let diskCacheStorageBaseUrl = myDocuments.appendingPathComponent("/CBOTempImages/")
//        guard let filePaths = try? fileManager.contentsOfDirectory(at: diskCacheStorageBaseUrl, includingPropertiesForKeys: nil, options: []) else { return }
//        print(filePaths)
//        for filePath in filePaths {
//            try? fileManager.removeItem(at: filePath)
//        }
//    }
//
//}
