**Mensalidade MTS** é um sistema desenvolvido para que os associados do **Rotaract Club de Matão Terra da Saudade** possam visualizar de forma clara e rápida suas mensalidades pendentes.

**Contexto**: Todos os associados do clube contribuem com uma mensalidade, em um valor definido pelo próprio clube, utilizada para custear atividades internas, eventos de companheirismo e festividades.

O objetivo do sistema é trazer **transparência** à gestão das mensalidades, permitindo que o associado acompanhe suas pendências e que a tesouraria registre no aplicativo quando um pagamento for realizado.

- **Requisitos**
    - O tesoureiro pode cadastrar associados e pode inativar ou ativar eles.
    - O tesoureiro pode cadastrar os pagamentos e marcar como pago.
    - Os associados podem ver as mensalidades pendentes da gestão.
    - Toda vez que um associado é inserido as mensalidades de toda a gestão já é gerada a partir do próximo mês. (Regra de que o primeiro mês o associado não paga).
    - Sistema de login com roles de permissão (Associado, Admin e Tesoureiro).
    - O tesoureiro pode adicionar um novo tesoureiro, para a nova gestão, mas no momento que fizer isso, ele perderá sua role de Tesoureiro, passando a ser um Associado.
 

- **.NET:** Será desenvolvido uma API em .NET utilizando o padrão de projeto Arquitetura Três Camadas**.**
- **Banco de dados:** Será usado o banco de dados PostgreSQL, sendo usado no  Supabase
- **Aplicativo: Flutter** (desenvolvimento híbrido).
