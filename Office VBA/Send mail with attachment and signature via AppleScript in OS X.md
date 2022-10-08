```applescript
tell application "Mail"

	set theSubject to "Subject" -- the subject
	set theContent to "Content" -- the content
	set theAddress to "xxx@163.com" -- the receiver 
	set theSignatureName to "signature_name"-- the signature name
	set theAttachmentFile to "Macintosh HD:Users:moligaloo:Downloads:attachment.pdf" -- the attachment path

	set msg to make new outgoing message with properties {subject: theSubject, content: theContent, visible:true}

	tell msg to make new to recipient at end of every to recipient with properties {address:theAddress}
	tell msg to make new attachment with properties {file name:theAttachmentFile as alias}

	set message signature of msg to signature theSignatureName

	send msg
end tell
```