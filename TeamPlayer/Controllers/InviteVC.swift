//
//  InviteVC.swift
//  TeamPlayer
//
//  Created by Ritesh Sinha on 28/07/21.
//

import UIKit

class InviteVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dashedView1: DashedView!
    @IBOutlet weak var dashedView: DashedView!
    
    var groupId = ""
    var participantArr = [inviteParticipantStruct]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.delegate = nil
        self.tableView.dataSource = nil
        self.dashedView.addLineDashedStroke(pattern: [2, 2], radius: 4, color: UIColor.gray.cgColor)
        self.dashedView1.addLineDashedStroke(pattern: [2, 2], radius: 4, color: UIColor.gray.cgColor)
        self.getGroupDetail()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
    }
    

    @IBAction func cellShowAction(_ sender: Any) {
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
                    self.participantArr.append(inviteParticipantStruct.init(id: "id", user_name: "Team Name", max_size: "max_size"))
                    for i in 0..<json["data"]["survey_group"].count {
                        let id =  json["data"]["survey_group"][i]["id"].stringValue
                        let user_name =  json["data"]["survey_group"][i]["user_name"].stringValue
                        let max_size =  json["data"]["survey_group"][i]["max_size"].stringValue
                        
                        self.participantArr.append(inviteParticipantStruct.init(id: id, user_name: user_name, max_size: max_size))
                     }

                    DispatchQueue.main.async {
                        if self.participantArr.count > 0 {
//                            self.tableView.dataSource = self
//                            self.tableView.delegate = self
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

//extension InviteVC: UITableViewDelegate, UITableViewDataSource {
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        self.participantArr.count
//    }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
    
    
//}
