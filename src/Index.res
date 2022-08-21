module Query = %relay(`
  query IndexQuery($query: String!, $queryNotBlank: Boolean!) {
    viewer { login }
    ...SearchView_query @arguments(query: $query, queryNotBlank: $queryNotBlank)
  }
`)

@react.component
let make = () => {
  let (query, setQuery) = React.useState(() => "")
  let (inputDisabled, setInputDisabled) = React.useState(() => true)
  let data = Query.use(
    ~variables=Query.makeVariables(~query, ~queryNotBlank=query->Js.String2.length > 0),
    (),
  )

  // For preventing refetch before hydration complete
  React.useEffect0(() => {
    setInputDisabled(_ => false)
    None
  })

  <div className="flex flex-col gap-4 h-full justify-center items-center">
    <div className="i-bi-github" />
    <span className="text-2xl"> {React.string(`Logged in as ${data.viewer.login}`)} </span>
    <input
      type_="text"
      disabled={inputDisabled}
      value={query}
      onChange={e => setQuery(_ => (e->ReactEvent.Synthetic.target)["value"])}
      className="rounded border border-gray-500 px-4 py-2 w-64"
    />
    <div
      className="flex-1 flex flex-col justify-center items-stretch self-stretch max-h-[50vh] mx-4 p-2 rounded border border-gray-300">
      <React.Suspense fallback={<div className="text-center"> {React.string("Loading...")} </div>}>
        <SearchView fragmentRef={data.fragmentRefs} />
      </React.Suspense>
    </div>
  </div>
}
