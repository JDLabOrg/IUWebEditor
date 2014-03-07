#!/usr/bin/expect -f

#call heroku auth
spawn heroku auth:whoami

#expect like if statements
# 1 case ) not login -> Enter your
# 2 case ) email -> check the @ 
#       echoing the email to prompt
expect {
    "Enter your Heroku credentials." {
        send_user "NO_ID_NO" 
        exit 1
    }
    "*@*"{
        send_user "expect_out(0, string)\n" 
	exit 0
    }
}
