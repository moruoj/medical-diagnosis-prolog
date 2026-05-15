:- dynamic suffer/1.
:- use_module(library(lists)).

ask(Symptom) :-
    write('Do you have '), write(Symptom), write('? Please answer yes or no: '),
    read(Ans),
    ( Ans == yes -> assertz(suffer(Symptom))
    ; true ).

clear_answers :-
    retractall(suffer(_)).

start_diagnosis :-
    clear_answers,
    nl,
    writeln('=============================================='),
    writeln(' Mini medical diagnosis helper.'),
    writeln(' 1) Choose a system: skin. / respiratory. / digestive.'),
    writeln(' 2) Answer the questions with yes. or no.'),
    writeln('=============================================='),
    nl,
    write('Which system would you like to check (skin/respiratory/digestive)? '),
    read(System),
    route_system(System).

route_system(skin) :-
    nl,
    writeln('You selected the skin system.'),
    start_skin.
route_system(respiratory) :-
    nl,
    writeln('You selected the respiratory system.'),
    start_respiratory.
route_system(digestive) :-
    nl,
    writeln('You selected the digestive system.'),
    start_digestive.
route_system(_) :-
    writeln('Please start the diagnosis again and choose skin., respiratory., or digestive.').

% علاجات امراض الجلد

treatment(eczema, allergy_cream).
treatment(eczema, moisturizing_cream).

treatment(burn, burn_cream).
treatment(burn, antibiotic).
treatment(burn, moisturizing_cream).

show_treatments(D) :-
    treatment(D, T),
    write('- '), writeln(T),
    fail.
show_treatments(_).

% سكورات الجلدية

eczema_score(S) :-
    findall(X, eczema_point(X), L),
    sum_list(L, Raw),
    ( Raw > 100 -> S = 100 ; S = Raw ).

burn_score(S) :-
    findall(X, burn_point(X), L),
    sum_list(L, Raw),
    ( Raw > 100 -> S = 100 ; S = Raw ).

eczema_point(25) :- suffer(itching).
eczema_point(15) :- suffer(redness).
eczema_point(60) :- suffer(skin_peeling).

burn_point(15) :- suffer(redness).
burn_point(75) :- suffer(tissue_damage).

show_skin_scores :-
    eczema_score(E),
    burn_score(B),
    writeln('The likelihoods we found are as follows:'),
    write('eczema = '), write(E), writeln('%'),
    write('burn   = '), write(B), writeln('%').

start_skin :-
    ask(itching),
    ask(redness),
    next_step_after_basic.

next_step_after_basic :-
    ask(skin_peeling),
    ( suffer(skin_peeling) ->
        nl,
        show_skin_scores,
        nl,
        writeln('You have been diagnosed with eczema.'),
        choose_treatment_plan(eczema)
    ;
        ask(tissue_damage),
        nl,
        show_skin_scores,
        nl,
        final_skin_decision
    ).

final_skin_decision :-
    eczema_score(E),
    burn_score(B),
    ( suffer(tissue_damage) ->
        writeln('You have been diagnosed with burn.'),
        choose_treatment_plan(burn)
    ; E > 0, B =:= 0 ->
        writeln('You may have eczema.'),
        write('Estimated likelihood: '), write(E), writeln('%'),
        writeln('Recommended medications:'),
        writeln(moisturizing_cream),
        writeln('You can repeat the diagnosis if you found more symptoms.')
    ; B > 0, E =:= 0 ->
        writeln('You may have burn.'),
        write('Estimated likelihood: '), write(B), writeln('%'),
        writeln('Recommended medications:'),
        writeln(moisturizing_cream),
        writeln('You can repeat the diagnosis if you found more symptoms .')
    ; E > 0, B > 0 ->
        writeln('The result is not fully clear yet.'),
        writeln('Possible conditions:'),
        write('eczema = '), write(E), writeln('%'),
        write('burn   = '), write(B), writeln('%'),
        writeln('Recommended medications:'),
        writeln(moisturizing_cream),
        writeln('You can repeat the diagnosis if you found more symptoms.')
    ; writeln('No clear skin diagnosis was found.'),
      writeln('Recommended medications:'),
      writeln(moisturizing_cream),
      writeln('You can repeat the diagnosis if you found more symptoms.')
    ).

% علاجات امراض الجهاز التنفسي

resp_treatment(covid19, home_isolation).
resp_treatment(covid19, fever_reducer).

resp_treatment(influenza, rest).
resp_treatment(influenza, fluids).
resp_treatment(influenza, fever_reducer).
resp_treatment(influenza, steam).

resp_treatment(asthma, bronchodilator_inhaler).

show_resp_treatments(D) :-
    resp_treatment(D, T),
    write('- '), writeln(T),
    fail.
show_resp_treatments(_).

% سكورات التنفسي

covid_score(S) :-
    findall(X, covid_point(X), L),
    sum_list(L, Raw),
    ( Raw > 100 -> S = 100 ; S = Raw ).

influenza_score(S) :-
    findall(X, influenza_point(X), L),
    sum_list(L, Raw),
    ( Raw > 100 -> S = 100 ; S = Raw ).

asthma_score(S) :-
    findall(X, asthma_point(X), L),
    sum_list(L, Raw),
    ( Raw > 100 -> S = 100 ; S = Raw ).

covid_point(20) :- suffer(dry_cough).
covid_point(20) :- suffer(fever).
covid_point(60) :- suffer(loss_of_taste_or_smell).

influenza_point(20) :- suffer(dry_cough).
influenza_point(20) :- suffer(fever).
influenza_point(60) :- suffer(severe_muscle_pain).

asthma_point(20) :- suffer(dry_cough).
asthma_point(80) :- suffer(shortness_of_breath).
asthma_point(80) :- suffer(chest_wheezing).

show_respiratory_scores :-
    covid_score(C),
    influenza_score(I),
    asthma_score(A),
    writeln('The likelihoods we found are as follows:'),
    write('covid19   = '), write(C), writeln('%'),
    write('influenza = '), write(I), writeln('%'),
    write('asthma    = '), write(A), writeln('%').

start_respiratory :-
    ask(dry_cough),
    ask(fever),
    ask(shortness_of_breath),
    next_step_respiratory.

next_step_respiratory :-
    ( suffer(shortness_of_breath) ->
        nl,
        show_respiratory_scores,
        nl,
        writeln('You have been diagnosed with asthma.'),
        choose_treatment_plan(asthma)
    ;
        ask(loss_of_taste_or_smell),
        ( suffer(loss_of_taste_or_smell) ->
            nl,
            show_respiratory_scores,
            nl,
            writeln('You have been diagnosed with covid19.'),
            choose_treatment_plan(covid19)
        ;
            ask(severe_muscle_pain),
            ( suffer(severe_muscle_pain) ->
                nl,
                show_respiratory_scores,
                nl,
                writeln('You have been diagnosed with influenza.'),
                choose_treatment_plan(influenza)
            ;
                ask(chest_wheezing),
                ( suffer(chest_wheezing) ->
                    nl,
                    show_respiratory_scores,
                    nl,
                    writeln('You have been diagnosed with asthma.'),
                    choose_treatment_plan(asthma)
                ;
                    nl,
                    show_respiratory_scores,
                    nl,
                    final_respiratory_decision
                )
            )
        )
    ).

final_respiratory_decision :-
    covid_score(C),
    influenza_score(I),
    asthma_score(A),
    ( C > I, C > A ->
        writeln('You may have covid19.'),
        write('Estimated likelihood: '), write(C), writeln('%'),
        writeln('Recommended medications:'),
        writeln(steam),
        writeln('You can repeat the diagnosis if you found more symptoms.')
    ; I > C, I > A ->
        writeln('You may have influenza.'),
        write('Estimated likelihood: '), write(I), writeln('%'),
        writeln('Recommended medications:'),
        writeln(steam),
        writeln('You can repeat the diagnosis if you found more symptoms.')
    ; A > C, A > I ->
        writeln('You may have asthma.'),
        write('Estimated likelihood: '), write(A), writeln('%'),
        writeln('Recommended medications:'),
        writeln(steam),
        writeln('You can repeat the diagnosis if you found more symptoms.')
    ; (C > 0 ; I > 0 ; A > 0) ->
        writeln('The result is not fully clear yet.'),
        writeln('Possible conditions:'),
        write('covid19   = '), write(C), writeln('%'),
        write('influenza = '), write(I), writeln('%'),
        write('asthma    = '), write(A), writeln('%'),
        writeln('Recommended medications:'),
        writeln(steam),
        writeln('You can repeat the diagnosis if you found more symptoms.')
    ; writeln('No clear respiratory diagnosis was found.'),
      writeln('Recommended medications:'),
      writeln(steam),
      writeln('You can repeat the diagnosis if you found more symptoms.')
    ).

% علاجات المشاكل الهضمية

dig_treatment(gastroenteritis, antibiotic).
dig_treatment(food_poisoning, fluids).

show_dig_treatments(D) :-
    dig_treatment(D, T),
    write('- '), writeln(T),
    fail.
show_dig_treatments(_).

% سكورات الامراض الهضمية

gastroenteritis_score(S) :-
    findall(X, gastroenteritis_point(X), L),
    sum_list(L, Raw),
    ( Raw > 100 -> S = 100 ; S = Raw ).

food_poisoning_score(S) :-
    findall(X, food_poisoning_point(X), L),
    sum_list(L, Raw),
    ( Raw > 100 -> S = 100 ; S = Raw ).

gastroenteritis_point(15) :- suffer(nausea).
gastroenteritis_point(25) :- suffer(vomiting).
gastroenteritis_point(60) :- suffer(longer_duration_of_symptoms).

food_poisoning_point(15) :- suffer(nausea).
food_poisoning_point(25) :- suffer(vomiting).
food_poisoning_point(60) :- suffer(sudden_fast_onset).

show_digestive_scores :-
    gastroenteritis_score(G),
    food_poisoning_score(F),
    writeln('The likelihoods we found are as follows:'),
    write('gastroenteritis = '), write(G), writeln('%'),
    write('food_poisoning  = '), write(F), writeln('%').

start_digestive :-
    ask(nausea),
    ask(vomiting),
    next_step_digestive.

next_step_digestive :-
    ask(longer_duration_of_symptoms),
    ( suffer(longer_duration_of_symptoms) ->
        nl,
        show_digestive_scores,
        nl,
        writeln('You have been diagnosed with gastroenteritis.'),
        choose_treatment_plan(gastroenteritis)
    ;
        ask(sudden_fast_onset),
        nl,
        show_digestive_scores,
        nl,
        final_digestive_decision
    ).

final_digestive_decision :-
    gastroenteritis_score(G),
    food_poisoning_score(F),
    ( suffer(sudden_fast_onset) ->
        writeln('You have been diagnosed with food_poisoning.'),
        choose_treatment_plan(food_poisoning)
    ; G > 0, F =:= 0 ->
        writeln('You may have gastroenteritis.'),
        write('Estimated likelihood: '), write(G), writeln('%'),
        writeln('Recommended medications:'),
        writeln(painkiller),
        writeln('You can repeat the diagnosis if you found more symptoms.')
    ; F > 0, G =:= 0 ->
        writeln('You may have food_poisoning.'),
        write('Estimated likelihood: '), write(F), writeln('%'),
        writeln('Recommended medications:'),
        writeln(painkiller),
        writeln('You can repeat the diagnosis if you found more symptoms.')
    ; G > 0, F > 0 ->
        writeln('The result is not fully clear yet.'),
        writeln('Possible conditions:'),
        write('gastroenteritis = '), write(G), writeln('%'),
        write('food_poisoning  = '), write(F), writeln('%'),
        writeln('Recommended medications:'),
        writeln(painkiller),
        writeln('You can repeat the diagnosis if you found more symptoms.')
    ; writeln('No clear digestive diagnosis was found.'),
      writeln('Recommended medications:'),
      writeln(painkiller),
      writeln('You can repeat the diagnosis if you found more symptoms.')
    ).

treatment_option(eczema, allergy_cream).
treatment_option(eczema, moisturizing_cream).

treatment_option(burn, burn_cream).
treatment_option(burn, antibiotic).
treatment_option(burn, moisturizing_cream).

treatment_option(covid19, home_isolation).
treatment_option(covid19, fever_reducer).

treatment_option(influenza, rest).
treatment_option(influenza, fluids).
treatment_option(influenza, fever_reducer).
treatment_option(influenza, steam).

treatment_option(asthma, bronchodilator_inhaler).

treatment_option(gastroenteritis, antibiotic).
treatment_option(gastroenteritis, fluids).

treatment_option(food_poisoning, fluids).


% البحث بالطريقتين

print_treatment_list([]).
print_treatment_list([H|T]) :-
    write('- '), writeln(H),
    print_treatment_list(T).

initial_severity_search(influenza, 40).
initial_severity_search(burn, 50).

% treatment_action(Disease, Treatment, RecoveryValue, SideEffectValue)

treatment_action(influenza, fever_reducer, 30, 9).
treatment_action(influenza, steam, 15, 2).
treatment_action(influenza, rest, 15, 1).
treatment_action(influenza, fluids, 10, 1).

treatment_action(burn, antibiotic, 35, 12).
treatment_action(burn, burn_cream, 30, 4).
treatment_action(burn, moisturizing_cream, 20, 1).

goal_search_state(state(Severity, _, _)) :-
    Severity =< 0.

next_search_state(Disease, state(Severity, SideEffects, Plan), state(NewSeverity, NewSideEffects, [Treatment|Plan])) :-
    treatment_action(Disease, Treatment, RecoveryValue, SideEffectValue),
    \+ member(Treatment, Plan),
    NewSeverity is Severity - RecoveryValue,
    NewSideEffects is SideEffects + SideEffectValue.

% BFS

bfs_treatment_search(Disease, Plan) :-
    initial_severity_search(Disease, InitialSeverity),
    StartState = state(InitialSeverity, 0, []),
    bfs_queue(Disease, [StartState], state(_, _, RevPlan)),
    reverse(RevPlan, Plan).

bfs_queue(_, [State|_], State) :-
    goal_search_state(State), !.

bfs_queue(Disease, [State|Rest], Solution) :-
    findall(NextState,
        next_search_state(Disease, State, NextState),
        Children),
    append(Rest, Children, NewQueue),
    bfs_queue(Disease, NewQueue, Solution).

% A*

path_cost(state(_, SideEffects, Plan), G) :-
    length(Plan, Steps),
    G is Steps + (SideEffects * 2).

heuristic_cost(state(Severity, _, _), H) :-
    H is max(0, Severity).

f_cost(State, F) :-
    path_cost(State, G),
    heuristic_cost(State, H),
    F is G + H.

astar_treatment_search(Disease, Plan) :-
    initial_severity_search(Disease, InitialSeverity),
    StartState = state(InitialSeverity, 0, []),
    f_cost(StartState, F0),
    astar_queue(Disease, [F0-StartState], state(_, _, RevPlan)),
    reverse(RevPlan, Plan).

astar_queue(_, Open, State) :-
    keysort(Open, [_-State|_]),
    goal_search_state(State), !.

astar_queue(Disease, Open, Solution) :-
    keysort(Open, [_-Current|Rest]),
    findall(FNext-NextState,
        (
            next_search_state(Disease, Current, NextState),
            f_cost(NextState, FNext)
        ),
        Children),
    append(Rest, Children, NewOpen),
    astar_queue(Disease, NewOpen, Solution).

choose_treatment_plan(Disease) :-
    nl,
    writeln('Based on your result, these are your treatment options:'),
    findall(T, treatment_option(Disease, T), Treatments),
    sort(Treatments, UniqueTreatments),
    print_treatment_list(UniqueTreatments),
    nl,
    (
        Disease = influenza ->
            writeln('Search-based treatment plans for influenza:'),
            bfs_treatment_search(influenza, BFSPlan),
            writeln('BFS plan:'),
            print_treatment_list(BFSPlan),
            astar_treatment_search(influenza, AStarPlan),
            writeln('A* plan:'),
            print_treatment_list(AStarPlan)
    ;   Disease = burn ->
            writeln('Search-based treatment plans for burn:'),
            bfs_treatment_search(burn, BFSPlan),
            writeln('BFS plan:'),
            print_treatment_list(BFSPlan),
            astar_treatment_search(burn, AStarPlan),
            writeln('A* plan:'),
            print_treatment_list(AStarPlan)
    ;   writeln('Suggested treatment options:'),
        print_treatment_list(UniqueTreatments)
    ).
