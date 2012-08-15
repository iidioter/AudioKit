//
//  ToneGenerator.m
//  Objective-C Sound Example
//
//  Created by Aurelius Prochazka on 6/9/12.
//  Copyright (c) 2012 Hear For Yourself. All rights reserved.
//

#import "ToneGenerator.h"
#import "OCSSineTable.h"
#import "OCSOscillator.h"
#import "OCSAudio.h"

@interface ToneGenerator () {
    OCSParameter *auxilliaryOutput;
}
@end

@implementation ToneGenerator

@synthesize frequency;
@synthesize auxilliaryOutput;

- (id)init
{
    self = [super init];
    
    if (self) {       
        // INPUTS ==============================================================
        
        frequency  = [[OCSInstrumentProperty alloc] initWithValue:220 minValue:kFrequencyMin  maxValue:kFrequencyMax];
        [frequency setControl:[OCSControl parameterWithString:@"InputFrequency"]]; 
        [self addProperty:frequency];
        
        // INSTRUMENT DEFINITION ===============================================
        
        OCSSineTable *sine = [[OCSSineTable alloc] init];
        [sine setIsNormalized:YES];
        [self addFTable:sine];
        
        OCSOscillator *oscillator;
        oscillator = [[OCSOscillator alloc] initWithFTable:sine
                                                 frequency:[frequency control]
                                                 amplitude:ocsp(0.4)];
        [self addOpcode:oscillator];
        
        // AUDIO OUTPUT ========================================================
        
        OCSAudio *audio = [[OCSAudio alloc] initWithMonoInput:[oscillator output]]; 
        [self addOpcode:audio];
        
        
        // EXTERNAL OUTPUTS ====================================================        
        // After your instrument is set up, define outputs available to others
        auxilliaryOutput = [OCSParameter globalParameterWithString:@"ToneGeneratorOutput"];
        [self assignOutput:auxilliaryOutput To:[oscillator output]];
    }
    return self;
}

@end