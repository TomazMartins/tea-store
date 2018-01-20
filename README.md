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

Aqui observa-se que, para melhor manutenabilidade e entendimento do projeto, foi preciso criar um novo pacote, entitulado "_requesters_". Nele está contida toda a lógica de requisição e recebimento de respostas do `webservice`.

A interação entre `models`, `controllers` e `views` é a padrão dentro do que já é conhecido em `Ruby On Rails`.

### 3.3. Diagrama de Classes

![Diagrama de Classes](https://github.com/TomazMartins/tea-store/blob/master/uml/class-diagram-models.png)

Por fim, temos o diagrama de classes que traz a interação e relacionamentos entre as classes contidas no pacote `models`.

### 3.4. Detalhamento da Chamada da API
Para melhor demonstrar a comunicação com a API do _webservice_, foi feito um diagrama de sequência, para evidenciar as classes envolvidas e as chamadas de métodos, bem como a interação delas.

A interação com a API ocorre em dois momentos:

- Requisição/Recebimento dos Chás;
- Fechamento de um Pedido.

Para cada um destes momentos um diagrama foi elaborado.

#### 3.4.1. Requisição/Recebimento dos Chás
Esta interação, a princípio, não deveria ocorrer diversas vezes. Apenas uma vez é suficiente, desde que os resultados sejam armazenados em banco de dados e atuallizados periodicamente. Desta forma, além de evitar uma quantidade excessiva de requisições à API, tem-se a oportunidade de manter o sistema em funcionamento, mesmo sem os recursos de internet (_offline_). Atulizações diárias seriam um bom intervalo de tempo.

Abaixo consta o diarama de sequência que demonstrar a interação para esta operação.

![DS - Requisição e Recebimento de Chás](https://github.com/TomazMartins/tea-store/blob/master/uml/request-response-tea.png)

#### 3.4.2. Fechamento de um Pedido

[problema]: https://github.com/TomazMartins/tea-store/blob/master/docs/problem.md
[faraday]: https://github.com/lostisland/faraday
