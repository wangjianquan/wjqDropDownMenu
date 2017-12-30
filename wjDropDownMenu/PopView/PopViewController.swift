//
//  PopViewController.swift
//  weibo_wjq
//
//  Created by landixing on 2017/5/25.
//  Copyright © 2017年 WJQ. All rights reserved.
//

import UIKit

class PopViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {


    var string = String()
    @IBOutlet var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let label = UILabel(frame: CGRect(x: view.center.x, y: view.center.y, width: 100, height: 21))
        label.text = string
        view.addSubview(label)
        self.table.register(UINib.init(nibName: demoCell, bundle: nil), forCellReuseIdentifier: demoCell)
        
        self.table.reloadData()
        // Do any additional setup after loading the view.
    }
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return 15
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return    44
    }
    
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: demoCell, for: indexPath) as! DemoCell
        cell.name.text = "白小嘿 - \(indexPath.row)"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        navigationController?.pushViewController(SecondVC(), animated: true)
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
