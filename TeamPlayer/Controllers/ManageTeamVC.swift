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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func notificationAction(_ sender: Any) {
    }
    
    @IBAction func benchmarkBtnAction(_ sender: Any) {
    }
    
    @IBAction func participantBtnAction(_ sender: Any) {
    }
    
}
