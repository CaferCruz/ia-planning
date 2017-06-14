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

%clima(quente).
%clima(frio).

%baixa(potencia).
%media(potencia).
%alta(potencia).
potencia(baixa).
potencia(media).
potencia(alta).
%Fim de predicado



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

usa_equipamento(p3).

nao_usa_equipamento(p1).
nao_usa_equipamento(p2).

%Fim relacao

%Logica
equipamento(X) :- data_show(X); computador(X).
ligavel(X) :- data_show(X); computador(X); ar_condicionado(X); lampada(X).


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
can(ajustar_ar_para_frio(Ar_Condicionado, Sala), [ligado(Ar_Condicionado), aberta(Sala), frio(clima), nao_ajustado(Ar_Condicionado)], preparar) :- 
ar_condicionado(Ar_Condicionado), sala(Sala), pertence(Sala, Ar_Condicionado).
 
adds(ajustar_ar_para_frio(Ar_Condicionado, Sala), [ajustado(Ar_Condicionado)], _, preparar):- 
ar_condicionado(Ar_Condicionado), sala(Sala).
 
deletes(ajustar_ar_para_frio(Ar_Condicionado, Sala), [nao_ajustado(Ar_Condicionado)],preparar) :- 
ar_condicionado(Ar_Condicionado), sala(Sala).
 
can(ajustar_ar_para_calor(Ar_Condicionado, Sala), [ligado(Ar_Condicionado), aberta(Sala), quente(clima), nao_ajustado(Ar_Condicionado)], preparar) :- 
ar_condicionado(Ar_Condicionado), sala(Sala), pertence(Sala, Ar_Condicionado).
 
adds(ajustar_ar_para_calor(Ar_Condicionado, Sala), [ajustado(Ar_Condicionado)], _, preparar):- 
ar_condicionado(Ar_Condicionado), sala(Sala).
 
deletes(ajustar_ar_para_calor(Ar_Condicionado, Sala), [nao_ajustado(Ar_Condicionado)],preparar) :- 
ar_condicionado(Ar_Condicionado), sala(Sala). 
 
 
 
%Abrir
can(abrir(Sala, Professor, Hora), [fechada(Sala) ], preparar) :-
sala(Sala), professor(Professor), hora(Hora), reserva(Sala, Professor, Hora).
 
adds(abrir(Sala, Professor, Hora), [aberta(Sala)], _, preparar) :- 
 sala(Sala), professor(Professor), hora(Hora).
 
deletes(abrir(Sala, Professor, Hora),[fechada(Sala)], preparar) :-  
sala(Sala), professor(Professor), hora(Hora).
 
%Fechar
can(fechar(Sala, Professor, Hora), [aberta(Sala)], preparar) :-
sala(Sala), professor(Professor), hora(Hora), reserva(Sala, Professor, Hora).
 
adds(fechar(Sala, Professor, Hora), [ fechada(Sala)], _, preparar) :- 
 sala(Sala), professor(Professor), hora(Hora).
 
deletes(fechar(Sala, Professor, Hora),[aberta(Sala)], preparar) :-  
sala(Sala), professor(Professor), hora(Hora).
 
%Preparar aula
can(preparar_aula_com_equipamento(Sala, Professor), [aberta(Sala), ligado(X), ligado(Y), ligado(Z), ligado(W),  ajustado(W)],preparar) :-
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
reserva(Sala, Professor, H),
usa_equipamento(Professor).
 
adds(preparar_aula_com_equipamento(Sala, Professor), [aula_preparada(Sala,Professor)], _, preparar):-
professor(Professor),
sala(Sala).

	
deletes(preparar_aula_com_equipamento(Sala, Professor), [], preparar):-
professor(Professor),
sala(Sala).

 
can(preparar_aula_sem_equipamento(Sala, Professor), [aberta(Sala),ligado(Z), ligado(W), ajustado(W)],preparar) :-
professor(Professor),
sala(Sala),
lampada(Z),
pertence(Sala,Z),
ar_condicionado(W),
pertence(Sala, W),
hora(H),
reserva(Sala, Professor, H),
nao_usa_equipamento(Professor).
 
adds(preparar_aula_sem_equipamento(Sala, Professor), [aula_preparada(Sala,Professor)], _, preparar):-
professor(Professor),
sala(Sala).


deletes(preparar_aula_sem_equipamento(Sala, Professor), [], preparar):-
professor(Professor),
sala(Sala).


%casos de teste

test01(P) :- plan([ fechada(s1), desligado(a1), desligado(l1), desligado(c1), desligado(d1), nao_ajustado(a1), frio(clima)], [aula_preparada(s1,p1)], preparar, P).
test02(P) :- plan([ fechada(s1), desligado(a1), desligado(l1), desligado(c1), desligado(d1), nao_ajustado(a1), quente(clima)], [aula_preparada(s1,p1)], preparar, P).
