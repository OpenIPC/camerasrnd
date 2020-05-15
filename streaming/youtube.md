# YouTube streaming

## HLS + H.265

Follow up [Delivering Content via HLS](https://developers.google.com/youtube/v3/live/guides/hls-ingestion) for more information.

### Create new stream

- Navigate https://developers.google.com/youtube/v3/live/code_samples page

- Select Resource 'liveStreams' and Method 'insert'

- In table below click on 'insert' use case

- Fill on right side on the page:
  - in 'cdn' object change "frameRate" from "60fps" to "variable", "resolution" from "1080p" to "variable" and "ingestionType" from "rtmp" to "hls":

```
    "cdn": {
    "ingestionType": "hls",
    "frameRate": "variable",
    "resolution": "variable"
    }
```

- in Credentials section make sure you've selected 'Google OAuth 2.0' and 'https://www.googleapis.com/auth/youtube' scope (use 'Show scopes') and deselect 'API Key' option, then press 'Execute' button below

- Authorize yourself using your Youtube connected account

- Make sure that you got 200 response otherwise check errors and repeat

- Save "channelId" from the response (it looks like this "UCPJRjbxYlq6h2cCqy8RCRjg")

### Create new broadcast:

- Navigate https://developers.google.com/youtube/v3/live/code_samples page

- Select Resource 'liveBroadcast' and Method 'insert'

- In table below click on 'insert' use case

- Fill on right side on the page:

  - 'title' field for your broadcast like 'My Hometown Camera'

  - 'scheduledStartTime' like '2020-04-21T00:00:00.000Z' (ensure that this time in the future),

  - 'scheduledEndTime' like '2020-04-21T01:00:00.000Z' (scheduled end time should be after the scheduled start time)

  - also press blue plus button inside "snippet" block and add "channelId" with given from stream step value

  - in Credentials section make sure you've selected 'Google OAuth 2.0' and 'https://www.googleapis.com/auth/youtube' scope (use 'Show scopes') and deselect 'API Key' option, then press 'Execute' button below

- Authorize yourself using your Youtube connected account

- Make sure that you got 200 response otherwise check errors and repeat

### Bind the broadcast to the stream:

- Navigate https://developers.google.com/youtube/v3/live/code_samples page

- Select Resource 'liveBroadcast' and Method 'bind'

- In table below click on 'Bind a broadcast to a stream' use case

- Fill on right side on the page:

  - 'id' - ID of the broadcast (can be found in server response in step 'Create new broadcast', field 'id')

  - 'streamId' - ID of the stream (can be found in server response in step 'Create new stream', field 'id')

  - in Credentials section make sure you've selected 'Google OAuth 2.0' and 'https://www.googleapis.com/auth/youtube' scope (use 'Show scopes') and deselect 'API Key' option, then press 'Execute' button below

- Authorize yourself using your Youtube connected account

- Make sure that you got 200 response otherwise check errors and repeat

### Go live!

Navigate https://studio.youtube.com/

On right side click on 'CREATE' button and then 'Go live'

credits (c) Victor
