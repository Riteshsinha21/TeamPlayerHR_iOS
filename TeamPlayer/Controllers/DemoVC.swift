//
//  DemoVC.swift
//  TeamPlayer
//
//  Created by Ritesh Sinha on 29/06/21.
//

import UIKit

class DemoVC: UIViewController {

    @IBOutlet weak var fullNameView: UIView!
    @IBOutlet weak var companyNameView: UIView!
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var mailVIew: UIView!
    
    @IBOutlet weak var mailTxt: UITextField!
    @IBOutlet weak var phoneTxt: UITextField!
    @IBOutlet weak var companyNameTxt: UITextField!
    @IBOutlet weak var fullNameTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setDashedBorder()
    }
    
    func setDashedBorder() {
        self.fullNameView.addLineDashedStroke(pattern: [2, 2], radius: 4, color: UIColor.gray.cgColor)
        self.companyNameView.addLineDashedStroke(pattern: [2, 2], radius: 4, color: UIColor.gray.cgColor)
        self.phoneView.addLineDashedStroke(pattern: [2, 2], radius: 4, color: UIColor.gray.cgColor)
        self.mailVIew.addLineDashedStroke(pattern: [2, 2], radius: 4, color: UIColor.gray.cgColor)
    }
    
    @IBAction func acceptBtnAction(_ sender: UIButton) {
        if sender.currentImage == UIImage.init(named: "uncheck") {
            sender.setImage(UIImage.init(named: "checked"), for: .normal)
           // self.isTermsAgreed = true
        } else {
            sender.setImage(UIImage.init(named: "uncheck"), for: .normal)
            //self.isTermsAgreed = false
        }
    }
    
}
