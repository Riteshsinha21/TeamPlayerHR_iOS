//
//  NewUserVC.swift
//  TeamPlayer
//
//  Created by Ritesh Sinha on 28/06/21.
//

import UIKit

class NewUserVC: UIViewController, UIPickerViewDelegate, UITextFieldDelegate {
    
    
    @IBOutlet weak var firstNameTxt: UITextField!
    @IBOutlet weak var lastNameTxt: UITextField!
    @IBOutlet weak var titleTxt: UITextField!
    @IBOutlet weak var phoneTxt: UITextField!
    @IBOutlet weak var addressTxt: UITextField!
    @IBOutlet weak var roadTxt: UITextField!
    @IBOutlet weak var organizationNameTxt: UITextField!
    @IBOutlet weak var roleTxt: UITextField!
    @IBOutlet weak var noOfEmployeesTxt: UITextField!
    @IBOutlet weak var countryTxt: UITextField!
    @IBOutlet weak var stateTxt: UITextField!
    @IBOutlet weak var cityTxt: UITextField!
    @IBOutlet weak var zipTxt: UITextField!
    @IBOutlet weak var sectorTxt: UITextField!
    @IBOutlet weak var occupationTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var confirmPasswordTxt: UITextField!
    @IBOutlet weak var imTxt: UITextField!
    
    @IBOutlet weak var roleTxtView: UIView!
    @IBOutlet weak var noOfEmployeesTxtView: UIView!
    @IBOutlet weak var occupationTxtView: UIView!
    
    @IBOutlet weak var agreeBtn: UIButton!
    
    @IBOutlet weak var signupView: UIView!
    @IBOutlet weak var stackView: UIView!
    @IBOutlet weak var organizationBtn: UIButton!
    @IBOutlet weak var participantBtn: UIButton!
    
    var countryList = [countryStruct]()
    var sectorList = [countryStruct]()
    var occupationList = [countryStruct]()
    var stateList = [countryStruct]()
    var cityList = [countryStruct]()
    var picker = UIPickerView()
    var toolBar = UIToolbar()
    var userSelection = ""
    var countryId = 0
    var stateId = 0
    var cityId = 0
    var sectorId = 0
    var occupationId = 0
    var isTermsAgreed = false
    
    var pikerDic = countryStruct()
    var imagePicker = UIImagePickerController()
    var uplaodedCv = ""
    var designation = ""
    var slot = ""
    var userType = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
       
        showParticipantView()
        self.userType = "ppt"
        self.signupView.roundRadius(options: [.layerMinXMinYCorner, .layerMaxXMinYCorner], cornerRadius: 30)
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 6/255, green: 159/255, blue: 190/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.cancelPicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        
        
        self.picker.delegate = self
        self.picker.dataSource = self
        
        self.countryTxt.delegate = self
        self.sectorTxt.delegate = self
        self.occupationTxt.delegate = self
        self.stateTxt.delegate = self
        self.cityTxt.delegate = self
        
        self.countryTxt.inputView = picker
        self.sectorTxt.inputView = picker
        self.occupationTxt.inputView = picker
        self.stateTxt.inputView = picker
        self.cityTxt.inputView = picker
        
        self.countryTxt.inputAccessoryView = toolBar
        self.sectorTxt.inputAccessoryView = toolBar
        self.occupationTxt.inputAccessoryView = toolBar
        self.stateTxt.inputAccessoryView = toolBar
        self.cityTxt.inputAccessoryView = toolBar
        
        self.getCountryList()
        self.getSectorList()
        self.getOccupationList()
        
        
    }
    
    private func showParticipantView(){
        DispatchQueue.main.async {
            self.organizationNameTxt.isHidden = true
            self.roleTxtView.isHidden = true
            self.noOfEmployeesTxtView.isHidden = true
            self.occupationTxtView.isHidden = false
            
            self.firstNameTxt.text = ""
            self.lastNameTxt.text = ""
            self.titleTxt.text = ""
            self.phoneTxt.text = ""
            self.addressTxt.text = ""
            self.roadTxt.text = ""
            self.organizationNameTxt.text = ""
            self.roleTxt.text = ""
            self.noOfEmployeesTxt.text = ""
            self.countryTxt.text = ""
            self.stateTxt.text = ""
            self.cityTxt.text = ""
            self.zipTxt.text = ""
            self.sectorTxt.text = ""
            self.occupationTxt.text = ""
            self.emailTxt.text = ""
            self.passwordTxt.text = ""
            self.confirmPasswordTxt.text = ""
            self.imTxt.text = ""
            
        }
        
    }
    
    private func showOrganizationView(){
        DispatchQueue.main.async {
            self.organizationNameTxt.isHidden = false
            self.roleTxtView.isHidden = false
            self.noOfEmployeesTxtView.isHidden = false
            self.occupationTxtView.isHidden = true
            
            
            self.firstNameTxt.text = ""
            self.lastNameTxt.text = ""
            self.titleTxt.text = ""
            self.phoneTxt.text = ""
            self.addressTxt.text = ""
            self.roadTxt.text = ""
            self.organizationNameTxt.text = ""
            self.roleTxt.text = ""
            self.noOfEmployeesTxt.text = ""
            self.countryTxt.text = ""
            self.stateTxt.text = ""
            self.cityTxt.text = ""
            self.zipTxt.text = ""
            self.sectorTxt.text = ""
            self.occupationTxt.text = ""
            self.emailTxt.text = ""
            self.passwordTxt.text = ""
            self.confirmPasswordTxt.text = ""
            self.imTxt.text = ""
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func roleAction(_ sender: Any) {
        let alert = UIAlertController(title: "Select Role", message: "", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "CEO", style: .default , handler:{ (UIAlertAction)in
            self.designation = "1"
            self.roleTxt.text = "CEO"
        }))
        
        alert.addAction(UIAlertAction(title: "HR Manager", style: .default , handler:{ (UIAlertAction)in
            self.designation = "2"
            self.roleTxt.text = "HR Manager"
        }))
        
        alert.addAction(UIAlertAction(title: "HR Consultant", style: .default , handler:{ (UIAlertAction)in
            self.designation = "3"
            self.roleTxt.text = "HR Consultant"
        }))
        
        alert.addAction(UIAlertAction(title: "HR Genralist", style: .default , handler:{ (UIAlertAction)in
            self.designation = "4"
            self.roleTxt.text = "HR Genralist"
        }))
        
        alert.addAction(UIAlertAction(title: "Leader", style: .default , handler:{ (UIAlertAction)in
            self.designation = "5"
            self.roleTxt.text = "Leader"
        }))
        
        alert.addAction(UIAlertAction(title: "Other", style: .default , handler:{ (UIAlertAction)in
            self.designation = "6"
            self.roleTxt.text = "Other"
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        
        //uncomment for iPad Support
        //alert.popoverPresentationController?.sourceView = self.view
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    
    @IBAction func employeesAction(_ sender: Any) {
        let alert = UIAlertController(title: "Number of Employees", message: "", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "1 - 20", style: .default , handler:{ (UIAlertAction)in
            self.slot = "1 - 20"
            self.noOfEmployeesTxt.text = "1-20"
        }))
        
        alert.addAction(UIAlertAction(title: "21 - 80", style: .default , handler:{ (UIAlertAction)in
            self.slot = "21 - 80"
            self.noOfEmployeesTxt.text = "21-80"
        }))
        
        alert.addAction(UIAlertAction(title: "81 - 500", style: .default , handler:{ (UIAlertAction)in
            self.slot = "81 - 500"
            self.noOfEmployeesTxt.text = "81-500"
        }))
        
        alert.addAction(UIAlertAction(title: "+500", style: .default , handler:{ (UIAlertAction)in
            self.slot = "+500"
            self.noOfEmployeesTxt.text = "+500"
        }))
        
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        
        //uncomment for iPad Support
        //alert.popoverPresentationController?.sourceView = self.view
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    @IBAction func signupTypeBtnActions(_ sender: UIButton) {
        if sender.tag == 101 {
            showParticipantView()
            self.userType = "ppt"
            self.participantBtn.backgroundColor = UIColor(red: 6/255.0, green: 159/255.0, blue: 190/255.0, alpha: 1)
            self.participantBtn.setTitleColor(UIColor.white, for: .normal)
            self.organizationBtn.backgroundColor = UIColor.lightGray
            self.organizationBtn.setTitleColor(UIColor.black, for: .normal)
        } else {
            showOrganizationView()
            self.userType = "org"
            self.organizationBtn.backgroundColor = UIColor(red: 6/255.0, green: 159/255.0, blue: 190/255.0, alpha: 1)
            self.organizationBtn.setTitleColor(UIColor.white, for: .normal)
            self.participantBtn.backgroundColor = UIColor.lightGray
            self.participantBtn.setTitleColor(UIColor.black, for: .normal)
        }
    }
    
    
    @objc func donePicker() {
        
        self.view.endEditing(true)
        
        if self.userSelection == "Country" {
            self.countryTxt.text = pikerDic.title
            self.stateTxt.text = ""
            self.cityTxt.text = ""
            self.stateId = 0
            self.cityId = 0
            self.getStateList()
        } else if self.userSelection == "Sector" {
            self.sectorTxt.text = pikerDic.title
            self.sectorId = pikerDic.id
        } else if self.userSelection == "Occupation" {
            self.occupationTxt.text = pikerDic.title
            self.occupationId = pikerDic.id
        } else if self.userSelection == "State" {
            self.stateTxt.text = pikerDic.title
            self.stateId = pikerDic.id
            self.getCityList()
        } else {
            self.cityTxt.text = pikerDic.title
            self.cityId = pikerDic.id
        }
        
    }
    
    @objc func cancelPicker() {
        self.view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.sectorTxt {
            
            self.userSelection = "Sector"
        } else if textField == self.countryTxt {
            
            self.userSelection = "Country"
        } else if textField == self.occupationTxt {
            
            self.userSelection = "Occupation"
        } else if textField == self.stateTxt {
            
            self.userSelection = "State"
        } else {
            self.userSelection = "City"
        }
    }
    
    @IBAction func onTapUploadResume(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Please select what would you like to upload?", message: "", preferredStyle: .actionSheet)
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
    
    
    
    @IBAction func submitAction(_ sender: Any) {
        
        if self.userType == "ppt" {
            if self.firstNameTxt.text!.isEmpty {
                self.view.makeToast("Please enter First Name.")
                return
            } else if self.lastNameTxt.text!.isEmpty {
                self.view.makeToast("Please enter Last Name.")
                return
            } else if self.titleTxt.text!.isEmpty {
                self.view.makeToast("Please enter Title.")
                return
            } else if self.phoneTxt.text!.isEmpty {
                self.view.makeToast("Please enter Phone No.")
                return
            } else if self.addressTxt.text!.isEmpty {
                self.view.makeToast("Please enter H.No,Plot Area")
                return
            } else if self.roadTxt.text!.isEmpty {
                self.view.makeToast("Please enter Road,Landmark.")
                return
            } else if self.sectorTxt.text!.isEmpty {
                self.view.makeToast("Please select Sector.")
                return
            } else if self.occupationTxt.text!.isEmpty {
                self.view.makeToast("Please select Occupation.")
                return
            } else if self.countryTxt.text!.isEmpty {
                self.view.makeToast("Please select Country.")
                return
            } else if self.stateTxt.text!.isEmpty {
                self.view.makeToast("Please select State.")
                return
            } else if self.cityTxt.text!.isEmpty {
                self.view.makeToast("Please select City.")
                return
            } else if self.zipTxt.text!.isEmpty {
                self.view.makeToast("Please enter Zip.")
                return
            } else if self.emailTxt.text!.isEmpty {
                self.view.makeToast("Please enter Email.")
                return
            } else if self.passwordTxt.text!.isEmpty {
                self.view.makeToast("Please enter Password.")
                return
            } else if self.confirmPasswordTxt.text!.isEmpty {
                self.view.makeToast("Please confirm your Password.")
                return
            } else if !self.isTermsAgreed {
                self.view.makeToast("Please check and agree Our Terms and Conditions.")
                return
            }
            
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ResumeVC") as! ResumeVC
            vc.completionHandlerCallback = {(cv: String?)->Void in
                self.uplaodedCv = cv!
                self.signupApiCall()
            }
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        } else {
            
            if self.firstNameTxt.text!.isEmpty {
                self.view.makeToast("Please enter First Name.")
                return
            } else if self.lastNameTxt.text!.isEmpty {
                self.view.makeToast("Please enter Last Name.")
                return
            } else if self.titleTxt.text!.isEmpty {
                self.view.makeToast("Please enter Title.")
                return
            } else if self.phoneTxt.text!.isEmpty {
                self.view.makeToast("Please enter Phone No.")
                return
            } else if self.addressTxt.text!.isEmpty {
                self.view.makeToast("Please enter H.No,Plot Area")
                return
            } else if self.roadTxt.text!.isEmpty {
                self.view.makeToast("Please enter Road,Landmark.")
                return
            } else if self.sectorTxt.text!.isEmpty {
                self.view.makeToast("Please select Sector.")
                return
            } else if self.organizationNameTxt.text!.isEmpty {
                self.view.makeToast("Please select Occupation.")
                return
            } else if self.countryTxt.text!.isEmpty {
                self.view.makeToast("Please select Country.")
                return
            } else if self.stateTxt.text!.isEmpty {
                self.view.makeToast("Please select State.")
                return
            } else if self.cityTxt.text!.isEmpty {
                self.view.makeToast("Please select City.")
                return
            } else if self.zipTxt.text!.isEmpty {
                self.view.makeToast("Please enter Zip.")
                return
            } else if self.emailTxt.text!.isEmpty {
                self.view.makeToast("Please enter Email.")
                return
            } else if self.passwordTxt.text!.isEmpty {
                self.view.makeToast("Please enter Password.")
                return
            } else if self.confirmPasswordTxt.text!.isEmpty {
                self.view.makeToast("Please confirm your Password.")
                return
            } else if !self.isTermsAgreed {
                self.view.makeToast("Please check and agree Our Terms and Conditions.")
                return
            } else if self.roleTxt.text!.isEmpty {
                self.view.makeToast("Please confirm your Password.")
                return
            } else if self.noOfEmployeesTxt.text!.isEmpty {
                self.view.makeToast("Please confirm your Password.")
                return
            }

            
            self.signupApiCall()
        }
        
        
    }
    
    @IBAction func onTapSignIn(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SigninVC") as! SigninVC
        vc.modalPresentationStyle = .fullScreen
        //self.navigationController?.pushViewController(vc, animated: true)
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func agreeBtnAction(_ sender: UIButton) {
        if sender.currentImage == UIImage.init(named: "uncheck") {
            sender.setImage(UIImage.init(named: "checked"), for: .normal)
            self.isTermsAgreed = true
        } else {
            sender.setImage(UIImage.init(named: "uncheck"), for: .normal)
            self.isTermsAgreed = false
        }
    }
    
    
    func getCountryList() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = [:]
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.GET_COUNTRIES, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                //success == "true"
                if success == "true"
                {
                    
                    
                    self.countryList.removeAll()
                    for i in 0..<json["data"].count
                    {
                        let title =  json["data"][i]["name"].stringValue
                        let id =  json["data"][i]["id"].intValue
                        
                        self.countryList.append(countryStruct.init(title: title, id: id))
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
    
    func getSectorList() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = [:]
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.GET_SECTOR, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                //success == "true"
                if success == "true"
                {
                    
                    
                    self.sectorList.removeAll()
                    for i in 0..<json["data"].count
                    {
                        let title =  json["data"][i]["name"].stringValue
                        let id =  json["data"][i]["id"].intValue
                        
                        self.sectorList.append(countryStruct.init(title: title, id: id))
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
    
    func getOccupationList() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = [:]
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.GET_OCCUPATION, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                //success == "true"
                if success == "true"
                {
                    
                    
                    self.occupationList.removeAll()
                    for i in 0..<json["data"].count
                    {
                        let title =  json["data"][i]["name"].stringValue
                        let id =  json["data"][i]["id"].intValue
                        
                        self.occupationList.append(countryStruct.init(title: title, id: id))
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
    
    func getStateList() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = [:]
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.GET_STATE + "?country_id=\(self.countryId)", successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                //success == "true"
                if success == "true"
                {
                    
                    self.stateList.removeAll()
                    for i in 0..<json["data"].count
                    {
                        let title =  json["data"][i]["name"].stringValue
                        let id =  json["data"][i]["id"].intValue
                        
                        self.stateList.append(countryStruct.init(title: title, id: id))
                    }
                    
                    if self.stateList.count == 0 {
                        self.stateTxt.isUserInteractionEnabled = false
                    } else {
                        self.stateTxt.isUserInteractionEnabled = true
                        
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
    
    func getCityList() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = [:]
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.GET_CITIES + "?state_id=\(self.stateId)", successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                //success == "true"
                if success == "true"
                {
                    
                    self.cityList.removeAll()
                    for i in 0..<json["data"].count
                    {
                        let title =  json["data"][i]["name"].stringValue
                        let id =  json["data"][i]["id"].intValue
                        
                        self.cityList.append(countryStruct.init(title: title, id: id))
                    }
                    
                    if self.cityList.count == 0 {
                        self.cityTxt.isUserInteractionEnabled = false
                    } else {
                        self.cityTxt.isUserInteractionEnabled = true
                        
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
    
    func signupApiCall() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            if let objFcmKey = UserDefaults.standard.object(forKey: "fcm_key") as? String
            {
                fcmKey = objFcmKey
            }
            else
            {
                //                fcmKey = ""
                fcmKey = "abcdef"
            }
            
            var param:[String:Any] = [:]
            var urlStr = ""
            
            if self.userType == "ppt" {
                urlStr = BASE_URL + PROJECT_URL.SIGNUP
                param = [ "email": self.emailTxt.text!,"title":self.titleTxt.text!,"phone":self.phoneTxt.text!, "cv": self.uplaodedCv,"address_line_1":self.addressTxt.text!,"address_line_2":self.roadTxt.text!,"sector":self.sectorId,"occupation":self.occupationId,"country":self.countryId,"city":self.cityId,"state":self.stateId,"zip":self.zipTxt.text!,"password":self.passwordTxt.text!,"confirm_password":self.confirmPasswordTxt.text!,"agreeTerms":self.isTermsAgreed,"agreePrivacy":self.isTermsAgreed, "first_name": self.firstNameTxt.text!, "last_name": self.lastNameTxt.text!]
            } else {
                urlStr = BASE_URL + PROJECT_URL.SIGNUP_COMPANY
                param = [ "email": self.emailTxt.text!,"title":self.titleTxt.text!,"phone":self.phoneTxt.text!,"address_line_1":self.addressTxt.text!,"address_line_2":self.roadTxt.text!,"sector":self.sectorId,"occupation":self.occupationId,"country":self.countryId,"city":self.cityId,"state":self.stateId,"zip":self.zipTxt.text!,"password":self.passwordTxt.text!,"confirm_password":self.confirmPasswordTxt.text!,"agreeTerms":self.isTermsAgreed,"agreePrivacy":self.isTermsAgreed, "first_name": self.firstNameTxt.text!, "last_name":self.lastNameTxt.text!,"user_role":self.designation,"no_of_employees":self.slot,"organization_name":self.organizationNameTxt.text!]

            }
                        
            ServerClass.sharedInstance.postRequestWithUrlParameters(param, path: urlStr, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    //save data in userdefault..
                    self.view.makeToast(json["message"].stringValue)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "SigninVC") as! SigninVC
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true, completion: nil)
                        
                    }
                }
                else {
                    self.view.makeToast(json["message"].stringValue)
                    // UIAlertController.showInfoAlertWithTitle("Message", message: json["message"].stringValue, buttonTitle: "Okay")
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

extension NewUserVC : UIDocumentPickerDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if userSelection == "Country" {
            return self.countryList.count
            
        } else if userSelection == "Sector" {
            return self.sectorList.count
            
        } else if userSelection == "Occupation" {
            return self.occupationList.count
            
        } else if userSelection == "State" {
            return self.stateList.count
        } else {
            return self.cityList.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //var pikerDic = countryStruct()
        if userSelection == "Country" {
            pikerDic = self.countryList[row]
        } else if userSelection == "Sector" {
            pikerDic = self.sectorList[row]
        } else if userSelection == "Occupation" {
            pikerDic = self.occupationList[row]
        } else if userSelection == "State" {
            pikerDic = self.stateList[row]
        } else {
            pikerDic = self.cityList[row]
        }
        
        return pikerDic.title
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if userSelection == "Country" {
            pikerDic = self.countryList[row]
            //  self.countryTxt.text = pikerDic.title
            self.countryId = pikerDic.id
        } else if userSelection == "Sector" {
            pikerDic = self.sectorList[row]
            // self.sectorTxt.text = pikerDic.title
        } else if userSelection == "Occupation" {
            pikerDic = self.occupationList[row]
            // self.occupationTxt.text = pikerDic.title
        } else if userSelection == "State" {
            pikerDic = self.stateList[row]
            //self.stateTxt.text = pikerDic.title
            self.stateId = pikerDic.id
        } else {
            pikerDic = self.cityList[row]
            //self.cityTxt.text = pikerDic.title
        }
        
    }
}

extension NewUserVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIDocumentMenuDelegate {
    
    
    func chooseType() {
        let alert = UIAlertController(title: "", message: "Select Mode", preferredStyle: UIAlertController.Style.actionSheet)
        
        
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

extension NewUserVC {
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

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

