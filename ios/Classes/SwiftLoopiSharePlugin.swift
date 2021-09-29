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
      // let videoPath = args["videoPath"] as? String,
      // let stickerPath = args["stickerPath"] as? String{
      //    result(videoPath)
      //    return
      // }
    }

    result(FlutterMethodNotImplemented)

  }

    // share image via instagram stories.
    // @ args image url
    func shareInstagram(args:Dictionary<String,Any>)  {
        if(args["videoPath"] == nil && args["stickerPath"] == nil){

                return
              }
              let imageExtensions = ["png", "jpg"]
              let instagramUrl = URL(string: "instagram-stories://share")
              if(args["videoPath"] != nil){
                let backgroundPath = args["videoPath"] as? String
                let documentExists = FileManager.default.fileExists(atPath: backgroundPath!)
                print("documentExists \(documentExists)")
                if(documentExists){
                  do{
                    let url:URL? = NSURL(fileURLWithPath: backgroundPath!) as URL
                    let pathExtension = url?.pathExtension
                    let background = try NSData(contentsOfFile: url!.path, options: .mappedIfSafe)
                    if(imageExtensions.contains(pathExtension!)){
                      UIPasteboard.general.addItems([["com.instagram.sharedSticker.backgroundImage": background as Any]])
                    }else{
                      UIPasteboard.general.addItems([["com.instagram.sharedSticker.backgroundVideo": background as Any]])
                    }
                  }catch{
                    print("Unexpected error converting to NSDATA:\(error).")
                  }
                }else{
                  print("Unexpected error DOCUMENT DOES NOT EXIST.")
                }
              }

              if(args["stickerPath"] != nil){
                let stickerPath = args["stickerPath"] as? String
                let documentExists = FileManager.default.fileExists(atPath: stickerPath!)
                print("documentExists \(documentExists)")
                if(documentExists){
                  do{
                    let url:URL? = URL(fileURLWithPath: stickerPath!) as URL
                    let pathExtension = url?.pathExtension
                    let sticker = try NSData(contentsOfFile: url!.path, options: .mappedIfSafe)
                    if(imageExtensions.contains(pathExtension!)){
                        do{
                            let imageData = try Data(contentsOf: url!)
                            let uiImage = UIImage(data: imageData)
//                            UIPasteboard.general.addItems([["com.instagram.sharedSticker.backgroundImage": UIImagePNGRepresentation(uiImage!).pngData]])
                        }catch {
                            print("Error loading image : \(error)")
                        }
                       // UIPasteboard.general.addItems(["com.instagram.sharedSticker.stickerImage": UIImage(imageWithData: sticker) ])
                      
                    }
                  }catch{
                    print("Unexpected error converting to NSDATA:\(error).")
                  }
                }else{
                  print("Unexpected error DOCUMENT DOES NOT EXIST.")
                }
              }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(instagramUrl!)
        } else {
            // Fallback on earlier versions
        }
        
    }




    // func shareInstagram(args:Dictionary<String,Any>)  {
    //     let imageUrl=args["stickerPath"] as! String
    
    //     let image = UIImage(named: imageUrl)
    //     if(image==nil){
    //         self.result!("File format not supported Please check the file.")
    //         return;
    //     }
    //     guard let instagramURL = URL(string: "instagram-stories://share") else {
    //         if let result = result {
    //             self.result?("Instagram app is not installed on your device")
    //             result(false)
    //         }
    //         return
    //     }
        
    //     do{
    //         try PHPhotoLibrary.shared().performChangesAndWait {
    //             let request = PHAssetChangeRequest.creationRequestForAsset(from: image!)
    //             let assetId = request.placeholderForCreatedAsset?.localIdentifier
    //             let instShareUrl:String? = "instagram://library?LocalIdentifier=" + assetId!
                
    //             //Share image
    //             if UIApplication.shared.canOpenURL(instagramURL as URL) {
    //                 if let sharingUrl = instShareUrl {
    //                     if let urlForRedirect = NSURL(string: sharingUrl) {
    //                         if #available(iOS 10.0, *) {
    //                             UIApplication.shared.open(urlForRedirect as URL, options: [:], completionHandler: nil)
    //                         }
    //                         else{
    //                             UIApplication.shared.openURL(urlForRedirect as URL)
    //                         }
    //                     }
    //                     self.result?("Success")
    //                 }
    //             } else{
    //                 self.result?("Instagram app is not installed on your device")
    //             }
    //         }
        
    //     } catch {
    //         print("Fail")
    //     }
    // }
}
