//
//  ResumeVC.swift
//  TeamPlayer
//
//  Created by Ritesh Sinha on 04/08/21.
//

import UIKit

class ResumeVC: UIViewController, UIDocumentPickerDelegate {

    @IBOutlet weak var uploadCvBtn: UIButton!
    
    var imagePicker = UIImagePickerController()
    var uplaodedCv = ""
    var param:[String:Any]!
    var completionHandlerCallback:((String?) ->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func uploadAction(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Please select what would you like to upload?", message: "", preferredStyle: .actionSheet)
        alertController.view.tintColor = UIColor(displayP3Red: 49/255.0, green: 128/255.0, blue: 152/255.0, alpha: 1.0)
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(UIAlertAction(title: "Image", style: .default , handler:{ (UIAlertAction)in
            self.chooseType()
        }))
        alertController.addAction(UIAlertAction(title: "Document", style: .default , handler:{ (UIAlertAction)in
            self.clickFunction()
        }))
        
        alertController.addAction(cancelButton)
        self.present(alertController, animated: true, completion: nil)
//        UIApplication.topViewController()?.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func buyAction(_ sender: Any) {
    }
    
    @IBAction func submitAction(_ sender: Any) {
        if self.uplaodedCv.isEmpty {
            self.view.makeToast("Please upload Resume.")
            return
        }
        if self.completionHandlerCallback != nil {
            self.completionHandlerCallback!(self.uplaodedCv)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension ResumeVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIDocumentMenuDelegate {
    
    
    func chooseType() {
        let alert = UIAlertController(title: "", message: "Select Mode", preferredStyle: UIAlertController.Style.actionSheet)
        alert.view.tintColor = UIColor(displayP3Red: 49/255.0, green: 128/255.0, blue: 152/255.0, alpha: 1.0)
        
        let deletbutton =  UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive, handler: {(action) in
            // self.Profileimage.image = #imageLiteral(resourceName: "customer.png")
            
        })
        // add the actions (buttons)
        let takephoto =  UIAlertAction(title: "Take Photo", style: UIAlertAction.Style.default, handler: {(action) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePicker.delegate = self
                self.imagePicker.allowsEditing = false
                self.imagePicker.sourceType = UIImagePickerController.SourceType.camera
                self.imagePicker.cameraCaptureMode = .photo
                self.imagePicker.modalPresentationStyle = .fullScreen
                self.present(self.imagePicker,animated: true,completion: nil)
              //  UIApplication.topViewController()?.present(self.imagePicker,animated: true,completion: nil)
            } else {
                self.noCamera()
            }
            
            
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        let uploadphoto = UIAlertAction(title: "Upload Photo", style: UIAlertAction.Style.default, handler: {(action) in
            self.imagePicker.delegate = self
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
          //  UIApplication.topViewController()?.present(self.imagePicker, animated: true, completion: nil)
            
            
        })
        
        alert.addAction(takephoto)
        alert.addAction(uploadphoto)
        //  alert.addAction(deletbutton)
        // show the alert
        self.present(alert, animated: true, completion: nil)
      //  UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
    }
    
    func clickFunction() {
        
        let importMenu = UIDocumentMenuViewController(documentTypes: ["public.text", "com.apple.iwork.pages.pages", "public.data"], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        self.present(importMenu, animated: true, completion: nil)
       // UIApplication.topViewController()?.present(importMenu, animated: true, completion: nil)
    }
    
    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        self.present(
            alertVC,
            animated: true,
            completion: nil)
//        UIApplication.topViewController()?.present(
//            alertVC,
//            animated: true,
//            completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        print("import result : \(myURL)")
        let fileUrlkk = Foundation.URL(string: myURL.absoluteString)
        do {
            let data = try Data(contentsOf: fileUrlkk!)
            let imageSize: Int = data.count
            if Double(imageSize) / 1000000.0 < 25.0 {
                self.uploadFileAPI(data, fileNamee: myURL.lastPathComponent)
            }
        } catch {
            
        }
        
    }
    
    func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .fullScreen
        self.present(documentPicker, animated: true, completion: nil)
       // UIApplication.topViewController()?.present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        //UIApplication.topViewController()?.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        let imageData = chosenImage.jpegData(compressionQuality: 0.5)
        self.dismiss(animated: true, completion: nil)
     //   UIApplication.topViewController()?.dismiss(animated: true, completion: nil)
        
        self.requestNativeImageUpload(image: chosenImage)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
       // UIApplication.topViewController()?.dismiss(animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    func uploadFileAPI(_ imageData: Data, fileNamee: String) {
        let params = ["file": ""] as Dictionary<String, AnyObject>
//        showProgressOnView(self.view)
        showProgressOnView(appDelegateInstance.window!)
        ImageUploadServerClass.sharedInstance.multipartPostRequestHandler("https://admin.teamplayerhr.com/api/user/upload", mimeType: "", fileName: fileNamee, params: params, fileData: imageData) { ( response: AnyObject?, error:NSError?, httpStatusCode:Int?) in
            //hideAllProgressOnView(self.view)
            hideProgressOnView(appDelegateInstance.window!)
            DispatchQueue.main.async(execute: {
                if error == nil && response != nil && response is NSDictionary && httpStatusCode == 200 {
                    let respDic = response as! NSDictionary
                    print(respDic)
                    self.uplaodedCv = respDic.value(forKey: "file") as! String
                    
                    
                }
            })
        }
    }
    
}

extension ResumeVC {
    func requestNativeImageUpload(image: UIImage) {
        showProgressOnView(appDelegateInstance.window!)
        guard let url = NSURL(string: "https://admin.teamplayerhr.com/api/user/upload") else { return }
        let boundary = generateBoundary()
        var request = URLRequest(url: url as URL)
        
        let parameters = ["file": ""]
        
        guard let mediaImage = Media(withImage: image, forKey: "file") else { return }
        
        request.httpMethod = "POST"
        
        request.allHTTPHeaderFields = [
            "X-User-Agent": "ios",
            "Accept-Language": "en",
            "Accept": "application/json",
            "Content-Type": "multipart/form-data; boundary=\(boundary)",
            "ApiKey": ""
        ]
        
        let dataBody = createDataBody(withParameters: parameters, media: [mediaImage], boundary: boundary)
        request.httpBody = dataBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
                DispatchQueue.main.async {
                    hideAllProgressOnView(appDelegateInstance.window!)
                }
            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    let jsonDic = json as! NSDictionary
                    print(jsonDic)
                    let data = jsonDic.value(forKey: "data") as! NSDictionary
                    self.uplaodedCv = data.value(forKey: "filename") as! String
                    
                } catch {
                    DispatchQueue.main.async {
                        hideAllProgressOnView(appDelegateInstance.window!)
                    }
                    print(error)
                }
            }
        }.resume()
    }
    
    
    func generateBoundary() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    func createDataBody(withParameters params: [String: String]?, media: [Media]?, boundary: String) -> Data {
        
        let lineBreak = "\r\n"
        var body = Data()
        
        if let parameters = params {
            for (key, value) in parameters {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\(value + lineBreak)")
            }
        }
        
        if let media = media {
            for photo in media {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.fileName)\"\(lineBreak)")
                body.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)")
                body.append(photo.data)
                body.append(lineBreak)
            }
        }
        
        body.append("--\(boundary)--\(lineBreak)")
        
        return body
    }
    
    
    struct Media {
        let key: String
        let fileName: String
        let data: Data
        let mimeType: String
        
        init?(withImage image: UIImage, forKey key: String) {
            self.key = key
            self.mimeType = "image/jpg"
            self.fileName = "\(arc4random()).jpeg"
            
            guard let data = image.jpegData(compressionQuality: 0.5) else { return nil }
            self.data = data
        }
    }
}
