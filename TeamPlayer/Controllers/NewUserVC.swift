//
//  NewUserVC.swift
//  TeamPlayer
//
//  Created by Ritesh Sinha on 28/06/21.
//

import UIKit

class NewUserVC: UIViewController, UIPickerViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var fullNameTxt: UITextField!
    @IBOutlet weak var titleTxt: UITextField!
    
    @IBOutlet weak var roasTxt: UITextField!
    @IBOutlet weak var hNoTxt: UITextField!
    @IBOutlet weak var phoneTxt: UITextField!
    
    @IBOutlet weak var sectorTxt: UITextField!
    @IBOutlet weak var occupationTxt: UITextField!
    @IBOutlet weak var countryTxt: UITextField!
    @IBOutlet weak var stateTxt: UITextField!
    @IBOutlet weak var cityTxt: UITextField!
    @IBOutlet weak var zipTxt: UITextField!
    
    @IBOutlet weak var imTxt: UITextField!
    @IBOutlet weak var confirmPasswordTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    
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
    var pikerDic = countryStruct()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @objc func donePicker() {
        
        self.view.endEditing(true)
        
        if self.userSelection == "Country" {
            self.countryTxt.text = pikerDic.title
            self.stateTxt.text = ""
            self.cityTxt.text = ""
            self.stateId = 0
            self.getStateList()
        } else if self.userSelection == "Sector" {
            self.sectorTxt.text = pikerDic.title
        } else if self.userSelection == "Occupation" {
            self.occupationTxt.text = pikerDic.title
        } else if self.userSelection == "State" {
            self.stateTxt.text = pikerDic.title
            self.getCityList()
        } else {
            self.cityTxt.text = pikerDic.title
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
    }
    
    @IBAction func submitAction(_ sender: Any) {
    }
    
    @IBAction func onTapSignIn(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SigninVC") as! SigninVC
        self.navigationController?.pushViewController(vc, animated: true)
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

