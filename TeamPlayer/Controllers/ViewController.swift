//
//  ViewController.swift
//  TeamPlayer
//
//  Created by Ritesh Sinha on 27/06/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //newUserButton.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 17)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
    }

    @IBAction func onTapSignIn(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SigninVC") as! SigninVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func onTapNewUser(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "NewUserVC") as! NewUserVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func onTapDemoRequest(_ sender: Any) {
    }
}

