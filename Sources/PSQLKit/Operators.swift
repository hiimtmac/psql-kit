import Foundation



///// Matches regular expression, case sensitive    'thomas' ~ '.*thomas.*'
//infix operator ~: LogicalConjunctionPrecedence
///// Matches regular expression, case insensitive    'thomas' ~* '.*Thomas.*'
//infix operator ~*: LogicalConjunctionPrecedence
///// Does not match regular expression, case sensitive    'thomas' !~ '.*Thomas.*'
//infix operator !~: LogicalConjunctionPrecedence
///// Does not match regular expression, case insensitive    'thomas' !~* '.*vadim.*'
//infix operator !~*: LogicalConjunctionPrecedence
