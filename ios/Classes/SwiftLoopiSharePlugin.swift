import Flutter
import UIKit
import PhotosUI

public class SwiftLoopiSharePlugin: NSObject, FlutterPlugin {
    
    var result: FlutterResult?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "loopi_share", binaryMessenger: registrar.messenger())
        let instance = SwiftLoopiSharePlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        self.result = result
        
        if(call.method == "getPlatformVersion"){
            result("iOS " + UIDevice.current.systemVersion)
            return
        }
        
        if(call.method == "shareInstagramImageStoryWithSticker"){
            let args = call.arguments as? Dictionary<String, Any>
            shareInstagram(args: args!)
            return
        }
        
        result(FlutterMethodNotImplemented)
        
    }
    
    private func shareInstagram(args:Dictionary<String,Any>)  {
        if(args["videoPath"] == nil && args["stickerPath"] == nil){
            self.result?("Message From Switf: videoPath or stickerPath as nil")
            print("Message From Switf: videoPath or stickerPath as nil")
            return
        }
        
        
        let instagramUrl = URL(string: "instagram-stories://share")
        
        guard UIApplication.shared.canOpenURL(instagramUrl! as URL) else {
            self.result?("Instagram app is not installed on your device")
            return
        }
        
        let backgroundPath = args["videoPath"] as? String
        let videoDocumentExists = FileManager.default.fileExists(atPath: backgroundPath!)
        
        let stickerPath = args["stickerPath"] as? String
        let stickerDocumentExists = FileManager.default.fileExists(atPath: stickerPath!)
        
        guard videoDocumentExists && stickerDocumentExists else {
            print("Unexpected error DOCUMENT DOES NOT EXIST.")
            self.result?("Message From Switf: error DOCUMENT DOES NOT EXIST.")
            return
        }
        
        
        do{
            let url:URL? = NSURL(fileURLWithPath: backgroundPath!) as URL
            let background = try NSData(contentsOfFile: url!.path, options: .mappedIfSafe)
            
            let stickerUrl:URL? = NSURL(fileURLWithPath: stickerPath!) as URL
            let sticker = try NSData(contentsOfFile: stickerUrl!.path, options: .mappedIfSafe)
            
            let boardItems = ["com.instagram.sharedSticker.backgroundVideo": background as Any,
                              "com.instagram.sharedSticker.stickerImage": sticker as Any ]
            let pasteBoardItems = [boardItems]
            
            
            guard #available(iOS 10.0, *) else {
                UIPasteboard.general.items = pasteBoardItems
                UIApplication.shared.openURL(instagramUrl!)
                self.result?("Success")
                return
            }
            
            let option: [UIPasteboard.OptionsKey: Any] = [.expirationDate: Date().addingTimeInterval(60 * 5)]
            UIPasteboard.general.setItems(pasteBoardItems, options: option)
            UIApplication.shared.open(instagramUrl!)
            self.result?("Success")
            return
        }
        catch{
            self.result?("Unexpected error converting to NSDATA:\(error).")
            print("Unexpected error converting to NSDATA:\(error).")
            
        }
    }
}
