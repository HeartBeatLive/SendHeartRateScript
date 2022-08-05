# Send Heart Rate Script
This is a script to emulate user's heart rate and send it to the server. \
This is very useful for developement when you want to simulate user's heart rate.

## Example usage
### Send random heart rate
```bash
$ ./send-heart-rate.sh -j $JWT_TOKEN
```

### Send random heart rate to custom server
```bash
$ ./send-heart-rate.sh -j $JWT_TOKEN -e https://rest.heartbeatlive.com/graphql
```

### Send random heart rate with custom timeout
```bash
$ ./send-heart-rate.sh -j $JWT_TOKEN -t 20
```

### Send low heart rate
```bash
$ ./send-heart-rate.sh -j $JWT_TOKEN -l 1 -h 20
```

### Send high heart rate
```bash
$ ./send-heart-rate.sh -j $JWT_TOKEN -l 200 -h 300
```

## Parameters
| Parameter Name | Description |
| -------------- | ----------- |
| `-h`, `--help` | Print command information. |
| `-j` | JWT token to use when making requests. Required. |
| `-l` | Lowest heart rate to use. Default to 30. |
| `-h` | Highest heart rate to use. Default to 170. |
| `-t` | Timeout in seconds between each request. Default to 5. |
| `-e` | Server GraphQL endpoint on which make request. Default to `http://localhost:8080/graphql`. |