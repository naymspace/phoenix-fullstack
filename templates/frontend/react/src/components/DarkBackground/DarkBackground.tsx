import React, { useCallback } from 'react';
import { useSelector, useDispatch } from 'react-redux';

import { StoreState } from '../../store';
import { setIsMainMenuOpen, setIsFilterOpen } from '../../store/appState/menus';

import './DarkBackground.sass';

const DarkBackground = () => {
  const dispatch = useDispatch();

  const handleClick = useCallback(() => {
    dispatch(setIsMainMenuOpen({ isOpen: false }));
    dispatch(setIsFilterOpen({ isOpen: false }));
  }, [dispatch]);

  const isMainMenuOpen = useSelector((s: StoreState) => s.appState.menu.isMainMenuOpen);
  const isFilterOpen = useSelector((s: StoreState) => s.appState.menu.isFilterOpen);

  const isOpen = isMainMenuOpen || isFilterOpen;

  return (
    <>
      <div className={'menu-background menu-dark' + (isOpen ? ' is-visible' : '')} />
      <div className={'menu-background menu-click' + (isOpen ? ' is-clickable' : '')} onClick={handleClick} />
    </>
  );
};

export default DarkBackground;
