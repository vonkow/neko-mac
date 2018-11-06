#import "MyPanel.h"
#include <stdlib.h>

@implementation MyPanel
- (void)setStateTo:(id)theState
{
	if(nekoState == theState)
		return;
	//printf("state %d\n", theState);
	tickCount = 0;
	stateCount = 0;
	nekoState = theState;
	[self flushWindow];
}

- (id)initWithContentRect:(NSRect)contentRect styleMask:(NSWindowStyleMask)styleMask backing:(NSBackingStoreType)bufferingType defer:(BOOL)deferCreation
{
	self = [super initWithContentRect:contentRect styleMask:NSBorderlessWindowMask backing:bufferingType defer:deferCreation];
	[self setBecomesKeyOnlyIfNeeded:YES];
	[self setLevel:NSStatusWindowLevel];
	[self setOpaque:NO];
	[self setCanHide:NO];
	[self setIgnoresMouseEvents:YES];
	[self setMovableByWindowBackground:NO];
	[self setFrame:NSMakeRect(0.0f, 0.0f, 32.0f, 32.0f) display:0];
	[self center];
	[self setBackgroundColor:[NSColor clearColor]];
	[self useOptimizedDrawing:YES];
	NSBundle *bundle = [NSBundle mainBundle];
	
	stop = [NSArray arrayWithObjects:
		[[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"mati2" ofType:@"gif"]], nil];
	[stop retain];
	jare = [NSArray arrayWithObjects:
		[[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"jare2" ofType:@"gif"]],
		[[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"mati2" ofType:@"gif"]], nil];
	[jare retain];
	kaki = [NSArray arrayWithObjects:
		[[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"kaki1" ofType:@"gif"]],
		[[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"kaki2" ofType:@"gif"]], nil];
	[kaki retain];
	akubi = [NSArray arrayWithObjects:
		[[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"mati3" ofType:@"gif"]], nil];
	[akubi retain];
	sleep = [NSArray arrayWithObjects:
		[[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"sleep1" ofType:@"gif"]],
		[[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"sleep2" ofType:@"gif"]], nil];
	[sleep retain];
	awake = [NSArray arrayWithObjects:
		[[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"awake" ofType:@"gif"]], nil];
	[awake retain];
	u_move = [NSArray arrayWithObjects:
		[[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"up1" ofType:@"gif"]],
		[[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"up2" ofType:@"gif"]], nil];
	[u_move retain];
	d_move = [NSArray arrayWithObjects:
		[[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"down1" ofType:@"gif"]],
		[[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"down2" ofType:@"gif"]], nil];
	[d_move retain];
	l_move = [NSArray arrayWithObjects:
		[[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"left1" ofType:@"gif"]],
		[[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"left2" ofType:@"gif"]], nil];
	[l_move retain];
	r_move = [NSArray arrayWithObjects:
		[[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"right1" ofType:@"gif"]],
		[[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"right2" ofType:@"gif"]], nil];
	[r_move retain];
	ul_move = [NSArray arrayWithObjects:
		[[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"upleft1" ofType:@"gif"]],
		[[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"upleft2" ofType:@"gif"]], nil];
	[ul_move retain];
	ur_move = [NSArray arrayWithObjects:
		[[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"upright1" ofType:@"gif"]],
		[[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"upright2" ofType:@"gif"]], nil];
	[ur_move retain];
	dl_move = [NSArray arrayWithObjects:
		[[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"dwleft1" ofType:@"gif"]],
		[[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"dwleft2" ofType:@"gif"]], nil];
	[dl_move retain];
	dr_move = [NSArray arrayWithObjects:
		[[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"dwright1" ofType:@"gif"]],
		[[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"dwright2" ofType:@"gif"]], nil];
	[dr_move retain];
	u_togi = [NSArray arrayWithObjects:
		[[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"utogi1" ofType:@"gif"]],
		[[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"utogi2" ofType:@"gif"]], nil];
	[u_togi retain];
	d_togi = [NSArray arrayWithObjects:
		[[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"dtogi1" ofType:@"gif"]],
		[[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"dtogi2" ofType:@"gif"]], nil];
	[d_togi retain];
	l_togi = [NSArray arrayWithObjects:
		[[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"ltogi1" ofType:@"gif"]],
		[[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"ltogi2" ofType:@"gif"]], nil];
	[l_togi retain];
	r_togi = [NSArray arrayWithObjects:
		[[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"rtogi1" ofType:@"gif"]],
		[[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"rtogi2" ofType:@"gif"]], nil];
	[r_togi retain];
	
	[self setStateTo:stop];
	
	[NSTimer scheduledTimerWithTimeInterval:0.125f target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
	return self;
}

- (void)calcDxDyForX:(float)x Y:(float)y
{
	float		MouseX, MouseY;
	float		DeltaX, DeltaY;
	float		Length;
	
	NSPoint p = [NSEvent mouseLocation];
	MouseX = p.x;
	MouseY = p.y;
	
	DeltaX = floor(MouseX - x - 16.0f);
	DeltaY = floor(MouseY - y);
	
	Length = hypotf(DeltaX, DeltaY);
	
	if (Length != 0.0f) {
		if (Length <= 13.0f) {
			moveDx = DeltaX;
			moveDy = DeltaY;
		} else {
			moveDx = (13.0f * DeltaX) / Length;
			moveDy = (13.0f * DeltaY) / Length;
		}
	} else {
		moveDx = moveDy = 0.0f;
	}
}

- (BOOL)isNekoMoveStart
{
	return moveDx > 6 || moveDx < -6 || moveDy > 6 || moveDy < -6;
}

- (void)advanceClock
{
	if (++tickCount >= 255) {
		tickCount = 0;
    }
	
    if (tickCount % 2 == 0) {
		if (stateCount < 255) {
			stateCount++;
		}
    }
}

- (void)NekoDirection
{
    id			NewState;
    double		LargeX, LargeY;
    double		Length;
    double		SinTheta;
	
    if (moveDx == 0.0f && moveDy == 0.0f) {
		NewState = stop;
    } else {
		LargeX = (double)moveDx;
		LargeY = (double)moveDy;
		Length = sqrt(LargeX * LargeX + LargeY * LargeY);
		SinTheta = LargeY / Length;
		//printf("SinTheta = %f\n", SinTheta);
		
		if (moveDx > 0) {
			if (SinTheta > 0.9239) {
				NewState = u_move;
                                currentDirection = u_move;
			} else if (SinTheta > 0.3827) {
				NewState = ur_move;
                                currentDirection = u_move;
			} else if (SinTheta > -0.3827) {
				NewState = r_move;
                                currentDirection = r_move;
			} else if (SinTheta > -0.9239) {
				NewState = dr_move;
                                currentDirection = r_move;
			} else {
				NewState = d_move;
                                currentDirection = d_move;
			}
		} else {
			if (SinTheta > 0.9239) {
				NewState = u_move;
                                currentDirection = u_move;
			} else if (SinTheta > 0.3827) {
				NewState = ul_move;
                                currentDirection = l_move;
			} else if (SinTheta > -0.3827) {
				NewState = l_move;
                                currentDirection = l_move;
			} else if (SinTheta > -0.9239) {
				NewState = dl_move;
                                currentDirection = d_move;
			} else {
				NewState = d_move;
                                currentDirection = d_move;
			}
		}
    }
	
    [self setStateTo:NewState];
}

- (void)handleTimer:(NSTimer*)timer
{
	float x = [self frame].origin.x;
	float y = [self frame].origin.y;
	//printf("paint %d %d\n", time(NULL), tickCount % [nekoState count]);
	
	[self calcDxDyForX:x Y:y];
	BOOL isNekoMoveStart = [self isNekoMoveStart];
	
    if(nekoState != sleep) {
		[view setImageTo:(NSImage*)[nekoState objectAtIndex:tickCount % [nekoState count]]];
    } else {
		[view setImageTo:(NSImage*)[nekoState objectAtIndex:(tickCount>>2) % [nekoState count]]];
    }
	
	[self advanceClock];
	
    if(nekoState == stop) {
		if (isNekoMoveStart) {
			[self setStateTo:awake];
			goto breakout;
		}
		if (stateCount < 4) {
			goto breakout;
		}
                if (arc4random_uniform(2) < 1) {
					[self setStateTo:jare];
                } else if (currentDirection == l_move) {
                    [self setStateTo:l_togi];
		} else if (currentDirection == r_move) {
			[self setStateTo:r_togi];
		} else if (currentDirection == u_move) {
			[self setStateTo:u_togi];
		} else if (currentDirection == d_move) {
			[self setStateTo:d_togi];
		} else {
                  [self setStateTo:jare];
		}
	} else if(nekoState == jare) {
		if (isNekoMoveStart) {
			[self setStateTo:awake];
			goto breakout;
		}
		if (stateCount < 10) {
			goto breakout;
		}
		[self setStateTo:kaki];
	} else if(nekoState == kaki) {
		if (isNekoMoveStart) {
			[self setStateTo:awake];
			goto breakout;
		}
		if (stateCount < 4) {
			goto breakout;
		}
		[self setStateTo:akubi];
	} else if(nekoState == akubi) {
		if (isNekoMoveStart) {
			[self setStateTo:awake];
			goto breakout;
		}
		if (stateCount < 6) {
			goto breakout;
		}
		[self setStateTo:sleep];
	} else if(nekoState == sleep) {
		if (isNekoMoveStart) {
			[self setStateTo:awake];
			goto breakout;
		}
	} else if(nekoState == awake) {
		if (stateCount < 3) {
			goto breakout;
		}
		[self NekoDirection];	/* 猫が動く向きを求める */
	} else if(nekoState == u_move || nekoState == d_move || nekoState == l_move || nekoState == r_move || nekoState == ul_move || nekoState == ur_move || nekoState == dl_move || nekoState == dr_move) {
		x += moveDx;
		y += moveDy;
		[self NekoDirection];
	} else if(nekoState == u_togi || nekoState == d_togi || nekoState == l_togi || nekoState == r_togi) {
		if (isNekoMoveStart) {
			[self setStateTo:awake];
			goto breakout;
		}
		if (stateCount < 10) {
			goto breakout;
		}
		[self setStateTo:akubi];
	} else {
		/* Internal Error */
		[self setStateTo:stop];
	}

	breakout:
	[view displayIfNeeded];
	[self setFrameOrigin:NSMakePoint(x, y)];
}
@end
