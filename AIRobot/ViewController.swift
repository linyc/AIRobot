//
//  ViewController.swift
//  AIRobot
//
//  Created by yuecang on 15/12/7.
//  Copyright © 2015年 LINYC. All rights reserved.
//

import UIKit

let messageFontSize:CGFloat = 17
let toolBarMinHeight:CGFloat = 44


class ViewController: UITableViewController ,UITextViewDelegate{

var toolBar:UIToolbar!
var textView:UITextView!
var sendButton:UIButton!
    
    override var inputAccessoryView:UIView!{
        get{
            if toolBar == nil{
                toolBar = UIToolbar(frame: CGRectMake(0,0,UIScreen.mainScreen().bounds.size.width,toolBarMinHeight-0.5))
                
                textView = InputTextView(frame:CGRectMake(5, 5, 200, 30))
                textView.backgroundColor = UIColor(white: 250/255, alpha: 1)
                textView.delegate = self
                textView.font = UIFont.systemFontOfSize(messageFontSize)
                textView.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 205/255, alpha: 1).CGColor
                textView.layer.borderWidth = 0.5
                textView.layer.cornerRadius = 5
                textView.scrollsToTop = false
                textView.textContainerInset = UIEdgeInsetsMake(4, 3, 3, 3)
                toolBar.addSubview(textView)
                
                sendButton = UIButton(type: .System)
                sendButton.enabled = false
                sendButton.titleLabel?.font = UIFont.boldSystemFontOfSize(15)
                sendButton.setTitle("发送", forState: .Normal)
                sendButton.setTitleColor(UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1), forState: .Disabled)
                sendButton.setTitleColor(UIColor(red: 0.05, green: 0.47, blue: 0.91, alpha: 1.0), forState: .Normal)
                sendButton.contentEdgeInsets = UIEdgeInsetsMake(6, 6, 6, 6)
                sendButton.addTarget(self, action: "sendAction", forControlEvents: .TouchUpInside)
                toolBar.addSubview(sendButton)
                
                textView.translatesAutoresizingMaskIntoConstraints = false
                sendButton.translatesAutoresizingMaskIntoConstraints = false
                
                NSLayoutConstraint(item: textView, attribute: .Leading, relatedBy: .Equal, toItem: toolBar, attribute: .Leading, multiplier: 1, constant: 8).active = true
                NSLayoutConstraint(item: textView, attribute: .Top, relatedBy: .Equal, toItem: toolBar, attribute: .Top, multiplier: 1, constant: 7.5).active = true
                NSLayoutConstraint(item: textView, attribute: .Trailing, relatedBy: .Equal, toItem: sendButton, attribute: .Leading, multiplier: 1, constant: -2).active = true
                NSLayoutConstraint(item: textView, attribute: .Bottom, relatedBy: .Equal, toItem: toolBar, attribute: .Bottom, multiplier: 1, constant: -8).active = true
                
                NSLayoutConstraint(item: sendButton, attribute: .Trailing, relatedBy: .Equal, toItem: toolBar, attribute: .Trailing, multiplier: 1, constant: 0).active = true
                NSLayoutConstraint(item: sendButton, attribute: .Top, relatedBy: .Equal, toItem: toolBar, attribute: .Top, multiplier: 1, constant: 4.5).active = true
                NSLayoutConstraint(item: sendButton, attribute: .Bottom, relatedBy: .Equal, toItem: toolBar, attribute: .Bottom, multiplier: 1, constant: -4.5).active = true
            }
            
            return toolBar;
        }
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.keyboardDismissMode = .Interactive
        self.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

