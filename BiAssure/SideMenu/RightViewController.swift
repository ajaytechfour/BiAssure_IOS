//
//  RightViewController.swift
//  BiAssure
//
//  Created by Divya on 25/07/19.
//  Copyright © 2019 Techfour. All rights reserved.
//

import UIKit
import KSToastView

class RightViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var menuArray = NSMutableArray()
     @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var nameLable: UILabel!
    var appdelegate : AppDelegate = AppDelegate()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        menuArray = NSMutableArray.init(objects: "Dashboard","Live streaming")
        nameLable.text = "Hey \(appdelegate.getUserName())"
    }
    
    // MARK: - TableView Delegate and Datasource
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
        //cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        switch indexPath.row {
        case 0:
            imageView.image = UIImage.init(named: "dashboard-icon1")
            break
            case 1:
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
                  // kMainViewController.hideRightView(animated: false, completionHandler: nil)
                    break
                case 1:
                  
                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                let navigationController = mainStoryboard.instantiateViewController(withIdentifier: "VideoViewController") as! UINavigationController
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
