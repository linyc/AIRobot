//
//  Message.swift
//  AIRobot
//
//  Created by CY on 15/12/13.
//  Copyright © 2015年 LINYC. All rights reserved.
//

import Foundation

class Message: NSObject {
    let incoming:Bool
    let text:String
    let sentDate:NSDate
    var url:String?
    
    init(incoming:Bool, text:String, sentDate:NSDate){
        self.incoming = incoming
        self.text = text
        self.sentDate = sentDate
    }
    
}