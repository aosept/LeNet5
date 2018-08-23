
#import <UIKit/UIKit.h>


@class CNN;
@class SVChartView;
@class SVGridView;
@protocol SVGridViewDelegate;


@protocol CNNDelegate <NSObject>

-(void)updateCNN:(CNN*)vc WithDic:(NSDictionary*)dic;


-(void)buttonOfCNN:(CNN*)vc DidClickedWithName:(NSString*)name;

-(void)changeCNN:(CNN*)vc WithName:(NSString*)name andValue:(CGFloat)value;

-(void)beginEditCNN:(CNN*)vc WithName:(NSString*)name;
-(void)endEditCNN:(CNN*)vc WithName:(NSString*)name andText:(NSString*)text;

@end
@interface CNN : UIViewController <UITextFieldDelegate,UITextViewDelegate,SVGridViewDelegate>
{
    CGFloat offsetY;
    CGFloat keyBoardHieght;
}
@property (nonatomic,weak) id <CNNDelegate> delegate;

@property (nonatomic,strong) SVChartView * dataChartView;

@property (nonatomic,strong) UIButton * runButton;

@property (nonatomic,strong) SVGridView * v1GridView;

@property (nonatomic,strong) SVGridView * v3Gridview;

@property (nonatomic,strong) SVGridView * v2Gridview;

@property (nonatomic,strong) SVGridView * v4Gridview;

@property (nonatomic,strong) UILabel * v7Label;

@property (nonatomic,strong) UITextField * trainingCountTextField;

@property (nonatomic,strong) UILabel * v9Label;

@property (nonatomic,strong) UILabel * index;

@property (nonatomic,strong) UITextField * trainLoopTextfield;

@property (nonatomic,strong) UITextField * indexTextfield;

@property (nonatomic,strong) UILabel * v13Label;

@property (nonatomic,strong) UILabel * v14Label;

@property (nonatomic,strong) UILabel * v15Label;

@property (nonatomic,strong) UILabel * v16Label;

@property (nonatomic,strong) UILabel * v17Label;

@property (nonatomic,strong) UILabel * v18Label;

@property (nonatomic,strong) UISwitch * derrdoutSwitch;

@property (nonatomic,strong) UISwitch * dwvSwitch;

@property (nonatomic,strong) UISwitch * deltaruleSwitch;

@property (nonatomic,strong) UISwitch * dnetdwSwitch;

@property (nonatomic,strong) UISwitch * doutdnetSwitch;

@property (nonatomic,strong) UITextView * logTextView;

@property (nonatomic,strong) SVGridView * v5Gridview;

@property (nonatomic,strong) SVGridView * v6Gridview;

@property (nonatomic,strong) SVGridView * v7Gridview;

@property (nonatomic,strong) UIScrollView * scrollView;
-(void)refreshFromDiction:(NSDictionary*)dic;
-(NSDictionary*)configSetting;
@end

