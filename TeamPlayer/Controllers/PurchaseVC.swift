//
//  PurchaseVC.swift
//  TeamPlayer
//
//  Created by Ritesh Sinha on 04/08/21.
//

import UIKit

class PurchaseVC: UIViewController {

    @IBOutlet weak var pptView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.pptView.addLineDashedStroke(pattern: [2, 2], radius: 4, color: UIColor.gray.cgColor)
    }
    
    @IBAction func sideMenuAction(_ sender: Any) {
        openSideMenu()
    }
    
    @IBAction func notificationAction(_ sender: Any) {
    }
    
}
