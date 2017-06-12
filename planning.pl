:- discontiguous can/3.
:- discontiguous adds/4.
:- discontiguous deletes/3.


%cria predicado
hora(h1).
hora(h2).
hora(h3).

sala(s1).
sala(s2).
sala(s3).

computador(c1).
computador(c2).
computador(c3).

data_show(d1).
data_show(d2).
data_show(d3).

ar_condicionado(a1).
ar_condicionado(a2).
ar_condicionado(a3).

lampada(l1).
lampada(l2).
lampada(l3).

professor(p1).
professor(p2).
professor(p3).

temperatura(t1).
temperatura(t2).
temperatura(t3).
%Fim de predicado

%init dos sujeitos
%equipamento init
%desligado(c1).
%desligado(c2).
%desligado(c3).
%desligado(d1).
%desligado(d2).
%desligado(d3).
%desligado(a1).
%desligado(a2).
%desligado(a3).
%desligado(l1).
%desligado(l2).
%desligado(l3).
%salas init
%fechada(s1).
%fechada(s2).
%fechada(s3).
%Fim init

%Relacao sujeito e predicado

pertence(s1,c1).
pertence(s2,c2).
pertence(s3,c3).
pertence(s1,d1).
pertence(s2,d2).
pertence(s3,d3).
pertence(s1, a1).
pertence(s2, a2).
pertence(s3, a3).
pertence(s1, l1).
pertence(s2, l2).
pertence(s3, l3).

potencia(a1, t1).
potencia(a2, t1).
potencia(a3, t1).

reserva(s1, p1, h1).
reserva(s1, p2, h2).
reserva(s2, p3, h1).

usa_equipamento(p1).
usa_equipamento(p3).
nao_usa_equipamento(p2).

%Fim relacao

%Logica
equipamento(X) :- data_show(X); computador(X).
ligavel(X) :- data_show(X); computador(X); ar_condicionado(X); lampada(X).
%ligado(X) :- not(desligado(X)).
%aberta(X) :- not(fechada(X)).

%Ligar
can(ligar(Item, Sala), [desligado(Item), aberta(Sala)], preparar) :- 
ligavel(Item), sala(Sala), pertence(Sala, Item) .
 
adds(ligar(Item, Sala), [ligado(Item)], _, preparar) :- 
ligavel(Item), sala(Sala).
 
deletes(ligar(Item, Sala), [desligado(Item)], preparar) :- 
ligavel(Item), sala(Sala).
 
%Desligar
can(desligar(Item, Sala), [ligado(Item), aberta(Sala)], preparar) :- 
ligavel(Item), sala(Sala), pertence(Sala, Item).
 
adds(desligar(Item, Sala), [desligado(Item)], _, preparar):- 
ligavel(Item), sala(Sala).
 
deletes(desligar(Item, Sala), [ligado(Item)],preparar) :- 
ligavel(Item), sala(Sala).
 
%AjustarArCondicionado
can(ajustar(ArCondicionado, Temperatura), [not(potencia(ArCondicionado, Temperatura))], preparar) :- 
ar_condicionado(ArCondicionado), temperatura(Temperatura).
 
adds(ajustar(ArCondicionado, Temperatura), [temperatura(ArCondicionado, Temperatura)], _, preparar):- 
ar_condicionado(ArCondicionado), temperatura(Temperatura).
 
deletes(ajustar(ArCondicionado, Temperatura), [not(potencia(ArCondicionado, Temperatura))],preparar) :- 
ar_condicionado(ArCondicionado), temperatura(Temperatura).
 
 
 
 
%Abrir
can(abrir(Sala, Professor, Hora), [fechada(Sala), reserva(Sala, Professor, Hora)], preparar) :-
sala(Sala), professor(Professor), hora(Hora).
 
adds(abrir(Sala, Professor, Hora), [aberta(Sala)], _, preparar) :- 
 sala(Sala), professor(Professor), hora(Hora).
 
deletes(abrir(Sala, Professor, Hora),[fechada(Sala)], preparar) :-  
sala(Sala), professor(Professor), hora(Hora).
 
%Fechar
can(fechar(Sala, Professor, Hora), [aberta(Sala), reserva(Sala,Professor,Hora)], preparar) :-
sala(Sala), professor(Professor), hora(Hora).
 
adds(fechar(Sala, Professor, Hora), [ fechada(Sala)], _, preparar) :- 
 sala(Sala), professor(Professor), hora(Hora).
 
deletes(fechar(Sala, Professor, Hora),[aberta(Sala)], preparar) :-  
sala(Sala), professor(Professor), hora(Hora).
 
%Iniciar aula
can(preparar_aula_com_equipamento(Sala, Professor), [aberta(Sala), ligado(X), ligado(Y), ligado(Z), ligado(W), usa_equipamento(Professor)],preparar) :-
professor(Professor),
sala(Sala),
data_show(X),
pertence(Sala, X),
computador(Y),
pertence(Sala, Y),
lampada(Z),
pertence(Sala,Z),
ar_condicionado(W),
pertence(Sala, W),
hora(H),
reserva(Sala, Professor, H).
 
adds(preparar_aula_com_equipamento(Sala, Professor), [aula_preparada(Sala,Professor)], _, preparar):-
professor(Professor),
sala(Sala).
%data_show(X),
%ligado(X),
%pertence(Sala, X),
%computador(Y),
%ligado(Y),
%pertence(Sala, Y),
%lampada(Z),
%ligado(Z),
%pertence(Sala,Z),
%ar_condicionado(W),
%ligado(W),
%pertence(Sala, W),
%hora(H),
%reserva(Sala, Professor, H).
	
deletes(preparar_aula_com_equipamento(Sala, Professor), [], preparar):-
professor(Professor),
sala(Sala).
%data_show(X),
%ligado(X),
%pertence(Sala, X),
%computador(Y),
%ligado(Y),
%pertence(Sala, Y),
%lampada(Z),
%ligado(Z),
%pertence(Sala,Z),
%ar_condicionado(W),
%ligado(W),
%pertence(Sala, W),
%hora(H),
%reserva(Sala, Professor, H).
 
can(preparar_aula_sem_equipamento(Sala, Professor), [aberta(Sala),ligado(Z), ligado(W), nao_usa_equipamento(Professor)],preparar) :-
professor(Professor),
sala(Sala),
lampada(Z),
pertence(Sala,Z),
ar_condicionado(W),
pertence(Sala, W),
hora(H),
reserva(Sala, Professor, H).
 
adds(preparar_aula_sem_equipamento(Sala, Professor), [aula_preparada(Sala,Professor)], _, preparar):-
professor(Professor),
sala(Sala).
%lampada(Z),
%ligado(Z),
%pertence(Sala,Z),
%ar_condicionado(W),
%ligado(W),
%pertence(Sala, W),
%hora(H),
%reserva(Sala, Professor, H).

deletes(preparar_aula_sem_equipamento(Sala, Professor), [], preparar):-
professor(Professor),
sala(Sala).
%lampada(Z),
%ligado(Z),
%pertence(Sala,Z),
%ar_condicionado(W),
%ligado(W),
%pertence(Sala, W),
%hora(H),
%reserva(Sala, Professor, H).
