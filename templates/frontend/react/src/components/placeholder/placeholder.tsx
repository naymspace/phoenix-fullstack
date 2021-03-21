import React from 'react';
import { Link } from 'react-router-dom';

import routes from '../../router/routes';

import './placeholder.sass';

const Placeholder = () => (
  <>
    <section className="row">
      {routes.map((r, i) => {
        const title = r.route + (r.accessLevel ? ' (' + r.accessLevel + ')' : '') || 'Home';
        const link = '/' + r.route + (r.acceptParam ? '/5' : '');
        return (
          <React.Fragment key={i + link}>
            <Link to={link}>{title}</Link>
            <br />
            <br />
          </React.Fragment>
        );
      })}
    </section>
  </>
);

export default Placeholder;
