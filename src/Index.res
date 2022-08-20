module Query = %relay(`
  query IndexQuery {
    viewer {
      login
    }
  }
`)

@react.component
let make = () => {
  let data = Query.use(~variables=(), ())

  <div className="flex h-20 justify-center items-center text-2xl">
    <div className="i-bi-star" /> {React.string(data.viewer.login)}
  </div>
}
