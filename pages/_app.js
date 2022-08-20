import AppRes from "../src/App.cjs";
import "@unocss/reset/tailwind.css";
import "uno.css";
import "../styles/global.css";

function MyApp(props) {
  return <AppRes {...props} />;
}

export default MyApp;
