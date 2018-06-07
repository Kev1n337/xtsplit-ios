//
//  GroupTabBarController.swift
//  XTsplit
//
//  Created by Kevin Linne on 09.10.16.
//  Copyright © 2016 Kevin Linne. All rights reserved.
//

import UIKit

class GroupTabBarController: UITabBarController {

    var group: Group?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = group!.name
        //self.navigationController?.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action:nil), animated: true)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
