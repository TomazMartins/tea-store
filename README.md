# Tea Store
### Teste para Desenvolvedor Full-Stack

## 1. O Problema
O problema encontra-se na pasta de documentos, neste [link][problema].

## 2. Desenvolvimento
Para o desenvolvimento da solução foi criado uma `VM`, por meio do `Vagrant`. O repositório já contém um `Vagrantfile`.
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

## 3. A Solução
Para a solução foi imaginado o uso da linguagem `Ruby`, com o suporte do _framework_ `Ruby on Rails`. Embora `Ruby` traga já bibliotecas que permitam a comunicação com _webservices_, foi pensado na utilização de `gem`s que facilitem o trabalho. Desta forma, foi utilizado a `gem` [`faraday`][faraday].

Inicialmente foi construído uma abstração em termos de OOP. Para melhor viualização foram compostos alguns diagramas UML.

### 3.1. Abstração da Comunicação entre sistema e _Webservice_

![Interação entre API Webservice e Ruby On Rails](https://github.com/TomazMartins/tea-store/blob/master/uml/interaction-ror-webservice.png)

O diagrama apenas retrata o que foi solicitado no documento relativo ao problema:

1. `RoR` envia uma requisição ao `webservice`;
2. `webservice` retorna uma resposta para o `RoR`;
3. `RoR` envia um pedido ao `webservice`, para registro.

### 3.2. Interação entre os pacotes e o _webservice_

![Interação com mais detalhes](https://github.com/TomazMartins/tea-store/blob/master/uml/interaction-more-details.png)

Aqui observa-se que, para melhor manutenabilidade e entendimento do projeto, foi preciso criar um novo pacote, entitulado "_requesters_". Nele está contida toda a lógica de requisição e recebimento de respostas do `webservice`. Isso também garante um dois princípios **SOLID**, de responsabilidade única.

A interação entre `models`, `controllers` e `views` é a padrão dentro do que já é conhecido em `Ruby On Rails`.

### 3.3. Diagrama de Classes

![Diagrama de Classes](https://github.com/TomazMartins/tea-store/blob/master/uml/class-diagram-models-onlytea.png)

Por fim, temos o diagrama de classes que traz a interação e relacionamentos entre as classes contidas no pacote `models`.

### 3.4. Detalhamento da Chamada da API
Para melhor demonstrar a comunicação com a API do _webservice_, foi feito um diagrama de sequência, para evidenciar as classes envolvidas e as chamadas de métodos, bem como a interação delas.

A interação com a API ocorre em dois momentos:

- Requisição/Recebimento dos Chás;
- Fechamento de um Pedido.

Para cada um destes momentos um diagrama foi elaborado.

#### 3.4.1. Requisição/Recebimento dos Chás
Esta interação, a princípio, não deveria ocorrer diversas vezes. Apenas uma vez é suficiente, desde que os resultados sejam armazenados em banco de dados e atuallizados periodicamente. Desta forma, além de evitar uma quantidade excessiva de requisições à API, tem-se a oportunidade de manter o sistema em funcionamento, mesmo sem os recursos de internet (_offline_). Atualizações diárias seriam um bom intervalo de tempo.

Abaixo consta o diagrama de sequência que demonstra a interação para esta operação. Importante dizer que foram retratados apenas os "caminhos felizes" destas operações.

![DS - Requisição e Recebimento de Chás](https://github.com/TomazMartins/tea-store/blob/master/uml/request-response-tea.png)

Deve-se ressaltar que, para que houvesse o disparo da **requisição**, foi necessário a adição de uma `gem`: [`whenever`][whenever]. Esta `gem` permite trabalhar com o `cron`, de forma a possibilitar o agendamento de tarefas.

1. O sistema, por meio de algum serviço de monitoramento de tempo, como o `cron`, verifica que deve disparar a chamada para uma atualização dos dados relacionados aos chás (`Tea`). Desta forma, ele invoca a chamada `request_teas()`, que é uma `Task` adicionada ao sistema.
2. O `requester` dedicado aos Chás, o `TeaRequester`, então invoca o método `request_tea()`, para fazer a requisição ao _webservice_ dos chás. A requisição é feita utilizando a `gem` `faraday`.
3. O _webservices_ retorna, por meio da chamada ao _endpoint_, os chás disponíveis.
4. O `TeaRequester` invoca outro método: `update_teas()`. Neste ponto há a necessidade de averiguar se há algum registro na tabela `Teas`. Caso não haja, os chás serão salvos no banco de dados. Caso já existam registros, eles serão apagados e substituídos pelos novos registros. Isso ocorre porque é mais "barato" a simples substituição do que a averiguação de alterações/substituição de dados absoletos.
5. É invocado o método `save()` da `ActiveRecord` responsável pelos chás. Assim, os dados são salvos no banco de dados e estão prontos para uso.

#### 3.4.2. Fechamento de um Pedido
A interação de fechamento de pedido é mais recorrente. Toda vez que um pedido é efetuado, deve-se abrir uma requisição com o _webservices_. **Talvez seja interessante que haja uma verificação de tempo. Caso a requisição seja efetuada em um intervalo de tempo X, Ok. No entanto, caso o tempo de espera expire, a requisição entraria numa _fila_ (`FIFO`) para que, na próxima vez, fosse enviada juntamente com a requisição atual. Isso seria uma forma de evitar que o sistema pare de funcionar em caso de perde de conexão com a internet**.

Abaixo consta o diagrama de sequência que demonstra a interação para esta operação.

![DS - Fechamento de um Pedido](https://github.com/TomazMartins/tea-store/blob/master/uml/close-order.png)

1. O frente de caixa abre um novo pedido, por meio da chamada. Para isso, ele acessa a página '/orders/new' (`new_order_path`).
2. A `action` `new()` invocada abre o formulário, onde o `Cashier` passa os parâmetros para a criação de um novo pedido (`Order`).
3. Com a submissão do formulário, o sistema invoca a `action` `create()`.
4. Devido a chamada anterior, o pedido (`Order`) é então salvo no banco de dados, pela chamada `save()`. Isso desencadeia o retorno de que o pedido foi salvo com sucesso no sistema.
5. Com o pedido salvo no banco de dados, a `OrderController` faz uma chamada ao `OrderRequester`, por meio do método `send_order()`. Assim, faz-se uma busca do último pedido (`Order`) salvo no banco de dados e passa-o como parâmetro para a requisição.
6. `OrderRequester` faz então uma requisição à `API`, por meio da chamada de `send_order()`. Isso acessa o _endpoint_ responsável por receber o pedido, retornando como sucesso a operação.

[problema]: https://github.com/TomazMartins/tea-store/blob/master/docs/problem.md
[faraday]: https://github.com/lostisland/faraday
[whenever]: https://github.com/javan/whenever
