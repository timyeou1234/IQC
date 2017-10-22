import UIKit

//MARK:客製下方選單
protocol YNActionSheetDelegate{
    func buttonClick(index:Int)
}

class YNActionSheet: UIViewController {
    
    var layview:UIView!
    var width:CGFloat!
    var height:CGFloat!
    var backgroundView = UIView()
    var CancelButton : UIButton!    //取消按钮
    var delegate :YNActionSheetDelegate!
    var btnArray = [UIButton()]
    let buttonHeight:CGFloat = 60
    
    init(){
        super.init(nibName: nil, bundle: nil)
        self.width = self.view.bounds.size.width
        self.height = self.view.bounds.size.height
        self.view.addSubview(backgroundView)
        self.backgroundView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        self.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        self.view.backgroundColor = UIColor.clear
        self.backgroundView.backgroundColor = UIColor.black
        self.backgroundView.alpha = 0.2
        let tap = UITapGestureRecognizer(target: self, action: #selector(YNActionSheet.tap))
        
        self.view.addGestureRecognizer(tap)
        
        btnArray = Array()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /**
    下来菜单消失
    */
    func tap(){
        self.dismiss(animated: false, completion: { () -> Void in
            
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /**
    *  添加一个取消按钮
    */
    func addCancelButtonWithTitle(Title:String){
        if(layview == nil){
            layview = UIView(frame: CGRect(x: width*0.05, y: height - ( (CGFloat)(btnArray.count) * self.buttonHeight + self.buttonHeight + 10), width: width*0.9, height: (CGFloat)(btnArray.count)*self.buttonHeight+self.buttonHeight + 20))
//            layview.layer.cornerRadius = 5
//            layview.layer.masksToBounds = true
            layview.alpha = 1
            self.view.addSubview(layview)
        }else{
            var nowHeight = self.layview.bounds.size.height
            nowHeight += 60
            layview.frame = CGRect(x:width * 0.05, y:height - nowHeight,width: width*0.9, height:nowHeight)
        }
        
        if(CancelButton == nil){
            CancelButton = UIButton(frame: CGRect(x:(CGFloat)(0), y:(CGFloat)(buttonHeight * (CGFloat)(btnArray.count)+10), width:width*0.9, height:buttonHeight))
            CancelButton.setTitle(Title, for: UIControlState.normal)
            CancelButton.layer.cornerRadius = 5
            CancelButton.layer.masksToBounds = true
            CancelButton.backgroundColor = UIColor.white
            CancelButton.setTitleColor(UIColor.red, for: .normal)
            CancelButton.addTarget(self, action: #selector(YNActionSheet.tap), for: UIControlEvents.touchUpInside)
            self.layview.addSubview(CancelButton)
        }
        
    }
    /**
    *  添加按钮
    */
    func addButtonWithTitle(Title:String){
        if(layview == nil){
            layview = UIView(frame: CGRect(x:width*0.1, y:height - (self.buttonHeight + 10), width: width*0.9, height: self.buttonHeight + 20))
//            layview.layer.cornerRadius = 5
//            layview.layer.masksToBounds = true
//            layview.alpha = 1
            self.view.addSubview(layview)
        }else{
            var nowHeight = self.layview.bounds.size.height
            nowHeight += buttonHeight
            layview.frame = CGRect(x:width * 0.05, y:height - nowHeight, width:width*0.9, height:nowHeight)
//            layview.layer.cornerRadius = 5
//            layview.layer.masksToBounds = true
//            layview.alpha = 1
        }
        let lineView = UIView(frame: CGRect(x: 0, y: (CGFloat)(btnArray.count)*buttonHeight - 1, width: width * 0.9, height: 1))
        lineView.backgroundColor = UIColor.lightGray
        let btn = UIButton(frame: CGRect(x:0, y:(CGFloat)(btnArray.count)*buttonHeight, width:width * 0.9, height:buttonHeight))
        btn.tag = btnArray.count
//        btn.layer.cornerRadius = 5
//        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(YNActionSheet.buttonClick(sender:)), for: UIControlEvents.touchUpInside)
        btn.setTitle(Title, for: UIControlState.normal)
        btn.setTitleColor("".colorWithHexString("0076FF"), for: .normal)
        btn.backgroundColor = UIColor.white
        
        
        
        btnArray.append(btn)
        if btnArray.count == 2{
            let cornerView = UIView(frame: CGRect(x:0, y:0, width:width * 0.9, height:120))
            cornerView.layer.cornerRadius = 5
            cornerView.layer.masksToBounds = true
            cornerView.backgroundColor = UIColor.white
            layview.addSubview(cornerView)
            for btns in btnArray{
                cornerView.addSubview(btns)
            }
            cornerView.addSubview(lineView)
            
        }else if btnArray.count == 1{
            let cornerView = UIView(frame: CGRect(x:0, y:0, width:width * 0.9, height:60))
            cornerView.layer.cornerRadius = 5
            cornerView.layer.masksToBounds = true
            cornerView.backgroundColor = UIColor.white
            layview.addSubview(cornerView)
            for btns in btnArray{
                cornerView.addSubview(btns)
            }
            cornerView.addSubview(lineView)
        }
        
        if(CancelButton != nil){
            let CancelY = CancelButton.frame.origin.y
            CancelButton.frame = CGRect(x:0, y:CancelY + buttonHeight, width:width*0.9, height:buttonHeight)
        }
    }
    /**
    点击按钮产生事件
    */
    func buttonClick(sender:AnyObject){
        self.dismiss(animated: true, completion: { () -> Void in
            
        })
        let btn = sender as! UIButton
        delegate.buttonClick(index: btn.tag)
    }
    
    
}
