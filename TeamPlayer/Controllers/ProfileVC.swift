//
//  ProfileVC.swift
//  TeamPlayer
//
//  Created by Ritesh Sinha on 30/06/21.
//

import UIKit
import SideMenu

class ProfileVC: UIViewController {

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
        self.getProfileApi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.navigationBar.isHidden = true
        
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
                    
                    
                    self.profileDic = profileStruct.init(title: title, first_name: firstName, last_name: lastName, phone: phone, email: email, profession: profession, image: image, imId: im, professionId: professionId)
                    
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
    }
    
    @IBAction func editProfileAction(_ sender: Any) {
        let vc = UIStoryboard(name: "SideMenu", bundle: nil).instantiateViewController(withIdentifier: "UpdateProfileVC") as! UpdateProfileVC
        vc.profileDic = self.profileDic
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}
