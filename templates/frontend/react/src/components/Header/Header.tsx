import React, { useState, useCallback } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { Link } from 'react-router-dom';

import { StoreState } from '../../store';
import { setIsMainMenuOpen } from '../../store/appState/menus';
import Menu from '../Menu/Menu';

import './Header.sass';

const Header = () => {
  const dispatch = useDispatch();

  const [searchTerm, setSearchTerm] = useState('');

  const isMenuOpen = useSelector((s: StoreState) => s.appState.menu.isMainMenuOpen);
  const toggleMenu = useCallback(() => {
    dispatch(setIsMainMenuOpen({ isOpen: !isMenuOpen }));
  }, [dispatch, isMenuOpen]);

  const onChange = useCallback((event: React.ChangeEvent<HTMLInputElement>) => {
    setSearchTerm(event.target.value);
  }, []);

  return (
    <div className="header">
      <Link className="header-home-link" to="/">
        <div className="header-home-link-inner">
          <div className="logo">
            <img src="" alt={'Home'} />
          </div>
        </div>
      </Link>

      <div className="menu-button" onClick={toggleMenu}>
        Menü
        {isMenuOpen ? (
          <img src="/images/menu_close_desktop.svg" alt={''} />
        ) : (
          <img src="/images/menu_icon_desktop.svg" alt={''} />
        )}
      </div>

      <Menu isOpen={isMenuOpen} onChange={onChange} searchTerm={searchTerm} />
    </div>
  );
};

export default Header;
