//
//  LoginViewController.swift
//  AIRobot
//
//  Created by yuecang on 16/1/6.
//  Copyright © 2016年 LINYC. All rights reserved.
//

import UIKit
import ParseUI

class LoginViewController: PFLogInViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.logInView?.logo = UIImageView(image: UIImage(named: "logo"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
