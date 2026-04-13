---
name: send-email
description: Compose and open an email in Microsoft Outlook for Mac via AppleScript. Use when the user asks to send, draft, or compose an email.
argument-hint: "[to] [subject] [body]"
user-invocable: true
---

# Send Email via Outlook

Compose an email in Microsoft Outlook for Mac and open it for review before sending.

## Arguments

- `$ARGUMENTS` - Natural language description of the email to send. May include recipient, subject, and body content, or the user may provide these separately.

## Instructions

### Step 1: Extract email parameters

From the user's request, determine:
- **To** (required): Email address(es)
- **CC** (optional): CC email address(es)
- **Subject** (required): Email subject line
- **Body** (required): Email body content

If any required field is missing, ask the user.

### Step 2: Format the body as HTML

Convert the body text to HTML for proper rendering in Outlook:
- Paragraphs: wrap in `<p>...</p>` tags
- Line breaks within a block: use `<br>`
- Bullet lists: use `<br>- item` or `<ul><li>...</li></ul>`
- Code/monospace: use `<code>...</code>`
- Bold: use `<b>...</b>`
- Links: use `<a href="...">text</a>`

**Do not use plain text `content` or `plain text content`** — Outlook for Mac ignores newlines in both. HTML in the `content` property is the only reliable way to get line breaks.

### Step 3: Compose via AppleScript

Use a heredoc to avoid shell escaping issues with the AppleScript:

```bash
osascript <<'APPLESCRIPT'
tell application "Microsoft Outlook"
    activate
    set newMsg to make new outgoing message with properties {subject:"<SUBJECT>", content:"<HTML_BODY>"}
    make new to recipient at newMsg with properties {email address:{address:"<TO_ADDRESS>"}}
    -- Add CC if needed:
    -- make new cc recipient at newMsg with properties {email address:{address:"<CC_ADDRESS>"}}
    open newMsg
end tell
APPLESCRIPT
```

**Important:**
- Use `<<'APPLESCRIPT'` (single-quoted heredoc) to prevent shell variable expansion
- Escape any single quotes in the HTML body by closing and reopening: `'` becomes `'"'"'` — but prefer avoiding single quotes in the body (use `&rsquo;` or rephrase)
- The email opens in a compose window for the user to review before sending — it is NOT sent automatically

### Step 4: Confirm

Tell the user the email is open in Outlook for review.
