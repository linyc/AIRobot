//
//  WelcomeViewController.swift
//  AIRobot
//
//  Created by yuecang on 16/1/6.
//  Copyright © 2016年 LINYC. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class WelcomeViewController: UIViewController,PFLogInViewControllerDelegate,PFSignUpViewControllerDelegate {
    
    var loginVC:PFLogInViewController!
    var signUpVC:PFSignUpViewController!
    var logo:UIImageView!
    var welcomeLabel:UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.whiteColor()
        self.navigationController?.navigationBarHidden = true
        logo = UIImageView(image: UIImage(named: "logo"))
        logo.center = CGPointMake(view.center.x, view.center.y-50)
        
        welcomeLabel = UILabel(frame: CGRect(x: view.center.x-150/2, y: view.center.y+20, width: 150, height: 50))
        welcomeLabel.font = UIFont.systemFontOfSize(22)
        welcomeLabel.textColor = UIColor(red: 0.11, green: 0.55, blue: 0.86, alpha: 1)
        welcomeLabel.textAlignment = .Center
        view.addSubview(welcomeLabel)
        view.addSubview(logo)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if PFUser.currentUser() != nil{
            self.welcomeLabel.text = "欢迎\(PFUser.currentUser()?.username)"
            delay(2.0, completion: { () -> Void in
                var chatVC = ViewController()
                chatVC.title = "AIRobot"
                var navVC = UINavigationController(rootViewController: chatVC)
                self.presentViewController(navVC, animated: true, completion: nil)
            })
        }
        else{
            self.welcomeLabel.text = "未登录"
            delay(2.0, completion: { () -> Void in
                self.loginVC = LoginViewController()
                self.loginVC.delegate = self
                self.signUpVC = SignUpViewController()
                self.signUpVC.delegate = self
                self.loginVC.signUpController = self.signUpVC
                self.presentViewController(self.loginVC, animated: true, completion: nil)
            })
        }
    }
    
    func delay(seconds:Double,completion:()->Void){
        let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC)*seconds))
        dispatch_after(popTime, dispatch_get_main_queue()) { () -> Void in
            completion()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//MARK: login delegate
    func logInViewController(logInController: PFLogInViewController, shouldBeginLogInWithUsername username: String, password: String) -> Bool {
        if !username.isEmpty && !password.isEmpty{
            return true
        }
        
//        UIAlertView(title: "缺少信息", message: "请补全缺少的信息", delegate: self, cancelButtonTitle: "确定").show()
        
        let ac = UIAlertController(title: "缺少信息", message: "请补全缺少的信息", preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "确定", style: .Cancel, handler: nil))
        self.loginVC.presentViewController(ac, animated: true, completion: nil)
        
        return false
    }

    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func logInViewController(logInController: PFLogInViewController, didFailToLogInWithError error: NSError?) {
        print("登录出错: \(error)")
    }
    
//MARK: signUp delegate
    func signUpViewController(signUpController: PFSignUpViewController, shouldBeginSignUp info: [NSObject : AnyObject]) -> Bool {
        var validateSuccess = true
        for value in info.values{
            let field = value as! String
            if field.isEmpty{
                validateSuccess = false
                break
            }
        }
        
        if !validateSuccess{
            let ac = UIAlertController(title: "缺少信息", message: "请补全缺少的信息", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "确定", style: .Cancel, handler: nil))
            self.signUpVC.presentViewController(ac, animated: true, completion: nil)
            
            return false
        }
        
        return true
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didFailToSignUpWithError error: NSError?) {
        print("注册失败：\(error)")
    }
}
