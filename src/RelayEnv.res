exception Graphql_error(string)

@module("../config.cjs") external githubApiToken: string = "GITHUB_API_TOKEN"

let fetchQuery: RescriptRelay.Network.fetchFunctionPromise = (
  operation,
  variables,
  _cacheConfig,
  _uploadables,
) => {
  open Webapi.Fetch
  fetchWithInit(
    "https://api.github.com/graphql",
    RequestInit.make(
      ~method_=Post,
      ~body=Js.Dict.fromList(list{
        ("query", Js.Json.string(operation.text)),
        ("variables", variables),
      })
      ->Js.Json.object_
      ->Js.Json.stringify
      ->BodyInit.make,
      ~headers=HeadersInit.make({
        "content-type": "application/json",
        "accept": "application/json",
        "authorization": "Bearer " ++ githubApiToken,
      }),
      (),
    ),
  )->Promise.then(resp =>
    if Response.ok(resp) {
      Response.json(resp)
    } else {
      Promise.reject(Graphql_error("Request failed: " ++ Response.statusText(resp)))
    }
  )
}

let network = RescriptRelay.Network.makePromiseBased(~fetchFunction=fetchQuery, ())

let environment = RescriptRelay.Environment.make(
  ~network,
  ~store=RescriptRelay.Store.make(
    ~source=RescriptRelay.RecordSource.make(),
    ~gcReleaseBufferSize=10,
    (),
  ),
  (),
)
