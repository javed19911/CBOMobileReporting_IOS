//
//  dictionary.swift
//  CBO Mobile Reporting
//
//  Created by CBO IOS on 07/01/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//

import Foundation
import UIKit
// delegate
protocol OurErrorProtocol: LocalizedError {
    
    var title: String? { get }
    var code: Int { get }
}

struct CustomError: OurErrorProtocol {
    
    var title: String?
    var code: Int
    var errorDescription: String? { return _description }
    var failureReason: String? { return _description }
    
    private var _description: String
    
    init(title: String?, description: String, code: Int) {
        self.title = title ?? "Error"
        self._description = description
        self.code = code
    }
}

extension Dictionary {
    func getString(key: Key) throws -> Value {
        if self.keys.contains(key) == true {
            return self[key]!
        }else {
            let error = CustomError(title: "Invalid key ", description: "Key not found \(key) ", code: 10000)
           throw   error
       }
    }
    
}

extension UIFont {
    
    func withTraits(traits:UIFontDescriptorSymbolicTraits...) -> UIFont {
        let descriptor = self.fontDescriptor
            .withSymbolicTraits(UIFontDescriptorSymbolicTraits(traits))
        return UIFont(descriptor: descriptor!, size: 0)
    }
    
    func bold() -> UIFont {
        return withTraits(traits: .traitBold)
    }
    
}


extension UITableView {
    func scrollToBottom(animated: Bool) {
        let y = contentSize.height - frame.size.height
        setContentOffset(CGPoint(x: 0, y: (y<0) ? 0 : y), animated: animated)
    }
    
 
        func setOffsetToBottom(animated: Bool) {
            self.setContentOffset(CGPoint(x :0, y : self.contentSize.height - self.frame.size.height), animated: true)
        }
        
        func scrollToLastRow(animated: Bool) {
            if self.numberOfRows(inSection: 0) > 0 {
                let indexPath = IndexPath(row: self.numberOfRows(inSection: 0) - 1, section: 0)
                self.scrollToRow(at: indexPath, at: .bottom, animated: true)

                // self.scrollToRowAtIndexPath(IndexPath(row :self.numberOfRows(inSection: 0) - 1), atScrollPosition: .bottom, animated: animated)
            }
        }
    }







extension String{
    
    
    func changeDirectoryUp(path : String) -> String{
        var newPath = ""
        let mypath = String(path.dropLast())
        var counter = 0 ,temp_counter = 0 ,pos = 0 , charLastPos = 0
        
        for a in mypath {
            if a == "/"{
                charLastPos = pos
                counter += 1
            }
            pos += 1
        }
        for a in mypath{
            let b = a
            if a == "/"{
                temp_counter += 1
                if counter > temp_counter {
                    newPath = newPath.appending("\(b)")
                }
            }else{
                newPath = newPath.appending("\(b)")
            }
        }
        
        if newPath.substringFrom(offSetTo: charLastPos - 1).appending("/").count > 1{
            return newPath.substringFrom(offSetTo: charLastPos - 1).appending("/")
        }else  { return "" }
        
        
        //        return newPath.substringFrom(offSetTo: charLastPos - 1).appending("/")
        //return currentDir
    }
    
    
    
    func subString( offsetFrom : Int , offSetTo : Int  ) -> String{
        var tempOffSetTo = offSetTo , tempOffSetFrom = offsetFrom
        
        
        
        if tempOffSetFrom < 0 || tempOffSetFrom > self.count - 1{
            
            tempOffSetFrom = 0
            
        }
        
        if tempOffSetTo < 0 || tempOffSetTo >= self.count - 1{
            
            tempOffSetTo = self.count - 1
            
        }
        let index = self.index(self.startIndex, offsetBy: tempOffSetTo)
        var newSubString = self[...index]
        newSubString = newSubString.dropFirst(tempOffSetFrom)
        return "\(newSubString)"
    }
    
    
    func substringFrom(offSetFrom : Int) -> String {
    
            return subString(offsetFrom: offSetFrom, offSetTo: self.count - 1)
    }
    
    func substringFrom(offSetTo : Int) -> String {
      
            return  subString(offsetFrom: 0, offSetTo: offSetTo )
        }
    
    func lastIndexOf(char : String ) -> Int{
        let index2 = self.range(of: char, options: .backwards)?.lowerBound


//        print((index2.map(self.substring(to:))?.count)!)

        return  (index2.map(self.substring(to:))?.count)!
    }

    func lastIndexOfForward(char : String ) -> Int{
        let index2 = self.range(of: char, options: .diacriticInsensitive)?.lowerBound
//        print ((index2.map(self.substring(to:))?.count)! - 1)

        return  (index2.map(self.substring(to:))?.count)!
    }
    
    
    
    
}



extension UIView{
    func getShadow(color : UIColor) {
        let viewShadow = UIView(frame: CGRect(x: self.frame.origin.x, y:  self.frame.origin.y, width: self.frame.width, height: self.frame.height))
        viewShadow.center = self.center
      
        viewShadow.layer.shadowColor = color.cgColor
        viewShadow.layer.shadowOpacity = 1
        viewShadow.layer.shadowOffset = CGSize.zero
        viewShadow.layer.shadowRadius = 5
        self.addSubview(viewShadow)
    }
}



extension UITableView {
    
    func layoutTableHeaderView() {
        
        guard let headerView = self.tableHeaderView else { return }
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        let headerWidth = headerView.bounds.size.width;
        let temporaryWidthConstraints = NSLayoutConstraint.constraints(withVisualFormat: "[headerView(width)]", options: NSLayoutFormatOptions(rawValue: UInt(0)), metrics: ["width": headerWidth], views: ["headerView": headerView])
        
        headerView.addConstraints(temporaryWidthConstraints)
        
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        
        let headerSize = headerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        let height = headerSize.height
        var frame = headerView.frame
        
        frame.size.height = height
        headerView.frame = frame
        
        self.tableHeaderView = headerView
        
        headerView.removeConstraints(temporaryWidthConstraints)
        headerView.translatesAutoresizingMaskIntoConstraints = true
        
    }
}


extension UIButton {
    private struct AssociatedKeys {
        static var DescriptiveName = "nsh_DescriptiveName"
    }
    
    @IBInspectable var descriptiveName: String? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.DescriptiveName) as? String
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(
                    self,
                    &AssociatedKeys.DescriptiveName,
                    newValue as NSString?,
                    objc_AssociationPolicy(rawValue: UInt(Float((objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC).rawValue)))!
                )
            }
        }
    }
}



extension Date {
    
    func getMonthName() -> String {
        let dateFormatter = DateFormatter()
        // only for month name
        //dateFormatter.dateFormat = "MMM"
        
        // month name with year
        dateFormatter.dateFormat = "MMM-YYYY"
        let strMonth = dateFormatter.string(from: self)
        return strMonth
    }
}


extension UIImage {
    var uncompressedPNGData: Data?      { return UIImagePNGRepresentation(self)        }
    var highestQualityJPEGNSData: Data? { return UIImageJPEGRepresentation(self, 1.0)  }
    var highQualityJPEGNSData: Data?    { return UIImageJPEGRepresentation(self, 0.75) }
    var mediumQualityJPEGNSData: Data?  { return UIImageJPEGRepresentation(self, 0.5)  }
    var lowQualityJPEGNSData: Data?     { return UIImageJPEGRepresentation(self, 0.25) }
    var lowestQualityJPEGNSData:Data?   { return UIImageJPEGRepresentation(self, 0.0)  }
    
    
    func convertImageToUploadableData() -> Data{
        
        let myimage = self.lowestQualityJPEGNSData
        
        let array = [UInt8](myimage!)
        print("Image size in bytes:\(array.count)")
        
        // converting data to image
        let finalImage = UIImage(data:myimage!,scale:0.0)
        
        
        let myimage1 = finalImage?.lowestQualityJPEGNSData
        let array1 = [UInt8](myimage1!)
        print("Image size in bytes:\(array1.count)")
        
        
        let finalImage1 = UIImage(data:myimage1!,scale:0.0)
        let resizedImage = resizeImage(image: resizeImage(image: finalImage1!))
        let reImage = resizeImage(image: resizedImage).lowestQualityJPEGNSData
        
        
        let array11 = [UInt8](reImage!)
        print("Image size in bytes:\(array11.count)")
        return reImage!
        
        
    }
    
    
    
        func resizeImage(image: UIImage) -> UIImage {
            var actualHeight: Float = Float(image.size.height)
            var actualWidth: Float = Float(image.size.width)
            let maxHeight: Float = 300.0
            let maxWidth: Float = 400.0
            var imgRatio: Float = actualWidth / actualHeight
            let maxRatio: Float = maxWidth / maxHeight
            let compressionQuality: Float = 0.5
            //50 percent compression
            
            if actualHeight > maxHeight || actualWidth > maxWidth {
                if imgRatio < maxRatio {
                    //adjust width according to maxHeight
                    imgRatio = maxHeight / actualHeight
                    actualWidth = imgRatio * actualWidth
                    actualHeight = maxHeight
                }
                else if imgRatio > maxRatio {
                    //adjust height according to maxWidth
                    imgRatio = maxWidth / actualWidth
                    actualHeight = imgRatio * actualHeight
                    actualWidth = maxWidth
                }
                else {
                    actualHeight = maxHeight
                    actualWidth = maxWidth
                }
            }
            
            let rect = CGRect(x :0.0, y: 0.0, width : CGFloat(actualWidth), height : CGFloat(actualHeight))
            UIGraphicsBeginImageContext(rect.size)
            image.draw(in: rect)
            let img = UIGraphicsGetImageFromCurrentImageContext()
            let imageData = UIImageJPEGRepresentation(img!,CGFloat(compressionQuality))
            UIGraphicsEndImageContext()
            return UIImage(data: imageData!)!
        }
        
        
    
    
    
    
    
}


//extension String{
//    func subString(offsetFrom : Int , offSetTo : Int  ) -> String{
//
//        if offSetTo > 0 && offSetTo > 0 && offsetFrom <= offSetTo{
//            let index4 = self.index(self.startIndex, offsetBy: offSetTo)
//
//
//            if offSetTo <=  self.characters.count{
//                //
//                var newSubString = self[...index4]
//                newSubString = newSubString.dropFirst(offsetFrom)
//                return "\(newSubString)"
//            }
//            return "index is out of range"
//        } else {
//            return "offSetTo value should be greater then offsetFrom"
//        }
//    }
//}

