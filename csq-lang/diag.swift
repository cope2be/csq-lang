//
//  diag.swift
//  csq-lang
//
//  Created by Cope on 19/7/2569 BE.
//

// messy but it works

import Foundation

struct diag_ctx
{
	let token: token

	let hint: String
		
	init(_ token: token, _ hint: String)
	{
		self.token = token
		self.hint = hint
	}
}

@inline(__always)
private func make_msg(_ type: String, _ msg: String, _ hint: String, _ ctxs: [ diag_ctx ]) -> String
{
	var output: String = ""
	var has_header = false
		
	for ctx in ctxs
	{
		let t: token = ctx.token
		
		if !has_header
		{
			has_header = true
			
			output += "\(type): \(msg)\n"
			output += "  --> main.csq:\(t.line):\(t.col)\n"
			output += "   |\n"
		}
		
		let base_str: String = t.lexeme.base
		let start_idx: Substring.Index = t.lexeme.startIndex
		
		let line_start: Substring.Index
		if let last_nl: Substring.Index = base_str[..<start_idx].firstIndex(where: { $0.isNewline })
		{
			line_start = base_str.index(after: last_nl)
		}
		else
		{
			line_start = base_str.startIndex
		}
		
		let line_end = base_str[start_idx...].firstIndex(where: { $0.isNewline }) ?? base_str.endIndex
		output += String(format: "%2d", t.line) + " | \(base_str[line_start..<line_end])\n"
		
		let padding = String(repeating: " ", count: t.col - 1)
		let carets = String(repeating: "^", count: max(1, t.lexeme.count))
		
		output += "   | \(padding)\(carets) \(ctx.hint)\n"
	}
	
	output += "   = \(hint)\n"
	return output
}

// boring white texts are fine (prolly)
func diag_err(_ msg: String, _ hint: String, _ ctxs: [ diag_ctx ])
{
	print(make_msg("error", msg, hint, ctxs))
}
