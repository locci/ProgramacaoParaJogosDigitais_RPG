
# Projeto QUEST RPG

Neste projeto, vocês deverão implementar diversas mecânicas em um
*role playing game* (RPG). Nessa versão ultra-simplificada de um gênero
vastamente complexo, haverá apenas mecânicas de combate, incluindo items,
habilidades e condições.

## 1. Entrega

Para o primeiro projeto, a entrega será até dia 6/11.

Para o segundo projeto, a entrega será até dia 4/12.

Os projetos valerão 10 pontos a menos por dia de atraso.

### 1.1 Formato

Vocês deverão entregar um arquivo comprimido (zip ou tar.gz) contendo:

1. O projeto LÖVE do jogo de vocês
2. Um relatório com nome e número USP dos participantes

O jogo deverá ser feito para a versão mais recente da LÖVE (11.2), e deverá
incluir todos os pacotes Lua externos que usar. Por exemplo, se você usa o
pacote [SUIT](https://github.com/vrld/suit) para *immediate-mode GUI*, você
deve incluir o código dele no seu projeto. Evite ao máximo usar pacotes
compilados (isso é, não escritos em Lua). Tome cuidado com as licenças.

## 2. Código base

Vocês devem usar o código neste repositório como base para a implementação do
projeto de vocês. Nossa recomendação é fazer um *fork* (usando git) deste
repositório, assim vocês já terão o formato estabelecido e um jeito fácil de
atualizar o código base caso mandemos alguma atualização. Mas não é necessário,
podem se organizar como acharem melhor contanto que o formato de entrega seja
atendido.

### 2.1 Máquina de estados

O código base providenciado nesse repositório tem um sistema simples de máquina
de estado. Cada estado é aproximadamente uma das "telas" do jogo, e eles se
acumulam usando uma pilha, para que seja possível retornar a estados anteriores
automaticamente. Se não houver nenhum estado na pilha, o jogo deve ser
encerrado. Aqui descrevemos as telas do jogo.

#### 2.1.2 Seleção de aventuras

Esse estado contém um menu que lista todas as aventuras do banco de dados para
que os jogadores escolham qual querem jogar.

#### 2.1.2 Progressão da aventura

Cada aventura é composta por uma sequência de encontros, e esse estado segue
essa sequência, retomando-a após cada encontro.

#### 2.1.3 Encontro

Sempre que os personagens dos jogadores se deparam com algum conflito, ele é
resolvido na forma de um encontro. Dentro desse estado, os personagems (dos
jogadores ou não) alternam turnos para realizar ações. Esse estado não possui
representação visual, pois costuma calcular instantaneamente de quem é a próxima
vez.

#### 2.1.4 Turno do jogador

Quando o turno de um personagem chega, eles precisam escolher uma ação para
realizar. Esse estado oferece as opções para os jogadores escolherem. Na versão
do código base, o estado é usado tanto para personagens dos jogadores quanto
personagens inimigos.

### 2.2 Estrutura de pastas

A estrutura de pastas e módulos segue uma arquitetura baseada no
*Model-View-Controller*. A diferença é que os "controllers" são os estados da
pilha. A divisão fica então assim:

+ `assets/`: arquivos de mídia para o jogo (texturas, fontes, sons, etc.)
+ `common/`: módulos e classes usadas por todo o resto do código
+ `database/`: especificação das entidades e cenários do jogo
+ `model/`: módulos e classes que definem a simulção (i.e. mecânicas) do jogo
+ `state/`: os estados de interação que o jogo tem
+ `view/`: classes dos elementos visuais que o jogador vê e interage com

## 3. Tarefas

Diferente dos EPs, no projeto não há uma "solução correta" do enunciado. Cada
grupo deve desenvolver seu projeto como achar melhor, escolhendo dentre as
tarefas listadas aqui. Cada tarefa em geral acrescenta uma mecânica no jogo,
podendo conter não só a parte lógica como também partes visuais e de interação
com usuário (inclusive novos estados/telas). **Vocês ganham até 10 pontos com
cada tarefa que fizerem, até um máximo de 100 pontos**. As tarefas indicam o que
é necessário para ganhar seu valor máximo. Notem que várias delas têm como
pré-requisito tarefas anteriores.

**Dica**: não precisa fazer a tarefa inteira pra ganhar nota nela, então não
percam tempo com subtarefas difíceis. Sigam para a próxima tarefa. Também não
precisam fazer as tarefas na ordem, contanto que satisfaçam seus pré-requisitos.

#### Índice de tarefas

1. [Apresentação](#apresentação-ax)
2. [Qualidade de código](#qualidade-de-código-ux)
3. [Juiciness](#juiciness-jx)
4. [Combate básico](#combate-básico-bx)
5. [Turno dos inimigos](#turno-dos-inimigos-tx)
6. [Estatísticas de combate](#estatísticas-de-combate-ex)
7. [Estatísticas de incerteza](#estatísticas-de-incerteza-zx)
8. [Habilidades](#habilidades-hx)
9. [Items consumíveis](#items-consumíveis-ix)
10. [Items equipáveis](#items-equipáveis-qx)
11. [Condições quantitativas](#condições-quantitativas-cx)
12. [Condições qualitativas](#condições-qualitativas-lx)
13. [Reações](#reações-rx)
14. [Progressão](#progressão-sx)
15. [Conteúdo adicional](#conteúdo-adicional-dx)

### **A**presentação (Ax)

| Código | Critério                                                   | Valor  |
| ------ | ---------------------------------------------------------- | ------ |
| A1     | Atender o formato de entrega                               | +2     |
| A2     | Executar sem erros                                         | +3     |
| A3     | Explicar organização do código no relatório                | +3     |
| A4     | Listar tarefas cumpridas no relatório                      | +2     |

No relatório, listem quais critérios de cada tarefa vocês cumpriram,
preferencialmente usando os códigos.

### Q**u**alidade de código (Ux)

| Código | Critério                                                   | Valor  |
| ------ | ---------------------------------------------------------- | ------ |
| U1     | Passar no [luacheck](https://github.com/mpeterv/luacheck)  | +5     |
| U2     | Separação clara entre Model, View e os estados             | +3     |
| U3     | Módulos de até 200 linhas                                  | +2     |
| U4     | Funções de até 20 linhas                                   | +2     |
| U5     | Linhas com até 100 caracteres                              | +2     |

### **J**uiciness (Jx)

Cada efeito de *juiciness* que vocês colocarem no jogo vale +2 pontos nesta
tarefa. Vocês precisam documentar o efeito no relatório. Algumas sugestões:

+ Efeito sonoros de interação com a interface (mover cursor, selecionar, etc.)
+ Transições entre telas e menus
+ Partículas

### Combate **b**ásico (Bx)

| Código | Critério                                                   | Valor  |
| ------ | ---------------------------------------------------------- | ------ |
| B1     | Seleção de alvo para o ataque                              | +2     |
| B2     | Ataque reduz a vida do alvo em uma quantidade fixa         | +2     |
| B3     | Personagens removidos do encontro quando ficam sem vida    | +2     |
| B4     | Jogador vence o encontro quando elimina todos os oponentes | +2     |
| B5     | Jogador falha a aventura se seus personagens morrerem      | +2     |

Todos os critérios dessa tarefa precisam que haja alguma representação textual
ou visual que o jogador possa ver e entender o que está acontecendo.

### **T**urno dos inimigos (Tx)

Requer [combate básico](#combate-básico-bx).

| Código | Critério                                                   | Valor  |
| ------ | ---------------------------------------------------------- | ------ |
| T1     | Inimigos escolhem suas próprias ações                      | +4     |
| T2     | Inimigos elegem alvos seguindo alguma prioridade           | +4     |
| T3     | Inimigos mudam de comportamento se estão em perigo         | +4     |
| T4     | Comportamento é carregado do banco de dados                | +4     |

### **E**statísticas de combate (Ex)

Requer [combate básico](#combate-básico-bx).

| Código | Critério                                                   | Valor  |
| ------ | ---------------------------------------------------------- | ------ |
| E1     | Poder                                                      | +3     |
| E2     | Resistência                                                | +3     |
| E3     | Velocidade                                                 | +6     |
| E4     | Carregar estatísticas do banco de dados                    | +3     |

O papel de cada estatística de combate fica a critério de vocês, seguindo mais
ou menos essas linhas:

1.  O **poder** indica quanto dano um personagem causa ao atacar. Vocês podem
    usar o valor exato de poder, ou alguma fórmula. Vocês também podem gerar o
    dano aleatoriamente com base no poder do personagem, ou dividir o poder em
    poder físico e mágico.
2.  A **resistência** reduz quanto dano um personagem recebe ao ser atacado.
    Assim como no poder, vocês podem projetar a fórmula que quiserem, usar
    aleatoriedade, e/ou dividir em resitência física e mágica.
3.  A **velocidade** interfere na ordem dos turnos, indicando quem ataca antes
    de quem. Existem várias maneiras de fazer isso mas, em geral, personagens
    mais rápidos atacam antes e/ou com mais frequência. Duas sugestões:
    + [Um sistema de energia][1] onde a velocidade representa o quão rápido o
      personagem fica pronto para agir novamente
    + Iniciativa, como em [*Dungeons & Dragons*][2] (ver em *Iniciative*),
      onde personagens com velocidade maior agem antes

Para ganhar a pontuação completa das estatísticas de poder, resistência e
velocidade, deve haver alguma representação textual e/ou visual delas que o
jogador consegue ver.

[1]: https://journal.stuffwithstuff.com/2014/07/15/a-turn-based-game-loop

[2]: https://www.dndbeyond.com/sources/basic-rules/combat#TheOrderofCombat

### Estatísticas de incerte**z**a (Zx)

Requer [combate básico](#combate-básico-bx).

| Código | Critério                                                   | Valor  |
| ------ | ---------------------------------------------------------- | ------ |
| Z1     | Chance de acerto                                           | +4     |
| Z2     | Acertos críticos                                           | +4     |
| Z3     | Carregar estatísticas do banco de dados                    | +3     |

Assim como nas estatística de combate, a implementação exata destas estatísticas
fica a critério de vocês. De maneira geral:

1.  A **chance de acerto** faz que alguns dos ataques errem, possivelmente
    envolvendo estatísticas de acurácia do atacante e esquiva do defensor.
2.  Os **acertos críticos** são ataques que, com uma chance relativamente
    pequena, causam grandes estragos. Também podem depender de estatísticas
    tanto do atacante quanto do defensor.

Para ganhar a pontuação completa das estatísticas de chance de acerto e de
acertos críticos, deve haver alguma representação textual e/ou visual delas que
o jogador consegue ver.

### **H**abilidades (Hx)

Requer [combate básico](#combate-básico-bx).

| Código | Critério                                                   | Valor  |
| ------ | ---------------------------------------------------------- | ------ |
| H1     | Seleção de habilidade durante o encontro                   | +3     |
| H2     | Narração do uso da habilidade                              | +2     |
| H3     | Usar habilidades consome um recurso                        | +2     |
| H4     | Efeito sobre um único alvo                                 | +3     |
| H5     | Efeito sobre um grupo de alvos                             | +3     |
| H6     | Carregar habilidades do banco de dados                     | +3     |

Cada personagem possui sua própria lista de habilidades e sua própria
estatística de quanto ele ou ela possui do recurso usado. A lista de habilidades
pode ser especificada como parte dos personagens no banco de dados. Sugestão de
nomes para o recurso usado: mana, special points, stamina, etc.

A narração do uso da habilidade pode ser tanto textual quanto audiovisual.

Para os critérios H4 e H5, vocês devem implementar pelo menos 3 habilidades de
cada tipo para ganhar a pontuação total. Os efeitos podem ser só de dano e cura,
ou algo que use as demais mecânicas do jogo (e.g. condições).

### **I**tems consumíveis (Ix)

Requer [combate básico](#combate-básico-bx).

| Código | Critério                                                   | Valor  |
| ------ | ---------------------------------------------------------- | ------ |
| I1     | Seleção de items durante o encontro                        | +3     |
| I2     | Narração do consumo de items                               | +2     |
| I3     | Items consumidos desaparecem                               | +2     |
| I4     | Efeito sobre quem consumiu o item                          | +3     |
| I5     | Inimigos deixam items consumíveis quando morrem            | +3     |
| I6     | Carregar items do banco de dados                           | +3     |

Todos os personagens do jogador compartilham da mesma lista de itens. Essa lista
pode ser especificada como parte da aventura no banco de dados.

A narração do consumo do item pode ser tanto textual quanto audiovisual.

Para o critério I4, vocês devem implementar pelo menos 3 items.

### Items e**q**uipáveis (Qx)

Requer [combate básico](#combate-básico-bx) e [estatísticas de
combate](#estatísticas-de-combate-ex).

| Código | Critério                                                   | Valor  |
| ------ | ---------------------------------------------------------- | ------ |
| Q1     | Personagens podem equipar até número máximo de items       | +2     |
| Q2     | Equipamentos alteram as estatísticas de combate            | +2     |
| Q3     | Personagens só podem equipar um item de cada tipo          | +3     |
| Q4     | O jogador pode trocar os items equipados entre encontros   | +3     |
| Q5     | Personagens têm limitações sobre quais items podem equipar | +3     |
| Q6     | Carregar equipamentos do banco de dados                    | +3     |

Todos os personagens do jogador compartilham da mesma lista de equipamentos.
Essa lista pode ser especificada como parte da aventura no banco de dados.

Para o critério Q2, vocês devem implementar pelo menos 6 equipapentos.

Para o critério Q3, deve haver pelo menos três tipos de equipamento. Sugestões:
armas, escudos, armaduras, amuletos, botas, etc.

O critério Q5 depende do critério Q4. As restrições podem ser especificadas por
personagem no banco de dados. Por exemplo, só a guerreira consegue usar a espada
gigante.

### **C**ondições quantitativas (Cx)

Requer [combate básico](#combate-básico-bx) e [estatísticas de
combate](#estatísticas-de-combate-ex).

| Código | Critério                                                   | Valor  |
| ------ | ---------------------------------------------------------- | ------ |
| C1     | Algumas ações colocam condições em personagens             | +3     |
| C2     | Personagens ficam com condições por alguns turnos          | +3     |
| C3     | Condições alteram as estatísticas de combate               | +3     |
| C5     | Carregar condições do banco de dados                       | +3     |

Condições só são adquiridas dentro de encontros, e somem de um encontro para
outro. Condições podem ser causadas por ataques, itens ou habilidades.

Para ganhar a pontuação completa nos critérios C1 e C2, deve haver alguma
representação textual e/ou visual das condições.

Para o critério C3, vocês devem implementar pelo menos 3 tipos de alteração,
como soma, multiplicação e substituição e ter pelo menos 6 condições usando
algum desses tipos de alteração pelo menos uma vez.

### Condições qua**l**itativas (Lx)

Requer [condições quantitativas](#condições-quantitativas-cx).

| Código | Critério                                                   | Valor  |
| ------ | ---------------------------------------------------------- | ------ |
| L1     | Condições que desabilitam ações                            | +4     |
| L2     | Condições que confundem personagens                        | +4     |
| L3     | Condições que transformam personagens                      | +4     |
| L4     | Carregar condições do banco de dados                       | +4     |

Sugestões de condições que desabilitam ações: paralisia (não pode fazer nenhuma
ação), atordoado (não pode atacar nem usar habilidades, só items), silenciado
(não pode usar habilidades).

Personagens confusos têm uma chance de não fazer a ação que os jogadores
escolherem, fazendo uma aleatória ao invés disso.

Personagens transformados geralmente viram uma criatura inofensiva muito fraca,
sem habilidades e que não pode usar items, como um sapo, uma ovelha, etc.

Para ganhar a pontuação completa nos critérios L1, L2 e L3, deve haver alguma
representação textual e/ou visual das condições.

Para o critério L1, vocês devem implementar pelo menos 3 condições. Os critérios
L2 e L3 podem ficar com apenas uma condição cada.

### **R**eações (Rx)

Requer [combate básico](#combate-básico-bx) e possivelmente outras mecânicas.

| Código | Critério                                                   | Valor  |
| ------ | ---------------------------------------------------------- | ------ |
| R1     | Efeitos no começo do turno                                 | +2     |
| R2     | Efeitos no começo do encontro                              | +2     |
| R3     | Efeitos quando um personagem faz uma ação                  | +3     |
| R4     | Efeitos quando um personagem toma dano                     | +3     |
| R5     | Efeitos quando um personagem morre                         | +3     |
| R6     | Carregar condições do banco de dados                       | +3     |

As mecânicas dessa tarefa devem ser aplicadas em conjunto com alguma outra
mecânica. Exemplos:

+ Uma condição que causa dano no personagem afetado todo começo de turno
+ Um item que te dá uma condição positiva no começo do encontro
+ Uma arma que recupera vida quando um personagem ataca com ela
+ Uma condição que paralisa quem ataca o personagem afetado
+ Um equipamento que causa dano em todos os personagens quando seu dono morre

Para ganhar a pontuação completa nos critérios R1 a R5, deve haver alguma
representação textual e/ou visual quando o efeito for desencadeado. Vocês
também devem implementar pelo menos 3 casos de uso para cada critério.

### Progre**s**são (Sx)

Requer [combate básico](#combate-básico-bx) e possivelmente outras mecânicas.

| Código | Critério                                                   | Valor  |
| ------ | ---------------------------------------------------------- | ------ |
| S1     | Descrições narrativas entre encontros                      | +2     |
| S2     | Pontos de decisão entre encontros                          | +2     |
| S3     | Experiência e níveis                                       | +4     |
| S4     | Dinheiro e lojas                                           | +4     |
| S5     | Carregar essas informações do banco de dados               | +4     |

No critério R1, basta mostrar textos entre encontros, como parte das aventuras.

O critério R2 basicamente diz que aventuras podem ter mais de uma rota. Coisas
como "uma velha misteriosa pede por sua ajuda, vocês aceitam seguí-la?". Deve
haver pelo menos uma aventura de exemplo.

No critério R3, vencer encontros confere pontos de experiência aos personagens,
que sobem de nível quando alcançam certos limiares de experiência. A cada nível,
eles ganham mais vida, habilidades, mana, etc. Deve haver pelo menos três
personagens com progressões diferentes.

No critério R4, vencer encontros confere dinheiro aos personagens, que podem
comprar (como um grupo) items e equipamentos entre encontros. Deve haver pelo
menos uma aventura com lojas no caminho.

### Conteúdo a**d**icional (Dx)

Todo personagem, aventura, item, habilidade, condição, etc. que vocês fizerem
além do requerido nos critérios das tarefas valem +1 ponto nesta tarefa,
contanto que sejam significativamente diferentes do conteúdo já existente. Isto
é, se os jogadores tivessem que escolher entre eles, não deveria haver uma opção
estritamente melhor que a outra. Por exemplo, escolher entre uma arma que causa
mais dano ou uma arma que lhe dá mais velocidade.

# ProgramacaoParaJogosDigitais_RPG
