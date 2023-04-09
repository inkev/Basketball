:- use_module(library(pce)).

main :-
    new(Dialog, dialog('Basketball Game')),
    send(Dialog, size, size(900, 700)),

    new(Pict, picture),
    send(Dialog, append, Pict),
    send(Pict, size, size(900, 600)),

    new(HoopBitmap, bitmap('hoop.png')),
    send(Pict, display, HoopBitmap, point(600, 200)),

    new(BallBitmap, bitmap('ball.png')),
    send(Pict, display, BallBitmap, point(10, 350)),

    new(ShootButton, button('Shoot')),
    send(Dialog, append, ShootButton),
    send(ShootButton, message, message(@prolog, shoot_button_clicked, Dialog, Pict)),

    new(PowerLabel, label(power, 'Power: 0%')),
    send(Dialog, append, PowerLabel),

    new(AngleLabel, label(angle, 'Angle: 0°')),
    send(Dialog, append, AngleLabel),

    send(Dialog, open).

shoot_button_clicked(Dialog, Pict) :-
    (   get(Pict, member, ball, _)
    ->  true
    ;   get(Dialog, member, power, PowerBar),
        get(Dialog, member, angle, AngleBar),
        update_power(PowerBar, 0, 100, Power),
        update_angle(AngleBar, 0, 90, Angle),
        shoot_ball(Pict, 10, 350, Power, Angle)
    ).

shoot_ball(Pict, X, Y, Power, Angle) :-
    send(Pict, display, new(Ball, bitmap(@ball)), point(X, Y)),
    send(Ball, name, ball),
    AngleRadians is Angle * pi / 180,
    update_ball(Pict, X, Y, AngleRadians, Power).

update_ball(Pict, X, Y, Angle, Power) :-
    (   get(Pict, member, ball, Ball)
    ->  (   X < 600
        ->  send(Ball, x, X),
            send(Ball, y, Y),
            NewX is X + Power / 20 * cos(Angle),
            NewY is Y - Power / 20 * sin(Angle),
            send(@display, dispatch),
            sleep(0.01),
            update_ball(Pict, NewX, NewY, Angle, Power)
        ;   send(Ball, free)
        )
    ;   true
    ).

update_power(PowerLabel, Min, Max, Power) :-
    (   get(PowerLabel, value, Value),
        (Value == Max -> Step = -1 ; Value == Min -> Step = 1 ; true),
        NewValue is Value + Step,
        send(PowerLabel, selection, string('Power: %d%%', NewValue)),
        send(@display, dispatch),
        sleep(0.01),
        update_power(PowerLabel, Min, Max, Power)
    ;   Power is Value
    ).

update_angle(AngleLabel, Min, Max, Angle) :-
    (   get(AngleLabel, value, Value),
        (Value == Max -> Step = -1 ; Value == Min -> Step = 1 ; true),
        NewValue is Value + Step,
        send(AngleLabel, selection, string('Angle: %d°', NewValue)),
        send(@display, dispatch),
        sleep(0.01),
        update_angle(AngleLabel, Min, Max, Angle)
    ;   Angle is Value
    ).

:- main.
