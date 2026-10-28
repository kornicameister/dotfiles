---
name: write-as-me
description: Draft or rewrite text others will read under the user's name, including client documents, PR/MR descriptions, commits, colleague messages, and review replies. Requires an explicit official or unofficial mode; ask the user when it is missing.
---

# Write as the user

Keep the user's direct voice, with no AI filler or pathos. Applies to text written under the user's name, not the agent's own replies to the user.

## Required argument: official | unofficial

The user must explicitly choose the mode before you draft or rewrite any text. Accept `official` or `unofficial` as an argument to the skill or an explicit instruction in the request. A mode chosen for the current drafting task remains in effect for its revisions.

**There is no default mode. If the user has not chosen one for the current task, ask `official czy unofficial?` (or the equivalent in the conversation's language) and wait for the answer. Do not produce a draft, infer the mode from the recipient or text type, or silently reuse a mode from an unrelated task.**

These recommendations help the user choose. They do not authorize automatic selection.

| Text | Suggested mode | Shape |
| --- | --- | --- |
| Client-facing documents or documents to be forwarded to a client | `official` | Self-contained purpose, outcome, context, and action needed |
| PR/MR descriptions | `official` | Problem, resulting behavior, relevant validation; follow the repository template |
| Commit messages | `official` | Repository commit convention; concise subject, body when useful |
| Messages to colleagues in Slack, Teams, or DMs | `unofficial` | Short, direct chat message |
| Responses in PR/MR review threads | `unofficial` | Answer the specific comment, explain the reason or actual change; `official` also fits a more formal reply |

Mode controls register. Text type controls structure. An `unofficial` PR description still follows its repository template; an `official` chat reply can still be one sentence. Honor either explicit mode for any text type.

## Shared rules

- Lead with the point. Use plain, concrete words. Remove corporate warmth, ceremonial introductions, generic praise, and offers of help.
- Preserve the user's intent and strength of opinion. Do not turn a question into agreement or uncertainty into a claim.
- Use facts from the current request, thread, or verified task evidence. Never invent ticket IDs, agreement, completed changes, test results, or deployment status.
- Use the language requested for the artifact; otherwise match the target thread or supplied draft. If neither gives a language, use English. Do not infer artifact language from the language used to instruct the agent.
- No em dashes or decorative formatting. Never add typos by hand; they come only from `scripts/typo.py` (see `## Typos`). Keep documents grammatically complete; the narrow allowance for conversational phrasing in official inline comments is described below.
- No automatic thanks-paragraph, sign-off, or "let me know". Keep a specific thank-you when it carries the user's intended meaning.
- Keep confidential details from past examples out of new drafts unless supplied for this task.
- Drafting does not itself authorize posting, sending, committing, or publishing.

## official

Direct, professional, readable engineering prose. No formal-letter ceremony or marketing copy.

- Correct spelling, normal capitalization, full words (`you`, not `u`), and complete sentences in document prose. Commit subjects and concise labels retain their own syntax. For inline technical comments, follow the narrower guidance below.
- No puzzled `??`, casual ellipses, Slack shortcodes, banter, or `MR-ed` in fresh official drafts. Avoid chat shorthand in documents; inline technical comments may use the limited conversational forms described below.
- Include enough context for the intended reader. Do not compress documents into chat fragments merely to make them short.
- Use paragraphs, bullets, headings, tables, or code formatting where useful or required by a template. Avoid decorative bold.
- State uncertainty precisely: what is known, what remains unverified, and the consequence when relevant. Do not add a disclaimer that the writing profile is a guess.

## unofficial

Short and matter-of-fact, like a colleague typing between tasks. Read [references/corpus.md](references/corpus.md) for real English Slack examples of the same intent. The corpus is a voice reference, not evidence for new factual claims.

- Usually one to three short lines. Add detail when needed to explain a blocker or answer a technical question.
- Start at the point; `hey,` or an `@mention` is enough when an opener helps. A one-word acknowledgement is fine when that is the whole answer.
- Casual lowercase openings, `yeah,`, `ah,`, `I am`, `gonna`, `wanna`, `afair`, `FYI`, `thx`, and `up to you` can fit. Do not force them into every draft.
- `u` only fits casual peer chat supported by the context. Use `you` with client reviewers and in technical review replies.
- `->` can mark an outcome or link handover; `;` can join a claim to its detail. Occasional `…` or `??` can fit casual chat. Technical review replies are calmer and normally use a single `?`.
- A light Slack shortcode can fit casual chat, at most one. No emoji in technical review replies by default.
- In ordinary chat, prefer separate lines over headings, bold, bullets, or numbering. Document templates and useful structured comparisons retain their structure. Code fences are for actual code or commands within the message.
- A technical answer that needs more than a line stays one flowing message, not bullets or paragraphs. Restate or confirm the ask first (`yeah,` / `You need X?`), then what you need, then the open decision as `A or B`, with a parenthetical for the options or an aside. Chain with commas, `;` and `+`.
- Own gaps and misses flatly, in the same breath: `I have no idea where to infer fields from`, `yeah, I forgot to create one`. No apology, no cushioning, no explanation beyond the one fact the reader needs.
- AI polish is a failure even when every fact is right; colleagues spot it. Avoid a closing summary line, balanced pros and cons, a sentence that restates the previous one, bold, headings, and a quoted `tldr` block. Real messages are uneven: some lines are one word, one is long and chained.
- A plain `tldr:` can help an unusually long message; skip it in short messages and most longer ones.
- Grammar is not sacred here. Fragments, a dropped subject or auxiliary (`we fine with`, `that question also mean`), missing commas, run-ons, and sentences that start with `but` or `and` are all fine. Do not polish a draft into clean grammar. The meaning must stay unambiguous and every fact exact.
- Typos: see `## Typos`. `unofficial` text carries them at about 10% of its words, scaled to length.
- When editing casual text, retain harmless quirks if they fit the requested edit. Never preserve errors in names, links, identifiers, commands, numbers, or facts.
- Push back directly, often with a concrete question. Use banter only when the current context supports it, not merely because the recipient is a colleague or manager.

## Shape by text type

Apply these rules together with the selected mode.

### Client-facing or forwarded documents

- Write for the final reader, who may not have seen the chat or ticket. State purpose and outcome, then the context needed to understand them.
- Explain user or business impact, decisions, constraints, and next steps. Include implementation details only when they help that reader act or assess the result.
- Define unfamiliar internal shorthand. Make references understandable outside the original conversation.
- Separate confirmed behavior from proposals and open questions. Do not imply a delivery commitment or approval that has not been given.
- Follow the requested document format. No chat greeting, paste wrapper, or sign-off in the document body.

### PR/MR descriptions

- Inspect and follow the applicable repository template, including required headings. Without a template, a small change usually needs a short paragraph plus relevant validation.
- Lead with the concrete problem and resulting behavior. Give a before/after example when helpful.
- Describe the final change for a reviewer who has not seen this conversation. Update title and description when scope changes; omit abandoned approaches unless they explain a trade-off.
- Include validation actually performed and material limitations. Do not substitute a file-by-file changelog or tool log for the explanation.
- Use bullets for distinct changes or checks when useful. Chat layout restrictions do not apply to descriptions.

### Commit messages

- Read and follow applicable commit instructions and the `conventional-commits` skill when available. That convention controls type, scope, casing, breaking-change markers, and subject syntax; this skill controls voice.
- Describe the actual change and its purpose. Keep the subject concise; add a body only for reasoning or consequences the subject cannot carry.
- No greeting, chat shorthand, emoji, PR checklist, or unsupported claims. Creating the commit requires authorization from the task.

### Messages to colleagues

- Give the status, blocker, request, or decision first. Include only the context needed to respond.
- Use one message unless the user asks for a sequence or the supplied exchange clearly calls for one.
- For a handover, include the relevant link and its purpose. For a decision, ask a specific question.

### Replies in PR/MR threads

- Read the comment and surrounding thread. Answer that point first; do not repeat the entire PR description.
- For a completed fix, say what changed and cite relevant code or a commit when useful. Say `fixed` or `done` only when task evidence supports it.
- For disagreement, state the reason and concrete consequence or trade-off. Ask a focused question if clarification is needed.
- For an explanation, give the reasoning and only the detail needed to assess it. A short acknowledgement is enough when there is nothing else to resolve.
- Use bullets for separate review points and fenced code for actual snippets. Avoid headings in a short reply and generic praise such as "Great catch".

For `official` inline technical comments, read [references/technical-comments.md](references/technical-comments.md). User-edited comments support these specific preferences:

- Address the author as a peer. When asking for clarification, prefer a direct question such as `Can you clarify...?`, `Can we confirm...?`, or `Which one is it?` over a repeated `Please confirm/define` instruction. Keep a concrete instruction when that is the actual intent.
- Where two descriptions conflict, ask which is intended. If it could be terminology alone, ask that before prescribing changes to behavior, costs or other sections. Do not invent mutually exclusive alternatives.
- Distinguish verified facts from personal interpretation. A brief `I guess`, `IMHO`, or `as far as I can tell` can qualify a judgement or reading of the document; it must not replace evidence or weaken a verified technical fact. Do not add one to every comment.
- Lowercase openings and natural spoken phrasing are acceptable in these comments. Preserve harmless user phrasing when editing; do not force lowercase, grammatical mistakes or shorthand into fresh text. This exception does not apply to client documents or PR/MR descriptions.
- Keep the technical explanation and useful source links. A conversational question does not require reducing every comment to a one-liner. Format identifiers correctly; do not imitate broken backticks, escaped Markdown or spacing mistakes.

For Jira comments or tickets, use the selected mode and existing ticket structure. Put the outcome first, then distinct findings or steps as bullets when helpful. Mention unverified behavior only when relevant.

## Typos

Typos come only from `scripts/typo.py`, never by hand. Run the final draft through it as the last step, with the mode chosen for the task:

`python3 -I ~/.claude/skills/write-as-me/scripts/typo.py --mode unofficial < draft`

- Density: `unofficial` 10% of words, `official` 3%, counted over the prose of the whole text (code, links and mentions are excluded). Expected typos = density x words; the fractional part is a coin flip. A long text gets several, a short one usually none and sometimes one, so a run that changes nothing is normal.
- Backtick identifiers, commands and names first. The script skips code, links, mentions, shortcodes, `<...>` placeholders, capitalized words and anything with digits.
- Deliver its stdout as is and do not mention the script. Check stderr (`typo: old -> new`) and rerun if the change hit a word that carries meaning.
- Skip it for commit messages; they are permanent and follow a syntax convention. Any other text type follows the chosen mode.

## Delivery and final check

1. Confirm an explicit `official` or `unofficial` choice for this task. If missing, ask and wait.
2. Check mode, text type, recipient, language, and available facts. Apply the relevant shape without importing the other mode's register.
3. Remove filler and unsupported claims. Preserve necessary context, reasoning, and uncertainty. Run `scripts/typo.py` last, in the chosen mode (see `## Typos`).
4. For a standalone paste-ready message, return only the draft in a code block unless requested otherwise. For a document or PR description, return its requested Markdown or artifact without an extra enclosing fence. In an authorized destination, write only the content there.
5. If a missing fact blocks an accurate draft, ask for it. If it can simply be omitted, omit it; never guess.

Use this check in both Claude and Codex. No additional humanizer plugin is required. An optional editing pass must preserve the selected mode, facts, intent, and document structure.

## Maintaining the profile

The [Slack corpus](references/corpus.md) supports the informal English voice. The [technical-comment examples](references/technical-comments.md) contain sanitized before/after excerpts from comments the user edited during an explicit `official` task. They support the narrow inline-comment preferences above, not a general profile of client documents, commits or Polish prose. Unchanged AI-written passages are not independent evidence of the user's voice.

When the user supplies examples, sanitize them following the corpus header and record their text type and register. Adjust inferred voice patterns only when they recur across at least three examples. Explicit user preferences apply immediately without repeated samples.
