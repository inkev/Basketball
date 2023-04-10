:- use_module(library(pce)).
:- use_module(library(pce_util)).

main :-
    new(Dialog, dialog('Ball Arc Test')),
    send(Dialog, size, size(900, 700)),

    new(Pict, picture),
    send(Dialog, append, Pict),
    send(Pict, size, size(900, 600)),

    new(BallBitmap, bitmap('ball.jpg')),
    send(BallBitmap, size, size(64, 64)),
    send(Pict, display, BallBitmap, point(10, 350)),

    new(MoveButton, button('Move Ball')),
    send(Dialog, append, MoveButton),
    send(MoveButton, message, message(@prolog, move_ball, Pict, 10, -10)),

    send(Dialog, open).

move_ball(Pict, XVel, YVel) :-
    get(Pict, member, bitmap, Ball),
    Delay is 1 / 60, % 60 FPS
    Frames is 10 * 60, % 10 seconds
    new(@my_timer, ball_timer(Ball, XVel, YVel, Delay, Frames)).

:- pce_begin_class(ball_timer, object).
variable(timer, timer, both, "The timer for the animation").
variable(ball, bitmap, both, "The ball bitmap").
variable(xVel, number, both, "The initial X velocity of the ball").
variable(yVel, number, both, "The initial Y velocity of the ball").
variable(delay, number, both, "The delay between frames").
variable(frames, number, both, "The number of frames for the animation").

initialise(T, Ball, XVel, YVel, Delay, Frames) :->
    send(T, slot, ball, Ball),
    send(T, slot, xVel, XVel),
    send(T, slot, yVel, YVel),
    send(T, slot, delay, Delay),
    send(T, slot, frames, Frames),
    send(T, timer, new(_, timer(Delay, message(T, update)))),
    send(T?timer, start).

unlink(T) :->
    send(T?timer, stop),
    send(T, send_super, unlink).

update(T) :->
    get(T, slot, frames, Frames),
    (   get(Frames, value, 0)
    ->  send(T?timer, stop),
        free(@my_timer)
    ;   get(T, slot, ball, Ball),
        get(T, slot, xVel, XVel),
        get(T, slot, yVel, YVel),
        get(Ball, x, X),
        get(Ball, y, Y),
        get(X, plus, XVel, NewX),
        get(Y, plus, YVel, NewY),
        send(Ball, x, NewX),
        send(Ball, y, NewY),
        get(YVel, plus, 1, NewYVel), % acceleration due to gravity
        send(T, slot, yVel, NewYVel),
        get(Frames, minus, 1, NewFrames),
        send(T, slot, frames, NewFrames)
    ).

:- pce_end_class.

:- main.
