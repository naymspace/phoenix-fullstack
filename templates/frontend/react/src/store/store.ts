import { applyMiddleware, createStore } from 'redux';
import { composeWithDevTools } from 'redux-devtools-extension';
import thunk from 'redux-thunk';

import rootReducer from './index';

const getStore = () => {
  const s = createStore(rootReducer, composeWithDevTools(applyMiddleware(thunk)));
  return s;
};

const store = getStore();

export default store;
