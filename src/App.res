type pageProps

module PageComponent = {
  type t = React.component<pageProps>
}

type props = {
  @as("Component")
  component: PageComponent.t,
  pageProps: pageProps,
}

let default = (props: props): React.element => {
  let {component, pageProps} = props

  <RescriptRelay.Context.Provider environment=RelayEnv.environment>
    {React.createElement(component, pageProps)}
  </RescriptRelay.Context.Provider>
}
