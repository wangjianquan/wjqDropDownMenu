//
//  BaseViewController.swift
//  wjDropDownMenu
//
//  Created by ulinix on 2017-11-23.
//  Copyright © 2017 wjq. All rights reserved.
//

import UIKit




class BaseViewController: UIViewController {
    
    lazy var titles = ["我的","我们的", "不是我萌的","反反复复付付付"]

    var fontSize = UIFont.systemFont(ofSize: 13)
    var  contentSizeWidth : CGFloat = 0

    var widthArr = NSArray()
    let itemSpace : CGFloat = 15
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let scroll = UIScrollView(frame: CGRect(x: 0, y: 100, width: screen_width, height: 40))
        scroll.backgroundColor = UIColor.yellow
        
//        label.text = labelText
//        let statusLabelSize = labelText.sizeWithAttributes([NSFontAttributeName : UIFont.systemFontOfSize(13)])
//        labelWidthConstraint.constant = statusLabelSize.width + 4

        
        for i in 0..<titles.count {

            let str = titles[i]
           
            let itemSize = textSize(text: str, font: fontSize)
            let itemWidth : CGFloat = ceil(itemSize.width) + 20

            widthArr.adding(itemWidth)
            contentSizeWidth += itemWidth
            
            scroll.contentSize = CGSize(width: contentSizeWidth + itemSpace * CGFloat(titles.count) + 23, height: scroll.frame.size.height)
      
      
         
        }
        for i in 0..<widthArr.count{
            
            let width : CGFloat = widthArr[i] as! CGFloat

            let label = UILabel(frame: CGRect(x:CGFloat(i) * width, y: CGFloat(0), width: width, height: scroll.frame.size.height))
            
            label.text = "titles[i]"
            label.textColor = UIColor.red
            label.textAlignment = NSTextAlignment.center
            label.backgroundColor = UIColor.blue
            scroll.addSubview(label)
            
        }
        view.addSubview(scroll)

        // Do any additional setup after loading the view.
    }
    
    func textSize(text : String , font : UIFont) -> CGSize{
       return   text.boundingRect(with: CGSize(width: 230, height:CGFloat(MAXFLOAT)), options: .usesFontLeading, attributes: [NSAttributedStringKey.font : font], context: nil).size
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
