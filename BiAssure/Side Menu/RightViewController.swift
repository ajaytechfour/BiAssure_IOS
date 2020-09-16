//
//  RightViewController.swift
//  BiAssure
//  Created by Pulkit on 04/09/20.
//  Copyright © 2020 Tech Four. All rights reserved.

import UIKit
import KSToastView

class RightViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var menuArray = NSMutableArray()
     @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var nameLable: UILabel!
    var appdelegate : AppDelegate = AppDelegate()
    override func viewDidLoad() {
        super.viewDidLoad()

       
        menuArray = NSMutableArray.init(objects: "Dashboard")
        nameLable.text = "\(appdelegate.getUserName())"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return menuArray.count
    }
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView .dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let imageView = cell .viewWithTag(1) as! UIImageView
        
        
        
        let nameLabel = cell .viewWithTag(2) as! UILabel
        nameLabel.text = menuArray.object(at: indexPath.row) as? String
        
        
        switch indexPath.row {
        case 0:
            imageView.image = UIImage.init(named: "dashboard-icon1")
            break
            
        default:
            break
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        switch indexPath.row
                {
                case 0:
                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let navigationController = mainStoryboard.instantiateViewController(withIdentifier: "dashboardnavigation") as! UINavigationController
                    let window = UIApplication.shared.delegate?.window as? UIWindow
        
                    window?.rootViewController = navigationController
                    window?.makeKeyAndVisible()
                    kMainViewController.hideRightView()
                  
                    break
                
                default:
                    break
                }
    }

    
    @IBAction func btnLogout_didSelect(_ sender:UIButton)
    {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        appdelegate.storeUserName(user_name: "")
        appdelegate.storeSessionId(session_id: "")
        
        let navigationController = mainStoryboard.instantiateViewController(withIdentifier: "rootnavigation") as! UINavigationController
    
         let window = UIApplication.shared.delegate?.window as? UIWindow
         
         window?.rootViewController = navigationController
         UIView .transition(with: (window)!, duration: 0.3, options: UIView.AnimationOptions.transitionCrossDissolve, animations: nil, completion: nil)
        KSToastView .ks_showToast("Logout Successfully")
    }
    

}
