curl -X PUT \
  'https://sandbox.urb-it.com/v3/checkouts/b970bcd0-1ea8-483b-a0c6-4413e8fb33dc/delivery' \
  -H 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiIzMDE4NzAxNS02MjUxLTQ5NDYtOTJiZC04MDVkNDAxMGVkY2YiLCJpYXQiOjE1NjkzMTI0NzUsInJvbGVzIjpbInJldGFpbGVyIl0sInN1YiI6IjkyMDEyNDE5LWQ3M2EtNDJmNS1hMTJjLWNkY2MyMDc0MGRlMyIsImlzcyI6InVyYml0LmNvbSIsIm5hbWUiOiJHXHUwMGUydGVhdXggZCdcdTAwYzltb3Rpb25zIFBhcmlzIiwiZXhwIjoxODg0NjcyNDc1fQ.P3YVPLgkbjJxD-A5-4-e_Cvx3xDmFDJMJIHB7NS5cos' \
  -H 'X-Api-Key: 92012419-d73a-42f5-a12c-cdcc20740de3' \
  -d '{
          "delivery_time": "2018-01-28T19:43:00Z",
          "message": "Door code: 1234",
          "recipient": {
            "first_name": "Test",
            "last_name": "Testsson",
            "address_1": "Example street 52",
            "address_2": "",
            "city": "Paris",
            "postcode": "75000",
            "phone_number": "+331612345678",
            "email": "test@grr.la"
          }
        }'
