//
//  AdImageViewController.swift
//  CBO Mobile Reporting
//
//  Created by rahul sharma on 24/02/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//

import UIKit

import Photos

class AdImageViewController: CustomUIViewController  , UIScrollViewDelegate{

    var image_index = 0
    
    
    
    @IBOutlet weak var myImageConterController: UIPageControl!
    
    var allControllerIsHidden : Bool = false

    @IBOutlet weak var bottomView: UIView!
    var InnerIndex = 0
    var indexId = 0
    var imageArrayc = [String]()
      var tempIndex = 0
    
    var sample_id = [String]()
    var sample_name = [String]()
    
    var imageArraya = [[String]]()
    var InnerInmageArray = [String]()
    var imageArray = [UIImage]()
    
    var myImagesDic = [[String : [String]]]()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollImg: UIScrollView!
    @IBOutlet weak var backButton: CustomeUIButton!

    @IBOutlet weak var saveNextButton: CustomeUIButton!
    @IBOutlet weak var myTopView: TopViewOfApplication!
    
    @IBOutlet weak var nextButton: CustomeUIButton!

    
    var swipeRight = UISwipeGestureRecognizer()
    var swipeLeft = UISwipeGestureRecognizer()
   
    override func viewDidLoad() {
    super.viewDidLoad()
     
        myTopView.backButton.addTarget(self, action: #selector(closeVC), for: .touchUpInside)
      saveNextButton.isHidden = true
        
        // swipe images
         swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)

        swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))

        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)

        swipeLeft.isEnabled = true
        swipeRight.isEnabled = true
     
        // scrolling
        
        scrollImg.delegate = self
        scrollImg.alwaysBounceVertical = false
        scrollImg.alwaysBounceHorizontal = false
        scrollImg.showsVerticalScrollIndicator = true
        scrollImg.flashScrollIndicators()

        scrollImg.minimumZoomScale = 1.0
        scrollImg.maximumZoomScale = 10.0

      
        
        nextButton.isHidden = true
        backButton.isHidden = true
        
        
 
        
        sample_id = VCIntentArray["sample_id"]! as! [String]
        sample_name = VCIntentArray["sample_name"]! as! [String]
   
        
        
        print(sample_id[indexId] , sample_name[indexId])
        
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let myFilesPath = documentDirectoryPath.appending("/Cbo/Product/")
        let fileManager = FileManager.default

        let files = fileManager.enumerator(atPath: myFilesPath)
        
        
        while let file = files?.nextObject() {

            let file1 = file as! String
            print(file1)

            if file1.contains(".") && file1.contains(String(sample_id[indexId])){
                print(file1)
                //imageView.image = UIImage(contentsOfFile: myFilesPath.appending("\(file1)"))
            }
        }
        
        
        let doubleTapGest = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapScrollView(recognizer:)))
        doubleTapGest.numberOfTapsRequired = 2
        
        scrollImg.addGestureRecognizer(doubleTapGest)
        

        
        myTopView.isHidden = true
        
        let singleTapGest = UITapGestureRecognizer(target: self, action: #selector(handleSingleTapScrollView(recognizer:)))
        singleTapGest.numberOfTapsRequired = 1
        
        scrollImg.addGestureRecognizer(singleTapGest)

        if indexId == 0 {
            backButton.isHidden = true
        } else if indexId == sample_id.count - 1{
            nextButton.isHidden = true
        }

//        changeImageGroup(IndexIdVar: indexId)
        
        imageView!.layer.cornerRadius = 11.0
        imageView!.clipsToBounds = false
        imageArrayc.removeAll()
        
        bottomView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
    
        setImage()
    }
    
    
   
    
    
    
    func changeImageGroup(IndexIdVar : Int){
        let innerDic = myImagesDic[indexId] as Dictionary<String , [String]>
        
        for innerArray in innerDic{
            print(innerArray.key)
            imageView.image = UIImage(contentsOfFile: getPath().appending("/\(innerArray.key)"))
            
             myTopView.setText(title: innerArray.key )
        }
    }
    
    
    @objc func closeVC(){
        myTopView.CloseCurruntVC(vc: self)
    }
    
    func getPath() -> String{
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        
        let filePath = documentDirectory.appending("/Cbo/Product/")
        return filePath
    }
    
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.left:
                    nextImage()
                print("swiperight")
                break
            case UISwipeGestureRecognizerDirection.right:
                    previousImage()
                
                print("Swiped left")
                break
            default:
                break
            }
        }
    }


    override func viewDidAppear(_ animated: Bool) {
     
        nextButton.addTarget(self, action: #selector(pressedNextButton), for: .touchUpInside)

        backButton.addTarget(self, action: #selector(pressedBackButton), for: .touchUpInside)

    }

    

    @objc func handleSingleTapScrollView(recognizer: UITapGestureRecognizer) {
       
       
        if allControllerIsHidden == true{
            
          
            myTopView.isHidden = allControllerIsHidden
            bottomView.isHidden = allControllerIsHidden

      
            backButton.isHidden = allControllerIsHidden
            nextButton.isHidden =  allControllerIsHidden
           
            
            
        
             print(allControllerIsHidden)

        } else if allControllerIsHidden == false{
            print(allControllerIsHidden)
             myTopView.isHidden = allControllerIsHidden
                bottomView.isHidden = allControllerIsHidden

           
            backButton.isHidden = (indexId  == 0)
            nextButton.isHidden = (indexId == sample_id.count - 1 )
            
        }
    
        allControllerIsHidden = !allControllerIsHidden
        
    }
    

    @objc func handleDoubleTapScrollView(recognizer: UITapGestureRecognizer) {

            if scrollImg.zoomScale == 1 {
                scrollImg.zoom(to: zoomRectForScale(scale: scrollImg.maximumZoomScale, center: recognizer.location(in: recognizer.view)), animated: true)
            } else {
                scrollImg.setZoomScale(1, animated: true)
        }
    }

    func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = imageView.frame.size.height / scale
        zoomRect.size.width  = imageView.frame.size.width  / scale
        let newCenter = imageView.convert(center, from: scrollImg)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }

    @objc func pressedNextButton(){
        nextGroup()
    }

    @objc func pressedBackButton(){
        previousGroup()
    }
    
    public func prepareImageArray(id : String,index : Int){
        
        if !sample_name[index].isEmpty{
             myTopView.setText(title: sample_name[index])
        }
        imageArrayc.removeAll()
        
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        
        let path = ("\(documentDirectoryPath)/Cbo/Product/\(id).jpg")
//        print(path)
        
        let path1 =  ("\(documentDirectoryPath)/Cbo/Product/\(id)_\(Custom_Variables_And_Method.pub_doctor_spl_code).jpg");
        //print(path1)
        
         let fileManager = FileManager.default
        
         //print(fileManager.fileExists(atPath: path))
        
        if fileManager.fileExists(atPath: path1){
            imageArrayc.append(path1)
            
            bind_imageArray(path: ("\(documentDirectoryPath)/Cbo/Product/\(id)_\(Custom_Variables_And_Method.pub_doctor_spl_code)"))
        } else if  fileManager.fileExists(atPath: path){
            imageArrayc.append(path)
            
            bind_imageArray(path: "\(documentDirectoryPath)/Cbo/Product/\(id)")
            
        }else{
            imageArrayc.append("no_image")
        }
        
    }
    
    
    
    public func bind_imageArray( path : String){
          image_index += 1
       // print(path)
        let path1 =  ("\(path)_\(image_index).jpg")
        
        let fileManager = FileManager.default
        
        if  fileManager.fileExists(atPath: path1){
            imageArrayc.append(path1)
            bind_imageArray(path: path)
          
        } else {
            image_index = 0
        }
    }

    
    
  
    
    
    
    
    
    func setImage(){
        
        prepareImageArray(id: sample_id[indexId], index: indexId)
        print(imageArrayc)
        tempIndex = 0
        myImageConterController.numberOfPages = imageArrayc.count
        myImageConterController.currentPage = tempIndex
        
        image_index = 0
        if imageArrayc[0] == "no_image"{
            imageView.image =  UIImage(named : "no_image.png")
        }else{
            imageView.image =  UIImage(contentsOfFile: imageArrayc[tempIndex])
        }
            
    }
    
//
    
    
    
    
    
    
    
  
    func nextImage(){
        
        if imageArrayc.count - 1 > tempIndex {
            tempIndex += 1
            imageView.image = UIImage(contentsOfFile: imageArrayc[tempIndex])
             myImageConterController.currentPage = tempIndex
            print(tempIndex)
        }
    }
    
    
    
    func previousImage(){
        if 0 < tempIndex {
            tempIndex -= 1
            imageView.image = UIImage(contentsOfFile: imageArrayc[tempIndex])
             myImageConterController.currentPage = tempIndex
            print(tempIndex)
        }
    }
    
    
    func nextGroup(){
        if sample_id.count - 1 > indexId {
            indexId += 1
            setImage()
            nextButton.isHidden = (indexId == sample_id.count - 1)
        }
         backButton.isHidden = (indexId == 0)
    }
    
    
    func previousGroup(){
        if 0 < indexId {
            indexId -= 1
            setImage()
            
            backButton.isHidden = (indexId == 0)
        }
         nextButton.isHidden = (indexId == sample_id.count - 1)
    }
    
    
    
    

}











