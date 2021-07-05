//
//  UpdateProfileVC.swift
//  TeamPlayer
//
//  Created by Ritesh Sinha on 01/07/21.
//

import UIKit

class UpdateProfileVC: UIViewController, UITextFieldDelegate, UIPickerViewDelegate {

    @IBOutlet weak var occupationView: UIView!
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var lastNameView: UIView!
    @IBOutlet weak var firstNameView: UIView!
    
    @IBOutlet weak var firstNameTxt: UITextField!
    @IBOutlet weak var lastNameTxt: UITextField!
    @IBOutlet weak var phoneTxt: UITextField!
    @IBOutlet weak var occupationTxt: UITextField!
    
    var occupationList = [countryStruct]()
    var picker = UIPickerView()
    var toolBar = UIToolbar()
    var pikerDic = countryStruct()
    var occupationId = 0
    
    var profileDic = profileStruct()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setData()
        self.setdashedView()
        self.getOccupationList()
        
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
        
        self.occupationTxt.delegate = self
        self.occupationTxt.inputView = picker
        self.occupationTxt.inputAccessoryView = toolBar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    func setData() {
        self.firstNameTxt.text = self.profileDic.first_name
        self.lastNameTxt.text = self.profileDic.last_name
        self.phoneTxt.text = self.profileDic.phone
        self.occupationTxt.text = self.profileDic.profession
        self.occupationId = self.profileDic.professionId
    }
    
    func setdashedView() {
        self.firstNameView.addLineDashedStroke(pattern: [2, 2], radius: 4, color: UIColor.gray.cgColor)
        self.lastNameView.addLineDashedStroke(pattern: [2, 2], radius: 4, color: UIColor.gray.cgColor)
        self.phoneView.addLineDashedStroke(pattern: [2, 2], radius: 4, color: UIColor.gray.cgColor)
        self.occupationView.addLineDashedStroke(pattern: [2, 2], radius: 4, color: UIColor.gray.cgColor)
    }
    
    @objc func donePicker() {
        
        self.view.endEditing(true)
        
        self.occupationTxt.text = pikerDic.title
        self.occupationId = pikerDic.id
        
    }
    
    @objc func cancelPicker() {
        self.view.endEditing(true)
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
    
    @IBAction func saveAction(_ sender: Any) {
        self.view.makeToast("Under Development.")
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func notificationAction(_ sender: Any) {
    }
    
    
    
}

extension UpdateProfileVC : UIDocumentPickerDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return self.occupationList.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        pikerDic = self.occupationList[row]
        return pikerDic.title
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        pikerDic = self.occupationList[row]
        
    }
}
