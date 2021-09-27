//
//  ShowInviteeVC.swift
//  TeamPlayer
//
//  Created by Ritesh Sinha on 13/09/21.
//

import UIKit

class ShowInviteeVC: UIViewController {

    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var id = ""
    var showInviteeListArr = [showInviteeListStruct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.delegate = nil
        self.tableView.dataSource = nil
        self.tableView.tableFooterView = UIImageView()
        self.getInviteeList()
    }
    
    func getInviteeList() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = [:]
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.SHOW_INVITEES + "?id=\(self.id)", successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                //success == "true"
                if success == "true"
                {
                    self.showInviteeListArr.removeAll()

                    for i in 0..<json["data"].count {
                        let id =  json["data"][i]["id"].stringValue
                        let email =  json["data"][i]["email"].stringValue
                        let on_date =  json["data"][i]["on_date"].stringValue
                        let group_id =  json["data"][i]["group_id"].stringValue
                        
                        self.showInviteeListArr.append(showInviteeListStruct.init(id: id, email: email, on_date: on_date, group_id: group_id))
                     }
//
                    DispatchQueue.main.async {
                        if self.showInviteeListArr.count > 0 {
                            self.emptyView.isHidden = true
                            self.tableView.delegate = self
                            self.tableView.dataSource = self
                            self.tableView.isHidden = false
                            self.tableView.reloadData()
                        } else {
                            self.emptyView.isHidden = false
                            self.tableView.isHidden = true
                        }
                    }
//                    
                    
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
    
    @IBAction func rsendInvitationAction(_ sender: UIButton) {
        let indexPath: IndexPath? = tableView.indexPathForRow(at: sender.convert(CGPoint.zero, to: tableView))
         let showInviteeObj = self.showInviteeListArr[indexPath!.row]
        self.sendInvitationAPI(showInviteeObj.group_id, email: showInviteeObj.email)
    }
    
    
    func sendInvitationAPI(_ group_id:String, email:String) {
        
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = ["group_id": group_id, "email": email]
            ServerClass.sharedInstance.postRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.SEND_INVITATION, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    self.view.makeToast(json["message"].stringValue)
                    
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
    
    @IBAction func deleteAction(_ sender: UIButton) {
    }
    
    

}

extension ShowInviteeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.showInviteeListArr.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShowInviteeListCell", for: indexPath) as! ShowInviteeListCell
        
        let showInviteeListObj = showInviteeListArr[indexPath.row]
        cell.cellNameLbl.text = showInviteeListObj.email
        cell.cellStatusLbl.text = showInviteeListObj.on_date
//
        return cell
    }
    
    
}
