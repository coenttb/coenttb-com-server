# How to send images in email using `pointfree-html` 

## The issue
I just sent out my first newsletter and the image didn't load. This was dissapointing as I had spend quite some time ensuring the image _would_ load.

My assumption was, as we do for printing HTML to PDf, that we have to encode the image as base64 directly in the email. I had tested this locally using Apple Mail, and when it loaded the image, I was happy. 

Experience has taught me to test further, and so I also created a test mailing list to test sending the email with image. I use mailgun to manage my mailing list, and sending the email with image to that test mailing list also returned an email with correctly loaded image. 

Imagine my dissapointment when I sent out the real first newsletter and immediatlty received feedback that the image wasn't loading (fortunately, the rest was loading correctly). 
