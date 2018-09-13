record Videos {
  videos : Array(String)
}

record Message {
  message : String
}

component Main {
  state file : Maybe(File) = Maybe.nothing()
  state videos : Videos = {videos = []}
  state error : String = ""
  state message : Message = {message = ""}

   get baseUrl : String {
    "http://180.37.194.116:3000"
   }

   fun componentDidMount : Promise(Never, Void) {
        getVideos
   }

   get getVideos : Promise(Never, Void) {
     sequence {
       response =
         baseUrl + "/api/all"
         |> Http.get()
         |> Http.send()

         json = Json.parse(response.body)
         |> Maybe.toResult("Json parsing error")

         items = decode json as Videos

         next { videos = items, message = {message = ""}}
     }  catch Http.ErrorResponse => er {
      next {error = "Could not get video information" }
    } catch String => er {
      next {error = "Could not parse json response" }
    } catch Object.Error => er {
      next { error = "could not decode json" }
    }
   }

   fun delVideo(video : String) : Promise(Never, Void) {
     sequence {
       response =
         baseUrl + "/api/del/" + video
         |> Http.get()
         |> Http.send()

         json = Json.parse(response.body)
         |> Maybe.toResult("Json parsing error")

         m = decode json as Message

         next { message = m}
         getVideos
     }  catch Http.ErrorResponse => er {
      next {error = "Could not delete video" }
    } catch String => er {
      next {error = "Could not parse json response" }
    } catch Object.Error => er {
      next { error = "could not decode json" }
    }
   }

  style pre {
    word-break: break-word;
    white-space: pre-wrap;
  }

  fun openDialog : Promise(Never, Void) {
    sequence {
      next
        {
          file = Maybe.nothing()
        }
      selectedFile =
        File.select("video/*")
      next
          {
            file = Maybe.just(selectedFile)
          }
    }
  }

  fun upload : Promise(Never, Void) {
    sequence {
      response =
        baseUrl + "/api/upload"
        |> Http.post()
        |> Http.formDataBody(formData)
        |> Http.send()

        next
          {
            file = Maybe.nothing(), message = {message = ""}, error = ""
          }

          getVideos
    } catch Http.ErrorResponse => er {
      sequence {
        Debug.log(er)
        Promise.never()
      }
    }
  } where {
    formData =
      try {
        Debug.log("about to resultFile")
        resultFile =
          Maybe.toResult("Got Nothing", file)

        FormData.empty()
        |> FormData.addFile("file", resultFile)
      } catch String => we {
        try {
         Debug.log("error in formData")
         FormData.empty()
        }
      }
  }

  fun renderVideo(video : String) : Html {
    <tr>
     <td><{ video }></td>
     <td><a href={url}><{url}></a></td>
     <td>
     <button onClick={(event : Html.Event) : Promise(Never, Void) => { delVideo(video) }}>
       <{ "Delete Video" }>
     </button>
     </td>
    </tr>
  } where {
    url = baseUrl + "/uploads/" + video
  }

  fun renderVideos : Html {
    if(Array.isEmpty(videos.videos)){
      <p><{"No videos uploaded"}></p>
    } else {
    <table>
    <thead>
      <th><{"File"}></th>
      <th><{"Url"}></th>
      <th></th>
    </thead>
    <tbody>
      <{ videos.videos |> Array.map(renderVideo)}>
    </tbody>
    </table>
  }
  }

  fun render : Html {
    <div>
     <p><{ error }></p>
     <p><{"note: do not upload videos with spaces or special characters in the filename! ideally something like this is perfect: somevideo.mp4"}></p>
      <button onClick={(event : Html.Event) : Promise(Never, Void) => { openDialog() }}>
        <{ "Select Video to Upload" }>
      </button>

      <button
        onClick={(event : Html.Event) : Promise(Never, Void) => { upload() }}
        disabled={Maybe.isNothing(file)}>

        <{ "Upload Video" }>

      </button>

      <{ fileHtml }>

    <{ renderVideos() }>

      /* <pre::pre>
        <{ contents }>
      </pre> */
    </div>
  } where {
    fileHtml =
      file
      |> Maybe.map(
        (file : File) : Html => {
          <div>
            <{ File.name(file) }>
          </div>
        })
      |> Maybe.withDefault(<div/>)
  }
}
