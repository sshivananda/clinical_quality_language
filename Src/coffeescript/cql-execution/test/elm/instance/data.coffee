###
   WARNING: This is a GENERATED file.  Do not manually edit!

   To generate this file:
       - Edit data.coffee to add a CQL Snippet
       - From java dir: ./gradlew :cql-to-elm:generateTestData
###

### Instance
library TestSnippet version '1'
using QUICK
context Patient
define QuantityA: Quantity {
  unit: 'a',
  value: 12
}

define CodeA: Code {
  system: 'http://loinc.org',
  code: '12345',
  version: '1',
  display: 'Test Code'
}

define ConceptA: Concept {
  codes: { CodeA },
  display: 'Test Concept'
}

define Med : Medication {
  name: 'Best Med Ever',
  isBrand: false
}

define val: QuantityA.value
###

module.exports['Instance'] = {
   "library" : {
      "identifier" : {
         "id" : "TestSnippet",
         "version" : "1"
      },
      "schemaIdentifier" : {
         "id" : "urn:hl7-org:elm",
         "version" : "r1"
      },
      "usings" : {
         "def" : [ {
            "localIdentifier" : "System",
            "uri" : "urn:hl7-org:elm-types:r1"
         }, {
            "localIdentifier" : "QUICK",
            "uri" : "http://hl7.org/fhir"
         } ]
      },
      "statements" : {
         "def" : [ {
            "name" : "Patient",
            "context" : "Patient",
            "expression" : {
               "type" : "SingletonFrom",
               "operand" : {
                  "dataType" : "{http://hl7.org/fhir}Patient",
                  "templateId" : "patient-qicore-qicore-patient",
                  "type" : "Retrieve"
               }
            }
         }, {
            "name" : "QuantityA",
            "context" : "Patient",
            "accessLevel" : "Public",
            "expression" : {
               "classType" : "{urn:hl7-org:elm-types:r1}Quantity",
               "type" : "Instance",
               "element" : [ {
                  "name" : "unit",
                  "value" : {
                     "valueType" : "{urn:hl7-org:elm-types:r1}String",
                     "value" : "a",
                     "type" : "Literal"
                  }
               }, {
                  "name" : "value",
                  "value" : {
                     "type" : "ToDecimal",
                     "operand" : {
                        "valueType" : "{urn:hl7-org:elm-types:r1}Integer",
                        "value" : "12",
                        "type" : "Literal"
                     }
                  }
               } ]
            }
         }, {
            "name" : "CodeA",
            "context" : "Patient",
            "accessLevel" : "Public",
            "expression" : {
               "classType" : "{urn:hl7-org:elm-types:r1}Code",
               "type" : "Instance",
               "element" : [ {
                  "name" : "system",
                  "value" : {
                     "valueType" : "{urn:hl7-org:elm-types:r1}String",
                     "value" : "http://loinc.org",
                     "type" : "Literal"
                  }
               }, {
                  "name" : "code",
                  "value" : {
                     "valueType" : "{urn:hl7-org:elm-types:r1}String",
                     "value" : "12345",
                     "type" : "Literal"
                  }
               }, {
                  "name" : "version",
                  "value" : {
                     "valueType" : "{urn:hl7-org:elm-types:r1}String",
                     "value" : "1",
                     "type" : "Literal"
                  }
               }, {
                  "name" : "display",
                  "value" : {
                     "valueType" : "{urn:hl7-org:elm-types:r1}String",
                     "value" : "Test Code",
                     "type" : "Literal"
                  }
               } ]
            }
         }, {
            "name" : "ConceptA",
            "context" : "Patient",
            "accessLevel" : "Public",
            "expression" : {
               "classType" : "{urn:hl7-org:elm-types:r1}Concept",
               "type" : "Instance",
               "element" : [ {
                  "name" : "codes",
                  "value" : {
                     "type" : "List",
                     "element" : [ {
                        "name" : "CodeA",
                        "type" : "ExpressionRef"
                     } ]
                  }
               }, {
                  "name" : "display",
                  "value" : {
                     "valueType" : "{urn:hl7-org:elm-types:r1}String",
                     "value" : "Test Concept",
                     "type" : "Literal"
                  }
               } ]
            }
         }, {
            "name" : "Med",
            "context" : "Patient",
            "accessLevel" : "Public",
            "expression" : {
               "classType" : "{http://hl7.org/fhir}Medication",
               "type" : "Instance",
               "element" : [ {
                  "name" : "name",
                  "value" : {
                     "valueType" : "{urn:hl7-org:elm-types:r1}String",
                     "value" : "Best Med Ever",
                     "type" : "Literal"
                  }
               }, {
                  "name" : "isBrand",
                  "value" : {
                     "valueType" : "{urn:hl7-org:elm-types:r1}Boolean",
                     "value" : "false",
                     "type" : "Literal"
                  }
               } ]
            }
         }, {
            "name" : "val",
            "context" : "Patient",
            "accessLevel" : "Public",
            "expression" : {
               "path" : "value",
               "type" : "Property",
               "source" : {
                  "name" : "QuantityA",
                  "type" : "ExpressionRef"
               }
            }
         } ]
      }
   }
}

