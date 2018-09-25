//
//  AppHelper.swift
//  MoDDA
//
//  Created by Jayesh on 08/06/17.
//  Copyright © 2017 Logistic Infotech Pvt. Ltd. All rights reserved.
//

import Foundation
import Reachability

public struct NetworkReachablity {
    
    func isNetwork() -> Bool {
        let host = Reachability()!
        return (host.connection == .none)
    }
}
public struct ScreenSize
{
    static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

public struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS =  UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPHONE_x = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 2436.0

}

public struct Validator {
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "(?:[A-Za-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[A-Za-z0-9!#$%&'*+/=?^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?\\.)+[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?|\\[(?:(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9]))\\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9])|[A-Za-z0-9-]*[A-Za-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    func isValidUserName(_ userName: String ) -> Bool {
        let uesrNameRegEx = "^[0-9a-zA-Z\\_]{3,18}$"
        let userNameTest = NSPredicate(format:"SELF MATCHES %@", uesrNameRegEx)
        return userNameTest.evaluate(with: userName)
    }
    
    func isValidPassword(_ password: String ) -> Bool {
        if password.count < 6 {
            return false
        }
        return true
    }
    
    static func isValidMobile(_ mobile: String) -> Bool {
        
        let PHONE_REGEX = "^\\+\\d{8,16}"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: mobile)
        return result
    }
    
    static func isValidString(_ str: String) -> Bool {
        
        let newStr = str.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if newStr.count == 0 {
            return false
        }
        return true
    }
    
    
    static func isValidURL(_ url: String) -> Bool {
        
        //        let regex = "((?:http|https)://)?(?:www\\.)?[\\w\\d\\-_]+\\.\\w{2,3}(\\.\\w{2})?(/(?<=/)(?:[\\w\\d\\-./_]+)?)?"
        let regex = "^(http://www\\.|Http://www\\.|https://www\\.|Https://www\\.|http://|Http://|https://|Https://)[a-z0-9]+([\\-\\.]{1}[a-z0-9]+)*\\.[a-z]{2,5}(:[0-9]{1,5})?(/.*)?$"
        
        let URLTest = NSPredicate(format:"SELF MATCHES %@", regex)
        return URLTest.evaluate(with: url)
    }
    
    func isValidInstagramURL(_ url: String) -> Bool {
        
        let regex = "(?:@)([A-Za-z0-9_](?:(?:[A-Za-z0-9_]|(?:\\.(?!\\.))){0,28}(?:[A-Za-z0-9_]))?)"
        
        let URLTest = NSPredicate(format:"SELF MATCHES %@", regex)
        return URLTest.evaluate(with: url)
    }
}

public struct UILabelHelper{
    static func visibleLineCount(_ label:UILabel) -> Int{
        let textSize = CGSize(width: CGFloat(label.frame.size.width), height: CGFloat(MAXFLOAT))
        let rHeight: Int = lroundf(Float(label.sizeThatFits(textSize).height))
        let charSize: Int = lroundf(Float(label.font.pointSize))
        return rHeight / charSize
    }
}

public struct PopupHelper {
    func showPopup(_ popup: UIView, inView superView: UIView){
        
        popup.alpha = 0.0
        superView.addSubview(popup)
        
        popup.layer.shouldRasterize = true;
        popup.layer.rasterizationScale = UIScreen.main.scale
        
        UIView.animate(withDuration: 0.25, animations: {
            popup.alpha = 1.0
        }, completion: {
            (value: Bool) in
            popup.layer.shouldRasterize = false
        })
        popup.layer.add(self.popupAnimation(), forKey: "popup")
    }
    
    func hidePopup(_ popup: UIView){
        popup.layer.shouldRasterize = true;
        popup.layer.rasterizationScale = UIScreen.main.scale
        
        UIView.animate(withDuration: 0.25, animations: {
            popup.alpha = 0.0
        }, completion: {
            (value: Bool) in
            popup.layer.shouldRasterize = false
            popup.removeFromSuperview()
        })
    }
    
    private func popupAnimation() -> CAKeyframeAnimation {
        
        let animation: CAKeyframeAnimation = CAKeyframeAnimation.init(keyPath: "transform")
        
        let scale1: CATransform3D = CATransform3DMakeScale(0.0, 0.0, 1);
        let scale2: CATransform3D = CATransform3DMakeScale(1.1, 1.1, 1);
        let scale3: CATransform3D = CATransform3DMakeScale(0.9, 0.9, 1);
        let scale4: CATransform3D = CATransform3DMakeScale(1.0, 1.0, 1);
        
        let frameValues = NSArray.init(array: [NSValue(caTransform3D:scale1),NSValue(caTransform3D:scale2),NSValue(caTransform3D:scale3),NSValue(caTransform3D:scale4)])
        animation.values = frameValues as? [Any]
        
        let frameTimes = NSArray.init(array: [NSNumber.init(value: 0.0),NSNumber.init(value: 0.5),NSNumber.init(value: 0.75),NSNumber.init(value: 1.0)])
        animation.keyTimes = frameTimes as? [NSNumber]
        animation.fillMode = kCAFillModeForwards;
        animation.isRemovedOnCompletion = false;
        animation.duration = 0.4;
        return animation;
    }
}

public func randomCGFloat(_ lower: CGFloat = 0, _ upper: CGFloat = 1) -> CGFloat{
    return CGFloat(Float(arc4random()) / Float(UINT32_MAX)) * (upper - lower) + lower
}

public func backgroundBlackColor() -> UIColor{
    return UIColor(red: 29.0/255.0, green: 29.0/255.0, blue: 29.0/255.0, alpha: 1.0)
}

public func titleBlackColor() -> UIColor{
    return UIColor(red: 29.0/255.0, green: 29.0/255.0, blue: 29.0/255.0, alpha: 1.0)
}

public func titleWhiteColor() -> UIColor{
    return UIColor.white
}

public func DLog(_ object: Any?, filename: String = #file, line: Int = #line, funcname: String = #function) {
    #if DEBUG
        print("**************************************************\n\(Date()) \(filename.components(separatedBy: "/").last!)(\(line)) \(funcname):\r\(object ?? "nil")\n**************************************************")
    #endif
}

public func hideNavBarAndBackButtonWithTitle(_ title: String, color: UIColor, viewController: UIViewController) {
    
    viewController.navigationController?.navigationBar.setBackgroundImage (UIImage(), for: .default)
    viewController.navigationController?.navigationBar.shadowImage = UIImage()
    viewController.navigationController?.navigationBar.isTranslucent = true
    viewController.navigationController?.view.backgroundColor = .clear
    viewController.title = title
    viewController.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "OratorStd-Slanted", size: 22)!, NSAttributedStringKey.foregroundColor: color]
    viewController.navigationItem.setHidesBackButton(true, animated:false);
}

public func pushVCWithPresentAnimation(navigationController:UINavigationController, viewController:UIViewController){
    let transition = CATransition()
    transition.duration = 0.5
    transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromTop;
    navigationController.view.layer.add(transition, forKey: kCATransition)
    navigationController.pushViewController(viewController, animated: false)
}

public func popVCWithPresentAnimation(navigationController:UINavigationController){
    let transition = CATransition()
    transition.duration = 0.5
    transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromBottom;
    navigationController.view.layer.add(transition, forKey: kCATransition)
    _ = navigationController.popViewController(animated: false)
}

public func showAlertWithTitle(_ title: String, message: String) -> Void{
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
    UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
}

public func showAlertInTabWithTitle(_ title: String, message: String,viewController:UIViewController) -> Void{
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
    viewController.present(alert, animated: true, completion: nil)
}

public func fileInDocumentsDirectory(_ filename: String) -> String {
    
    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let fileURL = documentsURL.appendingPathComponent(filename)
    return fileURL.path
    
}

public func Timestamp() -> String {
    return "\(UInt64(Date().timeIntervalSince1970 * 1000))"
}

public func saveImage (_ image: UIImage, path: String ) -> Bool{
    
    //        let pngImageData = UIImagePNGRepresentation(image)
    let jpgImageData = UIImageJPEGRepresentation(image, 0.6)   // if you want to save as JPEG
    let result = (try? jpgImageData!.write(to: URL(fileURLWithPath: path), options: [.atomic])) != nil
    
    return result
    
}

public func resizeImage(_ image: UIImage, newWidth: CGFloat) -> UIImage {
    
    let scale = newWidth / image.size.width
    let newHeight = image.size.height * scale
    UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
    image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!
}

public func delay(_ delay: Double, closure:@escaping () -> Void) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}
public func settingTopBorder(view:UIView)
{
    let border = CALayer()
    let width = CGFloat(2.0)
    border.borderColor = ColorConstants.TableBorderColor.cgColor
    border.frame = CGRect(x: -2, y: 40, width:  UIScreen.main.bounds.size.width+4, height: view.frame.size.height+5)
    border.borderWidth = width
    
    view.layer.addSublayer(border)
    view.layer.masksToBounds = true
    
}
public func settingBottomBorder(view:UIView)
{
    let border = CALayer()
    let width = CGFloat(2.0)
    border.borderColor = ColorConstants.TableBorderColor.cgColor
    border.frame = CGRect(x: 0, y: view.frame.size.height - width, width:  UIScreen.main.bounds.size.width, height: view.frame.size.height)
    border.borderWidth = width
    
    view.layer.addSublayer(border)
    view.layer.masksToBounds = true
}

public func roundDoubleValue(doubleValue:Double, toPlaces places:Int) -> Double {
    let divisor = pow(10.0, Double(places))
    return (doubleValue * divisor).rounded() / divisor
}

public func topViewController() -> UIViewController?{
    var topVC = UIApplication.shared.keyWindow?.rootViewController
    while ((topVC?.presentedViewController) != nil) {
        topVC = topVC?.presentedViewController
    }
    
    return topVC
}
public func getCurrentViewController()-> UIViewController?{
    var topVC = UIApplication.shared.keyWindow?.rootViewController
    while ((topVC?.presentedViewController) != nil) {
        topVC = topVC?.presentedViewController
    }
    
    return topVC
}

public func printLog(_ log:Any){
    print("\n\n==========>")
    print(log)
    
    if log is String{
        NSLog("\n\n==========>")
        NSLog(log as! String)
        NSLog("<==========\n\nLog Complete")
    }
    print("<==========\n")
}

