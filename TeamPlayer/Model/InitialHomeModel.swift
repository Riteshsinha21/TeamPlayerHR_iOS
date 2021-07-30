//
//  InitialHomeModel.swift
//  TeamPlayer
//
//  Created by Ritesh Sinha on 28/06/21.
//

import Foundation
import UIKit

struct countryStruct {
    var title:String = ""
    var id: Int = 0
}

struct profileStruct {
    var title:String = ""
    var first_name:String = ""
    var last_name:String = ""
    var phone:String = ""
    var email:String = ""
    var profession:String = ""
    var image:String = ""
    var imId:String = ""
    var professionId:Int = 0
}

struct demoQuestionStruct {
    var question:String = ""
    var maxanswers:String = ""
    var timelimit:String = ""
    var subpart:String = ""
    var answers = [demoAnswerStruct]()
    
}

struct demoAnswerStruct {
    var answerId:String = ""
    var sortorder:String = ""
    var image:String = ""
    var created_at:String = ""
    var answer:String = ""
    var questionid:String = ""
    var status:Bool = false
    var updated_at:String = ""
}

struct inviteGroupStruct {
    var id:String = ""
    var name:String = ""
    var max_size:String = ""
    
}

struct inviteParticipantStruct {
    var id:String = ""
    var user_name:String = ""
    var max_size:String = ""
    
}
