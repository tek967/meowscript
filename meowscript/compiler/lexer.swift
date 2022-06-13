//
//  lexer.swift
//  meowscript
//
//  Created by easontek2398 on 13/6/22.
//

import Foundation

enum TokenType {
    case TOKEN_TYPE_OPERATOR
    case TOKEN_TYPE_LITERAL
    case TOKEN_TYPE_SEPERATOR
    case TOKEN_TYPE_KEYWORD
    case TOKEN_TYPE_IDENTIFIER
    case TOKEN_NULL
}
enum TokenName {
    enum Keyword {
        case TOKEN_LET
        case TOKEN_LOOP
        case TOKEN_IF
        case TOKEN_ELSE
        case TOKEN_ELSEIF
        case TOKEN_IS
        case TOKEN_ISNOT
    }
    enum Literal {
        case TOKEN_LITERAL_COMMENT
        case TOKEN_LITERAL_NUMBER
        case TOKEN_LITERAL_STRING
        case TOKEN_LITERAL_BOOLEAN
        case TOKEN_LITERAL_NULL
        case TOKEN_LITERAL_ANY
    }
    enum Operator {
        case TOKEN_OP_PLUS
        case TOKEN_OP_MINUS
        case TOKEN_OP_MULT
        case TOKEN_OP_DIV
        case TOKEN_OP_EQUAL
        case TOKEN_OP_GREATERTHAN
        case TOKEN_OP_LESSTHAN
    }
    enum Seperator {
        case TOKEN_OPENING_BRACE
        case TOKEN_CLOSING_BRACE
        case TOKEN_OPENING_BRACKET
        case TOKEN_CLOSING_BRACKET
        case TOKEN_OPENING_SQBRACKET
        case TOKEN_CLOSING_SQBRACKET
    }
    enum Identifier {
        case TOKEN_END_OF_FILE
        case TOKEN_START_OF_FILE
        case TOKEN_NULL
    }
}

struct Token {
    var type: TokenType
    var name: Any
    var value: Any
}

let LOSList = ["let", "loop", "if", "else", "elseif", "is", "isnt", "function", "+", "-", "*", "/", "(", ")", "{", "}", "[", "]"]

let KeywordList = ["let", "loop", "if", "else", "elseif", "is", "isnt", "function"]
let OperatorList = ["+", "-", "*", "/"]
let SeperatorList = ["(", ")", "{", "}", "[", "]"]

let TokenCharLookup = [
    "let" : TokenName.Keyword.TOKEN_LET,
    "loop" : TokenName.Keyword.TOKEN_LOOP,
    "if" : TokenName.Keyword.TOKEN_IF,
    "else" : TokenName.Keyword.TOKEN_ELSE,
    "elseif" : TokenName.Keyword.TOKEN_ELSEIF,
    "is" : TokenName.Keyword.TOKEN_IS,
    "isnt" : TokenName.Keyword.TOKEN_ISNOT,
    "+" : TokenName.Operator.TOKEN_OP_PLUS,
    "-" : TokenName.Operator.TOKEN_OP_MINUS,
    "*" : TokenName.Operator.TOKEN_OP_MULT,
    "/" : TokenName.Operator.TOKEN_OP_DIV,
    "(" : TokenName.Seperator.TOKEN_OPENING_BRACKET,
    ")" : TokenName.Seperator.TOKEN_CLOSING_BRACKET,
    "{" : TokenName.Seperator.TOKEN_OPENING_BRACE,
    "}" : TokenName.Seperator.TOKEN_CLOSING_BRACE,
    "[" : TokenName.Seperator.TOKEN_OPENING_SQBRACKET,
    "]" : TokenName.Seperator.TOKEN_CLOSING_SQBRACKET
] as [String : Any]

struct Lexer {
    static func Split(expression: String) -> Array<String> {
        let SplitExprList = expression.components(separatedBy: " ")
        var newExprList: Array<String> = []
        for expr in SplitExprList {
            if let _ = TokenCharLookup[expr] {
                newExprList.append(expr)
            } else {
                for stringToken in LOSList {
                    newExprList.append(expr.replacingOccurrences(of: "\(stringToken)", with: "\(stringToken) "))
                }
            }
        }
        return newExprList
    }
    static func DetermineType(stringToken: String) -> TokenType? {
        for kw in KeywordList {
            if stringToken == kw {
                return TokenType.TOKEN_TYPE_KEYWORD
            }
        }
        for op in OperatorList {
            if stringToken == op {
                return TokenType.TOKEN_TYPE_OPERATOR
            }
        }
        for sep in SeperatorList {
            if stringToken == sep {
                return TokenType.TOKEN_TYPE_SEPERATOR
            }
        }
        return nil
    }
    static func Tokenise(StringToken stringToken: String) -> Token {
        if let _ = TokenCharLookup[stringToken] {
            return Token(type: self.DetermineType(stringToken: stringToken)!, name: TokenCharLookup[stringToken]!, value: stringToken)
        } else {
            return Token(type: TokenType.TOKEN_NULL, name: TokenName.Identifier.TOKEN_NULL, value: "NULL")
        }
    }
    static func Lex(expression: String) -> Array<Token> {
        var TokenisedList: Array<Token> = []
        let StringTokenList = self.Split(expression: expression)
        for t in StringTokenList {
            TokenisedList.append(Tokenise(StringToken: t))
        }
        return TokenisedList
    }
}


