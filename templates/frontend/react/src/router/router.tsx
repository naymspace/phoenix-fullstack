import React, { useCallback } from 'react';
import { BrowserRouter as RouterComponent, Route, Switch } from 'react-router-dom';

import DarkBackground from '../components/DarkBackground/DarkBackground';
import Header from '../components/Header/Header';
import PageNotFound from '../pages/PageNotFound/PageNotFound';

import TopScroller from './TopScroller';
import routes from './routes';

const Router = () => {
  const notFound = useCallback(() => {
    return <PageNotFound />;
  }, []);

  return (
    <>
      <RouterComponent>
        <Header />
        <TopScroller />
        <Switch>
          {routes.map((r, i) => {
            const Component = r.component;
            const route = '/' + r.route + (r.acceptParam ? '/:param' : '');

            return (
              <Route key={i + route} exact path={route}>
                <div className="main-content">
                  <DarkBackground />
                  <Component />
                </div>
              </Route>
            );
          })}
          <Route path="/" render={notFound} />
        </Switch>
      </RouterComponent>
    </>
  );
};

export default Router;
