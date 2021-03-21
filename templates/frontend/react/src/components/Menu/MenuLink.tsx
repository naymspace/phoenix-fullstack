import React from 'react';
import { Link } from 'react-router-dom';

type MenuLinkProps = {
  children: React.ReactNode;
  className: string;
  linkTo: string;
};

const MenuLink = ({ children, className, linkTo }: MenuLinkProps) => {
  return (
    <Link to={linkTo}>
      <div className={'menu-link' + (className ? ' ' + className : '')}>{children}</div>
    </Link>
  );
};

export default MenuLink;
