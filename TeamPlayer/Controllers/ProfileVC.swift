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
                    
//                    self.cityList.removeAll()
//                    for i in 0..<json["data"].count
//                    {
//                        let title =  json["data"][i]["name"].stringValue
//                        let id =  json["data"][i]["id"].intValue
//
//                        self.cityList.append(countryStruct.init(title: title, id: id))
//                    }
//
//                    if self.cityList.count == 0 {
//                        self.cityTxt.isUserInteractionEnabled = false
//                    } else {
//                        self.cityTxt.isUserInteractionEnabled = true
//
//                    }
                    
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
    

}
