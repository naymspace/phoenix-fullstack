import ExampleDetail from '../pages/ExampleDetail/ExampleDetail';
import ExampleList from '../pages/ExampleList/ExampleList';

import Placeholder from './Placeholder';
import { Route } from './types';

const routes: Route[] = [
  { component: Placeholder, route: '' },
  {
    component: ExampleList,
    route: 'list',
  },
  {
    acceptParam: true,
    component: ExampleDetail,
    route: 'detail',
  },
];

export default routes;
