//
//  lexer.swift
//  csq-lang
//
//  Created by Cope on 12/7/2569 BE.
//

// since tcc will do the heavy stuff
// the lexer can be stupid and lazy

enum token_type
{
	case ID
	case VAL
	case SYM
	case ERR
	case EOF
}

struct token
{
	let type: token_type
	let lexeme: Substring
	
	let line: Int
	let col: Int
	
	init(_ type: token_type, _ lexeme: Substring, _ line: Int, _ col: Int)
	{
		self.type = type
		self.lexeme = lexeme
		
		self.line = line
		self.col = col
	}
}

private let SYM_TBL: [ Character: Set<Character> ] = [
	"=": [ "=" ],
	
	"&": [],
	"*": [],
	"^": [],
	"~": [],
	
	"(": [],
	")": [],
	"{": [],
	"}": [],
	
	";": [],
]

struct lexer
{
	private var remainder: Substring
	private let full_src: Substring

	private var line: Int = 1
	private var col: Int = 1
	
	init(_ src: consuming String)
	{
		let substr = Substring(src)
		
		remainder = substr
		full_src = substr
	}
	
	private func peek() -> Character?
	{
		return remainder.first
	}
	
	private func peek(_ offset: Int) -> Character?
	{
		guard
			let idx: Substring.Index = remainder.index(remainder.startIndex, offsetBy: offset, limitedBy: remainder.endIndex),
			idx != remainder.endIndex
		else
		{
			return nil
		}
		
		return remainder[idx]
	}
	
	private mutating func consume(_ amount: Int = 1) -> Void
	{
		let chuck: Substring = remainder.prefix(amount)
		remainder = remainder.dropFirst(amount)
		
		for c: Character in chuck
		{
			if c.isNewline
			{
				line += 1
				col = 1
			}
			else
			{
				col += 1
			}
		}
	}
	
	mutating func next_token() -> token
	{
		while let c: Character = peek(), c.isWhitespace
		{
			consume()
		}
		
		if remainder.isEmpty
		{
			return token(token_type.EOF, "", line, col)
		}
		
		let start_idx: Substring.Index = remainder.startIndex
		
		let start_line: Int = line
		let start_col: Int = col
		
		let c: Character = peek()!
		
		if (c.isLetter && c.isASCII) || c == "_"
		{
			consume()
			
			while
				let next_c: Character = peek(),
				(next_c.isLetter && next_c.isASCII) || next_c == "_"
			{
				consume()
			}
			
			return token(token_type.ID, full_src[start_idx..<remainder.startIndex], start_line, start_col)
		}
		
		if c.isNumber
		{
			consume()
			
			while
				let next_c: Character = peek(),
				next_c.isNumber
			{
				consume()
			}
			
			return token(token_type.VAL, full_src[start_idx..<remainder.startIndex], start_line, start_col)
		}
		
		if let sym: Set<Character> = SYM_TBL[c]
		{
			consume()
			
			if let next_c: Character = peek(), sym.contains(next_c)
			{
				consume()
			}
			
			return token(token_type.SYM, full_src[start_idx..<remainder.startIndex], start_line, start_col)
		}

		consume()
		return token(token_type.ERR, full_src[start_idx..<remainder.startIndex], start_line, start_col)
	}
}
