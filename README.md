# Tea Store
### Teste para Desenvolvedor Full-Stack

## O Problema
O problema encontra-se na pasta de documentos, neste [link][problema].

## Desenvolvimento
Para o desenvolvimento da solução foi criado uma `VM`, por meio do `Vagrant`. O repositório já contém um `Vagrantfile`.
Os requisitos para utilizar está `Vagrantfile` são:

1. Ter a `VirtualBox`instalada na máquina;
2. Ter o `Vagrant` instalado na máquina.

Com isto, basta seguir estes passos para utilizar a `VM`:

1. Entre na raiz do projeto, onde encontra-se o arquivo `Vagrantfile`;
2. Execute o seguinte comando: `$ vagrant up`.
3. Execute: `$ vagrant ssh`;
4. Dentro da máquina virtual, execute: `$ cd /vagrant`.

Assim, você estará dentro da máquina virtual, mas na pasta compartilhada com a máquina hospedeira.

Para sair da máquina virtual, execute: `$ exit`.

## A Solução
Para a solução foi imaginado o uso da linguagem `Ruby`, com o suporte do _framework_ `Ruby on Rails`. Embora `Ruby` traga já bibliotecas que permitam a comunicação com _webservices_, foi pensado na utilização de `gem`s que facilitem o trabalho. Desta forma, foi utilizado a `gem` [`faraday`][faraday].

Inicialmente foi construído uma abstração em termos de OOP. Para melhor viualização foram compostos alguns diagramas UML.

![Interação entre API Webservice e Ruby On Rails](https://github.com/TomazMartins/tea-store/blob/master/uml/interaction-ror-webservice.png)

O diagrama apenas retrata o que foi solicitado no documento relativo ao problema:

1. `RoR` envia uma requisição ao `webservice`;
2. `webservice` retorna uma resposta do `RoR`;
3. `RoR` envia um pedido ao `webservice`, para registro.

![Interação com mais detalhes](https://github.com/TomazMartins/tea-store/blob/master/uml/interaction-more-details.png)

Aqui observa-se que, para melhor manutenabilidade e entendimento do projeto, foi preciso criar um novo pacote, entitulado "_requesters_". Nele está contida toda a lógica de requisição e recebimento de respostas do `webservice`.

A interação entre `models`, `controllers` e `views` é a padrão dentro do que já é conhecido em `Ruby On Rails`.

![Diagrama de Classes](https://github.com/TomazMartins/tea-store/blob/master/uml/class-diagram-models.png)

Por fim, temos o diagrama de classes que traz a interação e relacionamentos entre as classes contidas no pacote `models`.

[problema]: https://github.com/TomazMartins/tea-store/blob/master/docs/problem.md
[faraday]: https://github.com/lostisland/faraday
