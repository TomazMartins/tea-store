# Tea Store
### Teste para Desenvolvedor Full-Stack

## 1. O Problema
O problema encontra-se na pasta de documentos, neste [link][problema].

## 2. Desenvolvimento
Para o desenvolvimento da solução foi criado uma `VM`, por meio do `Vagrant`. O repositório já contém um `Vagrantfile`.

### 2.1 Usando Vagrant
Os requisitos para utilizar o `Vagrant` são:

1. Ter a `VirtualBox` instalada na máquina;
2. Ter o `Vagrant` instalado na máquina.

Com isto, basta seguir estes passos para utilizar a `VM`:

1. Entre na raiz do projeto, onde encontra-se o arquivo `Vagrantfile`;
2. Execute o seguinte comando: `$ vagrant up`.
3. Execute: `$ vagrant ssh`;
4. Dentro da máquina virtual, execute: `$ cd /vagrant`.

Assim, você estará dentro da máquina virtual, mas na pasta compartilhada com a máquina hospedeira.
Para executar o projeto no navegador, navegue até a página do projeto `rails`, assim:
`$ cd /teastore`. Agora, basta executar `$ rails s`.

No navegador, acesse pelo endereço: `http://192.168.222.222:3000/`.

Para sair da máquina virtual, execute: `$ exit`.

## 3. A Solução
Para a solução foi imaginado o uso da linguagem `Ruby`, com o suporte do _framework_ `Ruby on Rails`. Para a comunicação com `webservice` foi feito o uso de bibliotecas nativas de `Ruby`, como `uri` e `net/http`.

### 3.1. Os Requisitos e Regras de Negócio
Conforme o documento apresentando o **problema**, algumas regras de negócio são estabelecidas. Além disso, pode-se derivar alguns requisitos da aplicação.

#### 3.1.1. Regras de Negócio
O texto traz as seguintes regras explícitas para os chás (`Tea`):

```
- Chás pretos não são bons para tomar à noite;
- Chás verdes são ótimos para digestão;
- Chás brancos e Oolongs são mais procurados pelo seu teor medicinal;
- Chais são bons acompanhando refeições;
```

Estas regras são estabelecidas para que possam ser consultadas durante a recomendação de chás. Para isto pensou-se em criar uma "central", que teria acesso a todas as regras de negócio referentes aos chás e que podesse decidir quais chás seriam mais indicados para cada caso. A partir de consultas ao banco de dados, selecionaria-se os chs mais indicados para cada caso.

Uma outra regra de negócio, esta implícita na documentação, é que o frente de caixa (`Cashier`) **não deve** ter acesso à operações sobre os chás (`Tea`), com exeção à **consulta**. Na medida em que as chás (`Teas`) são recuperados a partir do `webservice`, não há porquê permitir que ele tenha condições de criar novos chás (`Tea`), editá-los ou mesmo destruí-los.

### 3.1.2. Requisitos da Aplicação
Os requisitos foram dispostos no formato de _user stories_. Estes requisitos foram convertidos em _issues_ e foram utilizados os próprios recursos da plataforma do **GitHub** para visualização e manejo dos mesmos, pois a manutenção de um ambiente de desenvolvimento contendo o máximo de recursos relativos ao projeto em um só lugar facilita a utilização, manutenção e atualização destes recursos.

A partir da documentação recebida, podesse derivar os seguintes requisitos:

**Observação:** o termo **Manter** é utilizado como uma referência ao _CRUD_.

```
Manter Chá (Tea)

"Eu, como frente de caixa, quero ter à minha disponibilidade a possibilidade de
 visualizar todos os chás disponíveis na loja, categorizados em diferentes tipos,
 para ter uma melhor visibilidade dos produtos."
```

```
Manter Pedido (Order)

"Eu, como frente de caixa, quero ter como criar um novo pedido, para que possa
 ser possível fazer a venda para um cliente."
```

```
Manter Cliente (Client)

"Eu, como frente de caixa, quero ser capaz de, ao vender os chás (Tea),
 especificar para qual cliente o chá será vendido, para associar o registro de
 venda àquele cliente."
```

```
Manter Frente de Caixa (Cashier)

"Eu, como administrador, quero ter visibilidade sobre os frentes de
 caixa que utilizam o sistema, podendo adicionar novos funcionários, remover ou
 mesmo atualizar seu cadastro, para que eu tenha controle administrativo sobre
 eles."
```

```
Recomendação de Chá (Tea)

"Eu, como frente de caixa, quero ajuda na hora de definir o melhor chá para o
 cliente, conforme suas necessidades, para que o atendimento seja mais rápido."
```

```
Fazer Venda/Fechar Pedido (Order)

"Eu, como frente de caixa, quero poder fechar uma compra com o cliente, para
 que haja o registro da mesma e a venda do produto."
```

Algumas _tech stories_ também foram derivadas, a partir das necessidades trazidas pelas _user stories_. São elas:

```
Requirir do Webservice informações sobre os chás

É necessário uma comunicação com o webservices para que o banco de dados
possa ser populado com as informações referentes aos chás (Tea).

Para isso é necessário que haja um agendamento desta tarefa, assim, ela
será executada periodicamente, garantindo a atualização dos dados.
```

```
Controle de Acesso

É importante que o frente de caixa não possa ter acesso a todas as funções
sobre as entidades na aplicação. Desta forma, um controle sobre o acesso
aos diferentes recursos se faz necessário.
```

```
Construção de Layouts para Chás (Tea)

É necessário a construção de layouts para a entidade Chá (Tea) que permitam
ao frente de caixa (Cashier) as operações básicas de CRUD.
```

```
Diferentes Tipos de Chás (Tea)

Os chás (Tea) devem estar dentro de uma estrutura hierárquica, na medida em
que há diferentes tipos de chás (Tea). Os tipos de chás (Tea) devem ser
representados como classes filhas da classe mãe, Chá (Tea).
```

### 3.2. Abstração da Comunicação entre sistema e _Webservice_

![Interação entre API Webservice e Ruby On Rails](https://github.com/TomazMartins/tea-store/blob/master/uml/interaction-ror-webservice.png)

O diagrama apenas retrata o que foi solicitado no documento relativo ao problema:

1. `A Aplicação RoR` envia uma requisição ao `webservice`, solicitando acesso a todos os Chás (`Tea`);
2. `webservice` retorna uma resposta para o `A Aplicação RoR`;
3. `RoR` envia um pedido (`Order`) ao `webservice`, para registro.

### 3.3. Interação entre os pacotes e o `webservice`

![Interação com mais detalhes](https://github.com/TomazMartins/tea-store/blob/master/uml/packages-interaction.png)

Aqui observa-se que, para melhor manutenabilidade e entendimento do projeto, foi preciso criar dois novos pacotes, entitulados _requesters_ e _convertes_. Neles está contida toda a lógica de requisição e recebimento de respostas do `webservice` e a lógica para a transformação entre objectos `Ruby` e `JSON` (da forma como o `webservice` espera), respectivamente. Isso também garante um dois princípios **SOLID**, de responsabilidade única.

A interação entre `models`, `controllers` e `views` é a padrão dentro do que já é conhecido em `Ruby On Rails`, utilizando-se do padrão arquitetural `MVC`.

### 3.4. Diagrama de Classes

![Diagrama de Classes](https://github.com/TomazMartins/tea-store/blob/master/uml/class-diagram-models.png)

Por fim, temos o diagrama de classes que traz a interação e relacionamentos entre as classes contidas no pacote `models`.

### 3.5. Detalhamento da Chamada da API
Para melhor demonstrar a comunicação com a API do `webservice`, foi feito um diagrama de sequência, para evidenciar as classes envolvidas e as chamadas de métodos, bem como a interação entre elas.

A interação com a API ocorre em dois momentos:

- Requisição/Recebimento dos Chás;
- Fechamento de um Pedido.

Para cada um destes momentos um diagrama foi elaborado.

#### 3.5.1. Requisição/Recebimento dos Chás
Esta interação com o `webservice` ocorre todas as vezes que o frente de caixa consultar os Chás (`Tea`). Esta interação é disparadas diversas vezes porque, na medida em que o sistema envolve a venda de produtos, há uma atualizaçã constante do estoque. Assim, é necessário esta consulta ao `webservice`, pois há mais de uma loja, ou seja, mais de uma fonte consumidora de estoque.

Abaixo consta o diagrama de sequência que demonstra a interação para esta operação. Importante dizer que foram retratados apenas os "caminhos felizes" destas operações.

![DS - Requisição e Recebimento de Chás](https://github.com/TomazMartins/tea-store/blob/master/uml/request-response-tea.png)

1. O frente de caixa (`Cashier`) pretende consultar os chás (`Tea`) disponíveis na loja, então aciona a tela para ver **todos** os chás (`Tea`);
2. A a solicitação para ver todos os Chás (`Tea`) é entendida pela aplicação, que envia uma solicitação à `TeaController`, para acessar a `action` `index()`;
3. Pela `action` `index` a _controller_ inicia o processo de requisição dos Chás (`Tea`), a partir da chamada do método `request_tea()`, de um objeto especializado neste tipo de chamada, o `TeaRequester`;
4. O `TeaRequester` abre uma requisição ao `webservice`, que responde com um objeto no formato `JSON`. O `TeaRequester`, então, retorna este objeto à `TeaController`;
5. Como a aplicação não sabe lidar com objetos `JSON`, a _controller_ faz uma chamada ao método `hash_from_json` a um objeto `TeaConverter`, especializado na conversão;
6. `TeaConverter` retorna então uma `hash` à _controller_. Foi escolhido a transformação em uma `hash`, na medida em que desejasse criar múltiplos objetos ao mesmo tempo. Para isto, faz-se uso de uma `hash` como argumento para a `ActiveRecord`. A `TeaController` chama então o método `create()`;
7. A modelo `Tea` então invoca o método `save()`, para armazenar os dados no banco de dados, que por sua vez retorna que os dados foram salvos com sucesso. Esta informação é passado então ao frente de caixa (`Cashier`).

#### 3.5.2. Fechamento de um Pedido
A interação de fechamento de pedido é mais recorrente. Toda vez que um pedido é efetuado, deve-se abrir uma requisição com o _webservices_.

Abaixo consta o diagrama de sequência que demonstra a interação para esta operação.

![DS - Fechamento de um Pedido](https://github.com/TomazMartins/tea-store/blob/master/uml/close-order.png)

1. O frente de caixa (`Cashier`) abre um novo pedido, por meio da chamada.
2. A `action` `new()` invocada abre o formulário, onde o `Cashier` passa os parâmetros para a criação de um novo pedido (`Order`).
3. Com a submissão do formulário, o sistema invoca a `action` `create()`.
4. Devido a chamada anterior, o pedido (`Order`) é então salvo no banco de dados, pela chamada `save()`. Isso desencadeia uma mensagem de retorno de que o pedido foi salvo com sucesso no sistema.
5. Com o pedido salvo no banco de dados, a `OrderController` faz uma chamada ao `OrderConverter`, por meio do método `to_json()`, afim de transformar o objeto, previamente salvo no banco de dados, em um objeto `JSON`.
6. O objeto `JSON`, resultado da conversão, É então inserido como argumento na chamada dométodo `send_order()`, do `OrderRequester`, que faz uma requisição à `API`, acessando o _endpoint_ de recebimento de pedidos.

**Observação:** É interessante que haja uma verificação de tempo. Caso a requisição seja efetuada em um intervalo de tempo previamente acordado, Ok. No entanto, caso o tempo de espera expire, a requisição entraria numa _fila_ (`FIFO`) para que, na próxima vez, fosse enviada juntamente com a requisição atual. Isso seria uma forma de evitar que o sistema pare de funcionar em caso de perde de conexão com a internet. Outra solução seria uma coluna na tabela de pedidos (`Order`) no banco de dados que indicasse quais pedidos já foram enviados e quais não. Assim, poderiasse reenviar os marcados como "_não enviados_" ainda em outra oportunidade.

### 3.6 Recomendação de Chás
Na solução imaginada uma classe seria responsável pela consulta às **regras de negócio**. Pode-se atribuir o nome de `TeaRecommenderer`. E, além disso, o uso do padrão de projeto **Strategy Pattern**. Vamos aos diagramas!
Com a adição da class `TeaRecommenderer` o diagrama de pacotes ficaria assim:

![pacotes - com reomendação](https://github.com/TomazMartins/tea-store/blob/master/uml/packages-plus-recommenderer.png)

Na solução, uma `interface/abstract class` seria criada, contendo o método `recommender_tea()`. Para cada uma das **regras de negócio** um `Strategy` seria elaborada, na forma de uma nova classe que implementaria a `interface/abstract class`. Cada classe implementaria o método `recommender_tea()` à sua maneira, de forma a estar responder corretamente aos critérios da estratégia. Em linhas gerais, uma consulta ao banco de dados com argumentos particulares a cada regra de negócio.

Assim, o `TeaRecommenderer` seria chamado pela _controller_ para fazer recomendações de chás. A forma como o `TeaRecommenderer` fica encapsulada e não há necessidade da _controller_ saber como ele o faz, pois basta o envio do critério de busca. Além disso, fica mais manutenível o código, além de legível. Se uma nova regra de negócio surge, bas adicionar uma nava class `Strategy`.

O diagrama de classes para o `Strategy` ficaria assim:

![strategy](https://github.com/TomazMartins/tea-store/blob/master/uml/strategy-recommenderer.png)

Para visualizar as operações para esta funcionalidade pode-se seguir o diagrama de sequência abaixo:

![pacotes - com reomendação](https://github.com/TomazMartins/tea-store/blob/master/uml/recommendation-teas.png)

[problema]: https://github.com/TomazMartins/tea-store/blob/master/docs/problem.md
