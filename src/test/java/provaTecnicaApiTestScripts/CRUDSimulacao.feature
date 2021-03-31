#Author: Rodrigo Borges - rodrigo_bborges@outlook.com


@tag
Feature: Simulacao

Background:
* url 'http://localhost:8080/api/v1'
  
  @tag1
  Scenario Outline: Incluir_Consultar Simulacao
  # Inclui validação de obrigatoriedade de campos e regras
  * def query = { nome: '<nome>', cpf: '<cpf>', email: '<email>', valor: '<valor>', parcela: '<parcela>', seguro: '<seguro>' }
  # all this function does is to set any empty string value to null, because that is what empty cells in 'Examples' become
    * def nullify = 
    """
    function(o) {
      for (var key in o) {
        if (o[key] == '') o[key] = null;
      }
      return o;
    }
    """
  * def query = nullify(query)
  * print query
  
    Given path '/simulacoes'
    # the 'params' keyword takes json, and will ignore any key that has a null value
    And params query
    When method POST 
    #And request { nome:"<nome>", cpf:"<cpf>", email:"<email>", valor:"<valor>", parcela:"<parcela>", seguro:"<seguro>" }
    #And request { nome:<nome>, cpf:<cpf>, email:<email>, valor:<valor>, parcela:<parcela>, seguro:<seguro> }
    #And request { nome:'<nome>', cpf:'<cpf>', email:'<email>', valor:'<valor>', parcela:'<parcela>', seguro:'<seguro>' }
    #And content-type = 'application/json;charset=UTF-8'
    Then status '<statusInclui>'
    #And match response == { id: '#notnull'}
    
  Given path response.cpf
  When method GET
  Then status '<statusConsulta>'
   
	Examples: 
	
  | nome           | cpf         | email        | valor  | parcela  | seguro | statusInclui | statusConsulta |
  | Nome Teste 1   | 97444802033 | teste1@teste | 1000   | 2        | true   | 201          | 200            |
  | Duplicado      | 97444802033 | teste1@teste | 1000   | 2        | true   | 409          | 200            |
  |                | 19843603028 | teste2@teste | 1000   | 2        | false  | 400          | 404            |
  | Nome Teste 3   |             | teste3@teste | 1000   | 3        | true   | 400          | 404            |
  | Nome Teste 4   | 88456530050 |              | 1000   | 4        | false  | 400          | 404            |
  | Nome Teste 5   | 99515556082 | teste5@teste |        | 5        | true   | 400          | 404            |
  | Nome Teste 6   | 72296023002 | teste6@teste | 1000   |          | false  | 400          | 404            |
  | Nome Teste 7   | 22240026022 | teste7@teste | 1000   | 7        |        | 400          | 404            |
  | Nome Teste 7   | 22240026022 | teste8@teste | 1000   | 8        |        | 400          | 404            |
  | Nome Teste 8   | 22240026022 | teste9       | 1000   | 8        | true   | 400          | 404            |
  | Nome Teste 9   | 0123        | teste8@teste | 1000   | 8        | true   | 400          | 404            |
  | Nome Teste 10  | 22240026022 | teste8@teste | 0999   | 8        | true   | 400          | 404            |
  | Nome Teste 11  | 22240026022 | teste8@teste | 40001  | 8        | true   | 400          | 404            |
  | Nome Teste 11  | 22240026022 | teste8@teste | 1000   | 1        | true   | 400          | 404            |
  | Nome Teste 11  | 22240026022 | teste8@teste | 1000   | 49       | true   | 400          | 404            |
   
  @tag2
  Scenario Outline: Alterar Simualcao
  
  * def query_alt = { nome: '<nome>', cpf: '<cpf>', email: '<email>', valor: '<valor>', parcela: '<parcela>', seguro: '<seguro>' }
  * print query_alt
  
  Given path '/simulacoes'
  And params query_alt
  When method PUT
  Then status '<status>'
  And match response == { nome:	'Alterado', email: 'teste1@alterado', valor: '1001', parcelas: '3', seguro: 'false'}
  
  Examples: 
	
  | nome           | cpf         | email           | valor  | parcela  | seguro  | status|
  | Alterado       | 97444802033 | teste1@alterado | 1001   | 3        | false   | 201   |
  
  
  @tag3
  Scenario Outline: Alterar Simualcao sem sucesso
  #Inclui validação de obrigatoriedade de campos e regras
  
  * def query_alt2 = { nome: '<nome>', cpf: '<cpf>', email: '<email>', valor: '<valor>', parcela: '<parcela>', seguro: '<seguro>' }
  * def nullify = 
    """
    function(o) {
      for (var key in o) {
        if (o[key] == '') o[key] = null;
      }
      return o;
    }
    """
  * def query_alt2 = nullify(query_alt2)
  * print query_alt2
  
  Given path '/simulacoes'
  And params query_alt2
  When method PUT
  Then status 405
  #Especificacao Status = 400
  
  Examples: 
	
  | nome           | cpf         | email        | valor  | parcela  | seguro |
  | Inexistente    | 99999999999 | teste1@teste | 1000   | 2        | true   |
  | Alterado Erro1 | 97444802033 |              | 1000   | 2        | true   |
  | Alterado Erro2 | 97444802033 | teste1@teste |        | 2        | true   |
  | Alterado Erro3 | 97444802033 | teste1@teste | 1000   |          | true   | 
  | Alterado Erro4 | 97444802033 | teste1@tste  | 1000   | 2        |        | 
  | Alterado Erro5 | 97444802033 | teste9       | 1000   | 8        | true   |
  | Alterado Erro6 | 0123        | teste8@teste | 1000   | 8        | true   |    
  | Alterado Erro7 | 97444802033 | teste8@teste | 0999   | 8        | true   |     
  | Alterado Erro8 | 97444802033 | teste8@teste | 40001  | 8        | true   |       
  | Alterado Erro9 | 97444802033 | teste8@teste | 1000   | 1        | true   |      
  | Alterado Erro0 | 97444802033 | teste8@teste | 1000   | 49       | true   |      
  
  
  @tag4
  Scenario: Remover Simulacao

    Given path '/simulacoes'
    And request { cpf: '97444802033' } 
    When method GET
    Then status 200
    Given path response.id
    When method DELETE
    Then status 204
    
    
 @tag5
 Scenario: Remover Simulacao sem sucesso

    Given path '/simulacoes'
    And request { id: '9999' } 
    When method DELETE
    Then status 405
    #especificacao status = 404       