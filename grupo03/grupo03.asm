;####################################################
;#	AUTORES(gp3):	Rodrigo Caldeira nº106963         #
;#					Guilherme Garcia nº105917		            #
;#					Henrique Nogueira nº107561		          #
;####################################################

DEFINE_LINHA    		          EQU  600AH          ; endereço do comando para definir a linha
DEFINE_COLUNA   		          EQU  600CH          ; endereço do comando para definir a coluna
DEFINE_PIXEL    		          EQU  6012H          ; endereço do comando para escrever um pixel
APAGA_AVISO     		          EQU  6040H          ; endereço do comando para apagar o aviso de nenhum cenário selecionado
APAGA_ECRÃ	 		              EQU  6002H          ; endereço do comando para apagar todos os pixels já desenhados
SELECIONA_VIDEO_FUNDO         EQU  6048H          ; endereço do comando para selecionar um video de fundo
INICIAR_VIDEO                 EQU  605CH          ; endereço do comando para reproduzir o video
SELECIONA_IMAGEM_FUNDO        EQU  6042H          ; endereço do comando para selecionar uma imagem de fundo
APAGA_VIDEO                   EQU  6068H          ; endereço do comando para apagar video
TOCA_SOM			                EQU  605AH          ; endereço do comando para tocar um som
MODIFICA_VOLUME_SOM                    EQU  604AH          ; endereço do comando para modificar o volume

LINHA_PAINEL        	        EQU  27
COLUNA_PAINEL	                EQU  24  
LINHA_LUZES    	              EQU  29
COLUNA_LUZES	                EQU  29


LINHA_SONDA_CENTRO_INICIAL    EQU 26
COLUNA_SONDA_CENTRO_INICIAL   EQU 32
LINHA_ASTEROIDE_INICIAL       EQU 0
COLUNA_ASTEROIDE_INICIAL      EQU 0
LINHA_MINERAVEL_INICIAL       EQU 0
COLUNA_MINERAVEL_INICIAL      EQU 30
LINHA_ASTEROIDE_DIREITA_INICIAL EQU 0
COLUNA_ASTEROIDE_DIREITA_INICIAL EQU 58
LINHA_SONDA_DIREITA_INICIAL   EQU 26         
COLUNA_SONDA_DIREITA_INICIAL  EQU 36         
LINHA_SONDA_ESQUERDA_INICIAL  EQU 26         
COLUNA_SONDA_ESQUERDA_INICIAL EQU 26   


LARGURA_PAINEL	     	        EQU  16             ; largura do interior do painel
LARGURA_LUZES	   	            EQU  6H             
ALTURA_PAINEL	                EQU  5            
ALTURA_LUZES	                EQU  2H
COR_OUTLINE		                EQU  0F579H     
COR_INTERIOR	                EQU  0F888H
COR_PRETO                     EQU  0F000H
COR_BRANCO                    EQU  0FFFFH
COR_VERMELHO		              EQU  0FF00H     
VERDE                         EQU  0F0F0H
ROSA                          EQU  0FFDFH
AZUL                          EQU  0F00FH

TEC_LIN                       EQU 0C000H   ; endere�o das linhas do teclado (perif�rico POUT-2)
TEC_COL                       EQU 0E000H   ; endere�o das colunas do teclado (perif�rico PIN)
LINHA      		                EQU 8        ; linha a testar (4� linha, 1000b)
MASCARA  		                  EQU 0FH      ; máscara usada para isolar 4 bits de menor peso

DISPLAY   	                  EQU 0A000H   ; endereço dos displays

ATRASO		                    EQU  0FFFFH	  ; atraso para limitar a velocidade de movimento do boneco
ATRASO_SONDA                  EQU  7FFFH
LIM_COLUNA_DIREITA            EQU  49
LIM_LINHA_DIREITA             EQU  15
LIM_LINHA_ESQUERDA            EQU  15
LIM_COLUNA_ESQUERDA           EQU  15
LIM_LINHA_CENTRO              EQU  15

ALTURA_SONDA                  EQU 1
LARGURA_SONDA                 EQU 1
LIM_ESQUERDO_ASTEROIDE        EQU 23
ATRASO_ASTEROIDE              EQU 5000H
ALTURA_ASTEROIDE              EQU 5
LARGURA_ASTEROIDE             EQU 5		   ; largura do boneco
VERMELHO		                  EQU 0FF00H      ; cor do pixel: vermelho em ARGB 
LARANJA      		              EQU 0FFC0H      ; cor do pixel: Laranja em ARGB
CASTANHO        	            EQU 0F500H      ; cor do pixel: Castanho em ARGB
CASTANHO_2                    EQU 0F850H
VERDE_ESCURO                  EQU 0F7B6H
AZUL_ESCURO                   EQU 0F03EH
VERDE_FORTE                   EQU 0F0F0H

; #######################################################################
; * STACK
; #######################################################################		
  PLACE       3000H
  STACK       500H
sp_inicial:

; #######################################################################
; * TABELA DE INTERRUPÇÕES
; #######################################################################		
tab_interrupts:
  WORD  atualiza_asteroide
  WORD  atualiza_sonda
  WORD  atualiza_contador
  WORD  atualiza_luzes

; #######################################################################
; * ZONA DE DADOS 
; #######################################################################		

DEF_PAINEL:					          ; definição do painel de instrumentos
	WORD		LARGURA_PAINEL
	WORD		ALTURA_PAINEL
  WORD    0, 0, COR_OUTLINE, COR_OUTLINE, COR_OUTLINE, COR_OUTLINE, COR_OUTLINE, COR_OUTLINE, COR_OUTLINE, COR_OUTLINE, COR_OUTLINE, COR_OUTLINE, COR_OUTLINE, COR_OUTLINE, 0, 0
  WORD    0, COR_OUTLINE, COR_INTERIOR, COR_INTERIOR, COR_INTERIOR, COR_INTERIOR, COR_INTERIOR, COR_INTERIOR, COR_INTERIOR, COR_INTERIOR, COR_INTERIOR, COR_INTERIOR, COR_INTERIOR, COR_INTERIOR, COR_OUTLINE, 0
	WORD		COR_OUTLINE, COR_INTERIOR, COR_INTERIOR, COR_INTERIOR, COR_INTERIOR, COR_INTERIOR, COR_INTERIOR, COR_INTERIOR, COR_INTERIOR, COR_INTERIOR, COR_INTERIOR, COR_INTERIOR, COR_INTERIOR, COR_INTERIOR, COR_INTERIOR, COR_OUTLINE
	WORD		COR_OUTLINE, COR_INTERIOR, COR_INTERIOR, COR_INTERIOR, COR_INTERIOR, COR_INTERIOR, COR_INTERIOR, COR_INTERIOR, COR_INTERIOR, COR_INTERIOR, COR_INTERIOR, COR_INTERIOR, COR_INTERIOR, COR_INTERIOR, COR_INTERIOR, COR_OUTLINE
  WORD		COR_OUTLINE, COR_INTERIOR, COR_INTERIOR, COR_INTERIOR, COR_INTERIOR, COR_INTERIOR, COR_INTERIOR, COR_INTERIOR, COR_INTERIOR, COR_INTERIOR, COR_INTERIOR, COR_INTERIOR, COR_INTERIOR, COR_INTERIOR, COR_INTERIOR, COR_OUTLINE    


; definições das luzes associadas ao painel (são 4 visto que queremos dar movimento às luzes, deste modo podemos ir alternando entre definições)
DEF_LUZES_0:
	WORD		LARGURA_LUZES
  WORD		ALTURA_LUZES
	WORD		COR_BRANCO, VERMELHO, LARANJA, ROSA, VERDE, VERMELHO
	WORD    ROSA, LARANJA, VERMELHO, VERDE, AZUL, ROSA

DEF_LUZES_1:
	WORD		LARGURA_LUZES
  WORD		ALTURA_LUZES
	WORD		VERMELHO, LARANJA, COR_BRANCO, ROSA, VERMELHO, VERDE
	WORD    LARANJA, ROSA, VERMELHO, ROSA, AZUL, VERDE

DEF_LUZES_2:
	WORD		LARGURA_LUZES
  WORD		ALTURA_LUZES
	WORD		COR_BRANCO, ROSA, VERMELHO, VERDE, ROSA, VERMELHO
	WORD    VERDE, LARANJA, VERMELHO, LARANJA, ROSA, AZUL

DEF_LUZES_3:
	WORD		LARGURA_LUZES
  WORD		ALTURA_LUZES
	WORD		COR_BRANCO, ROSA, VERMELHO, VERDE, LARANJA, ROSA
	WORD    VERMELHO, VERMELHO, LARANJA, ROSA, AZUL, VERDE

DEF_SONDA:                ;definição da sonda
  WORD    LARGURA_SONDA
  WORD    ALTURA_SONDA
  WORD    COR_VERMELHO

DEF_ASTEROIDE:            ;definição do asteroide normal
  WORD	  LARGURA_ASTEROIDE
  WORD    ALTURA_ASTEROIDE
  WORD	  0, LARANJA, LARANJA, LARANJA, 0
  WORD    LARANJA, VERMELHO, VERMELHO, VERMELHO, LARANJA
  WORD    VERMELHO, CASTANHO, CASTANHO, CASTANHO, VERMELHO
  WORD    CASTANHO, VERMELHO, CASTANHO, VERMELHO, CASTANHO
  WORD    0, LARANJA, LARANJA, LARANJA, 0 

DEF_MINERAVEL:           ;definição do asteroide minerável
  WORD    LARGURA_ASTEROIDE
  WORD    ALTURA_ASTEROIDE
  WORD    0, VERDE_ESCURO, AZUL_ESCURO, VERDE_ESCURO, 0
  WORD    VERDE_ESCURO, AZUL_ESCURO, VERDE_ESCURO, AZUL_ESCURO, VERDE_ESCURO
  WORD    AZUL_ESCURO, VERDE_ESCURO, VERDE_FORTE, VERDE_ESCURO, AZUL_ESCURO
  WORD    VERDE_ESCURO, AZUL_ESCURO, VERDE_ESCURO, AZUL_ESCURO, VERDE_ESCURO
  WORD    0, VERDE_ESCURO, AZUL_ESCURO, VERDE_ESCURO, 0

DEF_ASTEROIDE_APAGADO:  ;definição composta por pixels transparentes de modo a apagar asteroides
  WORD  LARGURA_ASTEROIDE
  WORD  ALTURA_ASTEROIDE
  WORD  0, 0, 0, 0, 0
  WORD  0, 0, 0, 0, 0
  WORD  0, 0, 0, 0, 0
  WORD  0, 0, 0, 0, 0
  WORD  0, 0, 0, 0, 0

DEF_SONDA_APAGADA:      ;definição composta por pixel transparente de modo a apagar sondas
  WORD    LARGURA_SONDA
  WORD    ALTURA_SONDA
  WORD    0


DEF_ASTEROIDE_DESTRUIDO:  ;definição de boneco que representa um asteroide destruído
  WORD  LARGURA_ASTEROIDE
  WORD  ALTURA_ASTEROIDE
  WORD  0, CASTANHO_2, 0, CASTANHO_2, 0
  WORD  0, 0, CASTANHO_2, 0, 0
  WORD  CASTANHO_2, CASTANHO_2, 0, CASTANHO_2, CASTANHO_2
  WORD  0, 0, CASTANHO_2, 0, 0
  WORD  0, CASTANHO_2, 0, CASTANHO_2, 0


BOOL_ASTEROIDE:         WORD  0          ;sinaliza se está na altura de redesenhar os asteroides na nova posição
BOOL_SONDAS:            WORD  0          ;sinaliza se está na altura de redesenhar a sonda na nova posição
SONDA_CENTRO:           WORD  0          ;regista se sonda do centro foi disparada
SONDA_ESQUERDA:         WORD  0          ;regista se sonda da esquerda foi disparada
SONDA_DIREITA:          WORD  0          ;regista se sonda da direita foi disparada
ATINGIU_NAVE:           WORD  0          ;se algum dos asteroides tiver atingido a nave, fica a 1 de modo a poder executar a rotina de fim de jogo

;coordenadas da sonda do centro em cada momento
LINHA_SONDA_CENTRO:     WORD  27
COLUNA_SONDA_CENTRO:    WORD  32
;coordenadas da sonda da direita em cada momento
LINHA_SONDA_DIREITA:    WORD  27
COLUNA_SONDA_DIREITA:   WORD  36
;coordenadas da sonda da esquerda em cada momento
LINHA_SONDA_ESQUERDA:   WORD  26
COLUNA_SONDA_ESQUERDA:  WORD  26

;coordenadas do asteroide da esquerda em cada momento
LINHA_ASTEROIDE:        WORD  0     
COLUNA_ASTEROIDE:       WORD  0

;coordenadas do asteroide minerável(centro) em cada momento
LINHA_MINERAVEL:        WORD  0
COLUNA_MINERAVEL:       WORD  30

;coordenadas do asteroide minerável(direita) em cada momento
LINHA_ASTEROIDE_DIREITA:  WORD 0
COLUNA_ASTEROIDE_DIREITA: WORD 58

NUM_LUZES:              WORD 0          ;regista qual dos desenhos das luzes foi escolhido naquele ciclo

ENERGIA_ACABOU:         WORD 0          ;caso a nave fique sem energia, valor fica a 1 para podermos executar a rotina de fim de jogo

ATUALIZAR_LUZES:        WORD 0          ;valor que indica que as luzes devem ser atualizadas
ATUALIZAR_CONTADOR:     WORD 0          ;valor que indica que o contador deve ser atualizado

VALOR_CONTADOR:		      WORD	100H      ;guarda valor do contador em cada momento
VOLUME_SOM:             WORD  100


;################################################################
;# Código
;################################################################
	PLACE   0					        ; o código tem de começar em 0000H


; ***************************************************************************
; setup - executa instruções essenciais par o funcionamento correto do programa
;         e como tal é executado no início da execução do mesmo
; ***************************************************************************
setup:
  MOV  SP, sp_inicial				;coloca stack pointer a apontar para fim da pilha    
  MOV  BTE, tab_interrupts
  CALL condicoes_iniciais
  CALL imagem_inicial

; ***************************************************************************
; menu_principal - espera até a tecla c ser premida, para dar início ao jogo
; ***************************************************************************
menu_principal:
  MOV  R8, 10H                ;colocar no registo que contém tecla premida um valor que ñ corresponde a nenhuma tecla
  CALL teclado                ;chamar função para ler input do jogador
comparacao_menu:
	MOV  R1, 0CH                ;verificar se a tecla C foi premida
	CMP  R8, R1
	JNZ  menu_principal         ;se não fôr esse o caso, continuar ciclo de espera

  CALL inicio_do_jogo         ;se C tiver sido premido, começar o jogo

  JMP  ciclo_principal        ;e saltar para o ciclo principal do jogo

; ***************************************************************************
; fim_energia - função que introduz as condições de sem energia, ou seja,
;               imagem, som e espera que a tecla c seja premida para o jogo
;               recomeçar
; ***************************************************************************
 fim_energia:
  DI                                ;desligar interrupções visto que o jogo terminou
	MOV R1, 0
  MOV [DISPLAY], R1                 ;colocar 0 no display visto que energia acabou
  MOV [VALOR_CONTADOR], R1          ;atualizar valor do contador na memória
	MOV [APAGA_ECRÃ], R1	            ;apaga os pixeis
	MOV [APAGA_VIDEO], R1             ;apaga o video
  MOV R1, 6
  MOV [TOCA_SOM], R1                ;toca som de fim do jogo
	MOV R1, 2
	MOV [SELECIONA_IMAGEM_FUNDO], R1  ;seleciona a imagem de fundo de game-over


; ***************************************************************************
; ciclo_espera_fim - ciclo partilhado por ambas as rotinas de finalização do
;                     jogo, aguarda que utilizador pressione C de modo a 
;                     recomeçar o jogo
; ***************************************************************************
ciclo_espera_fim:
  MOV  R8, 10H
  CALL teclado
	MOV  R1, 0CH
	CMP  R8, R1
	JZ   setup                ;se carregar no C o jogo recomeça
  JMP  ciclo_espera_fim     ;caso contrário continuamos à espera


; ***************************************************************************
; fim_explosao - função que introduz as condições de explosao da nave, ou seja,
;               imagem, som e espera que a tecla c seja premida para o jogo
;               recomeçar
; ***************************************************************************
fim_explosao:              ; termina o jogo 
  DI
  ;reset da posição asteroide
  MOV R4, LINHA_ASTEROIDE
  MOV R5, COLUNA_ASTEROIDE
  MOV R6, 0
  MOV [R4], R6
  MOV [R5], R6
	MOV R1, 0
  MOV R2, DISPLAY
  MOV R3, VALOR_CONTADOR
  MOV [R2], R1
  MOV [R3], R1
	MOV [APAGA_ECRÃ], R1	; apaga os pixeis
	MOV [APAGA_VIDEO], R1   ; apaga o video
  MOV R1, 5
  MOV [TOCA_SOM], R1
	MOV R1, 3
	MOV [SELECIONA_IMAGEM_FUNDO], R1 ; seleciona a imagem de fundo de game-over
  JMP ciclo_espera_fim


; ***************************************************************************
; ciclo_principal - funciona como "main" da função, local onde as outras 
;                   funções são chamadas e local que decide o passo seguinte.
; ***************************************************************************
ciclo_principal:
  CALL aleatoriedade_luzes
  MOV  R3, [ATUALIZAR_LUZES]
  MOV  R2, 1
  CMP  R3, R2                         ;se interrupção tiver sinalizado, luzes devem ser atualizadas
  JNZ  atualizacao_contador           ;caso contrário passamos para próximo passo

;dependendo da seleção feita pelo o sistema de aleatoriedade uma das rotinas abaixo é escolhida sendo que todas funcionam de forma idêntica
luz_0:
  MOV  R3, [NUM_LUZES]
  CMP  R3, 0                      ;é lido valor de desenho das luzes selecionado e feita uma verificação
  JNZ  luz_1                      ;se estivermos na rotina errada passamos à próxima
  MOV  R4, DEF_LUZES_0
  CALL luzes                      ;caso contrário desenhamos luzes com a definição pretendida
luz_1:
  CMP  R3, 1
  JNZ  luz_2
  MOV  R4, DEF_LUZES_1
  CALL luzes
luz_2:
  CMP  R3, 2
  JNZ  luz_3
  MOV  R4, DEF_LUZES_2
  CALL luzes
luz_3:
  CMP  R3, 3
  JNZ  atualizacao_contador
  MOV  R4, DEF_LUZES_3
  CALL luzes

atualizacao_contador:
  MOV  R2, 1
  MOV  R3, [ATUALIZAR_CONTADOR]
  CMP  R2, R3                         ;caso o sinal de atualização do contador tenha sido dado pela interrupção executar rotina de decremento
  JNZ  integridade_nave               ;caso contrário, passar a próxima rotina
  CALL contador

;verifica condições de fim de jogo
integridade_nave:
  CALL teste_limite_nave              ;executar rotina responsável por testar se algum asteróide bateu na nave
  MOV  R2, 1
  MOV  R3, [ATINGIU_NAVE]
  CMP  R3, R2
  JZ   fim_explosao                   ;caso tal tenha acontecido, executar fim de jogo adequado

  MOV  R3, [ENERGIA_ACABOU]           ;verificar se nave ainda tem energia
  CMP  R3, R2
  JZ   fim_energia                    ;se não tiver, executar fim de jogo adequado
  
colisao_sondas:
  CALL colisao_sonda_asteroide   ;verificar se houve colisão entre sonda e asteroide

ha_asteroide:                    ;verifica se asteroides devem ser redesenhados devido a alteração da posição dos mesmos
  MOV  R2, 1
  MOV  R3, [BOOL_ASTEROIDE]
  CMP  R3, R2
  JNZ  sondas
  CALL asteroide
  CALL mineravel
  CALL asteroide_direita

sondas:                         ;semelhante à anterior mas neste caso para as sondas(só se aplica a sondas que tenham sido disparadas, verificação é feita através do SONDA_*)
  MOV  R1, [BOOL_SONDAS]
  CMP  R1, R2
  JNZ  fase_teclado
ha_sonda_centro:
  MOV  R1, [SONDA_CENTRO]
  CMP  R1, R2
  JNZ  ha_sonda_esquerda
  CALL sonda_centro
ha_sonda_esquerda:
  MOV  R1, [SONDA_ESQUERDA]
  CMP  R1, R2
  JNZ  ha_sonda_direita
  CALL sonda_esquerda
ha_sonda_direita:
  MOV  R1, [SONDA_DIREITA]
  CMP  R1, R2
  JNZ  fase_teclado
  CALL sonda_direita

fase_teclado:                  ;fase do ciclo principal em que é feita a leitura do input do jogador
  CALL teclado            ;input é lido

  tecla_f:
    MOV  R1, 0FH
    CMP  R8, R1             ;se for F, o jogador desistiu e a nave autodestroi-se provocando uma explosão
    JZ   fim_explosao

  tecla_c:
    MOV  R1, 0CH
	  CMP  R8, R1             ;se for C, é executado um restart do jogo para que o jogador possa recomeçar se o jogo estiver a correr mal
	  JNZ  tecla1
    CALL condicoes_iniciais ;isto é feito aplicando as condições iniciais e recomeçando o jogo no ciclo principal
    CALL imagem_inicial
    CALL inicio_do_jogo
    JMP  ciclo_principal

  tecla1:
    MOV  R1, 1H
    CMP  R8, R1             ;se for 1, sonda do centro deve ser disparada
    JNZ  tecla_0
    MOV  R1, 3
    MOV  [TOCA_SOM], R1     ;isto implica um som, gasto de energia e inicialização da sonda
    CALL contador_sondas
    CALL sonda_centro
  
  tecla_0:                  ;identico ao anterior mas para sonda da esquerda
    MOV  R1, 0H
    CMP  R8, R1
    JNZ  tecla_2
    MOV  R1, 3
    MOV  [TOCA_SOM], R1
    CALL contador_sondas
    CALL sonda_esquerda

  tecla_2:                  ;identico ao anterior mas para sonda da direita
    MOV  R1, 2H
    CMP  R8, R1
    JNZ  tecla_b
    MOV  R1, 3
    MOV  [TOCA_SOM], R1
    CALL contador_sondas
    CALL sonda_direita

  tecla_b:
    MOV  R1, 0BH
    CMP  R8, R1                   ;se for B devemos pôr o jogo em pausa 
    JNZ  tecla_7
    CALL pausa                    ;chamando rotina de pausa
    CALL inicio_do_jogo           ;e continuando o jogo quando o utilizador sair da mesma

  tecla_7:
    MOV  R1, 07H
    CMP  R8, R1                   ;se for 7 AUMENTA O SOM 
    JNZ  tecla_6
    CALL aumenta_som                    ;chamando rotina DE AUMENTAR O SOM

  tecla_6:
    MOV  R1, 06H
    CMP  R8, R1                   ;se for 6 DIMINUI O SOM 
    JNZ  fim_do_ciclo_principal
    CALL diminui_som                    ;chamando rotina de DIMINUI O SOM

  fim_do_ciclo_principal:
    JMP ciclo_principal           ;volta ao inicio do ciclo para que este possa ser percorrido mais uma vez


; ***************************************************************************
; contador - rotina que diminui periódicamente a energia da nave e a apresenta no display
; ***************************************************************************
contador:
  PUSH  R0
  PUSH  R1
  PUSH  R2
  PUSH  R3
  PUSH  R4
  PUSH  R5
  PUSH  R6
  PUSH  R7
  PUSH  R8

  MOV R0, 0
  MOV [ATUALIZAR_CONTADOR], R0    ;indicar que já estamos a fazer update do valor da energia

  MOV R8, 3                       ;colocar o valor a subtrair no registo adequado
  MOV R4, DISPLAY                 ;obter endereço do display
  MOV R5, MASCARA                 ;obter máscara que será usada para isolar bits do algarismo das unidades
  MOV R7, VALOR_CONTADOR          ;obtém valor do contador para ser apresentado no ecrã (este está guardado em meória no enderço com a etiqueta VALOR_CONTADOR)
  MOV R1, [R7]                    ;esse valor (que vai ser atualizado) é colocado no R1
  JMP ciclo_diminuir              ;saltar para instruções que efetuam a subtração

contador_sondas:                  ;idêntico ao anterior mas para diminuir em 5 valor de energia devido a disparar de uma sonda
  PUSH  R0
  PUSH  R1
  PUSH  R2
  PUSH  R3
  PUSH  R4
  PUSH  R5
  PUSH  R6
  PUSH  R7
  PUSH  R8

  MOV R8, 5
  MOV R4, DISPLAY
  MOV R5, MASCARA 
  MOV R7, VALOR_CONTADOR
  MOV R1, [R7]
  JMP ciclo_diminuir

ciclo_diminuir:                   ;ciclo responsável pela diminuição especificada
  MOV R6, 100H
  CMP R1, R6                      ;se o contador tiver valor 100 e quisermos diminuir temos que fazer a passagem entre 100-99
  JZ  cem_nn
  CMP R1, 000H                    ;se o contador chegar a 0, o ciclo deve terminar
  
  ; GAME OVER, NO ENERGY
  JNZ  continuar_contagem
  CALL sem_energia

continuar_contagem:
  MOV R3, R1         ;fazer cópia do nº atual
  AND R3, R5         ;aplicar máscara de modo a isolar nibble inferior
  CMP R3, 0          ;se nibble inferior = 0 temos que diminuir em 1 as dezenas e por unidades a 9
  JZ  diminui_dezenas
  SUB R1, 1
  SUB R8, 1          ;R8 guarda quantas vezes temos de subtrair 1 par atingirmos a subtração desejada, quando o mesmo atingir o valor 0 sabemos que operação está terminada
  JNZ ciclo_diminuir ;caso contrário podemos só diminuir 1 unidade e continuar
  MOV [R7], R1       ;atualizar valor na memória
  JMP fim_contagem

diminui_dezenas:
  MOV R2, R1         ;fazer cópia de R1
  MOV R1, 9H         ;colocar R1 a 9 (reset das unidades)
  SHR R2, 4          ;fazer shift right para isolar digito responsável por apresentar algarismo das dezenas
  SUB R2, 1          ;subtrair um ao mesmo
  SHL R2, 4          ;voltar a colocar na posição certa (posição das dezenas)
  OR  R1, R2         ;juntar os algarismos para formar o novo número
  SUB R8, 1
  JNZ ciclo_diminuir
  MOV [R7], R1 	     ;atualizar valor na memória
  JMP fim_contagem

cem_nn:
	MOV R1, 99H        
  SUB R8, 1
  JNZ ciclo_diminuir
	MOV [R7], R1      ;atualizar valor de contar para 99
	JMP fim_contagem

fim_contagem:
	MOV [R4], R1      ;escrever valor nos displays e sair da rotina

  POP R8
  POP R7
  POP R6
  POP R5
  POP R4
  POP R3
  POP R2
  POP R1
  POP R0
  RET

; ***************************************************************************
; aumenta_energia - função que aumenta a energia quando um asteroide 
;                   mineravel é atingido (rotina muito semelhante à anterior)
; ***************************************************************************
aumentar_energia:
  PUSH  R0
  PUSH  R1
  PUSH  R2
  PUSH  R3
  PUSH  R4
  PUSH  R5
  PUSH  R6
  PUSH  R7
  PUSH  R8
  
  MOV R8, 25            ;valor de energia deve aumentar em 25 pontos
  MOV R4, DISPLAY
  MOV R5, MASCARA 
  MOV R7,	VALOR_CONTADOR
  MOV R1, [R7]
ciclo_aumentar:
  MOV R6, 99H           ;colocar 99 num registo para podermos executar a comparação
  CMP R1, R6            ;se o número atual fôr igual a 99 o próximo será 100 e para tal temos que executar uma rotina
  JZ  nn_cem            ;é igual e rotina é executada, caso contrário esta instrução é ignorada e passamos à seguinte
  MOV R3, R1            ;fazer cópia do nº atual
  AND R3, R5            ;aplicar máscara de modo a isolar nibble inferior
  MOV R6, 9H            ;colocar 9 num registo para ser usado na comparação
  CMP R3, R6            ;comparar valor do nibble inferior com 9
  JZ  aumentar_dezenas  ;sendo iguais teremos que aumentar as dezenas em 1 e fazer reset às unidades
  ADD R1, 1             ;caso contrário adicionamos 1 ao valor atual e podemos prosseguir
  SUB R8, 1
  JNZ ciclo_aumentar
  MOV [R7], R1          ;atualizar valor na memória
  JMP fim_contagem

aumentar_dezenas:
  MOV R2, R1         ;fazer cópia de nº atual
  MOV R1, 0H         ;colocar R1 a zero (reset das unidades)
  SHR R2, 4          ;fazer shift para podermos manipular facilmente o valor das dezenas
  ADD R2, 1          ;aumentar dezenas em 1
  SHL R2, 4          ;voltar a colocar valor das dezenas na posição certa
  OR  R1, R2         ;juntar as dezenas e as unidades de forma a termos o nº completo
  SUB R8, 1
  JNZ ciclo_aumentar
  MOV [R7], R1
  JMP fim_contagem

nn_cem:               
  MOV R1, 100H
  SUB R8, 1
  JNZ ciclo_aumentar
  MOV [R7], R1      ;atualizar valor de contador para 100
  JMP fim_contagem


; ***************************************************************************
; atualiza_asteroide - interrupção dos asteroides. Quando a interrupção é chamada
;                     fica sinalizado, através de valor na memória, que os asteroides
;                     devem ser redesenhados visto que mudaram de posição
; ***************************************************************************
atualiza_asteroide:
  PUSH  R0

  MOV R0, 1
  MOV [BOOL_ASTEROIDE], R0

  POP R0

  RFE

; ***************************************************************************
; atualiza_contador - inturrepção do contador. Quando a interrupção é chamada
;                     fica sinalizado, através de valor na memória, que o valor
;                     do contador deve ser atualizado
; ***************************************************************************
atualiza_contador:
  PUSH R0

  MOV R0, 1
  MOV [ATUALIZAR_CONTADOR], R0

  POP R0
  RFE

; ***************************************************************************
; atualiza_sonda - inturrepção da sonda. Quando a interrupção é chamada
;                  fica sinalizado, através de valor na memória, que posição
;                  das sondas ativas deve ser atualizada
; ***************************************************************************
atualiza_sonda:
  PUSH R0

  MOV R0, 1
  MOV [BOOL_SONDAS], R0

  POP R0
  RFE


; ***************************************************************************
; sonda_centro- desenha a sonda centro 
; ***************************************************************************
sonda_centro:
  PUSH  R0
  PUSH  R1
  PUSH  R2
  PUSH  R3
  PUSH  R4
  PUSH  R5
  PUSH  R6
  PUSH  R7
  PUSH  R8
  PUSH  R9
  PUSH  R10
  
  EI1
  MOV  R0, 1
  MOV  [SONDA_CENTRO], R0

	MOV  R1, [LINHA_SONDA_CENTRO]
	MOV  R2, [COLUNA_SONDA_CENTRO]

  MOV  R4, DEF_SONDA_APAGADA
  CALL desenha
  MOV  R1, [LINHA_SONDA_CENTRO]
  SUB  R1, 1
	MOV  [LINHA_SONDA_CENTRO], R1
	
teste_limite_centro:                   ;testa os limites do ecra para saber quando parar o ciclo de apagar e desenhar  
  MOV  R10, 0EH
  MOV  R1, [LINHA_SONDA_CENTRO]
	CMP  R1, R10
  JNZ  continua_centro
  CALL reset_sonda_centro
  JMP  fim_sonda_centro

  continua_centro:
  MOV  R1, [LINHA_SONDA_CENTRO]
	MOV  R2, [COLUNA_SONDA_CENTRO]
	MOV	 R4, DEF_SONDA
  CALL desenha
  JMP  fim_sonda_centro

  CALL reset_sonda_centro

fim_sonda_centro:
  MOV R0, 0
  MOV [BOOL_SONDAS], R0
  
  POP R10
  POP R9
  POP R8
  POP R7
  POP R6
  POP R5
  POP R4
  POP R3
  POP R2
  POP R1
  POP R0
  RET  

; ***************************************************************************
; reset_sonda_centro- dá reset aos valores da linha e da coluna
;                     guardados em memoria  
; ***************************************************************************
reset_sonda_centro:
  PUSH R1
	MOV  R1, LINHA_SONDA_CENTRO_INICIAL
  MOV  [LINHA_SONDA_CENTRO], R1
  MOV  R1, 0
  MOV  [SONDA_CENTRO], R1
  DI1
  POP  R1
  RET

; ***************************************************************************
; sonda_esquerda- desenha a sonda esquerda  
; ***************************************************************************
sonda_esquerda:
  PUSH  R0
  PUSH  R1
  PUSH  R2
  PUSH  R3
  PUSH  R4
  PUSH  R5
  PUSH  R6
  PUSH  R7
  PUSH  R8
  PUSH  R9
  PUSH  R10
  
  EI1
  MOV  R0, 1
  MOV  [SONDA_ESQUERDA], R0

	MOV  R1, [LINHA_SONDA_ESQUERDA]
	MOV  R2, [COLUNA_SONDA_ESQUERDA]

  MOV  R4, DEF_SONDA_APAGADA
  CALL desenha

  MOV  R1, [LINHA_SONDA_ESQUERDA]
  SUB  R1, 1
	MOV  [LINHA_SONDA_ESQUERDA], R1
  MOV  R1, [COLUNA_SONDA_ESQUERDA]
  SUB  R1, 1
  MOV  [COLUNA_SONDA_ESQUERDA], R1
	
teste_limite_esquerda:                   ;testa os limites do ecra para saber quando parar o ciclo de apagar e desenhar
  MOV  R10, 0EH
  MOV  R1, [LINHA_SONDA_ESQUERDA]
	CMP  R1, R10
  JNZ  continua_esquerda
  CALL reset_sonda_esquerda
  JMP  fim_sonda_esquerda

continua_esquerda:
  MOV  R1, [LINHA_SONDA_ESQUERDA]
	MOV  R2, [COLUNA_SONDA_ESQUERDA]
	MOV	 R4, DEF_SONDA
  CALL desenha
  JMP  fim_sonda_esquerda

  CALL reset_sonda_esquerda


fim_sonda_esquerda:
  MOV R0, 0
  MOV [BOOL_SONDAS], R0

  POP R10
  POP R9
  POP R8
  POP R7
  POP R6
  POP R5
  POP R4
  POP R3
  POP R2
  POP R1
  POP R0
  RET

; ***************************************************************************
; reset_sonda_esquerda- dá reset aos valores da linha e da coluna
;                     guardados em memoria  
; ***************************************************************************
reset_sonda_esquerda:
  PUSH R1
	MOV  R1, LINHA_SONDA_ESQUERDA_INICIAL
  MOV  [LINHA_SONDA_ESQUERDA], R1
  MOV  R1, COLUNA_SONDA_ESQUERDA_INICIAL
  MOV  [COLUNA_SONDA_ESQUERDA], R1
  MOV  R1, 0
  MOV  [SONDA_ESQUERDA], R1
  DI1
  POP  R1
  RET

; ***************************************************************************
; sonda_direita- desenha a sonda direita  
; ***************************************************************************
sonda_direita:
  PUSH  R0
  PUSH  R1
  PUSH  R2
  PUSH  R3
  PUSH  R4
  PUSH  R5
  PUSH  R6
  PUSH  R7
  PUSH  R8
  PUSH  R9
  PUSH  R10
  
  EI1
  MOV  R0, 1
  MOV  [SONDA_DIREITA], R0

	MOV  R1, [LINHA_SONDA_DIREITA]
	MOV  R2, [COLUNA_SONDA_DIREITA]

  MOV  R4, DEF_SONDA_APAGADA
  CALL desenha

  MOV  R1, [LINHA_SONDA_DIREITA]
  SUB  R1, 1
  MOV  [LINHA_SONDA_DIREITA], R1
  MOV  R1, [COLUNA_SONDA_DIREITA]
  ADD  R1, 1
	MOV  [COLUNA_SONDA_DIREITA], R1
	
teste_limite_direita:                   ;testa os limites do ecra para saber quando parar o ciclo de apagar e desenhar  
  MOV  R10, 0EH
  MOV  R1, [LINHA_SONDA_DIREITA]
	CMP  R1, R10
  JNZ  continua_direita
  CALL reset_sonda_direita
  JMP  fim_sonda_direita

  continua_direita:
  MOV  R1, [LINHA_SONDA_DIREITA]
	MOV  R2, [COLUNA_SONDA_DIREITA]
	MOV	 R4, DEF_SONDA
  CALL desenha
  JMP  fim_sonda_direita

  CALL reset_sonda_direita
 
fim_sonda_direita:
  MOV  R0, 0
  MOV  [BOOL_SONDAS], R0
  
  POP R10
  POP R9
  POP R8
  POP R7
  POP R6
  POP R5
  POP R4
  POP R3
  POP R2
  POP R1
  POP R0
  RET

; ***************************************************************************
; reset_sonda_direita- dá reset aos valores da linha e da coluna
;                     guardados em memoria  
; ***************************************************************************
reset_sonda_direita:
  PUSH R1
	MOV  R1, LINHA_SONDA_DIREITA_INICIAL
  MOV  [LINHA_SONDA_DIREITA], R1
  MOV  R1, COLUNA_SONDA_DIREITA_INICIAL
  MOV  [COLUNA_SONDA_DIREITA], R1
  MOV  R1, 0
  MOV  [SONDA_DIREITA], R1
  DI1
  POP  R1
  RET


; ***************************************************************************
; asteroide - desenha as asteroide nao-mineravel
; ***************************************************************************
asteroide:
  PUSH  R0
  PUSH  R1
  PUSH  R2
  PUSH  R3
  PUSH  R4
  PUSH  R5
  PUSH  R6
  PUSH  R7
  PUSH  R8
  PUSH  R9
  PUSH  R10

	MOV  R3, LINHA_ASTEROIDE			; linha do asteroid
	MOV  R1, [R3]
	MOV  R5, COLUNA_ASTEROIDE		; coluna do asteroid
	MOV  R2, [R5]

  MOV  R4, DEF_ASTEROIDE_APAGADO
  CALL desenha

  MOV  R3, LINHA_ASTEROIDE
  MOV  R1, [R3]
  MOV  R5, COLUNA_ASTEROIDE
  MOV  R1, [R5]
  ADD  R1, 1
	MOV  [R3], R1
	ADD  R2, 1
	MOV  [R5], R2

	MOV	 R4, DEF_ASTEROIDE		; endereço da tabela que define o asteroid
  CALL desenha

  MOV  R0, 0
  MOV  [BOOL_ASTEROIDE], R0

  POP R10
  POP R9
  POP R8
  POP R7
  POP R6
  POP R5
  POP R4
  POP R3
  POP R2
  POP R1
  POP R0
  RET


; ***************************************************************************
; asteroide_direita- desenha as asteroide nao-mineravel
; ***************************************************************************
asteroide_direita:
  PUSH  R0
  PUSH  R1
  PUSH  R2
  PUSH  R3
  PUSH  R4
  PUSH  R5
  PUSH  R6
  PUSH  R7
  PUSH  R8
  PUSH  R9
  PUSH  R10

	MOV  R3, LINHA_ASTEROIDE_DIREITA			; linha do asteroid
	MOV  R1, [R3]
	MOV  R5, COLUNA_ASTEROIDE_DIREITA		; coluna do asteroid
	MOV  R2, [R5]

  MOV  R4, DEF_ASTEROIDE_APAGADO
  CALL desenha

  MOV  R3, LINHA_ASTEROIDE_DIREITA
  MOV  R1, [R3]
  MOV  R5, COLUNA_ASTEROIDE_DIREITA
  MOV  R2, [R5]
  ADD  R1, 1
	MOV  [R3], R1
	SUB  R2, 1
	MOV  [R5], R2

	MOV	 R4, DEF_ASTEROIDE		; endereço da tabela que define o asteroid
  CALL desenha

  MOV  R0, 0
  MOV  [BOOL_ASTEROIDE], R0

  POP R10
  POP R9
  POP R8
  POP R7
  POP R6
  POP R5
  POP R4
  POP R3
  POP R2
  POP R1
  POP R0
  RET


; ***************************************************************************
; mineravel- desenha asteroide mineravel 
; ***************************************************************************
mineravel:
  PUSH  R0
  PUSH  R1
  PUSH  R2
  PUSH  R3
  PUSH  R4

	MOV  R1, [LINHA_MINERAVEL]
	MOV  R2, [COLUNA_MINERAVEL]

  MOV  R4, DEF_ASTEROIDE_APAGADO
  CALL desenha

  MOV  R1, [LINHA_MINERAVEL]
	MOV  R2, [COLUNA_MINERAVEL]

  ADD  R1, 1
	MOV  [LINHA_MINERAVEL], R1

  MOV	 R4, DEF_MINERAVEL
  CALL desenha

  MOV  R0, 0
  MOV  [BOOL_ASTEROIDE], R0

  POP R4
  POP R3
  POP R2
  POP R1
  POP R0
  RET

; ***************************************************************************
; painel- desenha a nave  
; ***************************************************************************
painel:
	MOV  R1, LINHA_PAINEL
	MOV  R2, COLUNA_PAINEL
	MOV	 R4, DEF_PAINEL
  CALL desenha
  RET


; ***************************************************************************
; luzes- desenha as luzes iniciais
; ***************************************************************************
luzes:
	MOV  R1, LINHA_LUZES
	MOV  R2, COLUNA_LUZES
  MOV  R3, 0
  MOV  [ATUALIZAR_LUZES], R3
  CALL desenha
  RET


; ***************************************************************************
; teste_limite_nave - testa a colisão asteroide-nave
; ***************************************************************************
teste_limite_nave:
  PUSH  R0
  PUSH  R1
  PUSH  R2
  PUSH  R3
  PUSH  R4
  PUSH  R5
  PUSH  R6
  PUSH  R7

  MOV R2, COLUNA_ASTEROIDE
  MOV R1, [R2]
	MOV R6, LIM_ESQUERDO_ASTEROIDE
	CMP R1, R6
	JNZ proxima_colisao

  MOV R6, 1
  MOV R7, ATINGIU_NAVE
  MOV [R7], R6

proxima_colisao:
  MOV R2, LINHA_MINERAVEL
  MOV R1, [R2]
  MOV R6, LIM_ESQUERDO_ASTEROIDE
  CMP R1, R6
  JNZ proxima_colisao_direita
  MOV R6, 1
  MOV [ATINGIU_NAVE], R6

proxima_colisao_direita:
  MOV R2, LINHA_ASTEROIDE_DIREITA
  MOV R1, [R2]
	MOV R6, LIM_ESQUERDO_ASTEROIDE
	CMP R1, R6
	JNZ nao_atingiu

  MOV R6, 1
  MOV R7, ATINGIU_NAVE
  MOV [R7], R6



nao_atingiu:
  POP R7
  POP R6
  POP R5
  POP R4
  POP R3
  POP R2
  POP R1
  POP R0

  RET


; ***************************************************************************
; asteroide_destruido - testa a colisão asteroide-sonda
; ***************************************************************************
colisao_sonda_asteroide:
  PUSH  R0
  PUSH  R1
  PUSH  R2
  PUSH  R3
  PUSH  R4
  PUSH  R5
 
  MOV  R0, LINHA_SONDA_ESQUERDA
  MOV  R2, [R0]
  MOV  R1, LINHA_ASTEROIDE
  MOV  R3, [R1]
  ADD  R3, 3
  CMP  R2, R3
  JNZ  proximo_centro_tiro 

	MOV  R3, LINHA_ASTEROIDE
	MOV  R1, [R3]
	MOV  R5, COLUNA_ASTEROIDE
	MOV  R2, [R5]

  MOV  R4, DEF_ASTEROIDE_DESTRUIDO
  CALL desenha

  CALL atraso

  MOV  R4, DEF_ASTEROIDE_APAGADO
  CALL desenha

  MOV  R2, 0
  MOV  [R3], R2
  MOV  [R5], R2

	MOV  R3, LINHA_SONDA_ESQUERDA
	MOV  R1, [R3]
	MOV  R5, COLUNA_SONDA_ESQUERDA
	MOV  R2, [R5]
  MOV  R4, 26
  MOV  [R3], R4
  MOV  [R5], R4
	MOV  R3, SONDA_ESQUERDA
	MOV  R1, [R3]
  MOV  R2, 0
  MOV  [R3], R2  

proximo_centro_tiro:
  MOV  R1, [SONDA_CENTRO]
  MOV  R0, 1
  CMP  R1, R0
  JNZ  proximo_direita_tiro
  MOV  R0, LINHA_SONDA_CENTRO
  MOV  R2, [R0]
  MOV  R1, LINHA_MINERAVEL
  MOV  R3, [R1]
  ADD  R3, 4
  CMP  R2, R3
  JNZ  proximo_direita_tiro

	MOV  R3, LINHA_MINERAVEL
	MOV  R1, [R3]
	MOV  R5, COLUNA_MINERAVEL
	MOV  R2, [R5]
  CALL aumentar_energia

  MOV  R4, DEF_ASTEROIDE_DESTRUIDO
  CALL desenha

  CALL atraso

  MOV  R4, DEF_ASTEROIDE_APAGADO
  CALL desenha

  MOV  R2, 0
  MOV  [R3], R2

	MOV  R3, LINHA_SONDA_CENTRO
	MOV  R1, [R3]
  MOV  R4, 26
  MOV  [R3], R4

	MOV  R3, SONDA_CENTRO
	MOV  R1, [R3]
  MOV  R2, 0
  MOV  [R3], R2  


proximo_direita_tiro:

  MOV  R0, LINHA_SONDA_DIREITA
  MOV  R2, [R0]
  MOV  R1, LINHA_ASTEROIDE_DIREITA
  MOV  R3, [R1]
  ADD  R3, 3
  CMP  R2, R3
  JNZ  fim_asteroide_destruido 

	MOV  R3, LINHA_ASTEROIDE_DIREITA
	MOV  R1, [R3]
	MOV  R5, COLUNA_ASTEROIDE_DIREITA
	MOV  R2, [R5]

  MOV  R4, DEF_ASTEROIDE_DESTRUIDO
  CALL desenha

  CALL atraso

  MOV  R4, DEF_ASTEROIDE_APAGADO
  CALL desenha

  MOV  R2, 0
  MOV  [R3], R2
  MOV  R2, 58
  MOV  [R5], R2

	MOV  R3, LINHA_SONDA_DIREITA
	MOV  R1, [R3]
	MOV  R5, COLUNA_SONDA_DIREITA
	MOV  R2, [R5]
  MOV  R4, 26
  MOV  [R3], R4
  MOV  R4, 36
  MOV  [R5], R4
	MOV  R3, SONDA_DIREITA
	MOV  R1, [R3]
  MOV  R2, 0
  MOV  [R3], R2  

fim_asteroide_destruido:
  POP R5
  POP R4
  POP R3
  POP R2
  POP R1
  POP R0

  RET

; ***************************************************************************
; atraso - função de atraso
; ***************************************************************************

atraso:
  MOV R7, ATRASO
ciclo_atraso:
  SUB R7, 1
  JNZ ciclo_atraso
  RET
; ***************************************************************************
; desenha - rotina geral que desenha os diversos bonecos no ecrâ
; ***************************************************************************
desenha:
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	PUSH R7
	
	MOV  R5, [R4]			    ;obtém a altura do asteroid
	MOV  R7, R5				    ;cópia da altura do asteroid
	ADD	 R4, 2				    ;endereço da largur do asteroid (2 porque a altura é uma word)
	MOV  R6, [R4]			    ;obtém a largura do asteroid
	ADD	 R4, 2				    ;endereço da cor do 1.º pixel (2 porque a largura é uma word)
	
desenha_pixels:         ;desenha os pixels do asteroid a partir da tabela
	MOV	 R3, [R4]			    ;obtém a cor do próximo pixel do asteroid
	CALL escreve_pixel	  ;escreve o pixel na linha e coluna definidas
	ADD	 R4, 2				    ;endereço da cor do próximo pixel (2 porque a cor do pixel é uma word)
 	ADD  R2, 1            ;próxima coluna
 	SUB  R5, 1				    ;menos uma coluna para tratar
 	JNZ  desenha_pixels		;repete até percorrer toda a largura (colunas) do objeto
	
desenha_proxima_linha:
	SUB  R6, 1 				    ;linhas por desenhar
	JZ   sai_desenha 	    ;todas as linhas já desenhadas?
	ADD  R1, 1 		   	    ;próxima linha
	MOV  R5, R7			    	;obtém a largura do asteroid
	SUB  R2, R5		 	    	;primeira coluna
	JMP  desenha_pixels
	
sai_desenha:
	POP  R7
	POP  R6
	POP  R5
	POP  R4
	POP  R3
	POP  R2
	POP  R1
	RET

; ***************************************************************************
; escreve_pixel - desenha o pixel escolhido no ecrã
; ***************************************************************************
escreve_pixel:
	MOV  [DEFINE_LINHA], R1		;seleciona a linha
	MOV  [DEFINE_COLUNA], R2	;seleciona a coluna
	MOV  [DEFINE_PIXEL], R3		;altera a cor do pixel na linha e coluna já selecionadas
	RET


; ***************************************************************************
; reset - dá reset ás coordenadas do asteroide
; ***************************************************************************
reset:								            ;esta função introduz na word da linha_asteroid e da coluna_asteroid
	MOV  R1, LINHA_ASTEROIDE        ;os valores iniciais, quando o asteroid atinge o limite, neste caso o pixel antes da nave
	MOV  R2, 0
	MOV  [R1], R2
	MOV  R1, COLUNA_ASTEROIDE
	MOV  [R1], R2
	
  POP R5
	POP R3
	POP R2
	POP R1
	RET


; ***************************************************************************
; pausa - introduz as condições de pausa, ou seja, imagem, som 
;         e espera que a tecla B seja premida para continuar o jogo
; ***************************************************************************
pausa:
  DI
  PUSH R1
  MOV  R1, 4
  MOV  [TOCA_SOM], R1                   ;toca som da pausa
  MOV  R1, 0
	MOV  [APAGA_ECRÃ], R1	                ;apaga os pixeis
	MOV  [APAGA_VIDEO], R1                ;apaga o video
	MOV  R1, 1 
	MOV  [SELECIONA_IMAGEM_FUNDO], R1     ;seleciona a imagem de fundo de pausa
ciclo_pausa:                            ;espera que jogador volte a pressionar B de modo a regressar ao curso normal do jogo
  MOV  R8, 10H
  CALL teclado
	MOV  R1, 0BH
	CMP  R8, R1
	JNZ  ciclo_pausa
  POP  R1
  RET


; ***************************************************************************
; teclado - le a tecla do teclado premida pelo utilizador
; ***************************************************************************
teclado:
  PUSH R0
  PUSH R2
  PUSH R3
  PUSH R4
  PUSH R5
  PUSH R6
  PUSH R7

;inicializa��es
  MOV  R2, TEC_LIN    ;endere�o do perif�rico das linhas
  MOV  R3, TEC_COL    ;endere�o do perif�rico das colunas
  MOV  R5, MASCARA    ;para isolar os 4 bits de menor peso, ao ler as colunas do teclado

ciclo_teclado:

  MOV  R8, LINHA      ;coloca valor da linha inicial em R1
  MOV  R6, R8         ;faz c�pia de R1 (como no proxima_linha mas para a primeira linha)

espera_tecla:         ;neste ciclo espera-se at� uma tecla ser premida
  AND  R8, R5	        ;ver se ainda estamos a avaliar alguma linha
  JZ   n_tecla        ;caso tenhamos percorrido todas as linhas, recome�ar
  MOVB [R2], R8       ;enviar sinal para o perif�rico de sa�da (codifica��o da linha)
  MOVB R0, [R3]       ;ler do perif�rico de entrada (codifica��o da coluna)
  AND  R0, R5         ;elimina bits para al�m dos bits 0-3
  CMP  R0, 0          ;h� tecla premida?
  JZ   proxima_linha  ;se nenhuma tecla premida, muda de linha e repete

  CALL ha_tecla

  CALL conversao   
	                    ;sabemos que o valor correspondente a cada combina��o de linha e coluna � dado por: 4*l+c
  MOV  R7, 4          ;load do 4 no registo para ser usado na multiplica��o
  MUL  R8, R7         ;4*linha
  ADD  R8, R0         ;+coluna 
  JMP  pops_teclado

    
ha_tecla:             ;neste ciclo espera-se at� NENHUMA tecla estar premida
  MOV  R8, R6         ;repor valor de linha a testar (R1 tinha sido alterado)
  MOVB [R2], R8       ;enviar sinal para o perif�rico de sa�da (linhas)
  MOV  R1, R0
  MOVB R1, [R3]       ;ler do perif�rico de entrada (colunas)
  AND  R1, R5         ;elimina bits para al�m dos bits 0-3
  CMP  R1, 0          ;h� tecla premida?
  JNZ  ha_tecla       ;se ainda houver uma tecla premida, espera at� n�o haver
  RET

proxima_linha:
  SHR  R8, 1          ;shift um bit para mudar de linha
  MOV  R6, R8         ;faz copy de R1 para R6 de modo a podermos repor R1 no ha_tecla
  JMP  espera_tecla   ;ap�s mudar a linha selecionada vamos verificar se h� alguma tecla ativa nessa nova linha

n_tecla:
  MOV  R8, 10H
pops_teclado:
  POP R7
  POP R6
  POP R5
  POP R4
  POP R3
  POP R2
  POP R0
  RET


; ***************************************************************************
; conversao - converte o valor da tecla para hexadecimal
; ***************************************************************************
conversao:                      ;esta rotina � respons�vel por converter o n� das linhas e colunas para Hexadecimal
  MOV  R7, 0                    ;registo que vai guardar os valores convertidos para Hexadecimal
ciclo_conversao_linha:
  ADD  R7, 1                    ;a quantidade de shifts at� detectar um 1 representa o valor da linha ou coluna em Hexa
  SHR  R8, 1                    ;bit que saiu � 1? Se n�o, repetir ciclo 
  JNC  ciclo_conversao_linha
                                ;o bit � 1 por isso podemos atualizar o valor da linha
  SUB  R7, 1                    ;subtrair 1 ao valor para ajustar offset causado pela primeira itera��o do ciclo
  MOV  R8, R7                   ;atualizar valor da linha
  MOV  R7, 0                    ;fazer RESET ao valor de R7 para poder voltar a ser usado na convers�o da coluna
ciclo_conversao_coluna:         ;an�logo ao ciclo_conversao_linha mas para a coluna
  ADD  R7, 1
  SHR  R0, 1
  JNC  ciclo_conversao_coluna
  SUB  R7, 1
  MOV  R0, R7
  RET


; ***************************************************************************
; imagem_inicial - introduz o fundo inicial
; ***************************************************************************
imagem_inicial:
  MOV R1, 0
  MOV [APAGA_AVISO], R1		              ;apaga o aviso de nenhum cenário selecionado
  MOV [APAGA_ECRÃ], R1		              ;apaga todos os pixels já desenhados
  MOV R1, 0			    	                  ;cenário de fundo inicial
  MOV [SELECIONA_IMAGEM_FUNDO], R1
  RET


; ***************************************************************************
; aumenta_som - aumenta o som de fundo
; ***************************************************************************

aumenta_som:
  PUSH R1
  PUSH R2

  MOV R1, 2
  MOV [SELECIONA_VIDEO_FUNDO], R1
  MOV R1, [VOLUME_SOM]
  CMP R1, 0
  JNZ seguinte_aumenta
  MOV R1, 25
  JMP aumenta_aumenta

seguinte_aumenta:
  MOV R2, 25
  ADD R1, R2
  MOV R2, 100
  CMP R2, R1
  JN aumenta_som_ret

aumenta_aumenta:
  MOV [MODIFICA_VOLUME_SOM], R1
  MOV [VOLUME_SOM], R1

aumenta_som_ret:
  POP R2
  POP R1
  RET



; ***************************************************************************
; diminui_som - diminui o som de fundo
; ***************************************************************************

diminui_som:
  PUSH R1
  PUSH R2

  MOV R1, 2
  MOV [SELECIONA_VIDEO_FUNDO], R1
  MOV R1, [VOLUME_SOM]
  MOV R2, 25
  SUB R1, R2
  MOV R2, 0
  CMP R1, R2
  JN diminui_som_ret
  MOV [MODIFICA_VOLUME_SOM], R1
  MOV [VOLUME_SOM], R1

diminui_som_ret:
  POP R2
  POP R1
  RET
; ***************************************************************************
; condições iniciais - inicializa os locais de memoria que servirão
;                      para controlarem posteriormente funções do jogo
; ***************************************************************************
condicoes_iniciais:
  MOV  R1, 0
  MOV  [ATUALIZAR_CONTADOR], R1
  MOV  [ATUALIZAR_CONTADOR], R1
  MOV  [ENERGIA_ACABOU], R1
  MOV  [BOOL_ASTEROIDE], R1
  MOV  [BOOL_SONDAS], R1
  MOV  [SONDA_CENTRO], R1
  MOV  [SONDA_ESQUERDA], R1
  MOV  [SONDA_DIREITA], R1
  MOV  [ATINGIU_NAVE], R1
  MOV R1, 100
  MOV [VOLUME_SOM], R1
  MOV  R2, 100H
  MOV  [VALOR_CONTADOR], R2
  MOV  [DISPLAY], R2
  MOV R1, 2
  MOV [SELECIONA_VIDEO_FUNDO], R1
  MOV R2, [VOLUME_SOM]
  MOV [MODIFICA_VOLUME_SOM], R2
  MOV  R3, LINHA_ASTEROIDE_INICIAL
  MOV  [LINHA_ASTEROIDE], R3
  MOV  R3, COLUNA_ASTEROIDE_INICIAL
  MOV  [COLUNA_ASTEROIDE], R3
  MOV  R3, LINHA_MINERAVEL_INICIAL
  MOV  [LINHA_MINERAVEL], R3
  MOV  R3, COLUNA_MINERAVEL_INICIAL
  MOV  [COLUNA_MINERAVEL], R3
  MOV  R3, LINHA_ASTEROIDE_DIREITA_INICIAL
  MOV  [LINHA_ASTEROIDE_DIREITA], R3  
  MOV  R3, COLUNA_ASTEROIDE_DIREITA_INICIAL
  MOV  [COLUNA_ASTEROIDE_DIREITA], R3

  CALL reset_sonda_centro
  CALL reset_sonda_direita
  CALL reset_sonda_esquerda
  RET


; ***************************************************************************
; inicio_do_jogo - introduz o inicio do jogo, ou seja,
;                 imagem, som e que dá inicio ás interrupções
; ***************************************************************************
inicio_do_jogo:					              ;esta função é chamada quando a tecla C é primida e inicia o jogo
	MOV  [APAGA_AVISO], R1		          ;apaga o aviso de nenhum cenário selecionado
  MOV  [APAGA_ECRÃ], R1		            ;apaga todos os pixels já desenhados
	MOV	 R1, 0			    	              ;cenário de fundo número 0
  MOV  [SELECIONA_VIDEO_FUNDO], R1	  ;seleciona o cenário de fundo
	MOV  [INICIAR_VIDEO], R1;           ;inicia o video em loop
  MOV  R1, 2
  MOV  [TOCA_SOM], R1                 ;toca som

  CALL painel                         ;desenha painel da nave
  MOV  R4, DEF_LUZES_0
  CALL luzes                          ;desenha luzes
  ;enable de interrupções (excepto I1 visto que essa só está ativa quando sonda é disparada)
  EI0
  EI2
  EI3
  EI
  RET


; ***************************************************************************
; sem_energia - quando a nave fica sem energia introduz no 
;               local da memoria o valor 1 para indicar que tal aconteceu
; ***************************************************************************
sem_energia:
  PUSH R0

  MOV  R0, 1
  MOV  [ENERGIA_ACABOU], R0

  POP  R0
  RET


; ***************************************************************************
; aleatoriedade_luzes - escolhe um nº 0-3 para decidir qual a versão do boneco
;                     que representa as luzes para as luzes piscarem aleatoriamente
; ***************************************************************************
aleatoriedade_luzes:
  PUSH R0

  MOV  R0, [TEC_COL]
  SHR  R0, 14
  MOV  [NUM_LUZES], R0

  POP  R0
  RET


; ***************************************************************************
; atualiza_luzes - interrupção das luzes. Quando a interrupção é chamada
;                     as luzes da nave ficam a alterar a sua posição
; ***************************************************************************
atualiza_luzes:
  PUSH R0

  MOV R0, 1
  MOV [ATUALIZAR_LUZES], R0

  POP R0
  RFE