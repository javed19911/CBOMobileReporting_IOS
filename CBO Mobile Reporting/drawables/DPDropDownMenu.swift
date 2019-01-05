//
//  DropDownMenu.swift
//  CBO Mobile Reporting
//
//  Created by CBO IOS on 03/01/18.
//  Copyright © 2018 rahul sharma. All rights reserved.
//




////
////  DropDownMenu.swift
////  SwiftSample
////
////  Created by Dave on 2017. 4. 17..
////  Copyright © 2017년 Yainoma. All rights reserved.
////
//
import UIKit
public struct DPItem {
    
    public var image: UIImage?
    public var title: String
    public var code: String? = "0"
    private var type: String? = "0"
    public var extra: String?
    public var highlight : Bool?
    public init(image: UIImage?, title: String) {
        self.image = image
        self.title = title
    }
    public init( title: String,code: String) {
        self.code = code
        self.title = title
    }
    public init( title: String,code: String,type : String) {
        self.code = code
        self.title = title
        self.type = type
    }
    
    public init(title: String) {
        self.title = title
    }
    
    public init(title  : String , extra : String){
        self.title = title
        self.extra = extra
        
    }
    public init(title  : String , extra : String , highlight : Bool){
        self.title = title
        self.extra = extra
        self.highlight = highlight
    }
    
    func isHighlighted() -> Bool {
        return highlight ?? false
    }
    
    mutating func setHighlight( highlight : Bool) {
        self.highlight = highlight;
    }
    
    func getType() -> String {
        return type ?? "0"
    }
    
    mutating func setType( type : String) {
        self.type = type;
    }
    
    
    

}




public class DPDropDownMenu: UIView {
    
    @IBInspectable public var visibleItemCount: Int = 3
    @IBInspectable public var headerTextFontSize: CGFloat = 15{
        didSet{
            label.font = label.font.withSize(headerTextFontSize)
        }
    }
    
    @IBInspectable public var headerTextBoldFontSize: CGFloat = 15{
        didSet{
            label.font = label.font.withSize(headerTextBoldFontSize)
            label.font = label.font.bold()
        }
    }
    
    
    @IBInspectable public var menuTextFontSize: CGFloat = 15{
        didSet{
            if let table = tableView {
                table.reloadData()
            }
        }
    }
    
    
    
    @IBInspectable public var headerTitle: String = "Header" {
        didSet {
           label.text = headerTitle
        }
    }
    
    @IBInspectable public var headerTextColor: UIColor = AppColorClass.colorPrimary! {
        didSet {
             label.textColor = headerTextColor
        }
    }
    
    @IBInspectable public var headerBackgroundColor: UIColor = .white {
        didSet {
            label.backgroundColor = headerBackgroundColor
        }
    }
    
    @IBInspectable public var menuTextColor: UIColor = AppColorClass.colorPrimary!{
        didSet {
            if let table = tableView {
                table.reloadData()
            }
        }
    }
    
    @IBInspectable public var menuBackgroundColor: UIColor = .white {
        didSet {
            if let table = tableView {
                table.backgroundColor = menuBackgroundColor
                
            }
        }
    }
    
    @IBInspectable public var selectedMenuTextColor: UIColor = AppColorClass.colorPrimary! {
        didSet {
            if let table = tableView {
                table.reloadData()
            }
        }
    }
    
    @IBInspectable public var selectedMenuBackgroundColor: UIColor = .white {
        didSet {
            if let table = tableView {
                table.reloadData()
            }
        }
    }
    
    @IBInspectable public var headerTextFont: UIFont = UIFont.systemFont(ofSize: 17) {
        didSet {
//            label.font = headerTextFont
        }
    }
    
    @IBInspectable public var menuTextFont: UIFont = UIFont.systemFont(ofSize: 17) {
        didSet {
//            if let table = tableView {
//                table.reloadData()
//            }
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    
    @IBInspectable var boarderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = boarderWidth
        }
    }
    
    public var items = [DPItem]() {
        didSet {
            if let table = tableView {
                table.reloadData()
            }
        }
    }
    
    public var selectedIndex = -1 {
        didSet {
            didSelectedItemIndex?(selectedIndex)
        }
    }
    
    fileprivate var isFold = true {
        didSet {
            if isFold {
                fold()
            } else {
                unFold()
            }
        }
    }
    
    fileprivate var button: UIButton! {
        didSet {
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(didSelectedButton(_:)), for: .touchUpInside)
           

        }
    }
    
    
    
    
    fileprivate var label: UILabel! {
        didSet {
            label.translatesAutoresizingMaskIntoConstraints = false
            label.backgroundColor = headerBackgroundColor
            label.font = label.font.withSize(CGFloat(headerTextFontSize))
            label.textColor = headerTextColor
            label.textAlignment = .center
            label.text = headerTitle
            label.numberOfLines = 0
        }
    }
    
    
    fileprivate var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.rowHeight = bounds.size.height
            tableView.separatorInset = UIEdgeInsets.zero
        }
    }
    
    fileprivate var backgroundView: UIView! {
        didSet {
            let tap = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
            backgroundView.addGestureRecognizer(tap)
        }
    }
    
    public var didSelectedItemIndex: ((Int) -> (Void))?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    public convenience init(items: [DPItem]) {
        self.init(frame: .zero)
        
        self.items = items
    }
    
    private func setup() {
        
        self.backgroundColor = .white
        label = UILabel()
        if cornerRadius == 0{
            self.layer.cornerRadius =  CGFloat(2)
        }else {
            self.layer.cornerRadius =  CGFloat(cornerRadius)
        }
        if boarderWidth == 0{
            self.layer.borderWidth =  CGFloat(2)
        }else {
            self.layer.borderWidth =  CGFloat(boarderWidth)
        }
        
        self.layer.borderColor = AppColorClass.colorPrimaryDark?.cgColor
        button = UIButton(type: .custom)
        addSubview(button)
        addSubview(label)
        let imageView = UIImageView()
        imageView.image =  UIImage(named: "drop_icon.png")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let widht = NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: NSLayoutRelation.equal , toItem:nil, attribute: .notAnAttribute , multiplier: 1, constant: 30)
        addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: self.topAnchor, constant : 0).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor , constant : 0).isActive = true
        imageView.rightAnchor.constraint(equalTo: self.rightAnchor , constant : -5).isActive = true
        widht.isActive = true
        
        
        
        let slash = UIView()
        slash.backgroundColor = UIColor.black
        slash.translatesAutoresizingMaskIntoConstraints = false
        let widht1 = NSLayoutConstraint(item: slash, attribute: .width, relatedBy: NSLayoutRelation.equal , toItem:nil, attribute: .notAnAttribute , multiplier: 1, constant: 2)
        addSubview(slash)
        slash.topAnchor.constraint(equalTo: self.topAnchor , constant : 5).isActive = true
        slash.bottomAnchor.constraint(equalTo: self.bottomAnchor , constant : -5).isActive = true
        slash.rightAnchor.constraint(equalTo: imageView.leftAnchor, constant : -5).isActive = true
        widht1.isActive = true
        
        var heightConstraint : NSLayoutConstraint!
        heightConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 0)
        heightConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(CGFloat(250)))
        heightConstraint.isActive =  true
        
        label.topAnchor.constraint(equalTo: self.topAnchor ,  constant : 5).isActive =  true
        label.rightAnchor.constraint(equalTo: slash.leftAnchor ,  constant : -5).isActive =  true
        label.leftAnchor.constraint(equalTo: self.leftAnchor ,  constant : 5).isActive =  true
        label.bottomAnchor.constraint(equalTo: self.bottomAnchor , constant : -5).isActive = true
        
        
    
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[b]|", options: [], metrics: [:], views: ["b": button]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[b]|", options: [], metrics: [:], views: ["b": button]))
        
    }
    
    @objc private func didSelectedButton(_ sender: UIButton) {
        isFold = !isFold
    }
    
    @objc private func didTap(_ sender: UITapGestureRecognizer) {
        isFold = true
    }
}

extension DPDropDownMenu {
    
    private var originTableFrame: CGRect {
       
        return CGRect(x: getframex , y: getframeY + frame.size.height, width: frame.size.width  - 50, height: 0)
    }
    
    private var tableFrame: CGRect {
        if isFold {
            return originTableFrame
        } else {
            var frame = originTableFrame
            frame.size.height = itemHeight
            return frame
        }
    }
    
    private var itemHeight: CGFloat {
        if items.count > visibleItemCount {
            tableView.isScrollEnabled = true
            return CGFloat(visibleItemCount) * bounds.size.height
        } else {
            tableView.isScrollEnabled = false
            return CGFloat(items.count) * bounds.size.height
        }
    }
    
    private var superSuperView: UIView {
        var v: UIView = self
        while (v.superview != nil) {
            v = v.superview!
        }
        return v
    }
    
    private var getframeY: CGFloat {
        //var v: UIView = self
        var y = self.superview?.convert(self.frame.origin, to: nil) //self.frame.origin.y
//        while (v.superview != nil) {
//            v = v.superview!
//            y = y + v.frame.origin.y
//        }
        return y!.y
    }
    
    private var getframex: CGFloat {
        var v: UIView = self
        var y = self.frame.origin.x
        while (v.superview != nil) {
            v = v.superview!
            y = y + v.frame.origin.x
        }
        return y
    }
    
    
    private var duration: TimeInterval {
        return 0.25
    }
    
    fileprivate func fold() {
        UIView.animate(withDuration: duration, animations: { [unowned self] in
            self.tableView.frame = self.tableFrame
        }) { [unowned self] finished in
            self.backgroundView.removeFromSuperview()
            self.tableView.removeFromSuperview()
        }
    }
    
    fileprivate func unFold() {
        backgroundView = UIView(frame: superSuperView.bounds)
        superSuperView.addSubview(backgroundView)
        
        tableView = UITableView(frame: originTableFrame, style: .plain)
        superSuperView.addSubview(tableView)
        tableView.reloadData()
        
        UIView.animate(withDuration: duration) { [unowned self] in
            self.tableView.frame = self.tableFrame
        }
    }
}

fileprivate let dropDownCellIdentifier = "dropDownCellIdentifier"

extension DPDropDownMenu: UITableViewDataSource, UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: dropDownCellIdentifier) as? DPDropDownMenuCell
        if cell == nil {
            cell = DPDropDownMenuCell(style: .default, reuseIdentifier: dropDownCellIdentifier)
            cell?.backgroundColor = .clear
        }
        
        cell?.reload(item: items[indexPath.row])
        reload(cell: cell!, indexPath: indexPath)
        
        return cell!
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        isFold = true
        
        selectedIndex = indexPath.row
        
        headerTitle =  items[selectedIndex].title
        
    }
    
    
    
    private func reload(cell: DPDropDownMenuCell, indexPath: IndexPath) {
//        cell.textLabel?.font = menuTextFont
        cell.textLabel?.font = cell.textLabel?.font.withSize(CGFloat(menuTextFontSize))
        if indexPath.row == selectedIndex {
            cell.backgroundColor = selectedMenuBackgroundColor
            cell.textLabel?.textColor = selectedMenuTextColor
        } else  {
            cell.backgroundColor = menuBackgroundColor
            cell.textLabel?.textColor = menuTextColor
        }
    }
}


class DPDropDownMenuCell: UITableViewCell {
    
    public func reload(item: DPItem) {
         textLabel?.numberOfLines = 0
        textLabel?.text = item.title
        
        imageView?.image = item.image
        
        if let _ = item.image {
            textLabel?.textAlignment = .left
        } else {
            textLabel?.textAlignment = .center
        }
    }
}
