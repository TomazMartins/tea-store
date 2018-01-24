# Tea Store
### Teste para Desenvolvedor Full-Stack

## 1. O Problema
O problema encontra-se na pasta de documentos, neste [link][problema].

## 2. Desenvolvimento
Para o desenvolvimento da solução foi criado uma `VM`, por meio do `Vagrant`. O repositório já contém um `Vagrantfile`.

### 2.1 Usando Vagrant
Os requisitos para utilizar está `Vagrantfile` são:

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

### 2.2 Usando a `gem` `whenever`
Para uma das `features` propostas, foi necessário o uso da `gem` `whenever`, que permite o uso de agendamento de tarefas por meio do `cron`. Então, é necessário a atualização da tabela do `cron` na máquina que irá executar a aplicação. Para isso, execute a seguinte linha de comando no terminal, após navegar até a pasta raiz do projeto `rails`: `$ whenever --update-crontab`.

**Observação:** é necessário averiguar as configurações de relógio da máquina, para que o agendamento seja feito dentro das configurações adequadas. Muitas vezes `VMs` não possuem o relógio sincronizado com o relágio da máquina hospedeira.

## 3. A Solução
Para a solução foi imaginado o uso da linguagem `Ruby`, com o suporte do _framework_ `Ruby on Rails`. Para a comunicação com `webservice` foi feito o uso de bibliotecas nativas de `Ruby`, como `uri` e `net/http`.

Inicialmente foi construído uma abstração em termos de OOP. Para melhor viualização foram compostos alguns diagramas UML.

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

Estas regras são estabelecidas para que possam ser consultadas durante a recomendação de chás. Inicialmente, pensou-se em atribuir para cada chá (`Tea`) recuperado da API uma descrição, contendo informações relativas à estas regras, para que podessem ser consultadas. Em um segundo momento percebeu-se que a consulta por texto seria tediosa. Surgiu então um novo conceito: armazenar as regras em um **dicionário**, atribuindo a cada regra, um código numérico. Este código numérico seria atribuído a cada chá (`Tea`), de forma que poderíamos consultar as regras pela referência numérica.

Uma outra regra de negócio, esta implícita na documentação, é que o frente de caixa (`Cashier`) **não deve** ter acesso à operações sobre os chás (`Tea`), com exeção à **consulta**. Na medida em que as chás (`Teas`) são recuperados a partir do `webservice`, não há porquê permitir que ele tenha condições de criar novos chás (`Tea`), editá-los ou mesmo destruí-los.

### 3.1.2. Requisitos da Aplicação
Os requisitos foram dispostos no formato de _user stories_. Estes requisitos foram convertidos em _issues_ e foi utilizado as próprios recursos da plataforma do **GitHub** para visualização e manejo dos mesmos, pois a manutenção de um ambiente de desenvolvimento contendo o máximo de recursos relativos ao projeto em um só lugar facilita a utilização, manutenção e atualização destes recursos.

A partir da documentação recebida, podesse derivar os seguintes requisitos:

```
Manter Chá (Tea)

"Eu, como frente de caixa, quero ter à minha disponibilidade a possibilidade de visualizar todos os
chás disponíveis na loja, categorizados em diferentes tipos, para ter uma melhor visibilidade dos produtos."
```

```
Manter Pedido (Order)

"Eu, como frente de caixa, quero ter como criar um novo pedido, para que possa ser possível fazer a
venda para um cliente."
```

```
Recomendação de Chá (Tea)

"Eu, como frente de caixa, quero ajuda na hora de definir o melhor chá para o cliente, conforme
suas necessidades, para que o atendimento seja mais rápido."
```

```
Fazer Venda/Fechar de Pedido (Order)

"Eu, como frente de caixa, quero poder fechar uma compra com o cliente, para que haja o registro da
 mesma e a venda do produto."
```

Algumas `tech stories` também foram derivadas, a partir das necessidades trazidas pelas `user stories`. São elas:

```
Requirir do Webservice informações sobre os chás

É necessário uma comunicação com o webservices para que o banco de dados possa ser populado com as
informações referentes aos chás (Tea).

Para isso é necessário que haja um agendamento desta tarefa, assim, ela será executada
periodicamente, garantindo a atualização dos dados.
```

```
Construção de Layouts para Chás (Tea)

É necessário a construção de layouts para a entidade Chá (Tea) que permitam ao frente de caixa
(Cashier) as operações básicas de CRUD.
```

```
Diferentes Tipos de Chás (Tea)

Os chás (Tea) devem estar dentro de uma estrutura hierárquica, na medida em que há diferentes tipos de chás (Tea). Os tipos de chás (Tea) devem ser representados como classes filhas da classe mãe, Chá (Tea).
```

### 3.2. Abstração da Comunicação entre sistema e _Webservice_

![Interação entre API Webservice e Ruby On Rails](https://github.com/TomazMartins/tea-store/blob/master/uml/interaction-ror-webservice.png)

O diagrama apenas retrata o que foi solicitado no documento relativo ao problema:

1. `RoR` envia uma requisição ao `webservice`;
2. `webservice` retorna uma resposta para o `RoR`;
3. `RoR` envia um pedido ao `webservice`, para registro.

### 3.3. Interação entre os pacotes e o `webservice`

![Interação com mais detalhes](https://github.com/TomazMartins/tea-store/blob/master/uml/interaction-more-details.png)

Aqui observa-se que, para melhor manutenabilidade e entendimento do projeto, foi preciso criar um novo pacote, entitulado "_requesters_". Nele está contida toda a lógica de requisição e recebimento de respostas do `webservice`. Isso também garante um dois princípios **SOLID**, de responsabilidade única.

A interação entre `models`, `controllers` e `views` é a padrão dentro do que já é conhecido em `Ruby On Rails`.

### 3.4. Diagrama de Classes

![Diagrama de Classes](https://github.com/TomazMartins/tea-store/blob/master/uml/class-diagram-models.png)

Por fim, temos o diagrama de classes que traz a interação e relacionamentos entre as classes contidas no pacote `models`.

### 3.5. Detalhamento da Chamada da API
Para melhor demonstrar a comunicação com a API do `webservice`, foi feito um diagrama de sequência, para evidenciar as classes envolvidas e as chamadas de métodos, bem como a interação delas.

A interação com a API ocorre em dois momentos:

- Requisição/Recebimento dos Chás;
- Fechamento de um Pedido.

Para cada um destes momentos um diagrama foi elaborado.

#### 3.5.1. Requisição/Recebimento dos Chás
Esta interação, a princípio, não deveria ocorrer diversas vezes. Apenas uma vez é suficiente, desde que os resultados sejam armazenados em banco de dados e atuallizados periodicamente. Desta forma, além de evitar uma quantidade excessiva de requisições à API, tem-se a oportunidade de manter o sistema em funcionamento, mesmo sem os recursos de internet (_offline_). Atualizações diárias seriam um bom intervalo de tempo.

Abaixo consta o diagrama de sequência que demonstra a interação para esta operação. Importante dizer que foram retratados apenas os "caminhos felizes" destas operações.

![DS - Requisição e Recebimento de Chás](https://github.com/TomazMartins/tea-store/blob/master/uml/request-response-tea.png)

Deve-se ressaltar que, para que houvesse o disparo da **requisição**, foi necessário a adição de uma `gem`: [`whenever`][whenever]. Esta `gem` permite trabalhar com o `cron`, de forma a possibilitar o agendamento de tarefas.

1. O sistema, por meio de algum serviço de monitoramento de tempo, como o `cron`, verifica que deve disparar a chamada para uma atualização dos dados relacionados aos chás (`Tea`). Desta forma, ele invoca a chamada `request_teas()`, que é uma `Task` adicionada ao sistema.
2. O `requester` dedicado aos Chás, o `TeaRequester`, então invoca o método `request_tea()`, para fazer a requisição ao `webservice` dos chás. A requisição é feita utilizando a `gem` `faraday`.
3. O _webservices_ retorna, por meio da chamada ao _endpoint_, os chás disponíveis.
4. O `TeaRequester` invoca outro método: `update_teas()`. Neste ponto há a necessidade de averiguar se há algum registro na tabela `Teas`. Caso não haja, os chás serão salvos no banco de dados. Caso já existam registros, eles serão apagados e substituídos pelos novos registros. Isso ocorre porque é mais "barato" a simples substituição do que a averiguação de alterações/substituição de dados absoletos.
5. É invocado o método `save()` da `ActiveRecord` responsável pelos chás. Assim, os dados são salvos no banco de dados e estão prontos para uso.

#### 3.5.2. Fechamento de um Pedido
A interação de fechamento de pedido é mais recorrente. Toda vez que um pedido é efetuado, deve-se abrir uma requisição com o _webservices_. **Talvez seja interessante que haja uma verificação de tempo. Caso a requisição seja efetuada em um intervalo de tempo X, Ok. No entanto, caso o tempo de espera expire, a requisição entraria numa _fila_ (`FIFO`) para que, na próxima vez, fosse enviada juntamente com a requisição atual. Isso seria uma forma de evitar que o sistema pare de funcionar em caso de perde de conexão com a internet**.

Abaixo consta o diagrama de sequência que demonstra a interação para esta operação.

![DS - Fechamento de um Pedido](https://github.com/TomazMartins/tea-store/blob/master/uml/close-order.png)

1. O frente de caixa (`Cashier`) abre um novo pedido, por meio da chamada. Para isso, ele acessa a página '/orders/new' (`new_order_path`).
2. A `action` `new()` invocada abre o formulário, onde o `Cashier` passa os parâmetros para a criação de um novo pedido (`Order`).
3. Com a submissão do formulário, o sistema invoca a `action` `create()`.
4. Devido a chamada anterior, o pedido (`Order`) é então salvo no banco de dados, pela chamada `save()`. Isso desencadeia o retorno de que o pedido foi salvo com sucesso no sistema.
5. Com o pedido salvo no banco de dados, a `OrderController` faz uma chamada ao `OrderRequester`, por meio do método `send_order()`. Assim, faz-se uma busca do último pedido (`Order`) salvo no banco de dados e passa-o como parâmetro para a requisição.
6. `OrderRequester` faz então uma requisição à `API`, por meio da chamada de `send_order()`. Isso acessa o _endpoint_ responsável por receber o pedido, retornando como sucesso a operação.

[problema]: https://github.com/TomazMartins/tea-store/blob/master/docs/problem.md
[faraday]: https://github.com/lostisland/faraday
[whenever]: https://github.com/javan/whenever
