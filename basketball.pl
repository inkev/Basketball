:- use_module(library(pce)).

% Define the predicate that creates the window and button
create_window :-
    new(Window, dialog('My Window')),
    new(Button, button('Click me')),
    send(Window, append, Button),
    send(Window, open),
    send(Button, message, message(@prolog, display_message)).

% Define the predicate that displays the message
display_message :-
    write('Button clicked!').

% Run the program by calling the create_window predicate
:- create_window.