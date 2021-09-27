//
//  ManageTeamVC.swift
//  TeamPlayer
//
//  Created by Ritesh Sinha on 05/08/21.
//

import UIKit

class ManageTeamVC: UIViewController {
    
    @IBOutlet weak var groupListTableView: UITableView!
    
    @IBOutlet weak var participantTableView: UITableView!
    @IBOutlet weak var benchmarkTableView: UITableView!
    @IBOutlet weak var benchmarkListEmptyView: UIView!
    @IBOutlet weak var groupListEmptyView: UIView!
    @IBOutlet weak var participantEmptyView: UIView!
    
    var teamParticipantObj = inviteTeamStruct()
    var teamUserListArr = [teamUserListStruct]()
    var teamBenchmarkListArr = [teamUserListStruct]()
    var teamParticipantArr = [teamUserListStruct]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showAndHideEmptyViews()
        self.categorizeUserTypes()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func showAndHideEmptyViews() {
        if self.teamUserListArr.count > 0 {
            self.groupListEmptyView.isHidden = true
        } else {
            self.groupListEmptyView.isHidden = false
        }
        
        if self.teamBenchmarkListArr.count > 0 {
            self.benchmarkListEmptyView.isHidden = true
        } else {
            self.benchmarkListEmptyView.isHidden = false
        }
        
        if self.teamParticipantArr.count > 0 {
            self.participantEmptyView.isHidden = true
        } else {
            self.participantEmptyView.isHidden = false
        }
    }
    
    func categorizeUserTypes() {
        let userListArr = self.teamParticipantObj.userList
        for items in userListArr {
            let item = items
            if item.user_type == "benchmark" {
                self.teamBenchmarkListArr.append(item)
            } else if item.user_type == "participant" {
                self.teamParticipantArr.append(item)
            } else {
                self.teamUserListArr.append(item)
            }
        }
        self.benchmarkTableView.reloadData()
        self.groupListTableView.reloadData()
        self.participantTableView.reloadData()
        self.showAndHideEmptyViews()
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func notificationAction(_ sender: Any) {
    }
    
    @IBAction func benchmarkBtnAction(_ sender: Any) {
        let indexPath: IndexPath? = groupListTableView.indexPathForRow(at: (sender as AnyObject).convert(CGPoint.zero, to: groupListTableView))
        let teamUSerListObj = self.teamUserListArr[indexPath!.row]
        self.changeUserStateApi("benchmark", id: teamUSerListObj.id, teamListObj: teamUSerListObj)
        
        self.teamUserListArr.remove(at: indexPath!.row)
        //        self.benchmarkTableView.reloadData()
        //        self.groupListTableView.reloadData()
        //        self.showAndHideEmptyViews()
    }
    
    @IBAction func participantBtnAction(_ sender: Any) {
        let indexPath: IndexPath? = groupListTableView.indexPathForRow(at: (sender as AnyObject).convert(CGPoint.zero, to: groupListTableView))
        let teamUSerListObj = self.teamUserListArr[indexPath!.row]
        self.changeUserStateApi("participant", id: teamUSerListObj.id, teamListObj: teamUSerListObj)
        
        self.teamUserListArr.remove(at: indexPath!.row)
        //        self.groupListTableView.reloadData()
        //        self.participantTableView.reloadData()
        //        self.showAndHideEmptyViews()
    }
    
    
    
    @IBAction func participantDelBtnAction(_ sender: UIButton) {
        if sender.tag == 101 {
            let indexPath: IndexPath? = benchmarkTableView.indexPathForRow(at: (sender as AnyObject).convert(CGPoint.zero, to: benchmarkTableView))
            let teamUSerListObj = self.teamBenchmarkListArr[indexPath!.row]
            self.teamBenchmarkListArr.remove(at: indexPath!.row)
            self.changeUserStateApi("", id: teamUSerListObj.id, teamListObj: teamUSerListObj)
        } else {
            let indexPath: IndexPath? = participantTableView.indexPathForRow(at: (sender as AnyObject).convert(CGPoint.zero, to: participantTableView))
            let teamUSerListObj = self.teamParticipantArr[indexPath!.row]
            self.teamParticipantArr.remove(at: indexPath!.row)
            self.changeUserStateApi("", id: teamUSerListObj.id, teamListObj: teamUSerListObj)
        }
        
        
    }
    
    @IBAction func benchmarkDelBtnAction(_ sender: UIButton) {
    }
    
    func changeUserStateApi(_ state: String, id: String, teamListObj: teamUserListStruct) {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let apiUrl =  BASE_URL + PROJECT_URL.CHANGE_USER_TYPE
            
            let url : NSString = apiUrl as NSString
            let urlStr : NSString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! as NSString
            
            
            //            let param:[String:Any] = {"id":"2","user_type":"benchmark"}
            let param:[String:Any] = ["id":id,"user_type":state]
            ServerClass.sharedInstance.putRequestWithUrlParameters(param, path: urlStr as String, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                
                if success == "true"
                {
                    if json["data"]["user_type"].stringValue == "benchmark" {
                        self.teamBenchmarkListArr.append(teamListObj)
                    } else if json["data"]["user_type"].stringValue == "participant" {
                        self.teamParticipantArr.append(teamListObj)
                    } else {
                        self.teamUserListArr.append(teamListObj)
                    }
                    
                    DispatchQueue.main.async {
                        self.benchmarkTableView.reloadData()
                        self.groupListTableView.reloadData()
                        self.participantTableView.reloadData()
                        self.showAndHideEmptyViews()
                        //self.categorizeUserTypes()
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
    
//    func getReportAPI(_ user_type: String, group_id: String, user_id: String, subgroup_id: String) {
//
//        if Reachability.isConnectedToNetwork() {
//            showProgressOnView(appDelegateInstance.window!)
//
//            let url = "https://dev.teamplayerhr.com/app-survey-result-team?group_id=\(group_id)&user_id=\(user_id)&subgroup_id=\(subgroup_id)&user_type=\(user_type)&token=Bearer \(String(describing: UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.VENDOR_SIGNUP_TOKEN)))"
//            let param:[String:String] = [:]
//            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: url, successBlock: { (json) in
//                print(json)
//                hideAllProgressOnView(appDelegateInstance.window!)
//                let success = json["success"].stringValue
//                if success == "true"
//                {
//
//
//
//                }
//                else {
//                    self.view.makeToast(json["message"].stringValue)
//                    // UIAlertController.showInfoAlertWithTitle("Message", message: json["message"].stringValue, buttonTitle: "Okay")
//                }
//            }, errorBlock: { (NSError) in
//                UIAlertController.showInfoAlertWithTitle("Alert", message: kUnexpectedErrorAlertString, buttonTitle: "Okay")
//                hideAllProgressOnView(appDelegateInstance.window!)
//            })
//
//        }else{
//            hideAllProgressOnView(appDelegateInstance.window!)
//            UIAlertController.showInfoAlertWithTitle("Alert", message: "Please Check internet connection", buttonTitle: "Okay")
//        }
//    }
    
    func getReportAPI(_ user_type: String, group_id: String, user_id: String, subgroup_id: String) {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = [:]
            let url = "https://dev.teamplayerhr.com/app-survey-result-team?group_id=\(group_id)&user_id=\(user_id)&subgroup_id=\(subgroup_id)&user_type=\(user_type)&token=\(UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.VENDOR_SIGNUP_TOKEN)!)"
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: url, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                //success == "true"
                if success == "true"
                {
                    
                    
                    
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

extension ManageTeamVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == groupListTableView {
            return self.teamUserListArr.count
        } else if tableView == benchmarkTableView {
            return self.teamBenchmarkListArr.count
        } else {
            return self.teamParticipantArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == groupListTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GroupListCell", for: indexPath) as! GroupListCell
            
            let userListObj = self.teamUserListArr[indexPath.row]
            cell.cellLbl.text = "Name: \(userListObj.user_name)"
            
            return cell
        } else if tableView == benchmarkTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BenchmarkListCell", for: indexPath) as! BenchmarkListCell
            
            let userListObj = self.teamBenchmarkListArr[indexPath.row]
            cell.cellLbl.text = "Name: \(userListObj.user_name)"
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ParticipantListCell", for: indexPath) as! ParticipantListCell
            
            let userListObj = self.teamParticipantArr[indexPath.row]
            cell.cellLbl.text = "Name: \(userListObj.user_name)"
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == benchmarkTableView {
            let benhcmarkListObj = self.teamBenchmarkListArr[indexPath.row]
//            self.getReportAPI("benchmark", group_id: benhcmarkListObj.group_id, user_id: benhcmarkListObj.user_id, subgroup_id: benhcmarkListObj.subgroup_id)
            let reportUrl = "https://dev.teamplayerhr.com/app-survey-result-team?group_id=\(benhcmarkListObj.group_id)&user_id=\(benhcmarkListObj.user_id)&subgroup_id=\(benhcmarkListObj.subgroup_id)&user_type=benchmark&token=\(UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.VENDOR_SIGNUP_TOKEN)!)"
            
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ViewReportVC") as! ViewReportVC
            vc.urlStr = reportUrl
//            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
            
        } else if tableView == participantTableView {
            let participantListObj = self.teamParticipantArr[indexPath.row]
           // self.getReportAPI("participant", group_id: participantListObj.group_id, user_id: participantListObj.user_id, subgroup_id: participantListObj.subgroup_id)
            let reportUrl = "https://dev.teamplayerhr.com/app-survey-result-team?group_id=\(participantListObj.group_id)&user_id=\(participantListObj.user_id)&subgroup_id=\(participantListObj.subgroup_id)&user_type=benchmark&token=\(UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.VENDOR_SIGNUP_TOKEN)!)"
            
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ViewReportVC") as! ViewReportVC
            vc.urlStr = reportUrl
//            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    
}
