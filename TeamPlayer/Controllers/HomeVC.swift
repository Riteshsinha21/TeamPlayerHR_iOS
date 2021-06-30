//
//  HomeVC.swift
//  TeamPlayer
//
//  Created by Ritesh Sinha on 29/06/21.
//

import UIKit
import SideMenu

class HomeVC: UIViewController {

    @IBOutlet weak var v1HeadingLbl: UILabel!
    @IBOutlet weak var v1ContentLbl: UILabel!
    @IBOutlet weak var v2HeadingLbl: UILabel!
    @IBOutlet weak var v2ContentLbl: UILabel!
    @IBOutlet weak var v3HeadingLbl: UILabel!
    @IBOutlet weak var v3ContentLbl: UILabel!
    @IBOutlet weak var v4HeadingLbl: UILabel!
    @IBOutlet weak var v4ContentLbl: UILabel!
    @IBOutlet weak var v5HeadingLbl: UILabel!
    @IBOutlet weak var lastViewContentLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.v1HeadingLbl.text = "• Employee Productivity"
        self.v1ContentLbl.text = "Decrease the 20% to 30% lost productivity that companies suffer due to unhappy and poorly engaged employees"
        self.v2HeadingLbl.text = "• Team Assignments"
        self.v2ContentLbl.text = "Savings of up to 20% when better aligned teams are operating on agile initiatives"
        self.v3HeadingLbl.text = "• Management Focus"
        self.v3ContentLbl.text = "Management Focus - A decrease of up to 20% of manager time focused on HR issues"
        self.v4HeadingLbl.text = "• Staff Hiring"
        self.v4ContentLbl.text = "Building Teams - An increase of up to 20% in employee productivity"
        self.v5HeadingLbl.text = "Augmenting Teams - Up to 30% reduction in the number and cost of bad hir"
        self.lastViewContentLbl.text = "TeamPlayerHR is not a psychometric test.\nTeamPlayerHR patented technology quickly assesses how individuals will interact with each other and tells its users whether individuals will work together effectively by assessing their cultural compatibility so they can create high performing teams."
        
    }
    
    @IBAction func onTapSideMenu(_ sender: Any) {
        
//        if isDemo {
//            let menu = storyboard!.instantiateViewController(withIdentifier: "EarlySideMenuVC") as! SideMenuNavigationController
//            var settings = SideMenuSettings()
//            settings.menuWidth = self.view.frame.width - 100
//            menu.settings = settings
//            present(menu, animated: true, completion: nil)
//
//        } else {
//
//            let menu = storyboard!.instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuNavigationController
//            var settings = SideMenuSettings()
//            settings.menuWidth = self.view.frame.width - 100
//            menu.settings = settings
//            present(menu, animated: true, completion: nil)
//        }
        
        let menu = storyboard!.instantiateViewController(withIdentifier: "EarlySideMenuVC") as! EarlySideMenuVC
        
        let vc = SideMenuNavigationController(rootViewController: menu)
        var settings = SideMenuSettings()
        settings.menuWidth = self.view.frame.width - 100
        vc.leftSide = true
        vc.settings = settings
        present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func onTapNotification(_ sender: Any) {
        
    }
    

}
