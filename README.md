# myworld
zork-like world; server component only

## start server

Use `0.0.0.0` so that other computers on network may connect.
```
rackup -o 0.0.0.0
```

## create your own client

Use curl at first

```
curl -X POST http://localhost:9292/player/dave/speaks-to/jalen --data 'message=This%20is%20the%20song%20that%20never%20ends%3B%20and%20it%20goes%20on%20and%20on%20my%20friend%20%3A)'
curl -X POST http://localhost:9292/api/v1/player/dave/speaks-to/jalen --data 'message=I%20feel%20fine%3B%20I%20want%20to%20take%20a%20walk.'
curl -X POST http://localhost:9292/api/v1/player/dave/speaks-to/jalen --data 'message=Would%20you%20like%20to%20play%20global%20thermonuclear%20war%3F%0A'

curl -X GET http://localhost:9292/api/v1/player/dave/messages
curl -X GET http://localhost:9292/api/v1/player/jalen/messages

curl -X GET http://localhost:9292/api/v1/high_scores/
curl -X POST http://localhost:9292/api/v1/high_scores/add_point_for/dave -H 'Content-Length: 0'
curl -X POST http://localhost:9292/api/v1/high_scores/reset -H 'Content-Length: 0'
```
