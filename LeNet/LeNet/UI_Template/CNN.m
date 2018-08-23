
//Automatically generated by "Happy Coding"
//Free donwload the App from :
//https://itunes.apple.com/us/app/ui-code/id1259075639?ls=1&mt=8
//






#import "SVChartView.h"
#import "SVGridView.h"














#import "CNN.h"

@interface CNN ()

@end

@implementation CNN

-(SVChartView*)dataChartView
{
    if (_dataChartView == nil) {
        _dataChartView = [SVChartView new];
        _dataChartView.backgroundColor = [UIColor whiteColor];
        _dataChartView.layer.borderWidth = 0;
        _dataChartView.layer.borderColor = [UIColor clearColor].CGColor;
    }
    return _dataChartView;
}


-(UIButton*)runButton
{
    if (_runButton == nil) {
        _runButton = [self buildButtonWith:@"runButton" andAction:@selector(buttonDidClicked:)];
    }
    return _runButton;
}

-(SVGridView*)v1GridView
{
    if (_v1GridView == nil) {
        _v1GridView = [SVGridView new];
        _v1GridView.backgroundColor = [UIColor whiteColor];
        _v1GridView.layer.borderWidth = 0;
        _v1GridView.layer.borderColor = [UIColor clearColor].CGColor;
    }
    return _v1GridView;
}


-(SVGridView*)v3Gridview
{
    if (_v3Gridview == nil) {
        _v3Gridview = [SVGridView new];
        _v3Gridview.backgroundColor = [UIColor whiteColor];
        _v3Gridview.layer.borderWidth = 0;
        _v3Gridview.layer.borderColor = [UIColor clearColor].CGColor;
    }
    return _v3Gridview;
}


-(SVGridView*)v2Gridview
{
    if (_v2Gridview == nil) {
        _v2Gridview = [SVGridView new];
        _v2Gridview.backgroundColor = [UIColor whiteColor];
        _v2Gridview.layer.borderWidth = 0;
        _v2Gridview.layer.borderColor = [UIColor clearColor].CGColor;
    }
    return _v2Gridview;
}


-(SVGridView*)v4Gridview
{
    if (_v4Gridview == nil) {
        _v4Gridview = [SVGridView new];
        _v4Gridview.backgroundColor = [UIColor whiteColor];
        _v4Gridview.layer.borderWidth = 0;
        _v4Gridview.layer.borderColor = [UIColor clearColor].CGColor;
    }
    return _v4Gridview;
}


-(UILabel*)v7Label
{
    if (_v7Label == nil) {
        _v7Label = [UILabel new];
        _v7Label.backgroundColor = [UIColor whiteColor];
        _v7Label.adjustsFontSizeToFitWidth = YES;
        _v7Label.numberOfLines=0;
        _v7Label.layer.borderWidth = 0;
        _v7Label.layer.borderColor = [UIColor clearColor].CGColor;
    }
    return _v7Label;
}


-(UITextField*)trainingCountTextField
{
    if (_trainingCountTextField == nil) {
        _trainingCountTextField = [UITextField new];
        _trainingCountTextField.backgroundColor = [UIColor whiteColor];
        _trainingCountTextField.layer.borderWidth = 0.5;
        _trainingCountTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _trainingCountTextField.delegate = self;
    }
    return _trainingCountTextField;
}


-(UILabel*)v9Label
{
    if (_v9Label == nil) {
        _v9Label = [UILabel new];
        _v9Label.backgroundColor = [UIColor whiteColor];
        _v9Label.adjustsFontSizeToFitWidth = YES;
        _v9Label.numberOfLines=0;
        _v9Label.layer.borderWidth = 0;
        _v9Label.layer.borderColor = [UIColor clearColor].CGColor;
    }
    return _v9Label;
}


-(UILabel*)index
{
    if (_index == nil) {
        _index = [UILabel new];
        _index.backgroundColor = [UIColor whiteColor];
        _index.adjustsFontSizeToFitWidth = YES;
        _index.numberOfLines=0;
        _index.layer.borderWidth = 0;
        _index.layer.borderColor = [UIColor clearColor].CGColor;
    }
    return _index;
}


-(UITextField*)trainLoopTextfield
{
    if (_trainLoopTextfield == nil) {
        _trainLoopTextfield = [UITextField new];
        _trainLoopTextfield.backgroundColor = [UIColor whiteColor];
        _trainLoopTextfield.layer.borderWidth = 0.5;
        _trainLoopTextfield.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _trainLoopTextfield.delegate = self;
    }
    return _trainLoopTextfield;
}


-(UITextField*)indexTextfield
{
    if (_indexTextfield == nil) {
        _indexTextfield = [UITextField new];
        _indexTextfield.backgroundColor = [UIColor whiteColor];
        _indexTextfield.layer.borderWidth = 0.5;
        _indexTextfield.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _indexTextfield.delegate = self;
    }
    return _indexTextfield;
}


-(UILabel*)v13Label
{
    if (_v13Label == nil) {
        _v13Label = [UILabel new];
        _v13Label.backgroundColor = [UIColor whiteColor];
        _v13Label.adjustsFontSizeToFitWidth = YES;
        _v13Label.numberOfLines=0;
        _v13Label.layer.borderWidth = 0;
        _v13Label.layer.borderColor = [UIColor clearColor].CGColor;
    }
    return _v13Label;
}


-(UILabel*)v14Label
{
    if (_v14Label == nil) {
        _v14Label = [UILabel new];
        _v14Label.backgroundColor = [UIColor whiteColor];
        _v14Label.adjustsFontSizeToFitWidth = YES;
        _v14Label.numberOfLines=0;
        _v14Label.layer.borderWidth = 0;
        _v14Label.layer.borderColor = [UIColor clearColor].CGColor;
    }
    return _v14Label;
}


-(UILabel*)v15Label
{
    if (_v15Label == nil) {
        _v15Label = [UILabel new];
        _v15Label.backgroundColor = [UIColor whiteColor];
        _v15Label.adjustsFontSizeToFitWidth = YES;
        _v15Label.numberOfLines=0;
        _v15Label.layer.borderWidth = 0;
        _v15Label.layer.borderColor = [UIColor clearColor].CGColor;
    }
    return _v15Label;
}


-(UILabel*)v16Label
{
    if (_v16Label == nil) {
        _v16Label = [UILabel new];
        _v16Label.backgroundColor = [UIColor whiteColor];
        _v16Label.adjustsFontSizeToFitWidth = YES;
        _v16Label.numberOfLines=0;
        _v16Label.layer.borderWidth = 0;
        _v16Label.layer.borderColor = [UIColor clearColor].CGColor;
    }
    return _v16Label;
}


-(UILabel*)v17Label
{
    if (_v17Label == nil) {
        _v17Label = [UILabel new];
        _v17Label.backgroundColor = [UIColor whiteColor];
        _v17Label.adjustsFontSizeToFitWidth = YES;
        _v17Label.numberOfLines=0;
        _v17Label.layer.borderWidth = 0;
        _v17Label.layer.borderColor = [UIColor clearColor].CGColor;
    }
    return _v17Label;
}


-(UILabel*)v18Label
{
    if (_v18Label == nil) {
        _v18Label = [UILabel new];
        _v18Label.backgroundColor = [UIColor whiteColor];
        _v18Label.adjustsFontSizeToFitWidth = YES;
        _v18Label.numberOfLines=0;
        _v18Label.layer.borderWidth = 0;
        _v18Label.layer.borderColor = [UIColor clearColor].CGColor;
    }
    return _v18Label;
}


-(UISwitch*)derrdoutSwitch
{
    if (_derrdoutSwitch == nil) {
        _derrdoutSwitch = [self buildUISwitch];
        _derrdoutSwitch.backgroundColor = [UIColor whiteColor];
    }
    return _derrdoutSwitch;
}

-(UISwitch*)dwvSwitch
{
    if (_dwvSwitch == nil) {
        _dwvSwitch = [self buildUISwitch];
        _dwvSwitch.backgroundColor = [UIColor whiteColor];
    }
    return _dwvSwitch;
}

-(UISwitch*)deltaruleSwitch
{
    if (_deltaruleSwitch == nil) {
        _deltaruleSwitch = [self buildUISwitch];
        _deltaruleSwitch.backgroundColor = [UIColor whiteColor];
    }
    return _deltaruleSwitch;
}

-(UISwitch*)dnetdwSwitch
{
    if (_dnetdwSwitch == nil) {
        _dnetdwSwitch = [self buildUISwitch];
        _dnetdwSwitch.backgroundColor = [UIColor whiteColor];
    }
    return _dnetdwSwitch;
}

-(UISwitch*)doutdnetSwitch
{
    if (_doutdnetSwitch == nil) {
        _doutdnetSwitch = [self buildUISwitch];
        _doutdnetSwitch.backgroundColor = [UIColor whiteColor];
    }
    return _doutdnetSwitch;
}

-(UITextView*)logTextView
{
    if (_logTextView == nil) {
        _logTextView = [UITextView new];
        _logTextView.backgroundColor = [UIColor whiteColor];
        _logTextView.layer.borderWidth = 0.0;
        _logTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _logTextView.delegate = self;
    }
    return _logTextView;
}

-(SVGridView*)v5Gridview
{
    if (_v5Gridview == nil) {
        _v5Gridview = [SVGridView new];
        _v5Gridview.backgroundColor = [UIColor whiteColor];
        _v5Gridview.layer.borderWidth = 0;
        _v5Gridview.layer.borderColor = [UIColor clearColor].CGColor;
    }
    return _v5Gridview;
}


-(SVGridView*)v6Gridview
{
    if (_v6Gridview == nil) {
        _v6Gridview = [SVGridView new];
        _v6Gridview.backgroundColor = [UIColor whiteColor];
        _v6Gridview.layer.borderWidth = 0;
        _v6Gridview.layer.borderColor = [UIColor clearColor].CGColor;
    }
    return _v6Gridview;
}


-(SVGridView*)v7Gridview
{
    if (_v7Gridview == nil) {
        _v7Gridview = [SVGridView new];
        _v7Gridview.backgroundColor = [UIColor whiteColor];
        _v7Gridview.layer.borderWidth = 0;
        _v7Gridview.layer.borderColor = [UIColor clearColor].CGColor;
    }
    return _v7Gridview;
}


-(UIImageView*)L6ImageView
{
    if (_L6ImageView == nil) {
        _L6ImageView = [UIImageView new];
        _L6ImageView.backgroundColor = [UIColor whiteColor];
        _L6ImageView.layer.borderWidth = 0;
        _L6ImageView.layer.borderColor = [UIColor clearColor].CGColor;
    }
    return _L6ImageView;
}


-(UIScrollView*)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [UIScrollView new];
        _scrollView.backgroundColor = [UIColor whiteColor];
        
    }
    return _scrollView;
}


- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    offsetY = 0;
    keyBoardHieght=0;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self.view addSubview:self.scrollView];
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
    
    [self.scrollView addSubview:self.dataChartView];
    
    [self.scrollView addSubview:self.runButton];
    
    [self.scrollView addSubview:self.L6ImageView];
    
    [self.scrollView addSubview:self.v1GridView];
    
    [self.scrollView addSubview:self.v2Gridview];
    
    [self.scrollView addSubview:self.v3Gridview];
    
    [self.scrollView addSubview:self.v4Gridview];
    
    [self.scrollView addSubview:self.v5Gridview];
    
    [self.scrollView addSubview:self.v6Gridview];
    
    [self.scrollView addSubview:self.v7Gridview];
    
    [self.scrollView addSubview:self.v13Label];
    
    [self.scrollView addSubview:self.v7Label];
    
    [self.scrollView addSubview:self.trainingCountTextField];
    
    [self.scrollView addSubview:self.v14Label];
    
    [self.scrollView addSubview:self.derrdoutSwitch];
    
    [self.scrollView addSubview:self.v9Label];
    
    [self.scrollView addSubview:self.trainLoopTextfield];
    
    [self.scrollView addSubview:self.v18Label];
    
    [self.scrollView addSubview:self.doutdnetSwitch];
    
    [self.scrollView addSubview:self.index];
    
    [self.scrollView addSubview:self.indexTextfield];
    
    [self.scrollView addSubview:self.v17Label];
    
    [self.scrollView addSubview:self.dnetdwSwitch];
    
    [self.scrollView addSubview:self.v16Label];
    
    [self.scrollView addSubview:self.deltaruleSwitch];
    
    [self.scrollView addSubview:self.v15Label];
    
    [self.scrollView addSubview:self.dwvSwitch];
    
    [self.scrollView addSubview:self.logTextView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat rate = [self rateOfwidth];
    if(rate == 0)
    {
        rate = [self screenW]/667.0;
    }
    
    self.dataChartView.backgroundColor = [UIColor clearColor];
    
    self.v7Label.adjustsFontSizeToFitWidth = YES;
    
    self.v7Label.textAlignment = NSTextAlignmentLeft;
    
    self.v7Label.backgroundColor = [UIColor whiteColor];
    
    self.v7Label.text = @"trainingCount";
    
    self.v7Label.font =[UIFont systemFontOfSize:14*rate];
    
    self.v7Label.textColor = [UIColor darkGrayColor];
    
    self.trainingCountTextField.placeholder = @"0";
    
    self.trainingCountTextField.textAlignment = NSTextAlignmentLeft;
    
    self.trainingCountTextField.adjustsFontSizeToFitWidth = YES;
    
    self.trainingCountTextField.backgroundColor = [UIColor whiteColor];
    
    self.trainingCountTextField.text = @"1";
    
    self.trainingCountTextField.font =[UIFont systemFontOfSize:14*rate];
    
    self.trainingCountTextField.textColor = [UIColor darkGrayColor];
    
    self.v9Label.adjustsFontSizeToFitWidth = YES;
    
    self.v9Label.textAlignment = NSTextAlignmentLeft;
    
    self.v9Label.backgroundColor = [UIColor whiteColor];
    
    self.v9Label.text = @"trainLoop";
    
    self.v9Label.font =[UIFont systemFontOfSize:14*rate];
    
    self.v9Label.textColor = [UIColor darkGrayColor];
    
    self.index.adjustsFontSizeToFitWidth = YES;
    
    self.index.textAlignment = NSTextAlignmentLeft;
    
    self.index.backgroundColor = [UIColor whiteColor];
    
    self.index.text = @"index";
    
    self.index.font =[UIFont systemFontOfSize:14*rate];
    
    self.index.textColor = [UIColor darkGrayColor];
    
    self.trainLoopTextfield.placeholder = @"0";
    
    self.trainLoopTextfield.textAlignment = NSTextAlignmentLeft;
    
    self.trainLoopTextfield.adjustsFontSizeToFitWidth = YES;
    
    self.trainLoopTextfield.backgroundColor = [UIColor whiteColor];
    
    self.trainLoopTextfield.text = @"1";
    
    self.trainLoopTextfield.font =[UIFont systemFontOfSize:14*rate];
    
    self.trainLoopTextfield.textColor = [UIColor darkGrayColor];
    
    self.indexTextfield.placeholder = @"0";
    
    self.indexTextfield.textAlignment = NSTextAlignmentLeft;
    
    self.indexTextfield.adjustsFontSizeToFitWidth = YES;
    
    self.indexTextfield.backgroundColor = [UIColor whiteColor];
    
    self.indexTextfield.text = @"1";
    
    self.indexTextfield.font =[UIFont systemFontOfSize:14*rate];
    
    self.indexTextfield.textColor = [UIColor darkGrayColor];
    
    self.v13Label.text = @"Log option";
    
    self.v14Label.adjustsFontSizeToFitWidth = YES;
    
    self.v14Label.textAlignment = NSTextAlignmentLeft;
    
    self.v14Label.backgroundColor = [UIColor clearColor];
    
    self.v14Label.text = @"DError Dout";
    
    self.v14Label.font =[UIFont systemFontOfSize:16*rate];
    
    self.v14Label.textColor = [UIColor darkGrayColor];
    
    self.v15Label.adjustsFontSizeToFitWidth = YES;
    
    self.v15Label.textAlignment = NSTextAlignmentLeft;
    
    self.v15Label.backgroundColor = [UIColor clearColor];
    
    self.v15Label.text = @"Dwv";
    
    self.v15Label.font =[UIFont systemFontOfSize:16*rate];
    
    self.v15Label.textColor = [UIColor darkGrayColor];
    
    self.v16Label.adjustsFontSizeToFitWidth = YES;
    
    self.v16Label.textAlignment = NSTextAlignmentLeft;
    
    self.v16Label.backgroundColor = [UIColor clearColor];
    
    self.v16Label.text = @"DeltaRule";
    
    self.v16Label.font =[UIFont systemFontOfSize:16*rate];
    
    self.v16Label.textColor = [UIColor darkGrayColor];
    
    self.v17Label.adjustsFontSizeToFitWidth = YES;
    
    self.v17Label.textAlignment = NSTextAlignmentLeft;
    
    self.v17Label.backgroundColor = [UIColor clearColor];
    
    self.v17Label.text = @"DNet DW";
    
    self.v17Label.font =[UIFont systemFontOfSize:16*rate];
    
    self.v17Label.textColor = [UIColor darkGrayColor];
    
    self.v18Label.adjustsFontSizeToFitWidth = YES;
    
    self.v18Label.textAlignment = NSTextAlignmentLeft;
    
    self.v18Label.backgroundColor = [UIColor clearColor];
    
    self.v18Label.text = @"Dout Dnet";
    
    self.v18Label.font =[UIFont systemFontOfSize:16*rate];
    
    self.v18Label.textColor = [UIColor darkGrayColor];
    
    self.derrdoutSwitch.backgroundColor = [UIColor whiteColor];
    
    self.derrdoutSwitch.on = NO;
    
    self.dwvSwitch.backgroundColor = [UIColor whiteColor];
    
    self.dwvSwitch.on = NO;
    
    self.deltaruleSwitch.backgroundColor = [UIColor whiteColor];
    
    self.deltaruleSwitch.on = NO;
    
    self.dnetdwSwitch.backgroundColor = [UIColor whiteColor];
    
    self.dnetdwSwitch.on = NO;
    
    self.doutdnetSwitch.backgroundColor = [UIColor whiteColor];
    
    self.doutdnetSwitch.on = NO;
    
    self.logTextView.backgroundColor = [UIColor whiteColor];
    
    self.logTextView.textAlignment = NSTextAlignmentLeft;
    
    self.logTextView.text = @"Log";
    
    self.logTextView.font =[UIFont systemFontOfSize:14*rate];
    
    self.logTextView.textColor = [UIColor redColor];
    
}

-(void)viewDidLayoutSubviews
{
    CGFloat left,top;
    CGFloat x,y,w,h;
    CGFloat rate = [self rateOfwidth];
    CGFloat rateH = [self rateOfHeight];
    CGFloat xInterval = 10.0,yInterval = 10.0;
    left = 0.00*rate;
    top = 0.00;
    CGFloat sw = [self screenW];
    CGFloat wr = sw/375.0;
    CGFloat wh = [self screenH];
    CGFloat nomalR = wh - 667.0*wr;
    CGFloat fixTop = 0;
    CGFloat fixLeft = 0;
    if (@available(iOS 11.0, *)) {
        fixTop = self.view.safeAreaInsets.top;//remove this line if has error
    } else {
        fixTop = 0;
    }
    if (@available(iOS 11.0, *)) {
        fixLeft = self.view.safeAreaInsets.left;//remove this line if has error
    } else {
        fixLeft = 0;
    }
    left += fixLeft;
    top += fixTop;
    top += offsetY;
    CGFloat contentw,contenth;
    
    CGFloat    dataChartView_Width = 375.00*rate;
    CGFloat    dataChartView_Height = 150.00*rateH;
    CGFloat    runButton_yInterval = 1.00*rateH;
    CGFloat    runButton_Width = 60.90*rate;
    CGFloat    runButton_Height = 31.00*rateH;
    CGFloat    L6ImageView_xInterval = 10.00*rate;
    CGFloat    L6ImageView_Width = 31.00*rate;
    CGFloat    v1GridView_yInterval = 3.00*rateH;
    CGFloat    v1GridView_Width = 375.00*rate;
    CGFloat    v1GridView_Height = 60.00*rateH;
    CGFloat    v2Gridview_yInterval = 60.00*rateH;
    CGFloat    v3Gridview_yInterval = 60.00*rateH;
    CGFloat    v3Gridview_Height = 23.00*rateH;
    CGFloat    v4Gridview_yInterval = 23.00*rateH;
    CGFloat    v5Gridview_xInterval = 14.47*rate;
    CGFloat    v5Gridview_yInterval = 7.89*rateH;
    CGFloat    v5Gridview_Width = 30.00*rate;
    CGFloat    v5Gridview_Height = 36.00*rateH;
    CGFloat    v6Gridview_xInterval = 10.00*rate;
    CGFloat    v6Gridview_Width = 21.00*rate;
    CGFloat    v7Gridview_yInterval = 12.90*rateH;
    CGFloat    v7Gridview_Width = 375.00*rate;
    CGFloat    v7Gridview_Height = 3.00*rateH;
    CGFloat    v13Label_xInterval = 135.67*rate;
    CGFloat    v13Label_yInterval = 9.20*rateH;
    CGFloat    v13Label_Width = 103.67*rate;
    CGFloat    v13Label_Height = 15.73*rateH;
    CGFloat    v7Label_xInterval = 53.00*rate;
    CGFloat    v7Label_yInterval = 0.27*rateH;
    CGFloat    v7Label_Width = 60.00*rate;
    CGFloat    v7Label_Height = 20.00*rateH;
    CGFloat    trainingCountTextField_xInterval = 14.00*rate;
    CGFloat    trainingCountTextField_yInterval = 2.00*rateH;
    CGFloat    v14Label_xInterval = 41.00*rate;
    CGFloat    v14Label_yInterval = 2.00*rateH;
    CGFloat    v14Label_Width = 54.40*rate;
    CGFloat    derrdoutSwitch_xInterval = 10.00*rate;
    CGFloat    derrdoutSwitch_Height = 30.00*rateH;
    CGFloat    v9Label_xInterval = 53.00*rate;
    CGFloat    v9Label_yInterval = 26.00*rateH;
    CGFloat    v9Label_Width = 60.00*rate;
    CGFloat    v9Label_Height = 20.00*rateH;
    CGFloat    trainLoopTextfield_xInterval = 14.00*rate;
    CGFloat    trainLoopTextfield_yInterval = 2.00*rateH;
    CGFloat    v18Label_xInterval = 41.00*rate;
    CGFloat    v18Label_yInterval = 3.00*rateH;
    CGFloat    v18Label_Width = 54.40*rate;
    CGFloat    doutdnetSwitch_xInterval = 10.00*rate;
    CGFloat    doutdnetSwitch_Height = 30.00*rateH;
    CGFloat    index_xInterval = 53.00*rate;
    CGFloat    index_yInterval = 25.00*rateH;
    CGFloat    index_Width = 60.00*rate;
    CGFloat    index_Height = 20.00*rateH;
    CGFloat    indexTextfield_xInterval = 14.00*rate;
    CGFloat    indexTextfield_yInterval = 2.00*rateH;
    CGFloat    v17Label_xInterval = 41.00*rate;
    CGFloat    v17Label_yInterval = 4.00*rateH;
    CGFloat    v17Label_Width = 54.40*rate;
    CGFloat    dnetdwSwitch_xInterval = 10.00*rate;
    CGFloat    dnetdwSwitch_Height = 30.00*rateH;
    CGFloat    v16Label_xInterval = 173.60*rate;
    CGFloat    v16Label_yInterval = 1.00*rateH;
    CGFloat    v16Label_Height = 20.00*rateH;
    CGFloat    deltaruleSwitch_xInterval = 10.00*rate;
    CGFloat    deltaruleSwitch_Height = 30.00*rateH;
    CGFloat    v15Label_xInterval = 173.60*rate;
    CGFloat    v15Label_yInterval = 1.00*rateH;
    CGFloat    v15Label_Height = 20.00*rateH;
    CGFloat    dwvSwitch_xInterval = 10.00*rate;
    CGFloat    dwvSwitch_Height = 30.00*rateH;
    CGFloat    logTextView_xInterval = 0.90*rate;
    CGFloat    logTextView_yInterval = 5.00*rateH;
    CGFloat    logTextView_Width = 373.30*rate;
    CGFloat    logTextView_Height = 60.00*rateH;
    
    x =  left;
    y =  top;
    w = dataChartView_Width;
    h = dataChartView_Height;
    self.dataChartView.frame = CGRectMake(x, y, w, h);
    
    yInterval = runButton_yInterval;
    x =  left;
    y =  y + h + yInterval;
    w = runButton_Width;
    h = runButton_Height;
    self.runButton.frame = CGRectMake(x, y, w, h);
    
    xInterval = L6ImageView_xInterval;
    x =  x + w + xInterval;
    w = L6ImageView_Width;
    self.L6ImageView.frame = CGRectMake(x, y, w, h);
    
    yInterval = v1GridView_yInterval;
    x =  left;
    y =  y + h + yInterval;
    w = v1GridView_Width;
    h = v1GridView_Height;
    self.v1GridView.frame = CGRectMake(x, y, w, h);
    
    yInterval = v2Gridview_yInterval;
    x =  left;
    y =  y + h;
    self.v2Gridview.frame = CGRectMake(x, y, w, h);
    
    yInterval = v3Gridview_yInterval;
    x =  left;
    y =  y + h;
    h = v3Gridview_Height;
    self.v3Gridview.frame = CGRectMake(x, y, w, h);
    
    yInterval = v4Gridview_yInterval;
    x =  left;
    y =  y + h;
    self.v4Gridview.frame = CGRectMake(x, y, w, h);
    
    yInterval = v5Gridview_yInterval;
    xInterval = v5Gridview_xInterval;
    x =  left + xInterval;
    y =  y + h + yInterval;
    w = v5Gridview_Width;
    h = v5Gridview_Height;
    self.v5Gridview.frame = CGRectMake(x, y, w, h);
    
    xInterval = v6Gridview_xInterval;
    x =  x + w + xInterval;
    w = v6Gridview_Width;
    self.v6Gridview.frame = CGRectMake(x, y, w, h);
    
    yInterval = v7Gridview_yInterval;
    x =  left;
    y =  y + h + yInterval;
    w = v7Gridview_Width;
    h = v7Gridview_Height;
    self.v7Gridview.frame = CGRectMake(x, y, w, h);
    
    yInterval = v13Label_yInterval;
    xInterval = v13Label_xInterval;
    x =  x + xInterval;
    y =  y + h + yInterval;
    w = v13Label_Width;
    h = v13Label_Height;
    self.v13Label.frame = CGRectMake(x, y, w, h);
    
    yInterval = v7Label_yInterval;
    xInterval = v7Label_xInterval;
    x =  left + xInterval;
    y =  y + h + yInterval;
    w = v7Label_Width;
    h = v7Label_Height;
    self.v7Label.frame = CGRectMake(x, y, w, h);
    
    yInterval = trainingCountTextField_yInterval;
    xInterval = trainingCountTextField_xInterval;
    x =  x + w + xInterval;
    y =  y + yInterval;
    self.trainingCountTextField.frame = CGRectMake(x, y, w, h);
    
    yInterval = v14Label_yInterval;
    xInterval = v14Label_xInterval;
    x =  x + w + xInterval;
    y =  y + yInterval;
    w = v14Label_Width;
    self.v14Label.frame = CGRectMake(x, y, w, h);
    
    xInterval = derrdoutSwitch_xInterval;
    x =  x + w + xInterval;
    h = derrdoutSwitch_Height;
    self.derrdoutSwitch.frame = CGRectMake(x, y, w, h);
    
    yInterval = v9Label_yInterval;
    xInterval = v9Label_xInterval;
    x =  left + xInterval;
    y =  y + yInterval;
    w = v9Label_Width;
    h = v9Label_Height;
    self.v9Label.frame = CGRectMake(x, y, w, h);
    
    yInterval = trainLoopTextfield_yInterval;
    xInterval = trainLoopTextfield_xInterval;
    x =  x + w + xInterval;
    y =  y + yInterval;
    self.trainLoopTextfield.frame = CGRectMake(x, y, w, h);
    
    yInterval = v18Label_yInterval;
    xInterval = v18Label_xInterval;
    x =  x + w + xInterval;
    y =  y + yInterval;
    w = v18Label_Width;
    self.v18Label.frame = CGRectMake(x, y, w, h);
    
    xInterval = doutdnetSwitch_xInterval;
    x =  x + w + xInterval;
    h = doutdnetSwitch_Height;
    self.doutdnetSwitch.frame = CGRectMake(x, y, w, h);
    
    yInterval = index_yInterval;
    xInterval = index_xInterval;
    x =  left + xInterval;
    y =  y + yInterval;
    w = index_Width;
    h = index_Height;
    self.index.frame = CGRectMake(x, y, w, h);
    
    yInterval = indexTextfield_yInterval;
    xInterval = indexTextfield_xInterval;
    x =  x + w + xInterval;
    y =  y + yInterval;
    self.indexTextfield.frame = CGRectMake(x, y, w, h);
    
    yInterval = v17Label_yInterval;
    xInterval = v17Label_xInterval;
    x =  x + w + xInterval;
    y =  y + yInterval;
    w = v17Label_Width;
    self.v17Label.frame = CGRectMake(x, y, w, h);
    
    xInterval = dnetdwSwitch_xInterval;
    x =  x + w + xInterval;
    h = dnetdwSwitch_Height;
    self.dnetdwSwitch.frame = CGRectMake(x, y, w, h);
    
    yInterval = v16Label_yInterval;
    xInterval = v16Label_xInterval;
    x =  left + w + xInterval;
    y =  y + h + yInterval;
    h = v16Label_Height;
    self.v16Label.frame = CGRectMake(x, y, w, h);
    
    xInterval = deltaruleSwitch_xInterval;
    x =  x + w + xInterval;
    h = deltaruleSwitch_Height;
    self.deltaruleSwitch.frame = CGRectMake(x, y, w, h);
    
    yInterval = v15Label_yInterval;
    xInterval = v15Label_xInterval;
    x =  left + w + xInterval;
    y =  y + h + yInterval;
    h = v15Label_Height;
    self.v15Label.frame = CGRectMake(x, y, w, h);
    
    xInterval = dwvSwitch_xInterval;
    x =  x + w + xInterval;
    h = dwvSwitch_Height;
    self.dwvSwitch.frame = CGRectMake(x, y, w, h);
    
    yInterval = logTextView_yInterval;
    xInterval = logTextView_xInterval;
    x =  left + xInterval;
    y =  y + h + yInterval;
    w = logTextView_Width;
    h = logTextView_Height;
    self.logTextView.frame = CGRectMake(x, y, w, h);
    
    contenth = y+h+keyBoardHieght;
    
    x = 0;
    y = 0;
    w = [UIScreen mainScreen].bounds.size.width;
    h = [UIScreen mainScreen].bounds.size.height;
    
    self.scrollView.frame = CGRectMake(x, y, w, h);
    contentw = w;
    self.scrollView.contentSize = CGSizeMake(contentw, contenth);
    
}

-(void)changeSwitch:(UISwitch*)pSwitch
{
    
    
    if(pSwitch == self.derrdoutSwitch)
    {
        if([self.delegate respondsToSelector:@selector(changeCNN:WithName:andValue:)])
        {
            [self.delegate changeCNN:self WithName:@"derrdoutSwitch" andValue:pSwitch.on];
        }
        NSLog(@"derrdoutSwitch ChangeValue%d",pSwitch.on);
    }
    
    
    if(pSwitch == self.dwvSwitch)
    {
        if([self.delegate respondsToSelector:@selector(changeCNN:WithName:andValue:)])
        {
            [self.delegate changeCNN:self WithName:@"dwvSwitch" andValue:pSwitch.on];
        }
        NSLog(@"dwvSwitch ChangeValue%d",pSwitch.on);
    }
    
    
    if(pSwitch == self.deltaruleSwitch)
    {
        if([self.delegate respondsToSelector:@selector(changeCNN:WithName:andValue:)])
        {
            [self.delegate changeCNN:self WithName:@"deltaruleSwitch" andValue:pSwitch.on];
        }
        NSLog(@"deltaruleSwitch ChangeValue%d",pSwitch.on);
    }
    
    
    if(pSwitch == self.dnetdwSwitch)
    {
        if([self.delegate respondsToSelector:@selector(changeCNN:WithName:andValue:)])
        {
            [self.delegate changeCNN:self WithName:@"dnetdwSwitch" andValue:pSwitch.on];
        }
        NSLog(@"dnetdwSwitch ChangeValue%d",pSwitch.on);
    }
    
    
    if(pSwitch == self.doutdnetSwitch)
    {
        if([self.delegate respondsToSelector:@selector(changeCNN:WithName:andValue:)])
        {
            [self.delegate changeCNN:self WithName:@"doutdnetSwitch" andValue:pSwitch.on];
        }
        NSLog(@"doutdnetSwitch ChangeValue%d",pSwitch.on);
    }
    
}
- (UISwitch*)buildUISwitch
{
    UISwitch*pSwitch = [[UISwitch alloc] init];
    //        pSwitch.onTintColor = [UIColor colorWithRed:76.0/255.0 green:67.0/255.0 blue:88.0/255.0 alpha:1.0];
    //        pSwitch.tintColor = [UIColor colorWithRed:150.0/255.0 green:125.0/255.0 blue:217.0/255.0 alpha:1.0];
    //        pSwitch.thumbTintColor = [UIColor colorWithRed:150.0/255.0 green:125.0/255.0 blue:217.0/255.0 alpha:1.0];
    [pSwitch setOn:YES];
    
    [pSwitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
    
    
    return pSwitch;
}
-(void)buttonDidClicked:(UIButton*)button

{
    
    if(button == self.runButton)
    {
        NSLog(@"self.runButton is clicked");
        [self runButtonClicked];
        
        if([self.delegate respondsToSelector:@selector(buttonOfCNN:DidClickedWithName:)])
        {
            [self.delegate buttonOfCNN:self DidClickedWithName:@"runButton"];
        }
        else
        {
            NSLog(@"Method buttonOfCNN:self DidClickedWithName: not implemented");
        }
    }
    
}

-(void)runButtonClicked
{
    
    NSLog(@"self.runButton is clicked");
}

-(void)refreshFromDiction:(NSDictionary*)dic
{
    
    /*
     @"v7Label":@"",
     @"trainingCountTextField":@"",
     @"v9Label":@"",
     @"index":@"",
     @"trainLoopTextfield":@"",
     @"indexTextfield":@"",
     @"v13Label":@"",
     @"v14Label":@"",
     @"v15Label":@"",
     @"v16Label":@"",
     @"v17Label":@"",
     @"v18Label":@"",
     @"derrdoutSwitch":@YES,
     @"dwvSwitch":@YES,
     @"deltaruleSwitch":@YES,
     @"dnetdwSwitch":@YES,
     @"doutdnetSwitch":@YES,
     @"logTextView":@"",
     
     */
    if(dic)
    {
        if(dic[@"v7Label"])
            self.v7Label.text = [NSString stringWithFormat:@"%@",dic[@"v7Label"]];
        
        if(dic[@"trainingCountTextField"])
            self.trainingCountTextField.text = [NSString stringWithFormat:@"%@",dic[@"trainingCountTextField"]];
        
        if(dic[@"v9Label"])
            self.v9Label.text = [NSString stringWithFormat:@"%@",dic[@"v9Label"]];
        
        if(dic[@"index"])
            self.index.text = [NSString stringWithFormat:@"%@",dic[@"index"]];
        
        if(dic[@"trainLoopTextfield"])
            self.trainLoopTextfield.text = [NSString stringWithFormat:@"%@",dic[@"trainLoopTextfield"]];
        
        if(dic[@"indexTextfield"])
            self.indexTextfield.text = [NSString stringWithFormat:@"%@",dic[@"indexTextfield"]];
        
        if(dic[@"v13Label"])
            self.v13Label.text = [NSString stringWithFormat:@"%@",dic[@"v13Label"]];
        
        if(dic[@"v14Label"])
            self.v14Label.text = [NSString stringWithFormat:@"%@",dic[@"v14Label"]];
        
        if(dic[@"v15Label"])
            self.v15Label.text = [NSString stringWithFormat:@"%@",dic[@"v15Label"]];
        
        if(dic[@"v16Label"])
            self.v16Label.text = [NSString stringWithFormat:@"%@",dic[@"v16Label"]];
        
        if(dic[@"v17Label"])
            self.v17Label.text = [NSString stringWithFormat:@"%@",dic[@"v17Label"]];
        
        if(dic[@"v18Label"])
            self.v18Label.text = [NSString stringWithFormat:@"%@",dic[@"v18Label"]];
        
        if(dic[@"derrdoutSwitch"])
            self.derrdoutSwitch.on = [dic[@"derrdoutSwitch"] boolValue];
        
        if(dic[@"dwvSwitch"])
            self.dwvSwitch.on = [dic[@"dwvSwitch"] boolValue];
        
        if(dic[@"deltaruleSwitch"])
            self.deltaruleSwitch.on = [dic[@"deltaruleSwitch"] boolValue];
        
        if(dic[@"dnetdwSwitch"])
            self.dnetdwSwitch.on = [dic[@"dnetdwSwitch"] boolValue];
        
        if(dic[@"doutdnetSwitch"])
            self.doutdnetSwitch.on = [dic[@"doutdnetSwitch"] boolValue];
        
        if(dic[@"logTextView"])
            self.logTextView.text = [NSString stringWithFormat:@"%@",dic[@"logTextView"]];
        
        
    }
}


- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
    if(textView == self.logTextView)
    {
        if([self.delegate respondsToSelector:@selector(beginEditCNN:WithName:)])
        {
            [self.delegate beginEditCNN:self WithName:@"logTextView"];
            NSLog(@"logTextView DidBeginEditing");
        }
    }
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    
    if(textView == self.logTextView)
    {
        if([self.delegate respondsToSelector:@selector(endEditCNN:WithName:andText:)])
        {
            [self.delegate endEditCNN:self WithName:@"logTextView" andText:textView.text];
            NSLog(@"logTextView DidEndEditing");
        }
    }
    
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if(textField == self.trainingCountTextField)
    {
        if([self.delegate respondsToSelector:@selector(beginEditCNN:WithName:)])
        {
            [self.delegate beginEditCNN:self WithName:@"trainingCountTextField"];
            NSLog(@"trainingCountTextField DidBeginEditing");
        }
    }
    
    if(textField == self.trainLoopTextfield)
    {
        if([self.delegate respondsToSelector:@selector(beginEditCNN:WithName:)])
        {
            [self.delegate beginEditCNN:self WithName:@"trainLoopTextfield"];
            NSLog(@"trainLoopTextfield DidBeginEditing");
        }
    }
    
    if(textField == self.indexTextfield)
    {
        if([self.delegate respondsToSelector:@selector(beginEditCNN:WithName:)])
        {
            [self.delegate beginEditCNN:self WithName:@"indexTextfield"];
            NSLog(@"indexTextfield DidBeginEditing");
        }
    }
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if(textField == self.trainingCountTextField)
    {
        if([self.delegate respondsToSelector:@selector(endEditCNN:WithName:andText:)])
        {
            [self.delegate endEditCNN:self WithName:@"trainingCountTextField" andText:textField.text];
            NSLog(@"trainingCountTextField DidEndEditing");
        }
    }
    
    if(textField == self.trainLoopTextfield)
    {
        if([self.delegate respondsToSelector:@selector(endEditCNN:WithName:andText:)])
        {
            [self.delegate endEditCNN:self WithName:@"trainLoopTextfield" andText:textField.text];
            NSLog(@"trainLoopTextfield DidEndEditing");
        }
    }
    
    if(textField == self.indexTextfield)
    {
        if([self.delegate respondsToSelector:@selector(endEditCNN:WithName:andText:)])
        {
            [self.delegate endEditCNN:self WithName:@"indexTextfield" andText:textField.text];
            NSLog(@"indexTextfield DidEndEditing");
        }
    }
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)keyboardShow:(NSNotification *)note
{
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyBoardHieght=keyBoardRect.size.height;
    
    
}

-(void)keyboardHide:(NSNotification *)note
{
    keyBoardHieght = 0;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UIButton*)buildButtonWith:(NSString*)title andAction:(SEL)action
{
    UIButton * button = [UIButton new];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor whiteColor];
    button.layer.borderColor = [UIColor blackColor].CGColor;
    button.layer.borderWidth = 1.0;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:0.9 green:0.7 blue:0.8 alpha:1.0] forState:UIControlStateHighlighted];
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    return button;
}


-(CGFloat)screenH
{
    
    if (self.view.bounds.size.width < self.view.bounds.size.height) {
        return self.view.bounds.size.height;
    }
    else
        return self.view.bounds.size.width;
}

-(CGFloat)screenW
{
    
    if (self.view.bounds.size.width < self.view.bounds.size.height) {
        return self.view.bounds.size.width;
    }
    else
        return self.view.bounds.size.height;
}
-(CGFloat)rateOfwidth
{
    CGFloat rate = self.view.bounds.size.width/375.0;
    return rate;
}
-(CGFloat)rateOfHeight
{
    CGFloat rate = self.view.bounds.size.height/667.0;
    return rate;
}
-(BOOL)islandScape
{
    if (self.view.bounds.size.width < self.view.bounds.size.height) {
        return NO;
    }
    else
        return YES;
}
@end




