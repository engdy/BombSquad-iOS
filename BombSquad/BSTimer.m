//
//  BSTimer.m
//  BombSquad
//
//  Created by Andrew Foulke on 7/17/13.
//  Copyright (c) 2013 Keltner. All rights reserved.
//

#import <sys/time.h>
#import "BSTimer.h"
#import "RunningMissionVC.h"

@interface BSTimer () <AVAudioPlayerDelegate>

@end

@implementation BSTimer

@synthesize timer = _timer, isTimerRunning = _isTimerRunning, isPlayingCountdown = _isPlayingCountdown, startMillis = _startMillis, elapsedMillis = _elapsedMillis, bombs = _bombs, willPlaySoundtrack = _willPlaySoundtrack, willPlayBombSounds = _willPlayBombSounds, willPlayCountdown = _willPlayCountdown, backgroundPlayer = _backgroundPlayer, smallBombPlayer = _smallBombPlayer, bigBombPlayer = _bigBombPlayer, countdownPlayer = _countdownPlayer;

- (BSTimer *)init {
    _timer = nil;
    _isTimerRunning = NO;
    _isPlayingCountdown = NO;
    _startMillis = 0;
    _elapsedMillis = 0;
    _bombs = [[BombList alloc] init];
    _willPlaySoundtrack = NO;
    _willPlayBombSounds = NO;
    _willPlayCountdown = NO;
    _backgroundPlayer = nil;
    _smallBombPlayer = nil;
    _bigBombPlayer = nil;
    _countdownPlayer = nil;
    return self;
}

- (void)enableSoundtrack:(BOOL)willPlaySoundtrack withResourceName:(NSString *)name volume:(CGFloat)volume {
    _willPlaySoundtrack = willPlaySoundtrack;
    if (_willPlaySoundtrack && [name length] > 0) {
        NSString *soundPath = [[NSBundle mainBundle] pathForResource:name ofType:@"m4a"];
        NSURL *url = [NSURL fileURLWithPath:soundPath];
        NSError *err = nil;
        _backgroundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&err];
        [_backgroundPlayer setNumberOfLoops:-1];
        [_backgroundPlayer setVolume:volume];
        [_backgroundPlayer prepareToPlay];
    }
    self.musicVolume = volume;
}

- (void)enableBombSounds:(BOOL)willPlayBombSounds volume:(CGFloat)volume {
    _willPlayBombSounds = willPlayBombSounds;
    if (_willPlayBombSounds) {
        NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"smallbomb" ofType:@"m4a"];
        NSURL *url = [NSURL fileURLWithPath:soundPath];
        NSError *err = nil;
        _smallBombPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&err];
        [_smallBombPlayer setVolume:volume];
        [_smallBombPlayer prepareToPlay];
        soundPath = [[NSBundle mainBundle] pathForResource:@"bigbomb" ofType:@"m4a"];
        url = [NSURL fileURLWithPath:soundPath];
        err = nil;
        _bigBombPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&err];
        [_bigBombPlayer setVolume:volume];
        [_bigBombPlayer prepareToPlay];
    } else {
        _smallBombPlayer = nil;
        _bigBombPlayer = nil;
    }
    self.bombVolume = volume;
}

- (void)enableCountdown:(BOOL)willPlayCountdown {
    _willPlayCountdown = willPlayCountdown;
    if (_willPlayCountdown) {
        NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"countdown" ofType:@"m4a"];
        NSURL *url = [NSURL fileURLWithPath:soundPath];
        NSError *err = nil;
        _countdownPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&err];
        [_countdownPlayer setVolume:1.0];
        [_countdownPlayer prepareToPlay];
        _countdownPlayer.delegate = self;
    } else {
        _countdownPlayer = nil;
    }
}

- (NSInteger)getNow {
    struct timeval time;
    gettimeofday(&time, NULL);
    return (time.tv_sec * 1000) + (time.tv_usec / 1000);
}

- (void)startTimer {
    if (_isTimerRunning) {
        return;
    }
    NSLog(@"Timer starting");
    _isTimerRunning = YES;
    _startMillis = [self getNow];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];

}

- (void)timerTick:(NSTimer *)timer {
    if (self.currentVC != nil) {
        NSInteger now = [self getNow];
        NSInteger duration = self.elapsedMillis + now - self.startMillis;
        Bomb *longestBomb = [self.bombs findMaxTimeBomb];
        if (longestBomb != nil) {
            [(RunningMissionVC *)self.currentVC updateMainTime:[longestBomb timeLeftFromElapsed:duration]];
        } else {
            [self stopTimer];
            [self stopMusic];
        }
        for (NSInteger i = 0; i < [self.bombs.bombs count]; ++i) {
            Bomb *b = [self.bombs.bombs objectAtIndex:i];
            if (b.state == LIVE) {
                if (duration > b.durationMillis) {
                    NSLog(@"Bomb %@ blew up!", [b asString]);
                    b.state = DETONATED;
                    [(RunningMissionVC *)self.currentVC updateBomb:b idx:i duration:-1];
                    if (self.willPlayBombSounds) {
                        switch (b.level) {
                            case 1:
                            case 2:
                                if (self.smallBombPlayer.playing) {
                                    self.smallBombPlayer.currentTime = 0;
                                }
                                [self.smallBombPlayer play];
                                break;
                                
                            case 3:
                                if (self.bigBombPlayer.playing) {
                                    self.bigBombPlayer.currentTime = 0;
                                }
                                [self.bigBombPlayer play];
                                break;
                                
                            default:
                                break;
                        }
                    }
                } else {
                    [(RunningMissionVC *)self.currentVC updateBomb:b idx:i duration:duration];
                }
            }
        }
        if (!_isPlayingCountdown && _willPlayCountdown) {
            Bomb *b = [self.bombs findMinTimeBomb];
            if (b != nil) {
                NSInteger timeToBomb = b.durationMillis - duration;
                if (timeToBomb < 10000) {
                    _isPlayingCountdown = YES;
                    NSTimeInterval ctime = (10000 - timeToBomb) / 1000;
                    _countdownPlayer.currentTime = ctime;
                    [_countdownPlayer play];
                    NSLog(@"Bomb %@ playing countdown from %f", b, ctime);
                }
            }
        }
    } else {
        NSLog(@"Tick!");
    }
}

- (void)stopTimer {
    if (!_isTimerRunning) {
        return;
    }
    if (_timer != nil) {
        [_timer invalidate];
        _timer = nil;
    }
    _isTimerRunning = NO;
    _elapsedMillis += [self getNow] - _startMillis;
    if (_isPlayingCountdown) {
        _isPlayingCountdown = NO;
        [_countdownPlayer stop];
    }
}

- (void)startMusic {
    if (_willPlaySoundtrack && _backgroundPlayer != nil) {
        [_backgroundPlayer play];
    }
}

- (void)stopMusic {
    if (_backgroundPlayer != nil) {
        [_backgroundPlayer stop];
    }
}

- (void)adjustMusicVolume:(CGFloat)volume {
    self.musicVolume = volume;
    if ([_backgroundPlayer isPlaying]) {
        [_backgroundPlayer setVolume:volume];
    }
}

- (void)adjustBombVolume:(CGFloat)volume {
    self.bombVolume = volume;
    [_smallBombPlayer setVolume:volume];
    [_bigBombPlayer setVolume:volume];
}

- (BOOL)isPlayingSoundtrack {
    return [_backgroundPlayer isPlaying];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    _isPlayingCountdown = NO;
}

@end
