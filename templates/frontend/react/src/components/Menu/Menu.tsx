import React, { useEffect } from 'react';
import { useDispatch } from 'react-redux';
import { useHistory } from 'react-router-dom';

import { setIsMainMenuOpen } from '../../store/appState/menus';

import MenuLink from './MenuLink';

import './Menu.sass';

interface MenuProps {
  onChange: (event: React.ChangeEvent<HTMLInputElement>) => void;
  searchTerm: string;
  isOpen: boolean;
}

const Menu = ({ isOpen }: MenuProps) => {
  const dispatch = useDispatch();
  const history = useHistory();

  useEffect(() => {
    history.listen(() => {
      dispatch(setIsMainMenuOpen({ isOpen: false }));
    });
  }, [dispatch, history]);

  return (
    <div className={'menu-wrapper' + (isOpen ? ' is-open' : '')}>
      <div className="menu">
        <MenuLink linkTo={'/list'} className="menu-button">
          Liste
        </MenuLink>
        Plenty of room for more fancy links.
      </div>
    </div>
  );
};

export default Menu;
