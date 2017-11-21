//
//  WjqDropMenu.swift
//  wjDropDownMenu
//
//  Created by ulinix on 2017-11-20.
//  Copyright © 2017 wjq. All rights reserved.
//

import UIKit

//MARK: 倒三角的位置， 默认在右
public enum ArrowPosition: String{
    case Left
    case Right
}

public struct WjIndexPath{
    //专栏 （筛选项个数）
    public var column = 0
    //筛选项条件个数
    public var row = 0
   
    init(column: NSInteger, row: NSInteger) {
        self.column = column
        self.row = row
    }
}

//MARK : -- 代理方法， 实现UITableView的代理方法
protocol Wjq_DropDownMenuDataSource: class {
   //有多少个筛选项（例如：区域， 租金， 户型，跟多）
    func numberOfColumns(menu: WjqDropMenu) -> NSInteger
    //每个筛选项中，条件的个数
    func numberOfRows(column: NSInteger,  menu: WjqDropMenu) -> Int
    
    //条件 cell 文字
    func titleForRows(indexPath: WjIndexPath,  menu: WjqDropMenu) -> String
    
    func titleFor(column: Int, menu: WjqDropMenu) -> String
    
}
extension Wjq_DropDownMenuDataSource {
    //返回的按钮个数(即 有多少个选项) 默认1个
    func numberOfColumns(mneu: WjqDropMenu) -> NSInteger{
        return 1
    }
    
    func titleFor(column: Int, menu: WjqDropMenu) -> String{
        return menu.data_Source?.titleForRows(indexPath: WjIndexPath(column: column, row: 0), menu: menu) ?? ""
    }
}
protocol Wjq_DropDownMenuDelegate : class {
    //点击cell方法
    func didSelectRow(indexPath: WjIndexPath, menu: WjqDropMenu)
    func didSelectDropMenu(menu: WjqDropMenu, show: Bool)
    func didSelectBackGroundMaskView()
}

/*
 ***
*/


class WjqDropMenu: UIView {
    
    var origin = CGPoint(x: 0, y: 0)
    
    var tableView_Y : CGFloat = 0
    
    //默认选中的index
    var currentSelectedMenuIndex = -1
    //是否显示
    var show = false
    
    var tableView = UITableView()
    
    //阴影蒙板
    var backGroundMaskView = UIView()
    var numberOfMenu = 1
    
    //dataSource
    var array : [String] = []
    
    //layers Array
    var titles: [CATextLayer] = []
    var indicators: [CAShapeLayer] = []
    var bgLayers: [CALayer] = []
    
    
    /*
      **外部参数设置
     */
  
    // cell设置
    open var cell_textLable_Color = UIColor.black
    open var cell_textLable_Select_Color = UIColor.black
    open var cellBgColor = UIColor.white //没有选中的cell背景颜色
    open var cell_Selected_Color = UIColor.groupTableViewBackground//选中的cell的背景颜色
   
    //CATextLayer颜色
    open var caTextLayer_Normal_Color = UIColor.black
    open var caTextLayer_SeleColor = UIColor.black

    //倒三角颜色设置
    open var arrow_Normal_Color = UIColor.black //箭头未选中颜色
    open var arrow_SelectColor = UIColor.black //箭头选中颜色
    
    
    //CaLayer 背景颜色设置
    open var CALayerBg_Normal_Color = UIColor.white
    open var CALayerBg_Select_Color = UIColor.white
    
    
    
    open var textFont = UIFont.systemFont(ofSize: CGFloat(14.0))//文本字体大小
    open var updateColumnTitleOnSelection = true // 按钮文字跟随选中文字改变
    open var arrowPostion: ArrowPosition = .Right //箭头方向， 默认在右侧
    open weak var data_Source: Wjq_DropDownMenuDataSource? {
        didSet {
            //configure view
            self.numberOfMenu = (data_Source?.numberOfColumns(menu: self))!
            setUpUI()
        }
    }
    
    open weak var delegate: Wjq_DropDownMenuDelegate?
    
    func  setUpUI() {
        let textLayerInterval = self.frame.size.width / CGFloat(( self.numberOfMenu * 2))
        let bgLayerInterval = self.frame.size.width / CGFloat(self.numberOfMenu)
        var tempTitles: [CATextLayer] = []
        var tempIndicators: [CAShapeLayer] = []
        var tempBgLayers: [CALayer] = []
        
         for i in 0..<self.numberOfMenu {
            
            //backGroundLayer =
            let backGroundLayerPosition = CGPoint(x: (Double(i)+0.5) * Double(bgLayerInterval), y: Double(self.frame.size.height/2))
            let backGroundLayer = self.createBackGroundLayer(CALayerBg_Normal_Color, backGroundLayerPosition)
            self.layer.addSublayer(backGroundLayer)
            tempBgLayers.append(backGroundLayer)
            
            
            //title
            let titlePosition = CGPoint(x: Double((i * 2 + 1)) * Double(textLayerInterval),
                                        y: Double(self.frame.size.height / 2))
            let titleString = self.data_Source?.titleFor(column: i, menu: self)
            let title = self.createTextLayer(titleString!, self.caTextLayer_Normal_Color, titlePosition)
            self.layer.addSublayer(title)
            tempTitles.append(title)
            
            
            //设置倒三角
            var indicatorPosition = CGPoint(x: 0, y: 0)
            if arrowPostion == .Right {
                indicatorPosition = CGPoint(x: titlePosition.x + title.bounds.size.width / 2 + 8,
                                            y: self.frame.size.height / 2)
            }
            else {
                indicatorPosition = CGPoint(x: titlePosition.x - title.bounds.size.width / 2 - 8,
                                            y: self.frame.size.height / 2)
            }
            
            //创建倒三角
            let indicator = self.createIndicator(self.arrow_Normal_Color, indicatorPosition)
            self.layer.addSublayer(indicator)
            tempIndicators.append(indicator)
           
        }
        
        titles = tempTitles
        indicators = tempIndicators
        bgLayers = tempBgLayers
    }
    
    
    //MARK: 初始化
    public init(origin : CGPoint, width: CGFloat?,height: CGFloat, tableView_Y: CGFloat) {
        let screenSize = UIScreen.main.bounds.size
        super.init(frame: CGRect(origin: CGPoint(x: origin.x, y :origin.y),
                                 size: CGSize(width: width ?? screenSize.width, height: height)))
        
        self.origin = origin
        self.tableView_Y = tableView_Y
        self.currentSelectedMenuIndex = -1
        self.show = false
       
        /*
          ***UITableView
         */
        self.tableView = UITableView.init(frame:
            CGRect(origin: CGPoint(x: origin.x, y :tableView_Y + self.frame.size.height),
                   size: CGSize(width: self.frame.size.width, height: 0)))
        self.tableView.rowHeight = 38
        self.tableView.delegate = self
        self.tableView.dataSource  = self
       
        //点击手势
        self.backgroundColor = UIColor.white
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(menuTapGesture(_:)))
        self.addGestureRecognizer(tapGesture)
        
        //初始化蒙板
        self.backGroundMaskView = UIView.init(frame: CGRect(origin: CGPoint(x: self.frame.origin.x, y :self.frame.origin.y),size: CGSize(width: width ?? screenSize.width, height: CGFloat(screenSize.height + tableView_Y))))
        self.backGroundMaskView.backgroundColor = UIColor.init(white: 0.0, alpha: 0.0)
        self.backGroundMaskView.isOpaque = false
        let tapMask = UITapGestureRecognizer(target: self, action: #selector(tapMask(paramSender:)))
        self.backGroundMaskView.addGestureRecognizer(tapMask)
        
        
        
        let bottomShadow = UIView.init(frame: CGRect(origin: CGPoint(x: 0, y :self.frame.size.height-0.5),
                                                     size: CGSize(width: width ?? screenSize.width, height: 0.5)))
        bottomShadow.backgroundColor = UIColor.lightGray
        self.addSubview(bottomShadow)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
   fileprivate func createBackGroundLayer(_ color: UIColor, _ position: CGPoint) -> CALayer {
        let  layer = CALayer()
        layer.position = position
        layer.bounds = CGRect(origin: CGPoint(x: 0, y : 0), size: CGSize(width: self.frame.size.width/CGFloat(self.numberOfMenu), height: self.frame.size.height - 1))
        layer.backgroundColor = color.cgColor
        return layer
    }
    
    
    //MARK: -- 绘制倒三角
    
    fileprivate func createIndicator(_ color: UIColor, _ point: CGPoint) -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 8, y: 0))
        path.addLine(to: CGPoint(x: 4, y: 5))
        path.close()
        
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = 1.0
        shapeLayer.fillColor = color.cgColor
        
        let bound = CGPath(__byStroking: shapeLayer.path!, transform: nil, lineWidth: shapeLayer.lineWidth, lineCap: .butt, lineJoin: .miter, miterLimit: shapeLayer.miterLimit)!
        
        shapeLayer.bounds = bound.boundingBoxOfPath
        shapeLayer.position = point
        
        return shapeLayer
    }
    
    //MARK: -- 文字layer
    fileprivate func createTextLayer(_ string: String, _ color: UIColor, _ point: CGPoint) -> CATextLayer{
       
        let size = self.calculateTitleSizeWith(string: string)
        
        let layer = CATextLayer()
        let sizeWidth = (size.width < (self.frame.size.width / CGFloat(self.numberOfMenu)) - 25) ? size.width : self.frame.size.width / CGFloat(self.numberOfMenu) - 25
        
        layer.bounds = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: sizeWidth, height: size.height))
        layer.string = string
        layer.fontSize = textFont.pointSize
        layer.alignmentMode = kCAAlignmentCenter
        layer.foregroundColor = color.cgColor
        layer.contentsScale = UIScreen.main.scale
        layer.position = point
        
        return layer
    }
    
   fileprivate  func calculateTitleSizeWith(string: String) -> CGSize {
        let dict = [NSAttributedStringKey.font: textFont]
        let constraintRect = CGSize(width: 280, height: 0)
        let rect = string.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: dict, context: nil)
        return rect.size
    }
   
    
}

//MARK: 手势点击事件
extension WjqDropMenu {
    
    @objc func menuTapGesture(_ gesture: UITapGestureRecognizer ){
       
        let touchPoint = gesture.location(in: self)
        
        //calculate index
        let tapIndex = Int(touchPoint.x / (self.frame.size.width / CGFloat(self.numberOfMenu)))

        for i in 0..<self.numberOfMenu where i != tapIndex {
            self.animateIndicator(indicator: indicators[i], forWard: false, completion: { _ in
                self.animateTitle(title: titles[i], show: false, completion: {_ in
                })
            })
            self.bgLayers[i].backgroundColor = CALayerBg_Normal_Color.cgColor
        }
        
        if tapIndex == self.currentSelectedMenuIndex && self.show {
            self.animate(indicator: indicators[self.currentSelectedMenuIndex], background: self.backGroundMaskView, tableView: self.tableView, title: titles[self.currentSelectedMenuIndex], forward: false, completion: { _ in
                self.currentSelectedMenuIndex = tapIndex
                self.show = false
            })
            self.bgLayers[tapIndex].backgroundColor = CALayerBg_Normal_Color.cgColor
            
            
        } else {
            self.currentSelectedMenuIndex = tapIndex
            self.tableView.reloadData()
            self.animate(indicator: indicators[tapIndex], background: self.backGroundMaskView, tableView: self.tableView, title: titles[tapIndex], forward: true, completion: { _ in
                self.show = true
            })
            self.bgLayers[tapIndex].backgroundColor = CALayerBg_Select_Color.cgColor
        }
        self.delegate?.didSelectDropMenu(menu: self, show:self.show)

    }
    
    
    @objc func tapMask(paramSender: UITapGestureRecognizer? = nil){
        
        self.animate(indicator: indicators[currentSelectedMenuIndex], background: self.backGroundMaskView, tableView: self.tableView, title: titles[self.currentSelectedMenuIndex], forward: false) { _ in
            self.show = false
            self.delegate?.didSelectBackGroundMaskView()

        }
        self.bgLayers[self.currentSelectedMenuIndex].backgroundColor = CALayerBg_Normal_Color.cgColor
//        self.delegate?.didSelectDropMenu(menu: self, show:self.show)
    }
}

//MARK: 手势动画
extension WjqDropMenu {
    
    //倒三角旋转动画
    fileprivate func animateIndicator(indicator: CAShapeLayer, forWard: Bool, completion:((Bool)->(Swift.Void))){
        let angle = forWard ? Double.pi : 0
        let rotate = CGAffineTransform(rotationAngle: CGFloat(angle))
        indicator.transform = CATransform3DMakeAffineTransform(rotate)
        if forWard {
            indicator.fillColor = arrow_SelectColor.cgColor
        } else {
            indicator.fillColor = arrow_Normal_Color.cgColor
        }
        completion(true)
    }

    //蒙板动画
    fileprivate  func animateBackGroundView(view: UIView, show: Bool, completion: @escaping ((Bool) -> Swift.Void)) {
        if show {
            self.superview?.addSubview(view)
            view.superview?.addSubview(self)
            UIView.animate(withDuration: 0.2, animations: {
                view.backgroundColor = UIColor.init(white: 0.0, alpha: 0.3)
                completion(true)
            })
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                view.backgroundColor = UIColor.init(white: 0.0, alpha: 0.0)
            }, completion: { _ in
                view.removeFromSuperview()
                completion(true)
            })
        }
    }
    
    
    //tableView动画
    fileprivate func animateWithTableView(tableView: UITableView, show: Bool, completion: @escaping ((Bool) -> (Swift.Void))){
        
        if show {
            tableView.frame = CGRect(origin: CGPoint(x: self.origin.x, y: self.frame.origin.y + self.frame.size.height), size: CGSize(
                width: self.frame.size.width, height: 0))
            
            self.superview?.addSubview(tableView)
            
            let tableViewHeight = (CGFloat(tableView.numberOfRows(inSection: 0)) * tableView.rowHeight) < UIScreen.main.bounds.height-(self.origin.y+100) ? (CGFloat(tableView.numberOfRows(inSection: 0)) * tableView.rowHeight) : UIScreen.main.bounds.height-(self.origin.y+100)
            
            UIView.animate(withDuration: 0.2, animations: {
                //此处的y值由于外部TableView的滚动时发生偏差， 先写死，原本为self.frame.origin.y
                self.tableView.frame = CGRect(origin: CGPoint(x: self.origin.x, y: self.tableView_Y + self.frame.size.height), size: CGSize(
                    width: self.frame.size.width, height: tableViewHeight))
                completion(true)
            })
            
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                self.tableView.frame = CGRect(origin: CGPoint(x: self.origin.x, y: self.tableView_Y + self.frame.size.height), size: CGSize(
                    width: self.frame.size.width, height: 0))
            }, completion: { (_) in
                tableView.removeFromSuperview()
                completion(true)
            })
            
        }
    }
    
    
    func animateTitle(title: CATextLayer, show: Bool, completion: ((Bool) -> Swift.Void)) {
        let size = self.calculateTitleSizeWith(string: title.string as? String ?? "")
        let sizeWidth = (size.width < (self.frame.size.width / CGFloat(self.numberOfMenu)) - 25) ? size.width : self.frame.size.width / CGFloat(self.numberOfMenu) - 25
        title.bounds = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: sizeWidth, height: size.height))
        if show {
            title.foregroundColor = caTextLayer_SeleColor.cgColor
        } else {
            title.foregroundColor = caTextLayer_Normal_Color.cgColor
        }
        completion(true)
    }
    
    func animate(indicator: CAShapeLayer, background: UIView, tableView: UITableView, title: CATextLayer, forward: Bool, completion: @escaping ((Bool) -> Swift.Void)) {
        
        animateIndicator(indicator: indicator, forWard: forward, completion: {_ in
            animateTitle(title: title, show: forward, completion: {_ in
                animateBackGroundView(view: background, show: forward, completion: {_ in
                    self.animateWithTableView(tableView: tableView, show: forward, completion: {_ in
                        completion(true)
                    })
                })
            })
        })
    }
    
    
}

extension WjqDropMenu: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.data_Source?.numberOfRows(column: self.currentSelectedMenuIndex, menu: self))!
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "Cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: identifier)
        }
        
        cell?.textLabel?.text = self.data_Source?.titleForRows(indexPath: WjIndexPath(column: self.currentSelectedMenuIndex, row: indexPath.row), menu: self)
        cell?.backgroundColor = cellBgColor
        cell?.textLabel?.font = textFont
        cell?.separatorInset = UIEdgeInsets.zero
        cell?.textLabel?.textColor = cell_textLable_Color
        if cell?.textLabel?.text == self.titles[self.currentSelectedMenuIndex].string as? String {
            cell?.backgroundColor = cell_Selected_Color
            cell?.textLabel?.textColor = cell_textLable_Select_Color
        }
        return cell!
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.confiMenuWith(row: indexPath.row)
        self.delegate?.didSelectRow(indexPath: WjIndexPath(column: self.currentSelectedMenuIndex, row: indexPath.row), menu: self)
    }

   fileprivate func confiMenuWith(row: NSInteger){
        let title = self.titles[self.currentSelectedMenuIndex]
        if updateColumnTitleOnSelection {
            title.string = self.data_Source?.titleForRows(indexPath: WjIndexPath(column: self.currentSelectedMenuIndex, row: row), menu: self)

        }
        self.animate(indicator: indicators[self.currentSelectedMenuIndex], background: self.backGroundMaskView, tableView: self.tableView, title: titles[self.currentSelectedMenuIndex], forward: false) { (_) in
            self.show = false
        }
        self.bgLayers[self.currentSelectedMenuIndex].backgroundColor = CALayerBg_Select_Color.cgColor
        
        let indicator = self.indicators[self.currentSelectedMenuIndex]
        indicator.position = CGPoint(x: title.position.x + title.frame.size.width / 2 + 8, y: indicator.position.y)
    }
    
    open func dismiss(){
       self.tapMask(paramSender: nil)
    }
    
    func selectRow(row: NSInteger, in component: NSInteger) {
        self.currentSelectedMenuIndex = component
        self.confiMenuWith(row: row)
    }
 
}

