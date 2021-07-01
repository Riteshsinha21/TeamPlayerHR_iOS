//
//  SigninVC.swift
//  TeamPlayer
//
//  Created by Ritesh Sinha on 28/06/21.
//

import UIKit

class SigninVC: UIViewController {
    
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var nameTxt: UITextField!
    
    @IBOutlet weak var mailView: DashedView!
    @IBOutlet weak var passwordView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.mailView.addLineDashedStroke(pattern: [2, 2], radius: 4, color: UIColor.gray.cgColor)
        self.passwordView.addLineDashedStroke(pattern: [2, 2], radius: 4, color: UIColor.gray.cgColor)
        self.loginView.roundRadius(options: [.layerMinXMinYCorner, .layerMaxXMinYCorner], cornerRadius: 30)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func showPasswordAction(_ sender: UIButton) {
        if sender.currentImage == UIImage.init(named: "password-hidden") {
            self.passwordTxt.isSecureTextEntry = false
            sender.setImage(UIImage.init(named: "password-show"), for: .normal)
        } else {
            sender.setImage(UIImage.init(named: "password-hidden"), for: .normal)
            self.passwordTxt.isSecureTextEntry = true
        }
    }
    
    @IBAction func loginAction(_ sender: Any) {
        if self.nameTxt.text!.isEmpty {
            self.view.makeToast("Please enter Name")
            return
        } else if self.passwordTxt.text!.isEmpty {
            self.view.makeToast("Please enter Password")
            return
        }
        
        self.loginApiCall()
        
    }
    
    @IBAction func forgotPasswordAction(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ForgotPasswordVCViewController") as! ForgotPasswordVCViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "NewUserVC") as! NewUserVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func skipAction(_ sender: Any) {
        isDemo = true
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "tabBarcontroller") as! UITabBarController
        UIApplication.shared.delegate!.window!!.rootViewController = viewController
    }
    
    func loginApiCall() {
        
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:Any] = [ "email": self.nameTxt.text!,"password":self.passwordTxt.text!]
            ServerClass.sharedInstance.postRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.LOGIN, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    //save data in userdefault..
                    
                    UserDefaults.standard.setValue(json["data"]["token"].stringValue, forKey: USER_DEFAULTS_KEYS.VENDOR_SIGNUP_TOKEN)
                    self.view.makeToast(json["message"].stringValue)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        
                        guard let window = UIApplication.shared.delegate?.window else {
                            return
                        }
                        
                        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "tabBarcontroller") as! UITabBarController
                        
                        window!.rootViewController = viewController
                        let options: UIView.AnimationOptions = .transitionCrossDissolve
                        let duration: TimeInterval = 0.5
                        UIView.transition(with: window!, duration: duration, options: options, animations: {}, completion:
                                            { completed in
                            window!.makeKeyAndVisible()
                        })
                    }
                    
                }
                else {
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
