//
//  TPGameCodeBreakerViewController.m
//  TidePoolTwo
//
//  Created by Mayank Sanganeria on 1/31/14.
//  Copyright (c) 2014 TidePool. All rights reserved.
//

#import "TPRansomStageViewController.h"
#import "TPLetterView.h"
#import "TPFontButton.h"

@interface TPRansomStageViewController ()
{
  NSMutableArray *_letters;
  NSMutableArray *_chosenLetters;
  UIView *_chosenLettersContainer;
  NSMutableSet *_submittedWords;
}
@end

@implementation TPRansomStageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  _letters = [@[] mutableCopy];
  _chosenLetters = [@[] mutableCopy];
  _submittedWords = [NSMutableSet set];
}

-(void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  float width = 50;
  float height = 50;
  
  _chosenLettersContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 65)];
  _chosenLettersContainer.backgroundColor = [UIColor darkAsphaltColor];
  
  [self.view addSubview:_chosenLettersContainer];
  
  NSString *allLetters = [self genLetters];
  for (int i=0; i<self.numberOfColumns; i++) {
    for (int j=0; j<self.numberOfRows; j++) {
      int spaceBetweenLetters = 10;
      int x = self.view.bounds.size.width/2 + (width + spaceBetweenLetters / 2) * (i - self.numberOfColumns / 2.0);
      int y = self.view.bounds.size.height/2 + (height + spaceBetweenLetters / 2) * (j - self.numberOfRows / 2.0);
      TPLetterView *circle = [[TPLetterView alloc] initWithFrame:CGRectMake(x, y, width, height)];
      UIView *letterBackgroundContainer = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
      letterBackgroundContainer.backgroundColor = [UIColor darkAsphaltColor];
      letterBackgroundContainer.layer.cornerRadius = letterBackgroundContainer.bounds.size.width/2;
      [self.view addSubview:letterBackgroundContainer];
      UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
      circle.letter = [allLetters substringWithRange:NSMakeRange(i*self.numberOfColumns + j, 1)];
      [circle addGestureRecognizer:tap];
      [_letters addObject:circle];
    }
  }
  double maxDelay;
  for (int i=0;i<[_letters count]; i++) {
    TPLetterView *circle = _letters[i];
    double delayInSeconds = 0.5 + 0.2*(i%self.numberOfRows);
    maxDelay = delayInSeconds;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
      [circle buildInBounce];
      [self.view addSubview:circle];
    });
  }
  //    self.buttonContainer.transform = CGAffineTransformMakeTranslation(0, -300);
  [self.cancelButton addTarget:self action:@selector(clearLetters) forControlEvents:UIControlEventTouchUpInside];
  [self.submitButton addTarget:self action:@selector(checkWord) forControlEvents:UIControlEventTouchUpInside];
  
  self.appDelegate = [[UIApplication sharedApplication] delegate];
  self.buttonContainer = [[UIView alloc] initWithFrame:CGRectMake(0, -91, self.view.bounds.size.width, 91)];
  self.buttonContainer.backgroundColor = [UIColor asphaltColor];
  [self.appDelegate.window addSubview:self.buttonContainer];

  float statusBarOffset = 20;
  self.cancelButton = [[TPFontButton alloc] initWithFrame:CGRectMake(0, statusBarOffset, 160, self.buttonContainer.frame.size.height-statusBarOffset)];
  [self.cancelButton setTitle:@"CLEAR ALL" forState:UIControlStateNormal];
  [self.cancelButton addTarget:self action:@selector(clearLetters) forControlEvents:UIControlEventTouchUpInside];
  [self.buttonContainer addSubview:self.cancelButton];

  float submitButtonHeight = 50;
  float submitButtonWidth = 120;
  self.submitButton = [[TPFontButton alloc] initWithFrame:CGRectMake(160 + (160 - submitButtonWidth) / 2,statusBarOffset + (self.buttonContainer.frame.size.height - statusBarOffset - submitButtonHeight)/2, submitButtonWidth, submitButtonHeight)];
  [self.submitButton setTitle:@"SUBMIT" forState:UIControlStateNormal];
  self.submitButton.backgroundColor = [UIColor whiteColor];
  self.submitButton.titleLabel.textColor = self.buttonContainer.backgroundColor;
  [self.submitButton addTarget:self action:@selector(checkWord) forControlEvents:UIControlEventTouchUpInside];
  self.submitButton.layer.cornerRadius = self.submitButton.frame.size.height/2;
  [self.buttonContainer addSubview:self.submitButton];

}
-(void)clearLetters
{
  for (int i=(int)_chosenLetters.count-1;i>=0;i--) {
    TPLetterView *letter = _chosenLetters[i];
    [self moveLetterBetweenGridAndChosenWord:letter];
  }
  [self refreshChosenLetters];
}

-(void)checkWord
{
  NSString *submittedWord = @"";
  for (TPLetterView *letter in _chosenLetters) {
    submittedWord = [NSString stringWithFormat:@"%@%@", submittedWord, letter.letter];
  }
  BOOL isWord = [self isDictionaryWord:submittedWord];
  BOOL isNewWord = ![_submittedWords containsObject:submittedWord];
  BOOL isValid = isWord && isNewWord;
  [self showResultGraphicCorrect:isValid];
  if (isValid) {
    self.gameVC.score +=  (int)submittedWord.length * ([self scrabbleScore:submittedWord]);
    [self clearLetters];
    [_submittedWords addObject:submittedWord];
  }
}

-(int)scrabbleScore:(NSString * )word
{
  int score = 0;
  static char EnglishScoreTable[26] = { 1, 3, 3, 2, 1, 4, 2, 4, 1, 8, 5, 1, 3, 1, 1, 3, 10, 1, 1, 1, 1, 4, 4, 8, 4, 10 };
  NSArray *wordArray = [word componentsSeparatedByString:@""];
  for (NSString *letter in wordArray)
  {
    char Letter = [letter characterAtIndex:0];
    if (Letter >= 'a' && Letter <= 'z')
    {
      score += EnglishScoreTable[Letter - 'a'];
    }
    else
    {
      // error in input
    }
  }
  return score;
}


-(BOOL) isDictionaryWord:(NSString*) word
{
  UITextChecker *checker = [[UITextChecker alloc] init];
  NSLocale *currentLocale = [NSLocale currentLocale];
  NSString *currentLanguage = [currentLocale objectForKey:NSLocaleLanguageCode];
  NSRange searchRange = NSMakeRange(0, [word length]);
  NSRange misspelledRange = [checker rangeOfMisspelledWordInString:word range: searchRange startingAt:0 wrap:NO language: currentLanguage ];
  return misspelledRange.location == NSNotFound;
}


-(void)showButtons
{
    [UIView animateWithDuration:0.2 animations:^{
        self.buttonContainer.transform = CGAffineTransformMakeTranslation(0, self.buttonContainer.bounds.size.height);
    }];
}

-(void)hideButtons
{
    [UIView animateWithDuration:0.2 animations:^{
      self.buttonContainer.transform = CGAffineTransformIdentity;
    }];
}

-(void)handleTap:(UITapGestureRecognizer *)sender
{
  TPLetterView *letter = (TPLetterView *)sender.view;
  [self moveLetterBetweenGridAndChosenWord:letter];
}

-(void)moveLetterBetweenGridAndChosenWord:(TPLetterView *)letter
{
  if ([_chosenLetters containsObject:letter]) {
    letter.isPartOfWord = NO;
    [_chosenLetters removeObject:letter];
    [UIView animateWithDuration:0.2 animations:^{
      letter.transform = CGAffineTransformIdentity;
    }];
    [self refreshChosenLetters];
  } else {
    letter.isPartOfWord = YES;
    [_chosenLetters addObject:letter];
    [self refreshChosenLetters];
  }
}

-(void)refreshChosenLetters
{
  [UIView animateWithDuration:0.2 animations:^{
    for (int i=0; i<_chosenLetters.count; i++) {
      TPLetterView *letter = _chosenLetters[i];
      float idealWidth = fminf(320 / _chosenLetters.count, letter.bounds.size.width);
      float scale = idealWidth / 50;
      if (scale < 1/1.3) {
        scale *= 1.3;
      }
      float offset = -((int)_chosenLetters.count-1)/2.0 + i;
      CGPoint idealPoint = CGPointMake(160 + (idealWidth) * offset, _chosenLettersContainer.center.y);
      CGPoint diff = CGPointMake(idealPoint.x - letter.center.x, idealPoint.y - letter.center.y);
      letter.transform = CGAffineTransformMakeTranslation(diff.x, diff.y);
      letter.transform = CGAffineTransformScale(letter.transform, scale, 1);
    }
  }];
  if (!_chosenLetters.count) {
    [self hideButtons];
  } else {
    [self showButtons];
  }
}

-(NSString *) genRandStringLength: (int) len {
  NSString *letters = @"abcdefghijklmnopqrstuvwxyz";
  NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
  for (int i=0; i<len; i++) {
    [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
  }
  return randomString;
}


-(void)buildOutAndProceed:(BOOL)proceed
{
  for (int i=0;i<[_letters count]; i++) {
    TPLetterView *circle = _letters[i];
    [circle buildOutBounce];
  }
  //    [_letters removeAllObjects];
  double delayInSeconds = 1;
  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
  dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    [self.gameVC currentStageOverProceed:proceed];
  });
}

-(NSString *)genLetters
{
  NSArray *places = @[@"paris", @"london", @"milan", @"manchester"];
  NSString *vowels = @"aeiou";
  NSString *consonants = @"bcdfghjklmnpqrstvwxyz";
  NSString *gen;
  // add place
  gen = places[arc4random()%places.count];
  for (int i=0;i<3;i++) {
    gen = [NSString stringWithFormat:@"%@%@",gen,[vowels substringWithRange:NSMakeRange(arc4random()%vowels.length, 1)]];
  }
  int remainingLength = self.numberOfRows*self.numberOfColumns - (int)[gen length];
  for (int i=0;i<remainingLength;i++) {
    gen = [NSString stringWithFormat:@"%@%@",gen,[consonants substringWithRange:NSMakeRange(arc4random()%consonants.length, 1)]];
  }
  return [self scrambleString:gen];
}

-(NSString *)scrambleString:(NSString *)toScramble {
  for (int i = 0; i < [toScramble length] * 15; i ++) {
    int pos = arc4random() % [toScramble length];
    int pos2 = arc4random() % ([toScramble length] - 1);
    char ch = [toScramble characterAtIndex:pos];
    NSString *before = [toScramble substringToIndex:pos];
    NSString *after = [toScramble substringFromIndex:pos + 1];
    NSString *temp = [before stringByAppendingString:after];
    before = [temp substringToIndex:pos2];
    after = [temp substringFromIndex:pos2];
    toScramble = [before stringByAppendingFormat:@"%c%@", ch, after];
  }
  return toScramble;
}


-(void)adjustScoreForCorrect:(BOOL)correct
{
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}


-(void)pauseStage
{
  
}

-(void)resumeStage
{
  
}


@end
