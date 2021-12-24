//
//  GroupVC.swift
//  TeamPlayer
//
//  Created by Ritesh Sinha on 29/07/21.
//

import UIKit

class GroupVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tblViewSubscription: UITableView!
    @IBOutlet weak var groupView: UIView!
    @IBOutlet weak var subscriptionView: UIView!
    
    var inviteGroupArr = [inviteGroupStruct]()
    var subscriptionListArr = [subscriptionListStruct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.dataSource = nil
        self.tableView.delegate = nil
        self.tableView.tableFooterView = UIView()
        self.tblViewSubscription.dataSource = nil
        self.tblViewSubscription.delegate = nil
        self.tblViewSubscription.tableFooterView = UIView()
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
                    if json["message"].stringValue == "Please subscribe to access app features." {
                        
                        self.getPlanAPI()
                                           
                    } else {
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
                                self.groupView.isHidden = false
                                self.subscriptionView.isHidden = true
                            }
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
    
    func getPlanAPI() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = [:]
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.GET_SUBSCRIPTION_PLAN, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                //success == "true"
                if success == "true"
                {
                    
                    self.subscriptionListArr.removeAll()
                    
                    for i in 0..<json["data"].count {
                        let frequency_type =  json["data"][i]["frequency_type"].stringValue
                        let title =  json["data"][i]["title"].stringValue
                        let amount =  json["data"][i]["amount"].stringValue
                        let duration =  json["data"][i]["duration"].stringValue
                        let detail =  json["data"][i]["detail"].stringValue
                        
                        self.subscriptionListArr.append(subscriptionListStruct.init(frequency_type: frequency_type, title: title, amount: amount, duration: duration, detail: detail))
                    }
                    
                    DispatchQueue.main.async {
                        if self.subscriptionListArr.count > 0 {
                            
                            self.tblViewSubscription.dataSource = self
                            self.tblViewSubscription.delegate = self
                            self.tblViewSubscription.reloadData()
                            self.groupView.isHidden = true
                            self.subscriptionView.isHidden = false
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
        if tableView == self.tableView{
            return self.inviteGroupArr.count
        }else{
            return self.subscriptionListArr.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! GroupCell
            
            let groupListObj = self.inviteGroupArr[indexPath.row]
            cell.cellLbl.text = "Manage \(groupListObj.name)"
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubscriptionCell", for: indexPath) as! SubscriptionCell
            
            let subscriptionListObj = self.subscriptionListArr[indexPath.row]
            cell.cellTitleLbl.text = subscriptionListObj.title
            cell.cellDetailLbl.text = subscriptionListObj.detail
            cell.cellDurationLbl.text = subscriptionListObj.duration
            cell.cellFrequencyLbl.text = subscriptionListObj.frequency_type
            cell.amountLbl.text = subscriptionListObj.amount
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == self.tableView{
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 60))
            headerView.backgroundColor = .white
            
            let headerLabel = UILabel(frame: CGRect(x: 10, y: 0, width: headerView.frame.width - 10, height: headerView.frame.height - 10))
            headerLabel.text = "Your Matches"

            headerLabel.font = UIFont(name: "Roboto-Bold", size: 18)
            headerView.addSubview(headerLabel)
            
            return headerView
        }else{
            return nil
        }
        

    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if tableView == self.tableView{
            let label = UILabel()
            label.numberOfLines = 0
            label.text = "Intrinsic Matrix – IM. When the TeamPlayerUK profile questionnaire is taken by participants, it establishes their Intrinsic Matrix - compatibility profile.  The “IM” acquires its value when compared to other members of current or planned teams. The results of these comparisons are used to match participants to the right employers/team leaders and current team members to help create the most compatible teams. The match is not skills or talent based, so, it accelerates hiring decisions, de-risks team building and helps improve productivity, reduces the costs of hiring new staff and minimizes hiring mistakes."
            label.textColor = .gray
            label.font = UIFont(name: "Roboto-Medium", size: 14)
            return label
        }else{
            
            return nil
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == self.tableView{
            return 40
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if tableView == self.tableView{
            return 40
        }else{
            return 0
        }
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tableView{
            let groupListObj = self.inviteGroupArr[indexPath.row]
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InviteVC") as! InviteVC
            vc.groupId = groupListObj.id
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}
