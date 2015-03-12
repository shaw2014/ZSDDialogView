# ZSDDialogView
自定义提示框，类似系统alertview

特点：
采用自动布局设计，block回调方式，此版本只支持最多2个按钮。

用法：
调用[[CustomDialogView alloc]initWithTitle:@"" message:@"" buttonTitles:@"" ,然后调用showInView:completion: 或者showWithCompletion:  方法显示弹框。  一个view默认只显示一个弹框，若要二次弹框甚至更多，可以设置seriesAlert为YES.
