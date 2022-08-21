module Fragment = %relay(`
  fragment RepoItem_repository on Repository {
    id
    nameWithOwner
    url
    descriptionHTML
    viewerHasStarred
    visibility
    stargazers {
      totalCount
    }
  }
`)

module AddStarMutation = %relay(`
  mutation RepoItem_AddStarMutation($input: AddStarInput!) {
    addStar(input: $input) {
      starrable {
        id
        stargazers {
          totalCount
        }
        viewerHasStarred
      }
    }
  }
`)

module RemoveStarMutation = %relay(`
  mutation RepoItem_RemoveStarMutation($input: RemoveStarInput!) {
    removeStar(input: $input) {
      starrable {
        id
        stargazers {
          totalCount
        }
        viewerHasStarred
      }
    }
  }
`)

@react.component
let make = (~fragmentRef) => {
  let data = Fragment.use(fragmentRef)
  let (addStar, isAddingStar) = AddStarMutation.use()
  let (removeStar, isRemovingStar) = RemoveStarMutation.use()
  let isMutating = isAddingStar || isRemovingStar

  <div className="flex flex-col">
    <dt className="flex items-center">
      <a href={data.url} className="text-lg font-medium hover:underline"> {data.nameWithOwner->React.string} </a>
      {data.visibility === #PRIVATE ? <div className="mx-1 i-bi-lock-fill" /> : React.null}
    </dt>
    <dd>
      <p dangerouslySetInnerHTML={"__html": data.descriptionHTML} />
      <button
        className={`relative px-2 py-1 text-sm rounded bg-gray-300 hover:bg-gray-200 flex items-center gap-2 tabular-nums ${isMutating
            ? "opacity-70"
            : "opacity-100"} transition-opacity duration-300`}
        onClick={_ =>
          switch data.viewerHasStarred {
          | false =>
            addStar(
              ~variables=AddStarMutation.makeVariables(
                ~input=AddStarMutation.make_addStarInput(~starrableId=data.id, ()),
              ),
              ~optimisticResponse={
                addStar: Some({
                  starrable: Some({
                    __typename: "Repository",
                    id: data.id,
                    stargazers: {
                      totalCount: data.stargazers.totalCount + 1,
                    },
                    viewerHasStarred: true,
                  }),
                }),
              },
              (),
            )->ignore
          | true =>
            removeStar(
              ~variables=RemoveStarMutation.makeVariables(
                ~input=RemoveStarMutation.make_removeStarInput(~starrableId=data.id, ()),
              ),
              ~optimisticResponse={
                removeStar: Some({
                  starrable: Some({
                    __typename: "Repository",
                    id: data.id,
                    stargazers: {
                      totalCount: data.stargazers.totalCount - 1,
                    },
                    viewerHasStarred: false,
                  }),
                }),
              },
              (),
            )->ignore
          }}>
        <div
          className={`i-bi-star-fill ${data.viewerHasStarred
              ? "bg-black"
              : "bg-white"} transition-colors duration-300`}
        />
        {data.stargazers.totalCount->Belt.Int.toString->React.string}
      </button>
    </dd>
  </div>
}
