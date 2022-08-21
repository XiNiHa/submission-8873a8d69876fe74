# submission-8873a8d69876fe74

## Setup

### Installation

```bash
yarn # Install dependencies
```

### Adding GitHub API token

Generate new token at [here](https://github.com/settings/tokens/new?scopes=repo,user), then update `config.cjs`.

```diff
module.exports = {
  // Add your GitHub API token here
-  GITHUB_API_TOKEN: "",
+  GITHUB_API_TOKEN: "ghp_yourtokenhere"
};
```

## Try it out

```bash
yarn relay --watch   # Terminal 1
yarn res:build -w    # Terminal 2
yarn dev             # Terminal 3
```
