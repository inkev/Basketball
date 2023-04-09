:- module(gui, [main/0]).

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
