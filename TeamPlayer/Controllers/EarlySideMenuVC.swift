//
//  EarlySideMenuVC.swift
//  TeamPlayer
//
//  Created by Ritesh Sinha on 30/06/21.
//

import UIKit
import SideMenu

class EarlySideMenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var sideMenuArr = ["Home", "How it Works", "Vision and Technology", "Contact Us", "News", "FAQ's"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signInAction(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SigninVC") as! SigninVC
       // self.navigationController?.pushViewController(vc, animated: true)
        
        let menu = SideMenuNavigationController(rootViewController: vc)
        present(menu, animated: true, completion: nil)
        
    }
    
    @IBAction func signupAction(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "NewUserVC") as! NewUserVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sideMenuArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell", for: indexPath) as! SideMenuCell

        cell.cellLbl.text = self.sideMenuArr[indexPath.row]

        return cell
    }
    
}
