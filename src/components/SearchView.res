module Fragment = %relay(`
  fragment SearchView_query on Query
  @refetchable(queryName: "SearchViewRefetchQuery")
  @argumentDefinitions(
    query: { type: "String", defaultValue: "" },
    count: { type: "Int", defaultValue: 10 }
    cursor: { type: "String" },
    queryNotBlank: { type: "Boolean!" }
  ) {
    search(first: $count, after: $cursor, query: $query, type: REPOSITORY)
    @connection(key: "SearchView_search")
    @include(if: $queryNotBlank) {
      edges {
        node {
          ... on Repository {
            id
            ...RepoItem_repository
          }
        }
      }
    }
  }
`)

@react.component
let make = (~fragmentRef) => {
  let {data, hasNext, loadNext, isLoadingNext} = Fragment.usePagination(fragmentRef)
  let repos = data.search->Fragment.getConnectionNodes

  <>
    <dl className="flex flex-col gap-4 flex-1 items-stretch overflow-y-auto">
      {repos
      ->Belt.Array.map(repo =>
        switch repo {
        | #Repository(repo) => <RepoItem key={repo.id} fragmentRef={repo.fragmentRefs} />
        | _ => React.null
        }
      )
      ->React.array}
    </dl>
    {hasNext
      ? <button
          disabled={isLoadingNext}
          onClick={_ => loadNext(~count=10, ())->ignore}
          className="my-2 p-2 rounded bg-gray-300 hover:bg-gray-200 opacity-100 disabled-opacity-60 transition-colors transition-opacity duration-300">
          {React.string(isLoadingNext ? "Loading..." : "Load More")}
        </button>
      : React.null}
  </>
}
