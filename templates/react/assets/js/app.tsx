// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import '../css/app.css';

import 'phoenix_html';
import React from 'react';
import ReactDOM from 'react-dom';
class PhoenixReact extends React.Component {
  render() {
    return (
      <>
        <section className="phx-hero">
          <h1>Welcome to Phoenix with React!</h1>
          <p>
            A productive web framework that
            <br />
            does not compromise speed or maintainability.
          </p>
        </section>

        <section className="row">
          <article className="column">
            <h2>Resources</h2>
            <ul>
              <li>
                <a href="https://hexdocs.pm/phoenix/overview.html">Guides &amp; Docs</a>
              </li>
              <li>
                <a href="https://github.com/phoenixframework/phoenix">Source</a>
              </li>
              <li>
                <a href="https://github.com/phoenixframework/phoenix/blob/v1.4/CHANGELOG.md">v1.4 Changelog</a>
              </li>
            </ul>
          </article>
          <article className="column">
            <h2>Help</h2>
            <ul>
              <li>
                <a href="https://elixirforum.com/c/phoenix-forum">Forum</a>
              </li>
              <li>
                <a href="https://webchat.freenode.net/?channels=elixir-lang">#elixir-lang on Freenode IRC</a>
              </li>
              <li>
                <a href="https://twitter.com/elixirphoenix">Twitter @elixirphoenix</a>
              </li>
            </ul>
          </article>
        </section>
      </>
    );
  }
}
ReactDOM.render(<PhoenixReact />, document.getElementById('react-container'));
