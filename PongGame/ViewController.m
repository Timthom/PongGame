//
//  ViewController.m
//  PongGame
//
//  Created by Thomas on 2016-09-06.
//  Copyright © 2016 Thomas Månsson. All rights reserved.
//

#import "ViewController.h"
#import "BackgroundLayer.h"

@interface ViewController ()
@property (nonatomic) UIView *ball;
@property (nonatomic) UIView *paddle;
@property (nonatomic) UIView *paddleComputer;
@property (nonatomic) CGPoint speed;
#define ARC4RANDOM_MAX      0x100000000
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabelComputer;
@property (weak, nonatomic) IBOutlet UILabel *WinOrLoose;
@property (weak, nonatomic) IBOutlet UIButton *StartButton;
@property (nonatomic) int scoreCount;
@property (nonatomic) int scoreCountComputer;
@property (nonatomic) float speedIncrease;
@property (nonatomic) NSTimer *myTimer;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer2;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer3;




@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CAGradientLayer *bgLayer = [BackgroundLayer greyGradient];
    bgLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:bgLayer atIndex:0];
    
    
    // Hitta den exakta sökvägen till vår ljudfil hit_paddle.wav
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"hit_paddle" withExtension:@"wav"];
    
    // Skapa en ljudspelare som ska spela upp ljudet
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    
    // Förbered för att spela
    [self.audioPlayer prepareToPlay];
    
    // Hitta den exakta sökvägen till vår ljudfil hit_ground.wav
    NSURL *url2 = [[NSBundle mainBundle] URLForResource:@"hit_ground" withExtension:@"wav"];
    
    // Skapa en ljudspelare som ska spela upp ljudet
    self.audioPlayer2 = [[AVAudioPlayer alloc] initWithContentsOfURL:url2 error:nil];
    
    // Förbered för att spela
    [self.audioPlayer2 prepareToPlay];
    
    // Hitta den exakta sökvägen till vår ljudfil horn.wav
    NSURL *url3 = [[NSBundle mainBundle] URLForResource:@"horn" withExtension:@"wav"];
    
    // Skapa en ljudspelare som ska spela upp ljudet
    self.audioPlayer3 = [[AVAudioPlayer alloc] initWithContentsOfURL:url3 error:nil];
    
    // Förbered för att spela
    [self.audioPlayer3 prepareToPlay];
    
    [self buttonSetup:self.StartButton borderColor:[UIColor greenColor]];
    
    _scoreCount = 0;
    _scoreCountComputer = 0;
    
    self.ball = [[UIView alloc] initWithFrame:CGRectMake(100,100 , 32, 32)];
    [self ballSetup:self.ball borderColor:[UIColor yellowColor]];
    self.ball.backgroundColor = [UIColor greenColor];
    [self. view addSubview:self.ball];
    
    self.paddle = [[UIView alloc] initWithFrame:CGRectMake(150, self.view.frame.size.height -50, 120, 20)];
    self.paddle.backgroundColor = [UIColor purpleColor];
    [self. view addSubview:self.paddle];
    
    self.paddleComputer = [[UIView alloc] initWithFrame:CGRectMake(150, self.view.frame.size.height - self.view.frame.size.height + 50, 120, 20)];
    self.paddleComputer.backgroundColor = [UIColor redColor];
    [self. view addSubview:self.paddleComputer];
    
    [self StartButton];
    self.WinOrLoose.hidden = YES;
    self.ball.hidden = YES;
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
    [self.view addGestureRecognizer:panRecognizer];
}



- (void)onPan:(UIPanGestureRecognizer*)panRecognizer {
    CGPoint translation =[panRecognizer translationInView:self.view];
    
    self.paddle.center = CGPointMake(self.paddle.center.x + translation.x, self.paddle.center.y);
    
    [panRecognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    if (self.paddle.center.x < 60) {
        
        self.paddle.center = CGPointMake(60, self.paddle.center.y);
    }
    if (self.paddle.center.x > self.view.frame.size.width - 60) {
        
        self.paddle.center = CGPointMake(self.view.frame.size.width - 60, self.paddle.center.y);
    }
}


- (void)tick {
    [self computer];
    [self changeGradient];
    self.StartButton.hidden = YES;
    
    self.ball.center = CGPointMake(self.ball.center.x + self.speed.x,
                                   self.ball.center.y + self.speed.y);
    
    if(self.ball.frame.origin.x + self.ball.frame.size.width > self.view.frame.size.width || self.ball.frame.origin.x < abs(0)) {
        // Spela upp ljudet
        [self playSoundGround];
        self.speed = CGPointMake(-self.speed.x, self.speed.y);
    } else if(self.ball.frame.origin.y < abs(0)) {
        
        self.scoreCount++;
        [self playSoundGround];
        
        
        switch(self.scoreCount)
        {
                /* case 2 :
                 [self.myTimer invalidate];
                 self.myTimer = nil;
                 self.speedIncrease = 1.0 / 35.0;;
                 self.myTimer = [NSTimer scheduledTimerWithTimeInterval:_speedIncrease target:self selector:@selector(tick) userInfo:nil repeats:YES];
                 NSLog(@"The new number of speedIncrease 2 is: %f", _speedIncrease);
                 break;
                 case 4 :
                 
                 [self.myTimer invalidate];
                 self.myTimer = nil;
                 self.speedIncrease = 1.0 / 40.0;;
                 self.myTimer = [NSTimer scheduledTimerWithTimeInterval:_speedIncrease target:self selector:@selector(tick) userInfo:nil repeats:YES];
                 NSLog(@"The new number of speedIncrease 4 is: %f", _speedIncrease);
                 
                 break;*/
            case 6 :
                [self.myTimer invalidate];
                self.myTimer = nil;
                self.speedIncrease = 1.0 / 50.0;;
                self.myTimer = [NSTimer scheduledTimerWithTimeInterval:_speedIncrease target:self selector:@selector(tick) userInfo:nil repeats:YES];
                NSLog(@"The new number of speedIncrease 6 is: %f", _speedIncrease);
                break;
            case 8 :
                [self.myTimer invalidate];
                self.myTimer = nil;
                self.speedIncrease = 1.0 / 55.0;;
                self.myTimer = [NSTimer scheduledTimerWithTimeInterval:_speedIncrease target:self selector:@selector(tick) userInfo:nil repeats:YES];
                NSLog(@"The new number of speedIncrease 8 is: %f", _speedIncrease);
                break;
            case 10:
                [self.myTimer invalidate];
                self.myTimer = nil;
                self.speedIncrease = 1.0 / 60.0;;
                self.myTimer = [NSTimer scheduledTimerWithTimeInterval:_speedIncrease target:self selector:@selector(tick) userInfo:nil repeats:YES];
                NSLog(@"The new number of speedIncrease 10 is: %f", _speedIncrease);
                break;
            default :
                NSLog(@"The number of speedIncrease is same as default: %f", _speedIncrease);
        }
        
        // self.speed = CGPointMake(self.speed.x, -fabsf(self.speed.y));
        [self playSoundDuck];
        self.ball.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
        float x = ((float)arc4random() / ARC4RANDOM_MAX * (10- 5)) + 5;
        float y = ((float)arc4random() / ARC4RANDOM_MAX * (10- 5)) + 5;
        if (x == abs(0)) {
            x = 1;
        }
        if (y == abs(0)) {
            y = 1;
        }
        NSLog(@"The new number of x is: %f", x);
        NSLog(@"The new number of Y is: %f", y);
        
        [self.myTimer invalidate];
        self.myTimer = nil;
        self.myTimer = [NSTimer scheduledTimerWithTimeInterval:_speedIncrease target:self selector:@selector(tick) userInfo:nil repeats:YES];
        
        self.speed = CGPointMake(x, -y);
        
        
    } else if(self.ball.frame.origin.y > self.view.frame.size.height) {
        
        
        [self playSoundDuck];
        self.scoreCountComputer++;
        
        switch(self.scoreCountComputer)
        {
                /*  case 2 :
                 [self.myTimer invalidate];
                 self.myTimer = nil;
                 self.speedIncrease = 1.0 / 35.0;;
                 self.myTimer = [NSTimer scheduledTimerWithTimeInterval:_speedIncrease target:self selector:@selector(tick) userInfo:nil repeats:YES];
                 NSLog(@"The new number of speedIncrease 2 is: %f", _speedIncrease);
                 break;
                 case 4 :
                 
                 [self.myTimer invalidate];
                 self.myTimer = nil;
                 self.speedIncrease = 1.0 / 40.0;;
                 self.myTimer = [NSTimer scheduledTimerWithTimeInterval:_speedIncrease target:self selector:@selector(tick) userInfo:nil repeats:YES];
                 NSLog(@"The new number of speedIncrease 4 is: %f", _speedIncrease);
                 
                 break;*/
            case 6 :
                [self.myTimer invalidate];
                self.myTimer = nil;
                self.speedIncrease = 1.0 / 50.0;;
                self.myTimer = [NSTimer scheduledTimerWithTimeInterval:_speedIncrease target:self selector:@selector(tick) userInfo:nil repeats:YES];
                NSLog(@"The new number of speedIncrease 6 is: %f", _speedIncrease);
                break;
            case 8 :
                [self.myTimer invalidate];
                self.myTimer = nil;
                self.speedIncrease = 1.0 / 55.0;;
                self.myTimer = [NSTimer scheduledTimerWithTimeInterval:_speedIncrease target:self selector:@selector(tick) userInfo:nil repeats:YES];
                NSLog(@"The new number of speedIncrease 8 is: %f", _speedIncrease);
                break;
            case 10:
                [self.myTimer invalidate];
                self.myTimer = nil;
                self.speedIncrease = 1.0 / 60.0;;
                self.myTimer = [NSTimer scheduledTimerWithTimeInterval:_speedIncrease target:self selector:@selector(tick) userInfo:nil repeats:YES];
                NSLog(@"The new number of speedIncrease 10 is: %f", _speedIncrease);
                break;
            default :
                NSLog(@"The number of speedIncrease is same as default: %f", _speedIncrease);
        }
        
        self.ball.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
        float x = ((float)arc4random() / ARC4RANDOM_MAX * (10- 5)) + 5;
        float y = ((float)arc4random() / ARC4RANDOM_MAX * (10- 5)) + 5;
        if (x == abs(0)) {
            x = 1;
        }
        if (y == abs(0)) {
            y = 1;
        }
        NSLog(@"The new number of x is: %f", x);
        NSLog(@"The new number of Y is: %f", y);
        
        [self.myTimer invalidate];
        self.myTimer = nil;
        self.myTimer = [NSTimer scheduledTimerWithTimeInterval:_speedIncrease target:self selector:@selector(tick) userInfo:nil repeats:YES];
        
        self.speed = CGPointMake(x, y);
        
        
        
    }
    if(CGRectIntersectsRect(self.ball.frame, self.paddle.frame)) {
        [self playSoundPaddle];
        float x = ((float)arc4random() / ARC4RANDOM_MAX * (-10- 10)) + 10;
        if (x == abs(0)) {
            x = 1;
        }
        self.speed = CGPointMake(x, -fabs(self.speed.y));
    }
    if(CGRectIntersectsRect(self.ball.frame, self.paddleComputer.frame)) {
        [self playSoundPaddle];
        float x = ((float)arc4random() / ARC4RANDOM_MAX * (-10- 10)) + 10;
        if (x == abs(0)) {
            x = 1;
        }
        self.speed = CGPointMake(x, fabs(self.speed.y));
    }
    
    if (self.scoreCountComputer == 10) {
        [self.myTimer invalidate];
        self.myTimer = nil;
        self.ball.hidden = YES;
        self.StartButton.hidden = NO;
        self.WinOrLoose.hidden = NO;
        self.WinOrLoose.text = [NSString stringWithFormat:@"You Loose!"];
        
    }
    if (self.scoreCount == 10) {
        [self.myTimer invalidate];
        self.myTimer = nil;
        self.ball.hidden = YES;
        self.StartButton.hidden = NO;
        self.WinOrLoose.hidden = NO;
        self.WinOrLoose.text = [NSString stringWithFormat:@"You Win!"];
    }
    
}

-(void)computer {
    
    if (self.paddleComputer.center.x > self.ball.center.x) {
        
        self.paddleComputer.center = CGPointMake(self.paddleComputer.center.x - 2.75, self.paddleComputer.center.y);
    }
    if (self.paddleComputer.center.x < self.ball.center.x) {
        
        self.paddleComputer.center = CGPointMake(self.paddleComputer.center.x + 2.75, self.paddleComputer.center.y);
    }
    if (self.paddleComputer.center.x < 60) {
        
        self.paddleComputer.center = CGPointMake(60, self.paddleComputer.center.y);
    }
    if (self.paddleComputer.center.x > self.view.frame.size.width - 60) {
        
        self.paddleComputer.center = CGPointMake(self.view.frame.size.width - 60, self.paddleComputer.center.y);
    }
    
}


-(void)setScoreCount:(int)scoreCount
{
    _scoreCount = scoreCount;
    self.scoreLabel.text = [NSString stringWithFormat:@"Your Score: %d", self.scoreCount];
    
}

-(void)setScoreCountComputer:(int)scoreCountComputer
{
    _scoreCountComputer = scoreCountComputer;
    self.scoreLabelComputer.text = [NSString stringWithFormat:@"Score Computer: %d", self.scoreCountComputer];
    
}

-(void) changeGradient {
    
    CAGradientLayer *layerToRemove;
    for (CALayer *aLayer in self.view.layer.sublayers) {
        if ([aLayer isKindOfClass:[CAGradientLayer class]]) {
            layerToRemove = (CAGradientLayer *)aLayer;
        }
    }
    [layerToRemove removeFromSuperlayer];
    
    CAGradientLayer *bgLayer;
    if (self.scoreCount == self.scoreCountComputer) {
        bgLayer = [BackgroundLayer greyGradient];
    } else if (self.scoreCountComputer > self.scoreCount) {
        bgLayer = [BackgroundLayer blueGradient];
    } else if (self.scoreCount > self.scoreCountComputer) {
        bgLayer = [BackgroundLayer orangeGradient];
    }
    
    bgLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:bgLayer atIndex:0];
    
}
- (IBAction)startGame:(id)sender {
    self.scoreCount = 0;
    self.scoreCountComputer = 0;
    self.WinOrLoose.hidden = YES;
    self.StartButton.hidden = YES;
    self.ball.hidden = NO;
    
    //selecting random x and random y position for ball
    float x = ((float)arc4random() / ARC4RANDOM_MAX * (10- 5)) + 5;
    float y = ((float)arc4random() / ARC4RANDOM_MAX * (10- 5)) + 5;
    if (x == abs(0)) {
        x = 1;
    }
    if (y == abs(0)) {
        y = 1;
    }
    
    self.speed = CGPointMake(x, y);
    
    NSLog(@"The number of x is: %f", x);
    NSLog(@"The number of Y is: %f", y);
    
    self.speedIncrease = 1.0 / 45.0;
    
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:_speedIncrease target:self selector:@selector(tick) userInfo:nil repeats:YES];
    NSLog(@"The first number of speedIncrease is: %f", _speedIncrease);
    
}

- (void)buttonSetup:(UIButton *)StartButton borderColor:(UIColor *)borderColor
{
    StartButton.layer.cornerRadius = StartButton.bounds.size.width/2;
    StartButton.layer.borderWidth = 1.0f;
    StartButton.layer.borderColor =[borderColor CGColor];
    StartButton.clipsToBounds = true;
}

- (void)ballSetup:(UIView *)ball borderColor:(UIColor *)borderColor
{
    ball.layer.cornerRadius = ball.bounds.size.width/2;
    ball.layer.borderWidth = 2.0f;
    ball.layer.borderColor =[borderColor CGColor];
    ball.clipsToBounds = true;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - User interaction

- (void)playSoundPaddle {
    // Kolla om ljudet redan spelas
    if ([self.audioPlayer isPlaying]) {
        
        // Stoppa det då och sätt spelaren till att börja från början
        // av ljudfilen nästa gång den spelas
        [self.audioPlayer stop];
        self.audioPlayer.currentTime = 0;
    }
    
    // Spela ljudet!
    [self.audioPlayer play];
}



- (void)playSoundGround {
    // Kolla om ljudet redan spelas
    if ([self.audioPlayer2 isPlaying]) {
        
        // Stoppa det då och sätt spelaren till att börja från början
        // av ljudfilen nästa gång den spelas
        [self.audioPlayer2 stop];
        self.audioPlayer2.currentTime = 0;
    }
    
    // Spela ljudet!
    [self.audioPlayer2 play];
}



- (void)playSoundDuck {
    // Kolla om ljudet redan spelas
    if ([self.audioPlayer3 isPlaying]) {
        
        // Stoppa det då och sätt spelaren till att börja från början
        // av ljudfilen nästa gång den spelas
        [self.audioPlayer3 stop];
        self.audioPlayer3.currentTime = 0;
    }
    
    // Spela ljudet!
    [self.audioPlayer3 play];
}



@end

