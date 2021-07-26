//
//  QuestionaireVC.swift
//  TeamPlayer
//
//  Created by Ritesh Sinha on 19/07/21.
//

import UIKit

class QuestionaireVC: UIViewController {
    
    @IBOutlet weak var quesLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var demoQuestionArr = [demoQuestionStruct]()
    var demoAnswersArr = [demoAnswerStruct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tableView.dataSource = nil
        self.tableView.delegate = nil
        self.getQuestionList()
        
    }
    
    @IBAction func menuAction(_ sender: Any) {
        openSideMenu()
    }
    
    @IBAction func notificationAction(_ sender: Any) {
    }
    
    func getQuestionList() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = [:]
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.GET_QUESTION_LIST, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                //success == "true"
                if success == "true"
                {
                    
                    self.demoQuestionArr.removeAll()
                    
                    for i in 0..<json["data"]["questions"].count {
                        let answerArr: [String] = []
                        let question =  json["data"]["questions"][i]["employerquestion"].stringValue
                        let answersList = json["data"]["questions"][i]["answers"].arrayValue
                        
                        self.demoAnswersArr.removeAll()
                        for j in 0..<json["data"]["questions"][i]["answers"].count {
                            let answer = json["data"]["questions"][i]["answers"][j]["answer"].stringValue
                            let answerId = json["data"]["questions"][i]["answers"][j]["answer_id"].stringValue
                            
                            self.demoAnswersArr.append(demoAnswerStruct.init(answerId: answerId, answer: answer))
                        }
                        
                        self.demoQuestionArr.append(demoQuestionStruct.init(question: question, answers: self.demoAnswersArr))
                    }
                    
                    DispatchQueue.main.async {
                        if self.demoQuestionArr.count > 0 {
                            
                            let answerObj = self.demoQuestionArr[0]
                            self.quesLbl.text = answerObj.question
                            
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

extension QuestionaireVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.demoQuestionArr[0].answers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RadioAnswerCell", for: indexPath) as! RadioAnswerCell
        
        let answerObj = self.demoQuestionArr[0].answers[indexPath.row]
        cell.cellLbl.text = answerObj.answer
        
        return cell
    }
    
    
}
