#Author: your.email@your.domain.com
#Keywords Summary :
#Feature: List of scenarios.
#Scenario: Business rule through list of steps with arguments.
#Given: Some precondition step
#When: Some key actions
#Then: To observe outcomes or validation
#And,But: To enumerate more Given,When,Then steps
#Scenario Outline: List of steps for data-driven as an Examples and <placeholder>
#Examples: Container for s table
#Background: List of steps run before each of the scenarios
#""" (Doc Strings)
#| (Data Tables)
#@ (Tags/Labels):To group Scenarios
#<> (placeholder)
#""
## (Comments)
#Sample Feature Definition Template
@tag
Feature: ConsultaRestricaoCPF
  
  @tag1
  Scenario: Consulta CPF com restricao
    Given url 'http://localhost:8080/api/v1/restricoes/97093236014'
    When method GET 
    Then status 200
   
  @tag2
  Scenario: Consulta CPF sem restricao
    Given url 'http://localhost:8080/api/v1/restricoes/01234567890'
    When method GET 
    Then status 204
   

     