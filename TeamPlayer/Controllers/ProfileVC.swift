//
//  ProfileVC.swift
//  TeamPlayer
//
//  Created by Ritesh Sinha on 30/06/21.
//

import UIKit
import SideMenu
import SDWebImage

class ProfileVC: UIViewController {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var participantNameLbl: UILabel!
    @IBOutlet weak var imIdLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var professionLbl: UILabel!
    
    var profileDic = profileStruct()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.navigationBar.isHidden = true
        self.getProfileApi()
        
    }
    
    @IBAction func viewCvAction(_ sender: Any) {
        let reportUrl = FILE_BASE_URL + "/\(self.profileDic.cv)"
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ViewReportVC") as! ViewReportVC
        vc.urlStr = reportUrl
//            vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func menuAction(_ sender: Any) {
        openSideMenu()
    }
    
    func getProfileApi() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = [:]
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.PROFILE, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                //success == "true"
                if success == "true"
                {
                    
                    let title =  json["data"]["title"].stringValue
                    let firstName =  json["data"]["first_name"].stringValue
                    let lastName =  json["data"]["last_name"].stringValue
                    let image =  json["data"]["image"].stringValue
                    let phone =  json["data"]["phone"].stringValue
                    let email =  json["data"]["email"].stringValue
                    let profession =  json["data"]["occupation_data"]["name"].stringValue
                    let professionId =  json["data"]["occupation_data"]["id"].intValue
                    let im =  json["data"]["im"].stringValue
                    let address = json["data"]["address_line_1"].stringValue
                    let cv = json["data"]["cv"].stringValue
                    
                    self.profileDic = profileStruct.init(title: title, first_name: firstName, last_name: lastName, phone: phone, email: email, profession: profession, image: image, imId: im, professionId: professionId, address: address, cv: cv)
                    
                    DispatchQueue.main.async {
                        self.setData()
                    }
                    
                    
                } else {
                    UIAlertController.showInfoAlertWithTitle("Message", message: json["message"].stringValue, buttonTitle: "Okay")
                }
            }, errorBlock: { (NSError) in
                UIAlertController.showInfoAlertWithTitle("Alert", message: kUnexpectedErrorAlertString, buttonTitle: "Okay")
                hideAllProgressOnView(appDelegateInstance.window!)
            })
            
        }else{
            hideAllProgressOnView(appDelegateInstance.window!)
            UIAlertController.showInfoAlertWithTitle("Alert", message: "Please Check internet connection", buttonTitle: "Okay")
        }
    }
    
    func setData() {
        self.nameLbl.text = "\(self.profileDic.title) \(self.profileDic.first_name) \(self.profileDic.last_name)"
        self.participantNameLbl.text = "\(self.profileDic.title) \(self.profileDic.first_name) \(self.profileDic.last_name)"
        self.phoneLbl.text = self.profileDic.phone
        self.emailLbl.text = self.profileDic.email
        self.professionLbl.text = self.profileDic.profession
        self.imIdLbl.text = self.profileDic.imId
        self.profileImg.sd_setImage(with: URL(string: FILE_BASE_URL + "/\(self.profileDic.image)"), placeholderImage: UIImage(named: "profile"))
    }
    
    @IBAction func editProfileAction(_ sender: Any) {
        let vc = UIStoryboard(name: "SideMenu", bundle: nil).instantiateViewController(withIdentifier: "UpdateProfileVC") as! UpdateProfileVC
        vc.profileDic = self.profileDic
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}
