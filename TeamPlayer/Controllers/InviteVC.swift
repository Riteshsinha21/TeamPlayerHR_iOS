//
//  InviteVC.swift
//  TeamPlayer
//
//  Created by Ritesh Sinha on 28/07/21.
//

import UIKit
import AVFoundation

class InviteVC: UIViewController {
    
    @IBOutlet weak var inviteMailTxt: UITextField!
    @IBOutlet weak var teamNameTxt: UITextField!
    @IBOutlet weak var participantTableView: UITableView!
    @IBOutlet weak var remainingQuestionaireLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dashedView1: DashedView!
    @IBOutlet weak var dashedView: DashedView!
    
    var groupId = ""
    var participantArr = [inviteParticipantStruct]()
    var teamsArr = [inviteTeamStruct]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.delegate = nil
        self.tableView.dataSource = nil
        self.participantTableView.dataSource = nil
        self.participantTableView.delegate = nil
        self.dashedView.addLineDashedStroke(pattern: [2, 2], radius: 4, color: UIColor.gray.cgColor)
        self.dashedView1.addLineDashedStroke(pattern: [2, 2], radius: 4, color: UIColor.gray.cgColor)
        self.getGroupDetail()
        self.getTeamAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func createAction(_ sender: Any) {
        if self.teamNameTxt.text!.isEmpty {
            self.view.makeToast("Please enter Team Name.")
            return
        }
        self.createTeamAPI()
    }
    
    @IBAction func inviteAction(_ sender: Any) {
        if self.inviteMailTxt.text!.isEmpty {
            self.view.makeToast("Please enter Email Id.")
            return
        }
        self.sendInvitationAPI()
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func paticipantCellBtnAction(_ sender: UIButton) {
        if sender.titleLabel?.text == "Add" {
            self.openTeamActionSheet()
        } else {
            let indexPath: IndexPath? = participantTableView.indexPathForRow(at: sender.convert(CGPoint.zero, to: participantTableView))
            let participantObj = self.participantArr[indexPath!.row]
        }
        
    }
    
    func getGroupDetail() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = [:]
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.GET_GROUP_DETAIL + "\(self.groupId)", successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                //success == "true"
                if success == "true"
                {
                    self.participantArr.removeAll()
                    for i in 0..<json["data"]["survey_participants"].count {
                        let id =  json["data"]["survey_participants"][i]["id"].stringValue
                        let user_name =  json["data"]["survey_participants"][i]["user_name"].stringValue
                        let survey_progress =  json["data"]["survey_participants"][i]["survey_progress"].boolValue
                        
                        self.participantArr.append(inviteParticipantStruct.init(id: id, user_name: user_name, survey_progress: survey_progress))
                     }

                    DispatchQueue.main.async {
                        if self.participantArr.count > 0 {
                            self.participantTableView.dataSource = self
                            self.participantTableView.delegate = self
                            self.participantTableView.reloadData()
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
    
    func getTeamAPI() {
        
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = ["group_id": self.groupId]
            ServerClass.sharedInstance.postRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.GET_TEAMS, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    self.teamsArr.removeAll()
                    for i in 0..<json["data"].count {
                        let id =  json["data"][i]["id"].stringValue
                        let name =  json["data"][i]["name"].stringValue
                        
                        
                        self.teamsArr.append(inviteTeamStruct.init(id: id, name: name))
                     }

                    DispatchQueue.main.async {
                        if self.teamsArr.count > 0 {
                            self.tableView.dataSource = self
                            self.tableView.delegate = self
                            self.tableView.reloadData()
                        }
                    }
                    
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
    
    func sendInvitationAPI() {
        
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = ["group_id": self.groupId, "email": self.inviteMailTxt.text!]
            ServerClass.sharedInstance.postRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.SEND_INVITATION, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    self.view.makeToast(json["message"].stringValue)
                    self.inviteMailTxt.text = ""
                    
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
    
    
    func createTeamAPI() {
        
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = ["group_id": self.groupId, "name": self.teamNameTxt.text!]
            ServerClass.sharedInstance.postRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.CREATE_TEAM, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    self.view.makeToast(json["message"].stringValue)
                    self.teamNameTxt.text = ""
                    self.getTeamAPI()
                    
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
    
    func addToTeamAPI(_ name: String) {
        
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = ["group_id": self.groupId, "name": name]
            ServerClass.sharedInstance.postRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.ADD_TO_TEAM, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    self.view.makeToast(json["message"].stringValue)
                    
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
    
    func openTeamActionSheet() {
        
        let alertController = UIAlertController(title: "Team", message: "Select Team", preferredStyle: .actionSheet)
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        for item in self.teamsArr{
            let classButton = UIAlertAction(title: item.name , style: .default, handler: { (action) in
                
                self.addToTeamAPI(item.name)
            })
            
            alertController.addAction(classButton)
        }
        alertController.addAction(cancelButton)
        self.present(alertController, animated: true, completion: nil)
        
    }
    

}

extension InviteVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == participantTableView {
            return self.participantArr.count
        } else {
            return self.teamsArr.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == participantTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InviteParticipantCell", for: indexPath) as! InviteParticipantCell
            
            let groupListObj = self.participantArr[indexPath.row]
            cell.cellNameLbl.text = "Name: \(groupListObj.user_name)"
            cell.cellStatusLbl.text = "Status: \(groupListObj.survey_progress ? "Complete" : "Pending")"
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InviteParticipantCell", for: indexPath) as! InviteParticipantCell
            
            let groupListObj = self.teamsArr[indexPath.row]
            cell.cellNameLbl.text = "Team Name: \(groupListObj.name)"
            //cell.cellStatusLbl.text = "Participants: \(groupListObj.survey_progress ? "Complete" : "Pending")"
            
            return cell
        }
    }
    
    
}
