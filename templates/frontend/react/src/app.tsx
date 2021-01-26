import React from 'react';
import ReactDOM from 'react-dom';
import { Provider } from 'react-redux';

import Router from './router/router';
import store from './store/store';
import './sass/globals.sass';

const App = () => {
  return (
    <Provider store={store}>
      <Router />
    </Provider>
  );
};

ReactDOM.render(<App />, document.getElementById('app-container'));
