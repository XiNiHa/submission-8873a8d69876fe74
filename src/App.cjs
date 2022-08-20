// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var React = require("react");
var RelayEnv = require("./RelayEnv.cjs");
var RescriptRelay = require("rescript-relay/src/RescriptRelay.cjs");

var PageComponent = {};

function $$default(props) {
  return React.createElement(RescriptRelay.Context.Provider.make, {
              environment: RelayEnv.environment,
              children: React.createElement(props.Component, props.pageProps)
            });
}

exports.PageComponent = PageComponent;
exports.$$default = $$default;
exports.default = $$default;
exports.__esModule = true;
/* react Not a pure module */
