//
//  PurchasePlanVC.swift
//  TeamPlayer
//
//  Created by Ritesh Sinha on 23/12/21.
//

import UIKit

class PurchasePlanVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    
    var planArray: NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if UserDefaults.standard.object(forKey: USER_DEFAULTS_KEYS.USER_ROLE) as! String == "3" {
            self.planArray = ["App Questionaire Purchase", "App Subscription Purchase", "PPC Purchase", "Full Questionaire Purchase", "Subscription Purchase", "Renewal Purchase"]
        } else {
            self.planArray = ["App Questionaire Purchase"]
        }
    }
    
    @IBAction func menuAction(_ sender: Any) {
        openSideMenu()
    }
    
    

}

extension PurchasePlanVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.planArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PurchasePlanCell", for: indexPath) as! PurchasePlanCell
        cell.cellLbl.text = self.planArray[indexPath.row] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "SideMenu", bundle: nil).instantiateViewController(withIdentifier: "PurchaseHistoryVC") as! PurchaseHistoryVC
        vc.planType = self.planArray[indexPath.row] as! String
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
