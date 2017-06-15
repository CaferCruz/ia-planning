:- discontiguous can/3.
:- discontiguous adds/4.
:- discontiguous deletes/3.
%:- debug.

%Inicio de criação dos predicado
sala(sala_120).
sala(sala_230).
sala(sala_370).

computador(compact).
computador(dell).
computador(positivo).

datashow(datashow_01).
datashow(datashow_02).
datashow(datashow_03).

ar_condicionado(ar_condicionado_01).
ar_condicionado(ar_condicionado_02).
ar_condicionado(ar_condicionado_03).

lampada(lampada_01).
lampada(lampada_02).
lampada(lampada_03).

professor(aline).
professor(dante).
professor(murta).

potencia(baixa).
potencia(media).
potencia(alta).
%Fim de predicado

%Relacao sujeito e predicado
pertence(sala_120, compact).
pertence(sala_230, dell).
pertence(sala_370, positivo).
pertence(sala_120, datashow_01).
pertence(sala_230, datashow_02).
pertence(sala_370, datashow_03).
pertence(sala_120, ar_condicionado_01).
pertence(sala_230, ar_condicionado_02).
pertence(sala_370, ar_condicionado_03).
pertence(sala_120, lampada_01).
pertence(sala_230, lampada_02).
pertence(sala_370, lampada_03).

reserva(sala_120, aline, 19).
reserva(sala_120, dante, 14).
reserva(sala_230, murta, 12).

usa_equipamento(murta).

nao_usa_equipamento(aline).
nao_usa_equipamento(dante).
%Fim relacao

/**
*	Lógicas criadas para auxliar.
*/
equipamento(X) :- 
	datashow(X); 
	computador(X).

ligavel(X) :- 
	datashow(X); 
	computador(X); 
	ar_condicionado(X).

dia(X) :-  
	X < 18.

noite(X) :- 
	X >= 18.

%
/**
*	Caso item esteja desligado e a sala aberta, ligar itens.
*/
can(ligar(Item, Sala), [desligado(Item), aberta(Sala)], preparar) :- 
	ligavel(Item), 
	sala(Sala), 
	pertence(Sala, Item).
 
adds(ligar(Item, Sala), [ligado(Item)], _, preparar) :- 
	ligavel(Item), 
	sala(Sala).
 
deletes(ligar(Item, Sala), [desligado(Item)], preparar) :- 
	ligavel(Item), 
	sala(Sala).
 

/**
*	Caso item esteja ligado e a sala aberta, desligar itens.
*/
can(desligar(Item, Sala), [ligado(Item), aberta(Sala)], preparar) :- 
	ligavel(Item), 
	sala(Sala), 
	pertence(Sala, Item).
 
adds(desligar(Item, Sala), [desligado(Item)], _, preparar):- 
	ligavel(Item), 
	sala(Sala).
 
deletes(desligar(Item, Sala), [ligado(Item)],preparar) :- 
	ligavel(Item), 
	sala(Sala).
 
 
/**
*	Caso seja dia, não acende a lâmpada.
*/
can(acender_luz_dia(Item, Sala, Hora), [desligado(Item), aberta(Sala), vai_dar_aula(Sala, Professor, Hora)], preparar) :- 
	lampada(Item), 
	sala(Sala),
	reserva(Sala, Professor, Hora), 
	pertence(Sala, Item), 
	dia(Hora).
 
adds(acender_luz_dia(Item, Sala, _Hora), [verificado(Item), desligado(Item)], _, preparar) :- 
	lampada(Item), 
	sala(Sala).
 
deletes(acender_luz_dia(Item, Sala, _Hora), [ligado(Item)], preparar) :- 
	lampada(Item), 
	sala(Sala).

/**
*	Caso seja noite, acende a lâmpada.
*/
can(acender_luz_noite(Item, Sala, Hora), [desligado(Item), aberta(Sala), vai_dar_aula(Sala, Professor, Hora)], preparar) :- 
	lampada(Item), 
	sala(Sala),
	reserva(Sala, Professor, Hora), 
	pertence(Sala, Item), 
	noite(Hora).
 
adds(acender_luz_noite(Item, Sala, _Hora), [verificado(Item) ,ligado(Item)], _, preparar) :- 
	lampada(Item), 
	sala(Sala).
 
deletes(acender_luz_noite(Item, Sala, _Hora), [desligado(Item)], preparar) :- 
	lampada(Item), 
	sala(Sala).
	
/**
* Apaga a luz caso ela estaja acesa 
*/	
can(apagar_luz(Item, Sala), [ligado(Item), deu_aula(Sala, Professor, Hora), aberta(Sala)], preparar):-
	lampada(Item),
	sala(Sala),
	reserva(Sala, Professor, Hora),
	pertence(Sala, Item).
	
adds(apagar_luz(Item, Sala), [desligado(Item)], _,preparar):-
	lampada(Item),
	sala(Sala),
	pertence(Sala, Item).
	
deletes(apagar_luz(Item, Sala), [ligado(Item)], preparar):-
	lampada(Item),
	sala(Sala),
	pertence(Sala, Item).
  
/**
*	Caso esteja frio, ajusta ar-condicionado para o frio. 
*/
can(ajustar_ar_para_frio(Ar_Condicionado, Sala), [ligado(Ar_Condicionado), aberta(Sala), frio(clima), nao_ajustado(Ar_Condicionado)], preparar) :- 
	ar_condicionado(Ar_Condicionado), 
	sala(Sala), 
	pertence(Sala, Ar_Condicionado).
 
adds(ajustar_ar_para_frio(Ar_Condicionado, Sala), [ajustado(Ar_Condicionado)], _, preparar):- 
	ar_condicionado(Ar_Condicionado), 
	sala(Sala).
 
deletes(ajustar_ar_para_frio(Ar_Condicionado, Sala), [nao_ajustado(Ar_Condicionado)],preparar) :- 
	ar_condicionado(Ar_Condicionado), 
	sala(Sala).

/**
*	Caso esteja calor, ajusta ar-condicionado para o calor. 
*/ 
can(ajustar_ar_para_calor(Ar_Condicionado, Sala), [ligado(Ar_Condicionado), aberta(Sala), quente(clima), nao_ajustado(Ar_Condicionado)], preparar) :- 
	ar_condicionado(Ar_Condicionado), 
	sala(Sala), 
	pertence(Sala, Ar_Condicionado).
 
adds(ajustar_ar_para_calor(Ar_Condicionado, Sala), [ajustado(Ar_Condicionado)], _, preparar):- 
	ar_condicionado(Ar_Condicionado), 
	sala(Sala).
 
deletes(ajustar_ar_para_calor(Ar_Condicionado, Sala), [nao_ajustado(Ar_Condicionado)],preparar) :- 
	ar_condicionado(Ar_Condicionado), 
	sala(Sala). 
 
/**
*	Caso a sala tenha sido reservado para o professor no horario X, abrir sala.
*/
can(abrir(Sala, Professor, Hora), [fechada(Sala), vai_dar_aula(Sala, Professor, Hora) ], preparar) :-
	sala(Sala),
	professor(Professor),  
	reserva(Sala, Professor, Hora).
 
adds(abrir(Sala, Professor, _Hora), [aberta(Sala)], _, preparar) :- 
	sala(Sala), 
	professor(Professor).
 
deletes(abrir(Sala, Professor, _Hora),[fechada(Sala)], preparar) :-  
	sala(Sala), 
	professor(Professor).
 
/**
*	Caso a sala tenha sido reservado para o professor no horario X, fechar a sala.
*/
can(fechar(Sala, Professor, Hora), [aberta(Sala), deu_aula(Sala, Professor, Hora), desligado(X), desligado(Y), desligado(Z), desligado(W)], preparar) :-
	sala(Sala), 
	datashow(X),
	pertence(Sala, X),
	computador(Y),
	pertence(Sala, Y),
	lampada(Z),
	pertence(Sala,Z),
	ar_condicionado(W),
	pertence(Sala, W),
	professor(Professor), 
	reserva(Sala, Professor, Hora).
 
adds(fechar(Sala, Professor, _Hora), [fechada(Sala)], _, preparar) :- 
	sala(Sala), 
	professor(Professor).
 
deletes(fechar(Sala, Professor, _Hora),[aberta(Sala)], preparar) :-  
	sala(Sala), 
	professor(Professor).
 
/**
*	Caso o professor possa usar os equipamentos, ligar os equipamentos ao iniciar aula.
*/
can(preparar_aula_com_equipamento(Sala, Professor, Hora), [aberta(Sala), ligado(X), ligado(Y), verificado(Z), ligado(W),  ajustado(W)],preparar) :-
	professor(Professor),
	sala(Sala),
	datashow(X),
	pertence(Sala, X),
	computador(Y),
	pertence(Sala, Y),
	lampada(Z),
	pertence(Sala,Z),
	ar_condicionado(W),
	pertence(Sala, W),
	reserva(Sala, Professor, Hora),
	usa_equipamento(Professor).
 
adds(preparar_aula_com_equipamento(Sala, Professor, Hora), [aula_preparada(Sala,Professor)], _, preparar):-
	professor(Professor),
	sala(Sala),
	reserva(Sala, Professor, Hora).

	
deletes(preparar_aula_com_equipamento(Sala, Professor, Hora), [], preparar):-
	professor(Professor),
	sala(Sala),
	reserva(Sala, Professor, Hora).

/**
*	Caso o professor não possa usar os equipamentos, ligar os equipamentos ao iniciar aula.
*/
can(preparar_aula_sem_equipamento(Sala, Professor, Hora), [aberta(Sala), verificado(Z), ligado(W), ajustado(W)],preparar) :-
	professor(Professor),
	sala(Sala),
	lampada(Z),
	pertence(Sala,Z),
	ar_condicionado(W),
	pertence(Sala, W),
	reserva(Sala, Professor, Hora),
	nao_usa_equipamento(Professor).
 
adds(preparar_aula_sem_equipamento(Sala, Professor, Hora), [aula_preparada(Sala,Professor)], _, preparar):-
	professor(Professor),
	sala(Sala),
	reserva(Sala, Professor, Hora).

deletes(preparar_aula_sem_equipamento(Sala, Professor, Hora), [], preparar):-
	professor(Professor),
	sala(Sala),
	reserva(Sala, Professor, Hora).

/**	
* Desprepera a aula após desligar os itens da sala e fechar a sala	
*/	
can(despreparar_aula(Sala, Professor, Hora),[aula_preparada(Sala, Professor) ,fechada(Sala), deu_aula(Sala, Professor, Hora), desligado(X), desligado(Y), desligado(Z), desligado(W) ], preparar):-
	professor(Professor),
	sala(Sala),
	datashow(X),
	pertence(Sala, X),
	computador(Y),
	pertence(Sala, Y),
	lampada(Z),
	pertence(Sala,Z),
	ar_condicionado(W),
	pertence(Sala, W),
	reserva(Sala, Professor, Hora).

adds(despreparar_aula(Sala, Professor, Hora), [aula_despreparada(Sala, Professor)], _, preparar):-
	professor(Professor),
	sala(Sala),
	reserva(Sala, Professor, Hora).
	
deletes(despreparar_aula(Sala, Professor, Hora), [aula_preparada(Sala, Professor)], preparar):-
	professor(Professor),
	sala(Sala),
	reserva(Sala, Professor, Hora).
	

/**
*	Casos de testes
*/
test01(P) :- plan([vai_dar_aula(sala_120,aline,19), fechada(sala_120), desligado(ar_condicionado_01), desligado(lampada_01), desligado(compact), desligado(datashow_01), nao_ajustado(ar_condicionado_01), frio(clima)], [aula_preparada(sala_120,aline)], preparar, P).

test02(P) :- plan([vai_dar_aula(sala_120,dante,14), fechada(sala_120), desligado(ar_condicionado_01), desligado(lampada_01), desligado(compact), desligado(datashow_01), nao_ajustado(ar_condicionado_01), quente(clima)], [aula_preparada(sala_120,dante)], preparar, P).

test03(P) :- plan([vai_dar_aula(sala_230,murta,12) ,fechada(sala_230), desligado(ar_condicionado_02), desligado(lampada_02), desligado(dell), desligado(datashow_02), nao_ajustado(ar_condicionado_02), quente(clima)], [aula_preparada(sala_230,murta)], preparar, P).

test04(P) :- plan([deu_aula(sala_230,murta,12), aula_preparada(sala_230, murta) ,aberta(sala_230), ligado(ar_condicionado_02), desligado(lampada_02), ligado(dell), ligado(datashow_02)], [aula_despreparada(sala_230,murta)], preparar, P).

test05(P) :- plan([deu_aula(sala_120,aline,19), aula_preparada(sala_120, aline) ,aberta(sala_120), ligado(ar_condicionado_01), ligado(lampada_01), desligado(compact), desligado(datashow_01)], [aula_despreparada(sala_120,aline)], preparar, P).