//
//  GroupVC.swift
//  TeamPlayer
//
//  Created by Ritesh Sinha on 29/07/21.
//

import UIKit

class GroupVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var inviteGroupArr = [inviteGroupStruct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.dataSource = nil
        self.tableView.delegate = nil
        self.tableView.tableFooterView = UIView()
        self.getGroupList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func menuAction(_ sender: Any) {
        openSideMenu()
    }
    
    func getGroupList() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = [:]
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.GET_GROUP_LIST, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                //success == "true"
                if success == "true"
                {
                    self.inviteGroupArr.removeAll()

                    for i in 0..<json["data"].count {
                        let id =  json["data"][i]["id"].stringValue
                        let name =  json["data"][i]["name"].stringValue
                        let max_size =  json["data"][i]["max_size"].stringValue
                        
                        self.inviteGroupArr.append(inviteGroupStruct.init(id: id, name: name, max_size: max_size))
                     }

                    DispatchQueue.main.async {
                        if self.inviteGroupArr.count > 0 {
                            
                            self.tableView.dataSource = self
                            self.tableView.delegate = self
                            self.tableView.reloadData()
                        }
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

extension GroupVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.inviteGroupArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! GroupCell
        
        let groupListObj = self.inviteGroupArr[indexPath.row]
        cell.cellLbl.text = "Manage \(groupListObj.name)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let groupListObj = self.inviteGroupArr[indexPath.row]
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InviteVC") as! InviteVC
        vc.groupId = groupListObj.id
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
